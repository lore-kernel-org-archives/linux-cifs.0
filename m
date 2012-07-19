From: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] Use errno instead of having unknown error
Date: Thu, 19 Jul 2012 11:38:28 +0200
Message-ID: <1342690708-15087-1-git-send-email-luk@debian.org>
Cc: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When access() fails, use errno for a sensible error message.

Signed-off-by: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
---
 mount.cifs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mount.cifs.c b/mount.cifs.c
index 6f3f382..f47f416 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -590,6 +590,7 @@ static int open_cred_file(char *file_name,
 	i = access(file_name, R_OK);
 	if (i) {
 		toggle_dac_capability(0, 0);
+		i = errno;
 		goto return_i;
 	}
 
-- 
1.7.10.4
