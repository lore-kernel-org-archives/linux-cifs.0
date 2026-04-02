Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23119EED3
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 01:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775092997; cv=none; b=e5lvYY5SKqX2iWi/JXitUC+RdiDBGfc5FJ4uQ230s7XXWx2XwZtz5IjmntcgoOr3cLNWemVKj7lpNxEYjxbjnm+2s0zHlq0TRTqVq8jMm54vsL3S/g2RtKV29UN96allR0Sliwao26par7kKXBKlSCbsw41XijnjT/WOdVNLIyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775092997; c=relaxed/simple;
	bh=uAB4Ca2filv1hfci7Gxaz+VBoWCNQzztlMmoynI7nKY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gs2/28sTsByq6vlu1cYeBjblYa+Iep5wOZkRpTyrZ9rsxMfL5MfSxmppbKGik0GcyehJv37IWB4jNtz4Ww9SPdfOJ9KNPTA+ZAHqhLJp3zF5CierCvCocC7Rhj5zKElrbJwefgihARSc5Iip+iL9ONnz+C+sU9qDCqZ52OuKEDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZdBZqkXP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=weNzRg6O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fs3LwlSX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ikCQOSfg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZdBZqkXP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="weNzRg6O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fs3LwlSX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ikCQOSfg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0BF9F5BD04;
	Thu,  2 Apr 2026 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775092994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ciFZZ/FrH13v5vsFH7nJiLiNN9//cD4x06+q1B+rLU=;
	b=ZdBZqkXP88zWgHWuhocH0gWpI1IdtksMnZ55WVVBC2DIBohYraYN8WmyH9Fexpni9wUcyK
	NGQrcISYIwmf5lh1NFmNjkivwCYy2ZQDpMMDonFki0dmf475+9+J6lhZ7f67fhgLkTuUbg
	4eGQSO4+AOe7SFmLVyEBNDbWe3jzj7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775092994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ciFZZ/FrH13v5vsFH7nJiLiNN9//cD4x06+q1B+rLU=;
	b=weNzRg6OK0F1ybP4MIFWCYqTIZ8hO3w8JnbC6KpHezz+z6rWdi+Om5bQf9uhUG+G7MwjRb
	lQS4Fe8KxPTLELBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fs3LwlSX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ikCQOSfg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775092993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ciFZZ/FrH13v5vsFH7nJiLiNN9//cD4x06+q1B+rLU=;
	b=fs3LwlSXXJcZrVhUv8QPHuyH2KrjDHBhwVXTxZvIVJsmDOvFLbcubV6rcZSSR5sL81Kvld
	7J0r8nOZdFTRqetJ8w/DEPG4turOW2SirM74aaJ+wpvCZI9ATvaR7di2YL2iHg3kj8PooT
	VuH8pl6kC3rELrBYKI2DxotfZ7RhqPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775092993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ciFZZ/FrH13v5vsFH7nJiLiNN9//cD4x06+q1B+rLU=;
	b=ikCQOSfgiDvFy7eOSBHMsiTDX/fc5gkVOgX3Uasjp1QTZloKNQBNzefOjp1jSOvzimAsBP
	LaiH05T7D1MYcnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC4BF4A0B0;
	Thu,  2 Apr 2026 01:23:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JfUhI/7EzWlyDAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Thu, 02 Apr 2026 01:23:10 +0000
Date: Thu, 2 Apr 2026 12:23:02 +1100
From: David Disseldorp <ddiss@suse.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org, Steve
 French <smfrench@gmail.com>, Bruno Bierbaumer <bruno@bierbaumer.net>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
Message-ID: <20260402122302.27553b2c.ddiss@suse.de>
In-Reply-To: <cauglxiqmzregxmz7qu3ervva3qiszmgs4xeiczmlpwuzmi4lk@6hgpziq22o6p>
References: <20260331000911.16062-1-ddiss@suse.de>
	<vuah4lb4wtxy3vhw4ywuacfto3dfxke7zldb4oiu3bcpjncrzv@ntdb7jyuzywi>
	<cauglxiqmzregxmz7qu3ervva3qiszmgs4xeiczmlpwuzmi4lk@6hgpziq22o6p>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.990];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.de,vger.kernel.org,gmail.com,bierbaumer.net];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,samba.org:url,suse.de:mid,suse.de:dkim,suse.de:email,bierbaumer.net:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0BF9F5BD04

Thanks for the feedback, Enzo and Henrique...

On Wed, 1 Apr 2026 12:24:37 -0300, Henrique Carvalho wrote:

> On Wed, Apr 01, 2026 at 10:40:41AM -0300, Enzo Matsumiya wrote:
> > Hi Dave,
> > 
> > On 03/31, David Disseldorp wrote:  
> > > The existing (j > pass_length) check is insufficient to avoid dst buffer
> > > overrun into the start of the adjacent struct parsed_mount_info field.
> > > Check for overrun before writing to dst, and account for comma-expansion
> > > and null-termination.
> > > 
> > > Bug: https://bugzilla.samba.org/show_bug.cgi?id=16044
> > > 
> > > Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
> > > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > > ---
> > > mount.cifs.c | 8 ++++----
> > > 1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/mount.cifs.c b/mount.cifs.c
> > > index 1923913..d41ca6a 100644
> > > --- a/mount.cifs.c
> > > +++ b/mount.cifs.c
> > > @@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
> > > 	unsigned int i = 0, j = 0;
> > > 
> > > 	while (src[i]) {
> > > -		if (src[i] == ',')
> > > -			dst[j++] = ',';
> > > -		dst[j++] = src[i++];
> > > -		if (j > pass_length) {
> > > +		if (j + 2 >= pass_length) {  
> > 
> > There is the overrun bug, yes, but unconditionally accounting for comma
> > expansion here will crop the password if it has at least 1 comma and
> > (unparsed) length == MOUNT_PASSWD_SIZE, e.g.:
> > 
> > (password here is <511 * 'a'> + ',')
> > 
> > # echo -e "username=administrator\npassword=$(printf 'a%.0s' {1..511})," > /tmp/creds
> > # ./mount.cifs -o credentials=/tmp/creds //w25.vm.test/test /mnt/test
> > Converted password too long!
> > error 1 (Operation not permitted) opening credential file /tmp/creds

Yes, it's a valid point. I did consider it, but decided against it as:
- it makes the code slightly more complex, and adds more
  password-content based logic
- length restrictions are already opaque and confusing
  + "it broke when I changed password from 300x ':' to 300x ',' - why?"
- we're cropping the field any way (oversize pws were previously still
  passed to the kernel)

> > Maybe password/password2 could be malloc'd with size
> > "strlen(src) + <number of commas in src>" and bounds checked against that?
> > Just a thought.
> >   
> 
> Maybe we could have buffers double the size, but that would represent a
> behavior change. Passwords containing commas were never guaranteed to
> fit in current MOUNT_PASSWD_SIZE sized buffers.

These options would still leave us with password-content specific
behaviour, which seems fragile (open to side-channels attacks, etc).
Shouldn't the new mount API allow for the password to be passed though
to the kernel individually, and in-turn completely avoid comma escaping?

> I believe this would be a separate chage.

Agreed.
