Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EE7314B90
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 22:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761862112; cv=none; b=RnYwgkT5uun6vFyk2JjpfjBIxuCtARLY4aUY6CNp83I8P+15sI4mkhwxn1tk9KdFfr9NoXgPr75lxJX7zpRccYG8dqUbc6vdU9FJ9Bsm9jfxU1aYaFSRXireo6Zij1xGilvB45zE8Cp1g8DXr7BBx4IhTn3SpM4sEIbNJ0kIpaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761862112; c=relaxed/simple;
	bh=Nt6i88k3fN312aCAyh63bz0dqw22u8QCt9eHbqWXuwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjFI7lKNa0ZigrvjPjlQYVS4M+ab0AmlelkIZNfBGko7BXxKeCzRB6mDu7Mzdo1qmFkVFxUdYquBSFKsoOzlI9OWSjqy1KwbhjS5Jysza0KAqJZ0UW5OtQkAlaqj/Jy8VHeYerOlh3gxsNXtOm5bnV4+JYx4qcAlCHaT32sxEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jmlQdqiP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=guK7Sksd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jmlQdqiP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=guK7Sksd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jmlQdqiP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="guK7Sksd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jmlQdqiP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="guK7Sksd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C77FF1F76B;
	Thu, 30 Oct 2025 22:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761862107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dH2mE5K5eq9XzsBSMGR2ng1xyiSyKMuwTn5iGOxgI8E=;
	b=jmlQdqiP4sUfWdbOJxYtlWmNsfWJDAy0BbfEh9qH8giiozAJlBYgVY0KVrFteUYaAx0v0t
	Yz+8Ds1HbAm6Fq0CpSPby1NGXhkVOKAx/NT3F7oiK5lsXQ/vXHsqFB1tK3k5INlBnc3zu5
	tUrgjvrVHSdaEygCx5DiOKOanxnavWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761862107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dH2mE5K5eq9XzsBSMGR2ng1xyiSyKMuwTn5iGOxgI8E=;
	b=guK7Sksd6O+x9m+130l3U4hBe335gsQ2ojmiGrHjQuB8cpnX30TAGY/6kSBU27hZ6vpcsr
	y7CI9ipbN6hfOZDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761862107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dH2mE5K5eq9XzsBSMGR2ng1xyiSyKMuwTn5iGOxgI8E=;
	b=jmlQdqiP4sUfWdbOJxYtlWmNsfWJDAy0BbfEh9qH8giiozAJlBYgVY0KVrFteUYaAx0v0t
	Yz+8Ds1HbAm6Fq0CpSPby1NGXhkVOKAx/NT3F7oiK5lsXQ/vXHsqFB1tK3k5INlBnc3zu5
	tUrgjvrVHSdaEygCx5DiOKOanxnavWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761862107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dH2mE5K5eq9XzsBSMGR2ng1xyiSyKMuwTn5iGOxgI8E=;
	b=guK7Sksd6O+x9m+130l3U4hBe335gsQ2ojmiGrHjQuB8cpnX30TAGY/6kSBU27hZ6vpcsr
	y7CI9ipbN6hfOZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C9541396A;
	Thu, 30 Oct 2025 22:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3r59BNvhA2kmXAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 30 Oct 2025 22:08:27 +0000
Date: Thu, 30 Oct 2025 19:08:24 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, smfrench@gmail.com, Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in
 /proc/fs/cifs/open_dirs
Message-ID: <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com>
 <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,microsoft.com];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On 10/30, Paulo Alcantara wrote:
>Bharath SM <bharathsm.hsk@gmail.com> writes:
>
>> Expose the SMB directory lease bits in the cached-dir proc
>> output for debugging purposes.
>>
>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>> ---
>>  fs/smb/client/cached_dir.c |  7 +++++++
>>  fs/smb/client/cached_dir.h |  1 +
>>  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
>>  3 files changed, 27 insertions(+), 4 deletions(-)
>
>Are you increasing cached_fid structure just for debugging purposes?
>That makes no sense.
>
>cached_fid structure has a dentry pointer, so what about accessing lease
>flags as below
>
>        u8 lease_state = CIFS_I(d_inode(cfid->dentry))->oplock;

Also, I don't think we can even get anything different than RH caching
for dirs.

Even on RH -> R lease breaks (IIRC this can happen), we don't handle it
and cfid is gone anyway.
