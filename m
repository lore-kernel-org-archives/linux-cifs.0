From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix NULL pointer dereference in cifs_find_smb_ses
Date: Wed, 18 Aug 2010 13:13:39 -0400
Message-ID: <1282151619-9707-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gacek-2004-5tc4TXWwyLM@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_find_smb_ses assumes that the vol->password field is a valid
pointer, but that's only the case if a password was passed in via
the options string. It's possible that one won't be if there is
no mount helper on the box.

Reported-by: diabel <gacek-2004-5tc4TXWwyLM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 95c2ea6..446e248 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1673,7 +1673,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
-			    strncmp(ses->password, vol->password,
+			    strncmp(ses->password,
+				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
 				continue;
 		}
-- 
1.7.2.1
