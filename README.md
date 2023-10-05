Getting Started
---------------

### Introduction
This is a demo project for education/training purposes of streaming.

It automates (using **Terraform**) the provisioning of the following infrastructure for live streaming in Akamai 
Connected Cloud (former Linode) using the [**SRT**](https://www.haivision.com/products/srt-secure-reliable-transport/) 
protocol designed by Hayvision:
- **Linodes** (Compute instances): Where the live streaming server will be running.
- **Firewall**: Protects the live streaming traffic.

Please check the files `linode.tf`, `linode-instances.tf`, `linode-firewall.tf`, `linode-ssh-keys.tf` for more details.

### Requirements

To build the mentioned workflow, you will need to install the following software:

- [**Docker**](https://www.docker.com): Container platform to run the SRT server.
- [**Terraform 1.5.x**](https://www.terraform.io): Very famous IaC tool, used for the provisioning of the resources.

### Documentation

Follow the documentation below to know more about Akamai:

- [**How to create Akamai Connected Cloud credentials**](https://www.linode.com/docs/api)
- [**List of Akamai Connected Cloud Regions**](https://www.linode.com/docs/api/regions/)
- [**List of Akamai Connected Cloud Types**](https://www.linode.com/docs/api/linode-types/)
- [**List of Akamai Connected Cloud Images**](https://www.linode.com/docs/api/images/)
- [**Linode documentation**](https://www.linode.com/docs/)

### Important notes
- **If any phase got errors or violations, the pipeline will stop.**
- **DON'T EXPOSE OR COMMIT ANY SENSITIVE DATA, SUCH AS CREDENTIALS, IN THE PROJECT.**

### Contact
**LinkedIn:**
- https://www.linkedin.com/in/fvilarinho

**e-Mail:**
- fvilarin@akamai.com
- fvilarinho@gmail.com
- fvilarinho@outlook.com
- me@vila.net.br
