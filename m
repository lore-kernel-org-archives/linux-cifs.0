From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch] cifs: writing past the end of the array
Date: Sun, 6 Mar 2011 16:26:21 +0300
Message-ID: <20110306132621.GN3416@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a cut and paste error.  p16 only has 16 chars, not 21.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 3967635..1525d5e 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -353,7 +353,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
 	int rc;
 	unsigned char p16[16], p21[21];
 
-	memset(p16, '\0', 21);
+	memset(p16, '\0', 16);
 	memset(p21, '\0', 21);
 
 	rc = E_md4hash(passwd, p16);
