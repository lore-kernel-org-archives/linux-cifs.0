From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/24] cifs: Convert to separately allocated bdi
Date: Thu,  2 Feb 2017 18:34:08 +0100
Message-ID: <20170202173422.3240-11-jack@suse.cz>
References: <20170202173422.3240-1-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170202173422.3240-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Allocate struct backing_dev_info separately instead of embedding it
inside superblock. This unifies handling of bdi among users.

CC: Steve French <sfrench@samba.org>
CC: linux-cifs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/cifs/cifs_fs_sb.h |  1 -
 fs/cifs/cifsfs.c     |  7 ++++++-
 fs/cifs/connect.c    | 10 ----------
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 07ed81cf1552..cbd216b57239 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -68,7 +68,6 @@ struct cifs_sb_info {
 	umode_t	mnt_dir_mode;
 	unsigned int mnt_cifs_flags;
 	char   *mountdata; /* options received at mount time or via DFS refs */
-	struct backing_dev_info bdi;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 	char *prepath;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 70f4e65fced2..8dcf1c2555bf 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -138,7 +138,12 @@ cifs_read_super(struct super_block *sb)
 	sb->s_magic = CIFS_MAGIC_NUMBER;
 	sb->s_op = &cifs_super_ops;
 	sb->s_xattr = cifs_xattr_handlers;
-	sb->s_bdi = &cifs_sb->bdi;
+	rc = super_setup_bdi(sb);
+	if (rc)
+		goto out_no_root;
+	/* tune readahead according to rsize */
+	sb->s_bdi->ra_pages = cifs_sb->rsize / PAGE_SIZE;
+
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
 	inode = cifs_root_iget(sb);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 35ae49ed1f76..6c1dfe56589d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3650,10 +3650,6 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 	int referral_walks_count = 0;
 #endif
 
-	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs");
-	if (rc)
-		return rc;
-
 #ifdef CONFIG_CIFS_DFS_UPCALL
 try_mount_again:
 	/* cleanup activities if we're chasing a referral */
@@ -3681,7 +3677,6 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 	server = cifs_get_tcp_session(volume_info);
 	if (IS_ERR(server)) {
 		rc = PTR_ERR(server);
-		bdi_destroy(&cifs_sb->bdi);
 		goto out;
 	}
 	if ((volume_info->max_credits < 20) ||
@@ -3735,9 +3730,6 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 	cifs_sb->wsize = server->ops->negotiate_wsize(tcon, volume_info);
 	cifs_sb->rsize = server->ops->negotiate_rsize(tcon, volume_info);
 
-	/* tune readahead according to rsize */
-	cifs_sb->bdi.ra_pages = cifs_sb->rsize / PAGE_SIZE;
-
 remote_path_check:
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	/*
@@ -3854,7 +3846,6 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 			cifs_put_smb_ses(ses);
 		else
 			cifs_put_tcp_session(server, 0);
-		bdi_destroy(&cifs_sb->bdi);
 	}
 
 out:
@@ -4057,7 +4048,6 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
-	bdi_destroy(&cifs_sb->bdi);
 	kfree(cifs_sb->mountdata);
 	kfree(cifs_sb->prepath);
 	call_rcu(&cifs_sb->rcu, delayed_free);
-- 
2.10.2
