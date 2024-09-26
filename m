Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1593C15B122
	for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 18:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727374982; cv=none; b=p4SSOSBbX5i77U86d0Y1lhQZLVcZ7q98oAh2GmSLQ6s7qoH1gg+/SWZcXBCkMfYlmXbfFkB88MdjzPTYLK0qVoEJYvN5RRCHJoVgZq2jNjZjTGU/d1vf9ycfTVfMGrMidSOtXA4FQWh+ptCIBXaTodMsT14QYM6ryCUAb9+PuWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727374982; c=relaxed/simple;
	bh=/4WqgRe5s9vgyc5LBSdDIKRUwBTrI0EWw4wHpGcHIvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdm/bDInYoADWXB8sQTjMP/CIxovyseDQLKwp0ACcrJlqtW5f8cvtvEJ7kx9w2MRMI5dR46lCbTggDHeyFULLJqw64u2pCFOtRgVrLkBj+OLjiN6DddMb07czxHYilTzVcxEFgKPorHPq8l2KO0HGe6B4ux7RjL5OmEl5ZHFiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AYTeNpXj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yVc5gq/6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AYTeNpXj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yVc5gq/6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AYTeNpXj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yVc5gq/6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AYTeNpXj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yVc5gq/6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46D5021B0F;
	Thu, 26 Sep 2024 18:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727374979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4WqgRe5s9vgyc5LBSdDIKRUwBTrI0EWw4wHpGcHIvo=;
	b=AYTeNpXjPET6u9zyCeVvu+KSN0TDX8FuUkAI1EXKwf3VuXJ92JCMvNKWTJa5aKifU5K6vA
	xCioTIGzaZL7WK4uo0GpOTrVtiihoYrnTaz+p1QeVumfTjhlNLRMWeHoPD1VIzNwbk9tC0
	q9wT4+IYsMgr9W124xJPDqpWJ3gfWqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727374979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4WqgRe5s9vgyc5LBSdDIKRUwBTrI0EWw4wHpGcHIvo=;
	b=yVc5gq/6FEo9x7+SyESKo0tPjtiouF2vEVTHZzz9pGM91KXto4E8p2lWyBtJnhwoBJdXcb
	vDFZbnEXFvk9RCDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727374979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4WqgRe5s9vgyc5LBSdDIKRUwBTrI0EWw4wHpGcHIvo=;
	b=AYTeNpXjPET6u9zyCeVvu+KSN0TDX8FuUkAI1EXKwf3VuXJ92JCMvNKWTJa5aKifU5K6vA
	xCioTIGzaZL7WK4uo0GpOTrVtiihoYrnTaz+p1QeVumfTjhlNLRMWeHoPD1VIzNwbk9tC0
	q9wT4+IYsMgr9W124xJPDqpWJ3gfWqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727374979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/4WqgRe5s9vgyc5LBSdDIKRUwBTrI0EWw4wHpGcHIvo=;
	b=yVc5gq/6FEo9x7+SyESKo0tPjtiouF2vEVTHZzz9pGM91KXto4E8p2lWyBtJnhwoBJdXcb
	vDFZbnEXFvk9RCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAB7313318;
	Thu, 26 Sep 2024 18:22:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bQ4fIIKm9WbPOgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Sep 2024 18:22:58 +0000
Date: Thu, 26 Sep 2024 15:23:12 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Shyam Prasad N <nspmangalore@gmail.com>, Bharath S M <bharathsm@microsoft.com>
Subject: Re: default value of esize (min_encrypt_offload size)
Message-ID: <oz3ewqwy6i62pqmaryuo4jyr62cutz3jmym23n5in6uvwbepjy@wfsqs5lufwwq>
References: <CAH2r5msbBYdqe=2HQqrceJSCYLXhyBRemYwXMjrmXWvq_y9VkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msbBYdqe=2HQqrceJSCYLXhyBRemYwXMjrmXWvq_y9VkA@mail.gmail.com>
X-Spam-Score: -3.75
X-Spamd-Result: default: False [-3.75 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.15)[-0.748];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,microsoft.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 09/26, Steve French wrote:
>Does anyone have perf data on enabling esize (minimum size to
>determine if worth offloading for decryption) and what size (e.g. I
>was thinking 256K or 512K minimum encryption offload size)?
>
>Does setting esize help any workloads you have tried - and which ones?

On my very shallow tests, with esize=1, offloading decryption has a
2x perf improvement.

Decryption is (currently?) very costly -- I see an average of 700ms per
4MiB payload on my test VM (with a high of 900ms!).

IMHO the "inflight > 1" criteria is the best way to determine whether
to offload decryption.

I don't really have an opinion on esize/min_enc_offload, but if it's so
hard to determine a default or minimum value to it, imagine leaving that
choice to the user.


My 2c,

Enzo
