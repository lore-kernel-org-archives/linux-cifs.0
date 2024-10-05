Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D2D15AF6;
	Sat,  5 Oct 2024 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137299; cv=none; b=avS6bpfHzaXYsti4ITGQAbPK+1sSdr7Fk5O2PYWqDgc968UZNz5N+9gpsmBZg8gNbaLYfIxhFg5Ry1WEY0Qs0iYsas8xNxN2bwbnXB31Ih0KViFtOqeRUZDgXmecSofsVvfeY3y5o9XQC95XosQwjrN0Zi0S06RR9wIbyRy8ubU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137299; c=relaxed/simple;
	bh=197aaP8UlND6oQt7Yx9UkHED9QP2gF1svlEV5jVAhig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5RjLZIEWOowwZlQ+it7EPM3Z7CGldJyC85Fj8C5g0ng+3XZPMov39TjejdHtyxUflG+laXH/+HMeL12giu+sMAITIQs5DdV7Sm0/W5Gdes/Z+wlDgw3OUcaDvB7mFC+VjotOy4v1k82lAi+UNjbOEHKMDs0iXz0rm2C3oxnTAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6WkyRqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6WkyRqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD37DC4CEC2;
	Sat,  5 Oct 2024 14:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137299;
	bh=197aaP8UlND6oQt7Yx9UkHED9QP2gF1svlEV5jVAhig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q6WkyRqLOhu04jMlkNUmfBjuVbAUkPt0JWomfwGQa9LNJhnaZYIMJj8OBsoxxoEly
	 ZARGokm2pQHqhO5bOb7dP7GVzqcfDuunBK8OOg4JJFVJN/E6VlxMcc9Mc3dAkz/GEP
	 PP8z7PCMrTKfqT8F/lQcX612U30SEfifUEl81BlJsTXkaLW254X5uAVgEXsa8z7ZFn
	 YK35GrKLNmmhaakRSoIVl1vFUZk/ROhn1O3gQTXPXmbda9HkaGleK5CH+pmMAGEIdz
	 y5qBbSCU8JwPZdbRDO/eoq4yHZ59/BFxhQfGE4Z52J37K50TMgSLMgwMQqpJwDHwbw
	 y3hk3JpavU/3w==
Received: by pali.im (Postfix)
	id A7C97648; Sat,  5 Oct 2024 16:08:13 +0200 (CEST)
Date: Sat, 5 Oct 2024 16:08:13 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] cifs: Improve creating native symlinks pointing to
 directory
Message-ID: <20241005140813.3lmqjwcg2kli5jvm@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-3-pali@kernel.org>
 <76a3103261ea1be01a83acec8c0db2d4@manguebit.com>
 <20240930171715.blyid7rqfse7bwm7@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240930171715.blyid7rqfse7bwm7@pali>
User-Agent: NeoMutt/20180716

On Monday 30 September 2024 19:17:15 Pali Rohár wrote:
> On Monday 30 September 2024 12:09:48 Paulo Alcantara wrote:
> > Pali Rohár <pali@kernel.org> writes:
> > 
> > > SMB protocol for native symlinks distinguish between symlink to directory
> > > and symlink to file. These two symlink types cannot be exchanged, which
> > > means that symlink of file type pointing to directory cannot be resolved at
> > > all (and vice-versa).
> > >
> > > Windows follows this rule for local filesystems (NTFS) and also for SMB.
> > >
> > > Linux SMB client currenly creates all native symlinks of file type. Which
> > > means that Windows (and some other SMB clients) cannot resolve symlinks
> > > pointing to directory created by Linux SMB client.
> > >
> > > As Linux system does not distinguish between directory and file symlinks,
> > > its API does not provide enough information for Linux SMB client during
> > > creating of native symlinks.
> > >
> > > Add some heuristic into the Linux SMB client for choosing the correct
> > > symlink type during symlink creation. Check if the symlink target location
> > > ends with slash, or last path component is dot or dot dot, and check if the
> > > target location on SMB share exists and is a directory. If at least one
> > > condition is truth then create a new SMB symlink of directory type.
> > > Otherwise create it as file type symlink.
> > >
> > > This change improves interoperability with Windows systems. Windows systems
> > > would be able to resolve more SMB symlinks created by Linux SMB client
> > > which points to existing directory.
> > >
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > ---
> > >  fs/smb/client/reparse.c   | 131 ++++++++++++++++++++++++++++++++++++--
> > >  fs/smb/client/smb2inode.c |   3 +-
> > >  fs/smb/client/smb2proto.h |   1 +
> > >  3 files changed, 130 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > index 507e17244ed3..9390ab801696 100644
> > > --- a/fs/smb/client/reparse.c
> > > +++ b/fs/smb/client/reparse.c
> > > @@ -24,13 +24,16 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
> > >  	struct inode *new;
> > >  	struct kvec iov;
> > >  	__le16 *path;
> > > +	bool directory = false;
> > >  	char *sym, sep = CIFS_DIR_SEP(cifs_sb);
> > >  	u16 len, plen;
> > >  	int rc = 0;
> > >  
> > > -	sym = kstrdup(symname, GFP_KERNEL);
> > > +	len = strlen(symname)+1;
> > > +	sym = kzalloc(len+1, GFP_KERNEL); /* +1 for possible directory slash */
> > >  	if (!sym)
> > >  		return -ENOMEM;
> > > +	memcpy(sym, symname, len);
> > >  
> > >  	data = (struct cifs_open_info_data) {
> > >  		.reparse_point = true,
> > > @@ -45,6 +48,125 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
> > >  		goto out;
> > >  	}
> > >  
> > > +	/*
> > > +	 * SMB distinguish between symlink to directory and symlink to file.
> > > +	 * They cannot be exchanged (symlink of file type which points to
> > > +	 * directory cannot be resolved and vice-versa). First do some simple
> > > +	 * check, if the original Linux symlink target ends with slash, or
> > > +	 * last path component is dot or dot dot then it is for sure symlink
> > > +	 * to the directory.
> > > +	 */
> > > +	if (!directory) {
> > > +		const char *basename = kbasename(symname);
> > > +		int basename_len = strlen(basename);
> > > +		if (basename_len == 0 || /* symname ends with slash */
> > > +		    (basename_len == 1 && basename[0] == '.') || /* last component is "." */
> > > +		    (basename_len == 2 && basename[0] == '.' && basename[1] == '.')) /* last component is ".." */
> > > +			directory = true;
> > > +	}
> > > +
> > > +	/*
> > > +	 * If it was not detected as directory yet and the symlink is relative
> > > +	 * then try to resolve the path on the SMB server, check if the path
> > > +	 * exists and determinate if it is a directory or not.
> > > +	 */
> > > +	if (!directory && symname[0] != '/') {
> > > +		__u32 oplock;
> > > +		struct tcon_link *tlink;
> > > +		struct cifs_tcon *tcon;
> > > +		struct cifs_fid fid;
> > > +		struct cifs_open_parms oparms;
> > > +		char *resolved_path;
> > > +		char *path_sep;
> > > +		int open_rc;
> > > +		int full_path_len = strlen(full_path);
> > > +		int symname_len = strlen(symname);
> > > +
> > > +		tlink = cifs_sb_tlink(cifs_sb);
> > > +		if (IS_ERR(tlink)) {
> > > +			rc = PTR_ERR(tlink);
> > > +			goto out;
> > > +		}
> > > +
> > > +		resolved_path = kzalloc(full_path_len + symname_len + 1, GFP_KERNEL);
> > > +		if (!resolved_path) {
> > > +			rc = -ENOMEM;
> > > +			goto out;
> > > +		}
> > 
> > If !@resolved_path, then you will end up leaking @tlink.
> > 
> > > +
> > > +		/*
> > > +		 * Compose the resolved SMB symlink path from the SMB full path
> > > +		 * and Linux target symlink path.
> > > +		 */
> > > +		memcpy(resolved_path, full_path, full_path_len+1);
> > > +		path_sep = strrchr(resolved_path, sep);
> > > +		if (path_sep)
> > > +			path_sep++;
> > > +		else
> > > +			path_sep = resolved_path;
> > > +		memcpy(path_sep, symname, symname_len+1);
> > > +		if (sep == '\\')
> > > +			convert_delimiter(path_sep, sep);
> > > +
> > > +		tcon = tlink_tcon(tlink);
> > > +
> > > +		oparms = (struct cifs_open_parms) {
> > > +			.tcon = tcon,
> > > +			.cifs_sb = cifs_sb,
> > > +			.desired_access = FILE_READ_ATTRIBUTES,
> > > +			.disposition = FILE_OPEN,
> > > +			.path = resolved_path,
> > > +			.fid = &fid,
> > > +		};
> > 
> > Please use CIFS_OPARMS().
> > 
> > > +
> > > +		/* Try to open as NOT_FILE */
> > > +		oplock = 0;
> > > +		oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
> > > +		open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> > > +		if (open_rc == 0) {
> > > +			/* Successful open means that the target path is definitely a directory. */
> > > +			directory = true;
> > > +			tcon->ses->server->ops->close(xid, tcon, &fid);
> > > +		} else if (open_rc != -ENOTDIR) {
> > > +			/* Try to open as NOT_DIR */
> > > +			oplock = 0;
> > > +			oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
> > > +			open_rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> > > +			if (open_rc == 0) {
> > > +				tcon->ses->server->ops->close(xid, tcon, &fid);
> > > +			} else if (open_rc == -EISDIR) {
> > > +				/* -EISDIR means that the target path is definitely a directory. */
> > > +				directory = true;
> > > +			} else {
> > > +				cifs_dbg(FYI,
> > > +					 "%s: cannot determinate if the symlink target path '%s' "
> > > +					 "is directory or not, creating '%s' as file symlink\n",
> > > +					 __func__, symname, full_path);
> > > +			}
> > > +		}
> > > +
> > > +		kfree(resolved_path);
> > > +		cifs_put_tlink(tlink);
> > > +	}
> > > +
> > > +	/*
> > > +	 * For absolute symlinks it is not possible to determinate
> > > +	 * if it should point to directory or file.
> > > +	 */
> > > +	if (!directory && symname[0] == '/')
> > > +		cifs_dbg(FYI,
> > > +			 "%s: cannot determinate if the symlink target path '%s' "
> > > +			 "is directory or not, creating '%s' as file symlink\n",
> > > +			 __func__, symname, full_path);
> > > +
> > 
> > Create a helper with all of this and then call it in
> > smb2_create_reparse_symlink() to determine whether symlink target is a
> > directory or file.
> 
> Hello, thanks for review! Of course I will update this patch to address
> all your points.

Hello, I addresses this issues in V2 of the patch series. Please look at it.
