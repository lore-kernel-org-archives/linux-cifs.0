From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: check for NULL session password
Date: Mon, 23 Aug 2010 11:38:04 -0400
Message-ID: <1282577884-16564-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible for a cifsSesInfo struct to have a NULL password, so we
need to check for that prior to running strncmp on it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 18af707..ec0ea4a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1673,6 +1673,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
+			    ses->password != NULL &&
 			    strncmp(ses->password,
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
-- 
1.7.2.1
