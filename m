Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6023525771
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732551582; cv=none; b=kP8Q/RhmJgA84FHfgWxLPAMwssRPgxSEFzdqkne70hqOmkDpszqLoCMWA4gf/Tn9tHn4u/3lW8oAZMaGHbFoKok23RUfgLSE6QZVq00kbtl/JoQf23jCcDuuFNU54MYyjoXZmU9ErjaIcn9i4PzuO0k6f+GuYHwPM5z+ASFtSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732551582; c=relaxed/simple;
	bh=IfkGbS6yXw6zG3SZ4fmXJmt9hParwb+3A3maW/rtBFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SITAtBstsfp9Yt7UrRfCkfzCPi+zO2/jzQ8mGqLG77ODnTzGnI7O0YM3tqTfcCMfdXFtcmPsUptfcZgpAvHsQ+6hxWimSr2C3m6aF2/lFIe+J6HDjHq+wWatnuOdoVUetB5V2MbeCsWHafOQ0b3ugtYbrLWiS4XtxEXIHWzLQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=o0sJYog3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BZU/2qhg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=o0sJYog3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BZU/2qhg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="o0sJYog3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BZU/2qhg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="o0sJYog3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BZU/2qhg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8173421190;
	Mon, 25 Nov 2024 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732551578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/uerMC4IX3YOB00VMa8vcYI3eKjvV5e6YWmDKvKr4uQ=;
	b=o0sJYog3iFLEGtwT6OqADsTbYXMPqXyOadYF3d98L+GdZ320gBK6bBj1SWRRj8zru5A911
	YN4arzJnEiYh3bwCJMQje9or6u00e+/OUbwE2s47Ig4bxmXJt4HOZosQ12JUGdebWUSpC8
	whktdFWHovHP36a76zmdbEDcPMbGlXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732551578;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/uerMC4IX3YOB00VMa8vcYI3eKjvV5e6YWmDKvKr4uQ=;
	b=BZU/2qhg50VPoGpAw6RTIJxXMnVbJ0sU7gAjRifF/OT2555h+yVCriqe5nz2cRy1RUxquz
	T0GrhOQzfsMnoWDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732551578; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/uerMC4IX3YOB00VMa8vcYI3eKjvV5e6YWmDKvKr4uQ=;
	b=o0sJYog3iFLEGtwT6OqADsTbYXMPqXyOadYF3d98L+GdZ320gBK6bBj1SWRRj8zru5A911
	YN4arzJnEiYh3bwCJMQje9or6u00e+/OUbwE2s47Ig4bxmXJt4HOZosQ12JUGdebWUSpC8
	whktdFWHovHP36a76zmdbEDcPMbGlXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732551578;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/uerMC4IX3YOB00VMa8vcYI3eKjvV5e6YWmDKvKr4uQ=;
	b=BZU/2qhg50VPoGpAw6RTIJxXMnVbJ0sU7gAjRifF/OT2555h+yVCriqe5nz2cRy1RUxquz
	T0GrhOQzfsMnoWDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FD6313890;
	Mon, 25 Nov 2024 16:19:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y7lwMpmjRGfmbgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 25 Nov 2024 16:19:37 +0000
Date: Mon, 25 Nov 2024 13:17:20 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] smb: client: disable directory caching when
 dir_cache_timeout is zero
Message-ID: <sgohasrwpajg2oec2copmidglvc5octzcu4eh37gjma2amgbyg@42r5snk2ynpb>
References: <20241123011437.375637-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241123011437.375637-1-henrique.carvalho@suse.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[samba.org,manguebit.com,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On 11/22, Henrique Carvalho wrote:
>Setting dir_cache_timeout to zero should disable the caching of
>directory contents. Currently, even when dir_cache_timeout is zero,
>some caching related functions are still invoked, which is unintended
>behavior.
>
>Fix the issue by setting tcon->nohandlecache to true when
>dir_cache_timeout is zero, ensuring that directory handle caching
>is properly disabled.
>
>Fixes: 238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
>V1 -> V2: Split patch and addressed review comments
>
> fs/smb/client/connect.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>index b227d61a6f205..62a29183c655c 100644
>--- a/fs/smb/client/connect.c
>+++ b/fs/smb/client/connect.c
>@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>
> 	if (ses->server->dialect >= SMB20_PROT_ID &&
> 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
>-		nohandlecache = ctx->nohandlecache;
>+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
> 	else
> 		nohandlecache = true;
> 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers
