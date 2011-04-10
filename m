From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 3/3] CIFS: Migrate to shared superblock model
Date: Sun, 10 Apr 2011 14:05:54 +0400
Message-ID: <1302429954-9927-3-git-send-email-piastry@etersoft.ru>
References: <1302429954-9927-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302429954-9927-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add cifs_match_super to use in sget to share superblock between mounts
that have the same //server/sharename, credentials and mount options.
It helps us to improve performance on work with future SMB2.1 leases.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c  |    6 ++-
 fs/cifs/connect.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c40c1f4..abc8436 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -577,14 +577,16 @@ cifs_do_mount(struct file_system_type *fs_type,
 	if (rc)
 		return ERR_PTR(rc);
 
-	sb = sget(fs_type, NULL, set_anon_super, NULL);
+	sb = sget(fs_type, cifs_match_super, set_anon_super, volume_info);
 	if (IS_ERR(sb)) {
 		cifs_cleanup_volume_info(&volume_info);
 		return ERR_CAST(sb);
 	}
 
-	if (sb->s_fs_info)
+	if (sb->s_fs_info) {
+		cFYI(1, "Use existing superblock");
 		goto out;
+	}
 
 	sb->s_flags = flags;
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 53b79e7..7c98c36 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2193,6 +2193,99 @@ cifs_put_tlink(struct tcon_link *tlink)
 	return;
 }
 
+static void setup_cifs_sb(struct smb_vol *vol, struct cifs_sb_info *sb);
+static inline struct tcon_link *
+cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
+
+static const u32 ACTUAL_MOUNT_FLAGS = CIFS_MOUNT_NO_PERM | CIFS_MOUNT_SET_UID |
+	CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | CIFS_MOUNT_NO_XATTR |
+	CIFS_MOUNT_MAP_SPECIAL_CHR | CIFS_MOUNT_UNX_EMUL | CIFS_MOUNT_NO_BRL |
+	CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | CIFS_MOUNT_OVERR_GID |
+	CIFS_MOUNT_DYNPERM | CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC |
+	CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | CIFS_MOUNT_MULTIUSER |
+	CIFS_MOUNT_STRICT_IO;
+
+static int
+compare_mount_options(struct super_block *sb, struct smb_vol *vol)
+{
+	struct cifs_sb_info *old = CIFS_SB(sb), new;
+
+	setup_cifs_sb(vol, &new);
+
+	if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=
+	    (new.mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
+		return 0;
+
+	if (old->rsize != new.rsize || old->wsize != new.wsize)
+		return 0;
+
+	if (old->mnt_uid != new.mnt_uid || old->mnt_gid != new.mnt_gid)
+		return 0;
+
+	if (old->mnt_file_mode != new.mnt_file_mode ||
+	    old->mnt_dir_mode != new.mnt_dir_mode)
+		return 0;
+
+	if (old->prepathlen != new.prepathlen ||
+	    strncmp(old->prepath, new.prepath, old->prepathlen))
+		return 0;
+
+	if (strcmp(old->local_nls->charset, vol->local_nls->charset))
+		return 0;
+
+	if (old->actimeo != new.actimeo)
+		return 0;
+
+	return 1;
+}
+
+int
+cifs_match_super(struct super_block *sb, void *data)
+{
+	struct smb_vol *volume_info = (struct smb_vol *) data;
+	struct TCP_Server_Info *tcp_srv;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct sockaddr_storage addr;
+	int rc = 0;
+
+	memset(&addr, 0, sizeof(struct sockaddr_storage));
+
+	spin_lock(&cifs_tcp_ses_lock);
+	cifs_sb = CIFS_SB(sb);
+	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
+	if (IS_ERR(tlink))
+		goto out;
+	tcon = tlink_tcon(tlink);
+	ses = tcon->ses;
+	tcp_srv = ses->server;
+
+	if (!volume_info->UNCip || !volume_info->UNC)
+		goto out;
+
+	rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
+				volume_info->UNCip,
+				strlen(volume_info->UNCip),
+				volume_info->port);
+	if (!rc)
+		goto out;
+
+	if (!match_server(tcp_srv, (struct sockaddr *)&addr, volume_info) ||
+	    !match_session(ses, volume_info) ||
+	    !match_tcon(tcon, volume_info->UNC)) {
+		rc = 0;
+		goto out;
+	}
+
+	rc = compare_mount_options(sb, volume_info);
+out:
+	cifs_put_tlink(tlink);
+	spin_unlock(&cifs_tcp_ses_lock);
+	return rc;
+}
+
 int
 get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_path,
 	     const struct nls_table *nls_codepage, unsigned int *pnum_referrals,
-- 
1.7.1
