import { googleAI } from "@genkit-ai/google-genai";
import { getStorage } from "firebase-admin/storage";
import { genkit, z } from "genkit";


const ai = genkit({
    plugins: [googleAI()]
})

const KioskInputSchema = z.object({
    imageUrl: z.string().url(),
    templateId: z.string(),
});

const KioskOutputSchema = z.object({
    success: z.boolean(),
    imageUrl: z.string(),
    caption: z.string(),
});


export const generateImageFlow = ai.defineFlow(
    {
        name: 'generateImage',
        inputSchema: KioskInputSchema,
        outputSchema: KioskOutputSchema,
    },
    async (input) => {
        // 1. analyse input.imageUrl and input.templateId to generate a new image
        const analysisResponse = await ai.generate({
            model: googleAI.model('gemini-2.5-flash'),
            prompt: [
                { text: 'Analyze this photograph carefully for reillustration. Concisely describe the gender, posture, pose, facial expression, hairstyle, and clothing of the individuals in the image. Do not describe the background.' },
                { media: { url: input.imageUrl, contentType: 'image/jpeg' } }
            ]
        });

        const personDescription = analysisResponse.text;
        console.log('Gemini Analysis Result:', personDescription);

        // 2. choose a template based on the input.templateId and the analysis result
        let stylePrompt = '';
        // let negativePrompt = 'deformed, bad anatomy, disfigured, poorly drawn face, mutated hands, extra limbs';

        switch (input.templateId) {
            case 'cyberpunk':
                stylePrompt = `A stunning cyberpunk digital art of ${personDescription}. Futuristic neon-lit city street at night, glowing pink and cyan neon lights, rainy weather, high-tech gadgets, cyberpunk aesthetic, highly detailed, octane render, 8k resolution.`;
                break;
            case 'fantasy':
                stylePrompt = `An epic high-fantasy oil painting of ${personDescription} as a mythical hero. Standing on a dramatic cliff, glowing magic elements, ancient mystical forest in the background, dramatic sky, cinematic lighting, artstation masterpiece.`;
                break;
            case 'anime':
                stylePrompt = `Beautiful anime-style digital illustration of ${personDescription}. Vibrant colors, clean lines, beautiful sky with fluffy clouds in the background, Ghibli or Makoto Shinkai aesthetic, cinematic, masterpiece.`;
                break;
            case 'steampunk':
                stylePrompt = `A stunning steampunk digital art of ${personDescription}. Intricate 19th-century industrial laboratory setting, rotating brass gears, copper steam pipes, ticking clocks, warm golden hour sunlight filtering through soot-stained windows, sepia tones, cinematic lighting, retro-futurism aesthetic, highly detailed, octane render, 8k resolution.`;
                break;
            case 'retrowave':
                stylePrompt = `A stunning retrowave synthwave digital art of ${personDescription}. 1980s neon grid landscape, giant glowing wireframe sunset sun on the horizon, glowing pink and purple neon wireframes, outrun aesthetic, vector grid floor, palm tree silhouettes, highly detailed, 8k resolution.`;
                break;
            case 'solarpunk':
                stylePrompt = `A stunning solarpunk digital art of ${personDescription}. Utopian eco-friendly city, bright clear blue sky, buildings integrated with lush vertical gardens, sleek futuristic solar panels and wind turbines, warm bright sunlight, hopeful environmental aesthetic, vibrant green and gold colors, highly detailed, 8k resolution`;
                break;
            case 'dieselpunk':
                stylePrompt = `A stunning dieselpunk digital art of ${personDescription}. Gritty mid-20th-century industrial cityscape, massive steel machinery, heavy soot and exhaust smoke, dark metallic tones, retro-military aesthetic, imposing Art Deco architecture, dramatic shadows, octane render, highly detailed, 8k resolution.`;
                break;
            case 'vaporwave':
                stylePrompt = `A stunning vaporwave digital art of ${personDescription}. Surreal 1990s desktop computer environment, floating Windows 95 icons, classical marble Greek statues, checkerboard floors, pastel pink and turquoise gradient background, glitch art textures, lo-fi aesthetic, nostalgic, 8k resolution.`;
                break;
            case 'kawaii-pop':
                stylePrompt = `A stunning kawaii pop vector illustration of ${personDescription}. Extremely cute and hyper-simplified anime style, oversized sparkling eyes, joyful expression, pastel rainbow background filled with smiling stars and clouds, bright cheerful colors, clean linework, flat shading, 8k resolution.`;
                break;
            case 'low-poly':
                stylePrompt = `A stunning low poly 3D digital art of ${personDescription}. Sharp geometric faceted polygons, minimalist structures, clean polygonal mesh surfaces, vibrant stylized color palette, sharp studio lighting, modern indie game aesthetic, octane render, 8k resolution.`;
                break;
            case 'flat-illustration':
                stylePrompt = `A stunning flat design vector illustration of ${personDescription}. Modern minimalist corporate art style, bold geometric shapes, clean vector lines, solid flat colors, zero gradients or shadows, aesthetic trendy graphic design, clean layout, 8k resolution.`;
                break;
            case 'impressionism ':
                stylePrompt = `A stunning impressionist oil painting of ${personDescription}. Thick visible brushstrokes, emphasis on the accurate depiction of light in its changing qualities, vibrant unblended colors, dappled sunlight filtering through trees, fluid movement, Claude Monet style, heavy canvas texture, 8k resolution.`;
                break;
            case 'baroque':
                stylePrompt = `A stunning baroque oil painting of ${personDescription}. Dramatic and intense atmosphere, extreme chiaroscuro contrast between deep shadows and brilliant highlights, theatrical lighting, rich golden tones, deep emotional depth, Rembrandt style canvas, 8k resolution.`;
                break;
            case 'watercolor':
                stylePrompt = `A stunning watercolor painting of ${personDescription}. Soft bleeding paint edges, translucent layers of wet-on-wet pigments, delicate paint splatters, visible natural grain of cold press paper texture, elegant color wash, organic fluid art style, 8k resolution.`;
                break;
            default:
                stylePrompt = `A highly detailed professional photo of ${personDescription} stylized in: ${input.templateId} theme, cinematic lighting, photorealistic.`;
        }

        // 3. generate the new image using the chosen style prompt
        const imageGenResponse = await ai.generate({
            model: googleAI.model('gemini-3.1-flash-lite-image'),
            prompt: stylePrompt,
            config: {
                imageConfig: {
                    aspectRatio: '1:1',
                },
                responseModalities: ['IMAGE', 'TEXT'],
            },
        });

        // 4. upload the generated image to a storage service and get the URL imageGenResponse.media (Data URL / Base64)
        const generatedMedia = imageGenResponse.media;

        if (!generatedMedia || typeof generatedMedia.url !== 'string') {
            throw new Error('AI failed to generate image');
        }

        // split Base64 String from Data URL
        const base64Data = generatedMedia.url.split(',')[1];
        const buffer = Buffer.from(base64Data, 'base64');

        // define bucket and filename for the generated image
        const bucket = getStorage().bucket();
        const filename = `processed_images/${Date.now()}_stylized.png`;
        const file = bucket.file(filename);

        // save the generated image to the storage bucket
        await file.save(buffer, {
            metadata: {
                contentType: 'image/png',
            },
        });

        // make public file
        await file.makePublic();
        
        // publicUrl = `https://storage.googleapis.com/${bucket.name}/${filename}`;
        const publicUrl = file.publicUrl();

        // 5. generate a funny caption for the generated image using the AI model
        const captionResponse = await ai.generate({
            model: googleAI.model('gemini-2.5-flash'),
            prompt: `Write **a short**, cute and funny one-sentence caption in Thai for the person in the image who has just been styled to ${input.templateId}. Do not include quotation marks.`
        });
        const funnyCaption = captionResponse.text || 'ว้าว! รูปคุณเท่สุดๆ ไปเลย';

        // send result back
        return {
            success: true,
            imageUrl: publicUrl,
            caption: funnyCaption.trim(),
        };
    },
);