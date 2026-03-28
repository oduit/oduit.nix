{ inputs, ... }:
inputs.nixpkgs.lib.extend (
  _final: prev: {
    maintainers = prev.maintainers // {
      sbidoul = {
        github = "sbidoul";
        name = "sbidoul";
      };
    };
  }
)
