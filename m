Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A53331A4C
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761915347; cv=none; b=rk9aZ63v/O/wZkvhKmpT8PUA7CjsJ74zFyYfpKGkqthCgDwVNHcIDreIuVL0/hhgioOKhiHZA7gO3qzqcfHWQj9GOCeKdWWzhFBzjVmT6RhhJVJAqjxuuZKXoRNKxPtK2HtcM6fZ8FQyOSdOf2wbhBV4C9fHg1t9SKvK+vy2JoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761915347; c=relaxed/simple;
	bh=5J1s7PihHTLpwT258jm9JEvBJJCjshtfGsTxPPpbKzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGycMuaAhpTay/2DZHzbgrIULSkhxtZYF9BlysGayC/o/BmaBbXoGdPWFP1hVE/lQXAhu3Dv9cSgppOEK0DMR/qJyZlY435O2Rk/+arvs6DpzOe3kBElCdpjTC2qXZcJ9anMp3Ge9TRgQ8oOU4ZM2YNuKt/L/wf7HbyRo90cwvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2ITd71Pf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UUDqYveI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2ITd71Pf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UUDqYveI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2ITd71Pf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UUDqYveI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2ITd71Pf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UUDqYveI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6634322059;
	Fri, 31 Oct 2025 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761915343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sui4AHTjxoCbr+DgsgNvtoyVOgSDm7xjv/9gpgejxHM=;
	b=2ITd71PfwW8YbzY45U3kcBJCZX3u1KCadpGub9/J0culkC/B5P+qg+ij7UBSGJhmiAFyVn
	pUKzSl+hfwEEzj+Nuv4grMkYn6IQioBu4FzQGPlha+hqdiSLEFmgU4sfeS7kbdbqV4mBY2
	fcoWkKTtAXf8Hmsi9NI9ufvvrcVH9GM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761915343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sui4AHTjxoCbr+DgsgNvtoyVOgSDm7xjv/9gpgejxHM=;
	b=UUDqYveI3ymZC4jE1GYDcG3Pj+b3e7wCBQzdEIFCFou2HPtFczj1a3URmZHbIxE3bLTTJf
	TDFI7HJyNjMNB/CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761915343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sui4AHTjxoCbr+DgsgNvtoyVOgSDm7xjv/9gpgejxHM=;
	b=2ITd71PfwW8YbzY45U3kcBJCZX3u1KCadpGub9/J0culkC/B5P+qg+ij7UBSGJhmiAFyVn
	pUKzSl+hfwEEzj+Nuv4grMkYn6IQioBu4FzQGPlha+hqdiSLEFmgU4sfeS7kbdbqV4mBY2
	fcoWkKTtAXf8Hmsi9NI9ufvvrcVH9GM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761915343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sui4AHTjxoCbr+DgsgNvtoyVOgSDm7xjv/9gpgejxHM=;
	b=UUDqYveI3ymZC4jE1GYDcG3Pj+b3e7wCBQzdEIFCFou2HPtFczj1a3URmZHbIxE3bLTTJf
	TDFI7HJyNjMNB/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4E8113393;
	Fri, 31 Oct 2025 12:55:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jB6GKs6xBGm6KQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 31 Oct 2025 12:55:42 +0000
Date: Fri, 31 Oct 2025 09:55:40 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, 
	Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	smfrench@gmail.com, Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in
 /proc/fs/cifs/open_dirs
Message-ID: <6juyv7x4jacgyxpfgtmcegyzso2mblw43t2x6pc4g5fnsfyody@ji2zhgqnrgvq>
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com>
 <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
 <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
 <CANT5p=pnXLDyZMVoKdUqTzPB7dxj2kd1g+2FfzD8LS4+8LyODg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANT5p=pnXLDyZMVoKdUqTzPB7dxj2kd1g+2FfzD8LS4+8LyODg@mail.gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[manguebit.org,gmail.com,vger.kernel.org,microsoft.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On 10/31, Shyam Prasad N wrote:
>Hi Enzo,
>
>On Fri, Oct 31, 2025 at 3:42=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>>
>> On 10/30, Paulo Alcantara wrote:
>> >Bharath SM <bharathsm.hsk@gmail.com> writes:
>> >
>> >> Expose the SMB directory lease bits in the cached-dir proc
>> >> output for debugging purposes.
>> >>
>> >> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>> >> ---
>> >>  fs/smb/client/cached_dir.c |  7 +++++++
>> >>  fs/smb/client/cached_dir.h |  1 +
>> >>  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
>> >>  3 files changed, 27 insertions(+), 4 deletions(-)
>> >
>> >Are you increasing cached_fid structure just for debugging purposes?
>> >That makes no sense.
>> >
>> >cached_fid structure has a dentry pointer, so what about accessing lease
>> >flags as below
>> >
>> >        u8 lease_state =3D CIFS_I(d_inode(cfid->dentry))->oplock;
>>
>> Also, I don't think we can even get anything different than RH caching
>> for dirs.
>I don't think we can make an assumption about what all servers return.
>I don't mind dumping this extra info about the lease state.

It's not an assumption, it's a fact -- if a server returns anything
different than RH for a dir lease, the server is broken and we shouldn't
even trust/cache it.

>> Even on RH -> R lease breaks (IIRC this can happen), we don't handle it
>> and cfid is gone anyway.

My point is a dir is either cached (RH, cfid->has_lease =3D=3D true) or we
don't (lease break with 0 or R-cache only, cfid->has_lease =3D=3D false).

So unless we're changing/handling the behaviour for RH -> R downgrades
(which I really think we shouldn't), creating such level of granularity
makes no sense and will only cause confusion (imagine seeing W-caching
for a dir).


Cheers,

Enzo
