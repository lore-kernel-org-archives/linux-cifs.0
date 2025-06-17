Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C798D29AB01;
	Tue, 17 Jun 2025 23:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201305; cv=none; b=uEOAngl0ifSCJre+fqJUMnpSbyE4O0hbT8fG0iHY2dExtv9nQ9yLxYNCPHj8E9n2i7VrabwONDAFwIjGmiPdNq7Cd3751IcGcIEBEGFEMz+FETNq1cM1vXcEs3O4TKlSQEr6D7fxHOAC6X5xCxVLoQQjrrmVhA0vpPrBDw3zcs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201305; c=relaxed/simple;
	bh=sW9D2EHGGn3o2Fs2xK6qkO6wuWSgYC+g3Nwo5SJlKDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYtss8QmVM4rVnGYPTdYvcpre4gz8PNyUnBGcgZZmA4duCqLiXEFLN30fN/QjIbJh6NBZHPVmvp+hmjjSjxoF+E5PcZlUGIK5Yhsvb+/HBe0BiGqBBmXSZCSDfsLyZILQMxtpx0ae1A1N4G7KMFWA/YLCOmhzFkqBDTVZnB5HzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AR6xNRkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AR6xNRkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B41BC4CEF0;
	Tue, 17 Jun 2025 23:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750201305;
	bh=sW9D2EHGGn3o2Fs2xK6qkO6wuWSgYC+g3Nwo5SJlKDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AR6xNRkgFOcc4t7FHQex+AoSNu323Qo9zRqJMere6xByX2YfMejtDEWShszi1DL5+
	 IwDxdCvEDP5Jhw3dYOOe0zy/ZR70kg+J7jl1nFISCHOdcy07KBBGbfRNmix2ddQz1c
	 zcxIMpAThI0m/XhH81lQweQPfLXW6x8zY+LeQEgWppDMxUf8KVeydaPLAw3fTWF3Yw
	 Ja41CjpDLVqF3RgUSBjf68n5DvWfKtAf05MEw5b1n6W1UBa6vG6J7P+DHJernyif43
	 8bIYHtQ0qaXr+KVTqvC5k0pTOTmN2/vOVGGgpH1fs5AhyvMLGh1V7sH+PYypc7vJGb
	 jaY+dh7KzQt5A==
Received: by pali.im (Postfix)
	id F2E704D5; Wed, 18 Jun 2025 01:01:42 +0200 (CEST)
Date: Wed, 18 Jun 2025 01:01:42 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cifs: Show reason why autodisabling serverino support
Message-ID: <20250617230142.ol3rc76uamwsd4rk@pali>
References: <20250610172221.ihsrjrikbiijyb4n@pali>
 <20250610181502.15839-1-pali@kernel.org>
 <470d6baeb8e569aa1587de19c46f43c2@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <470d6baeb8e569aa1587de19c46f43c2@manguebit.org>
User-Agent: NeoMutt/20180716

On Tuesday 17 June 2025 19:23:15 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Extend cifs_autodisable_serverino() function to print also text message why
> > the function was called.
> >
> > The text message is printed just once for mount then autodisabling
> > serverino support. Once the serverino support is disabled for mount it will
> > not be re-enabled. So those text messages do not cause flooding logs.
> >
> > This change allows to debug issues why cifs.ko decide to turn off server
> > inode number support and hence disable support for detection of hardlinks.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> > Paulo and Tom, could you check if this change is better now for you?
> > It should address problems with logs flooding and also information about
> > harlinks (it is already printed as can be seen also in this diff).
> > I would like to get your ACK, so I'm trying to improve it.
> > ---
> >  fs/smb/client/cifsproto.h | 2 +-
> >  fs/smb/client/connect.c   | 2 +-
> >  fs/smb/client/dfs_cache.c | 2 +-
> >  fs/smb/client/inode.c     | 6 +++---
> >  fs/smb/client/misc.c      | 6 +++++-
> >  fs/smb/client/readdir.c   | 4 ++--
> >  6 files changed, 13 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index d550662b4e72..07a67c8c37ce 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -586,9 +586,9 @@ extern int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
> >  			   const struct nls_table *nls_codepage, int remap);
> >  extern int CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
> >  			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
> >  #endif /* CIFS_ALLOW_INSECURE_LEGACY */
> > -extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
> > +extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char *reason, int rc);
> >  extern bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
> >  extern int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> >  			      struct cifs_sb_info *cifs_sb,
> >  			      struct cifs_fattr *fattr,
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 6bf04d9a5491..819721dfd5bb 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -3907,9 +3907,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
> >  	/*
> >  	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
> >  	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
> >  	 */
> > -	cifs_autodisable_serverino(cifs_sb);
> > +	cifs_autodisable_serverino(cifs_sb, "Reconnecting to different server, inode numbers won't match anymore", 0);
> 
> We are mounting an DFS share, not reconnecting.  The message is
> misleading.

I mostly copied the comment above the cifs_autodisable_serverino() call.
Does it mean that the existing comment about reconnecting is wrong too?

> >  	/*
> >  	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
> >  	 * that have different prefix paths.
> >  	 */
> > diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
> > index 4dada26d56b5..c3fe85c31e2b 100644
> > --- a/fs/smb/client/dfs_cache.c
> > +++ b/fs/smb/client/dfs_cache.c
> > @@ -1288,9 +1288,9 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
> >  	/*
> >  	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
> >  	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
> >  	 */
> > -	cifs_autodisable_serverino(cifs_sb);
> > +	cifs_autodisable_serverino(cifs_sb, "Reconnecting to different server, inode numbers won't match anymore", 0);
> 
> Ditto.
> 
> >  	/*
> >  	 * Force the use of prefix path to support failover on DFS paths that resolve to targets
> >  	 * that have different prefix paths.
> >  	 */
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index cd06598eacbd..b1c6e3986278 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -1076,9 +1076,9 @@ static void cifs_set_fattr_ino(int xid, struct cifs_tcon *tcon, struct super_blo
> >  		if (*inode)
> >  			fattr->cf_uniqueid = CIFS_I(*inode)->uniqueid;
> >  		else {
> >  			fattr->cf_uniqueid = iunique(sb, ROOT_I);
> > -			cifs_autodisable_serverino(cifs_sb);
> > +			cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number via get_srv_inum", rc);
> 
> Looks good.
> 
> >  		}
> >  		return;
> >  	}
> >  
> > @@ -1529,9 +1529,9 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
> >  		if (fattr->cf_flags & CIFS_FATTR_INO_COLLISION) {
> >  			fattr->cf_flags &= ~CIFS_FATTR_INO_COLLISION;
> >  
> >  			if (inode_has_hashed_dentries(inode)) {
> > -				cifs_autodisable_serverino(CIFS_SB(sb));
> > +				cifs_autodisable_serverino(CIFS_SB(sb), "Inode number collision detected", 0);
> 
> Looks good.
> 
> >  				iput(inode);
> >  				fattr->cf_uniqueid = iunique(sb, ROOT_I);
> >  				goto retry_iget5_locked;
> >  			}
> > @@ -1596,9 +1596,9 @@ struct inode *cifs_root_iget(struct super_block *sb)
> >  iget_root:
> >  	if (!rc) {
> >  		if (fattr.cf_flags & CIFS_FATTR_JUNCTION) {
> >  			fattr.cf_flags &= ~CIFS_FATTR_JUNCTION;
> > -			cifs_autodisable_serverino(cifs_sb);
> > +			cifs_autodisable_serverino(cifs_sb, "Cannot retrieve attributes for junction point", rc);
> 
> This has nothing to do with not being able to retrieve attributes.  It
> is simply disabling 'serverino' to prevent inode collisions with
> surrogate reparse points (automounts).  This should also printed with
> FYI.

Ok. So then I misunderstood the code around. Do you know when exactly
can this case happen? And it is really a problem? Because name surrogate
reparse point already creates a new mount hierarchy for which is
generated new st_dev major and minor numbers and hence inode collisions
should not happen (they do not share st_dev anymore).

> >  		}
> >  		inode = cifs_iget(sb, &fattr);
> >  	}
> >  
> > diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> > index e77017f47084..409277883e8a 100644
> > --- a/fs/smb/client/misc.c
> > +++ b/fs/smb/client/misc.c
> > @@ -551,9 +551,9 @@ dump_smb(void *buf, int smb_buf_length)
> >  		       smb_buf_length, true);
> >  }
> >  
> >  void
> > -cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
> > +cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char *reason, int rc)
> >  {
> >  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
> >  		struct cifs_tcon *tcon = NULL;
> >  
> > @@ -561,8 +561,12 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
> >  			tcon = cifs_sb_master_tcon(cifs_sb);
> >  
> >  		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
> >  		cifs_sb->mnt_cifs_serverino_autodisabled = true;
> > +		if (rc)
> > +			cifs_dbg(VFS, "%s: %d\n", reason, rc);
> > +		else
> > +			cifs_dbg(VFS, "%s\n", reason);
> >  		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s\n",
> >  			 tcon ? tcon->tree_name : "new server");
> >  		cifs_dbg(VFS, "The server doesn't seem to support them properly or the files might be on different servers (DFS)\n");
> >  		cifs_dbg(VFS, "Hardlinks will not be recognized on this mount. Consider mounting with the \"noserverino\" option to silence this message.\n");
> > diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> > index 787d6bcb5d1d..06e90921f751 100644
> > --- a/fs/smb/client/readdir.c
> > +++ b/fs/smb/client/readdir.c
> > @@ -412,9 +412,9 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
> >  	if (rc == 0) {
> >  		cifsFile->invalidHandle = false;
> >  	} else if ((rc == -EOPNOTSUPP) &&
> >  		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
> > -		cifs_autodisable_serverino(cifs_sb);
> > +		cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number via query_dir_first", rc);
> 
> Looks good.
> 
> >  		goto ffirst_retry;
> >  	}
> >  error_exit:
> >  	cifs_put_tlink(tlink);
> > @@ -1006,9 +1006,9 @@ static int cifs_filldir(char *find_entry, struct file *file,
> >  	if (de.ino && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
> >  		fattr.cf_uniqueid = de.ino;
> >  	} else {
> >  		fattr.cf_uniqueid = iunique(sb, ROOT_I);
> > -		cifs_autodisable_serverino(cifs_sb);
> > +		cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inode number", 0);
> 
> Perhaps also mention which function it wasn't able to retrieve inode
> number from like above?

I quickly look at this code around and I was not able to figure out what
is that function which was not able to retrieve inode. So I did not
write it into the message. Do you know, or could you figure out what is
that function / callback?
