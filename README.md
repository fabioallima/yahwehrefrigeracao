# Yahweh Refrigeração - Site Profissional

Site profissional para a empresa Yahweh Refrigeração, especializada em conserto de geladeiras, máquinas de lavar e ar condicionado.

## 📁 Estrutura do Projeto

```
yahwehrefrigeracao/
├── index.html              # Página principal
├── css/
│   └── style.css           # Estilos CSS
├── js/
│   └── script.js           # JavaScript
├── assets/                 # Pasta para imagens
│   ├── logo-yahweh-refrigeracao.png
│   ├── logo-branca-yahweh-refrigeracao.png
│   ├── hero-image.jpg
│   ├── servico-geladeira.jpg
│   ├── servico-ar-condicionado.jpg
│   ├── servico-maquina-lavar.jpg
│   ├── atendimento-domiciliar.jpg
│   ├── sobre-nos.jpg
│   ├── cliente-1.jpg
│   ├── cliente-2.jpg
│   ├── cliente-3.jpg
│   ├── cliente-4.jpg
│   ├── cliente-5.jpg
│   └── favicon.ico
└── README.md
```

## 🚀 Como Hospedar no S3 da AWS (Gratuitamente)

### Pré-requisitos
- Conta na AWS
- AWS CLI instalado (opcional, mas recomendado)

### Passo a Passo

#### 1. Criar um Bucket S3
1. Acesse o [Console da AWS](https://console.aws.amazon.com/)
2. Vá para o serviço S3
3. Clique em "Create bucket"
4. Configure:
   - **Bucket name**: `yahwehrefrigeracao.com.br` (ou outro nome único)
   - **Region**: `us-east-1` (para melhor performance)
   - **Block Public Access**: Desmarque todas as opções
   - **Bucket Versioning**: Desabilitado
   - **Tags**: Opcional
5. Clique em "Create bucket"

#### 2. Configurar o Bucket para Hospedagem Estática
1. Selecione o bucket criado
2. Vá para a aba "Properties"
3. Role até "Static website hosting"
4. Clique em "Edit"
5. Configure:
   - **Static website hosting**: Enable
   - **Hosting type**: Host a static website
   - **Index document**: `index.html`
   - **Error document**: `index.html` (para SPA)
6. Clique em "Save changes"
7. Anote a URL do website (será algo como: `http://yahwehrefrigeracao.com.br.s3-website-us-east-1.amazonaws.com`)

#### 3. Configurar Política de Bucket
1. Vá para a aba "Permissions"
2. Clique em "Bucket policy"
3. Cole a seguinte política:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::SEU-BUCKET-NAME/*"
        }
    ]
}
```

**Substitua `SEU-BUCKET-NAME` pelo nome do seu bucket.**

#### 4. Fazer Upload dos Arquivos
1. Vá para a aba "Objects"
2. Clique em "Upload"
3. Arraste todos os arquivos do projeto ou clique em "Add files"
4. Selecione todos os arquivos:
   - `index.html`
   - Pasta `css/` com `style.css`
   - Pasta `js/` com `script.js`
   - Pasta `assets/` com todas as imagens
5. Clique em "Upload"

#### 5. Configurar Domínio Personalizado (Opcional)
Para usar um domínio personalizado:

1. **Registrar domínio no Route 53** (ou usar domínio existente)
2. **Criar certificado SSL** no AWS Certificate Manager
3. **Configurar CloudFront** para CDN e HTTPS
4. **Configurar Route 53** para apontar para o CloudFront

### 📊 Custos Estimados (Tier Gratuito)

Com o **AWS Free Tier**, você tem:
- **S3**: 5GB de armazenamento por 12 meses
- **CloudFront**: 1TB de transferência por 12 meses
- **Route 53**: 1 zona hospedada por 12 meses

**Após 12 meses**, custos aproximados:
- S3: ~$0.023/GB/mês
- CloudFront: ~$0.085/GB
- Route 53: ~$0.50/mês por zona hospedada

### 🔧 Configurações Adicionais

#### Otimização de Performance
1. **Comprimir arquivos CSS e JS** antes do upload
2. **Otimizar imagens** (WebP, compressão)
3. **Configurar cache headers** no CloudFront

#### SEO e Analytics
1. **Google Analytics**: Adicionar código de rastreamento
2. **Google Search Console**: Verificar propriedade
3. **Sitemap**: Criar sitemap.xml
4. **Meta tags**: Já configuradas no HTML

#### Segurança
1. **HTTPS**: Configurar certificado SSL
2. **Headers de segurança**: Configurar no CloudFront
3. **Backup**: Configurar versionamento do S3

### 📱 Funcionalidades do Site

- ✅ Design responsivo
- ✅ Menu mobile
- ✅ Scroll suave
- ✅ FAQ interativo
- ✅ Botão WhatsApp flutuante
- ✅ Animações no scroll
- ✅ SEO otimizado
- ✅ Performance otimizada
- ✅ Acessibilidade

### 🛠️ Tecnologias Utilizadas

- **HTML5**: Estrutura semântica
- **CSS3**: Estilos modernos com CSS Grid e Flexbox
- **JavaScript**: Funcionalidades interativas
- **Font Awesome**: Ícones
- **Google Fonts**: Tipografia

### 📞 Contato

Para suporte técnico ou dúvidas sobre o site:
- **WhatsApp**: (21) 98461-9958
- **Email**: contato@yahwehrefrigeracao.com.br

### 🔄 Atualizações

Para atualizar o site:
1. Faça as alterações nos arquivos locais
2. Faça upload dos arquivos atualizados para o S3
3. Se usar CloudFront, invalide o cache

### 📈 Monitoramento

Configure alertas no CloudWatch para:
- Erros 4xx/5xx
- Latência alta
- Uso de banda
- Custos

---

**Nota**: Este site está otimizado para hospedagem no S3 e segue as melhores práticas de desenvolvimento web moderno. 