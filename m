Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6433C0606
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 14:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781189881; cv=none; b=oR/FasSGorJxj+mFNXCLmrxB0yvCkXNrB41jH83xHlfcRXL0Y9U1aQG+IRp74VnnyNO2TTlUJQ9XeZ5bXeySzQIUyUI1i2yPZRmEE+qj/6lA5rfpBBivEHLyoN18oWHlvv/2CFYRmbrg04dz65C/WUKXassgRlYUGxi6jfFTuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781189881; c=relaxed/simple;
	bh=WG5Ps8BZ3M0xByFL5vgCqiWsDqFk/WJHfWIDwRyKZjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jQqkz9dNuj7xsVYIwJBIwsEj+kv/aW1Tb1IYF/fUCJX+LZufY+iTRrIcvBcVkDInRX0XeCnJ1FtaT3JHxV71pJNXBXafmoKZO86yZQbbPxhh/a5++dMXFDRm3XPSh4qwCe2Ex4cWBk7dWnKFv21lnqqR45uO2npvxBmsZlzu0+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=GI8u4OZY; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="GI8u4OZY"
X-KPN-MessageId: eae1c854-65a5-11f1-89f6-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id eae1c854-65a5-11f1-89f6-00505699b430;
	Thu, 11 Jun 2026 16:57:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:date:subject:to:from;
	bh=E04F1I5e7mS1zEgYDN4bGAlthuHFKxrqo2BjnfxCIQs=;
	b=GI8u4OZYd0XgjmTk+AOvjdRqlzLHbRMNXBzYO0aVkzyrWMHNpL1uWcJLwHSVA26y8k6j0o3L50Soh
	 0PA0NCH4fjKuhCq2vfD4NHbvQRDSmJnG/yP64oSx5pv+lK7fXqKJs6bA8pW2xEVFjm8Tmsihn/xRD/
	 m/NdyVRfNuPC5K5M2Z8YwU9hSE05zL2ZAggX8ig39zYmI03KeMxCqwqMmJXfgrLOg2YlYWArjyNmj9
	 TCRzvBiIJHegcaAtceAGj0BhfEqi3NdjEjPgzGobDh/qq/YGJJC7Foyy0ZSQyKKy/almCGIrzxmNSI
	 5lpMv1grUMU96+0Kl8AuFtE25UWL9Sw==
X-KPN-MID: 33|47fcke+1ON7eanjgmYgu4pqab+/Lp1ddWofic8fys7yNTseYYHwhKojo22SRFzH
 rj+bjt8/muclXLgGFA+dp7xYY8lhADRUtjuNDUM+ExYA=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|hIU8PPtSnVoLJsj17k7+AEOIVlYQjTm+JatKlKpYBr96vuyO6UbxqX7fdJeawP6
 R8AOfVTvo8SHkivB5lFeBjw==
Received: from lt-jori.home (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id e7da8a26-65a5-11f1-9c0d-00505699d6e5;
	Thu, 11 Jun 2026 16:57:51 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jkoolstra@xs4all.nl
Subject: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Date: Thu, 11 Jun 2026 16:57:06 +0200
Message-ID: <20260611145733.43776-1-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There is a comment in vfs_prepare_mode() that says:

  Note that it's currently valid for @type to be 0 if a directory is
  created. Filesystems raise that flag individually and we need to check
  whether each filesystem can deal with receiving S_IFDIR from the vfs
  before we enforce a non-zero type.

This is a bit challenging since there are many filesystems. Claude Opus
4.8 was used to generate the context for each mkdir implementation from
which it can be judged whether passing S_IFDIR is safe. The result was
then verified by hand by looking at how the mode argument is used in
each case. To check whether all mkdir implementations are convered,
'rg "\.mkdir" ' was used and checked against the list of uses Claude
found.

The only mkdir implementation that I am not as sure of is
cifs_mkdir(). So this goes cc to the cifs people. But of course, I might
have made errors in other places (except probably not for the A list as
those are all just mode | S_IFDIR cases without other uses of mode
besides logging)


This is the AI context I worked with:

Here's each filesystem with the exact line(s) that make it safe, grouped by why.

  A. Forces S_IFDIR itself (redundant if pre-set → harmless)

  9p          fs/9p/vfs_inode.c:683        perm = unixmode2p9mode(v9ses, mode | S_IFDIR);
  9p (dotl)   fs/9p/vfs_inode_dotl.c:365   omode |= S_IFDIR;
  affs        fs/affs/namei.c:290          inode->i_mode = S_IFDIR | mode;
  afs         fs/afs/dir.c:1326            op->create.mode = S_IFDIR | mode;
  autofs      fs/autofs/root.c:744         inode = autofs_get_inode(dir->i_sb, S_IFDIR | mode);
  btrfs       fs/btrfs/inode.c:7123        inode_init_owner(idmap, inode, dir, S_IFDIR | mode);
  ceph        fs/ceph/dir.c:1145           mode |= S_IFDIR;
  ext2        fs/ext2/namei.c:239          inode = ext2_new_inode(dir, S_IFDIR | mode, &dentry->d_name);
  ext4        fs/ext4/namei.c:3012         inode = ext4_new_inode_start_handle(idmap, dir, S_IFDIR | mode,
  f2fs        fs/f2fs/namei.c:745          inode = f2fs_new_inode(idmap, dir, S_IFDIR | mode, NULL);
  fuse        fs/fuse/dir.c:1131           return create_new_entry(idmap, fm, &args, dir, entry, S_IFDIR);
  gfs2        fs/gfs2/inode.c:1351         gfs2_create_inode(dir, dentry, NULL, S_IFDIR | mode, ...)
  hfs         fs/hfs/dir.c:228             inode = hfs_new_inode(dir, &dentry->d_name, S_IFDIR | mode);
  hfsplus     fs/hfsplus/dir.c:579         hfsplus_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0)
  hpfs        fs/hpfs/namei.c:66           result->i_mode |= S_IFDIR;
  hugetlbfs   fs/hugetlbfs/inode.c:974     mode | S_IFDIR, 0);
  jffs2       fs/jffs2/dir.c:465           mode |= S_IFDIR;
  jfs         fs/jfs/namei.c:226           ip = ialloc(dip, S_IFDIR | mode);
  minix       fs/minix/namei.c:113         inode = minix_new_inode(dir, S_IFDIR | mode);
  nilfs2      fs/nilfs2/namei.c:234        inode = nilfs_new_inode(dir, S_IFDIR | mode);
  ntfs3       fs/ntfs3/namei.c:216         S_IFDIR | mode, 0, NULL, 0, NULL));
  ocfs2       fs/ocfs2/namei.c:660         ocfs2_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
  dlmfs       fs/ocfs2/dlmfs/dlmfs.c:425   inode = dlmfs_get_inode(dir, dentry, mode | S_IFDIR);
  omfs        fs/omfs/dir.c:285            return ERR_PTR(omfs_add_node(dir, dentry, mode | S_IFDIR));
  orangefs    fs/orangefs/namei.c:336      orangefs_new_inode(dir->i_sb, dir, S_IFDIR | mode, 0, &ref);
  ramfs       fs/ramfs/inode.c:124         ramfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
  ubifs       fs/ubifs/dir.c:1034          inode = ubifs_new_inode(c, dir, S_IFDIR | mode, false);
  udf         fs/udf/namei.c:431           inode = udf_new_inode(dir, S_IFDIR | mode);
  ufs         fs/ufs/namei.c:177           inode = ufs_new_inode(dir, S_IFDIR|mode);
  xfs         fs/xfs/xfs_iops.c:309        xfs_generic_create(idmap, dir, dentry, mode | S_IFDIR, 0, NULL)
  nfs         fs/nfs/dir.c:2475            attr.ia_mode = mode | S_IFDIR;

  B. Masks the type bits away before use (pre-set S_IFDIR stripped)

  overlayfs   fs/overlayfs/dir.c:743       ovl_create_object(dentry, (mode & 07777) | S_IFDIR, 0, NULL)
  vboxsf      fs/vboxsf/dir.c:272-273      params.info.attr.mode = (mode & 0777) |
                                             (is_dir ? SHFL_TYPE_DIRECTORY : SHFL_TYPE_FILE);
  nfs (v3)    fs/nfs/nfs3xdr.c:562         *p++ = cpu_to_be32(attr->ia_mode & S_IALLUGO);
  nfs (v4)    fs/nfs/nfs4xdr.c:1170,1196   *p++ = cpu_to_be32(iap->ia_mode & S_IALLUGO);

  C. Type comes from elsewhere — incoming mode's type is never consulted

  exfat       fs/exfat/namei.c:856         exfat_add_entry(dir, ..., TYPE_DIR, &info);   // literal dir type
  fat/msdos   fs/fat/namei_msdos.c:376     msdos_add_entry(dir, ..., 1, ...);            // is_dir=1 literal
  fat/vfat    fs/fat/namei_vfat.c:867      vfat_add_entry(dir, &dentry->d_name, 1, ...); // is_dir=1 literal
  coda        fs/coda/dir.c:182            attrs.va_mode = mode;     // type assigned by Venus userspace server
  hostfs      fs/hostfs/hostfs_kern.c:698  err = do_mkdir(file, mode);  // type re-read from host stat()
  cifs        fs/smb/client/inode.c:2253   cifs_mkdir(...)  // SMB protocol carries dir-vs-file separately, not in mode
  ecryptfs    fs/ecryptfs/inode.c:521      vfs_mkdir(&nop_mnt_idmap, lower_dir, ...)  // delegates to lower fs (cat.
  A/B)
  bad_inode   fs/bad_inode.c:64            return ERR_PTR(-EIO);     // never creates anything

  These ignore the type field of mode entirely (or never create an inode), so a pre-set S_IFDIR is irrelevant.

  D. Pseudo-filesystems — mode is permission-only or dropped

  configfs    fs/configfs/dir.c            mode unused; dir created by make_group()/make_item() callbacks
  kernfs      fs/kernfs/dir.c:1382         scops->mkdir(parent, dentry->d_name.name, mode)  // passed on, never
  type-switched
  resctrl     fs/resctrl/rdtgroup.c:3936   rdtgroup_mkdir() branches on parent/name, not on mode's type bits
  tracefs     fs/tracefs/inode.c:~222      tracefs_ops.mkdir(name.name.name)  // mode dropped entirely

Jori Koolstra (1):
  vfs: pass S_IFDIR mode to vfs_prepare_mode()

 fs/namei.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

-- 
2.54.0

