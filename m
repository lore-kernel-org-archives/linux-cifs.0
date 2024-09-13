Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861776F077
	for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2024 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726245875; cv=none; b=oc9Q35hqV3zgaKYkZKdbxRCDbuYQKRyOShejSgDgodKz3gCdeLcyY/BZYr8yyHOTlR++Y8J5Qva+kQbN38V3rujeI5Q4s1YF0Y8lA4gYm5VDPae/FLBcKgWo1hwFlNruWGxgNi+xUG2OGFBnhvO+5VGsfQcWETDRIxpD3t+Zrio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726245875; c=relaxed/simple;
	bh=E2SaAswACbtuJmRdfku4cmNdvwE1qoZT6RgeVFF4s0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UY4G1x6a9ZbJ95DKX8i4e5bnyYqvdXvg0yIseYLS5Wh6X+rPU4idtO8IoeuV/tMw1shgs01W8+t4ccg9Sl7hkobB+Ci8lciw4kvtkWCaAkOMhqe7fbCFlLxWD1UkS+YMLpyVe5lNA3sAlgDFB0Ck6nafqc/lC+Vf01DCF+YLsoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gP1Ux3MO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nsE4E4fY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gP1Ux3MO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nsE4E4fY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gP1Ux3MO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nsE4E4fY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gP1Ux3MO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nsE4E4fY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC74121A95;
	Fri, 13 Sep 2024 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726245871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8A7nDkV4DS0uCXqvqZiineDyTFgBuMYC6cb1HCZQU/M=;
	b=gP1Ux3MOv09qmzpj9Vsu86OZuhY1Axcl5XotfgyQtYHMhe3fCMkkaDbJizlX1+thJhfd2T
	WRrku/nHBrKbUy0iX/Hi6BCyjmFqdgbWBWVt7ITw9gghPNzUV6uI/eo06w0UeRbE09x4Ff
	2wNTlKO+6djNU8PFBAedWB/EeStZuOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726245871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8A7nDkV4DS0uCXqvqZiineDyTFgBuMYC6cb1HCZQU/M=;
	b=nsE4E4fYX9i4Frxk2fUINKslpl6kiN5Fpj47PgdotZO94vY+qW3Uy2Dw+5hP2lH1Fs//Nv
	i2Ce4jY2ye5i45Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726245871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8A7nDkV4DS0uCXqvqZiineDyTFgBuMYC6cb1HCZQU/M=;
	b=gP1Ux3MOv09qmzpj9Vsu86OZuhY1Axcl5XotfgyQtYHMhe3fCMkkaDbJizlX1+thJhfd2T
	WRrku/nHBrKbUy0iX/Hi6BCyjmFqdgbWBWVt7ITw9gghPNzUV6uI/eo06w0UeRbE09x4Ff
	2wNTlKO+6djNU8PFBAedWB/EeStZuOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726245871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8A7nDkV4DS0uCXqvqZiineDyTFgBuMYC6cb1HCZQU/M=;
	b=nsE4E4fYX9i4Frxk2fUINKslpl6kiN5Fpj47PgdotZO94vY+qW3Uy2Dw+5hP2lH1Fs//Nv
	i2Ce4jY2ye5i45Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11E3E13999;
	Fri, 13 Sep 2024 16:44:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VgifLe5r5GbzYwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 13 Sep 2024 16:44:30 +0000
Date: Fri, 13 Sep 2024 13:44:20 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [bug report] smb: client: compress: LZ77 code improvements
 cleanup
Message-ID: <awvhqexgaxb5zseimnoelstn3po3dwfda56z6xowmt6ywkuw2o@7dvntwbyukef>
References: <7eac0abe-1ea6-467c-a560-fa70dc20385e@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7eac0abe-1ea6-467c-a560-fa70dc20385e@stanley.mountain>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Hi Dan,

On 09/13, Dan Carpenter wrote:
>Hello Enzo Matsumiya,
>
>Commit 13b68d44990d ("smb: client: compress: LZ77 code improvements
>cleanup") from Sep 6, 2024 (linux-next), leads to the following
>Smatch static checker warning:
>
>	fs/smb/client/compress.c:311 should_compress()
>	warn: signedness bug returning '(-12)'
>
>fs/smb/client/compress.c
>    292 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
>    293 {
>    294         const struct smb2_hdr *shdr = rq->rq_iov->iov_base;
>    295
>    296         if (unlikely(!tcon || !tcon->ses || !tcon->ses->server))
>    297                 return false;
>    298
>    299         if (!tcon->ses->server->compression.enabled)
>    300                 return false;
>    301
>    302         if (!(tcon->share_flags & SMB2_SHAREFLAG_COMPRESS_DATA))
>    303                 return false;
>    304
>    305         if (shdr->Command == SMB2_WRITE) {
>    306                 const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
>    307
>    308                 if (wreq->Length < SMB_COMPRESS_MIN_LEN)
>    309                         return false;
>    310
>--> 311                 return is_compressible(&rq->rq_iter);
>
>Was this patch ever sent to a public mailing list?  I don't see it on lore.

No, I sent them directly to Steve.
I'll make sure to send the next ones to the list.

>The is_compressible() function has some weird stuff going on.  It's an is_
>function so it should return bool instead of negative error codes.  Here the
>negative error codes are treated as "let's compress this".
>
>check_repeated_data().  It's better to name boolean functions something like
>is_repeated_data() so people will know it's boolean.  This function takes the
>sample data and compares if the first half is a duplicate of the second half.
>The only way I can imagine this happening in the real world is if the file is
>all zeroes.
>
>check_ascii_bytes().  Rename to is_mostly_ascii().  Get rid of the bucket struct
>and instead just it make an array of unsigned int.  Then the checks are
>simpler:
>
>-		if (bkt[i].count > 0)
>+		if (bkt[i])
>
>The check_ascii_bytes() has some micro-optimizations going on.  I don't think
>they're necessary.  I can't imagine how this could show up on a benchmark.  Just
>do one loop instead of two.  On my computer I'm able to do that function 12
>million times per second, but I micro optimized the function even more and now
>I can go through it 20 million times per second using a single loop.
>
>static bool check_ascii_bytes2(const unsigned int *p)
>{
>        int count = 0;
>        int i;
>
>        for (i = 0; i < 256; i++) {
>                if (p[i]) {
>                        if (++count > 64)
>                                return false;
>                }
>        }
>
>        return true;
>}
>
>The trick was I got rid of the threshold const used a literal instead.
>
>The check at the end of is_compressible() should not treat negatives as success:
>
>-	return !!ret;
>+	if (ret == 1)
>+		return true;
>+	return false;
>
>    312         }
>    313
>    314         return (shdr->Command == SMB2_READ);
>    315 }

I'll address those issues.
Thanks for the suggestions/corrections!


Cheers,

Enzo
