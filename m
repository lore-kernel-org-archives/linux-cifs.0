Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442D3E5594
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294566; cv=none; b=T8X6HNa4DAKEg+LyXIq5GnWLlbOo4taMJg9E+Hbm4GtF5iAUOtR1Z4P2//QxYTnNz2H/Z8aUEXCIpWgGc5sydEAF6hz0takPhnXfhJZq3qpY+5XH5S98Msr+E1vYD1q9IkOdLG0nXV5zaT/pSFe/ynv1SXbNlBr2ihu2FvCkHog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294566; c=relaxed/simple;
	bh=8uctWUo8TzUrMUT3LdFj+KSdSAMo/M9keiM/N1gHLqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY7HsnO9qXn9NN5EKpWtzLDP8VDyFZC46ULw0xWcLcg+8muk3cjViBm7cbdFwxnt81IANibIWjUeVFpNKSVkFpsSCd9Utd0LkQ/n+AH9R88Tr3ZFHko94sxUn5hVydiz7pE7IHM43qE+n019gOcDnSXRPl8C/BMZLBgDhe8n0mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JwzjwxGQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9Si0AG1L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KXsX72LM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gdNoDV1v; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JwzjwxGQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9Si0AG1L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KXsX72LM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gdNoDV1v"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4FC3219E9;
	Tue,  6 Oct 2026 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791294559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wO52eYOz1ccTlUa28zyQO/YJpzjlgazFUJ4nL993W7w=;
	b=JwzjwxGQN5KgGqsiZ+oGmdY2vKKTKIT9f9Y5mJeu2Vp5pK55iz68uXTsMM8kakHYlgSev1
	w9E9fZyDf2FvpJL88BstR/ARUtU83ohDP5Pfyph/VRNGr+8PlPwTlRh1/VBrh0ECpvxtDm
	xGDavvVb1pTTkn6MESxppWF/EKENtPY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791294559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wO52eYOz1ccTlUa28zyQO/YJpzjlgazFUJ4nL993W7w=;
	b=9Si0AG1LGJNdzFun12Lcp+AoUIKwGbuKXYOP2sV5K52NNDZsDmJxb7p0pR6RY3M8kXChNF
	r4xZ51uMAFjEe2Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791294554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wO52eYOz1ccTlUa28zyQO/YJpzjlgazFUJ4nL993W7w=;
	b=KXsX72LMe7tdpbouYWfqF0dvLFuGLYGbmnF5bis2+rE2DqiBZmdwJH7STY+8D2eZXdZFUf
	eQ9kM6atqgMkPoZZqm8HaUBOiVSGXo9dKv5kJ8wJlqpqmg7ilS8A1q3N2BvK9v+qoKth87
	JYoYQHI3vOVJ/aWkQR91Jss2qLE3dmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791294554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wO52eYOz1ccTlUa28zyQO/YJpzjlgazFUJ4nL993W7w=;
	b=gdNoDV1vYHArUcSjHSb0nA1cNwlSjS9ZZkm9SodEHDBB7QZgty877+SqzAdeb8u/aEpBJp
	dc/8ThetynRz88Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 519601368D;
	Tue,  6 Oct 2026 13:49:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 75YFNVn8xGqHegAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 06 Oct 2026 13:49:14 +0000
Date: Tue, 6 Oct 2026 10:49:08 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org, linkinjeon@kernel.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v2 0/2] reconnect fixes and improvements
Message-ID: <asT6p2KwY3DLYDRT@suse.de>
References: <20260928150355.850472-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260928150355.850472-1-ematsumiya@suse.de>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

Any comments on these 2 patches?
We have at least a couple of customers with huge workloads impacted by
this problem.


Thanks,

Enzo

On 09/28, Enzo Matsumiya wrote:
>Hi all,
>
>Sending v2 to address the issues found by sashiko
>https://sashiko.dev/#/patchset/20260925202003.618856-1-ematsumiya%40suse.de
>
>Please refer to the original cover letter for rationale and reproducer
>https://lore.kernel.org/linux-cifs/20260925202003.618856-1-ematsumiya@suse.de/
>
>
>Cheers,
>
>Enzo Matsumiya (2):
>  smb: client: fast fail sends if need to reconnect
>  smb: client: prevent premature discard of requests if reconnecting
>
> fs/smb/client/cifsglob.h  |  4 ++
> fs/smb/client/connect.c   | 58 ++++++++++++++++++++-----
> fs/smb/client/misc.c      | 91 +++++++++++++++++++++++++++------------
> fs/smb/client/transport.c |  8 ++++
> 4 files changed, 124 insertions(+), 37 deletions(-)
>
>-- 
>2.55.0
>
>
