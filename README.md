# myproj

init package 

mkdir -p ./linux_inspection/ssh

ssh-keygen -t ed25519 \
-f ./linux_inspection/ssh/linux_inspection \
-C "linux-inspection"

chmod 700 ./linux_inspection/ssh

chmod 600 ./linux_inspection/ssh/linux_inspection

chmod 644 ./linux_inspection/ssh/linux_inspection.pub
