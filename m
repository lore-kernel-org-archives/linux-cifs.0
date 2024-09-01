Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412741F957
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725221736; cv=none; b=lxXra/fTYxM7Pw8T0CONWooS2tKS+eSdlSyi25oOuG8b/LzuoqpjQGFjbsIoqKVMvHQnBpJ/HWcMO20treLrF8UU/KZiYMI19msY4uVaBHSmKDUFRtlEOz3lh3N/BC9bDZHXkYB+3iXtb3KEvr6rzNVB+rxO8hC6xOyvGl8YeD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725221736; c=relaxed/simple;
	bh=ETG0BzaT99Lr9FjhUAJF9adIBkY3pURZYqYnSnXY4lQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pK4iYcbRQFPVk4P43cQ0rJeH+s7VLG1ihwVEeHHnd1fRa4oVVuE29m/OX0RA0Lp1wUkmEG9e9A4PWZGmEd7nN6jdpKUhBB388KwapycraOn8ccZLaZUtAX6jsCI0aOfg1JsdEWZHVIzbUYjn7vDtCEd/gqB+aeVbiJEs1GMxbTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4g+aY3p; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4g+aY3p"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5344ab30508so4350547e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Sep 2024 13:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725221732; x=1725826532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxLYTyIyYy++PuaXcAiLYBgL62Mk7EoNo1yaSAPEIGw=;
        b=E4g+aY3pe7QgUh5GIoXpBSOnhq+JeVYORYinpsVrZp8ulfcfbltMOLZLCTtZapc2pz
         N3uzFEVzG1+0cekMGDpc1LUOZ2841kmA5eL/txZiENi8sdFKh21vf6FwdCHkKZWxwQiv
         XFIqLRyeg/FsELSs8/pkuqmYhRCOszpktZ2oEHH0E2Cun0FG1VfkIKyt7AWvjvtnWzEY
         Ax5IZKmYGq59OlHvRge4TQcdq0srHmB453Ud9Dj8CWfOBtL6z2zsi2+3YcFJ7F01xjGM
         BSlDnW5IDJHXaeXt4cOdDvAGo9I5Y+25k7UGAC3T2e1/ulD1Ag3+fJmYkwD4Xu0cFfeA
         +fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725221732; x=1725826532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qxLYTyIyYy++PuaXcAiLYBgL62Mk7EoNo1yaSAPEIGw=;
        b=V3XvospJ67p5DL1KrfCwC8/fARHGXUOWNI9S2hL/I3Mcbh53VIvpcYMUr9Srbax2fo
         z84hAHqfcrF4tQ4mVmMXfbYyjE+VTu/zoiTfskRxoWsb1mkr0SRtSViPVOtZsFhBQTaV
         10f29VG2MMbF1i9Zq2ZW8osPX48wqBmNf666WO6gGezLGPPjdEo+dtNIxIoi2PcSuKTU
         XUMg9i2LfUjbfM3jfMohR2JXNfWzh5XVgopACEhq6QCqI2mHDuUzxiKosi+bc1dZKfkd
         IKRVfUFHsuGjD5+NufFHe67lzbVcnPSzYZe8+GvMtQ85h28q12po2EioNWwS7WiQnVHm
         TNXQ==
X-Gm-Message-State: AOJu0YylenpLppyiXfBJHk/V4lqGXbt13jCPODOAX00N2tLutoyxbvgN
	gyY4m+IbH0qhYfxIZJxL6/CJ94fRg3MN0P0UQNKVPreg5o2gorTIx2fJMW2tp9Bpna4qEplvp/X
	w8bSdPhrMbgyq1E/IJH0oTXEQuGipu83Z
X-Google-Smtp-Source: AGHT+IFm6lTsro+cQiSBzP/y1dXuvRTbxQpvIgIoOY+6TM1oHqFyfipnsG6a1+62yDOWmocjrSkRo3vEuUDBb0hoWxQ=
X-Received: by 2002:a05:6512:2812:b0:52b:bee8:e987 with SMTP id
 2adb3069b0e04-535462ee2cemr2985766e87.3.1725221732135; Sun, 01 Sep 2024
 13:15:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240831000937.8103-1-ematsumiya@suse.de> <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
In-Reply-To: <CAH2r5msJ4HpuRi5mzOKvL5FhaUnxw2ZtaX331Sm2cZ92vCSgTA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Sep 2024 15:15:21 -0500
Message-ID: <CAH2r5mtz5ROx=vfKD=JMVteJ1WCyg8ZiCFGv+AXcV7TcMM-4DQ@mail.gmail.com>
Subject: Re: [RFC PATCH] smb: client: force dentry revalidation if
 nohandlecache is set
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This does look wrong since it would affect use of acdirmax/acregmax.

Would like to dig deeper into the failure and see if more intuitive
way to fix it.

It also seems like the if ... nohandlecache check applies more to
whether it is worth calling open_cached_dir_by_dentry ... not to
whether we should leverage acdirmax/acregmax cached dentries

On Sat, Aug 31, 2024 at 11:36=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> tentatively merged to cifs-2.6.git for-next pending testing and
> additional review
>
> On Fri, Aug 30, 2024 at 7:10=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > Some operations return -EEXIST for a non-existing dir/file because of
> > cached attributes.
> >
> > Fix this by forcing dentry revalidation when nohandlecache is set.
> >
> > Bug/reproducer:
> > Azure Files share, attribute caching timeout is 30s (as
> > suggested by Azure), 2 clients mounting the same share.
> >
> > tcon->nohandlecache is set by cifs_get_tcon() because no directory
> > leasing capability is offered.
> >
> >     # client 1 and 2
> >     $ mount.cifs -o ...,actimeo=3D30 //server/share /mnt
> >     $ cd /mnt
> >
> >     # client 1
> >     $ mkdir dir1
> >
> >     # client 2
> >     $ ls
> >     dir1
> >
> >     # client 1
> >     $ mv dir1 dir2
> >
> >     # client 2
> >     $ mkdir dir1
> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exists
> >     $ ls
> >     dir2
> >     $ mkdir dir1
> >     mkdir: cannot create directory =E2=80=98dir1=E2=80=99: File exists
> >
> > "mkdir dir1" eventually works after 30s (when attribute cache
> > expired).
> >
> > The same behaviour can be observed with files if using some
> > non-overwritting operation (e.g. "rm -i").
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/inode.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> > index dd0afa23734c..5f9c5525385f 100644
> > --- a/fs/smb/client/inode.c
> > +++ b/fs/smb/client/inode.c
> > @@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
> >         if (!lookupCacheEnabled)
> >                 return true;
> >
> > +       if (tcon->nohandlecache)
> > +               return true;
> > +
> >         if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) =
{
> >                 spin_lock(&cfid->fid_lock);
> >                 if (cfid->time && cifs_i->time > cfid->time) {
> > --
> > 2.46.0
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
