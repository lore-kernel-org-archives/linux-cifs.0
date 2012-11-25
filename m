From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/6] cifs: always zero out smb_vol before parsing options
Date: Sun, 25 Nov 2012 07:57:32 -0500
Message-ID: <1353848252-2468-2-git-send-email-jlayton@redhat.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
 <1353848252-2468-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353848252-2468-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the code relies on the callers to do that and they all do,
but this will ensure that it's always done.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 60295a4..ec1c462 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1162,6 +1162,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	separator[1] = 0;
 	delim = separator[0];
 
+	/* ensure we always start with zeroed-out smb_vol */
+	memset(vol, 0, sizeof(*vol));
+
 	/*
 	 * does not have to be perfect mapping since field is
 	 * informational, only used for servers that do not support
@@ -3356,7 +3359,6 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 			mdata = NULL;
 		} else {
 			cleanup_volume_info_contents(volume_info);
-			memset(volume_info, '\0', sizeof(*volume_info));
 			rc = cifs_setup_volume_info(volume_info, mdata,
 							fake_devname);
 		}
@@ -3378,7 +3380,6 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 	if (cifs_parse_mount_options(mount_data, devname, volume_info))
 		return -EINVAL;
 
-
 	if (volume_info->nullauth) {
 		cFYI(1, "Anonymous login");
 		kfree(volume_info->username);
@@ -3415,7 +3416,7 @@ cifs_get_volume_info(char *mount_data, const char *devname)
 	int rc;
 	struct smb_vol *volume_info;
 
-	volume_info = kzalloc(sizeof(struct smb_vol), GFP_KERNEL);
+	volume_info = kmalloc(sizeof(struct smb_vol), GFP_KERNEL);
 	if (!volume_info)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.11.7
