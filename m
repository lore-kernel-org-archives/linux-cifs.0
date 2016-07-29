From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] Fix memory leaks in cifs_do_mount()
Date: Fri, 29 Jul 2016 22:38:19 +0100
Message-ID: <1469828301-9937-2-git-send-email-sprabhu@redhat.com>
References: <1469828301-9937-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	=?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469828301-9937-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix memory leaks introduced by the patch
fs/cifs: make share unaccessible at root level mountable

Also move allocation of cifs_sb->prepath to cifs_setup_cifs_sb().

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c    | 20 ++++++++------------
 fs/cifs/cifsproto.h |  2 +-
 fs/cifs/connect.c   | 10 +++++++++-
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6bbec5e..cc9cdab 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -686,26 +686,22 @@ cifs_do_mount(struct file_system_type *fs_type,
 	cifs_sb->mountdata = kstrndup(data, PAGE_SIZE, GFP_KERNEL);
 	if (cifs_sb->mountdata == NULL) {
 		root = ERR_PTR(-ENOMEM);
-		goto out_cifs_sb;
+		goto out_free;
 	}
 
-	if (volume_info->prepath) {
-		cifs_sb->prepath = kstrdup(volume_info->prepath, GFP_KERNEL);
-		if (cifs_sb->prepath == NULL) {
-			root = ERR_PTR(-ENOMEM);
-			goto out_cifs_sb;
-		}
+	rc = cifs_setup_cifs_sb(volume_info, cifs_sb);
+	if (rc) {
+		root = ERR_PTR(rc);
+		goto out_free;
 	}
 
-	cifs_setup_cifs_sb(volume_info, cifs_sb);
-
 	rc = cifs_mount(cifs_sb, volume_info);
 	if (rc) {
 		if (!(flags & MS_SILENT))
 			cifs_dbg(VFS, "cifs_mount failed w/return code = %d\n",
 				 rc);
 		root = ERR_PTR(rc);
-		goto out_mountdata;
+		goto out_free;
 	}
 
 	mnt_data.vol = volume_info;
@@ -752,9 +748,9 @@ out:
 	cifs_cleanup_volume_info(volume_info);
 	return root;
 
-out_mountdata:
+out_free:
+	kfree(cifs_sb->prepath);
 	kfree(cifs_sb->mountdata);
-out_cifs_sb:
 	kfree(cifs_sb);
 out_nls:
 	unload_nls(volume_info->local_nls);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1243bd3..95dab43 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -184,7 +184,7 @@ extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
 				      struct page *page, unsigned int to_read);
-extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
+extern int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
 extern void cifs_cleanup_volume_info(struct smb_vol *pvolume_info);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7ae0328..4546926 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3222,7 +3222,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 	}
 }
 
-void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
+int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			struct cifs_sb_info *cifs_sb)
 {
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
@@ -3316,6 +3316,14 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
 		cifs_dbg(VFS, "mount option dynperm ignored if cifsacl mount option supported\n");
+
+	if (pvolume_info->prepath) {
+		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
+		if (cifs_sb->prepath == NULL)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 static void
-- 
2.5.5
