From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix error handling when cifscreds key payload is an error
Date: Fri, 20 Jan 2012 08:04:37 -0500
Message-ID: <1327064677-15896-1-git-send-email-jlayton@redhat.com>
Cc: dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 986709a..aa687c8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2125,7 +2125,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	down_read(&key->sem);
 	upayload = key->payload.data;
 	if (IS_ERR_OR_NULL(upayload)) {
-		rc = PTR_ERR(key);
+		rc = upayload ? PTR_ERR(upayload) : -EINVAL;
 		goto out_key_put;
 	}
 
-- 
1.7.7.5
