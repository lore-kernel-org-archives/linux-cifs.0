From: Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 3.7.10+:  BUG Dentry still in use [unmount of cifs cifs]
Date: Thu, 7 Mar 2013 20:19:15 +0100
Message-ID: <20130307191914.GA1652@mguzik.brq.redhat.com>
References: <51363F80.8070609@candelatech.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51363F80.8070609-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Mar 05, 2013 at 10:54:56AM -0800, Ben Greear wrote:
> In doing some CIFS testing (utilizing it's feature to bind to local
> address..but not sure that matters), we saw this error when trying
> to un-mount.
> 
> Our kernel is patched (nfs, some networking related patches), but there
> are no out-of-kernel patches to CIFS, so I don't *think* this is anything
> we could have caused.
> 
> This problem appears to be easily reproducible, so we will be happy
> to test patches if anyone has any suggestions.
> 
> BUG: Dentry ffff8800c07e43c0{i=45762,n=cifs2-01.7.lf-data} still in use (1) [unmount of cifs cifs]

We encountered similar panic, but it was related to writes. In our case
the problem was that some cifsInodeInfo holding dentry references were
still around (in slow-work queue) during superblock destruction in unmount.

I reproduced the problem on 3.8 kernel (sorry, no 3.7 handy) with reads
as well, which should match your scenario.

I attached a patch that deals with this problem by grabbing refcounts to
cifs superblock on cifsInodeInfo creation. This delays sb destruction
until all cifsInodeInfos are gone. I didn't test it on 3.7.10 kernel but
it should work fine.

-- 
Mateusz Guzik

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="cifs-umount-dentry-panic-upstream.diff"

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..345e76b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -91,6 +91,24 @@ struct workqueue_struct	*cifsiod_wq;
 __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
 #endif
 
+void
+cifs_sb_active(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_inc_return(&server->active) == 1)
+		atomic_inc(&sb->s_active);
+}
+
+void
+cifs_sb_deactive(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_dec_and_test(&server->active))
+		deactivate_super(sb);
+}
+
 static int
 cifs_read_super(struct super_block *sb)
 {
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 7163419..0e32c34 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -41,6 +41,10 @@ extern struct file_system_type cifs_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
+/* Functions related to super block operations */
+extern void cifs_sb_active(struct super_block *sb);
+extern void cifs_sb_deactive(struct super_block *sb);
+
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8c0d855..7a0dd99 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -300,6 +300,8 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	mutex_init(&cfile->fh_mutex);
 
+	cifs_sb_active(inode->i_sb);
+
 	/*
 	 * If the server returned a read oplock and we have mandatory brlocks,
 	 * set oplock level to None.
@@ -349,7 +351,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsLockInfo *li, *tmp;
 	struct cifs_fid fid;
 	struct cifs_pending_open open;
@@ -414,6 +417,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
+	cifs_sb_deactive(sb);
 	kfree(cifs_file);
 }
 

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="cifs-umount-dentry-panic-3.7.10.diff"

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e7931cc..cba259a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -93,6 +93,24 @@ struct workqueue_struct	*cifsiod_wq;
 __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
 #endif
 
+void
+cifs_sb_active(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_inc_return(&server->active) == 1)
+		atomic_inc(&sb->s_active);
+}
+
+void
+cifs_sb_deactive(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_dec_and_test(&server->active))
+		deactivate_super(sb);
+}
+
 static int
 cifs_read_super(struct super_block *sb)
 {
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 7163419..0e32c34 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -41,6 +41,10 @@ extern struct file_system_type cifs_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
+/* Functions related to super block operations */
+extern void cifs_sb_active(struct super_block *sb);
+extern void cifs_sb_deactive(struct super_block *sb);
+
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 70b6f4c..2c7ce42 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -276,6 +276,8 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	INIT_WORK(&cfile->oplock_break, cifs_oplock_break);
 	mutex_init(&cfile->fh_mutex);
 
+	cifs_sb_active(inode->i_sb);
+
 	spin_lock(&cifs_file_list_lock);
 	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE)
 		oplock = fid->pending_open->oplock;
@@ -315,7 +317,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct cifs_tcon *tcon = tlink_tcon(cifs_file->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct super_block *sb = inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsLockInfo *li, *tmp;
 	struct cifs_fid fid;
 	struct cifs_pending_open open;
@@ -380,6 +383,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 
 	cifs_put_tlink(cifs_file->tlink);
 	dput(cifs_file->dentry);
+	cifs_sb_deactive(sb);
 	kfree(cifs_file);
 }
 

--xHFwDpU9dbj6ez1V--
