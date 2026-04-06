{ ... }:
{
  services.paperless = {
    enable = true;
    port = 28981;
    settings = {
      PAPERLESS_OCR_LANGUAGE = "rus+eng";
      PAPERLESS_URL = "https://paper.daz9e.space";
    };
  };
}
