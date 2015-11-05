From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1] cifs: make shares unaccessible at root level mountable
Date: Thu, 5 Nov 2015 15:48:36 +0100
Message-ID: <20151105154836.1851c30c@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AGp9SoFVFIwfVOcwuGSetma"; protocol="application/pgp-signature"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/AGp9SoFVFIwfVOcwuGSetma
Content-Type: multipart/mixed; boundary="MP_/G1LHl6bIMtsJrG/3yLLqQ.Y"

--MP_/G1LHl6bIMtsJrG/3yLLqQ.Y
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I've been working on solving this bug [1] for some time now. You can
find some of my research notes here [2]. I was recently able to
finally make it work.

The patch is based on Shirish's patch (available at [1]) to which I've
made the following modification:

- create disconnected root when any intermediary path are "not
  found" (ENOENT). Previously it was only done for EACCES errors.

- fix build_path_from_dentry() to correctly prefix dentry that are
  children of a disconnected root with the disconnected root actual
  path. This path is only avaible when using the struct rdelem linked
  list stored in the cifs superblock i.e. when we mount with
  noserverino.

So basically if you have the bug described in [1] you can solve it by
applying this patch and mounting with -o noserverino. I would like to
get rid this restriction (noserverino) and unconditionnaly use the
rdelem linked list but I don't know how feasible/safe that is (I'm still
new to all this stuff, this is my first kernel patch).

Shirish, I'd like to hear your comments if you have any. I've noticed
your find_rdelem_by_dentry() removes the dentry from the rdelem list
and I'm not sure I understand why. I've added and used
find_rdelem_by_dentry_no_del() to do the same thing without removing it.

1: https://bugzilla.samba.org/show_bug.cgi?id=3D8950
2: http://diobla.info/doc/suse-todo#bnc799133

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--MP_/G1LHl6bIMtsJrG/3yLLqQ.Y
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-cifs-make-shares-unaccessible-at-root-level-mountabl.patch

=46rom 92520bbeef256957c150df01f946ad8890140a78 Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Date: Thu, 5 Nov 2015 15:24:20 +0100
Subject: [PATCH] cifs: make shares unaccessible at root level mountable

Based on Shirish Pargaonkar's disconnected root patch [1].

The initial patch was modified to create a disconnected root when any
intermediary path is unaccessible (EACCESS) but *also* when "not
found" (ENOENT).

The other change was to modify build_path_from_dentry() in dir.c so that
if it has to build a path for a dentry that uses a disconnected root, it
prefixes that path with the disconnected root actual path.

Previously, when called with a dentry that had a disconnected root,
build_path_path() would stop when it reached that disconnected root,
which is not the same as the root of the share, resulting in a wrong
output path.

1: https://bugzilla.samba.org/show_bug.cgi?id=3D8950

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |  10 +++
 fs/cifs/cifsfs.c     |  84 +++++++++++++++++++-
 fs/cifs/cifsproto.h  |   1 +
 fs/cifs/connect.c    |   3 +
 fs/cifs/dir.c        | 217 ++++++++++++++++++++++++++++++++++++++++++++++-=
----
 fs/cifs/inode.c      |  36 ++++++++-
 6 files changed, 325 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 3182273..b2b65f6 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -67,5 +67,15 @@ struct cifs_sb_info {
 	struct backing_dev_info bdi;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
+	struct list_head rtdislist; /* list of disconnected root dentries */
+	spinlock_t rtdislock; /* lock for disconnected root dentry list */
+};
+
+struct cifs_rdelem {
+	int                     rdcount;
+	struct list_head        rdlist;
+	char *                  rdname;
+	struct dentry *		rdentry;
+	struct inode *          rdinode;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6a1119e..55160df 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -584,6 +584,80 @@ static const struct super_operations cifs_super_ops =
=3D {
 #endif
 };
=20
+void
+cifs_free_rdelem(struct cifs_rdelem *rdelem)
+{
+	kfree(rdelem->rdname);
+	kfree(rdelem);
+}
+
+struct cifs_rdelem *
+cifs_alloc_rdelem(char *full_path, struct dentry *rdentry,
+				struct inode *rdinode)
+{
+	struct cifs_rdelem *rdelem;
+	rdelem =3D kmalloc(sizeof(struct cifs_rdelem), GFP_KERNEL);
+	if (!rdelem) {
+		cifs_dbg(FYI, "%s Can't allocate root dentry\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rdelem->rdname =3D kstrdup(full_path, GFP_KERNEL);
+
+	if (!rdelem->rdname) {
+		cifs_dbg(FYI, "%s Can't allocate root dentry name\n", __func__);
+		kfree(rdelem);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rdelem->rdinode =3D rdinode;
+	rdelem->rdentry =3D rdentry;
+
+	return rdelem;
+}
+
+static struct dentry *
+create_root_dis_dentry(struct super_block *sb, struct inode *rinode,
+			char *fpath)
+{
+	int rc;
+	unsigned int xid;
+	struct dentry *dentry =3D NULL;
+	struct cifs_rdelem *rdelem =3D NULL;
+	struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
+	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
+
+	xid =3D get_xid();
+	if (tcon->unix_ext)
+		rc =3D cifs_get_inode_info_unix(&rinode, fpath, sb, xid);
+	else
+		rc =3D cifs_get_inode_info(&rinode, fpath, NULL, sb, xid, NULL);
+	free_xid(xid);
+
+	if ((rc =3D=3D 0) && (rinode !=3D NULL)) {
+		dentry =3D d_obtain_alias(rinode);
+		if (IS_ERR(dentry)) {
+			iput(rinode);
+			goto rdelem_ret;
+		}
+
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+
+			rdelem =3D
+				cifs_alloc_rdelem(fpath, dentry, rinode);
+			if (IS_ERR(rdelem))
+				goto rdelem_ret;
+			spin_lock(&cifs_sb->rtdislock);
+			list_add(&rdelem->rdlist, &cifs_sb->rtdislist);
+			spin_unlock(&cifs_sb->rtdislock);
+		}
+		return dentry;
+	}
+
+rdelem_ret:
+	return ERR_PTR(-EACCES);
+}
+
 /*
  * Get root dentry from superblock according to prefix path mount option.
  * Return dentry with refcount + 1 on success and NULL otherwise.
@@ -596,9 +670,10 @@ cifs_get_root(struct smb_vol *vol, struct super_block =
*sb)
 	char *full_path =3D NULL;
 	char *s, *p;
 	char sep;
+	struct inode *rinode =3D NULL;
+	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
=20
-	full_path =3D cifs_build_path_to_root(vol, cifs_sb,
-					    cifs_sb_master_tcon(cifs_sb));
+	full_path =3D cifs_build_path_to_root(vol, cifs_sb, tcon);
 	if (full_path =3D=3D NULL)
 		return ERR_PTR(-ENOMEM);
=20
@@ -639,6 +714,11 @@ cifs_get_root(struct smb_vol *vol, struct super_block =
*sb)
 		dput(dentry);
 		dentry =3D child;
 	} while (!IS_ERR(dentry));
+
+	if (IS_ERR(dentry) && (PTR_ERR(dentry) =3D=3D -EACCES || PTR_ERR(dentry) =
=3D=3D -ENOENT) && *s) {
+		dentry =3D create_root_dis_dentry(sb, rinode, full_path);
+	}
+
 	kfree(full_path);
 	return dentry;
 }
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c63fd1d..b0a813f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -205,6 +205,7 @@ extern void cifs_add_pending_open_locked(struct cifs_fi=
d *fid,
 					 struct tcon_link *tlink,
 					 struct cifs_pending_open *open);
 extern void cifs_del_pending_open(struct cifs_pending_open *open);
+extern void cifs_free_rdelem(struct cifs_rdelem *);
=20
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 773f4dc..018c156 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3190,6 +3190,9 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree =3D RB_ROOT;
=20
+	spin_lock_init(&cifs_sb->rtdislock);
+	INIT_LIST_HEAD(&cifs_sb->rtdislist);
+
 	/*
 	 * Temporarily set r/wsize for matching superblock. If we end up using
 	 * new sb then client will later negotiate it downward if needed.
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c3eb998..bc02265 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -77,6 +77,9 @@ cifs_build_path_to_root(struct smb_vol *vol, struct cifs_=
sb_info *cifs_sb,
 	return full_path;
 }
=20
+static struct cifs_rdelem * find_rdelem_by_dentry_no_del(const struct dent=
ry *rdentry,
+							 struct cifs_sb_info * cifs_sb);
+
 /* Note: caller must free return buffer */
 char *
 build_path_from_dentry(struct dentry *direntry)
@@ -89,6 +92,25 @@ build_path_from_dentry(struct dentry *direntry)
 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(direntry->d_sb);
 	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
 	unsigned seq;
+	struct cifs_rdelem *dis_root =3D NULL;
+	size_t dis_root_len =3D 0;
+
+	/*
+	 * First look if the dentry has a disconnected root in its
+	 * parent hierarchy. If that's the case we must append that
+	 * root path as a prefix.
+	 */
+
+	rcu_read_lock();
+	for (temp =3D direntry; temp && !IS_ROOT(temp); temp =3D temp->d_parent);
+	if (temp && (dis_root =3D find_rdelem_by_dentry_no_del(temp, cifs_sb)))
+		dis_root_len =3D strlen(dis_root->rdname);
+	rcu_read_unlock();
+
+	/*
+	 * Now let's compute the length of the path so that we can
+	 * allocate the right size
+	 */
=20
 	dirsep =3D CIFS_DIR_SEP(cifs_sb);
 	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
@@ -108,8 +130,19 @@ cifs_bp_rename_retry:
 			return NULL;
 		}
 	}
+	if (dis_root && temp =3D=3D dis_root->rdentry) {
+		/*
+		 *  Account for the disconnected root prefix
+		 *  Note: leading dir separator already in the length
+		 */
+		namelen +=3D dis_root_len;
+	}
 	rcu_read_unlock();
=20
+	/*
+	 * Next step is to actually fill the full_path string
+	 */
+
 	full_path =3D kmalloc(namelen+1, GFP_KERNEL);
 	if (full_path =3D=3D NULL)
 		return full_path;
@@ -136,7 +169,12 @@ cifs_bp_rename_retry:
 			return NULL;
 		}
 	}
+	if (dis_root && temp =3D=3D dis_root->rdentry) {
+		namelen -=3D dis_root_len;
+		strncpy(full_path + namelen, dis_root->rdname, dis_root_len);
+	}
 	rcu_read_unlock();
+
 	if (namelen !=3D dfsplen || read_seqretry(&rename_lock, seq)) {
 		cifs_dbg(FYI, "did not end path lookup where expected. namelen=3D%ddfspl=
en=3D%d\n",
 			 namelen, dfsplen);
@@ -704,6 +742,73 @@ mknod_out:
 	return rc;
 }
=20
+static struct cifs_rdelem *
+find_rdelem_by_inode(struct inode *rdinode, struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (rdelem->rdinode =3D=3D rdinode) {
+			list_del(&rdelem->rdlist);
+			spin_unlock(&cifs_sb->rtdislock);
+			return rdelem;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+	return NULL;
+}
+
+static struct cifs_rdelem *
+find_rdelem_by_dentry(const struct dentry *rdentry,
+			struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (rdelem->rdentry =3D=3D rdentry) {
+			list_del(&rdelem->rdlist);
+			spin_unlock(&cifs_sb->rtdislock);
+			return rdelem;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+	return NULL;
+}
+
+static struct cifs_rdelem *
+find_rdelem_by_dentry_no_del(const struct dentry *rdentry,
+			struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+	struct cifs_rdelem *found =3D NULL;
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (rdelem->rdentry =3D=3D rdentry) {
+			found =3D rdelem;
+			break;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+	return found;
+}
+
+
+static void
+find_rdelem_by_path(char *full_path, struct inode **newInode,
+			struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (!strcmp(rdelem->rdname, full_path)) {
+			*newInode =3D ilookup(rdelem->rdinode->i_sb,
+					    rdelem->rdinode->i_ino);
+			break;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+}
+
 struct dentry *
 cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	    unsigned int flags)
@@ -715,6 +820,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dent=
ry *direntry,
 	struct cifs_tcon *pTcon;
 	struct inode *newInode =3D NULL;
 	char *full_path =3D NULL;
+	struct dentry *ret =3D NULL;
+	struct cifs_rdelem *rdelem;
+	struct qstr dname;
=20
 	xid =3D get_xid();
=20
@@ -751,20 +859,66 @@ cifs_lookup(struct inode *parent_dir_inode, struct de=
ntry *direntry,
 	}
 	cifs_dbg(FYI, "Full path: %s inode =3D 0x%p\n",
 		 full_path, d_inode(direntry));
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+		/*
+		 * Looking for an existing disconnected root dentry if any,
+		 * before sending out a lookup on the wire.
+		 */
+		find_rdelem_by_path(full_path, &newInode, cifs_sb);
+	}
=20
-	if (pTcon->unix_ext) {
-		rc =3D cifs_get_inode_info_unix(&newInode, full_path,
-					      parent_dir_inode->i_sb, xid);
-	} else {
-		rc =3D cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
+	if (!newInode) {
+		if (pTcon->unix_ext) {
+			rc =3D cifs_get_inode_info_unix(&newInode, full_path,
+					parent_dir_inode->i_sb, xid);
+		} else
+			rc =3D cifs_get_inode_info(&newInode, full_path, NULL,
+					parent_dir_inode->i_sb, xid, NULL);
 	}
+	/* else, found an anonymous root dentry with an inode */
+
+
=20
 	if ((rc =3D=3D 0) && (newInode !=3D NULL)) {
-		d_add(direntry, newInode);
+
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
-		renew_parental_timestamps(direntry);
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+			dname.name =3D direntry->d_name.name;
+			dname.len =3D strlen(direntry->d_name.name) + 1;
+			/*
+			 * Perhaps another lookup beat us to this.
+			 */
+			spin_lock(&cifs_sb->rtdislock);
+			ret =3D d_lookup(direntry->d_parent, &dname);
+			if (ret && !IS_ERR(ret)) {
+				dput(ret);
+				spin_unlock(&cifs_sb->rtdislock);
+				goto lookup_out;
+			} else
+				ret =3D d_splice_alias(newInode, direntry);
+			spin_unlock(&cifs_sb->rtdislock);
+		} else
+			ret =3D d_splice_alias(newInode, direntry);
+		if (!ret)
+			renew_parental_timestamps(direntry);
+
+		else {
+			if (!IS_ERR(ret)) {
+				if (!(cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_SERVER_INUM)) {
+					rdelem =3D
+					find_rdelem_by_inode(newInode, cifs_sb);
+					if (rdelem)
+						cifs_free_rdelem(rdelem);
+				}
+				renew_parental_timestamps(ret);
+				dput(ret);
+				goto lookup_out;
+			} else
+				rc =3D PTR_ERR(ret);
+		}
+
=20
 	} else if (rc =3D=3D -ENOENT) {
 		rc =3D 0;
@@ -777,12 +931,41 @@ cifs_lookup(struct inode *parent_dir_inode, struct de=
ntry *direntry,
 		/* We special case check for Access Denied - since that
 		is a common return code */
 	}
-
+	ret =3D ERR_PTR(rc);
 lookup_out:
 	kfree(full_path);
 	cifs_put_tlink(tlink);
 	free_xid(xid);
-	return ERR_PTR(rc);
+	return ret;
+}
+
+static void
+cifs_d_common_releasedelete(const struct dentry *dentry)
+{
+	struct cifs_rdelem *rdelem;
+	struct cifs_sb_info *cifs_sb;
+
+	cifs_sb =3D CIFS_SB(dentry->d_sb);
+
+	/* disconnected root dentries that did not get spliced */
+	if (IS_ROOT(dentry) && dentry->d_flags & DCACHE_DISCONNECTED) {
+		rdelem =3D find_rdelem_by_dentry(dentry, cifs_sb);
+		if (rdelem)
+			cifs_free_rdelem(rdelem);
+	}
+}
+
+static int
+cifs_d_delete(const struct dentry *dentry)
+{
+	cifs_d_common_releasedelete(dentry);
+	return 0;
+}
+
+static void
+cifs_d_release(struct dentry *dentry)
+{
+	cifs_d_common_releasedelete(dentry);
 }
=20
 static int
@@ -834,19 +1017,11 @@ cifs_d_revalidate(struct dentry *direntry, unsigned =
int flags)
 	return 1;
 }
=20
-/* static int cifs_d_delete(struct dentry *direntry)
-{
-	int rc =3D 0;
-
-	cifs_dbg(FYI, "In cifs d_delete, name =3D %pd\n", direntry);
-
-	return rc;
-}     */
-
 const struct dentry_operations cifs_dentry_ops =3D {
 	.d_revalidate =3D cifs_d_revalidate,
 	.d_automount =3D cifs_dfs_d_automount,
-/* d_delete:       cifs_d_delete,      */ /* not needed except for debuggi=
ng */
+	.d_delete =3D cifs_d_delete,
+	.d_release =3D cifs_d_release,
 };
=20
 static int cifs_ci_hash(const struct dentry *dentry, struct qstr *q)
@@ -921,4 +1096,6 @@ const struct dentry_operations cifs_ci_dentry_ops =3D {
 	.d_hash =3D cifs_ci_hash,
 	.d_compare =3D cifs_ci_compare,
 	.d_automount =3D cifs_dfs_d_automount,
+	.d_delete =3D cifs_d_delete,
+	.d_release =3D cifs_d_release,
 };
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f621b44..7d17911 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -923,8 +923,10 @@ inode_has_hashed_dentries(struct inode *inode)
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
-			spin_unlock(&inode->i_lock);
-			return true;
+			if (!(dentry->d_flags & DCACHE_DISCONNECTED)) {
+				spin_unlock(&inode->i_lock);
+				return true;
+			}
 		}
 	}
 	spin_unlock(&inode->i_lock);
@@ -974,6 +976,23 @@ retry_iget5_locked:
 	return inode;
 }
=20
+void
+fill_phfattr(struct cifs_fattr *cf, struct super_block *sb)
+{
+
+	struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
+
+	memset(cf, 0, sizeof(*cf));
+	cf->cf_uniqueid =3D ROOT_I;
+	cf->cf_nlink =3D 1;
+	cf->cf_atime =3D CURRENT_TIME;
+	cf->cf_ctime =3D CURRENT_TIME;
+	cf->cf_mtime =3D CURRENT_TIME;
+	cf->cf_mode =3D S_IFDIR | S_IXUGO | S_IRWXU;
+	cf->cf_uid =3D cifs_sb->mnt_uid;
+	cf->cf_gid =3D cifs_sb->mnt_gid;
+}
+
 /* gets root inode */
 struct inode *cifs_root_iget(struct super_block *sb)
 {
@@ -982,6 +1001,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	struct inode *inode =3D NULL;
 	long rc;
 	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
+	struct cifs_fattr phfattr;
=20
 	xid =3D get_xid();
 	if (tcon->unix_ext) {
@@ -997,8 +1017,16 @@ struct inode *cifs_root_iget(struct super_block *sb)
=20
 iget_no_retry:
 	if (!inode) {
-		inode =3D ERR_PTR(rc);
-		goto out;
+		if (rc =3D=3D -EACCES) {
+			fill_phfattr(&phfattr, sb);
+			inode =3D cifs_iget(sb, &phfattr);
+			if (inode)
+				rc =3D 0;
+		}
+		if (rc) {
+			inode =3D ERR_PTR(rc);
+			goto out;
+		}
 	}
=20
 #ifdef CONFIG_CIFS_FSCACHE
--=20
2.1.4


--MP_/G1LHl6bIMtsJrG/3yLLqQ.Y--

--Sig_/AGp9SoFVFIwfVOcwuGSetma
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWO2xGAAoJEDIGO5Hchq/8F+MP/26StfgnxzRZCwkUKkyKwwVh
X+xZZhFhG35Te1OubTW/vrAVftgmpcsuBEbmv+Wuu536LSa9rPaCkioir1KxMV5G
qGoPtn92VeuRjan95OM5SCJD9SW8ZEWHnWzpI20kqKc1S7GUgbWVE4L+IlEMT9Yq
F90hawwJgzQLVcBQO2GVrjkYQxrFULVlIgwwvzGKzgP2RxSC455tj3kVwn5JjamC
2poIEGb85e1BugRzT960rdMT4BegiBrNbFtGIgocmsWZ4qvUSeqJRREAH2GRa9L1
oLhusgVCfEy/NgJxNckBgOwMyarLoF8q1prKhzit7jPhGp89O7Ir9/gEYTmFsm4e
lyQhLwXudg3rHSwi2oVrlEPKw7824v0vEErZMtK0s0CpUs9HM5kl0A0MBjDKPmEi
xOWPm83p0dcVFL3fL6s0Pq5lOva7C4TtcB6ZX8G2yFZp2TGmjbInS8bJAYoJLJMW
RAn/ISS3rGSmLSmVAK6yKLFQbAdJI/UUCxonrhkFn2GMsTZn4GtPowVbwZVOOLvS
EEjY4qIHHr8o/K3cxkllEvvlwRIriJ655vmZMRNpjnypUxpsdoGrga7SNStOwfos
CHInJONfATnh8jVfgbjV8AYRNg7jw8f0z144hgwFJylsBAjmGQZ7HNd58D2r8cBp
UZ+SUlEUa/0U6uzbM/sl
=IWtf
-----END PGP SIGNATURE-----

--Sig_/AGp9SoFVFIwfVOcwuGSetma--
