#! /bin/bash
echo 'creating backup for /home/ec2-user/script'
tar -czf /home/ec2-user/backup/my-backup.tgz /home/ec2-user/script
echo 'backup created /home/ec2-user/backup/my-backup.tgz'

