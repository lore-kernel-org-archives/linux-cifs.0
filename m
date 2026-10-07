Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4D6287247
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791392584; cv=none; b=V1w2oK08J5w6dJ4Hk313f8N+Y9NSvH6km8k9wLA1XJMye3b+5Wd4GOPRgPET4g63gdHTVSL8F1jFYgHOA95xOr3IXucIWQLq/es5DQ56UGS3JQtJT868a6fi2wKMMF4cdSzl+b3ecRb757lbs2i+1Zy2mmZ1VPJytod66OUauBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791392584; c=relaxed/simple;
	bh=Sq+TurtO/4k6Uj1Bmj8XarNnPG2jOM1PW0/pPxXfx7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKiqLPpglY9aZK1GBYXehmfMRzWUA3FTG3LB2FP4hHz8W/ylPSkWZBD9kZI2hG43mwry5jJQIUQeqsrGxKqUFyJ3pCnCwbEVQfH1K+0AqrK+Hz3x/qggfoY6S4p1N3AHrKgfXFYItn9HikEntl54TuKaiC6hC34OHnIkJijOcPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=My61zy2+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/8+bN0g7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=My61zy2+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/8+bN0g7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="My61zy2+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/8+bN0g7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="My61zy2+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/8+bN0g7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 10D041F44E;
	Wed,  7 Oct 2026 17:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791392581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xdB1m3pVSEIHpZ9mbJUCpMz3O0UXvdCnIsgQvozD4H0=;
	b=My61zy2+scA+qFtjqxI6QFLiehmUJB+yhugkeV3J+BR5PtbE65nN3l3f1+7jxMWJdlUo7M
	uthD7HW20uaQ6fs/lnaLWtDZOB2drrlJY002dZ6NkJ4ees11UTCbShKDdrcBsSYFUi9/SZ
	VwkzGxn4dyY/QZ5k9bcowyJH08nm9pA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791392581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xdB1m3pVSEIHpZ9mbJUCpMz3O0UXvdCnIsgQvozD4H0=;
	b=/8+bN0g7iMirg0c1ojzI+9qleLvIT8Xr62WVs9izEZtK5vClU09gCl0Xbt65UhxDfjoSjc
	lOMbWHwNuGL5+FCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791392581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xdB1m3pVSEIHpZ9mbJUCpMz3O0UXvdCnIsgQvozD4H0=;
	b=My61zy2+scA+qFtjqxI6QFLiehmUJB+yhugkeV3J+BR5PtbE65nN3l3f1+7jxMWJdlUo7M
	uthD7HW20uaQ6fs/lnaLWtDZOB2drrlJY002dZ6NkJ4ees11UTCbShKDdrcBsSYFUi9/SZ
	VwkzGxn4dyY/QZ5k9bcowyJH08nm9pA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791392581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xdB1m3pVSEIHpZ9mbJUCpMz3O0UXvdCnIsgQvozD4H0=;
	b=/8+bN0g7iMirg0c1ojzI+9qleLvIT8Xr62WVs9izEZtK5vClU09gCl0Xbt65UhxDfjoSjc
	lOMbWHwNuGL5+FCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 750EA13354;
	Wed,  7 Oct 2026 17:03:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oBK+AkR7xmpxdgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 07 Oct 2026 17:03:00 +0000
Date: Wed, 7 Oct 2026 14:02:43 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v3 2/2] smb: client: prevent premature discard of
 requests if reconnecting
Message-ID: <asZ12ZKIHpc5yPsn@suse.de>
References: <20260929170358.270612-1-ematsumiya@suse.de>
 <20260929170358.270612-2-ematsumiya@suse.de>
 <b0f37e56c4559eb51624f76f92c23ee8@manguebit.org>
 <asVQ8CHNUY3bxbaz@suse.de>
 <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <00e0fcdfdde0a281ed3f080040d6fb63@manguebit.org>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On 10/06, Paulo Alcantara wrote:
>Note that there's currently no backoff mechanism in either CIFS or
>netfslib for writeback, meaning that the write requests will be retried
>forever if the server goes offline.  You'll end up with tasks hanging
>forever on close or fsync.  Trying to fix that in the reconnect path
>doesn't seem the right way to do it, IMO.

Btw, I forgot perhaps the most important bit here -- whenever there's
a reconnect during a write, the file gets corrupted.

That's regardless of how long the downtime was.  As soon as the first
task times out in cifs_wait_for_server_reconnect(), returning
-EHOSTDOWN, that request is lost, and data is corrupted.

Note that the writes (operations) _are_ resumed, but what was lost,
stays lost.

Again, I agree that retrying indefinitely might be wrong, but so is
corrupting data due to a short network outage.

I did try to relieve this situation with this patch, and TBH, after
reassessing it, I fail to see how/where this could be handled in netfs
or cifs I/O path.

The closest I got to a PoC was by loosening the restrictions to set
NETFS_SREQ_NEED_RETRY on smb2_writev_callback() and smb2_async_writev(),
and then we're obviously back to the retry-forever-but-no-corruption
dilemma.


Cheers,

Enzo
