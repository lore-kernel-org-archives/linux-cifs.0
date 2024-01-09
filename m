Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4267E7F7
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jan 2024 00:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gLUhqLod";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BucA54Gm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gLUhqLod";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BucA54Gm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4AC942204A;
	Tue,  9 Jan 2024 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704761791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nn5AChTBCR51VMufCoVcLT8QHSXkHdgDPjOqMa0YGGI=;
	b=gLUhqLodYaiD8PWxBYHCMxnu6owgFz+qROBmZLV+MX8YYbWUIRysW69WSFKYlvcNuWgdET
	+Yh4p58WXP91WyYuub6g8SzTduaLVg+dIYF7J2cmqOYTQuZA9EsjZ0pNKX3+jTJIgtNJva
	CQv6Y1+xY+/8oMNx6dR4bh7zZAnNG0s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704761791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nn5AChTBCR51VMufCoVcLT8QHSXkHdgDPjOqMa0YGGI=;
	b=BucA54GmhgenUKGWeVQHebgLfJEwCMCv6+JyT96diV/MCBYsOd8vxumIq2EnIRwMJWJGFc
	q1zj0mmcU1gkJ2DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704761791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nn5AChTBCR51VMufCoVcLT8QHSXkHdgDPjOqMa0YGGI=;
	b=gLUhqLodYaiD8PWxBYHCMxnu6owgFz+qROBmZLV+MX8YYbWUIRysW69WSFKYlvcNuWgdET
	+Yh4p58WXP91WyYuub6g8SzTduaLVg+dIYF7J2cmqOYTQuZA9EsjZ0pNKX3+jTJIgtNJva
	CQv6Y1+xY+/8oMNx6dR4bh7zZAnNG0s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704761791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nn5AChTBCR51VMufCoVcLT8QHSXkHdgDPjOqMa0YGGI=;
	b=BucA54GmhgenUKGWeVQHebgLfJEwCMCv6+JyT96diV/MCBYsOd8vxumIq2EnIRwMJWJGFc
	q1zj0mmcU1gkJ2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C43521392C;
	Tue,  9 Jan 2024 00:56:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kMVQIr6ZnGXcDwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 09 Jan 2024 00:56:30 +0000
Date: Mon, 8 Jan 2024 21:56:28 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Jacob Shivers <jshivers@redhat.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Linux client SMB and DFS site awareness
Message-ID: <20240109005628.5xbwpkqc75okxmcg@suse.de>
References: <CALe0_77CgEXNiXrM4oQ47sfHnDoML18oz5rmEu-_57Av0KRTkg@mail.gmail.com>
 <20240108181751.natpy6fac7fzdjqd@suse.de>
 <CALe0_777GL=XQYSochOoph73madKm8DsRn+xQOcTmz9xh+wcHQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CALe0_777GL=XQYSochOoph73madKm8DsRn+xQOcTmz9xh+wcHQ@mail.gmail.com>
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-1.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.00)[12.83%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 TO_DN_ALL(0.00)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.30

Hi Jacob,

On 01/08, Jacob Shivers wrote:
>Hello Enzo,
>
>Thank you for the response!

Thanks for elaborating.

>I failed to mention the initial aspect that is specific to mounting a
>domain based DFS share. This would contact a random domain controller
>instead of a DC local to the calling client's site, should it exist. A
>CLAP ping like that used by SSSD[0] could be used to identify the
>nearest domain controller prior to initiating a subsequent mount
>request. This is where the DNS discovery for a ldap entry would be
>applicable.
>
>Hope that helps to clarify the use case.

This is pretty much what I had in mind, but I still see it as a
server-side situation, both from the spec side, as from a personal POV.

The DC the client connects to should have all the info in-place and
ordered (either by site location or by cost) to return to the client,
where it will contain the highest priority target as the first entry on
the list (that will probably not be itself, see below).

On Windows Server, you can create a registry key [0] on the DC to force to
put the logon server (the server the client is authenticated to) as the
topmost entry on the DC referrals list.

This behaviour is disabled by default, and the reason (as I understand),
just like your proposal, is because it would defeat the transparency that
DFS offers; the client would be "forced" (either by manual input or by
discovery) to know beforehand where it's connecting to, where MS-DFSC shows
that the client shouldn't be aware of such details.

I haven't tested, but I would expect the DC I'm connecting to to offer
the closest targets, no matter if on the same domain, different
domain/same forest, or even in a forest-forest (with a trust
relationship) scenario.  Do you have a practical test case where this
doesn't happen?  OS type and version, along with an overview of the DFS
setup would be helpful to analyze as well.

[0]
add/set HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dfs\PreferLogonDC
(DWORD) to 1


Cheers,

Enzo
