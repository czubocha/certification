npm i
ng build --prod
cd dist/certification
aws s3 sync . s3://certification-frontend-vniwjbvwie --delete
