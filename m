Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF101A2872
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754683148; cv=none; b=goFluAwYLqs9WWy7c3b9fdLkbmyYcZN+FABTGNZKyrghfN+RuNTcSH9BvBBMsdI2FZHCLi/L+dGQk3cEszjM4/PQvE4nXajjA2/a8dyW15qSJoeOakrUqAOCZ1q0lTD22KaXrnXIlFS4JxDFEhexXmSAQpy2JaeBVH5W7fBN+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754683148; c=relaxed/simple;
	bh=VBb9zEkv38ylfHY0Cw/evVtvUUWPgb/DyPLceoi/7tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZX4irESmFaBkPKbAu9+j1RF+rmLRj7IDucXEBo7SHIeGdUokaZa5Rw0M3b477avBojLXMRBhHJTYBqONpJo/fpKkEuxTBVSbuqltZyN4cf9UQ5fxhjRUf1ex4gFpE7TSweNa4CWZAArIYeprWpe/m222KA4LpcZ8H91hX8bE9aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s/vcxHHx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EDoWnzRn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OOEEGGKs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5s58R7dT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s/vcxHHx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EDoWnzRn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OOEEGGKs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5s58R7dT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B4A022296;
	Fri,  8 Aug 2025 19:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754683145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHofNAmOe1s5LZNCui/VKbdF+qdGoXNU+mj8mYOF4XA=;
	b=s/vcxHHxesMeyUzvS2wMg7e/Fych8N7pJsKi4kBTse4b4BxnwT9SVtlGda0T6bdZGgeRgI
	/oNBPiskw1qkP34U8Kg53BH6XEJ4zIgZstlrU4Uj2aXiftrkEJU8tuyAFLPQ8NIny9fv3B
	7f/TL4OOkFyOeO5a1FrVmEFG9jniHYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754683145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHofNAmOe1s5LZNCui/VKbdF+qdGoXNU+mj8mYOF4XA=;
	b=EDoWnzRn9HOAKkk0Q7Jg0ffkkpWWq3KWDjRxd1/ykOXfhecx/h4RMRrxCzRdM1CXh3v01X
	Lk7bh3VuoEwenXCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754683144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHofNAmOe1s5LZNCui/VKbdF+qdGoXNU+mj8mYOF4XA=;
	b=OOEEGGKsibyLhrkaGv/UOlLkxBWHynXHth1erG9xklrR5WIJbc8YUf+ihlBB54m5b6A/q6
	BNWJkK7AygjGYeXmQO2FzxxukP/fgppiMrIMyEdOLpEbcclCFTSoiUGDMRlGIeOCPLl9WZ
	P1j7f9YqwNDkdee3Oou3qep+C+1ggAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754683144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHofNAmOe1s5LZNCui/VKbdF+qdGoXNU+mj8mYOF4XA=;
	b=5s58R7dTY2bXkGy6xL8ZX3ktusy2fAkdwifr4DCKtMauF5smjTNm8y8FX8BlMKZisF67bj
	+12Bphurqfp05zCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CAEEA1392A;
	Fri,  8 Aug 2025 19:59:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id doZmJAdXlmh0CAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 08 Aug 2025 19:59:03 +0000
Date: Fri, 8 Aug 2025 16:58:57 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Wang Zhaolong <wangzhaolong@huaweicloud.com>, Stefan Metzmacher <metze@samba.org>, 
	Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES
 and use netmem allocator
Message-ID: <dseje3czotanrhlafvy6rp7u5qoksqu6aaboyyh4l36wt42ege@huredpkntg2t>
References: <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm>
 <20250806203705.2560493-1-dhowells@redhat.com>
 <2938703.1754673937@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2938703.1754673937@warthog.procyon.org.uk>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 08/08, David Howells wrote:
>Hi Enzo,
>
>> >     (d) Compression should be a matter of vmap()'ing these pages to form
>> >     	 the source buffer, allocating a second buffer of pages to form a
>> >     	 dest buffer, also in a bvecq, vmapping that and then doing the
>> >     	 compression.  The first buffer can then just be replaced by the
>> >     	 second.
>>
>> OTOH, compression can't be in-place because SMB2 says that if
>> compression fails, the original uncompressed request must be sent (i.e.
>> src must be left untouched until smb_compress() finishes).
>
>I've got a change which should achieve this, but it seems I can't test it.
>None of ksmbd, samba and azure seem to support it:-/

Yes, Windows 11 or Windows Server 2022+ only.

Compression for ksmbd and samba have been on my TODO list for too long,
I should get back to it :/

Anyway, if you want me to test, just send me the patches.
I have your linux-fs remote as well, if that's easier.


Cheers,

Enzo
