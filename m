Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D48308F25
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 14:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366686; cv=none; b=nJBi5zJWDsax+T/mLFCBOezvj4HA7HBubs1ZXZb/JAlqot6AZUcUkdhZIHKk2cO4AkAUdclSEPGcyxZuCEx8p4DaC4eIg0p9XZ5V6kV/ZDG+SZkV4GcIumapEhlTfXAZ4lpnEWyfo4B+szOkSUpqzeaQNayrCcI1bzpEgUZNxDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366686; c=relaxed/simple;
	bh=ywXpP59Lk88yCseXP50OE5LNKsf9iCO/d2MVzhXqhDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQl8K4q1iBZS3ExgKKFyzhbeTrrOvaIin1Z3DpONFQi4XMTp5INcP7Hw+gE6ju98FeP0X8XYqSnPDsxP/8nOZzE+xyvpRbfQWyk5VlyRSBSLFp+aQfBB/4GmG3MEiR21eNhTsRR1yxZCctHcflCcWvfUYr9aMXIBYir7Dm8KK74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VK+1EE4j; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H+Z+hlMP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hkN0EgMX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FHAP454y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VK+1EE4j";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H+Z+hlMP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hkN0EgMX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FHAP454y"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9512521905;
	Mon, 13 Oct 2025 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760366681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+B3cRhWFJTukv1G4BnYWSSIGt6ZCh6nUUGxVgo8uAQ=;
	b=VK+1EE4j3M6zBqUyqwsfJPZ7wNYbNuR1eUYpArR9NC5nxT0JEYhfCqG3l/1UbRM8XVeAgD
	OP0ejKQsBj5T8f9bIQnjWVkcKyFcX8n6r7VgwfemCk5Xer8TbVvXtU1PO6ufXcSm+jf7I7
	0qcZxo/SElX6uWKsTJCbr/DdMo7uR+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760366681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+B3cRhWFJTukv1G4BnYWSSIGt6ZCh6nUUGxVgo8uAQ=;
	b=H+Z+hlMPXqFqLSc2kVG/rLS0qhGuA8ExX3p3hiaPm4lBldtXUsA9IZ5fg0XElV5gpVt8mp
	TA9WceHuz9oKuUCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hkN0EgMX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FHAP454y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760366680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+B3cRhWFJTukv1G4BnYWSSIGt6ZCh6nUUGxVgo8uAQ=;
	b=hkN0EgMXB8IgYv43vMMrxEPUrwlVUpg7/bsuVp035BGXrnqO2UTWc9/uGV0Y/B2ihoI0TF
	UfiYAbs6vrdVLfBdsWUUqMvC/1w863h6ipglsyft76uCD275x9BlmpoHMSXnVNQB7Hb8/j
	JNqGyyE8fu1nTh7W6JPQvPTs7IfIHT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760366680;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+B3cRhWFJTukv1G4BnYWSSIGt6ZCh6nUUGxVgo8uAQ=;
	b=FHAP454y4M6+ghCQIv03zw8w029neiqKz5sutpVNxnz92au7q04wTGUqqbMW0bPmU9qH0Q
	yaMIuKKvyDU9IXAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1852A13874;
	Mon, 13 Oct 2025 14:44:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jQVKNFcQ7Wh4KQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Oct 2025 14:44:39 +0000
Date: Mon, 13 Oct 2025 11:44:37 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	samba-technical@lists.samba.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/8] smb: client: More crypto library conversions
Message-ID: <ihoaj3ymhuesevdb7k2kg2a2axdkishrrrjr2teigelhkxmt4s@do2n6pkdmaas>
References: <20251012015738.244315-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251012015738.244315-1-ebiggers@kernel.org>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 9512521905
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
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,samba.org,lists.samba.org,manguebit.org,gmail.com,microsoft.com,talpey.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.01

Hi Eric,

On 10/11, Eric Biggers wrote:
>This series converts fs/smb/client/ to access SHA-512, HMAC-SHA256, MD5,
>and HMAC-MD5 using the library APIs instead of crypto_shash.
>
>This simplifies the code significantly.  It also slightly improves
>performance, as it eliminates unnecessary overhead.
>
>Tested with Samba with all SMB versions, with mfsymlinks in the mount
>options, 'server min protocol = NT1' and 'server signing = required' in
>smb.conf, and doing a simple file data and symlink verification test.
>That seems to cover all the modified code paths.
>
>However, with SMB 1.0 I get "CIFS: VFS: SMB signature verification
>returned error = -13", regardless of whether this series is applied or
>not.  Presumably, testing that case requires some other setting I
>couldn't find.
>
>Regardless, these are straightforward conversions and all the actual
>crypto is exactly the same as before, as far as I can tell.

I think the overall series looks good and do a great cleanup.

Just a minor nit about fips_enabled: since it's now being handled
explicitly (rather than an error on cifs_alloc_hash() currently), I
think it makes sense to move the check to mount code path when
'sectype == NTLMv2' (I don't particularly care about SMB1, but
something similar can be done for 'smb1 && sign' cases I guess).

>Eric Biggers (8):
>  smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
>  smb: client: Use HMAC-SHA256 library for key generation
>  smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
>  smb: client: Use MD5 library for M-F symlink hashing
>  smb: client: Use MD5 library for SMB1 signature calculation
>  smb: client: Use HMAC-MD5 library for NTLMv2
>  smb: client: Remove obsolete crypto_shash allocations
>  smb: client: Consolidate cmac(aes) shash allocation
>
> fs/smb/client/Kconfig         |   7 +-
> fs/smb/client/cifsencrypt.c   | 201 +++++++++++++---------------------
> fs/smb/client/cifsfs.c        |   4 -
> fs/smb/client/cifsglob.h      |   3 -
> fs/smb/client/cifsproto.h     |  10 +-
> fs/smb/client/link.c          |  31 +-----
> fs/smb/client/sess.c          |   2 +-
> fs/smb/client/smb2misc.c      |  53 ++-------
> fs/smb/client/smb2proto.h     |   8 +-
> fs/smb/client/smb2transport.c | 164 +++++----------------------
> 10 files changed, 131 insertions(+), 352 deletions(-)
>
>
>base-commit: 67029a49db6c1f21106a1b5fcdd0ea234a6e0711
>-- 
>2.51.0


Cheers,

Enzo
