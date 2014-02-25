From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: mask off top byte in get_rfc1002_length()
Date: Tue, 25 Feb 2014 05:27:17 -0800
Message-ID: <1393334837-6480-1-git-send-email-jlayton@redhat.com>
Cc: klaus-jjkdzbv0JQgAvxtiuMwx3w@public.gmane.org, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The 32-bit rfc1002 header field consists of a type byte and then a
24-bit length field, but get_rfc1002_length doesn't mask off the top
byte.

In most cases, it's not a problem since the RFC1002_SESSION_MESSAGE type
is '\0', but when doing a RFC1002 session establishment, the type is
non-zero and that throws off the returned length in smb_send_rqst.

Reported-by: klaus-jjkdzbv0JQgAvxtiuMwx3w@public.gmane.org
Tested-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e7fe49e..45376a4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -506,7 +506,7 @@ struct cifs_mnt_data {
 static inline unsigned int
 get_rfc1002_length(void *buf)
 {
-	return be32_to_cpu(*((__be32 *)buf));
+	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
 }
 
 static inline void
-- 
1.8.5.3
