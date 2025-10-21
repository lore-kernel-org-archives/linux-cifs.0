Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECBC34D91A
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 19:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761074136; cv=none; b=JL1DgRUxg19F6tH4f6nLaz4xu+KFgUwJ4ZF20uL7ya0T7AUV8Q2KM9rrQx4pMEVOD9SZFIvPjqk2utXZKzNFZGBOk79EGWpMSztdORRXlf0EdLeaBKn1Z8TIzPAAz+m/tg1kVSANfsQ9564fcDx+OyTOC2h9/rPl4oCzXarzuhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761074136; c=relaxed/simple;
	bh=KrK89DSZfM/EzhQJ3XfHcBpiNt3K+mGQIy0r3lOs7bY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKzqzFj5RVlxeAudlz/MA3WaSB+VVsNh+gWhJcU9VjmLfFBYd5Mvx8YbVn18dKaVL4dxDZVVxqM2/Y3lWTIkTLGYaZkN9JW3VJm+/1zQaVXBpQeHFdhMmQOvRmyXCrAjEWPn3HloDHDfSgYzhDIIUWJMysl2yBm/G92FnupnnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z9c6K2tt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=r4PeKDRO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dg2+NH2G; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Su9DZB7F; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z9c6K2tt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="r4PeKDRO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dg2+NH2G";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Su9DZB7F"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17A561F397;
	Tue, 21 Oct 2025 19:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761074128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vqGj01DN27mHnPeSIAF/3BxVWcaGy6GuoNC93tL0ScQ=;
	b=z9c6K2ttDFat2ZUXB3s6qspF3+1b6f72T6t4WrntUcykb4MoMgYBW0rmLTVa7PVBJ3hgOC
	4OdosfsuNlBmCBqffRwwEghC/4q/CxnZlmKWj79/+nj/y60TEWSsvLQaOKAfoqw8L2kUpm
	09Ah6/B+QmNPp2Iv9MxFwO4U90JHNKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761074128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vqGj01DN27mHnPeSIAF/3BxVWcaGy6GuoNC93tL0ScQ=;
	b=r4PeKDROEg5JVPVBHWuP8m0pRae9yGpK+b3GBjbQ7qFCrEer1du95SAjqF8gf5i0Qk4s4/
	Ciw76cxTZnQ24ADQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dg2+NH2G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Su9DZB7F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761074123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vqGj01DN27mHnPeSIAF/3BxVWcaGy6GuoNC93tL0ScQ=;
	b=dg2+NH2Gj7wSCpRDg5F7TC2p1Eq78w+LutqB4SFMzlSYXVBwa7PALKmIBOoWFGB0e+sUWs
	cljtGUtXMyxod0/uXjFq4fGBWYJY+UmRbuuyLKUTLbyvsTmHcXE+7L4yU7bKPbBimKtPz/
	1k+cHREDLLFL+JRGt6Tlpi6ekLeOWNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761074123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vqGj01DN27mHnPeSIAF/3BxVWcaGy6GuoNC93tL0ScQ=;
	b=Su9DZB7FD4/eKypSPhKgc0swLmoUMFq45UJc1JKAwkm0mkuRtuP2NHyt+WCVHjupKo7fb0
	XaQ+beXNg/5UApAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A9EC139D2;
	Tue, 21 Oct 2025 19:15:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C2SaFMrb92j8fQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 21 Oct 2025 19:15:22 +0000
Date: Tue, 21 Oct 2025 16:15:20 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Thomas Spear <speeddymon@gmail.com>
Cc: Steve French <smfrench@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>, linux-cifs@vger.kernel.org
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when
 enforced via sysfs or modprobe options
Message-ID: <rsmt3c27mnkm2nprau6waeexxpo3y3fg43rzxjj7gxbwor3mwh@6yppid4sbeej>
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
 <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
 <eksh6mo4hhijkea2o3lalpbsoju7sp4nwwvo62l2fhs7hkvaid@6aisea5jt3f2>
 <CAEAsNvTNf14E8iVrtptzSqQ4Gq8QsM4sHpJ0tfTyt4mkFWCk7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEAsNvTNf14E8iVrtptzSqQ4Gq8QsM4sHpJ0tfTyt4mkFWCk7w@mail.gmail.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 17A561F397
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,lists.samba.org,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.01

On 10/21, Thomas Spear wrote:
>This sort-of makes sense as to why it's happening. I can understand
>some code so what I see here is:
>
>>  else if (enable_gcm_256) {
>>                   pneg_ctxt->DataLength = cpu_to_le16(8); /* Cipher Count + 3 ciphers */
>>                   pneg_ctxt->CipherCount = cpu_to_le16(3);
>>                   pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_GCM;
>>                   pneg_ctxt->Ciphers[1] = SMB2_ENCRYPTION_AES256_GCM;
>>                   pneg_ctxt->Ciphers[2] = SMB2_ENCRYPTION_AES128_CCM;
>
>Here, AES-256-GCM is second to AES-128-GCM when enable_gcm_256 is
>true, but if AES-256-GCM is still present as one of the ciphers as per
>this snipped, and the server doesn't support AES-128-GCM, shouldn't it
>fall-forward to AES-256-GCM instead of causing an error?

That's correct.

But I also see it working fine against Windows Server 2022.

On server:
   > Set-SmbServerConfiguration -EncryptionCiphers "AES_256_GCM"

On client:
   # mount.cifs -o ...,seal //srv/test /mnt/test
   # cat /sys/module/cifs/parameters/require_gcm_256
   N
   # cat /sys/module/cifs/parameters/enable_gcm_256
   Y
   # grep Encryption /proc/fs/cifs/DebugData
   Encryption: Negotiated cipher (AES256-GCM)

> IOW, I'm
>wondering if there's an issue elsewhere that's preventing the
>AES-256-GCM cipher from being used and reordering would simply
>band-aid the issue.
>
>> so if the server supports AES-256-GCM, the only way to make cifs use it
>> is with 'require_gcm_256', unless you disable AES-128-GCM on the server
>> (as you have observed).
>
>Actually, the issue I'm observing is that _when_ we disable
>AES-128-GCM on the server (Azure Files), mount.cifs on the client is
>failing to mount the share completely _until_ I set require_gcm_256.

Azure sometimes responds with unexpected (sometimes even out of spec)
settings.

I'll setup an Azure Files instance to test this.


Cheers,

Enzo
