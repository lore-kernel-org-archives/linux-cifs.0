Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879E240BCB3
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781192032; cv=none; b=u8kVY+Ky2t66oMKbuBFZOM3Dj/h3lgwAugKdACyOf5xaFjKvklD+VgpfEtQENoEso5Plwo1j9OHIf88YW7QJMliDpE1XlpV6WRuRvtedxOQXdN98UHtPlwxT5nP6ObWTRxiyoa4eYd7qPtnDqaJGwdbAMAwHmbEZCQtUu2Z9jjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781192032; c=relaxed/simple;
	bh=DJZNWltygh7n32wiepOQlNy4iRac0MmrbqElhk5ZGMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCj54R6vQ2eL+YUhRQGs+Sh2Rg6RDifXFANE5vL0lCQF8DDEVheaHzNSIweodzkBFA99YyaUL8VuPd5woa9rG/DV5b3PwFs8TDCf+KWkOZQg8/TqU+o4AIRT7cNNrL4WTsM+rfOBc2yn+vhH+lN8r2zzJbtKbtM4T1/2nr3B7gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mFufpgsW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gFi8oInp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mFufpgsW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gFi8oInp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mFufpgsW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gFi8oInp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mFufpgsW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gFi8oInp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9503F6AF82;
	Thu, 11 Jun 2026 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781192017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qI1DCrjojIvfp4V0fb9SUexR3zxzsh3I/Dr0x91vqc=;
	b=mFufpgsWB6k/Niyuk7xxzDDEBsr386bmlLR0UzQUgYRJUGyInoUT9vRqLUweUh6PQ7vV3R
	dr7w04dT+XoUyt/ZpEjxG/rdTJplv9MAeVpLD+ppccJTQckNETF3Q9lBbZVWKDpZjPDhAc
	stDGfTj+xMwruMfw2U1XnX4tQGoouoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781192017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qI1DCrjojIvfp4V0fb9SUexR3zxzsh3I/Dr0x91vqc=;
	b=gFi8oInpkDgn3AGR0VVI5zDz1HfuAmOe7tfAw0MlMy5MTbgjRJNgc51mG7WegKdokZ0hQ3
	CcpgrG2vyyouuOBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781192017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qI1DCrjojIvfp4V0fb9SUexR3zxzsh3I/Dr0x91vqc=;
	b=mFufpgsWB6k/Niyuk7xxzDDEBsr386bmlLR0UzQUgYRJUGyInoUT9vRqLUweUh6PQ7vV3R
	dr7w04dT+XoUyt/ZpEjxG/rdTJplv9MAeVpLD+ppccJTQckNETF3Q9lBbZVWKDpZjPDhAc
	stDGfTj+xMwruMfw2U1XnX4tQGoouoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781192017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8qI1DCrjojIvfp4V0fb9SUexR3zxzsh3I/Dr0x91vqc=;
	b=gFi8oInpkDgn3AGR0VVI5zDz1HfuAmOe7tfAw0MlMy5MTbgjRJNgc51mG7WegKdokZ0hQ3
	CcpgrG2vyyouuOBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8366B779A7;
	Thu, 11 Jun 2026 15:33:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zl4SIFHVKmrwEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Jun 2026 15:33:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E55B6A10CE; Thu, 11 Jun 2026 17:33:36 +0200 (CEST)
Date: Thu, 11 Jun 2026 17:33:36 +0200
From: Jan Kara <jack@suse.cz>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>, 
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Message-ID: <7iocwlr7jg2jiyx53q7lxaccrybu6fpv6ch36u64igdmddafdk@3ejeqvr4e7rh>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260611145733.43776-1-jkoolstra@xs4all.nl>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[xs4all.nl];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,xs4all.nl];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,samba.org,gmail.com,zeniv.linux.org.uk,brown.name,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Thu 11-06-26 16:57:06, Jori Koolstra wrote:
> There is a comment in vfs_prepare_mode() that says:
> 
>   Note that it's currently valid for @type to be 0 if a directory is
>   created. Filesystems raise that flag individually and we need to check
>   whether each filesystem can deal with receiving S_IFDIR from the vfs
>   before we enforce a non-zero type.
> 
> This is a bit challenging since there are many filesystems. Claude Opus
> 4.8 was used to generate the context for each mkdir implementation from
> which it can be judged whether passing S_IFDIR is safe. The result was
> then verified by hand by looking at how the mode argument is used in
> each case. To check whether all mkdir implementations are convered,
> 'rg "\.mkdir" ' was used and checked against the list of uses Claude
> found.
> 
> The only mkdir implementation that I am not as sure of is
> cifs_mkdir(). So this goes cc to the cifs people. But of course, I might
> have made errors in other places (except probably not for the A list as
> those are all just mode | S_IFDIR cases without other uses of mode
> besides logging)

For the filesystems I know this looks sound. Thanks for the cleanup. But
this series should then follow with the removal of now-pointless "|
S_IFDIR" statements.

								Honza

> This is the AI context I worked with:
> 
> Here's each filesystem with the exact line(s) that make it safe, grouped by why.
> 
>   A. Forces S_IFDIR itself (redundant if pre-set → harmless)
> 
>   9p          fs/9p/vfs_inode.c:683        perm = unixmode2p9mode(v9ses, mode | S_IFDIR);
>   9p (dotl)   fs/9p/vfs_inode_dotl.c:365   omode |= S_IFDIR;
>   affs        fs/affs/namei.c:290          inode->i_mode = S_IFDIR | mode;
>   afs         fs/afs/dir.c:1326            op->create.mode = S_IFDIR | mode;
>   autofs      fs/autofs/root.c:744         inode = autofs_get_inode(dir->i_sb, S_IFDIR | mode);
>   btrfs       fs/btrfs/inode.c:7123        inode_init_owner(idmap, inode, dir, S_IFDIR | mode);
>   ceph        fs/ceph/dir.c:1145           mode |= S_IFDIR;
>   ext2        fs/ext2/namei.c:239          inode = ext2_new_inode(dir, S_IFDIR | mode, &dentry->d_name);
>   ext4        fs/ext4/namei.c:3012         inode = ext4_new_inode_start_handle(idmap, dir, S_IFDIR | mode,
>   f2fs        fs/f2fs/namei.c:745          inode = f2fs_new_inode(idmap, dir, S_IFDIR | mode, NULL);
>   fuse        fs/fuse/dir.c:1131           return create_new_entry(idmap, fm, &args, dir, entry, S_IFDIR);
>   gfs2        fs/gfs2/inode.c:1351         gfs2_create_inode(dir, dentry, NULL, S_IFDIR | mode, ...)
>   hfs         fs/hfs/dir.c:228             inode = hfs_new_inode(dir, &dentry->d_name, S_IFDIR | mode);
>   hfsplus     fs/hfsplus/dir.c:579         hfsplus_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0)
>   hpfs        fs/hpfs/namei.c:66           result->i_mode |= S_IFDIR;
>   hugetlbfs   fs/hugetlbfs/inode.c:974     mode | S_IFDIR, 0);
>   jffs2       fs/jffs2/dir.c:465           mode |= S_IFDIR;
>   jfs         fs/jfs/namei.c:226           ip = ialloc(dip, S_IFDIR | mode);
>   minix       fs/minix/namei.c:113         inode = minix_new_inode(dir, S_IFDIR | mode);
>   nilfs2      fs/nilfs2/namei.c:234        inode = nilfs_new_inode(dir, S_IFDIR | mode);
>   ntfs3       fs/ntfs3/namei.c:216         S_IFDIR | mode, 0, NULL, 0, NULL));
>   ocfs2       fs/ocfs2/namei.c:660         ocfs2_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
>   dlmfs       fs/ocfs2/dlmfs/dlmfs.c:425   inode = dlmfs_get_inode(dir, dentry, mode | S_IFDIR);
>   omfs        fs/omfs/dir.c:285            return ERR_PTR(omfs_add_node(dir, dentry, mode | S_IFDIR));
>   orangefs    fs/orangefs/namei.c:336      orangefs_new_inode(dir->i_sb, dir, S_IFDIR | mode, 0, &ref);
>   ramfs       fs/ramfs/inode.c:124         ramfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);
>   ubifs       fs/ubifs/dir.c:1034          inode = ubifs_new_inode(c, dir, S_IFDIR | mode, false);
>   udf         fs/udf/namei.c:431           inode = udf_new_inode(dir, S_IFDIR | mode);
>   ufs         fs/ufs/namei.c:177           inode = ufs_new_inode(dir, S_IFDIR|mode);
>   xfs         fs/xfs/xfs_iops.c:309        xfs_generic_create(idmap, dir, dentry, mode | S_IFDIR, 0, NULL)
>   nfs         fs/nfs/dir.c:2475            attr.ia_mode = mode | S_IFDIR;
> 
>   B. Masks the type bits away before use (pre-set S_IFDIR stripped)
> 
>   overlayfs   fs/overlayfs/dir.c:743       ovl_create_object(dentry, (mode & 07777) | S_IFDIR, 0, NULL)
>   vboxsf      fs/vboxsf/dir.c:272-273      params.info.attr.mode = (mode & 0777) |
>                                              (is_dir ? SHFL_TYPE_DIRECTORY : SHFL_TYPE_FILE);
>   nfs (v3)    fs/nfs/nfs3xdr.c:562         *p++ = cpu_to_be32(attr->ia_mode & S_IALLUGO);
>   nfs (v4)    fs/nfs/nfs4xdr.c:1170,1196   *p++ = cpu_to_be32(iap->ia_mode & S_IALLUGO);
> 
>   C. Type comes from elsewhere — incoming mode's type is never consulted
> 
>   exfat       fs/exfat/namei.c:856         exfat_add_entry(dir, ..., TYPE_DIR, &info);   // literal dir type
>   fat/msdos   fs/fat/namei_msdos.c:376     msdos_add_entry(dir, ..., 1, ...);            // is_dir=1 literal
>   fat/vfat    fs/fat/namei_vfat.c:867      vfat_add_entry(dir, &dentry->d_name, 1, ...); // is_dir=1 literal
>   coda        fs/coda/dir.c:182            attrs.va_mode = mode;     // type assigned by Venus userspace server
>   hostfs      fs/hostfs/hostfs_kern.c:698  err = do_mkdir(file, mode);  // type re-read from host stat()
>   cifs        fs/smb/client/inode.c:2253   cifs_mkdir(...)  // SMB protocol carries dir-vs-file separately, not in mode
>   ecryptfs    fs/ecryptfs/inode.c:521      vfs_mkdir(&nop_mnt_idmap, lower_dir, ...)  // delegates to lower fs (cat.
>   A/B)
>   bad_inode   fs/bad_inode.c:64            return ERR_PTR(-EIO);     // never creates anything
> 
>   These ignore the type field of mode entirely (or never create an inode), so a pre-set S_IFDIR is irrelevant.
> 
>   D. Pseudo-filesystems — mode is permission-only or dropped
> 
>   configfs    fs/configfs/dir.c            mode unused; dir created by make_group()/make_item() callbacks
>   kernfs      fs/kernfs/dir.c:1382         scops->mkdir(parent, dentry->d_name.name, mode)  // passed on, never
>   type-switched
>   resctrl     fs/resctrl/rdtgroup.c:3936   rdtgroup_mkdir() branches on parent/name, not on mode's type bits
>   tracefs     fs/tracefs/inode.c:~222      tracefs_ops.mkdir(name.name.name)  // mode dropped entirely
> 
> Jori Koolstra (1):
>   vfs: pass S_IFDIR mode to vfs_prepare_mode()
> 
>  fs/namei.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
