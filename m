From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Fix corrupt SMB2 ioctl requests
Date: Mon, 14 Oct 2013 00:52:14 -0500
Message-ID: <CAH2r5mvtEvGQqHjzkBBXLK0wddZpe=45KRqZ5qRnp=udZcxSOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that I have been able to test a wider variety of
SMB2/SMB3 ioctls, some with input payloads and
some without, I have this updated version of the patch
(which hopefully is cleaner )

We were off by one calculating the length of ioctls in some cases
because the protocol specification for SMB2 ioctl includes a mininum
one byte payload but not all SMB2 ioctl requests actually have
a data buffer to send. We were also not zeroing out the
return buffer (in case of error this is helpful).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index edccb52..afa3829 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1137,6 +1137,7 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,

     cifs_dbg(FYI, "SMB2 IOCTL\n");

+    *out_data = NULL;
     /* zero out returned data len, in case of error */
     if (plen)
         *plen = 0;
@@ -1182,11 +1183,23 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
         req->Flags = 0;

     iov[0].iov_base = (char *)req;
-    /* 4 for rfc1002 length field */
-    iov[0].iov_len = get_rfc1002_length(req) + 4;

-    if (indatalen)
-        inc_rfc1001_len(req, indatalen);
+    /*
+     * If no input data, the size of ioctl struct in
+     * protocol spec still includes a 1 byte data buffer,
+     * but if input data passed to ioctl, we do not
+     * want to double count this, so we do not send
+     * the dummy one byte of data in iovec[0] if sending
+     * input data (in iovec[1]). We also must add 4 bytes
+     * in first iovec to allow for rfc1002 length field.
+     */
+
+    if (indatalen) {
+        inc_rfc1001_len(req, indatalen - 1);
+        iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+    } else
+        iov[0].iov_len = get_rfc1002_length(req) + 4;
+

     rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
     rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
-- 
1.7.11.7

-- 
Thanks,

Steve
