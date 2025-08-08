Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890B216F8E9
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754662528; cv=none; b=Kui4rUBeYDREbb3k0krjavpS9yul8Yn3pqcRmHueuQIzx02P7ZjqSQ/mVONGwJ165pcKXaHv72EvCipmjNR85XWJzd9fc/kMohTxwQg88sa1f1o8csPQPXa4Zu/RxFGZ0qfmPoiHQ014k8Dw8WEg0HFE0+Swy/akScRNJy3osgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754662528; c=relaxed/simple;
	bh=0EnkHEGJ73QH04wvhXkCK8nf+om469IjyS/Wkl6uPyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDLiHgsd8dt5b8f5p8vme8lAAHH2MoctpP+KS71Hk14sMWz9EMYRruuXNXq6wHrW1d3dJGK74Yc91bLIRtgO5Ek8KdBbWTkhKPwLk3SknymfBgPyZXYkDW5/kQ2WZt13EsDiwtAu71ODLaeAM56iCPf8cAsxOuySYnsEDkIAnHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qavj5MhT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vcMJx+ql; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qavj5MhT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vcMJx+ql; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qavj5MhT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vcMJx+ql";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qavj5MhT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vcMJx+ql"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA61C5BDEE;
	Fri,  8 Aug 2025 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754662524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nCJX2YVHRzsi+NQ8DFEFBBW8/NL0NIQfBKtZHerXTs=;
	b=qavj5MhTSvJRCF9J0MiircfSlkIm8v927uxY/RydR3WgRSDsurECXTraE3n364Dh4s8dm7
	wrOvZf+zUBiEMB9KaVdHYcPHMx0v+xxUOfOS5dPP1Zj8VHikmzXn58rih3CTaPwsgEdTyK
	IQjQUJSoeTnHekNCFOTQ7mALfwNr97M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754662524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nCJX2YVHRzsi+NQ8DFEFBBW8/NL0NIQfBKtZHerXTs=;
	b=vcMJx+qllMS5++GYAm0RxaJ5042O3IDvPfV7XxysuUg8yP2EqWluevmzshjG9V+8/1uP6l
	o6BCxligy4dTNuCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qavj5MhT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vcMJx+ql
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754662524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nCJX2YVHRzsi+NQ8DFEFBBW8/NL0NIQfBKtZHerXTs=;
	b=qavj5MhTSvJRCF9J0MiircfSlkIm8v927uxY/RydR3WgRSDsurECXTraE3n364Dh4s8dm7
	wrOvZf+zUBiEMB9KaVdHYcPHMx0v+xxUOfOS5dPP1Zj8VHikmzXn58rih3CTaPwsgEdTyK
	IQjQUJSoeTnHekNCFOTQ7mALfwNr97M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754662524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nCJX2YVHRzsi+NQ8DFEFBBW8/NL0NIQfBKtZHerXTs=;
	b=vcMJx+qllMS5++GYAm0RxaJ5042O3IDvPfV7XxysuUg8yP2EqWluevmzshjG9V+8/1uP6l
	o6BCxligy4dTNuCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 356C51392A;
	Fri,  8 Aug 2025 14:15:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Dp1xOnsGlmg7MQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 08 Aug 2025 14:15:23 +0000
Date: Fri, 8 Aug 2025 11:15:13 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Wang Zhaolong <wangzhaolong@huaweicloud.com>, Stefan Metzmacher <metze@samba.org>, 
	Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES
 and use netmem allocator
Message-ID: <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm>
References: <20250806203705.2560493-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250806203705.2560493-1-dhowells@redhat.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: AA61C5BDEE
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01

Hi David,

On 08/06, David Howells wrote:
> (3) Rewrite the base TCP transmission to be able to use MSG_SPLICE_PAGES.
>
>     (a) Copy all the data involved in a message into a big buffer formed
>     	 of a sequence of pages attached to a bvecq.

Nice!

>     (b) If encrypting the message just encrypt this buffer.  Converting
>     	 this to a scatterlist is much simpler (and uses less memory) than
>     	 encrypting from the protocol elements.

This could've been done a long ago, but since you're on it... crypto API
supports in-place ops (src == dst), so you can save yet another allocation
here.

This is also possible from SMB2 side because the spec says if encryption
fails, the request should be failed as a whole.

>     (d) Compression should be a matter of vmap()'ing these pages to form
>     	 the source buffer, allocating a second buffer of pages to form a
>     	 dest buffer, also in a bvecq, vmapping that and then doing the
>     	 compression.  The first buffer can then just be replaced by the
>     	 second.

OTOH, compression can't be in-place because SMB2 says that if
compression fails, the original uncompressed request must be sent (i.e.
src must be left untouched until smb_compress() finishes).

I don't know how relevant these comments are for you and your patches,
but HTH.

Directly related to the patches: it would be great if you could handle
commented out code, either by completely removing them, or by providing
some in-code fallback mechanism (I'll reply to the patches).

Other than that, +1 for the cleanup/refactoring; I really like the new
smb_message/transport infrastructure!


Cheers,

Enzo
