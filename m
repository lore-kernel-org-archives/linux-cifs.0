Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D068B3491C4
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 16:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767629879; cv=none; b=U46UH7q5/kLlskAoP0YhPYG67j2mTNkEa6XVmHYkn5a/P4JKoJS51n0nfYoRQ5QfISWuRzmwrZk4fILO0HG3webhO/O4gUxZ81FxxgbQ3UwqR+qkUBNeSdX3/6tRYGKLHGV1cjd9H2y6d7t5ygBSH3Cng8XL1k3SRlu2yohunSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767629879; c=relaxed/simple;
	bh=U5JNXzUelt2oG0k9H/UBmnR6vsa+uU0PmVwCu88IDgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5GoceMixr0N8rSnL4w7mi4asWaBAZ8zTC5dcjRJ+jBNbdcxSEisgz6Nyp/qBF1gwJl8VQRB9PqPyWTzmoSpZVnzTqu6RxewF+PeQJ8pex44+ASi82kNr9wkSGxKpqxKi0srePcMavPv84ql3iNJvo1bfZsbh4o+GAZjda9yeyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QypB5P8l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4dq0llcP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QypB5P8l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4dq0llcP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QypB5P8l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4dq0llcP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QypB5P8l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4dq0llcP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2AB3F5BDB2;
	Mon,  5 Jan 2026 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767629876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1DFvpD5WZqumQjvq1dY5e6M7m22Rg2kOe+aJWOauueI=;
	b=QypB5P8lC9ySNMO/aFcfMrp5FtgSNBMU41gE6ylcGLUvLr+yC2KQZmI3MVlS7JtFCMEug2
	1w5I0/hej5J0RF39b71dWUF1guZ9rrQbtPoFRuEQ/Hm5aUv5gmWzms6zBurKME7qCNTBQN
	GPxHeM1OlYe2wx9IQhFPMNm0MxiNf8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767629876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1DFvpD5WZqumQjvq1dY5e6M7m22Rg2kOe+aJWOauueI=;
	b=4dq0llcPZ9X/rG0A876zUi75iCbx1NxTHqZD21FYu6ZMJmGR2DhQUaaia+eKNgO52k5MH5
	kLTxocHqXLfZyUCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767629876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1DFvpD5WZqumQjvq1dY5e6M7m22Rg2kOe+aJWOauueI=;
	b=QypB5P8lC9ySNMO/aFcfMrp5FtgSNBMU41gE6ylcGLUvLr+yC2KQZmI3MVlS7JtFCMEug2
	1w5I0/hej5J0RF39b71dWUF1guZ9rrQbtPoFRuEQ/Hm5aUv5gmWzms6zBurKME7qCNTBQN
	GPxHeM1OlYe2wx9IQhFPMNm0MxiNf8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767629876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1DFvpD5WZqumQjvq1dY5e6M7m22Rg2kOe+aJWOauueI=;
	b=4dq0llcPZ9X/rG0A876zUi75iCbx1NxTHqZD21FYu6ZMJmGR2DhQUaaia+eKNgO52k5MH5
	kLTxocHqXLfZyUCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACD9A3EA63;
	Mon,  5 Jan 2026 16:17:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VqwLHTPkW2ngHQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 05 Jan 2026 16:17:55 +0000
Date: Mon, 5 Jan 2026 13:17:49 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com
Subject: Re: [PATCH] smb: client: terminate session upon signature
 verification failure
Message-ID: <s4kmfu25glkgu44wl46e3q3bjvyhlbcvnlaiuqkuey4qlg4d5o@s7ispothcved>
References: <20251226201939.36293-1-aadityakansal390@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251226201939.36293-1-aadityakansal390@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[samba.org,vger.kernel.org,manguebit.org,gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

On 12/27, Aaditya Kansal wrote:
>Currently, when the SMB signature verification fails, the error is
>logged without any action to terminate the session.
>
>Call cifs_reconnect() to terminate the session if the signature
>verification fails.
>
>Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>

Thanks, I think this was long overdue.

>---
> fs/smb/client/cifstransport.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
>index 28d1cee90625..89818bb983ec 100644
>--- a/fs/smb/client/cifstransport.c
>+++ b/fs/smb/client/cifstransport.c
>@@ -169,12 +169,15 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>
> 		iov[0].iov_base = mid->resp_buf;
> 		iov[0].iov_len = len;
>-		/* FIXME: add code to kill session */
>+
> 		rc = cifs_verify_signature(&rqst, server,
> 					   mid->sequence_number);
>-		if (rc)
>+		if (rc) {
> 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
> 				 rc);
>+			cifs_reconnect(server, true);

I'd like to hear opinions on having reconnect happen only if signing
is required by server, otherwise only log the error (current behaviour).

>+			return rc;
>+		}
> 	}
>
> 	/* BB special case reconnect tid and uid here? */
>-- 

Nonetheless,

Acked-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,
