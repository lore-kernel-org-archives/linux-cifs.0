Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446722;
	b=qG0oiwmWHBlrReL+LZUX/oYzjO86tVXfFEjEQnuXSCTFXIa85i1K/DJJ2nkUiMTeCxIH
	 qjJIEcr3Ajxpbgs7xtakqgOgAnSN+6DweSgeFx2dI2TiVMDzNxNuvXqmdqYysIVSYO473
	 OIQ82VDULboGEljEb3+GTsrkajjnk42uIfl5ecECP7DxeUK14k9dGPe3Ya/NBIBnpaWqd
	 ynUs43m6UD0gWIqya8O73LqDAf8M1YrnxVJkcQTkePSf00KwUViZutjmtKagslKfuOpHb
	 69EU2sX4ui5iGtrCrDDXL76bJLhqzeZXse/dZeBNdivhl66N96190WIikEsOAQPGI1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446722;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=NawzmRle3zK58b68NMU+T0/daswBzxGzH4m78eRsLlU=;
	b=dGcjZsdpA41c+zgFG36mmP0nY2yF+D1Y4VDwzpRv7NwUmolFQnAxLrY0Qv6YLjMV6J6w
	 IRtyDAYbzTX1ERQbfYqic6FAv3KD5ETGvu+ZT4UDCb8l9xSBbN0oXTKV+rdmLR56I5zKL
	 Aulha7iF6ruzuw9+p3KbiJJP63TY2Q2LlImCZ6k8q9Orvo+eJZE1FX//4x0/Oqkg0q7KV
	 hPmX5ok8DiHLP5/qrWcDuDOvklDm4RciiRUGL5OTdLZjIBIFQ8HngoVbi0a0zwS1M0LE9
	 WKc14NaZobfkByjGwT0XE37aNMdvq/pfnroNttImYx8ZNTg3eZOrwiM+jbrlKdU5Z8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=R5XQ5s68;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bVd9yBoE;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=R5XQ5s68;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bVd9yBoE;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361FB606A327
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 15:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 361FB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=R5XQ5s68;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bVd9yBoE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=R5XQ5s68;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bVd9yBoE
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 38B1F220E1;
	Mon, 23 Nov 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795446720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NawzmRle3zK58b68NMU+T0/daswBzxGzH4m78eRsLlU=;
	b=R5XQ5s68LShLZdo7ayFJAUR6MK6HZwsFzjICDwykenZe9kBP9sy6tBplHS8L+USG4uNx20
	59HpoeYAOSJmZ72JCT3j0N+s/Cm+kHLJFm0G5NZ9BpgL7GrHodx30b9Fif9Mq1Vj9NH9OC
	XKuPHnHFaukKn1fhLUy1yWfjcuB/qbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795446720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NawzmRle3zK58b68NMU+T0/daswBzxGzH4m78eRsLlU=;
	b=bVd9yBoE4/8RL7/cFcKdcPtNmd4hN+iNhOUMhR1/MlmDmy6UMLS3QS+segTGr/xIaUUFJg
	KYXKFzhKEyDlrjDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795446720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NawzmRle3zK58b68NMU+T0/daswBzxGzH4m78eRsLlU=;
	b=R5XQ5s68LShLZdo7ayFJAUR6MK6HZwsFzjICDwykenZe9kBP9sy6tBplHS8L+USG4uNx20
	59HpoeYAOSJmZ72JCT3j0N+s/Cm+kHLJFm0G5NZ9BpgL7GrHodx30b9Fif9Mq1Vj9NH9OC
	XKuPHnHFaukKn1fhLUy1yWfjcuB/qbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795446720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NawzmRle3zK58b68NMU+T0/daswBzxGzH4m78eRsLlU=;
	b=bVd9yBoE4/8RL7/cFcKdcPtNmd4hN+iNhOUMhR1/MlmDmy6UMLS3QS+segTGr/xIaUUFJg
	KYXKFzhKEyDlrjDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9886B13510;
	Mon, 23 Nov 2026 15:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +3F3Cr9XBGvsCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 23 Nov 2026 15:11:59 +0000
Date: Mon, 23 Nov 2026 12:11:57 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Tanuj Sharma <ertanuj96@gmail.com>
Cc: security@kernel.org, sfrench@samba.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Subject: Re: [SECURITY] smb: client: OOB read in parse_sid via unchecked
 num_subauth (18 years)
Message-ID: <awRXZZufcnmah6To@suse.de>
References: <20261123111922.84271-1-ertanuj96@gmail.com>
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
In-Reply-To: <20261123111922.84271-1-ertanuj96@gmail.com>
X-Spamd-Result: default: False [-13.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,samba.org,manguebit.com,gmail.com,microsoft.com,talpey.com,vger.kernel.org];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.30
X-Spam-Level: 
X-Spam-Flag: NO

On 11/23, Tanuj Sharma wrote:
> ...
>I have not shared this finding publicly. Happy to work with the CIFS/SMB
>maintainers on the patch if any changes are needed.

Just a heads up that linux-cifs@vger.kernel.org is a public list, and
it was Cc'd in your report.


Cheers,

Enzo
