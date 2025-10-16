Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC7D26B942
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 12:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760618560; cv=none; b=YO6Mp2CYxbT8deXuM0fgObeS7UbAX8yuzbJJLTzn8UeVLp04ZuyQlmxEXkpdzRpq1mcel7iAGlfHJMkwWmFa3BVKQFLN/uAVPAmqH0h/M4PDaCz47LJ5756iTxFEJCddZuOMPilYNHcc2EXwOkJnOOkqLsj7qpfyAIWY1Qb4ULo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760618560; c=relaxed/simple;
	bh=/Vn+SoNjdZAJPdwgYWTSNf0iwBFi1AZUscWfNKrNcoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6ayl/574Dho9qaUa2f4L7Cbq1tceUY0/rdtX10iAUp+PecVIG0AWaql0vfg8Pxc0epNxKM9zr26pzKjEw6in/1aH8lcrwLTZMaGjhBPoqh39xrYPwTN3YK/nK8S+7xjJFlpHhEtZkiAu0mNlf5WSY6W0lo2FYBCG+2k3bQkt+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IvKXZjlq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+6M0OdW+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PleXtpzv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BsaK+tYd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IvKXZjlq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+6M0OdW+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PleXtpzv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BsaK+tYd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B5C3721A3C;
	Thu, 16 Oct 2025 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760618556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrDeNB9hw9Mw52W/7JqsvnRYl3u6xnr7RWDFLtF7OiY=;
	b=IvKXZjlq61jvqNuU9cv9LY5eGwdbyaquLGLLt7j6GErA3RdyBvxiIPN2iHXvFIkdH9Plix
	4mNrOjb2wVrNuK5ci5bQ5grFfRbc2PDxjgEQ1R9H6QkwHMCg4GFZqu4E+wEkeryCZbw7Oz
	JUSotgYdebSNQDa34Irj5YaMoV/9ocM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760618556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrDeNB9hw9Mw52W/7JqsvnRYl3u6xnr7RWDFLtF7OiY=;
	b=+6M0OdW+ENoIg2zJvFQJ1KRwIDO7je6C6YhevH7BpNyAoFUOaiKIVLfgaeQteOrfJifTx+
	VPVo20IlQmDkSWDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PleXtpzv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BsaK+tYd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760618555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrDeNB9hw9Mw52W/7JqsvnRYl3u6xnr7RWDFLtF7OiY=;
	b=PleXtpzvu+zA7aTRalVuNQ4e6r90XZLy2LNvdYT1m43n8hL5t9oaXw8WXzZLapChCQOqNl
	TSw10YuWAjrRkGQloOkEOUrNZZb7eWNydaLM7FGgRrBjX+s1qeG/gf7C96BsHnbeDHnVL8
	ap1mPgCRfogA7391CuDDIMs14Y70xe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760618555;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrDeNB9hw9Mw52W/7JqsvnRYl3u6xnr7RWDFLtF7OiY=;
	b=BsaK+tYdJKVtHUrMAqF34uDkZlfYLDy40WnLchgARzI9K1gEjgZus6itWjMmztXuMXAbKe
	hKms9curI53wcmBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3452C1376E;
	Thu, 16 Oct 2025 12:42:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id riK5Ojro8GiqFgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 16 Oct 2025 12:42:34 +0000
Date: Thu, 16 Oct 2025 09:42:28 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v2 00/20] cached dir fixes and improvements
Message-ID: <va662bnsjp4xkl3pnpqphviy7b7gsunpjqwyoibofhfj3ns6ju@fybzpfopoawr>
References: <20251007174304.1755251-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251007174304.1755251-1-ematsumiya@suse.de>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: B5C3721A3C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.01

Ping.

On 10/07, Enzo Matsumiya wrote:
>Hi,
>
>Sending v2 of this series.  Please refer to v1 cover letter for details.

I'm preparing v3 to include some changes suggested by Henrique, Paulo,
and Steve, along with some fixes for some bugs I've found while testing
it myself.

I couldn't reproduce the hangs Steve reported (mostly to samba on
btrfs), nor the perf degradation with some xfstests (Azure, Windows,
samba), however, I also did change slightly the lookup code in order to
(attempt to) prevent this.

I'd appreciate if I could get more reviews/feedback so I can include
them in v3.


Thanks,

Enzo

>Cheers,
>
>Enzo
>
>
>v1 -> v2:
>- rebased on mainline (previously based on cifs/for-next)
>- already includes the fixes sent individually for patches 12 and 19
>- fixed issues reported by kernel test robot for patches 13, 16, 19
>- ran smatch locally with whole series applied (all good)
>
>Enzo Matsumiya (20):
>  smb: client: remove cfids_invalidation_worker
>  smb: client: remove cached_dir_offload_close/close_work
>  smb: client: remove cached_dir_put_work/put_work
>  smb: client: remove cached_fids->dying list
>  smb: client: remove cached_fid->on_list
>  smb: client: merge {close,invalidate}_all_cached_dirs()
>  smb: client: merge free_cached_dir in release callback
>  smb: client: split find_or_create_cached_dir()
>  smb: client: enhance cached dir lookups
>  smb: client: refactor dropping cached dirs
>  smb: client: simplify cached_fid state checking
>  smb: client: prevent lease breaks of cached parents when opening
>    children
>  smb: client: actually use cached dirs on readdir
>  smb: client: wait for concurrent caching of dirents in cifs_readdir()
>  smb: client: remove cached_dirent->fattr
>  smb: client: add is_dir argument to query_path_info
>  smb: client: use cached dir on queryfs/smb2_compound_op
>  smb: client: skip dentry revalidation of cached root
>  smb: client: rework cached dirs synchronization
>  smb: client: cleanup open_cached_dir()
>
> fs/smb/client/cached_dir.c | 985 +++++++++++++++++--------------------
> fs/smb/client/cached_dir.h |  81 +--
> fs/smb/client/cifs_debug.c |   8 +-
> fs/smb/client/cifsfs.c     |   4 +-
> fs/smb/client/cifsglob.h   |   5 +-
> fs/smb/client/dir.c        |  64 +--
> fs/smb/client/file.c       |   2 +-
> fs/smb/client/inode.c      |  35 +-
> fs/smb/client/misc.c       |   9 +-
> fs/smb/client/readdir.c    | 147 +++---
> fs/smb/client/smb1ops.c    |   6 +-
> fs/smb/client/smb2inode.c  |  57 ++-
> fs/smb/client/smb2misc.c   |   2 +-
> fs/smb/client/smb2ops.c    |  44 +-
> fs/smb/client/smb2pdu.c    |  76 ++-
> fs/smb/client/smb2proto.h  |  10 +-
> 16 files changed, 777 insertions(+), 758 deletions(-)
>
>-- 
>2.51.0
>
>
