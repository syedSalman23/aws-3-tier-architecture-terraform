resource "aws_db_subnet_group" "db-sub-group" {

  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.db-sub[0].id,
    aws_subnet.db-sub[1].id
  ]

  tags = {
    Name = "db-subnet-group"
  }
}


resource "aws_db_instance" "rds-db" {

  identifier = "rds-db"

  allocated_storage = 10

  db_name = "mydb"

  engine = "mysql"

  engine_version = "8.0"

  instance_class = "db.t3.micro"

  username = "root"

  password = "root@123"

  db_subnet_group_name = aws_db_subnet_group.db-sub-group.name

  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  skip_final_snapshot = true

  tags = {
    Name = "rds-db"
  }
}