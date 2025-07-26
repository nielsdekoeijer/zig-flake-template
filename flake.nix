{
  description = "A collection of flake templates";
  outputs = { self }: {
    templates.default = {
      path = ./zig;
      description = "A template for a zig project";
    };
  };
}
