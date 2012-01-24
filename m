From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] cifs: NULL dereference on allocation failure
Date: Tue, 24 Jan 2012 11:39:22 +0300
Message-ID: <20120124083922.GA29097@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We should just return directly here, the goto causes a NULL dereference.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 986709a..026d646 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3857,10 +3857,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 	struct smb_vol *vol_info;
 
 	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
-	if (vol_info == NULL) {
-		tcon = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	if (vol_info == NULL)
+		return ERR_PTR(-ENOMEM);
 
 	vol_info->local_nls = cifs_sb->local_nls;
 	vol_info->linux_uid = fsuid;
