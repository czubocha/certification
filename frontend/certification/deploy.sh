npm i
ng build --prod
cd dist/certification
aws s3 sync . s3://certification-cicd-frontend-1lkm3p-frontendbucket-awxvaicy1bgy --delete
