Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B951FE461
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754915119; cv=none; b=iuNtiAeMJgjtHGvxQ8y2WkZbKwsu0UGXNRZwR6wJLa3/vRS46ItFUdlaPKMjmaLq/YPpGv4cAcOgamUeKrjggQX4WBMJyB55hJMQ4PEFOOVpejys4Hf+GZF2xS3Ao3BsAFRpv+K7KffmxtSytMSrs9tUOd+mBlS6cBPWWhM5ZAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754915119; c=relaxed/simple;
	bh=2jfg50HXaRr8zGpsbEYSNizjN7rgUPJiQx7uagTFEyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0yWUm2X2/vDUUKLxVrtgn4liKnGQA/AMSolK9vsMTG/y1Q6xnbOEtd7Dqsko+GC14ld2QqOrNgXfEthy9oZBXIYKiwVPQgrVXZYld+WnL52tj3RJ9kumH6eUB2lqDdvuIbL/LFZWFiT+TANFXGXTW5HPxAmh3qZKTTxuiNwU+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y64aryxr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CESkPW/N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y64aryxr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CESkPW/N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y64aryxr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CESkPW/N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y64aryxr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CESkPW/N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 54B8D1F394;
	Mon, 11 Aug 2025 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754915116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G/xz727bLKnxBk+S5wMVGYSxOC92grzf7CfZhE1HKmM=;
	b=y64aryxrfGUdaSfgdkinkKKhl6wjhuqJcePhuMFM1//K28b69bO5kAEujutkb+bqqNDf0n
	WNaGDPFMFTPOE49dHY5kbmT5D8Oe/suT1qI2GVkdogFT8EnnNhLV3wCg95j/3rKXKC/+2h
	L2E0dKt8m8Q8Go+AquzVaLwM/fY4VFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754915116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G/xz727bLKnxBk+S5wMVGYSxOC92grzf7CfZhE1HKmM=;
	b=CESkPW/No/9mUwQ9kKchjZk7RMalcqU0tYGFZdfF1zEeh+Aa51DCkwdy+3Iy0tUJzByELt
	VdaHg3CZFV9swvCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754915116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G/xz727bLKnxBk+S5wMVGYSxOC92grzf7CfZhE1HKmM=;
	b=y64aryxrfGUdaSfgdkinkKKhl6wjhuqJcePhuMFM1//K28b69bO5kAEujutkb+bqqNDf0n
	WNaGDPFMFTPOE49dHY5kbmT5D8Oe/suT1qI2GVkdogFT8EnnNhLV3wCg95j/3rKXKC/+2h
	L2E0dKt8m8Q8Go+AquzVaLwM/fY4VFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754915116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G/xz727bLKnxBk+S5wMVGYSxOC92grzf7CfZhE1HKmM=;
	b=CESkPW/No/9mUwQ9kKchjZk7RMalcqU0tYGFZdfF1zEeh+Aa51DCkwdy+3Iy0tUJzByELt
	VdaHg3CZFV9swvCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA16B13479;
	Mon, 11 Aug 2025 12:25:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v4+4IyvhmWiqMAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 11 Aug 2025 12:25:15 +0000
Date: Mon, 11 Aug 2025 09:25:09 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Wang Zhaolong <wangzhaolong@huaweicloud.com>, Stefan Metzmacher <metze@samba.org>, 
	Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES
 and use netmem allocator
Message-ID: <q4ngijgig45tompgxwc7eu2odtjp65lby2lx6bpbvu3sw2inlm@mfpunzg4uaur>
References: <dseje3czotanrhlafvy6rp7u5qoksqu6aaboyyh4l36wt42ege@huredpkntg2t>
 <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm>
 <20250806203705.2560493-1-dhowells@redhat.com>
 <2938703.1754673937@warthog.procyon.org.uk>
 <308528.1754868563@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <308528.1754868563@warthog.procyon.org.uk>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 08/11, David Howells wrote:
>Hi Enzo,
>
>I now have encryption, compression and encryption+compression all working :-)
>
>I've pushed my patches here:
>
>	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=cifs-experimental
>
>It should work up to "cifs: Don't use corking".

Great! I'll try it out later.

>Btw, is is_compressible() actually worth doing?  It seems to copy a lot of
>data (up to 4M) to an extra buffer and then do various analyses on it,
>including doing a sort.

Compression, as a whole, is actually only worth doing if one is paying
more for network traffic than computing.  is_compressible() tries to
balance that to avoid a "compress/fail/send original" cycle, as it takes
0-4ms on a 4M payload (on my machine) whereas, without it, a failing
cycle can take up to 40ms.

>I need to extract a fix for collect_sample(), which I can do tomorrow, but it
>should look something like:
>
>/*
> * Collect some 2K samples with 2K gaps between.
> */
>static int collect_sample(const struct iov_iter *source, ssize_t max, u8 *sample)
>{
>	struct iov_iter iter = *source;
>	size_t s = 0;
>
>	while (iov_iter_count(&iter) >= SZ_2K) {
>		size_t part = umin(umin(iov_iter_count(&iter), SZ_2K), max);
>		size_t n;
>
>		n = copy_from_iter(sample + s, part, &iter);
>		if (n != part)
>			return -EFAULT;
>
>		s += n;
>		max -= n;
>
>		if (iov_iter_count(&iter) < PAGE_SIZE - SZ_2K)
>			break;
>
>		iov_iter_advance(&iter, SZ_2K);
>	}
>
>	return s;
>}
>
>What's currently upstream won't work and may crash because it assumes that
>ITER_XARRAY is in use - which should now never be true.

Yes, compression was merged when that was the only case.

>Also, there's a bug in wireshark's LZ77 decoder.  See attached patch.

Good catch :)
There are several, actually... if you vary the compression parameters
defined (min len, min/max dist, hash log) within acceptable limits,
you'll notice that, even though wireshark might show some as malformed
packets, Windows is able to decode them just fine.

I really need to reserve some time to work on this again :(


Cheers,

Enzo
