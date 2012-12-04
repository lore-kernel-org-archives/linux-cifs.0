From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] SMB3 mounts fail with access denied to some servers
Date: Tue, 4 Dec 2012 17:12:12 -0600
Message-ID: <CAH2r5muKfZKD9THXbwW7-A806LK+_20fuBuS9iyJfqUxf_NaJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Tue Dec 4 16:56:37 2012 -0600

    [CIFS] SMB3 mounts fail with access denied to some servers

    We were checking incorrectly if signatures were required to be sent,
    so were always sending signatures after the initial session establishment.
    For SMB3 mounts (vers=3.0) this was a problem because we were putting
    SMB2 signatures in SMB3 requests which would cause access denied
    on mount (the tree connection would fail).

    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index cf33622..e7f9dbc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -425,7 +425,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
        }

        cFYI(1, "sec_flags 0x%x", sec_flags);
-       if (sec_flags & CIFSSEC_MUST_SIGN) {
+       if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
                cFYI(1, "Signing required");
                if (!(server->sec_mode & (SMB2_NEGOTIATE_SIGNING_REQUIRED |
                      SMB2_NEGOTIATE_SIGNING_ENABLED))) {


-- 
Thanks,

Steve
