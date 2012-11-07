From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/3] getcifsacl: fix up printing of REVISION: and CONTROL: fields
Date: Wed,  7 Nov 2012 09:51:53 -0500
Message-ID: <1352299913-32624-1-git-send-email-jlayton@samba.org>
References: <1352289120-29327-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352289120-29327-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

They need endianness conversion too...

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index c576fc0..b76c8ec 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -327,8 +327,8 @@ parse_sec_desc(struct cifs_ntsd *pntsd, ssize_t acl_len, int raw)
 				le32toh(pntsd->gsidoffset));
 	dacloffset = le32toh(pntsd->dacloffset);
 	dacl_ptr = (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset);
-	printf("REVISION:0x%x\n", pntsd->revision);
-	printf("CONTROL:0x%x\n", pntsd->type);
+	printf("REVISION:0x%x\n", le16toh(pntsd->revision));
+	printf("CONTROL:0x%x\n", le16toh(pntsd->type));
 
 	rc = parse_sid(owner_sid_ptr, end_of_acl, "OWNER", raw);
 	if (rc)
-- 
1.7.12.1
