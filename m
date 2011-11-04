From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Fix sparse warning when calling cifs_strtoUCS
Date: Fri,  4 Nov 2011 09:42:16 -0500
Message-ID: <1320417736-15607-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Fix sparse endian check warning while calling cifs_strtoUCS

CHECK   fs/cifs/smbencrypt.c
fs/cifs/smbencrypt.c:216:37: warning: incorrect type in argument 1
(different base types)
fs/cifs/smbencrypt.c:216:37:    expected restricted __le16 [usertype] *<noident>
fs/cifs/smbencrypt.c:216:37:    got unsigned short *<noident>


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smbencrypt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 7cacba1..56002ae 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -213,7 +213,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
 
 	/* Password cannot be longer than 128 characters */
 	if (passwd) /* Password must be converted to NT unicode */
-		len = cifs_strtoUCS(wpwd, passwd, 128, codepage);
+		len = cifs_strtoUCS((__le16 *)wpwd, passwd, 128, codepage);
 	else {
 		len = 0;
 		*wpwd = 0; /* Ensure string is null terminated */
-- 
1.6.0.2
