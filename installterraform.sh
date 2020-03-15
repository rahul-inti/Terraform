#! /bin/bash
readonly TERRAFORM_VERSION="0.9.6"
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
     brew install curl
  fi
   if [ -e "$unzip_cmd" ]; then
     echo "Hey Uzip already there"
   else
     echo "i am on the way to install uzip"
     sudo apt-get   install curl
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
    curl -o "$DOWNLOADED_FILE" "$DOWNLOAD_URL"

   echo ""
   echo "Extracting Terraform executable"
   sudo unzip "$DOWNLOADED_FILE" -d "$INSTALL_DIR"

  rm "$DOWNLOADED_FILE"

  fi
}

install_terraform
