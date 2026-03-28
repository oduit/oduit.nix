## Available Tools

<!-- BEGIN GENERATED PACKAGE DOCS -->

### Utilities

<details>
<summary><strong>odoo-ls</strong> - Odoo language server built from source</summary>

- **Source**: source
- **License**: LGPL-3.0-only
- **Homepage**: https://github.com/odoo/odoo-ls
- **Usage**: `nix run github:oduit/oduit.nix#odoo-ls -- --help`
- **Nix**: [packages/odoo-ls/package.nix](packages/odoo-ls/package.nix)

</details>
<details>
<summary><strong>odoo-lsp</strong> - Language server for Odoo Python, JavaScript, and XML</summary>

- **Source**: source
- **License**: MIT
- **Homepage**: https://github.com/Desdaemon/odoo-lsp
- **Usage**: `nix run github:oduit/oduit.nix#odoo-lsp -- --help`
- **Nix**: [packages/odoo-lsp/package.nix](packages/odoo-lsp/package.nix)

</details>
<!-- END GENERATED PACKAGE DOCS -->

## Installation

### Using Nix Flakes (Recommended)

Add to your system configuration:

```nix
{
  inputs = {
    oduit.url = "github:oduit/oduit.nix";
  };

  # In your system packages:
  environment.systemPackages = with inputs.oduit.packages.${pkgs.stdenv.hostPlatform.system}; [
    odoo-ls
    # ... other tools
  ];
}
```

### Using Overlay

Alternatively, use the overlay to access packages under the `oduit` namespace:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    oduit.url = "github:oduit/oduit.nix";
  };

  outputs = { nixpkgs, oduit, ... }: {
    # NixOS / nix-darwin configuration
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        nixpkgs.overlays = [ oduit.overlays.default ];
        environment.systemPackages = [
          pkgs.oduit.odoo-ls
        ];
      }];
    };
  };
}
```

### Try Without Installing

Browse all available tools with the interactive launcher:

```bash
nix run github:oduit/oduit.nix
```

This opens an fzf picker listing every package with its description.
Select one and it will be run via `nix run`.

Or run a specific tool directly:

```bash
nix run github:oduit/oduit.nix#odoo-ls
# etc...
```


## Development

### Setup Development Environment

```bash
nix develop
```

### Building Packages

```bash
# Build a specific package
nix build .#odoo-ls
# etc...
```

### Code Quality

```bash
# Format all code
nix fmt

# Run checks
nix flake check
```

## Package Details

### Platform Support

All packages support:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`


## Contributing

Contributions are welcome! Please:

1. Fork the repository
1. Create a feature branch
1. Run `nix fmt` before committing
1. Submit a pull request

## See also

- [natsukium/mcp-servers-nix](https://github.com/natsukium/mcp-servers-nix) - Nix packages for MCP (Model Context Protocol) servers
- [aaddrick/claude-desktop-debian](https://github.com/aaddrick/claude-desktop-debian?tab=readme-ov-file#using-nix-flake-nixos) - Claude Desktop for Linux
- [nothingnesses/agent-images](https://github.com/nothingnesses/agent-images) - Sandboxed OCI container images for AI coding agents
- [numtide/llm-agents.nix](https://github.com/numtide/llm-agents.nix)
  Inspiration for this nix repo

## License

Individual tools are licensed under their respective licenses.

The Nix packaging code in this repository is licensed under MIT.
