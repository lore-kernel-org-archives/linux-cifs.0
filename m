Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04C1149C5B
	for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2024 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718300222; cv=none; b=c6ao2q9oG4zxk5C2X84d0NWOLi2shsNXmu3YCIGpCT5mNM9R8cHy8UjqviAr6dFFyYQYYXj0qigM8MbxQwjmfepbycC9lFDsV4UqGOqaQtqWfdTBfY4GcRnEvJvbTuN7oy1XEKNj6umxjOgFFWRhoZqXK/hVSzDORHljqO8LouE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718300222; c=relaxed/simple;
	bh=8ig7u4Ll+CHxQhuJ1cAz/7RwSvla2CFYc/JvAgoHvw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FuRJG+C9G8lvQ+SUEVyEEdhjywFAOaHGJQx4yJuNP4bYz2bks0baEPU3kBvfUNqvXgLqfkyGWNNtktwaaLURK6L58MlDlUiWt/VQWj3zxnLDZ9vVyyovksTa3VyTukZz1R+FeOYY9WMScpfTx30rz9yXTCujlO4dJ9ZW+l0BVEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j/WYRwq4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k0AkjnTa; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=j/WYRwq4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k0AkjnTa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j/WYRwq4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k0AkjnTa";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="j/WYRwq4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k0AkjnTa"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D256B1F832;
	Thu, 13 Jun 2024 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718300214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ig7u4Ll+CHxQhuJ1cAz/7RwSvla2CFYc/JvAgoHvw8=;
	b=j/WYRwq4xh4xRm7n+/sqSI4v+Q6rEZkVJd7Kg3XLjXmJOwfaYcskddZ19jgspE+w5N3pps
	hijnhfz9ZY+1OsEW97qOpLvl8tMC6xNG21APrW+iLmrCkWpN5Fjw5XDYV8phmFlVS+mYCd
	feZ/6N7AUivIPMkZ415ulykQ2/4hOz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718300214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ig7u4Ll+CHxQhuJ1cAz/7RwSvla2CFYc/JvAgoHvw8=;
	b=k0AkjnTaVCjAGOmTpWMoUx3+P7qHUmK7orOFeUlqYdqaJEfpepHKsdkKc8YYejt6f3dpaK
	sSZ26YUC3pxYTpBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718300214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ig7u4Ll+CHxQhuJ1cAz/7RwSvla2CFYc/JvAgoHvw8=;
	b=j/WYRwq4xh4xRm7n+/sqSI4v+Q6rEZkVJd7Kg3XLjXmJOwfaYcskddZ19jgspE+w5N3pps
	hijnhfz9ZY+1OsEW97qOpLvl8tMC6xNG21APrW+iLmrCkWpN5Fjw5XDYV8phmFlVS+mYCd
	feZ/6N7AUivIPMkZ415ulykQ2/4hOz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718300214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ig7u4Ll+CHxQhuJ1cAz/7RwSvla2CFYc/JvAgoHvw8=;
	b=k0AkjnTaVCjAGOmTpWMoUx3+P7qHUmK7orOFeUlqYdqaJEfpepHKsdkKc8YYejt6f3dpaK
	sSZ26YUC3pxYTpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 609BB13A87;
	Thu, 13 Jun 2024 17:36:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /yyDCjYua2bHCAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 13 Jun 2024 17:36:54 +0000
Date: Thu, 13 Jun 2024 14:37:06 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: "Heckmann, Ilja" <heckmann@izw-berlin.de>
Cc: dhowells@redhat.com, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Crash when attempting to run executables from a share
Message-ID: <zfyfkb4zhatmzxcggdhuk2expapwetgqigdlku6ohq72bdtv3i@tx6uzncfj7jn>
References: <55a38b4f4da449bb9da403d4f58847c5@izw-berlin.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <55a38b4f4da449bb9da403d4f58847c5@izw-berlin.de>
X-Spam-Score: -3.73
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.73 / 50.00];
	BAYES_HAM(-2.93)[99.69%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

Hi,

On 06/13, Heckmann, Ilja wrote:
> ...
>This is what the smb.conf looks like, without the (hopefully) irrelevant
>domain membership and printing settings:
>---------------------------------
>[global]
>case sensitive = yes
>delete readonly = yes
>map acl inherit = yes
>vfs objects = acl_xattr
>oplocks = no
>level2 oplocks = no
>min protocol = SMB2
>
>[share]
>path = /data/share
>read only = no
>acl_xattr:ignore system acl = yes
>---------------------------------

Thanks for the reproducer info.

>And here is a crash record from the journal:
>--------------------------------------------------------------------------------
>Jun 13 10:08:13 server kernel: ------------[ cut here ]------------
>Jun 13 10:08:13 server kernel: WARNING: CPU: 121 PID: 3906695 at fs/smb/client/file.c:3341 cifs_limit_bvec_su bset.constprop.0+0xf2/0x130 [cifs]
> ...

That's not reproducible since v6.10-rc1, probably because of David's netfs work.
Can you try a kernel >= than that one?


Cheers,

Enzo
