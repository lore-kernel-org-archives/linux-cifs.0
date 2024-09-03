Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A976F188916
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725376948; cv=none; b=RVSUT40XI58ai+t/zgaR3BkbC8sbIBkqeAFcaNJ111Zs6lyYmHJgof83gq6n9b9lvHlHKU9ZkAhE4/xjBsC9wUuNiutfFJq3DGhhIBY7Wv10kvOQEeV3soUlV3WmjMqpGuYJZanLZZBphjhM3Ne4BiYQkF7bVkW3IalJKy2Qxrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725376948; c=relaxed/simple;
	bh=Q2JPnhUyNctdDaxgm7i8Tx9XsbW2wUNsRhgpc1wQaSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1ZTirws9o4WsqrfT5zYaGoW8j1dsj8vlSJ7ErqfLzCzJEAiidZ6xX3XgpnW507YOls3Nwj9zS1iqC3RYz7Usx7XYmQW8AA5ozmpvkp+BLVS7B5MWQOFlShNuyqJJtfDVJP6zR0MMtHjs5S0EE/7KAWUo+7Sv4KAssTPdnKXcYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RhNAF2wN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eXrKfK8D; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RhNAF2wN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eXrKfK8D; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RhNAF2wN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eXrKfK8D";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RhNAF2wN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eXrKfK8D"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 94FE61F394;
	Tue,  3 Sep 2024 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725376944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NpgDL4W88Y598w861WtXT5URUCAPOXHhwgcCyjYtwA=;
	b=RhNAF2wNmrBN/DgRKC79AwXmjIOoJuqAw4LPH0E9pwCg2OiMP5boX/g5nkr8LgOkZ89TcO
	/zN5u9OBbb2MD4eoyui+7/I1+VfJ/yys5wQa5Fl9c3BCzVYEog7qEzvYr36U0NjyDoLe3t
	IhCWQ03euJhqStyeHmE1QBs3/je4rwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725376944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NpgDL4W88Y598w861WtXT5URUCAPOXHhwgcCyjYtwA=;
	b=eXrKfK8DaC3SQKZg0ne9h47McOjBe4yE7vViUAml0RWX72voCxYvn9m0/b7T+urfXMEKKp
	vFJRrpco+OAOW5CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RhNAF2wN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eXrKfK8D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725376944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NpgDL4W88Y598w861WtXT5URUCAPOXHhwgcCyjYtwA=;
	b=RhNAF2wNmrBN/DgRKC79AwXmjIOoJuqAw4LPH0E9pwCg2OiMP5boX/g5nkr8LgOkZ89TcO
	/zN5u9OBbb2MD4eoyui+7/I1+VfJ/yys5wQa5Fl9c3BCzVYEog7qEzvYr36U0NjyDoLe3t
	IhCWQ03euJhqStyeHmE1QBs3/je4rwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725376944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NpgDL4W88Y598w861WtXT5URUCAPOXHhwgcCyjYtwA=;
	b=eXrKfK8DaC3SQKZg0ne9h47McOjBe4yE7vViUAml0RWX72voCxYvn9m0/b7T+urfXMEKKp
	vFJRrpco+OAOW5CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21C6C13A80;
	Tue,  3 Sep 2024 15:22:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CpfmNq8p12bRbAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 03 Sep 2024 15:22:23 +0000
Date: Tue, 3 Sep 2024 12:21:33 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
Message-ID: <kmsgk4xxyiyj5ay6dumzyksslw7dwocb46dla55fvwih2qw7pp@kupfqpgemuq4>
References: <20240831000937.8103-1-ematsumiya@suse.de>
 <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
 <CAH2r5mtz5ROx=vfKD=JMVteJ1WCyg8ZiCFGv+AXcV7TcMM-4DQ@mail.gmail.com>
 <ahdte3act4vozuxoc3vfz7cutyvye44ltqmyu7d2wedcdog6ei@7xgxdvrndmf3>
 <CAH2r5msOoN0ao0es_-M-LU9Vb04Yjs5gCtGvcd5kgzGvw8sbGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5msOoN0ao0es_-M-LU9Vb04Yjs5gCtGvcd5kgzGvw8sbGA@mail.gmail.com>
X-Rspamd-Queue-Id: 94FE61F394
X-Spam-Level: 
X-Spamd-Result: default: False [-6.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,manguebit.com,gmail.com,microsoft.com,talpey.com,suse.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -6.01
X-Spam-Flag: NO

On 09/02, Steve French wrote:
>> So, as per my question in my first follow up reply, it should be
>possible to not cache handles, but still cache attributes?
>
>Yes - there are two types of caching.
>
>Safe caching of file attributes (size and mtime e.g.) and existence
>with file leases (for open files, or files whose close has been
>deferred) or file or directory existence with directory leases on the
>parent.
>
>"actimeo" attribute caching (less safe): Using actimeo sets all
>acregmax and acdirmax to the same value. If this option is not
>specified, the cifs (and similarly for NFS) client uses the defaults.
>"acregmax" controls how long mtime/size and existence of all are
>cached, while acdirmax does the same thing for directories (note that
>for directories, caching their existence can save much time in open of
>files in deep directory trees, it is less common that apps care about
>the mtime or ctime of a directory - just that the path is still valid
>- ie that the directory exists).
>
>cifs.ko sets a much lower value for actimeo by default than nfs, but
>it is still technically "unsafe" so applications that need 100%
>accuracy on timestamps or size of files being updated by other clients
>should set acregmax smaller (or to 0) - it is usually safe to keep
>acdirmax to a higher value.
>
>By default even if we do not have a lease - we will cache attributes
>for a file (so two stats on the same file, less than a second apart,
>will be benefit from the cached attributes and only require 1/2 as
>many SMB3.1.1 queryinfo calls to be sent over the wire)

Okay, thanks, I get that.

Performance is a reasonable explanation iff the files/dirs exists, which
is an assumption of cifs here.

I'm still researching ideas how to better handle this, but the fact that
dentry lookups are done by names, so -EEXIST is returned by the mkdir
syscall way before hitting any cifs code, makes really hard to come
up with an alternative fix that preserves this behaviour you mention.


Cheers,

>On Mon, Sep 2, 2024 at 7:12=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>>
>> On 09/01, Steve French wrote:
>> >This does look wrong since it would affect use of acdirmax/acregmax.
>>
>> So, as per my question in my first follow up reply, it should be
>> possible to not cache handles, but still cache attributes?
>>
>> TBH I agree the fix might be wrong, as it seems the problem is more
>> fundamental than this -- it was more of a PoC, thus sent as RFC.
>>
>> But my understanding is that if we're not getting leases, we shouldn't
>> be caching anything at all (i.e. neither files/dirs nor their
>> attributes).
>>
>> e.g. something like (handcrafted, untested) in connect.c:cifs_get_tcon():
>>
>> -         else
>> -                 nohandlecache =3D true;
>> +         else {
>> +                 nohandlecache =3D true;
>> +                 ctx->acregmax =3D 0;
>> +                 ctx->acdirmax =3D 0;
>> +         }
>>
>> This illustrates better what I'm asking (and also a clearer intent of
>> my original patch).
>>
>> >Would like to dig deeper into the failure and see if more intuitive
>> >way to fix it.
>> >
>> >It also seems like the if ... nohandlecache check applies more to
>> >whether it is worth calling open_cached_dir_by_dentry ... not to
>> >whether we should leverage acdirmax/acregmax cached dentries
>> >
>> >On Sat, Aug 31, 2024 at 11:36=E2=80=AFPM Steve French <smfrench@gmail.c=
om> wrote:
>> >>
>> >> tentatively merged to cifs-2.6.git for-next pending testing and
>> >> additional review
>> >>
>> >> On Fri, Aug 30, 2024 at 7:10=E2=80=AFPM Enzo Matsumiya <ematsumiya@su=
se.de> wrote:
>> >> >
>> >> > Some operations return -EEXIST for a non-existing dir/file because =
of
>> >> > cached attributes.
>> >> >
>> >> > Fix this by forcing dentry revalidation when nohandlecache is set.
>> >> >
>> >> > Bug/reproducer:
>> >> > Azure Files share, attribute caching timeout is 30s (as
>> >> > suggested by Azure), 2 clients mounting the same share.
>> >> >
>> >> > tcon->nohandlecache is set by cifs_get_tcon() because no directory
>> >> > leasing capability is offered.
>> >> >
>> >> >     # client 1 and 2
>> >> >     $ mount.cifs -o ...,actimeo=3D30 //server/share /mnt
>> >> >     $ cd /mnt
>> >> >
>> >> >     # client 1
>> >> >     $ mkdir dir1
>> >> >
>> >> >     # client 2
>> >> >     $ ls
>> >> >     dir1
>> >> >
>> >> >     # client 1
>> >> >     $ mv dir1 dir2
>> >> >
>> >> >     # client 2
>> >> >     $ mkdir dir1
>> >> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exi=
sts
>> >> >     $ ls
>> >> >     dir2
>> >> >     $ mkdir dir1
>> >> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exi=
sts
>> >> >
>> >> > "mkdir dir1" eventually works after 30s (when attribute cache
>> >> > expired).
>> >> >
>> >> > The same behaviour can be observed with files if using some
>> >> > non-overwritting operation (e.g. "rm -i").
>> >> >
>> >> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> >> > Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> >> > ---
>> >> >  fs/smb/client/inode.c | 3 +++
>> >> >  1 file changed, 3 insertions(+)
>> >> >
>> >> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
>> >> > index dd0afa23734c..5f9c5525385f 100644
>> >> > --- a/fs/smb/client/inode.c
>> >> > +++ b/fs/smb/client/inode.c
>> >> > @@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
>> >> >         if (!lookupCacheEnabled)
>> >> >                 return true;
>> >> >
>> >> > +       if (tcon->nohandlecache)
>> >> > +               return true;
>> >> > +
>> >> >         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfi=
d)) {
>> >> >                 spin_lock(&cfid->fid_lock);
>> >> >                 if (cfid->time && cifs_i->time > cfid->time) {
>> >> > --
>> >> > 2.46.0
>>
>>
>> Cheers,
>>
>> Enzo
>
>
>
>--=20
>Thanks,
>
>Steve
>
