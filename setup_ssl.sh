#!/bin/bash

# SSL Setup Script for Production
# Purpose: Generate self-signed certificates or setup Let's Encrypt

echo "🔐 SSL CERTIFICATE SETUP"
echo "========================"

mkdir -p nginx/ssl

echo "Choose SSL setup method:"
echo "1) Self-signed certificate (for development/testing)"
echo "2) Let's Encrypt (for production with domain)"
read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "🔧 Generating self-signed certificate..."
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout nginx/ssl/key.pem \
            -out nginx/ssl/cert.pem \
            -subj "/C=US/ST=State/L=City/O=ArdhaRAG/CN=localhost"
        echo "✅ Self-signed certificate generated"
        echo "⚠️  Browser will show security warning - this is normal for self-signed certs"
        ;;
    2)
        read -p "Enter your domain name: " domain
        echo "🌐 Setting up Let's Encrypt for $domain..."
        echo "📋 Steps to complete manually:"
        echo "1. Point your domain to this server's IP"
        echo "2. Run: docker run --rm -p 80:80 -v nginx_certs:/etc/letsencrypt certbot/certbot certonly --standalone -d $domain"
        echo "3. Update nginx configuration with your domain"
        echo "4. Set up automatic renewal cron job"
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo "🎯 SSL setup complete!"
