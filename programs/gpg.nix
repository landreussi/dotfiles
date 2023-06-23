{ pkgs, ... }: {
  enable = true;
  settings = rec {
    default-key = "EB65A9EFCEA9940245F5AAF9515E426DDD3A9FBA";
    personal-cipher-preferences = "AES256 AES192 AES";
    personal-digest-preferences = "SHA512 SHA384 SHA256";
    personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
    cert-digest-algo = "SHA512";
    s2k-digest-algo = cert-digest-algo;
    s2k-cipher-algo = "AES256";
    fixed-list-mode = true;
    no-comments = true;
    no-emit-version = true;
    keyid-format = "0xlong";
    list-options = "show-uid-validity";
    verify-options = list-options;
    with-fingerprint = true;
    require-cross-certification = true;
    no-symkey-cache = true;
    throw-keyids = true;
    use-agent = true;
    auto-key-retrieve = true;
  };
}
