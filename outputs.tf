output "internal_alb_dns_name" {
  value = aws_lb.int-alb-tf.dns_name
}

output "public_alb_dns_name" {
  value = aws_lb.public.dns_name
}
