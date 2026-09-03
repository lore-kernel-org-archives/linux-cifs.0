Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6DB480328;
	Thu,  3 Sep 2026 10:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788430600; cv=none; b=YrFS1DUyvcgEDEvNqkemWRPlHod5BjmPLCG8nAGnrHdhieMxkTFP+UvxsEjlO1KuEQp49Hq7d8jCZbp3GYUJfsxTsfj2mCM9q8s+/XzUC/wtTY1UuUNnJI8kGiFn1AmbtynMewvfIe+KEa/hxmC115zoUPx7t+VmqTMiaK022aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788430600; c=relaxed/simple;
	bh=mD0w9PyHBMxoxqF6XVYQQejMxEJKovyykRbdXl95mn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZazrM7py1og5Z2jePfWF93TLFfgJr0b/M9eP+xZYy42emWYg4jHUSrT96Oan/Pixa/KQ6TLGhUoQcuHOXtY4g7OOQ9K4Am5MN5o3gt6iQu3hDfSztSMiyNmAtvX6DSUKTfYfCSiUGKggvH1kk8EPnV+j6r3plrG7SxayHdhkcGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NTzwLKD+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oLjPRRc/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aJte7QtF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aHIbijI/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NTzwLKD+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oLjPRRc/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aJte7QtF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aHIbijI/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7F23B21D98;
	Thu,  3 Sep 2026 10:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788430579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wU+icT/0o0sXokPTmYo+cIrdFZ6mQDn0bo8ALtSgFRk=;
	b=NTzwLKD+7sze+b+VPaFwt9kEhn1GForP+EG6QD2o6Hjub5yXPDKiENPm84bxfDQ/iAnk3h
	HRshkABQyEB3/TLgf6KEDqJCsD1dbX/ndnP01PcLDlJHq4faTNbwsdLXHVmGHsHxLaQnNQ
	85sb1fXcZ9KDnAmp3QqoqwVGfLwoO2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788430579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wU+icT/0o0sXokPTmYo+cIrdFZ6mQDn0bo8ALtSgFRk=;
	b=oLjPRRc/Nnt9TGNZ8UVo4K2/xbxnOWPF2EMt2El1RAm2JlYNRC7copQKRjGTw0ykcA9Nzq
	xZqYXqgcIR+RcwDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aJte7QtF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="aHIbijI/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788430575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wU+icT/0o0sXokPTmYo+cIrdFZ6mQDn0bo8ALtSgFRk=;
	b=aJte7QtFOFMFstk6q6l0u12FREBxIgI5eVLGCZFUCSbe8vZjlI6nUsB4sd5RDKUdXiHIzk
	HicF7RLo7T3Xh4Ogb2+Pkjgh2EiZtuXbXbOuMQhPFjB2lwZ6hwttpcXr7Kz2HdXkD8Ie5v
	pcYoMgFYlaeM4ANdaqIhjsDy7O0oqt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788430575;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wU+icT/0o0sXokPTmYo+cIrdFZ6mQDn0bo8ALtSgFRk=;
	b=aHIbijI/hKfJxeHz7Ds81kSSD7BOykPJuj43m1t5x0QjAuq9A+2IWe5a8qvEPbmdNVxJfF
	76fw3WobiTCd2pCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60219136D9;
	Thu,  3 Sep 2026 10:16:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Jvd2F+9ImWp0FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 10:16:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F1587A13AC; Thu, 03 Sep 2026 12:16:14 +0200 (CEST)
Date: Thu, 3 Sep 2026 12:16:14 +0200
From: Jan Kara <jack@suse.cz>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@manguebit.org>, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] super: make iterate_supers_type() deletion-safe
Message-ID: <32afuwcqxfzvc2qwsvx6ecpyvbunr45wnvmezbbqzz25qtfn35@tvotjvtm3soe>
References: <20260903013336.92081-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903013336.92081-1-kmehltretter@gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7F23B21D98
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Thu 03-09-26 03:33:36, Karl Mehltretter wrote:
> iterate_supers_type() drops sb_lock while invoking the callback and keeps
> only a passive reference to the current superblock. That reference keeps
> the object allocated, but does not keep its s_instances node linked.
> 
> After the callback releases s_umount, final teardown can unlink the current
> s_instances node. The iterator then advances through a reinitialized node.
> With the current hlist it stops without visiting the remaining superblocks.
> The unlink moved from generic_shutdown_super() to kill_super_notify(), but
> the cursor lifetime has been unsafe since the helper was introduced.
> 
> The CIFS DFS lookup can consequently miss a matching superblock and return
> -EINVAL.
> 
> Walk the global superblock list in reverse and filter it by filesystem
> type. A passive reference keeps its s_list node linked, and reverse
> traversal preserves newest-first visitation. Superblocks removed from
> fs_supers remain on the global list, but teardown marks them SB_DYING
> before unlinking them, so the existing filter excludes them.
> 
> This broadens the scan from superblocks of one type to all superblocks.
> The only in-tree caller is the CIFS DFS lookup, so the broader scan is
> limited to that path.
> 
> Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Good spotting! But what I'm wondering about is whether we just shouldn't
move where we delete sb from fs_supers. Currently we do that in
kill_super_notify() to hide the sb from sget_fc() (which would otherwise
permanently retry and call test() for S_DEAD sb which can cause problems).
But if we just skipped S_DEAD superblocks in sget_fc(), we could move
removal from fs_supers list to put_super() (make it symmetric with the
handling of super_blocks list) and that would also fix
iterate_supers_type(). Christian, what do you think?

								Honza

> ---
> Testing: x86_64 QEMU deterministic KUnit A/B using the actual CIFS lookup
> callback over temporary VFS superblocks. Baseline skipped the surviving
> match after teardown of the preceding nonmatch and returned -EINVAL. With
> only this patch applied, the same test passed.
> 
> A real Samba DFS server and the kernel CIFS client were then run in the
> same QEMU guest over loopback. Baseline and patch-only kernels both followed
> the referrals and completed 20 reconnects while two workers repeatedly
> mounted and unmounted independent CIFS superblocks. The patch-only run
> successfully mounted, read from, and unmounted CIFS shares 95 times. Kprobes
> recorded 110 DFS lookup calls and 60 iterate_supers_type() calls. There were
> no unmount failures, kernel warnings, oopses, or sanitizer reports. The
> natural network stress did not hit the narrow race on baseline.
> 
> Stable is requested because concurrent DFS automount teardown can make a
> reconnect lookup miss a live matching superblock.
> 
> Backport note: before dc3216b14160 ("super: ensure valid info"), the
> s_instances unlink is in generic_shutdown_super(). Before 3ec9800c2d33
> ("super: convert s_count to refcount_t s_passive"), the passive reference is
> named s_count.
> 
>  fs/super.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 05e4431730387..c8accd144bad2 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1026,11 +1026,18 @@ void iterate_supers_type(struct file_system_type *type,
>  	struct super_block *sb, *p = NULL;
>  
>  	spin_lock(&sb_lock);
> -	hlist_for_each_entry(sb, &type->fs_supers, s_instances) {
> +	/*
> +	 * The passive reference keeps the s_list cursor valid while sb_lock
> +	 * is dropped. Entries are added at the tail. Walk backwards to retain
> +	 * newest-first visitation.
> +	 */
> +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
>  		bool locked;
>  
>  		if (super_flags(sb, SB_DYING))
>  			continue;
> +		if (sb->s_type != type)
> +			continue;
>  
>  		if (!refcount_inc_not_zero(&sb->s_passive))
>  			continue;
> -- 
> 2.53.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
