Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3E2262A3
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725378322; cv=none; b=e8Yo5cjAT701aRh8vTHBSpBuZqgBvLeOapTgnEnJ4ynYf19WN4gkEGGY3yXEbuFzjJty4XbOCNGZ+B27D6mCW3ChL5RO8WBlD0gDgJt60IL+DcF+Dhrnwgv7GngBMcXmXo+0O676jezsMYJ3IJbh+Vn4eCGNskIbUaC3IoZBKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725378322; c=relaxed/simple;
	bh=RyzIVobnEck+KOW7rJkjutzTJqjQXJ1mUNJZH6G+SZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=myFrE3xN6Bv6y9OgAyZAE0d/7It36H2pbTIfqfSOmYMD8glm7RBpbb0rjAZYWTkj9advDyduxmuRo8uEZdy6hltzxZl10bOLiEjQFzN5WeyAlArF9tB/FT7u6B/V+wgzznWnZd6rFaACTu8FSIh4VLrqPITQl4QCzKPmIZ7kZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ib7/+Nm/; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ib7/+Nm/"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53345604960so6352854e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2024 08:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725378319; x=1725983119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ph6GWROfJXKj3IbOMGOii5BN7Jh5KZ+GrH4nOlEMFHs=;
        b=Ib7/+Nm/0SduwBxQlwP2pBu7F10jNtwbMJ5wnSvg9vGbANNyH5vhtommX66krZeyfv
         FgeFrZH9WtstW1E2DU60ErDTGO3zfIzL94UVC41dWLFwzCI6eZmn86HAN+/4VQN0v76i
         C1z7UdMOm6nY8IPoIafdFTeVQWkwAOeh1B1Pb7zpIjg21nUClLK4nnLoqSElWOwp87H8
         dI8PKiWPDNy2l1ZxPAQFqHa44Iux8Q0KXGqnG3T1M2fwzT9krYZIdcwHWnifyJvFiJD0
         ai8uq6TOr3RPeccv3Dy5Ca7RlZ7o+5zI+XNXw6ul2tSQhT4J6+H2t8bgkimulZMzCLyD
         1WRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725378319; x=1725983119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ph6GWROfJXKj3IbOMGOii5BN7Jh5KZ+GrH4nOlEMFHs=;
        b=d1tm0xdz24MEuC+u+V/SC0+9qB82vLSpdEIjEQgssgzHVzpHQuMpmAX/luD176N42D
         TNJGRnZTs3DIv+Yl7IKjxloSZ4YANmXOlVUdypQyBETTXQW1mGQ5rbIh52aNMdtacHfa
         LOHqXr58YANosEMmbZzWU9PZXI8ZspUwezm+wyFLeTawPtIP1zxdw4MwGkbarTH/PZz3
         +JCVXhdY37KCDNB5RdycrWXYoUiEVIMnkKvwJK0yNsADnt5tNqtTszrn9fLGszBAN0ds
         xZWUNPFrTiriOPmxA1MZyA9AE16cRqUGv9gBJJEM4+2yYwkv6sY6UJdxE4LFHfxdm3cQ
         JLaw==
X-Gm-Message-State: AOJu0Yz92fHl9lG6CXjQiPAwLy3Xqn5gDT2nVpfKJvj1fU3zT89EmyoZ
	3WnyiomUo6eh32jtYlH+s5603AvaE+FAqgCTbqJzEjnjJMFGRNjyu8EvzCT8ou1yUemgixtbW/0
	ahA9Qec/Z27tyyz8pccRbyAmlQIM=
X-Google-Smtp-Source: AGHT+IE1pI42OHY5TjZSi3EHifmWohq8bfTLnW9XR5vJTegoERmI/ob8d0bhBVZxsbLjXsW9akt3DkkTbo3QFNpvmhY=
X-Received: by 2002:a05:6512:3089:b0:52c:8abe:51fb with SMTP id
 2adb3069b0e04-53546af36dbmr9947890e87.10.1725378318544; Tue, 03 Sep 2024
 08:45:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240831000937.8103-1-ematsumiya@suse.de> <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
 <CAH2r5mtz5ROx=vfKD=JMVteJ1WCyg8ZiCFGv+AXcV7TcMM-4DQ@mail.gmail.com>
 <ahdte3act4vozuxoc3vfz7cutyvye44ltqmyu7d2wedcdog6ei@7xgxdvrndmf3>
 <CAH2r5msOoN0ao0es_-M-LU9Vb04Yjs5gCtGvcd5kgzGvw8sbGA@mail.gmail.com> <kmsgk4xxyiyj5ay6dumzyksslw7dwocb46dla55fvwih2qw7pp@kupfqpgemuq4>
In-Reply-To: <kmsgk4xxyiyj5ay6dumzyksslw7dwocb46dla55fvwih2qw7pp@kupfqpgemuq4>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Sep 2024 10:45:06 -0500
Message-ID: <CAH2r5mvp6=A-bpsaYAvJYuujxMi6J0ekZAsDRJ+neZDAW07OVg@mail.gmail.com>
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

And as expected, the intel bot showed performance degradation with the
RFC version of the patch (your earlier version) due to extra network
traffic (revalidate)

On Tue, Sep 3, 2024 at 10:22=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 09/02, Steve French wrote:
> >> So, as per my question in my first follow up reply, it should be
> >possible to not cache handles, but still cache attributes?
> >
> >Yes - there are two types of caching.
> >
> >Safe caching of file attributes (size and mtime e.g.) and existence
> >with file leases (for open files, or files whose close has been
> >deferred) or file or directory existence with directory leases on the
> >parent.
> >
> >"actimeo" attribute caching (less safe): Using actimeo sets all
> >acregmax and acdirmax to the same value. If this option is not
> >specified, the cifs (and similarly for NFS) client uses the defaults.
> >"acregmax" controls how long mtime/size and existence of all are
> >cached, while acdirmax does the same thing for directories (note that
> >for directories, caching their existence can save much time in open of
> >files in deep directory trees, it is less common that apps care about
> >the mtime or ctime of a directory - just that the path is still valid
> >- ie that the directory exists).
> >
> >cifs.ko sets a much lower value for actimeo by default than nfs, but
> >it is still technically "unsafe" so applications that need 100%
> >accuracy on timestamps or size of files being updated by other clients
> >should set acregmax smaller (or to 0) - it is usually safe to keep
> >acdirmax to a higher value.
> >
> >By default even if we do not have a lease - we will cache attributes
> >for a file (so two stats on the same file, less than a second apart,
> >will be benefit from the cached attributes and only require 1/2 as
> >many SMB3.1.1 queryinfo calls to be sent over the wire)
>
> Okay, thanks, I get that.
>
> Performance is a reasonable explanation iff the files/dirs exists, which
> is an assumption of cifs here.
>
> I'm still researching ideas how to better handle this, but the fact that
> dentry lookups are done by names, so -EEXIST is returned by the mkdir
> syscall way before hitting any cifs code, makes really hard to come
> up with an alternative fix that preserves this behaviour you mention.
>
>
> Cheers,
>
> >On Mon, Sep 2, 2024 at 7:12=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >>
> >> On 09/01, Steve French wrote:
> >> >This does look wrong since it would affect use of acdirmax/acregmax.
> >>
> >> So, as per my question in my first follow up reply, it should be
> >> possible to not cache handles, but still cache attributes?
> >>
> >> TBH I agree the fix might be wrong, as it seems the problem is more
> >> fundamental than this -- it was more of a PoC, thus sent as RFC.
> >>
> >> But my understanding is that if we're not getting leases, we shouldn't
> >> be caching anything at all (i.e. neither files/dirs nor their
> >> attributes).
> >>
> >> e.g. something like (handcrafted, untested) in connect.c:cifs_get_tcon=
():
> >>
> >> -         else
> >> -                 nohandlecache =3D true;
> >> +         else {
> >> +                 nohandlecache =3D true;
> >> +                 ctx->acregmax =3D 0;
> >> +                 ctx->acdirmax =3D 0;
> >> +         }
> >>
> >> This illustrates better what I'm asking (and also a clearer intent of
> >> my original patch).
> >>
> >> >Would like to dig deeper into the failure and see if more intuitive
> >> >way to fix it.
> >> >
> >> >It also seems like the if ... nohandlecache check applies more to
> >> >whether it is worth calling open_cached_dir_by_dentry ... not to
> >> >whether we should leverage acdirmax/acregmax cached dentries
> >> >
> >> >On Sat, Aug 31, 2024 at 11:36=E2=80=AFPM Steve French <smfrench@gmail=
.com> wrote:
> >> >>
> >> >> tentatively merged to cifs-2.6.git for-next pending testing and
> >> >> additional review
> >> >>
> >> >> On Fri, Aug 30, 2024 at 7:10=E2=80=AFPM Enzo Matsumiya <ematsumiya@=
suse.de> wrote:
> >> >> >
> >> >> > Some operations return -EEXIST for a non-existing dir/file becaus=
e of
> >> >> > cached attributes.
> >> >> >
> >> >> > Fix this by forcing dentry revalidation when nohandlecache is set=
.
> >> >> >
> >> >> > Bug/reproducer:
> >> >> > Azure Files share, attribute caching timeout is 30s (as
> >> >> > suggested by Azure), 2 clients mounting the same share.
> >> >> >
> >> >> > tcon->nohandlecache is set by cifs_get_tcon() because no director=
y
> >> >> > leasing capability is offered.
> >> >> >
> >> >> >     # client 1 and 2
> >> >> >     $ mount.cifs -o ...,actimeo=3D30 //server/share /mnt
> >> >> >     $ cd /mnt
> >> >> >
> >> >> >     # client 1
> >> >> >     $ mkdir dir1
> >> >> >
> >> >> >     # client 2
> >> >> >     $ ls
> >> >> >     dir1
> >> >> >
> >> >> >     # client 1
> >> >> >     $ mv dir1 dir2
> >> >> >
> >> >> >     # client 2
> >> >> >     $ mkdir dir1
> >> >> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File e=
xists
> >> >> >     $ ls
> >> >> >     dir2
> >> >> >     $ mkdir dir1
> >> >> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File e=
xists
> >> >> >
> >> >> > "mkdir dir1" eventually works after 30s (when attribute cache
> >> >> > expired).
> >> >> >
> >> >> > The same behaviour can be observed with files if using some
> >> >> > non-overwritting operation (e.g. "rm -i").
> >> >> >
> >> >> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> >> >> > Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >> >> > ---
> >> >> >  fs/smb/client/inode.c | 3 +++
> >> >> >  1 file changed, 3 insertions(+)
> >> >> >
> >> >> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> >> >> > index dd0afa23734c..5f9c5525385f 100644
> >> >> > --- a/fs/smb/client/inode.c
> >> >> > +++ b/fs/smb/client/inode.c
> >> >> > @@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dent=
ry)
> >> >> >         if (!lookupCacheEnabled)
> >> >> >                 return true;
> >> >> >
> >> >> > +       if (tcon->nohandlecache)
> >> >> > +               return true;
> >> >> > +
> >> >> >         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &c=
fid)) {
> >> >> >                 spin_lock(&cfid->fid_lock);
> >> >> >                 if (cfid->time && cifs_i->time > cfid->time) {
> >> >> > --
> >> >> > 2.46.0
> >>
> >>
> >> Cheers,
> >>
> >> Enzo
> >
> >
> >
> >--
> >Thanks,
> >
> >Steve
> >



--=20
Thanks,

Steve
