Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA6318455C
	for <linux-cifs@vger.kernel.org>; Mon,  2 Sep 2024 12:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725279129; cv=none; b=E7BloiDrJbGVt9IrwPA5xeBR0vpsZ+G4tbGp2gCmW57RErZmMWryHfY+sp/sH7rVJ8EHnnTKPMJKB1pmT+Ny/3yu9LKp7gG/o48GEwitRDwHPJkn09fQB2GtIyJUpjWZ9ePfgDo5WA3+oO7hGgMx3Rdhc2T/wJQ3LNU9yhkn0U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725279129; c=relaxed/simple;
	bh=bPQCWnR2QGrxxfzzXh8nuJx1teRuQCnUvrGuF9w1LV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcHYg39NhYnJT349set0bd4YsOCb3E/95zHRaz71OAnU1fq5pajBI1YGVTIFYyv+jTIDXrlxulX2DAjSL2SO2kgBBISbBxR3SXU+7K/9yPNAmq3HN2ehksoEw0Q0HhJUt3SaEi23udT42uxGe50P7HOSBTs91W38oXqnYkxroJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a0xNl7kZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/IJKrscr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a0xNl7kZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/IJKrscr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a0xNl7kZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/IJKrscr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a0xNl7kZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/IJKrscr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D757D21B42;
	Mon,  2 Sep 2024 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725279125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuZnnVLT4ms0Hjl23HIep/aEzmyjGecUonxO48zfw8M=;
	b=a0xNl7kZgtbjAKL4PGY4/pfBR93xYb2fCw23MOXOimFXdpwwQExqxVVGNURlndlIVN+hwv
	BSPoL/r8FzW0BmilibGogIKwIp/4Uk9bX0Hyy7QdX3IjALlqmf66ef3l3W5JjQeuyFAmdm
	FBYmTw1+dHZT595ixZX3Vh1VBDe8mk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725279125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuZnnVLT4ms0Hjl23HIep/aEzmyjGecUonxO48zfw8M=;
	b=/IJKrscru8MHK61cn1VJt2XNN3sK5k8Nb1QWUbTwFA9QDmoXcFyjceqvGV8ZhKfvt40KTN
	6/cFtU4992SzKCCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725279125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuZnnVLT4ms0Hjl23HIep/aEzmyjGecUonxO48zfw8M=;
	b=a0xNl7kZgtbjAKL4PGY4/pfBR93xYb2fCw23MOXOimFXdpwwQExqxVVGNURlndlIVN+hwv
	BSPoL/r8FzW0BmilibGogIKwIp/4Uk9bX0Hyy7QdX3IjALlqmf66ef3l3W5JjQeuyFAmdm
	FBYmTw1+dHZT595ixZX3Vh1VBDe8mk0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725279125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuZnnVLT4ms0Hjl23HIep/aEzmyjGecUonxO48zfw8M=;
	b=/IJKrscru8MHK61cn1VJt2XNN3sK5k8Nb1QWUbTwFA9QDmoXcFyjceqvGV8ZhKfvt40KTN
	6/cFtU4992SzKCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6429713AE0;
	Mon,  2 Sep 2024 12:12:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1ZVkC5Wr1WY/CgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 02 Sep 2024 12:12:05 +0000
Date: Mon, 2 Sep 2024 09:11:18 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
Message-ID: <ahdte3act4vozuxoc3vfz7cutyvye44ltqmyu7d2wedcdog6ei@7xgxdvrndmf3>
References: <20240831000937.8103-1-ematsumiya@suse.de>
 <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
 <CAH2r5mtz5ROx=vfKD=JMVteJ1WCyg8ZiCFGv+AXcV7TcMM-4DQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mtz5ROx=vfKD=JMVteJ1WCyg8ZiCFGv+AXcV7TcMM-4DQ@mail.gmail.com>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,manguebit.com,gmail.com,microsoft.com,talpey.com,suse.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 09/01, Steve French wrote:
>This does look wrong since it would affect use of acdirmax/acregmax.

So, as per my question in my first follow up reply, it should be
possible to not cache handles, but still cache attributes?

TBH I agree the fix might be wrong, as it seems the problem is more
fundamental than this -- it was more of a PoC, thus sent as RFC.

But my understanding is that if we're not getting leases, we shouldn't
be caching anything at all (i.e. neither files/dirs nor their
attributes).

e.g. something like (handcrafted, untested) in connect.c:cifs_get_tcon():

-         else
-                 nohandlecache =3D true;
+	  else {
+		  nohandlecache =3D true;
+		  ctx->acregmax =3D 0;
+		  ctx->acdirmax =3D 0;
+	  }

This illustrates better what I'm asking (and also a clearer intent of
my original patch).

>Would like to dig deeper into the failure and see if more intuitive
>way to fix it.
>
>It also seems like the if ... nohandlecache check applies more to
>whether it is worth calling open_cached_dir_by_dentry ... not to
>whether we should leverage acdirmax/acregmax cached dentries
>
>On Sat, Aug 31, 2024 at 11:36=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
>>
>> tentatively merged to cifs-2.6.git for-next pending testing and
>> additional review
>>
>> On Fri, Aug 30, 2024 at 7:10=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.=
de> wrote:
>> >
>> > Some operations return -EEXIST for a non-existing dir/file because of
>> > cached attributes.
>> >
>> > Fix this by forcing dentry revalidation when nohandlecache is set.
>> >
>> > Bug/reproducer:
>> > Azure Files share, attribute caching timeout is 30s (as
>> > suggested by Azure), 2 clients mounting the same share.
>> >
>> > tcon->nohandlecache is set by cifs_get_tcon() because no directory
>> > leasing capability is offered.
>> >
>> >     # client 1 and 2
>> >     $ mount.cifs -o ...,actimeo=3D30 //server/share /mnt
>> >     $ cd /mnt
>> >
>> >     # client 1
>> >     $ mkdir dir1
>> >
>> >     # client 2
>> >     $ ls
>> >     dir1
>> >
>> >     # client 1
>> >     $ mv dir1 dir2
>> >
>> >     # client 2
>> >     $ mkdir dir1
>> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exists
>> >     $ ls
>> >     dir2
>> >     $ mkdir dir1
>> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exists
>> >
>> > "mkdir dir1" eventually works after 30s (when attribute cache
>> > expired).
>> >
>> > The same behaviour can be observed with files if using some
>> > non-overwritting operation (e.g. "rm -i").
>> >
>> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> > Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> > ---
>> >  fs/smb/client/inode.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> > index dd0afa23734c..5f9c5525385f 100644
>> > --- a/fs/smb/client/inode.c
>> > +++ b/fs/smb/client/inode.c
>> > @@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>> >         if (!lookupCacheEnabled)
>> >                 return true;
>> >
>> > +       if (tcon->nohandlecache)
>> > +               return true;
>> > +
>> >         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid))=
 {
>> >                 spin_lock(&cfid->fid_lock);
>> >                 if (cfid->time && cifs_i->time > cfid->time) {
>> > --
>> > 2.46.0


Cheers,

Enzo
