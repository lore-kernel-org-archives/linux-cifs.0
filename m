From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: clean up some compiler warnings
Date: Tue, 25 Jan 2011 10:16:45 -0500
Message-ID: <1295968605-21687-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

New compiler warnings that I noticed when building a patchset based
on recent Fedora kernel:

fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBSetFileSize=E2=80=99:
fs/cifs/cifssmb.c:4813:8: warning: variable =E2=80=98data_offset=E2=80=99=
 set but not used
[-Wunused-but-set-variable]

fs/cifs/file.c: In function =E2=80=98cifs_open=E2=80=99:
fs/cifs/file.c:349:24: warning: variable =E2=80=98pCifsInode=E2=80=99 s=
et but not used
[-Wunused-but-set-variable]
fs/cifs/file.c: In function =E2=80=98cifs_partialpagewrite=E2=80=99:
fs/cifs/file.c:1149:23: warning: variable =E2=80=98cifs_sb=E2=80=99 set=
 but not used
[-Wunused-but-set-variable]
fs/cifs/file.c: In function =E2=80=98cifs_iovec_write=E2=80=99:
fs/cifs/file.c:1740:9: warning: passing argument 6 of =E2=80=98CIFSSMBW=
rite2=E2=80=99 from
incompatible pointer type [enabled by default]
fs/cifs/cifsproto.h:337:12: note: expected =E2=80=98unsigned int *=E2=80=
=99 but argument is
of type =E2=80=98size_t *=E2=80=99

fs/cifs/readdir.c: In function =E2=80=98cifs_readdir=E2=80=99:
fs/cifs/readdir.c:767:23: warning: variable =E2=80=98cifs_sb=E2=80=99 s=
et but not used
[-Wunused-but-set-variable]

fs/cifs/cifs_dfs_ref.c: In function =E2=80=98cifs_dfs_d_automount=E2=80=
=99:
fs/cifs/cifs_dfs_ref.c:342:2: warning: =E2=80=98rc=E2=80=99 may be used=
 uninitialized in
this function [-Wuninitialized]
fs/cifs/cifs_dfs_ref.c:278:6: note: =E2=80=98rc=E2=80=99 was declared h=
ere

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c |    9 ++++-----
 fs/cifs/cifssmb.c      |    3 ---
 fs/cifs/file.c         |    8 ++------
 fs/cifs/readdir.c      |    3 ---
 4 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index f1c6862..0a265ad 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -282,8 +282,6 @@ static struct vfsmount *cifs_dfs_do_automount(struc=
t dentry *mntpt)
 	cFYI(1, "in %s", __func__);
 	BUG_ON(IS_ROOT(mntpt));
=20
-	xid =3D GetXid();
-
 	/*
 	 * The MSDFS spec states that paths in DFS referral requests and
 	 * responses must be prefixed by a single '\' character instead of
@@ -293,7 +291,7 @@ static struct vfsmount *cifs_dfs_do_automount(struc=
t dentry *mntpt)
 	mnt =3D ERR_PTR(-ENOMEM);
 	full_path =3D build_path_from_dentry(mntpt);
 	if (full_path =3D=3D NULL)
-		goto free_xid;
+		goto cdda_exit;
=20
 	cifs_sb =3D CIFS_SB(mntpt->d_inode->i_sb);
 	tlink =3D cifs_sb_tlink(cifs_sb);
@@ -303,9 +301,11 @@ static struct vfsmount *cifs_dfs_do_automount(stru=
ct dentry *mntpt)
 	}
 	ses =3D tlink_tcon(tlink)->ses;
=20
+	xid =3D GetXid();
 	rc =3D get_dfs_path(xid, ses, full_path + 1, cifs_sb->local_nls,
 		&num_referrals, &referrals,
 		cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	FreeXid(xid);
=20
 	cifs_put_tlink(tlink);
=20
@@ -338,8 +338,7 @@ success:
 	free_dfs_info_array(referrals, num_referrals);
 free_full_path:
 	kfree(full_path);
-free_xid:
-	FreeXid(xid);
+cdda_exit:
 	cFYI(1, "leaving %s" , __func__);
 	return mnt;
 }
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 32378f2..0ad5bab 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4810,7 +4810,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTcon=
Info *tcon, __u64 size,
 		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  =3D NULL;
-	char *data_offset;
 	struct file_end_of_file_info *parm_data;
 	int rc =3D 0;
 	__u16 params, param_offset, offset, byte_count, count;
@@ -4834,8 +4833,6 @@ CIFSSMBSetFileSize(const int xid, struct cifsTcon=
Info *tcon, __u64 size,
 	param_offset =3D offsetof(struct smb_com_transaction2_sfi_req, Fid) -=
 4;
 	offset =3D param_offset + params;
=20
-	data_offset =3D (char *) (&pSMB->hdr.Protocol) + offset;
-
 	count =3D sizeof(struct file_end_of_file_info);
 	pSMB->MaxParameterCount =3D cpu_to_le16(2);
 	/* BB find exact max SMB PDU from sess structure BB */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5a659f9..113c775 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -346,7 +346,6 @@ int cifs_open(struct inode *inode, struct file *fil=
e)
 	struct cifsTconInfo *tcon;
 	struct tcon_link *tlink;
 	struct cifsFileInfo *pCifsFile =3D NULL;
-	struct cifsInodeInfo *pCifsInode;
 	char *full_path =3D NULL;
 	bool posix_open_ok =3D false;
 	__u16 netfid;
@@ -361,8 +360,6 @@ int cifs_open(struct inode *inode, struct file *fil=
e)
 	}
 	tcon =3D tlink_tcon(tlink);
=20
-	pCifsInode =3D CIFS_I(file->f_path.dentry->d_inode);
-
 	full_path =3D build_path_from_dentry(file->f_path.dentry);
 	if (full_path =3D=3D NULL) {
 		rc =3D -ENOMEM;
@@ -1146,7 +1143,6 @@ static int cifs_partialpagewrite(struct page *pag=
e, unsigned from, unsigned to)
 	char *write_data;
 	int rc =3D -EFAULT;
 	int bytes_written =3D 0;
-	struct cifs_sb_info *cifs_sb;
 	struct inode *inode;
 	struct cifsFileInfo *open_file;
=20
@@ -1154,7 +1150,6 @@ static int cifs_partialpagewrite(struct page *pag=
e, unsigned from, unsigned to)
 		return -EFAULT;
=20
 	inode =3D page->mapping->host;
-	cifs_sb =3D CIFS_SB(inode->i_sb);
=20
 	offset +=3D (loff_t)from;
 	write_data =3D kmap(page);
@@ -1667,7 +1662,8 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written =3D 0, written =3D 0;
+	size_t total_written =3D 0;
+	unsigned int written =3D 0;
 	unsigned long num_pages, npages;
 	size_t copied, len, cur_len, i;
 	struct kvec *to_send;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 7f25cc3..f8e4cd2 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -764,7 +764,6 @@ int cifs_readdir(struct file *file, void *direntry,=
 filldir_t filldir)
 {
 	int rc =3D 0;
 	int xid, i;
-	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	struct cifsFileInfo *cifsFile =3D NULL;
 	char *current_entry;
@@ -775,8 +774,6 @@ int cifs_readdir(struct file *file, void *direntry,=
 filldir_t filldir)
=20
 	xid =3D GetXid();
=20
-	cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
-
 	/*
 	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
 	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
--=20
1.7.3.4
