# aerc talks to Gmail over IMAP/SMTP directly -- no mbsync/notmuch mirror -- so
# the only local state is aerc's header cache.
{
  lib,
  pkgs,
  ...
}: {
  accounts.email.accounts.gmail = {
    primary = true;
    address = "lucasandreussi@gmail.com";
    realName = "Lucas Andreussi";
    # Sets imap.gmail.com:993 and smtp.gmail.com:465, both TLS, and defaults
    # userName to the address.
    flavor = "gmail.com";

    # Google refuses the account password over IMAP and SMTP, so this has to be
    # an app password: https://myaccount.google.com/apppasswords (only offered
    # once 2FA is on). Store it with `pass insert gmail`.
    passwordCommand = [(lib.getExe pkgs.pass) "gmail"];

    folders = {
      inbox = "INBOX";
      drafts = "[Gmail]/Drafts";
      # Gmail files its own copy in Sent Mail whenever a message leaves through
      # its SMTP, so an aerc copy-to on top of that duplicates every sent mail.
      # Empty drops the copy-to key from accounts.conf entirely.
      sent = "";
    };

    gpg = {
      key = "45777D1BB49B2383D72BED7DE755DF9796E6E3AE";
      # `:sign` on demand rather than on every message -- mail signatures show
      # up as an attachment for most recipients.
      signByDefault = false;
      encryptByDefault = false;
    };

    aerc = {
      enable = true;

      extraAccounts = {
        # Gmail "archives" by dropping the Inbox label, which over IMAP is the
        # same thing as moving the message into All Mail.
        archive = "[Gmail]/All Mail";
        # Label views, not real folders: everything in them is already in Inbox
        # or All Mail, so they only pad the sidebar.
        folders-exclude = ["[Gmail]/Important" "[Gmail]/Starred"];
        # Gmail's IMAP is slow enough that re-fetching headers on every open is
        # noticeable.
        cache-headers = true;
        # IMAP pushes updates for the open folder only; this is what keeps the
        # unread counts on everything else moving.
        check-mail = "1m";
      };

      extraBinds.messages = {
        # aerc's default D is :delete, and Gmail's IMAP turns that into a
        # permanent expunge rather than the move-to-Trash that the web UI does.
        D = ":move [Gmail]/Trash<Enter>";
      };
    };
  };

  programs.aerc = {
    enable = true;

    extraConfig = {
      general = {
        # home-manager renders accounts.conf into the world-readable Nix store,
        # and aerc refuses to start on a non-0600 accounts.conf without this.
        # Nothing secret is in the file: the password is fetched at runtime by
        # source-cred-cmd, which runs pass.
        unsafe-accounts-conf = true;
      };

      ui = {
        threading-enabled = true;
        sidebar-width = 22;
        index-columns = "date<=,name<20%,flags>=,subject<*";
        timestamp-format = "2006-01-02 15:04";
        this-day-time-format = "15:04";
      };

      viewer = {
        # Gmail sends multipart/alternative for almost everything; prefer the
        # plain text part and fall back to the w3m-rendered HTML.
        alternatives = "text/plain,text/html";
      };
    };
  };
}
