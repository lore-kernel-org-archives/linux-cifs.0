Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A2249C4C2
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791302286; cv=none; b=fj0jA4hhEROzoU/hYAV5Xq+XBDhUYF7LzDWwjrMJTCX4xADNzB8Cs2UAA3yIL1PB7hVRBD9xjzehX46quSVRgp737Pt8r8+dOm0m3PeV5g792mGUSOdUnyjmeVkOj4b6aWdgr/fFReXAWUS5izHcmhenVmL3uHwewe87wh2Q8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791302286; c=relaxed/simple;
	bh=3Jhk9/4jfaFw5J/FlxqvHUfldgtwWZ1E2phmW71laZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1D+N52UnMm080WBtLzhyr8PxHIA0Po4WTm5OGz/6RQBwbI9U5b1Hc3aky3XumGxsOlB0BV1/iAL2IM9IwF0xjDgfSiq6VK4vPBjb6UL3rlUW4XlG2ov+CNp82BVLrjKIrjCwoTAQv8rFiTwmApRBG8ps1eJync7ovMZ3H9eyhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mVOQFiys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3zlxJ+vf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gAcKVdT1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zd9+/gyM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mVOQFiys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3zlxJ+vf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gAcKVdT1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zd9+/gyM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D384C1F7E4;
	Tue,  6 Oct 2026 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791302279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Jhk9/4jfaFw5J/FlxqvHUfldgtwWZ1E2phmW71laZ8=;
	b=mVOQFiyshzlch4kCpeXqsY7gC2XMYYZbAmDMq9cZnVN46j92dxcpgbJEB8WuBNEEal892N
	MUKl2z37uMOpsxlqovU1asDsVax4+d6qigOJb0vl7yLjRYF1nA15l6+Xsv9+kARcDHtV2c
	PhlH/Jfs/bc6yWgfXiaBHHXSrIEYp6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791302279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Jhk9/4jfaFw5J/FlxqvHUfldgtwWZ1E2phmW71laZ8=;
	b=3zlxJ+vfpFcZP/y9j2Be1RsXnA3EiQeGbTC7muhMAVHM63Ue/6SaHH5I5M0m97jS3mN0iq
	fy5iyKJ5NKXPmBBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791302274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Jhk9/4jfaFw5J/FlxqvHUfldgtwWZ1E2phmW71laZ8=;
	b=gAcKVdT1yUKnJ8g98kTjy+rkfLieLVXeRz5ZneY+zqE6/nOjczWfyL6+KCGwd273NbQ8F6
	3F0s9Jq+lZF4c/zJDt5xwjhpYS/PMeJvtkvLZSZptgOuVmH9FN7NCIpZpJnNGtDEMLDCzS
	gdTjZYamTtyhbxglBuPNOg4ctqvcD8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791302274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Jhk9/4jfaFw5J/FlxqvHUfldgtwWZ1E2phmW71laZ8=;
	b=zd9+/gyMwMLOvTC0WGvrh7h9vHO6kAAZFigjDP+Xz8peQE+RQGXpQv2MwLa889IYTPUpIK
	+cSwcHcDf1TYkCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E53E133CF;
	Tue,  6 Oct 2026 15:57:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a+IxMIEaxWpHDQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 06 Oct 2026 15:57:54 +0000
Date: Tue, 6 Oct 2026 12:57:51 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, linkinjeon@kernel.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH v2 0/2] reconnect fixes and improvements
Message-ID: <asUaMT70FNmugEmZ@suse.de>
References: <20260928150355.850472-1-ematsumiya@suse.de>
 <asT6p2KwY3DLYDRT@suse.de>
 <bf32ad6883839c45d61831fcca7a9017@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bf32ad6883839c45d61831fcca7a9017@manguebit.org>
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On 10/06, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> Any comments on these 2 patches?
>> We have at least a couple of customers with huge workloads impacted by
>> this problem.
>
>Did you send v3 addressing sashiko[1] and Namjae reviews?
>
>[1] https://sashiko.dev/#/patchset/20260928150355.850472-1-ematsumiya%40suse.de

Yes, I did (I just noticed I replied on the v2 thread).

Patch 1:
https://lore.kernel.org/linux-cifs/20260929170358.270612-1-ematsumiya@suse.de/

Patch 2:
https://lore.kernel.org/linux-cifs/20260929170358.270612-2-ematsumiya@suse.de/


Thanks,

Enzo
