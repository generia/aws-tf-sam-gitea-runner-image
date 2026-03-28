# aws-tf-sam-gitea-runner-image

Public Gitea runner image with AWS CLI, Terraform, AWS SAM CLI, and a pre-configured Terraform provider cache.

## Usage

```yaml
container:
  image: ghcr.io/generia/aws-tf-sam-gitea-runner-image:latest
```

## Publish

Tag the repo with `vX.Y.Z` to publish via GitHub Actions. After first push, set the package visibility to **Public** in GitHub Packages settings.

e.g.

```bash

 create an annotated tag
git tag v1.0.0

# push the tag to GitHub
git push origin v1.0.0
```
