## Available Tools

<!-- BEGIN GENERATED PACKAGE DOCS -->

### Packaging

<details>
<summary><strong>dob</strong> - Project scaffold for bootstrapping Odoo instances with Docker Compose</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/initOS/dob
- **Usage**: `nix run github:oduit/oduit.nix#dob -- --help`
- **Nix**: [packages/dob/package.nix](packages/dob/package.nix)

</details>
<details>
<summary><strong>whool</strong> - Build backend and CLI for Odoo addons</summary>

- **Source**: source
- **License**: MIT
- **Homepage**: https://github.com/sbidoul/whool
- **Usage**: `nix run github:oduit/oduit.nix#whool -- --help`
- **Nix**: [packages/whool/package.nix](packages/whool/package.nix)

</details>

### Utilities

<details>
<summary><strong>click-odoo</strong> - Beautiful, robust CLI for Odoo</summary>

- **Source**: source
- **License**: LGPL-3.0-or-later
- **Homepage**: https://github.com/acsone/click-odoo
- **Usage**: `nix run github:oduit/oduit.nix#click-odoo -- --help`
- **Nix**: [packages/click-odoo/package.nix](packages/click-odoo/package.nix)

</details>
<details>
<summary><strong>doblib</strong> - Management tool for Odoo installations</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/initOS/dob-lib
- **Usage**: `nix run github:oduit/oduit.nix#doblib -- --help`
- **Nix**: [packages/doblib/package.nix](packages/doblib/package.nix)

</details>
<details>
<summary><strong>manifestoo</strong> - Tool to reason about Odoo addons manifests</summary>

- **Source**: source
- **License**: MIT
- **Homepage**: https://github.com/acsone/manifestoo
- **Usage**: `nix run github:oduit/oduit.nix#manifestoo -- --help`
- **Nix**: [packages/manifestoo/package.nix](packages/manifestoo/package.nix)

</details>
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
<details>
<summary><strong>oduit</strong> - CLI and library for running, updating, installing, and testing Odoo modules</summary>

- **Source**: source
- **License**: MPL-2.0
- **Homepage**: https://github.com/oduit/oduit
- **Usage**: `nix run github:oduit/oduit.nix#oduit -- --help`
- **Nix**: [packages/oduit/package.nix](packages/oduit/package.nix)

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


## Update Packages

### odoo-ls

`odoo-ls` uses a checked-in `Cargo.lock` plus a separately fetched release asset, so the update is manual.

```bash
# 1) Prefetch the upstream source with submodules
nix run nixpkgs#nix-prefetch-github -- odoo odoo-ls --rev 1.2.1 --fetch-submodules

# 2) Prefetch the release config schema
nix store prefetch-file https://github.com/odoo/odoo-ls/releases/download/1.2.1/config_schema.json

# 3) Regenerate the Rust lockfile from the release tag
tmp="$(mktemp -d)"
git clone --depth 1 --branch 1.2.1 https://github.com/odoo/odoo-ls "$tmp"
cargo generate-lockfile --manifest-path "$tmp/server/Cargo.toml"
cp "$tmp/server/Cargo.lock" packages/odoo-ls/Cargo.lock
rm -rf "$tmp"

# 4) Update version and hashes in packages/odoo-ls/package.nix

# 5) Build and copy any new cargoLock.outputHashes printed by Nix
nix build --accept-flake-config 'path:.#odoo-ls'
```

Update these fields in `packages/odoo-ls/package.nix`:

- `version`
- `src.hash`
- `configSchema.hash`
- `cargoLock.outputHashes` if the build reports new values

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
