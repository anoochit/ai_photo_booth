# Image Generate function with GenKit backend

## Test onCallGenkit with `curl`

```bash
curl -X POST -H "Content-Type: application/json"  http://127.0.0.1:5001/photobooth-3333a/us-central1/generateImage  -d '{"data":  { "imageUrl": "https://www.anthropics.com/portraitpro/img/page-images/homepage/v22/what-can-it-do-2B.jpg", "templateId": "cyberpunk"} }'
```

```json
{"result":{"success":true,"imageUrl":"http://127.0.0.1:9199/photobooth-3333a.firebasestorage.app/processed_images%2F1783221828739_stylized.png","caption":"นี่คนหรือ AI คะเนี่ย น่ารักเกินต้านทาน!"}}
```