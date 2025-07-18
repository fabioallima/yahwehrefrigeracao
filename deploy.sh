#!/bin/bash

# Script de Deploy para AWS S3
# Yahweh Refrigeração

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
BUCKET_NAME="yahwehrefrigeracao.com.br"
REGION="us-east-1"
PROFILE="default"

echo -e "${BLUE}🚀 Iniciando deploy do site Yahweh Refrigeração${NC}"

# Verificar se AWS CLI está instalado
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI não está instalado. Instale em: https://aws.amazon.com/cli/${NC}"
    exit 1
fi

# Verificar se o bucket existe
echo -e "${YELLOW}📦 Verificando bucket S3...${NC}"
if ! aws s3 ls "s3://$BUCKET_NAME" --profile $PROFILE &> /dev/null; then
    echo -e "${RED}❌ Bucket $BUCKET_NAME não existe. Crie primeiro no console AWS.${NC}"
    exit 1
fi

# Verificar arquivos necessários
echo -e "${YELLOW}📁 Verificando arquivos...${NC}"
REQUIRED_FILES=(
    "index.html"
    "css/style.css"
    "js/script.js"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Arquivo $file não encontrado${NC}"
        exit 1
    fi
done

echo -e "${GREEN}✅ Todos os arquivos principais encontrados${NC}"

# Backup do bucket atual (opcional)
echo -e "${YELLOW}💾 Criando backup do bucket atual...${NC}"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
aws s3 sync "s3://$BUCKET_NAME" "s3://$BUCKET_NAME-backup-$BACKUP_DATE" --profile $PROFILE --quiet

# Upload dos arquivos
echo -e "${YELLOW}📤 Fazendo upload dos arquivos...${NC}"

# Upload HTML
echo -e "${BLUE}   📄 Uploading HTML...${NC}"
aws s3 cp index.html "s3://$BUCKET_NAME/" --profile $PROFILE --cache-control "max-age=3600"

# Upload CSS
echo -e "${BLUE}   🎨 Uploading CSS...${NC}"
aws s3 cp css/style.css "s3://$BUCKET_NAME/css/" --profile $PROFILE --cache-control "max-age=31536000"

# Upload JavaScript
echo -e "${BLUE}   ⚡ Uploading JavaScript...${NC}"
aws s3 cp js/script.js "s3://$BUCKET_NAME/js/" --profile $PROFILE --cache-control "max-age=31536000"

# Upload assets (se existirem)
if [ -d "assets" ]; then
    echo -e "${BLUE}   🖼️  Uploading assets...${NC}"
    aws s3 sync assets/ "s3://$BUCKET_NAME/assets/" --profile $PROFILE --cache-control "max-age=2592000"
fi

# Configurar website hosting
echo -e "${YELLOW}🌐 Configurando website hosting...${NC}"
aws s3 website "s3://$BUCKET_NAME" --index-document index.html --error-document index.html --profile $PROFILE

# Configurar política de bucket (se não existir)
echo -e "${YELLOW}🔒 Configurando política de bucket...${NC}"
POLICY='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::'$BUCKET_NAME'/*"
        }
    ]
}'

aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy "$POLICY" --profile $PROFILE

# Invalidar cache do CloudFront (se configurado)
if command -v aws cloudfront &> /dev/null; then
    echo -e "${YELLOW}🔄 Verificando CloudFront...${NC}"
    DISTRIBUTION_ID=$(aws cloudfront list-distributions --profile $PROFILE --query "DistributionList.Items[?Aliases.Items[?contains(@, '$BUCKET_NAME')]].Id" --output text)
    
    if [ ! -z "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
        echo -e "${BLUE}   🚀 Invalidando cache do CloudFront...${NC}"
        aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*" --profile $PROFILE
    fi
fi

# Verificar se o deploy foi bem-sucedido
echo -e "${YELLOW}✅ Verificando deploy...${NC}"
if aws s3 ls "s3://$BUCKET_NAME/index.html" --profile $PROFILE &> /dev/null; then
    echo -e "${GREEN}🎉 Deploy concluído com sucesso!${NC}"
    echo -e "${BLUE}🌐 URL do site: http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com${NC}"
else
    echo -e "${RED}❌ Erro no deploy. Verifique os logs acima.${NC}"
    exit 1
fi

# Estatísticas do deploy
echo -e "${YELLOW}📊 Estatísticas do deploy:${NC}"
echo -e "${BLUE}   📁 Total de arquivos:${NC}"
aws s3 ls "s3://$BUCKET_NAME" --recursive --profile $PROFILE | wc -l

echo -e "${BLUE}   💾 Tamanho total:${NC}"
aws s3 ls "s3://$BUCKET_NAME" --recursive --profile $PROFILE --human-readable --summarize | grep "Total Size"

echo -e "${GREEN}✨ Deploy finalizado! O site está no ar.${NC}"
echo -e "${YELLOW}💡 Dica: Configure um domínio personalizado no Route 53 para uma URL mais profissional.${NC}" 