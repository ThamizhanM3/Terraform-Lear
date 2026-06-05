output "frontend_alb_dns" {
    value = aws_lb.frontend_alb.dns_name
}

output "bastion_public_ip" { 
    value = aws_instance.bastionhost_instance.public_ip 
}

output "cloudfront_domain" { 
    value = aws_cloudfront_distribution.songs_cdn.domain_name 
}

output "database_private_ip" { 
    value = aws_instance.database_instance.private_ip 
}