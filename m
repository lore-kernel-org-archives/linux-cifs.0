Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE10350A00
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 19:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076092; cv=none; b=rqaZDMWq0WgBgxZzEHGwWDm/SU73G57F79tuANhv2jFwYNYGtohLSw9HMWCoO1sShXpiWQCiEgXTIkxcGmd1jcqZjNf/JRyljymZ2hNduHT1qExNsve5iYYfoac8HH64jOzF1nOPZowqNrB8V+bxpdB7gBB6IvEkm0PWrptDVJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076092; c=relaxed/simple;
	bh=zXRRCVV/EQD5t3lpNP3IrqeX+xtknAl5K5cjxFzA8Mw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnq7nSC9u3kRjyGGQ+01eh/aTlTVZd32+QSQzOcHkJNU1s9WRAL9LB2ISE1Fj8wSD8DoSmL+ViUOsyZrCWZdvlFwIu422Q502Rl2tr7gsapv9tYQI/KffTY2lIpLjUSt14IU35ifaUesYU0ZtdHQ3XhO+d7f0q13cboZhCufYXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hdelGbBz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZevXv3Y0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uxEDpkX4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SStoReiN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hdelGbBz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZevXv3Y0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uxEDpkX4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SStoReiN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A719D1F38D;
	Tue, 21 Oct 2025 19:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761076083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+sEBHSZpi6sapWx4QF59hK4GMWdVPR9DNXmFeXvPj8=;
	b=hdelGbBzcBF6rRyegV2m5qWlxidFDYszwCq9uP+aVVByQ/nvGs77waauvdnUBJsC1oyPFu
	muJBWsdK+CD98P3qJKKLvAVSkXH9QTGO1ww3g8x+UKk47wMo4+iZwrdB7xSjyiqfTvEQe3
	zwvX6A8HuBiqtkBRehIUPxjgu3ySyXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761076083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+sEBHSZpi6sapWx4QF59hK4GMWdVPR9DNXmFeXvPj8=;
	b=ZevXv3Y0HZlHG2wI+Swpgb23tefhoG8IL07VzGdMmRXRA5yxrTV8kWZsdkw0mWVM2ePbx3
	Pf0rNIAQEidypuBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uxEDpkX4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SStoReiN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761076079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+sEBHSZpi6sapWx4QF59hK4GMWdVPR9DNXmFeXvPj8=;
	b=uxEDpkX4chvRKDKgbqrgGYTX81E7yCfbZqCQeKXFN/NiyYQa+bE8ctpIxYA850ewZ1woEn
	16+tthp+Kh09uzl4kjwwkSJVHlQ9FMCacd4XgIUZx7TFxcSM01bjCN8IeBUf5FxCYxPdFu
	LVukJqf3INRrVpxowrXYPY1ntTk3ITU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761076079;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+sEBHSZpi6sapWx4QF59hK4GMWdVPR9DNXmFeXvPj8=;
	b=SStoReiNKmG8jjRthtnAumR0+qS6aAQcTq6L9BxrcYpwl06uXXB0n7zUvIkak96hIYIipV
	uDf5UpqxVnoo0/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3190D139B1;
	Tue, 21 Oct 2025 19:47:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id plgbOm7j92iuHQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 21 Oct 2025 19:47:58 +0000
Date: Tue, 21 Oct 2025 16:47:52 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Thomas Spear <speeddymon@gmail.com>, Steve French <smfrench@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>, linux-cifs@vger.kernel.org
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when
 enforced via sysfs or modprobe options
Message-ID: <4edwqongmxeuf2zvokxmzxi65k6cglammqdvsufrs4goc7qmij@g2hunlte7qm2>
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
 <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
 <eksh6mo4hhijkea2o3lalpbsoju7sp4nwwvo62l2fhs7hkvaid@6aisea5jt3f2>
 <CAEAsNvTNf14E8iVrtptzSqQ4Gq8QsM4sHpJ0tfTyt4mkFWCk7w@mail.gmail.com>
 <rsmt3c27mnkm2nprau6waeexxpo3y3fg43rzxjj7gxbwor3mwh@6yppid4sbeej>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <rsmt3c27mnkm2nprau6waeexxpo3y3fg43rzxjj7gxbwor3mwh@6yppid4sbeej>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: A719D1F38D
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
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,lists.samba.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.01

On 10/21, Enzo Matsumiya via samba-technical wrote:
>On 10/21, Thomas Spear wrote:
>>This sort-of makes sense as to why it's happening. I can understand
>>some code so what I see here is:
>>
>>> else if (enable_gcm_256) {
>>>                  pneg_ctxt->DataLength = cpu_to_le16(8); /* Cipher Count + 3 ciphers */
>>>                  pneg_ctxt->CipherCount = cpu_to_le16(3);
>>>                  pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_GCM;
>>>                  pneg_ctxt->Ciphers[1] = SMB2_ENCRYPTION_AES256_GCM;
>>>                  pneg_ctxt->Ciphers[2] = SMB2_ENCRYPTION_AES128_CCM;
>>
>>Here, AES-256-GCM is second to AES-128-GCM when enable_gcm_256 is
>>true, but if AES-256-GCM is still present as one of the ciphers as per
>>this snipped, and the server doesn't support AES-128-GCM, shouldn't it
>>fall-forward to AES-256-GCM instead of causing an error?
>
>That's correct.
>
>But I also see it working fine against Windows Server 2022.
>
>On server:
>  > Set-SmbServerConfiguration -EncryptionCiphers "AES_256_GCM"
>
>On client:
>  # mount.cifs -o ...,seal //srv/test /mnt/test
>  # cat /sys/module/cifs/parameters/require_gcm_256
>  N
>  # cat /sys/module/cifs/parameters/enable_gcm_256
>  Y
>  # grep Encryption /proc/fs/cifs/DebugData
>  Encryption: Negotiated cipher (AES256-GCM)
>
>>IOW, I'm
>>wondering if there's an issue elsewhere that's preventing the
>>AES-256-GCM cipher from being used and reordering would simply
>>band-aid the issue.
>>
>>>so if the server supports AES-256-GCM, the only way to make cifs use it
>>>is with 'require_gcm_256', unless you disable AES-128-GCM on the server
>>>(as you have observed).
>>
>>Actually, the issue I'm observing is that _when_ we disable
>>AES-128-GCM on the server (Azure Files), mount.cifs on the client is
>>failing to mount the share completely _until_ I set require_gcm_256.
>
>Azure sometimes responds with unexpected (sometimes even out of spec)
>settings.
>
>I'll setup an Azure Files instance to test this.

So I just tested this and it turns out that Azure is indeed responding
wrong values.

It responds with AES-128-GCM even when only AES-256-GCM is enabled.

Then, since cifs sends AES-128-GCM preferred by default, and Azure
replies with AES-128-GCM, all cifs can do is trust it and start
generating keys + trying to encrypt stuff.

This fails with STATUS_ACCESS_DENIED right on Session Setup
NTLMSSP_AUTH.  I didn't dig deeper so far, but it looks like Azure is
internally prepared to do AES-256-GCM, so it expects AES-256 values.

I don't think there's much to be done from cifs side TBH, so you should
try reaching out to Azure support.


HTH

Enzo
