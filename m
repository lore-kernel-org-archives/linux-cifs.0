Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FAC329395
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 20:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775076202; cv=none; b=dCgDatZkbKeLNdSeGllF9otRbXGR6DI8Y6D+c5U1CjS/j4UBfh7OzOY/5KAXvq99b/F0SZ6i6k7RIdcYR1DNqvErw1UHup6zHE0ZihHz71IGK4zSMEO8EfyVfsNm8G+ewXn2l0O7gT6IjByT8vYF9yRwt7Y1B8US1a3wovjs928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775076202; c=relaxed/simple;
	bh=Z6yKSzg9z6Q8Z6xMLwRpBMR0dDVhaeIkTO0eV5vIW8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AU908SUBtJkq74ZHl6SxzTNZukkgUO/P5Bp3RwvwVH5LG2kSB2z3gYYWApCAmEAgUsSg6+JP4zTYYN6+PEVZx2j3nA5JRkeqOxuHDL0OX5pzTplAWzn9FnqggpimE9C2qfe7uZDbVKJlqCkGxLAv1lqoFXBOjTqByZg6lCnLu4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QsAWJGDv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZUU6DHpA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QsAWJGDv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZUU6DHpA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QsAWJGDv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZUU6DHpA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QsAWJGDv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZUU6DHpA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 687235BCC9;
	Wed,  1 Apr 2026 20:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775076198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oK7Aqq2TXPxO/UEdlSK0Z6IGqH5br8KBbbrXLzmaWLo=;
	b=QsAWJGDvMZAaCbG92bNvY44Ry+72VLa4oBXWLwZlLLOAcU1w4o9//SGGkeKtUyCTuqdnwH
	Vc4KefgXpckqhcRkyj3rqDPOIePFIKXxcgzwVddLnl0sDY07GbX0L9d38Pu/vco7IgVv/C
	v2NsJ3KGNPRwcJlIinCUqamZer38Wq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775076198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oK7Aqq2TXPxO/UEdlSK0Z6IGqH5br8KBbbrXLzmaWLo=;
	b=ZUU6DHpA72FvbvhDyqLEk5UQR+eX4sm4NIx7maPFPY2b4I5HCpBJ4+h6Hl7Y4v75j6E0WK
	BDLykJ/CFpkjH9Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775076198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oK7Aqq2TXPxO/UEdlSK0Z6IGqH5br8KBbbrXLzmaWLo=;
	b=QsAWJGDvMZAaCbG92bNvY44Ry+72VLa4oBXWLwZlLLOAcU1w4o9//SGGkeKtUyCTuqdnwH
	Vc4KefgXpckqhcRkyj3rqDPOIePFIKXxcgzwVddLnl0sDY07GbX0L9d38Pu/vco7IgVv/C
	v2NsJ3KGNPRwcJlIinCUqamZer38Wq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775076198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oK7Aqq2TXPxO/UEdlSK0Z6IGqH5br8KBbbrXLzmaWLo=;
	b=ZUU6DHpA72FvbvhDyqLEk5UQR+eX4sm4NIx7maPFPY2b4I5HCpBJ4+h6Hl7Y4v75j6E0WK
	BDLykJ/CFpkjH9Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50B864A0B0;
	Wed,  1 Apr 2026 20:43:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +H0cE2aDzWnBeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 20:43:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 00759A0B39; Wed,  1 Apr 2026 22:43:09 +0200 (CEST)
Date: Wed, 1 Apr 2026 22:43:09 +0200
From: Jan Kara <jack@suse.cz>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Namjae Jeon <linkinjeon@kernel.org>, 
	Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>, 
	Jeff Layton <jlayton@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: replace ints with enum component_type for
 LAST_XXX
Message-ID: <qugkhnjm7hzu46hw6xyosv2mqicr34gjuugdhgh4q3zehwh3pk@x26fuch2wixl>
References: <20260401174307.3887296-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401174307.3887296-1-jkoolstra@xs4all.nl>
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
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,xs4all.nl];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,gmail.com,chromium.org,talpey.com,brown.name,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[15];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Wed 01-04-26 19:43:03, Jori Koolstra wrote:
> Several functions in namei.c take an "int *type" parameter, such as
> filename_parentat(). To know what values this can take you have to find
> the anonymous struct that defines the LAST_XXX values. I would argue
> that the readability of the code is improved by making this an explicit
> type.
> 
> Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>

I guess less churn is better :). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> ---
> 
> v2: move back to LAST_XXX and change int to component_type in
> fs/smb/server/vfs.c.
> 
> ---
>  fs/namei.c            | 41 ++++++++++++++++++++++-------------------
>  fs/smb/server/vfs.c   |  5 +++--
>  include/linux/namei.h |  4 ++--
>  3 files changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 9e5500dad14f..a880454a6415 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -721,15 +721,15 @@ EXPORT_SYMBOL(path_put);
>  
>  #define EMBEDDED_LEVELS 2
>  struct nameidata {
> -	struct path	path;
> -	struct qstr	last;
> -	struct path	root;
> -	struct inode	*inode; /* path.dentry.d_inode */
> -	unsigned int	flags, state;
> -	unsigned	seq, next_seq, m_seq, r_seq;
> -	int		last_type;
> -	unsigned	depth;
> -	int		total_link_count;
> +	struct path		path;
> +	struct qstr		last;
> +	struct path		root;
> +	struct inode		*inode; /* path.dentry.d_inode */
> +	unsigned int		flags, state;
> +	unsigned		seq, next_seq, m_seq, r_seq;
> +	enum component_type	last_type;
> +	unsigned		depth;
> +	int			total_link_count;
>  	struct saved {
>  		struct path link;
>  		struct delayed_call done;
> @@ -2221,7 +2221,7 @@ static struct dentry *follow_dotdot(struct nameidata *nd)
>  	return dget(nd->path.dentry);
>  }
>  
> -static const char *handle_dots(struct nameidata *nd, int type)
> +static const char *handle_dots(struct nameidata *nd, enum component_type type)
>  {
>  	if (type == LAST_DOTDOT) {
>  		const char *error = NULL;
> @@ -2869,7 +2869,7 @@ static int path_parentat(struct nameidata *nd, unsigned flags,
>  /* Note: this does not consume "name" */
>  static int __filename_parentat(int dfd, struct filename *name,
>  			       unsigned int flags, struct path *parent,
> -			       struct qstr *last, int *type,
> +			       struct qstr *last, enum component_type *type,
>  			       const struct path *root)
>  {
>  	int retval;
> @@ -2894,7 +2894,7 @@ static int __filename_parentat(int dfd, struct filename *name,
>  
>  static int filename_parentat(int dfd, struct filename *name,
>  			     unsigned int flags, struct path *parent,
> -			     struct qstr *last, int *type)
> +			     struct qstr *last, enum component_type *type)
>  {
>  	return __filename_parentat(dfd, name, flags, parent, last, type, NULL);
>  }
> @@ -2963,7 +2963,8 @@ static struct dentry *__start_removing_path(int dfd, struct filename *name,
>  	struct path parent_path __free(path_put) = {};
>  	struct dentry *d;
>  	struct qstr last;
> -	int type, error;
> +	enum component_type type;
> +	int error;
>  
>  	error = filename_parentat(dfd, name, 0, &parent_path, &last, &type);
>  	if (error)
> @@ -3009,7 +3010,8 @@ struct dentry *kern_path_parent(const char *name, struct path *path)
>  	CLASS(filename_kernel, filename)(name);
>  	struct dentry *d;
>  	struct qstr last;
> -	int type, error;
> +	enum component_type type;
> +	int error;
>  
>  	error = filename_parentat(AT_FDCWD, filename, 0, &parent_path, &last, &type);
>  	if (error)
> @@ -3057,7 +3059,7 @@ EXPORT_SYMBOL(kern_path);
>   * @root: pointer to struct path of the base directory
>   */
>  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
> -			   struct path *parent, struct qstr *last, int *type,
> +			   struct path *parent, struct qstr *last, enum component_type *type,
>  			   const struct path *root)
>  {
>  	return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
> @@ -4903,7 +4905,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
>  	bool want_dir = lookup_flags & LOOKUP_DIRECTORY;
>  	unsigned int reval_flag = lookup_flags & LOOKUP_REVAL;
>  	unsigned int create_flags = LOOKUP_CREATE | LOOKUP_EXCL;
> -	int type;
> +	enum component_type type;
>  	int error;
>  
>  	error = filename_parentat(dfd, name, reval_flag, path, &last, &type);
> @@ -5365,7 +5367,7 @@ int filename_rmdir(int dfd, struct filename *name)
>  	struct dentry *dentry;
>  	struct path path;
>  	struct qstr last;
> -	int type;
> +	enum component_type type;
>  	unsigned int lookup_flags = 0;
>  	struct delegated_inode delegated_inode = { };
>  retry:
> @@ -5383,6 +5385,7 @@ int filename_rmdir(int dfd, struct filename *name)
>  	case LAST_ROOT:
>  		error = -EBUSY;
>  		goto exit2;
> +	case LAST_NORM: ; // OK
>  	}
>  
>  	error = mnt_want_write(path.mnt);
> @@ -5507,7 +5510,7 @@ int filename_unlinkat(int dfd, struct filename *name)
>  	struct dentry *dentry;
>  	struct path path;
>  	struct qstr last;
> -	int type;
> +	enum component_type type;
>  	struct inode *inode;
>  	struct delegated_inode delegated_inode = { };
>  	unsigned int lookup_flags = 0;
> @@ -6074,7 +6077,7 @@ int filename_renameat2(int olddfd, struct filename *from,
>  	struct renamedata rd;
>  	struct path old_path, new_path;
>  	struct qstr old_last, new_last;
> -	int old_type, new_type;
> +	enum component_type old_type, new_type;
>  	struct delegated_inode delegated_inode = { };
>  	unsigned int lookup_flags = 0;
>  	bool should_retry = false;
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index d08973b288e5..b12d481f5ba9 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -56,7 +56,8 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_config *share_conf,
>  {
>  	struct qstr last;
>  	const struct path *root_share_path = &share_conf->vfs_path;
> -	int err, type;
> +	int err;
> +	enum component_type type;
>  	struct dentry *d;
>  
>  	if (pathname[0] == '\0') {
> @@ -668,7 +669,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
>  	struct renamedata rd;
>  	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
>  	struct ksmbd_file *parent_fp;
> -	int new_type;
> +	enum component_type new_type;
>  	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
>  
>  	if (ksmbd_override_fsids(work))
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index 58600cf234bc..fa3ae87762b7 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -16,7 +16,7 @@ enum { MAX_NESTED_LINKS = 8 };
>  /*
>   * Type of the last component on LOOKUP_PARENT
>   */
> -enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
> +enum component_type {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
>  
>  /* pathwalk mode */
>  #define LOOKUP_FOLLOW		BIT(0)	/* follow links at the end */
> @@ -70,7 +70,7 @@ static inline void end_removing_path(const struct path *path , struct dentry *de
>  	end_creating_path(path, dentry);
>  }
>  int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
> -			   struct path *parent, struct qstr *last, int *type,
> +			   struct path *parent, struct qstr *last, enum component_type *type,
>  			   const struct path *root);
>  int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
>  		    unsigned int, struct path *);
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
