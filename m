Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245181B4125
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551014; cv=none; b=Rym3Kid++ELmtNOiPBY//B52whIDX2OHie+G5LyVDIvFMYYUQPWtPpwCGVkZEa+CZ5Z8hcF5rCF5DqgjD9mFvYSMXr3y91ues3GkAACmK734c09cyrP3IJNhlmBetBCKG5KOnzbadIOS5QiUOXoEU4JfEm5zJgmlEm5DF9TanUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551014; c=relaxed/simple;
	bh=jurq8gfJQz/D7wA33o9pjlQ3qUG8mtMdx+MvL6yFRvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZyG3IsEZUviy3y8tHAog5fKSx5MIJFYh6ROzN1KLtP+scMWwCgbMJDobVSSwMDi3mDgA8Wn1KwNb1iQjYO41Pk5fPD5MH72A/DwMKaxP8FjJ/Lb/LYdfIUi9yeiNdOeYp6tLXppw/I3igANsR+RXCOoHpzwyLnUI00Ohhthp2xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B3JAQXlg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=02N1oa6O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=B3JAQXlg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=02N1oa6O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B3JAQXlg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="02N1oa6O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="B3JAQXlg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="02N1oa6O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 440A421120;
	Mon, 25 Nov 2024 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732551011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86dTpzRC3dwLP/Stc4vn+IEcrK2nE2h4aJmJxjcmbg0=;
	b=B3JAQXlgoF6UU6IuHGIKpRGOparAl5qeqcQP4UUuLsNy135gIiv6C/bD1OaRdGNTOvKwGr
	3KzwfVOV6tDMr06WYA3V2kaAbRfpt+S63iRSlAtvuHjOqzezrLAFef3qnPySHZ0XtwiGJs
	8ctVZFRrJnLI54MZf//99zcpyu++4n4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732551011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86dTpzRC3dwLP/Stc4vn+IEcrK2nE2h4aJmJxjcmbg0=;
	b=02N1oa6OdUj2BPhnWGXoq4QMujj1F7BrWW2BndmhOQyOQjSCXeFeNmSDPBisE2dr8bP7Cf
	82SSeriF53CwYEBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732551011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86dTpzRC3dwLP/Stc4vn+IEcrK2nE2h4aJmJxjcmbg0=;
	b=B3JAQXlgoF6UU6IuHGIKpRGOparAl5qeqcQP4UUuLsNy135gIiv6C/bD1OaRdGNTOvKwGr
	3KzwfVOV6tDMr06WYA3V2kaAbRfpt+S63iRSlAtvuHjOqzezrLAFef3qnPySHZ0XtwiGJs
	8ctVZFRrJnLI54MZf//99zcpyu++4n4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732551011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86dTpzRC3dwLP/Stc4vn+IEcrK2nE2h4aJmJxjcmbg0=;
	b=02N1oa6OdUj2BPhnWGXoq4QMujj1F7BrWW2BndmhOQyOQjSCXeFeNmSDPBisE2dr8bP7Cf
	82SSeriF53CwYEBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C268913890;
	Mon, 25 Nov 2024 16:10:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h6N2ImKhRGfhawAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 25 Nov 2024 16:10:10 +0000
Date: Mon, 25 Nov 2024 13:07:54 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] smb: client: remove unnecessary checks in
 open_cached_dir()
Message-ID: <4mnj5oyxousir27z5ak6bgr7vd3iggk433bbdqjx6ts2w5xtrx@ajqgfusmy27k>
References: <20241123011437.375637-1-henrique.carvalho@suse.com>
 <20241123011437.375637-2-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241123011437.375637-2-henrique.carvalho@suse.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,manguebit.com,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:email]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On 11/22, Henrique Carvalho wrote:
>Checks inside open_cached_dir() can be removed because if dir caching is
>disabled then tcon->cfids is necessarily NULL. Therefore, all other checks
>are redundant.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
>V1 -> V2: Split patch and addressed review comments
>
> fs/smb/client/cached_dir.c | 10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 8b510c858f4ff..85a8cc04e2c81 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -162,15 +162,17 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 	const char *npath;
> 	int retries = 0, cur_sleep = 1;
>
>-	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
>-	    is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
>+	if (cifs_sb->root == NULL)
>+		return -ENOENT;

Callers of open_cached_dir() seems to only handle its return value as
0 or -ENOENT, but if cifs_sb->root is NULL at this point (even though
unlikely), it's definitely neither.

Maybe returning something different here (e.g. -EIO) and handling it
properly in a follow up patch would be good.

>+
>+	if (tcon == NULL)
> 		return -EOPNOTSUPP;
>
> 	ses = tcon->ses;
> 	cfids = tcon->cfids;
>
>-	if (cifs_sb->root == NULL)
>-		return -ENOENT;
>+	if (cfids == NULL)
>+		return -EOPNOTSUPP;
>
> replay_again:
> 	/* reinitialize for possible replay */

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers
