Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD55376A1C
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 10:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260437; cv=none; b=Yr3/INhWDUSVomNp4174K6yAsafZk9qEtMCdsHK215W1yHwbGswiXCk9x8is4ssAFT5Ao17kgEMsy0SPbOO50RYrYd8o8u2fh0IGwGP2wsPgxYnhAy3lHUigvkdRTxQAMNkI1R1a4NSWe02XFCEZi36GRrS6GsOwqfR1KXScs5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260437; c=relaxed/simple;
	bh=UuBzp+U+fCiduQSi3jeEARo9Ia0OhnlAwwM6gzeVfsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qg7Aq7C+5U/oJM3nB3vSZxyK4MhH94ZT2JZyqeDl3azmYZQ3c73WBGDOPbZ5dX3WJ8hce+RHA/vrpLuQm5TgEIi9gjYFUlx89CiCnRuCzK/xeuOe/xWJW4xMGmJAxgathCTN7BRoSiCqFSihDuRo+89QdEK4O+URzpmMdF4WGCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mxrEQ/P/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cqeu32Qb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mxrEQ/P/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cqeu32Qb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mxrEQ/P/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cqeu32Qb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mxrEQ/P/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cqeu32Qb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DAE376ED6;
	Fri, 12 Jun 2026 10:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781260434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U5opVELbIP4oDt7dYdHoTJ1FWjwgZGhvCOV69XQiDec=;
	b=mxrEQ/P/tXP2hoyBXuGcuqPrW3dMVQ/QfcYXZ6b2ZyV+683KseeZriCnot+/01MRuhJT7T
	h29FGum0c9fnjm5aYHqPR/n/iJrt5wMeD1jYjd30HbOaXJjevQ9YzAOv4ZVv3Km8ftHfQW
	OoPdYEIFuHMd4ijPXo7ktw0PwO/GHwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781260434;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U5opVELbIP4oDt7dYdHoTJ1FWjwgZGhvCOV69XQiDec=;
	b=cqeu32QbLt3VSbbUXZwslvo0nwmVLcKv8CAQLF2Y/gB0j4x41eFK7F5JTrpsLWAPlbl3Ne
	TojHkVSD6O/l2UCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781260434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U5opVELbIP4oDt7dYdHoTJ1FWjwgZGhvCOV69XQiDec=;
	b=mxrEQ/P/tXP2hoyBXuGcuqPrW3dMVQ/QfcYXZ6b2ZyV+683KseeZriCnot+/01MRuhJT7T
	h29FGum0c9fnjm5aYHqPR/n/iJrt5wMeD1jYjd30HbOaXJjevQ9YzAOv4ZVv3Km8ftHfQW
	OoPdYEIFuHMd4ijPXo7ktw0PwO/GHwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781260434;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U5opVELbIP4oDt7dYdHoTJ1FWjwgZGhvCOV69XQiDec=;
	b=cqeu32QbLt3VSbbUXZwslvo0nwmVLcKv8CAQLF2Y/gB0j4x41eFK7F5JTrpsLWAPlbl3Ne
	TojHkVSD6O/l2UCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43EB8779A7;
	Fri, 12 Jun 2026 10:33:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bVmQEJLgK2ppQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 12 Jun 2026 10:33:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B737CA0EB4; Fri, 12 Jun 2026 12:33:53 +0200 (CEST)
Date: Fri, 12 Jun 2026 12:33:53 +0200
From: Jan Kara <jack@suse.cz>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>, 
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Message-ID: <vt6zmgnwz3n5jc3opm5i3bckkocfmzcysrbivbin52nudayus5@5stfgorwnob7>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
 <7iocwlr7jg2jiyx53q7lxaccrybu6fpv6ch36u64igdmddafdk@3ejeqvr4e7rh>
 <987538907.1434294.1781209240897@kpc.webmail.kpnmail.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987538907.1434294.1781209240897@kpc.webmail.kpnmail.nl>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[xs4all.nl];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,xs4all.nl];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,samba.org,gmail.com,zeniv.linux.org.uk,brown.name,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Level: 

On Thu 11-06-26 22:20:40, Jori Koolstra wrote:
> Hi Jan,
> 
> > Op 11-06-2026 17:33 CEST schreef Jan Kara <jack@suse.cz>:
> > 
> > For the filesystems I know this looks sound. Thanks for the cleanup. But
> > this series should then follow with the removal of now-pointless "|
> > S_IFDIR" statements.
> > 
> 
> Right, perhaps it should. But wouldn't that be too much churn? I know Al can
> really be on the brake sometimes with regards to that. But it isn't a lot of
> effort, so I am fine with it.

I agree it will be more churn but leaving the now-pointless | S_IFDIR in
the filesystems is confusing for code readers which isn't good either. So
at least for filesystems I maintain I would like that cleanup to be done.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
