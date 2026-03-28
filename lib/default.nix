{ inputs, ... }:
inputs.nixpkgs.lib.extend (
  _final: prev: {
    maintainers = prev.maintainers // {
      Bad3r = {
        github = "Bad3r";
        githubId = 25513724;
        name = "Bad3r";
      };
    };
  }
)
