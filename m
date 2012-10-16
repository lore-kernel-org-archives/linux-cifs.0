From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] cifs: move num_subauth check inside of CONFIG_CIFS_DEBUG2 check in parse_sid()
Date: Tue, 16 Oct 2012 07:26:44 -0400
Message-ID: <1350386806-18356-3-git-send-email-jlayton@redhat.com>
References: <1350386806-18356-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350386806-18356-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d0b2bfb..eddadcd 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -987,8 +987,8 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 		return -EINVAL;
 	}
 
-	if (psid->num_subauth) {
 #ifdef CONFIG_CIFS_DEBUG2
+	if (psid->num_subauth) {
 		int i;
 		cFYI(1, "SID revision %d num_auth %d",
 			psid->revision, psid->num_subauth);
@@ -1002,8 +1002,8 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 			num auths and therefore go off the end */
 		cFYI(1, "RID 0x%x",
 			le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
-#endif
 	}
+#endif
 
 	return 0;
 }
-- 
1.7.11.7
