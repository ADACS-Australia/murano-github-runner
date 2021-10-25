# GitHub self-hosted runner Murano package

This repo contains a Murano (OpenStack) package for the Nectar research cloud. It allows you to set up a GitHub self-hosted runner easily from the dashboard. You can find the most relevant steps of the installation in `deploy.sh`. Currently, it only supports Ubuntu 20.04 LTS.

Docker is available in the runner, and so container based GitHub workflows are supported.

## Build
You can build the package with the makefile
```
make build
```
This will create a `.zip` file that you can [manually upload](#manual-upload) to your Nectar project in the dashboard.

Alternatively, if you have user/application credentials loaded in your environment and have the Murano CLI installed, you can build + upload with
```
make upload
```

## Manual upload
Each release contains a `zip` file that can be uploaded to your Nectar/OpenStack account. You can upload directly using the URL.

Go to the releases for this repo. Select the latest release. Under assests, right click on `github-runner.zip` and then copy the link address.

On you Nectar/OpenStack account, navigate to `Applications > Manage > Packages`. Then press `+ Import Package` and choose URL as the Package Source. Use the link address you copied from the release page.
