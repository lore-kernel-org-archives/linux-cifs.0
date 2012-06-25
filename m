From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the cifs tree
Date: Mon, 25 Jun 2012 12:11:08 +1000
Message-ID: <20120625121108.882a4319f8e4f66e074c46b2@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Jun_2012_12_11_08_+1000_kL=l9MeuAd1Q0r9T"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Steve French <smfrench@gmail.com>,
	<linux-cifs@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Mon__25_Jun_2012_12_11_08_+1000_kL=l9MeuAd1Q0r9T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/cifs/dir.c
between commit 76023fd85bfd ("CIFS: Rename Get/FreeXid and make them work
with unsigned int") from the cifs tree and commit 070ac6cd4b0a ("cifs:
implement i_op->atomic_open()") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary.

P.S. Steve. that cifs tree commit has a bad email address for you in your
Signed-off-by line and committer (Steven French <sfrench@w500smf.(none)>).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/dir.c
index 9d73354,a180265..0000000
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@@ -133,29 -133,40 +133,40 @@@ cifs_bp_rename_retry
  	return full_path;
  }
 =20
+ /*
+  * Don't allow the separator character in a path component.
+  * The VFS will not allow "/", but "\" is allowed by posix.
+  */
+ static int
+ check_name(struct dentry *direntry)
+ {
+ 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(direntry->d_sb);
+ 	int i;
+=20
+ 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+ 		for (i =3D 0; i < direntry->d_name.len; i++) {
+ 			if (direntry->d_name.name[i] =3D=3D '\\') {
+ 				cFYI(1, "Invalid file name");
+ 				return -EINVAL;
+ 			}
+ 		}
+ 	}
+ 	return 0;
+ }
+=20
+=20
  /* Inode operations in similar order to how they appear in Linux file fs.=
h */
 =20
- int
- cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
- 		struct nameidata *nd)
+ static int cifs_do_create(struct inode *inode, struct dentry *direntry,
 -			  int xid, struct tcon_link *tlink, unsigned oflags,
++			  unsigned int xid, struct tcon_link *tlink, unsigned oflags,
+ 			  umode_t mode, __u32 *oplock, __u16 *fileHandle,
+ 			  int *created)
  {
  	int rc =3D -ENOENT;
- 	unsigned int xid;
  	int create_options =3D CREATE_NOT_DIR;
- 	__u32 oplock =3D 0;
- 	int oflags;
- 	/*
- 	 * BB below access is probably too much for mknod to request
- 	 *    but we have to do query and setpathinfo so requesting
- 	 *    less could fail (unless we want to request getatr and setatr
- 	 *    permissions (only).  At least for POSIX we do not have to
- 	 *    request so much.
- 	 */
- 	int desiredAccess =3D GENERIC_READ | GENERIC_WRITE;
- 	__u16 fileHandle;
- 	struct cifs_sb_info *cifs_sb;
- 	struct tcon_link *tlink;
- 	struct cifs_tcon *tcon;
+ 	int desiredAccess;
+ 	struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
+ 	struct cifs_tcon *tcon =3D tlink_tcon(tlink);
  	char *full_path =3D NULL;
  	FILE_ALL_INFO *buf =3D NULL;
  	struct inode *newinode =3D NULL;
@@@ -321,37 -355,136 +355,136 @@@ cifs_create_get_file_info
  	}
 =20
  cifs_create_set_dentry:
- 	if (rc =3D=3D 0)
- 		d_instantiate(direntry, newinode);
- 	else
+ 	if (rc !=3D 0) {
  		cFYI(1, "Create worked, get_inode_info failed rc =3D %d", rc);
+ 		goto out;
+ 	}
+ 	d_drop(direntry);
+ 	d_add(direntry, newinode);
 =20
- 	if (newinode && nd) {
- 		struct cifsFileInfo *pfile_info;
- 		struct file *filp;
+ 	/* ENOENT for create?  How weird... */
+ 	rc =3D -ENOENT;
+ 	if (!newinode) {
+ 		CIFSSMBClose(xid, tcon, *fileHandle);
+ 		goto out;
+ 	}
+ 	rc =3D 0;
 =20
- 		filp =3D lookup_instantiate_filp(nd, direntry, generic_file_open);
- 		if (IS_ERR(filp)) {
- 			rc =3D PTR_ERR(filp);
- 			CIFSSMBClose(xid, tcon, fileHandle);
- 			goto cifs_create_out;
- 		}
+ out:
+ 	kfree(buf);
+ 	kfree(full_path);
+ 	return rc;
+ }
 =20
- 		pfile_info =3D cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
- 		if (pfile_info =3D=3D NULL) {
- 			fput(filp);
- 			CIFSSMBClose(xid, tcon, fileHandle);
- 			rc =3D -ENOMEM;
- 		}
- 	} else {
+ int
+ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
+ 		 struct file *file, unsigned oflags, umode_t mode,
+ 		 int *opened)
+ {
+ 	int rc;
 -	int xid;
++	unsigned int xid;
+ 	struct tcon_link *tlink;
+ 	struct cifs_tcon *tcon;
+ 	__u16 fileHandle;
+ 	__u32 oplock;
+ 	struct file *filp;
+ 	struct cifsFileInfo *pfile_info;
+=20
+ 	/* Posix open is only called (at lookup time) for file create now.  For
+ 	 * opens (rather than creates), because we do not know if it is a file
+ 	 * or directory yet, and current Samba no longer allows us to do posix
+ 	 * open on dirs, we could end up wasting an open call on what turns out
+ 	 * to be a dir. For file opens, we wait to call posix open till
+ 	 * cifs_open.  It could be added to atomic_open in the future but the
+ 	 * performance tradeoff of the extra network request when EISDIR or
+ 	 * EACCES is returned would have to be weighed against the 50% reduction
+ 	 * in network traffic in the other paths.
+ 	 */
+ 	if (!(oflags & O_CREAT)) {
+ 		struct dentry *res =3D cifs_lookup(inode, direntry, 0);
+ 		if (IS_ERR(res))
+ 			return PTR_ERR(res);
+=20
+ 		return finish_no_open(file, res);
+ 	}
+=20
+ 	rc =3D check_name(direntry);
+ 	if (rc)
+ 		return rc;
+=20
 -	xid =3D GetXid();
++	xid =3D get_xid();
+=20
+ 	cFYI(1, "parent inode =3D 0x%p name is: %s and dentry =3D 0x%p",
+ 	     inode, direntry->d_name.name, direntry);
+=20
+ 	tlink =3D cifs_sb_tlink(CIFS_SB(inode->i_sb));
+ 	filp =3D ERR_CAST(tlink);
+ 	if (IS_ERR(tlink))
+ 		goto free_xid;
+=20
+ 	tcon =3D tlink_tcon(tlink);
+=20
+ 	rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+ 			    &oplock, &fileHandle, opened);
+=20
+ 	if (rc)
+ 		goto out;
+=20
+ 	rc =3D finish_open(file, direntry, generic_file_open, opened);
+ 	if (rc) {
  		CIFSSMBClose(xid, tcon, fileHandle);
+ 		goto out;
  	}
 =20
- cifs_create_out:
- 	kfree(buf);
- 	kfree(full_path);
+ 	pfile_info =3D cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
+ 	if (pfile_info =3D=3D NULL) {
+ 		CIFSSMBClose(xid, tcon, fileHandle);
+ 		fput(filp);
+ 		rc =3D -ENOMEM;
+ 	}
+=20
+ out:
+ 	cifs_put_tlink(tlink);
+ free_xid:
 -	FreeXid(xid);
++	free_xid(xid);
+ 	return rc;
+ }
+=20
+ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mod=
e,
+ 		bool excl)
+ {
+ 	int rc;
 -	int xid =3D GetXid();
++	int xid =3D get_xid();
+ 	/*
+ 	 * BB below access is probably too much for mknod to request
+ 	 *    but we have to do query and setpathinfo so requesting
+ 	 *    less could fail (unless we want to request getatr and setatr
+ 	 *    permissions (only).  At least for POSIX we do not have to
+ 	 *    request so much.
+ 	 */
+ 	unsigned oflags =3D O_EXCL | O_CREAT | O_RDWR;
+ 	struct tcon_link *tlink;
+ 	__u16 fileHandle;
+ 	__u32 oplock;
+ 	int created =3D FILE_CREATED;
+=20
+ 	cFYI(1, "cifs_create parent inode =3D 0x%p name is: %s and dentry =3D 0x=
%p",
+ 	     inode, direntry->d_name.name, direntry);
+=20
+ 	tlink =3D cifs_sb_tlink(CIFS_SB(inode->i_sb));
+ 	rc =3D PTR_ERR(tlink);
+ 	if (IS_ERR(tlink))
+ 		goto free_xid;
+=20
+ 	rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+ 			    &oplock, &fileHandle, &created);
+ 	if (!rc)
+ 		CIFSSMBClose(xid, tlink_tcon(tlink), fileHandle);
+=20
  	cifs_put_tlink(tlink);
+ free_xid:
 -	FreeXid(xid);
 +	free_xid(xid);
+=20
  	return rc;
  }
 =20
@@@ -488,22 -621,17 +621,17 @@@ mknod_out
 =20
  struct dentry *
  cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
- 	    struct nameidata *nd)
+ 	    unsigned int flags)
  {
 -	int xid;
 +	unsigned int xid;
  	int rc =3D 0; /* to get around spurious gcc warning, set to zero here */
  	struct cifs_sb_info *cifs_sb;
  	struct tcon_link *tlink;
  	struct cifs_tcon *pTcon;
- 	struct cifsFileInfo *cfile;
  	struct inode *newInode =3D NULL;
  	char *full_path =3D NULL;
- 	struct file *filp;
 =20
 -	xid =3D GetXid();
 +	xid =3D get_xid();
 =20
  	cFYI(1, "parent inode =3D 0x%p name is: %s and dentry =3D 0x%p",
  	      parent_dir_inode, direntry->d_name.name, direntry);

--Signature=_Mon__25_Jun_2012_12_11_08_+1000_kL=l9MeuAd1Q0r9T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP58i8AAoJEECxmPOUX5FEEt0P/R91QfPnGzq6TAw3pkJJtEyW
dGnVa6WUHdErO0AC756Z5RS2QOKPNcoNyhST7QQgMZ91QcBvImb4fylrJWo4APq9
/wKBjq0G4aCrErUcW7F5XGFBMfYWukUPjETQfx4TRGGvtezPmwEQ9JXGEe0XMIus
G+OsqxJUqG830Ws7apLFgm44orJ55g4fEzFdVrL+ZUSote4YrVhDDTO6ObWp+yah
/Gb5vJ5A94RHEM2zsXPD9lMe2nu4kHu+7MQidQv0kX+lPIi4od8y1QhNpP0Izo0c
U25SIkpQ5+ayLNiQ7nBLQJ96Iqc/jMZ4PEEQvcLUt3UZX0O2JKTwMOipUvDBlfVC
zeCwW4a/8Ggc5IWJB4h1+anGx8jpsmLlQ+DO1Ao5TP+lAa+LAN0KwY0lLtzGvJ+L
zx6iFEL3tyZAZAA3WbSg5vbv7AuWeRKzDTnlCP+McaReBD7/dzT0V8+DcHEHMV8o
x0BHor4r4fqpsPuaOAR80YMII1s8HIpIerhWQr5fzx2ix/X/Ix0Lo8HBeaiCAP8j
w5pGbXtsuwwZ104Y5Ju+ErlHHmMNuMIDc1Z+1Je8X+mwdXG+XtxWGGLssKAkLcUS
kYq7MHcLHik+fi9PQYP1mu/4ks3dGWXm34ZZUD8k4TTvp34JmCmentAFHbRjGWxz
KlxUFaGxOU4gJrkR8ujM
=SDPU
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jun_2012_12_11_08_+1000_kL=l9MeuAd1Q0r9T--
