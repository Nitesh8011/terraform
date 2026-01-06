# HashiCorp Configuration Language (HCL) — Features

HashiCorp Configuration Language (HCL) is a concise, declarative language used by HashiCorp tools such as Terraform, Packer, Vault, and Consul to define infrastructure and configuration in a human-readable format.

## Key features

1. Declarative syntax  
   Describe the desired state, not the steps to achieve it. Tools like Terraform determine execution order and diffs automatically.

2. Blocks and arguments  
   Configuration is organized with blocks such as `resource`, `provider`, `variable`, and `output`, each containing arguments and nested blocks.

3. Variables and outputs  
   Supports input variables for reuse and parameterization, and outputs to expose values after runs.

4. Expressions and functions  
   Provides expressions and built-in functions (for example `length()`, `lookup()`, `join()`) for dynamic values.

5. Conditionals  
   Supports conditional logic using ternary expressions to control resource attributes.

6. Loops and dynamic blocks  
   Use `count`, `for_each`, and `dynamic` blocks to create multiple resources or repeated configuration programmatically.

7. State management  
   Tracks infrastructure state to detect changes, prevent drift, and enable safe updates and planning.

8. Provider ecosystem  
   Works with hundreds of providers (AWS, Azure, GCP, Kubernetes, and more), enabling broad platform support.

9. Human-readable syntax  
   HCL is easier to read, write, and review than raw JSON or verbose formats, while still being machine-friendly.

## Summary

HCL combines simplicity, flexibility, and power, making it well suited for Infrastructure as Code (IaC) workflows.