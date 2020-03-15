#! /bin/bash
readonly TERRAFORM_VERSION="0.12.23"
readonly INSTALL_DIR="/usr/local/bin"
readonly INSTALL_DIR_TERRAFORM="/usr/local/bin/terraform"
readonly DOWNLOAD_DIR="/tmp"
readonly DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
readonly DOWNLOADED_FILE="$DOWNLOAD_DIR/terraform.zip"

prerequisites() {
  local curl_cmd=`which curl`
  local unzip_cmd=`which unzip`

#  echo "$curl_cmd"

   if [ -e "$curl_cmd" ]; then
     echo "Hey Curl already there"
   else
     echo "i am on the way to install curl"
    apt-het -y install curl
  fi
   if [ -e "$unzip_cmd" ]; then
     echo "Hey Uzip already there"
   else
     echo "i am on the way to install uzip"
     sudo apt-get update -y
     sudo apt-get install unzip -y
  fi

}
prerequisites

install_terraform() {

  if [ -e "$INSTALL_DIR_TERRAFORM" ]; then

   echo "Terraform already installed +++++"

else
   echo "Going to install"
   echo ""
   echo "Downloading Terraform zip'd binary"
    cd /tmp
    curl -o  https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip

   echo ""
   echo "Extracting Terraform executable"
   unzip terraform_0.12.23_linux_amd64.zip
   mv terraform_0.12.23_linux_amd64 terraform
   mv terraform /usr/local/bin
  
  rm "$DOWNLOADED_FILE"

  fi
}

install_terraform
