Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE895345CCD
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783693004; cv=none; b=jOsfgfPB7UnoZw/Bb524a+ZEB2h68zywJWIo3PPNJJy8IfOReaF01dfyj3IA+ljvAtJUqplPbMDkH9NbuWwrH/g5aTv77BHgfSIYBoDvzJNVZ+2pm2zck8rWBcj5gS6W/FeZlMZuA24pteaLCiHM+c4MGfURiwTAMXEcFfOzZ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783693004; c=relaxed/simple;
	bh=WJMTnr1XzPdAa6Wpw2RW8P1yPWsr+257lgV7cvVmXPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fj4JTWwQW1gY1ClCBilqUhdYkJveZdrLmCDgL45teGvF/oLnsgLGBX54lutCctjpyLcdi3drP7kyk+eUEKqF26zuEoSU5dAo1/2kE5//13/4rIHlOAh2+hUoI+iTRqODCaCChywFo+tsjsiBLcmeiqqR6ffp1tNnaA0kTu3/fsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jCmvt5fq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4fctQgde; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mv+Zq3NF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=df67Nt7y; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jCmvt5fq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4fctQgde";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mv+Zq3NF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="df67Nt7y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED8D57646B;
	Fri, 10 Jul 2026 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783693001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6jpA6NLvWFPc6w0vBOkB6Mg+7+/KXLBnWyi0okspBE=;
	b=jCmvt5fq/RG+dUfqxSU0fsQbWIkbUrYRSZVTRuc2FMT0oT+frvsqLlpTQG27c79MzYtJzm
	qvNzM35dn6RHiyZqEPqV6D5OuC7sx7Z3yblb9NV64CMtKJcqZUO3HhJ6o/iO8WdzDvbAjT
	fxJtlVXMwCQxP+aF6sa1bMbA10F6YgE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783693001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6jpA6NLvWFPc6w0vBOkB6Mg+7+/KXLBnWyi0okspBE=;
	b=4fctQgde0rnYtp3iLvipuajdpdeg6YReOS/XFD6EoieqzTUE+nLJfHFInAZsQapgF+q1mb
	I42FwjLLKZfTmRBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783693000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6jpA6NLvWFPc6w0vBOkB6Mg+7+/KXLBnWyi0okspBE=;
	b=Mv+Zq3NFb6msJerMNWwBEKNWTx0bWYkllvPdxlCGfSSpGVnphDAIXVrGFtOZTmUIyiW4FQ
	VECcM/uqc9278YTJv2u8pJR0YRbFqf3TDmJ6yh7RXy63dkbZmyYIvtkBXzulbPXoQV4ub/
	9K+08faB6kN/VmMzB0ey8zdlM3Mw6zA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783693000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K6jpA6NLvWFPc6w0vBOkB6Mg+7+/KXLBnWyi0okspBE=;
	b=df67Nt7y2LJfJ0DJ3ffxsP2QRdCHCfV0F0tAp+f3KgpRq7Z9jlKq+XcG4ac35kHOna61Pq
	ayHfYdPnZP6YjtDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 763BC779BD;
	Fri, 10 Jul 2026 14:16:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CpBLD8j+UGptOwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 10 Jul 2026 14:16:40 +0000
Date: Fri, 10 Jul 2026 11:16:30 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Samuel Cabrero <scabrero@suse.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH 00/18] SWN: Decouple witness registrations and tcons
Message-ID: <alD99AD9miVVui6Q@suse.de>
References: <20260710091637.58873-1-scabrero@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260710091637.58873-1-scabrero@suse.com>
X-Spam-Flag: NO
X-Spam-Score: -8.30
X-Spamd-Result: default: False [-8.30 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Level: 

On 07/10, Samuel Cabrero wrote:
>This patches removes the cached tcon pointers from the witness
>registrations.
>
>First patch in the serie reverts the current approach based on snapshots
>that fixes a race while processing a received notification. This
>patchset implements a different approach based on reference counting and
>fixes other races that could occur with concurrent
>register/unregister/notification processing.
>
>The witness registration stores now all required information to issue
>register/unregister DCERPC calls (like auth info and target address),
>and when a notification is received it applies it to all matching
>witness-enabled tcons.
>
>Each witness registration has its own task to enforce the registration
>in case the userspace daemon is started after mounting the share,
>instead of overload the echo task for this purpose.

@Steve you may add my Rb to the whole series.

>Samuel Cabrero (18):
>  Revert "smb: client: resolve SWN tcon from live registrations"
>  smb:client: Adjust witness notification request
>  smb:client: Rename variable to match the rest of the code
>  smb:client: Split idr remove and release functions
>  smb:client: Add a specific task to refresh witness registrations
>  smb:client: Store the tcon dstaddr in the witness registration
>  smb:client: Fix printf format string
>  smb:client: Save memory allocations
>  smb:client: Use the correct return code
>  smb:client: Improve tcon matching logic
>  smb:client: Pass the tcon to cifs_swn_send_register_message
>  smb:client: Pass the tcon to notification handlers
>  smb:client: Introduce swn_notification struct
>  smb:client: Cache auth info

@Samuel just a small observation in this patch (14/18):

It's better practice to use kfree_sensitive() when freeing
passwords (swnreg->authinfo.ntlm.password).

IMHO this can be done in a follow up patch instead of a v2.

>  smb:client: Do not store the tcon reference, find a matching one
>  smb:client: Simplify registration creation
>  smb:client: Improve registration network and share names handling
>  smb:client: Avoid witness re-register if the address did not change
>
> fs/smb/client/cifs_swn.c | 1179 ++++++++++++++++++++++----------------
> fs/smb/client/cifs_swn.h |    3 -
> fs/smb/client/connect.c  |    3 -
> fs/smb/client/trace.h    |    4 +-
> 4 files changed, 682 insertions(+), 507 deletions(-)


Cheers,

Enzo
