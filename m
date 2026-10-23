Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792779864;
	b=LLqavCaClJm0ckKYxWp5VJb8yZYiEja3uHU/BHzGIgRVM69PbjI2HjrVSd9hTgSvj/WZ
	 4cRUYE/Pp71r5xnd0xjVfNBnuyQQEdnqAjURWdB8cxB7paBljqWWOthfomeTrmM2JehKO
	 kPgulv+a3ZQzBP1VG9fYEG0u85+Z5ou1R7De463OJLZTpCL1OcLqfg7yxDf9wUKoODnAG
	 QcbSUA2a5DKP4IErH0Ewn/wJH7gTOjV8MRXT3Y1N3SbpiLYpGIvwROenbQNP+CjexsxHs
	 Ruw7w02ZTKEffQxIqQV+x7I5oA+o7fj/YJtRZGZSlxA8kodSvtKpc4vp1w4UfJ9HI0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792779864;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=7PGT7HioSP3JeBidYrILtUI8RZdOjDlFCftJUAqdOvQ=;
	b=JqRJBgt3ut+cOtmMhos9eoUjowWCfHJ/D79ibLwfsjnIniWXtMzeSkbOSuvg4aI3cZli
	 TcICqel8EgwEPrml06mapVxEVuEAsBAq+ZjdfCnZ0ZZJl/cmQ1WT1rwxy/AtmmnjtJ6yb
	 J+cBrwAg5OjdzDbrz1xNg1+L+Y+ZS8CVaXh6J2ikSw6JIHfFLBm3yY7q9nv4pCCjcfNWU
	 OnQKd10fPUdOA748sXFoxVfk+zLouWZ9nP+Cd6qc1rWIqvDS9g8Op64P/jcWPuvIgT1VL
	 oynmd/+73xvkePQlDUVgHEABk61+/yyASyG1t95rclxfXy/ZgUtRwgm2JZAxfXyVIrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wxJcKxRT;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Y+vQyaBJ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wxJcKxRT;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Y+vQyaBJ;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CC1606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 18:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94CC1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wxJcKxRT;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Y+vQyaBJ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wxJcKxRT;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Y+vQyaBJ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B90F71F38C;
	Fri, 23 Oct 2026 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792779861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7PGT7HioSP3JeBidYrILtUI8RZdOjDlFCftJUAqdOvQ=;
	b=wxJcKxRTovLA2NDgJNSoy7ThB1N08734o1bdfRZVttaq83HWttKS8EKgX8vdgqzb+8hbyZ
	EpffpkoDbMC7ffF4AYTtUyLvkVVnUPs9Czqu1v6GVmT31vq4+rNu57viMTQz+EqfJhfJ9r
	WM4B0DKHvC8ZVQVY+eZnEPDSekLwzu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792779861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7PGT7HioSP3JeBidYrILtUI8RZdOjDlFCftJUAqdOvQ=;
	b=Y+vQyaBJt2TUBdSp5XTBR5YA/GhenukmKZ7uPupLQK4u0qI97Wdw2TewYRmCA75EJ6II2s
	w4pnebOTbzZJdGCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792779861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7PGT7HioSP3JeBidYrILtUI8RZdOjDlFCftJUAqdOvQ=;
	b=wxJcKxRTovLA2NDgJNSoy7ThB1N08734o1bdfRZVttaq83HWttKS8EKgX8vdgqzb+8hbyZ
	EpffpkoDbMC7ffF4AYTtUyLvkVVnUPs9Czqu1v6GVmT31vq4+rNu57viMTQz+EqfJhfJ9r
	WM4B0DKHvC8ZVQVY+eZnEPDSekLwzu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792779861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7PGT7HioSP3JeBidYrILtUI8RZdOjDlFCftJUAqdOvQ=;
	b=Y+vQyaBJt2TUBdSp5XTBR5YA/GhenukmKZ7uPupLQK4u0qI97Wdw2TewYRmCA75EJ6II2s
	w4pnebOTbzZJdGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 004FA133F3;
	Fri, 23 Oct 2026 18:24:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YszoIFSm22q8fwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 23 Oct 2026 18:24:20 +0000
Date: Fri, 23 Oct 2026 15:24:18 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org
Subject: Re: ksmbd: AES-GMAC signing support?
Message-ID: <atugaviJxR8nzHQO@suse.de>
References: <20261023174821.17552-1-mike.michalo@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261023174821.17552-1-mike.michalo@gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-10.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -10.80

Hi Michail,

On 10/23, Michail Andreas Michalopoulos wrote:
>Hi Namjae,
>
>ksmbd currently negotiates HMAC-SHA256 and AES-CMAC for SMB 3.1.1
>signing, but not AES-GMAC (SIGNING_ALG_AES_GMAC is defined in
>fs/smb/common/smb2pdu.h but unused), which is what Windows 11 and
>Server 2022 clients prefer when it is offered.
>
>Would you be interested in patches adding it? Roughly:
>
> - accept AES-GMAC in the SMB2_SIGNING_CAPABILITIES negotiate context,
> - sign and verify with gcm(aes) over the message, using the nonce
>   from MS-SMB2 3.1.4.1 (MessageId plus the request/response and
>   CANCEL bits), and
> - keep HMAC-SHA256/AES-CMAC behaviour unchanged.
>
>I would test it with smbtorture's signing tests and the ksmbd CI
>tests, and check the existing signing paths against an older Windows
>server I have access to.
>
>I have exams until mid-November, so I would start on it after that,
>and as it is a bigger change it may take a few weeks. If someone
>needs it sooner, I'm happy to leave it to them.
>
>Before I start: is anyone already working on this, or is there
>anything you would like done differently?

I did this 4 years ago for cifs:

https://github.com/smfrench/smb3-kernel/commits/aes-gmac-v3/

I never sent the patches because my tests [0] showed that AES-CMAC was
slightly faster for cifs case.

After talking to Steve about it, our conclusion back then was that such
non-negligible overhead wasn't really worth the code change [1].

Feel free to use that code as a reference for your implementation.

I could certainly have gotten something wrong, but I didn't (don't)
really have the time to work on it again.


Cheers,

Enzo


[0] my tests were done with a user POV in mind, so everything was
measured in workload time rather than us/ms tracing.  Tested only
on common desktop HW too.

[1] AES-CMAC uses the shash crypto API, but AES-GMAC uses AEAD
encryption API (to only sign a payload you use an empty plaintext
buffer, and set the full payload to the associated data buffer).

This makes it require non-trivial changes other than simply loading
another shash alg.
