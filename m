Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D90C757E4
	for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709229142; cv=none; b=N0OW8lisOryFg6Ox4w2ojfx78qnJRGP7UopM45EVyfA2XCChMUReH7Nj9KPTmZgYafTYXDpMiqQpHEroghq4KJvh7m/nDX0HwDiHbHi4NdwcsS+DhwWJ8ObEw/SSr89HVkgm1bhnHRnlGEu3lq4CCWPDZTapO6fxIkzHIzmfL/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709229142; c=relaxed/simple;
	bh=wE2PZ8bliNun+QTcNai73f/ciV0qVxgkZMp00JokK0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YIfKVclWmeuIm5m42EINYTKNNgutzQ6FUojXN15UvDwh8NRD5/q9Feefx3RoeKmhStFzaPsLBh8wl1tt7EfmPgJ4Y5OmJw88bGidNEIxCRf4pnvSiSm2ccpw1KhzO1EsJSNNZFlsN2f3Vk5fnynbajpmfkpGvv/jzjCqR27OqG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKxnaPYz; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKxnaPYz"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-dcc80d6004bso1174144276.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 09:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709229140; x=1709833940; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8+8otMoxwMqgEQQ4tdqaPS5Pluv66jSW4EuPLqwnxA=;
        b=MKxnaPYznBWi/lbtcy5r2ttAD0AZVLxGrgQOjs0EG/ifazs7ZyEqEzaHmrteEJbcrm
         qJtCy1PuUS458FHdAC7AB3lEmkdc06UcPbpQLZrMVLivoupGzV3aOIGW4TfiFSXacp+7
         EyTRUSIzOKl8ywZJCpUIyIEDwJVgbHXjrFugEyctcrWRFtfPNDjbCgrFlJsOU1J68Iwf
         1f2vrNCaTEO4HXpnej/oshhNDnGrABjhbIxW1BKw0G845gmAu1q6rFs3ldNjQX6PiyKD
         WGyTQtHJyab/3IpTinlOediciO296xKWgXueWiJu9hMqfuK1wQiKVlBNYE8FCJis+8jS
         8QmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709229140; x=1709833940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K8+8otMoxwMqgEQQ4tdqaPS5Pluv66jSW4EuPLqwnxA=;
        b=CJfNrAaPlZHtQY/PEvNoQ9pXFV2WZUtAf4RGWUXpmjKLvpmbikqlbEbumRaCcZ5EUJ
         R8IKbpy1ghc5kZQURJPS8Cdt+Eq6UvHx8uCgcIydFoiOYSjKPmps3e/r9WIs7YZNOvet
         E4t7Vrzie4nDPC9/1fzPzgZyF2bVo4N1LLWHwyk0z4enzGhXZ0u0b6lo1tqOSfzTihGn
         hLVm2RP2C/4RLl5vwckaSUe91o3M9ACbnND0ecQjCoAmT67MA3SGGLM7Ji/HnEecm+9F
         ReKWN4UfVXSC/J+tQTqdfk5KtclrUD3wVgbV+cpJI2QYsEymrf9Ur/U20Tv7qCXzBgo9
         /YdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWk/dYxTDsL10WznMUpK6mACf7S6SWtXinWQzBYpUETJd6D1gtpLJ9DtV9IqZPzDnVfZQEZxLJLShog0NYbHkhB+jxYbTHYvMuRw==
X-Gm-Message-State: AOJu0Yzy3gsOgVRieurU6bEmVj1HJqF4L/1mFfLf08fnp/kzudrvH1fH
	fX4X+52xYkNL3B3CRfFTBEKeWiEf7mgSJDlbUFSh38Qz8utmjRLE70coUaT2DAFRiMGU7jkBQu2
	fp+u9iofLraDhGqQGYSKzpDqO4AAmaQ/W7Y0=
X-Google-Smtp-Source: AGHT+IELpG/W/e309pxwtRN7JP2Lz8R0a88bsj6Krmpq7PhGcgb/IOV8JJzI9QoW1q7cZ9KEjlNWPAaldYHxyaFYZDA=
X-Received: by 2002:a25:6b04:0:b0:dcd:5635:5c11 with SMTP id
 g4-20020a256b04000000b00dcd56355c11mr3083924ybc.45.1709229140138; Thu, 29 Feb
 2024 09:52:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226045010.30908-1-bharathsm@microsoft.com>
 <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com> <CAGypqWzZoQZW4=EK_bCAORMXmw1+bdA7icptFEQCge05rrB14g@mail.gmail.com>
In-Reply-To: <CAGypqWzZoQZW4=EK_bCAORMXmw1+bdA7icptFEQCge05rrB14g@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 29 Feb 2024 23:22:08 +0530
Message-ID: <CAGypqWx9JwO5nz-S+Yr8kw3UBsZPk5n0hiwzGa632pm_f1zpWA@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent updating file size from server if we have a
 read/write lease
To: Steve French <smfrench@gmail.com>
Cc: pc@cjr.nz, sfrench@samba.org, nspmangalore@gmail.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

minor update to resolve conflicts.
And Cc: stable@vger.kernel.org

On Wed, Feb 28, 2024 at 3:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Attached updated patch to have this fix only for calls from readdir
> i.e cifs_prime_dcache.
>
> On Mon, Feb 26, 2024 at 10:44=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
> >
> > My only worry is that perhaps we should make it more narrow (ie only
> > when called from readdir ie cifs_prime_dcache()  rather than also
> > never updating it on query_info calls)
> >
> > On Sun, Feb 25, 2024 at 10:50=E2=80=AFPM Bharath SM <bharathsm.hsk@gmai=
l.com> wrote:
> > >
> > > In cases of large directories, the readdir operation may span multipl=
e
> > > round trips to retrieve contents. This introduces a potential race
> > > condition in case of concurrent write and readdir operations. If the
> > > readdir operation initiates before a write has been processed by the
> > > server, it may update the file size attribute to an older value.
> > > Address this issue by avoiding file size updates from server when a
> > > read/write lease.
> > >
> > > Scenario:
> > > 1) process1: open dir xyz
> > > 2) process1: readdir instance 1 on xyz
> > > 3) process2: create file.txt for write
> > > 4) process2: write x bytes to file.txt
> > > 5) process2: close file.txt
> > > 6) process2: open file.txt for read
> > > 7) process1: readdir 2 - overwrites file.txt inode size to 0
> > > 8) process2: read contents of file.txt - bug, short read with 0 bytes
> > >
> > > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > > ---
> > >  fs/smb/client/file.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > > index f2db4a1f81ad..e742d0d0e579 100644
> > > --- a/fs/smb/client/file.c
> > > +++ b/fs/smb/client/file.c
> > > @@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsInodeInf=
o *cifsInode, __u64 end_of_file)
> > >         if (!cifsInode)
> > >                 return true;
> > >
> > > -       if (is_inode_writable(cifsInode)) {
> > > +       if (is_inode_writable(cifsInode) ||
> > > +                       ((cifsInode->oplock & CIFS_CACHE_RW_FLG) !=3D=
 0)) {
> > >                 /* This inode is open for write at least once */
> > >                 struct cifs_sb_info *cifs_sb;
> > >
> > > --
> > > 2.34.1
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
