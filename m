Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4362E3A7F69;
	Thu, 10 Sep 2026 09:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032346; cv=none; b=pyLjDL0cP6QgtBzNQaYe+9V2mZZds8A6swgEAAdUuWdj6rUEtbZ6QrvG8OBiqwe5F1Wdx0/lCb/372t5D/m3jdJMoWxiFOEyaTWdUPElJBhGh+QjAy79Ckoa38dAunKgEXFgNiYcCqM7BKWAyymaEQMM2EKDOKVifevWA6AoaSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032346; c=relaxed/simple;
	bh=8RaqSawQ1vF5qX9NhmWGCVksHh6K50Ps3D9VLnths8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHMtPqOJOHlxwy3Yhem7y93Z4xxYVRyVN7wHFmgeoBP0jzBO0OwsFS8c0j4NvVrYDDXcIhsXJxZ0WR6retk8URiogOjSggZ8FsaXRlJgXHEAt3APacbsqEkZ3SLurENn7Q8q+nD8Lbb/4u6YyN4/pUJH8Ty3nCJHNoKWGlf10Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TS8gejpD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FZn08i+u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vhp3byuu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Emzvn4XT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TS8gejpD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FZn08i+u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vhp3byuu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Emzvn4XT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3E8C221A40;
	Thu, 10 Sep 2026 09:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789032335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4OnHufQCEI/q4CeEJ/6LJb9WBevXB4VxMCacj9atnjg=;
	b=TS8gejpDnCs3pf7xTX4LXrFOtT3NmzhlONzA9+XabE1H7Csb3PjMzDLi1qCgOzsx1XkePN
	AXVShDiotuHUbi5Bog94bJtRd1a39DIRo9VzDn65GtZXr4yLpahdzq2mtjBvVRU0eWXyvr
	IjbabB39o69Q/olNwY5Cr1W1kWe02z8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789032335;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4OnHufQCEI/q4CeEJ/6LJb9WBevXB4VxMCacj9atnjg=;
	b=FZn08i+uXxc7uty6Dtt5rhLHoC0x5qwS5xzxnF9MQlBUaZf5NQPSgG4B58JkYktt9evR8U
	EG84DCP4SgknYfAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vhp3byuu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Emzvn4XT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789032331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4OnHufQCEI/q4CeEJ/6LJb9WBevXB4VxMCacj9atnjg=;
	b=vhp3byuuq9e9zrYWse5GagWE6a+jFAxBwIl/m3cC7REBg8VYrpnnbukZLFR1Tc1tQKQmjK
	YK2ovRbiOeVru4tOJ4AXwS9C/wyBNypM2zojcE+/uyHJjBa6S1jaLDGeZq/PrwI3Fj3dzS
	pqjl3YqSUJMRdFkHWrAQUzUSgig5wps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789032331;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4OnHufQCEI/q4CeEJ/6LJb9WBevXB4VxMCacj9atnjg=;
	b=Emzvn4XTerqRE6MD4NmoLpkCaTUQnJQWFNZ3r5zm+WzWN0EW4HTWTEGS9SGB9J801RhHkX
	jh8irPB+HfacNZCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D509137FD;
	Thu, 10 Sep 2026 09:25:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LTI7A4t3omqVEAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 09:25:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9DD53A12EA; Thu, 10 Sep 2026 11:25:26 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:25:26 +0200
From: Jan Kara <jack@suse.cz>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@manguebit.org>, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] super: make iterate_supers_type() deletion-safe
Message-ID: <fqx7ykgqbmqfinufnwc3spjfcmy5vmkgk7doo5kugar6shlxur@mpleeeom7m7r>
References: <20260909193034.7467-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909193034.7467-1-kmehltretter@gmail.com>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 3E8C221A40
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:email];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Wed 09-09-26 21:30:34, Karl Mehltretter wrote:
> From: Christian Brauner <brauner@kernel.org>
> 
> iterate_supers_type() drops sb_lock while invoking the callback and keeps
> only a passive reference to the current superblock. That reference keeps
> the object allocated, but does not keep its s_instances node linked.
> 
> After the iterator releases s_umount, final teardown can unlink the current
> s_instances node. The iterator then advances through a reinitialized node.
> With the current hlist it stops without visiting the remaining superblocks.
> The unlink moved from generic_shutdown_super() to kill_super_notify(), but
> the cursor lifetime has been unsafe since the helper was introduced.
> 
> The CIFS DFS lookup can consequently miss a matching superblock and return
> -EINVAL.
> 
> Move removal from fs_supers to put_super(), alongside removal from
> super_blocks, so a passive reference keeps both list nodes linked. Keep
> the filesystem module reference until then, since unlinking s_instances
> may touch type->fs_supers.
> 
> Make sget_fc() skip SB_DEAD superblocks before invoking test(), and set
> SB_DEAD under sb_lock to serialize with those callbacks. This allows
> kernfs to free its private information after kill_anon_super() returns.
> Keep matching SB_DYING superblocks until SB_DEAD is set so concurrent
> mounts still wait for teardown before retrying.
> 
> Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Closes: https://lore.kernel.org/r/20260903013336.92081-1-kmehltretter@gmail.com
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
> Assisted-by: LLM
> [kmehltretter: supplied the commit message]
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Looks good to me! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Use Christian's implementation of Jan's suggestion: keep s_instances
>   linked until the last passive reference is dropped and make sget_fc()
>   skip SB_DEAD superblocks under sb_lock.
> - Retain the filesystem module reference until put_super().
> - Attribute authorship to Christian; retain my commit message.
> 
> Testing: All tests run on v1 also passed with Christian's draft. These
> included an x86_64 QEMU deterministic KUnit test using the actual CIFS
> lookup callback and a Samba DFS reconnect test with concurrent CIFS
> mounts and unmounts in the same guest. The deterministic test exercised
> the missed-match case; the network stress did not reproduce the narrow
> race on baseline.
> 
> Link to v1: https://lore.kernel.org/r/20260903013336.92081-1-kmehltretter@gmail.com
> 
> Christian's draft:
> https://lore.kernel.org/r/20260904-rockkonzert-bergtour-dahin-23c9c5c87d0f@brauner
> 
>  fs/kernfs/mount.c |  4 ++--
>  fs/super.c        | 39 +++++++++++++++++++--------------------
>  2 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index f183a96778b9..a57399021c8b 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -434,8 +434,8 @@ void kernfs_kill_sb(struct super_block *sb)
>  	up_write(&root->kernfs_supers_rwsem);
>  
>  	/*
> -	 * Remove the superblock from fs_supers/s_instances
> -	 * so we can't find it, before freeing kernfs_super_info.
> +	 * Mark the superblock dead so sget_fc() can't find it,
> +	 * before freeing kernfs_super_info.
>  	 */
>  	kill_anon_super(sb);
>  	kfree(info);
> diff --git a/fs/super.c b/fs/super.c
> index 05e443173038..0f9e13eedb4f 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -433,15 +433,19 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  void put_super(struct super_block *s)
>  {
>  	if (refcount_dec_and_test(&s->s_passive)) {
> +		struct file_system_type *type = s->s_type;
>  
>  		spin_lock(&sb_lock);
>  		list_del_init(&s->s_list);
> +		hlist_del_init(&s->s_instances);
>  		spin_unlock(&sb_lock);
>  
>  		WARN_ON(s->s_dentry_lru.node);
>  		WARN_ON(s->s_inode_lru.node);
>  		WARN_ON(s->s_mounts);
>  		call_rcu(&s->rcu, destroy_super_rcu);
> +		/* The unlink above may touch type->fs_supers, so drop it last. */
> +		put_filesystem(type);
>  	}
>  }
>  
> @@ -558,17 +562,6 @@ static void kill_super_notify(struct super_block *sb)
>  	if (sb->s_flags & SB_DEAD)
>  		return;
>  
> -	/*
> -	 * Remove it from @fs_supers so it isn't found by new
> -	 * sget_fc() walkers anymore. Any concurrent mounter still
> -	 * managing to grab a temporary reference is guaranteed to
> -	 * already see SB_DYING and will wait until we notify them about
> -	 * SB_DEAD.
> -	 */
> -	spin_lock(&sb_lock);
> -	hlist_del_init(&sb->s_instances);
> -	spin_unlock(&sb_lock);
> -
>  	/* Drop sget_fc()'s claim; a never-registered entry stays with the sb. */
>  	if (sb->s_super_dev->sd_dev) {
>  		super_dev_put(sb->s_super_dev);
> @@ -577,11 +570,15 @@ static void kill_super_notify(struct super_block *sb)
>  
>  	/*
>  	 * Let concurrent mounts know that this thing is really dead.
> -	 * We don't need @sb->s_umount here as every concurrent caller
> -	 * will see SB_DYING and either discard the superblock or wait
> -	 * for SB_DEAD.
> +	 * sget_fc() skips SB_DEAD superblocks and calls test() under
> +	 * sb_lock, so set it under sb_lock: once we return no test()
> +	 * runs on this superblock anymore and none will start. Everyone
> +	 * else already saw SB_DYING and either discarded the superblock
> +	 * or waits for SB_DEAD.
>  	 */
> +	spin_lock(&sb_lock);
>  	super_wake(sb, SB_DEAD);
> +	spin_unlock(&sb_lock);
>  }
>  
>  /**
> @@ -608,7 +605,6 @@ void deactivate_locked_super(struct super_block *s)
>  		list_lru_destroy(&s->s_dentry_lru);
>  		list_lru_destroy(&s->s_inode_lru);
>  
> -		put_filesystem(fs);
>  		put_super(s);
>  	} else {
>  		super_unlock_excl(s);
> @@ -795,12 +791,12 @@ void generic_shutdown_super(struct super_block *sb)
>  	}
>  	/*
>  	 * Broadcast to everyone that grabbed a temporary reference to this
> -	 * superblock before we removed it from @fs_supers that the superblock
> -	 * is dying. Every walker of @fs_supers outside of sget_fc() will now
> -	 * discard this superblock and treat it as dead.
> +	 * superblock that it is dying. Every walker of @fs_supers outside
> +	 * of sget_fc() will now discard this superblock and treat it as
> +	 * dead.
>  	 *
> -	 * We leave the superblock on @fs_supers so it can be found by
> -	 * sget_fc() until we passed sb->kill_sb().
> +	 * sget_fc() keeps finding the superblock until SB_DEAD is set, so
> +	 * a concurrent mounter waits until we passed sb->kill_sb().
>  	 */
>  	super_wake(sb, SB_DYING);
>  	super_unlock_excl(sb);
> @@ -879,6 +875,9 @@ struct super_block *sget_fc(struct fs_context *fc,
>  	spin_lock(&sb_lock);
>  	if (test) {
>  		hlist_for_each_entry(old, &fc->fs_type->fs_supers, s_instances) {
> +			/* Only unlinked at the last passive reference. */
> +			if (super_flags(old, SB_DEAD))
> +				continue;
>  			if (test(old, fc))
>  				goto share_extant_sb;
>  		}
> -- 
> 2.53.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
