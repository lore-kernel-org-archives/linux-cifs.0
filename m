From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Remove sparse warnings
Date: Wed, 20 Jun 2012 22:09:57 +0200
Message-ID: <CAH2r5mtiYCjBdqMv_vAfZmzCu8qxhSQ431Jx-PvfFtUFEiHagA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two minor fixes to include in your smb2 patches (to remove sparse warnings)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0b435f8..8836c7b 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -439,7 +439,7 @@ extern int CIFSSMBSetEA(const unsigned int xid,
struct cifs_tcon *tcon,
 		const struct nls_table *nls_codepage, int remap_special_chars);
 extern int CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon,
 			__u16 fid, struct cifs_ntsd **acl_inf, __u32 *buflen);
-extern int CIFSSMBSetCIFSACL(const int, struct cifs_tcon *, __u16,
+extern int CIFSSMBSetCIFSACL(const unsigned int, struct cifs_tcon *, __u16,
 			struct cifs_ntsd *, __u32, int);
 extern int CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 		const unsigned char *searchName,
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 5023483..a97f86b 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -25,6 +25,7 @@
 #include "cifs_debug.h"
 #include "smb2pdu.h"
 #include "smb2status.h"
+#include "smb2proto.h"

 struct status_to_posix_error {
 	__u32 smb2_status;

-- 
Thanks,

Steve
