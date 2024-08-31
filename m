Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4784405
	for <linux-cifs@vger.kernel.org>; Sat, 31 Aug 2024 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063452; cv=none; b=UJuKShA3ViyFmTEjAzIirJe5bLtoqc/0uu0tLAyslcdeNwUdfteB2vLycD5k1GhlAxZzJzEEb1If9w/E9BlJ5A3FUM5lQjTvYfbNohE1Cu8lz67I6hhY2S8kgdDrDThzPUd1RqWLhCtlF5QuvJrlDosZn5L1Fy27DwSByZ4Km3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063452; c=relaxed/simple;
	bh=+h2NTg/pp4ni0dpNsfK5KnmJ6/O6MexpUBFJ+POe3og=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9mweA0VOJQrd2LSbR+986m6MhIMkAhCfrwZzy0226LK+a3vBb9cO7t/ari7griseFksTYRFfFQI39wut/x/l4lbjGI6JhmDrz4JoFi6Gegy1xXroIUyp8d6d72e8rv674P+1VmDZ+tkISVQqAXDJFAtJfHs33ez8vaADQyEgT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hViG1dKy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gqR3D3kK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hViG1dKy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gqR3D3kK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hViG1dKy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gqR3D3kK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hViG1dKy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gqR3D3kK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43C0B21A0D;
	Sat, 31 Aug 2024 00:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725063448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVnr7mGqKH2uyff1qdh0tUTnyZuKBRRin+CI7RYNzgE=;
	b=hViG1dKyNi0z1cOcor5vXDE+Bh02OfSDFANx9HLuIyZBCNMkmK3fzh3b7fLp8fmnTQ2kxA
	uPPLxa05LgpnectvYWB6a1/o1NT+1+J06jyWXV27M10dujrxzDvG3RTk2yxmA1FaWDaAvW
	clk7HhohQJQkQd5qE7QXuvbb0VEnI8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725063448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVnr7mGqKH2uyff1qdh0tUTnyZuKBRRin+CI7RYNzgE=;
	b=gqR3D3kK1Ta7HCk+jx8SiWF95WhYMwxxFMlZi4PQ/+iFAzTPIA/nkHJgsZFJwrWf70DOO+
	F9kmxRjiQL6I4NDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725063448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVnr7mGqKH2uyff1qdh0tUTnyZuKBRRin+CI7RYNzgE=;
	b=hViG1dKyNi0z1cOcor5vXDE+Bh02OfSDFANx9HLuIyZBCNMkmK3fzh3b7fLp8fmnTQ2kxA
	uPPLxa05LgpnectvYWB6a1/o1NT+1+J06jyWXV27M10dujrxzDvG3RTk2yxmA1FaWDaAvW
	clk7HhohQJQkQd5qE7QXuvbb0VEnI8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725063448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVnr7mGqKH2uyff1qdh0tUTnyZuKBRRin+CI7RYNzgE=;
	b=gqR3D3kK1Ta7HCk+jx8SiWF95WhYMwxxFMlZi4PQ/+iFAzTPIA/nkHJgsZFJwrWf70DOO+
	F9kmxRjiQL6I4NDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C16BA13A1F;
	Sat, 31 Aug 2024 00:17:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MRkLIhdh0mYVBgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Sat, 31 Aug 2024 00:17:27 +0000
Date: Fri, 30 Aug 2024 21:16:48 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
Message-ID: <477uxxjmzpi5hnszmxlhtrapo5retotyc2x2gta6rpzak4pjdn@7zvzkoww4624>
References: <20240831000937.8103-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240831000937.8103-1-ematsumiya@suse.de>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+]
X-Spam-Flag: NO
X-Spam-Level: 

On 08/30, Enzo Matsumiya wrote:
>Some operations return -EEXIST for a non-existing dir/file because of
>cached attributes.
>
>Fix this by forcing dentry revalidation when nohandlecache is set.
> 
> ...
> 
>---
> fs/smb/client/inode.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>index dd0afa23734c..5f9c5525385f 100644
>--- a/fs/smb/client/inode.c
>+++ b/fs/smb/client/inode.c
>@@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
> 	if (!lookupCacheEnabled)
> 		return true;
>
>+	if (tcon->nohandlecache)
>+		return true;
>+
> 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
> 		spin_lock(&cfid->fid_lock);
> 		if (cfid->time && cifs_i->time > cfid->time) {

Simplest fix for a bug we hit while debugging something else.

Sending as RFC because I wasn't sure if/why attributes caching
shouldn't be in sync with handles caching.

Appreciate any thoughts, corrections, explanations.


Cheers,

Enzo
