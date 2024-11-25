Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AAC29415
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732550306; cv=none; b=DKLuCoYXUIr/8Fvk6DI2fGpDNaVKU3UJ8zx9J99W0k6iZAoaTh9dTNbEk7unScELvPebrKsnXmIKVX7zIK/QjT734d8dS9nduZlB6NnucNi8XSJqsprzpjMenwsCQM1/jg010R2sz6PV01s1zJJLP4knGEbF5Rm+jOnkLWf2nlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732550306; c=relaxed/simple;
	bh=o/vpT5j+e6lQvNqzDLmJdFKzWZDWx+pB3bDltWZaE+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFlHeOnljZ8s5ZbB6P7W+22fSyi06HkaMaDi2u3qIFGZu0WYiTWsSaEHqHCucoPg7uLUold3JMsz0bg8FdWHQkR1eX1fjqmE76Tkxvlb/ikzR+BDszy9HVYGPrK6++3Id4jIujfd3sjF9dYlpAbmEBjH132BSAQctCrVblGoClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sB1+GWaF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=l2sXK6Uz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sB1+GWaF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=l2sXK6Uz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sB1+GWaF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="l2sXK6Uz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sB1+GWaF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="l2sXK6Uz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99EC51F442;
	Mon, 25 Nov 2024 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732550302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DH++ATPHxhh6qSvmq4BR4yNpPS7KbYXz7a6Yv5TbhKw=;
	b=sB1+GWaFakgjDsidhaN5rMAyqZD4rEpn+++Wzvewkyou2q+cJecSIiu8bKZBp2VOsQlhEr
	C4Ox1vszf9ysdDJQNXe/K4mzKo6CdDn9pinZOyJZ1c1kSZo1xTvGjIDgkQJyCWIapwtoYQ
	Is5CSaRZDV3Czb2GhNS18deLcYfjXII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732550302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DH++ATPHxhh6qSvmq4BR4yNpPS7KbYXz7a6Yv5TbhKw=;
	b=l2sXK6UzWu6zZTqRk75JajyrdxYIiM+vc8TpbJ4zZElPntuHx/3Ho+CC3lZGmhH12D5iP9
	yEtdI1hi+GT8f+Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732550302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DH++ATPHxhh6qSvmq4BR4yNpPS7KbYXz7a6Yv5TbhKw=;
	b=sB1+GWaFakgjDsidhaN5rMAyqZD4rEpn+++Wzvewkyou2q+cJecSIiu8bKZBp2VOsQlhEr
	C4Ox1vszf9ysdDJQNXe/K4mzKo6CdDn9pinZOyJZ1c1kSZo1xTvGjIDgkQJyCWIapwtoYQ
	Is5CSaRZDV3Czb2GhNS18deLcYfjXII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732550302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DH++ATPHxhh6qSvmq4BR4yNpPS7KbYXz7a6Yv5TbhKw=;
	b=l2sXK6UzWu6zZTqRk75JajyrdxYIiM+vc8TpbJ4zZElPntuHx/3Ho+CC3lZGmhH12D5iP9
	yEtdI1hi+GT8f+Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 128B113890;
	Mon, 25 Nov 2024 15:58:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nVn5Mp2eRGevZwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 25 Nov 2024 15:58:21 +0000
Date: Mon, 25 Nov 2024 12:56:00 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com, ematsumiya@suse.com
Subject: Re: [PATCH] Update misleading comment in cifs_chan_update_iface
Message-ID: <ubfww55cebjyaur47o2s34qkpcqdmck4zvdx7q47e2tk4bvkwe@xvefnpedopnf>
References: <20241107164029.322205-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241107164029.322205-1-marco.crivellari@suse.com>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 11/07, Marco Crivellari wrote:
>Since commit 8da33fd11c05 ("cifs: avoid deadlocks while updating iface")
>cifs_chan_update_iface now takes the chan_lock itself, so update the
>comment accordingly.
>
>Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
>---
> fs/smb/client/sess.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
>diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
>index 3216f786908f..51614a36a100 100644
>--- a/fs/smb/client/sess.c
>+++ b/fs/smb/client/sess.c
>@@ -359,10 +359,7 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
> 	spin_unlock(&ses->chan_lock);
> }
>
>-/*
>- * update the iface for the channel if necessary.
>- * Must be called with chan_lock held.
>- */
>+/* update the iface for the channel if necessary. */
> void
> cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
> {
>-- 

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers
