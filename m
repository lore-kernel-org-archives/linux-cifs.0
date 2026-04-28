Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34D543CECE;
	Tue, 28 Apr 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777397297; cv=none; b=AO+7wqUVqI4zLEYMvA241rDcSs4IHEyKOzczHeNYn765poJzg1o5wJtdG5mhy/0O0vFEeB/2OYrupGWVvKjl0g54dV+nRwGtLG4Tx2wjPiGApkQAwzmQprpT/4ellBFYJNniwiN2SLwnrPHM0ssHoyUcvcNHjyKW+xg6MYTzCNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777397297; c=relaxed/simple;
	bh=aK1A0F52g1hEvh2240PVi8iidcBqxIpd6FloalqeCR0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=G3ByD/na+4eiMH50wXaeAzS6hDq1+U/49InEmxwuTd1c0b9cT5m12gy8qoKjc7kXqxOEkKA5wUJMq9mbL+b5waJ9GLY1JEE6pMgT76jLe8Hoq3VvUWYfBNYq7bgq2H1kMPXOEAAPlTXJ6t6HKbjiJMYGjk+n2ln/9fw6jOEOsYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=IB2Qdp55; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="IB2Qdp55"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G1J5OR3MUF730xBsui9yjwFfvvjC4RiDCVHbp7kYe74=; b=IB2Qdp556p5N5+ybQOgDxtxtwz
	YD2f1IKgFPnWbNncPmBG6H2HalQTSP2g1SNFYNaVOcDVslsPMWNspKMM6rDLa9asiEP2N7hjOBbe7
	h9o4nDtfKnEXtjbuC6h6SILf4NUR/C8PkIqcXSEgvpDuP1QFqMjmAw9xG3geWkRajILd15Pu6Cp6x
	KJxeErRkl4DLnwlE78d9O3e9XFC7IEzwcPsL/ae67W63mNGwFR7NRylW9HpPe+iKx8CeXThs5Im+1
	BAoAL88qiUSndZ7EZBzgnISTCjQEZTvKnI34alFbhxI+XWRR6OoLhwtvGBJtglmQvk3XItRLjPlK3
	KqZBfpdQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wHmEF-0000000043A-2kKy;
	Tue, 28 Apr 2026 14:28:11 -0300
Message-ID: <d43b1d1023d13746819a780f65da9341@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
 bharathsm@microsoft.com, dhowells@redhat.com, henrique.carvalho@suse.com,
 ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 03/19] cifs: invalidate cfid on unlink/rename/rmdir
In-Reply-To: <20260428160804.281745-3-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
 <20260428160804.281745-3-sprasad@microsoft.com>
Date: Tue, 28 Apr 2026 14:28:11 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today we do not invalidate the cached_dirent or the entire
> parent cfid when a dentry in a dir has been removed/moved.
>
> This change invalidates the parent cfid so that we don't serve
> directory contents from the cache.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/inode.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 888f9e35f14b8..e077df844c819 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -28,6 +28,23 @@
>  #include "cached_dir.h"
>  #include "reparse.h"
>  
> +static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
> +				       struct dentry *parent)
> +{
> +	struct cached_fid *parent_cfid = NULL;
> +
> +	if (!tcon || !parent)
> +		return;

The NULL check for @tcon is unnecessary.  This seems to be called only
with a valid @tcon.

> +
> +	if (!open_cached_dir_by_dentry(tcon, parent, &parent_cfid)) {
> +		mutex_lock(&parent_cfid->dirents.de_mutex);
> +		parent_cfid->dirents.is_valid = false;
> +		parent_cfid->dirents.is_failed = true;
> +		mutex_unlock(&parent_cfid->dirents.de_mutex);
> +		close_cached_dir(parent_cfid);
> +	}
> +}
> +
>  /*
>   * Set parameters for the netfs library
>   */
> @@ -322,7 +339,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
>  				fattr->cf_uid = uid;
>  		}
>  	}
> -	
> +

Why are you adding a blank newline?

>  	fattr->cf_gid = cifs_sb->ctx->linux_gid;
>  	if (!(sbflags & CIFS_MOUNT_OVERR_GID)) {
>  		u64 id = le64_to_cpu(info->Gid);
> @@ -2067,6 +2084,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
>  		cifs_set_file_info(inode, attrs, xid, full_path, origattr);
>  
>  out_reval:
> +	if (!rc && dentry->d_parent)
> +		cifs_invalidate_cached_dir(tcon, dentry->d_parent);

The non-NULL check of @dentry->d_parent is unnecessary.
cifs_invalidate_cached_dir() already handles it.

> +
>  	if (inode) {
>  		cifs_inode = CIFS_I(inode);
>  		cifs_inode->time = 0;	/* will force revalidate to get info
> @@ -2378,7 +2398,6 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  	}
>  
>  	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
> -	cifs_put_tlink(tlink);
>  
>  	cifsInode = CIFS_I(d_inode(direntry));
>  
> @@ -2388,6 +2407,8 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  		i_size_write(d_inode(direntry), 0);
>  		clear_nlink(d_inode(direntry));
>  		spin_unlock(&d_inode(direntry)->i_lock);
> +		if (direntry->d_parent)
> +			cifs_invalidate_cached_dir(tcon, direntry->d_parent);

Ditto.

>  	}
>  
>  	/* force revalidate to go get info when needed */
> @@ -2402,6 +2423,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
>  
>  	inode_set_ctime_current(d_inode(direntry));
>  	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	cifs_put_tlink(tlink);
>  
>  rmdir_exit:
>  	free_dentry_path(page);
> @@ -2501,6 +2523,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>  	struct cifs_sb_info *cifs_sb;
>  	struct tcon_link *tlink;
>  	struct cifs_tcon *tcon;
> +	struct dentry *source_parent;
> +	struct dentry *target_parent;
>  	bool rehash = false;
>  	unsigned int xid;
>  	int rc, tmprc;
> @@ -2532,6 +2556,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>  	if (IS_ERR(tlink))
>  		return PTR_ERR(tlink);
>  	tcon = tlink_tcon(tlink);
> +	source_parent = source_dentry->d_parent ? dget(source_dentry->d_parent) : NULL;
> +	target_parent = target_dentry->d_parent ? dget(target_dentry->d_parent) : NULL;

Why do you need to dget() ->d_parent?

>  	server = tcon->ses->server;
>  
>  	page1 = alloc_dentry_path();
> @@ -2668,11 +2694,21 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>  	}
>  
>  	/* force revalidate to go get info when needed */
> +	if (!rc) {
> +		cifs_invalidate_cached_dir(tcon, source_parent);
> +		if (target_parent != source_parent)
> +			cifs_invalidate_cached_dir(tcon, target_parent);
> +	}
> +
>  	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
>  
>  cifs_rename_exit:
>  	if (rehash)
>  		d_rehash(target_dentry);
> +	if (target_parent)
> +		dput(target_parent);
> +	if (source_parent)
> +		dput(source_parent);

The non-NULL checks are unnecessary.  dput() already handles NULL
dentries.
