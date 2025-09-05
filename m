Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF0517F4F6
	for <linux-cifs@vger.kernel.org>; Fri,  5 Sep 2025 14:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082102; cv=none; b=UfHu1G3ms+d6B8ioX30JWkA5nP20dveSYSXf5RH9cK9H2xej1jCp1yPvvP86BJx4nJqPrOCkOjjprWUjN5fESHYTEMb2ImeHzumqXLKpT6eXgDGF14c6tnIIkVWw3stAqevud/OOF2nshrxooqmFPojQcYDRAW4CIrbAQrvwJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082102; c=relaxed/simple;
	bh=GrOe2tAQ+eXoCAg4sRL2egs2/ru9Fc1Ib0KPYpFdXa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGG8MsLlt5xKKhUqpT5ni5eL5muKHLwTnLuVOLTs/lKIYy4+PmISvCHNesO7lAKvrR4FOQhAW71ioujDZMSU8885/kXTrSKYKltYMFal9OSCSVoYfPiU63zyqdp+xjoyNfQQPTPmBTO62h4bdbkVgWD8KItEb4UIon0nQujydqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sT/4t3HQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a0LBke4c; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sT/4t3HQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a0LBke4c; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sT/4t3HQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a0LBke4c";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sT/4t3HQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a0LBke4c"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 315384EAAE;
	Fri,  5 Sep 2025 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757082098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9dKKD9KsNhIizCOYg08ty0PO8e8ojpGyQDggaf/to8=;
	b=sT/4t3HQlqCoUfQElC/fCX5LaDqRVKLrMvgXexS4lXN1/rLZb2Rp3/edZIMSzFGEH+9SFh
	/W37JR9xJSAWxksADoFFbih3LFGXLq1c4xgvQMvL/1LZp4wBXTa7xl80qg9E2gaUNtNkKc
	k55c8xqxSF1PFkHllsH9bACj70R4DbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757082098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9dKKD9KsNhIizCOYg08ty0PO8e8ojpGyQDggaf/to8=;
	b=a0LBke4ccj6Ht4Sx+7vCCXITCXygLCylkoZd3cxmBQrNwizKJ3DRVbVt6NsNsjebtDZ9wJ
	SIN8cnrHHjXnrSBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="sT/4t3HQ";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=a0LBke4c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757082098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9dKKD9KsNhIizCOYg08ty0PO8e8ojpGyQDggaf/to8=;
	b=sT/4t3HQlqCoUfQElC/fCX5LaDqRVKLrMvgXexS4lXN1/rLZb2Rp3/edZIMSzFGEH+9SFh
	/W37JR9xJSAWxksADoFFbih3LFGXLq1c4xgvQMvL/1LZp4wBXTa7xl80qg9E2gaUNtNkKc
	k55c8xqxSF1PFkHllsH9bACj70R4DbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757082098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9dKKD9KsNhIizCOYg08ty0PO8e8ojpGyQDggaf/to8=;
	b=a0LBke4ccj6Ht4Sx+7vCCXITCXygLCylkoZd3cxmBQrNwizKJ3DRVbVt6NsNsjebtDZ9wJ
	SIN8cnrHHjXnrSBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0D3D139B9;
	Fri,  5 Sep 2025 14:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8uscHvHxumgjBgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 05 Sep 2025 14:21:37 +0000
Date: Fri, 5 Sep 2025 11:21:31 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.com>, Matthew Wilcox <willy@infradead.org>, 
	Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath SM <bharathsm.hsk@gmail.com>
Subject: Re: Growing memory usage on 6.6 kernel
Message-ID: <ddd6lpyi36bfbe5qhaqc25m2nfw4rfh7rwjzrsx2chkf3p5zji@4xq5ew2qisha>
References: <CANT5p=ofG-CQF_Rmv15+HAe0Jd1u1r=uqa-nYyDFOBOJ-0-jng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=ofG-CQF_Rmv15+HAe0Jd1u1r=uqa-nYyDFOBOJ-0-jng@mail.gmail.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 315384EAAE
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,manguebit.com,infradead.org,gmail.com,vger.kernel.org];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,linaro.org:url]
X-Spam-Score: -2.51

Hi Shyam,

On 09/05, Shyam Prasad N wrote:
>Hi David / Paulo / Matthew,
>
>We have a customer who is reporting a behaviour change in the way that
>cifs.ko manages pages with Azure Linux running 6.6 kernel. This kernel
>is generally on par with stable 6.6 tree.
>They have a test program which simply opens a file, writes to it and
>closes it (it chooses one of 100 files at random). It spawns multiple
>threads which do this in parallel.
>They reported that the memory usage keeps growing and that at some
>point, the VM becomes unusable.
>
>I checked what's going on, I see that there is no memory being leaked.
>The output of free command reports approximately the same available
>memory as it runs. However, I see that the "Inactive" section of
>/proc/meminfo keeps growing:
>https://man7.org/linux/man-pages/man5/proc_meminfo.5.html
>
>              Active %lu
>                     Memory that has been used more recently and usually
>                     not reclaimed unless absolutely necessary.
>
>              Inactive %lu
>                     Memory which has been less recently used.  It is
>                     more eligible to be reclaimed for other purposes.
>
>I see that this behaviour is not the same on Ubuntu's 6.8 kernel. The
>inactive memory does not grow.
>And on the same 6.6 kernel, a trial on ext4 filesystem also shows
>similar results. The inactive count does not grow.
>
>My understanding is that these are reclaimable pages, which is why
>free is not showing a growth in memory.
>But the customer is claiming that they can consistently reproduce this
>issue and that the VM goes unresponsive as this memory keeps growing.
>
>Any idea what may be causing this?
>Is there a known fix in more recent kernels that you're aware of which
>needs to be backported?

We had a very similar bug in our v6.4-based SLES, it's a folio leak.
We fixed it with this downstream patch:

https://lists.linaro.org/archives/list/linux-stable-mirror@lists.linaro.org/message/FY4GYKLWIMQKGPI4CDDANZH2AFIK6NM4/

Copying a single large (100GB+) file also makes the VM unresponsive.

HTH


Cheers,

Enzo
