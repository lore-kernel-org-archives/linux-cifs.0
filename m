Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD025A359
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760039494; cv=none; b=c5sJEaL3X+8tXYDWx1Eu6tydqmpROyeTKDsRFurFIKFufw4FGz1XBFq7V33nb7AUJ1HTgEncAErZWNZwMbGYnEjkE8wdrhhIuxh5m/LvXnHXLopGtCFpXRBOYVupBh7hKQHEbtbxVH0PvVNlnTDIGUvNokSm5ds5Wa/vN5dkCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760039494; c=relaxed/simple;
	bh=pctPK6SmpvQDyEexmdnTbROcXSp+wM+OMksZSLFjlrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTrh82P5/Sa4mgDUA0T/XX24gF8GqaDt3YA+10Usui78UmE0GNFTZVsX4GHyEBlwYXjxH26qQlM/WvsggiqsO9WBk7mI+XKCEQKvZCiPLoGjT8v4X1gbrCXwbs4uxvQDP73aje5Xjrl0ote4OKxbVhzn+WFKAFsBy/TiOYpRM/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mCL0wa/f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AwuXgxHI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mCL0wa/f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AwuXgxHI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mCL0wa/f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AwuXgxHI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mCL0wa/f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AwuXgxHI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 39E0122433;
	Thu,  9 Oct 2025 19:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760039490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4KKqPmh/RYSryLeUzHqpT7/it9Ut8JQ2ilHqJPlN1s=;
	b=mCL0wa/fxKBJk90yGlCv9lFNXESNWUAfM1aiD2W4zfo4qERjsf3v4q1u95V8nQeG1BdrZz
	RVkl/fhQCMwBI5SsPVa4tujGPkk8R0YsQ3PeV0+GLjt9AOihOTdK0+s1AeKsP9IChTGOvs
	v3Fdy4ugve4Xt9h6gC99KDRQyfRY2Kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760039490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4KKqPmh/RYSryLeUzHqpT7/it9Ut8JQ2ilHqJPlN1s=;
	b=AwuXgxHIFFT/g1p5u4gKHxTpTLlu/WPpVTHsZDaAqADChW0agdborJOxL3i35dbrLGMOd7
	FMUK5PJKaes3GXBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760039490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4KKqPmh/RYSryLeUzHqpT7/it9Ut8JQ2ilHqJPlN1s=;
	b=mCL0wa/fxKBJk90yGlCv9lFNXESNWUAfM1aiD2W4zfo4qERjsf3v4q1u95V8nQeG1BdrZz
	RVkl/fhQCMwBI5SsPVa4tujGPkk8R0YsQ3PeV0+GLjt9AOihOTdK0+s1AeKsP9IChTGOvs
	v3Fdy4ugve4Xt9h6gC99KDRQyfRY2Kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760039490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4KKqPmh/RYSryLeUzHqpT7/it9Ut8JQ2ilHqJPlN1s=;
	b=AwuXgxHIFFT/g1p5u4gKHxTpTLlu/WPpVTHsZDaAqADChW0agdborJOxL3i35dbrLGMOd7
	FMUK5PJKaes3GXBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8C1513A61;
	Thu,  9 Oct 2025 19:51:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSPmH0ES6GhidwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 09 Oct 2025 19:51:29 +0000
Date: Thu, 9 Oct 2025 16:51:19 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, Henrique Carvalho <henrique.carvalho@suse.com>
Subject: Re: directory lease patch series
Message-ID: <bfchkjcqxrtrsm5jgiqramxrdjbsnqy4dx23uvxgksivdftdb2@jf2xiaq3ak72>
References: <CAH2r5muZ8KPXD8-KN+PsAfrhJzJXtR7EdVhtSbS+M5TCvyPEfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muZ8KPXD8-KN+PsAfrhJzJXtR7EdVhtSbS+M5TCvyPEfA@mail.gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

Hi Steve,

On 10/09, Steve French wrote:
>Enzo,
>Was running tests with your 20 patch directory lease series (with
>mainline from a few days ago) and noticed a HUGE slowdown in
>generic/165 (run to Samba) it went from taking 41 seconds, to taking
>over 31 minutes (and thus timing out).  I also noticed that more than
>1/3 of the tests were also running much slower - e.g. test cifs/105
>went from 4 seconds to 39 seconds (but only from Samba, didn't have
>this problem to older Windows), generic/014 to Azure was about 50%
>slower, generic/109 (to Windows) went from 15-->25 seconds,
>generic/129 to Azure was about 40% slower, generic/138 and 139 and 140
>(all three to Samba) slowed down as well going from 5 seconds to about
>40 seconds when run with the patches, generic/142 (to Samba) went from
>5 seconds to 4:46, generic/143 (to Samba) went from 26 seconds to
>5:06, generic/144 (to Samba) went from 5 seconds to 41 seconds.
>Similarly tests generic/145, 147, 148, 149, 150, 151, 153, 155 (to
>Samba) were about 20x slower run with Enzo's patches
>
>Do you notice this perf degradation?

Thanks for reporting.

I tested it on my own set of xfstests (95 tests) agaist Windows Server
2022 and samba only, and I can't say I noticed any difference, although
TBH I only compared the whole run time, not individually -- so if there
was any difference here, one test was much faster while other slowed
down.  I'll run everything again and observe carefully now.

Also, I can't really say anything about your report right now because
my test set only include 1 of the ones you mentioned.  So I'll make
sure to include all of them as well.

I'll ping back when I get results.


Cheers,

Enzo
