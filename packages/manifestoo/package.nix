{
  lib,
  flake,
  manifestoo,
}:
manifestoo.overrideAttrs (old: {
  passthru = (old.passthru or { }) // {
    category = "Utilities";
  };

  meta = (old.meta or { }) // {
    changelog = "https://github.com/acsone/manifestoo/releases/tag/v${old.version}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with flake.lib.maintainers; [ sbidoul ];
    mainProgram = "manifestoo";
  };
})
