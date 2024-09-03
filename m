Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9BA2904
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725339502; cv=none; b=oGAHbw10N/M58I+l1TwgpMBFk2fuuoJReYrM6ClQ+QXD04fc3fELcoIwfxTCZ2sHDzLX8mRTxNvOJ2WXfMq/gtmkb9hnJ0lcmYP32ytRHvjHvwTKvf/kwZuXW6DaLGSikkJDIGE+sX/FklAdWPybq0jg2/QXw/DxRPSO2o9fvVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725339502; c=relaxed/simple;
	bh=kJYhkQ+0FE2XYt2TOHz7d8aWu42wcW0PriO/HzM2GVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pnvw70InJ6EAm1gkRM3ikUEyZOigoghzw83OkP5MgZjX7AoLTIXCZuNaKGfNwvTRS8ue0pRIvEsg1h98aPLkf+9Q/3NBgO/E/7n1/52U+9/Htgk+42oeHhXU9O9+fbx96UtEmt6AEDgcnfXTwy9yzj1qTKUoblcCGyYgcJDervI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UgwUYjvK; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UgwUYjvK"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5bf006f37daso919377a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Sep 2024 21:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725339499; x=1725944299; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mTPMLRdKhDB1FUYXEzZIImcFWZhvkS9G5QC4GlBXNHA=;
        b=UgwUYjvKoaLs5w+E0uMRg6er8Ur7kG5qZGQnzCJYGVvisVJrESl/sNzPv91zFSKPZ4
         h0JDat+xb45mhWxtpGKrlA+6ect89iLSZfp/BWX5xuq9livTOv8KWDSXUIYLX5GCpmVl
         EIlTzCdyawPyLgR9BjhEx+MJaC7tNfw70IJjSxFHACeB0fDhXsM2Xf1AJ0Uk4hYLjbaF
         YGoetjk/dy6iq9tHqJoPCkXBVPOyKa+Tba19t0E5wM/8FbhXaqwSbiSDNQyDKYTFdLIK
         SVOEd3Kh6hsU4tA+D1fNTDDdBisNvyGqnTMAxlC85GnU0atQZGeQIXlmAGkrMUsDdaQy
         swJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725339499; x=1725944299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mTPMLRdKhDB1FUYXEzZIImcFWZhvkS9G5QC4GlBXNHA=;
        b=LKSQEtHplZ72gwY1N4/fSBWaTT9gsdwxxwNFDXBZhA+ma089INr1fDll8JFVeKhUzu
         R/XrCVUAt/QvvfgTsqa4k/sarF5TtuoSWQwhCgQCQFn5SH1sc7P0G0+k5LjHOXoCXsQo
         SJLhuSsyTd7eLMgb3L/Z9cD/ekrA9wBOrb1+kWN+g9j9hk2zdDmQA1b8yRsWtRFP0FB7
         1oX6IokEOAhXTgYkwdRPpbhUI2QWUsc4E/8xGmVbKWCyRVjfHv6fHWTOw6LZJI4m0Bxz
         KBc62jdLRqveWMtauZPZshaXtqZyCnktHQt3EYyOsOZ82ZxpkyqOyt3VkN3cKvjO7NvQ
         fq4w==
X-Gm-Message-State: AOJu0YxUZDuoq9rRXz1C01zDfeCkDldRXVj/+mg6ozMohhcEI/EYM58N
	w1hBVCh3Y4IfQlBLaNst8Zlu3L5/OQ+IRoB3ku2wlCSo3aULjjghcO0L+eeZsSt2jVvvuRM3SQP
	s/oRYt62mhF0XqcjByGSofuN7xAcf+XDlLXE=
X-Google-Smtp-Source: AGHT+IGDgn5O3Z0SwwWl6hS6dAm2wGaVJHniqtOsmhlPM7/nkut9DQ7bXyMMB2t3VMyQ5f7ziOxkMXVBpPK0h2a3Zys=
X-Received: by 2002:a05:6402:538e:b0:5a1:4ca9:c667 with SMTP id
 4fb4d7f45d1cf-5c22f80557amr13809397a12.11.1725339498916; Mon, 02 Sep 2024
 21:58:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240831000937.8103-1-ematsumiya@suse.de> <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
 <CAH2r5mtz5ROx=vfKD=JMVteJ1WCyg8ZiCFGv+AXcV7TcMM-4DQ@mail.gmail.com> <ahdte3act4vozuxoc3vfz7cutyvye44ltqmyu7d2wedcdog6ei@7xgxdvrndmf3>
In-Reply-To: <ahdte3act4vozuxoc3vfz7cutyvye44ltqmyu7d2wedcdog6ei@7xgxdvrndmf3>
From: Steve French <smfrench@gmail.com>
Date: Mon, 2 Sep 2024 23:58:07 -0500
Message-ID: <CAH2r5msOoN0ao0es_-M-LU9Vb04Yjs5gCtGvcd5kgzGvw8sbGA@mail.gmail.com>
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> So, as per my question in my first follow up reply, it should be
possible to not cache handles, but still cache attributes?

Yes - there are two types of caching.

Safe caching of file attributes (size and mtime e.g.) and existence
with file leases (for open files, or files whose close has been
deferred) or file or directory existence with directory leases on the
parent.

"actimeo" attribute caching (less safe): Using actimeo sets all
acregmax and acdirmax to the same value. If this option is not
specified, the cifs (and similarly for NFS) client uses the defaults.
"acregmax" controls how long mtime/size and existence of all are
cached, while acdirmax does the same thing for directories (note that
for directories, caching their existence can save much time in open of
files in deep directory trees, it is less common that apps care about
the mtime or ctime of a directory - just that the path is still valid
- ie that the directory exists).

cifs.ko sets a much lower value for actimeo by default than nfs, but
it is still technically "unsafe" so applications that need 100%
accuracy on timestamps or size of files being updated by other clients
should set acregmax smaller (or to 0) - it is usually safe to keep
acdirmax to a higher value.

By default even if we do not have a lease - we will cache attributes
for a file (so two stats on the same file, less than a second apart,
will be benefit from the cached attributes and only require 1/2 as
many SMB3.1.1 queryinfo calls to be sent over the wire)

On Mon, Sep 2, 2024 at 7:12=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> On 09/01, Steve French wrote:
> >This does look wrong since it would affect use of acdirmax/acregmax.
>
> So, as per my question in my first follow up reply, it should be
> possible to not cache handles, but still cache attributes?
>
> TBH I agree the fix might be wrong, as it seems the problem is more
> fundamental than this -- it was more of a PoC, thus sent as RFC.
>
> But my understanding is that if we're not getting leases, we shouldn't
> be caching anything at all (i.e. neither files/dirs nor their
> attributes).
>
> e.g. something like (handcrafted, untested) in connect.c:cifs_get_tcon():
>
> -         else
> -                 nohandlecache =3D true;
> +         else {
> +                 nohandlecache =3D true;
> +                 ctx->acregmax =3D 0;
> +                 ctx->acdirmax =3D 0;
> +         }
>
> This illustrates better what I'm asking (and also a clearer intent of
> my original patch).
>
> >Would like to dig deeper into the failure and see if more intuitive
> >way to fix it.
> >
> >It also seems like the if ... nohandlecache check applies more to
> >whether it is worth calling open_cached_dir_by_dentry ... not to
> >whether we should leverage acdirmax/acregmax cached dentries
> >
> >On Sat, Aug 31, 2024 at 11:36=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> >>
> >> tentatively merged to cifs-2.6.git for-next pending testing and
> >> additional review
> >>
> >> On Fri, Aug 30, 2024 at 7:10=E2=80=AFPM Enzo Matsumiya <ematsumiya@sus=
e.de> wrote:
> >> >
> >> > Some operations return -EEXIST for a non-existing dir/file because o=
f
> >> > cached attributes.
> >> >
> >> > Fix this by forcing dentry revalidation when nohandlecache is set.
> >> >
> >> > Bug/reproducer:
> >> > Azure Files share, attribute caching timeout is 30s (as
> >> > suggested by Azure), 2 clients mounting the same share.
> >> >
> >> > tcon->nohandlecache is set by cifs_get_tcon() because no directory
> >> > leasing capability is offered.
> >> >
> >> >     # client 1 and 2
> >> >     $ mount.cifs -o ...,actimeo=3D30 //server/share /mnt
> >> >     $ cd /mnt
> >> >
> >> >     # client 1
> >> >     $ mkdir dir1
> >> >
> >> >     # client 2
> >> >     $ ls
> >> >     dir1
> >> >
> >> >     # client 1
> >> >     $ mv dir1 dir2
> >> >
> >> >     # client 2
> >> >     $ mkdir dir1
> >> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exis=
ts
> >> >     $ ls
> >> >     dir2
> >> >     $ mkdir dir1
> >> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exis=
ts
> >> >
> >> > "mkdir dir1" eventually works after 30s (when attribute cache
> >> > expired).
> >> >
> >> > The same behaviour can be observed with files if using some
> >> > non-overwritting operation (e.g. "rm -i").
> >> >
> >> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> >> > Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >> > ---
> >> >  fs/smb/client/inode.c | 3 +++
> >> >  1 file changed, 3 insertions(+)
> >> >
> >> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> >> > index dd0afa23734c..5f9c5525385f 100644
> >> > --- a/fs/smb/client/inode.c
> >> > +++ b/fs/smb/client/inode.c
> >> > @@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
> >> >         if (!lookupCacheEnabled)
> >> >                 return true;
> >> >
> >> > +       if (tcon->nohandlecache)
> >> > +               return true;
> >> > +
> >> >         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid=
)) {
> >> >                 spin_lock(&cfid->fid_lock);
> >> >                 if (cfid->time && cifs_i->time > cfid->time) {
> >> > --
> >> > 2.46.0
>
>
> Cheers,
>
> Enzo



--=20
Thanks,

Steve
