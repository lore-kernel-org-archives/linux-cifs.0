Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795191432;
	b=A5HYnB4wY2n+pb+ywhV2IYbBRhdZqDsfUcly/VCeXOYuQPtka3eIVfpD1a6rWkZ2uY/N
	 /huW6ue/sdUX+prLydL8QLn/sTShyIRnagpYMah9j0bBtbLmv7whmXs+DX4XZj4l6GLhT
	 Q+04iGto79K3mTII42D0+yxlJA5BbGjNGh31A0W4EE5iZtOYoJEmwawb9PiwPRCakNyFb
	 ghZoGhhxB9oia+ae602u/Yyr3mW0ZDlVawjFHOUj8kCmoV5HICU8j3zV0UyDycsBkzsi/
	 EIC7zEzelylSd99DdKuzIeCZsUhMh07PP6RXz1PDsxPbGyXVtFQ+2tayW7pLZna/5zQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191432;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
	b=MvMOcXdFv8qajLQsM5Lq58KaAoui+Ebz09UR1VjrBHQXC5s9X5cc46XKLOacyOJo7yWy
	 AjSfh5PIPHJQyuYrUjtRoRLAOPWSWPR25q0Y9C8+k3Bm6Aa9lB9u8mIiPeSIUVGodW19U
	 Q/YAR/vENwmrUDPLl7J8G3sYNSQwSaLT7kIF04o/8XnWEjIci4R6To7RELPxROfLk5jqp
	 hmFkJbaKrCG6rRjDGX4zGHOUIz7ngASBj5uiVSXxPQfswQTY48eHBIcQDuHI6S0Ypit7m
	 Z5JeGEMTA4zMv/FojKfqRiu7tzGhmLjgVgPU3CFlqoFiYMsR/bYi6MIqQ+VquhXnAtg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="h/fZwFYo";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33994606A333
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 16:17:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33994606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h/fZwFYo
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b8786bb305so1360156a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 08:17:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795191430; cv=none;
        d=google.com; s=arc-20260327;
        b=CB34gTxXuQxXhmWkeZ7tBiLgehJGHIKIgU8ipdI8M0DkEIvUx44+BkhDfx8z6KbqSY
         T64AR8decdeCehwGw/y+RPOv057felOEZ/0gQBU99PHwEz4HWZya/LrvETY13nbNGejR
         f1VwdpuKZZLrVMuU/zf7yMDhPceiFmfz78XKVuXmC2YRseGx+fPNwekrUDqZxOmczSjs
         xRtiqAkmpLgunjhQwVLeuWqghATnOtGCtcWpd0SKIVDtu5PiZiKfU4mcJ/JFkOWJ56HQ
         GUKVOUNrW5HoCqXWEG9JSLV5UknzW/XEPfQhL4/RnbKfinN45MZkdzeGQk4BWEdIWcVI
         blrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        fh=U2ILapbtZIWhkFvJEzKmzTgVgd73/2poZh2hkOx6y50=;
        b=DQCKGwXULeRn2mp3UQdeCBvcOZxfYtoUw9JVtPFb1SbJL9lrXvFMBbutMV5gibNILz
         88+d879oPWar6oezHiSkELWzhMMjCzWsSlLH0Fl3ol2oSDd/7x+Ul1oQDyubVtVilhGH
         UzguQEuDCaNHscaz+s9gMNGn+0elb9luRVw51n1XYf7+uFCJA0Wio68Yl3DfQ4ihQl1L
         ePIoIuDcFillDgclGbJgf+VMIKFkgD2w3DN8KLbc3tGWcFeH6T54AgfN+8MnRnOajdJq
         nwOb3Q9rtAPuRkJPHTiwFbnV7ZGfpO7O2DWGkbnn7FDknWLUSkG1U8pnmAwKofP6NkKY
         L+qQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191430; x=1795796230; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        b=h/fZwFYoiZ5YPRIJdDNPd6R2WQqQoX+h7cTcLwOfnPyAa1DPa1hxluLRyoO6Xm4sY9
         ovgYMuN1VmVG2b0g/LvfpIVhbQQX2N6IaALoOXq1GETPLvZs61MuhJ0UhI/bX7lZx9kE
         jrz+F1knWHvPKhUY4x5+Zcq6R49IPXPGuHiJXtvd9qU+hHWP0DeqyDjhSzKwzl2IvYdL
         y8KcOZpqPD5+clxjMHGD0gIx54eNMFAhPY1AXnyv17zAzyJbePexJvC3yP8mla0hT9fU
         J1CtyrcpOL584I1Qt0hbElWxdBJJ+Dsh5m8jAkiw92q7dDtejYpy9TmKaIr813bbhk4r
         grXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191430; x=1795796230;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        b=ekpegQYhBgXoesawNj+OYPMm+9YtXad2Stu1gVvbNmjZ5zbLn624faeRB6Vpf9z5Nl
         U+7LoXasaWYBBt4QFknWZ1YnhPntTqHNNivILqV2jcd1kR1J+ljviNKfAJYiQHv3C0D4
         O0HCd6JzWErS0YhjiAnIvZNXZ40AsDoNinWrwOAR2nDmqDmDHruRsyfIC8tO8b7b21/A
         sNtxlGaWUB22KFuqvb0pf5OE3bsHDMkYfnXSrZPp1XZnC14Omp4kdHX/1t20h7EQ+8tu
         2gCXszPkjVtOX7ga2RQWnLG44TN3cA0pt035y3Sf2mvua5O+rBz7+h3U7XU7wL1rKawb
         Y5xQ==
X-Forwarded-Encrypted: i=1; AL+hErFYQ83y5x0fopjuISerkwnSEAfHtKnCFgDDK9DaOAMqvU+5pM9/1rIv5mBGrf8HD9sTId75QrWrfq69@vger.kernel.org
X-Gm-Message-State: APuU4Z/YwiEdcnTMitu15R34USv06vNMnxg97R3eG47TCeo9T+Tw2N2A
	94315kkP2rVlG/Gthr8FDHmq33xuoVtQbMj0lDhg8bput/8TiyRa6m36NbhGmPBU6KD7YMDJnP1
	UL5tGFifG32v+CLm4KOn3w2tDlmffLAw=
X-Gm-Gg: AZFdTZcvZTfbxWm81oYbi/MX2ZMmjoEhim1l85vx8WFEjydniV4hTw4PeI+OV7DNLjv
	dY8Tp5ika0tMYcbJWilL0EkrkUYSCogdgAYmNB6Ck1t5gEFUG96II5rP3dOHxTYoRj7Gyp3Aoyp
	0raLEOkj5nrkP2LqVq2aUxDazj5/zjS253PqvvyhMG6iJJ/oPRFMk3XLivn9gMlAmejqbZjbueR
	WTgTElZbed4rhqc/XV/deEM2yWbY5tP6qnK6C39bNfZkCltM5vDoQYrtP6zKt8+VE+4csSJ2KAY
	LwLS/fOaz4CDhYuYxZdzETitrucevAz5UTQEWd7EyD+w670anKu0NHZaJVapjpBhy6kdtL1YOUv
	7VUTYEoXC237V42uroxMCMuBL5VDR1KFEExSDi0okhgZo3uP13y80mzoP4z3IZ8c8Ti+VtQ==
X-Received: by 2002:a05:6402:3223:b0:6b8:5f08:931b with SMTP id
 4fb4d7f45d1cf-6ba37ea44b2mr2736007a12.26.1795191430236; Fri, 20 Nov 2026
 08:17:10 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-9-koray.fra@gmail.com>
 <CAOQ4uxgoNsOH82FyrCxc+qSoid_CFmbmpL0qgWFw-e8E689fFA@mail.gmail.com>
 <DMZJ4PL1JVA4.2YEB7EPYJR5Q7@gmail.com> <CAOQ4uxi6h9BBP7pf4sR+gc2+4XtkEgbxXZha45iZzdB_wGFVgQ@mail.gmail.com>
 <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com> <CAOQ4uxh+d-wNC0aWLEexPFz7zj=TZjLyu61kaEmwBx9_hKn2gg@mail.gmail.com>
 <DN0526U5C1RT.3AQRIHXPB86NS@gmail.com>
In-Reply-To: <DN0526U5C1RT.3AQRIHXPB86NS@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 17:16:57 +0100
X-Gm-Features: Aa3M54o4zCHXyRapvg8jSZ5VVJaxHz4N0ZrJOn4Hcu1m2DItc14K7Jop9PLrcPo
Message-ID: <CAOQ4uxjCN-ekd18R-soD8tkGFnXjK0S1VdSNhq9b3Ev6y8K9jQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 08/10] nfs: add provenance time (ptime) via FATTR4_TIME_CREATE
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 4:21=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Fri Nov 20, 2026 at 3:55 PM CET, Amir Goldstein wrote:
> > On Fri, Nov 20, 2026 at 2:34=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> On Fri Nov 20, 2026 at 7:45 AM CET, Amir Goldstein wrote:
> >> > On Thu, Nov 19, 2026 at 11:10=E2=80=AFPM koraynilay <koray.fra@gmail=
.com> wrote:
> >
> >> >> >                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING=
;
> >> >> > +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESER=
VING;
> >> >> > +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRE=
SERVING;
> >> >> Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn'=
t
> >> >> it *only* be in _ro_mask? (same for CASEFOLD)
> >> >>
> >> >
> >> > Good question. Maybe
> >> > I guess if you want to follow some percent
> >> > FS_FL_USER_MODIFIABLE is a subset of FS_FL_USER_VISIBLE
> >> > but I think that exporting ro_mask and _mask is going to be easier a=
nd
> >> > cleaner than rw_mask but not sure.
> >>
> >> Hmm I asked that also because you said in the xfs shared extent thread=
:
> >>
> >> > The advantage being that it makes the interface symmetric.
> >> > User can alway setattr() with the buffer they got from getattr()
> >> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> >> > along with fsx_mask defines the behavior exactly.
> >>
> >> But by putting the ro flags in _mask too, a user would have to clean
> >> them out or vfs will reject the call with -EINVAL/something else, sinc=
e
> >> in that case the vfs would see the user say "I want to change this [ro=
]
> >> flag".
> >>
> >
> > That's just a matter of interpretation.
> >
> > You could say that if flag FS_XFLAG_CASENONPRESERVING
> > is in ro_mask then its value may not be modified and fs needs to
> > fail the set
>
> Yes, that's what I was thinking.
>
> > if the user given value is not a match to the current
> > kernel's value.
>
> Since this is a new API, I think it's fine to -EINVAL if it's in _mask
> anyway, even if the value is the same, no?
>

The question is only about when a flag is set in _ro_mask
and say that it is not in _rw_mask
what do you do with the value of this flag in _xflags?

You can simply ignore it, mask it out as  copy_fsxattr_to_user()
is doing today and this is probably the right choice.

But you could also take a more conservative approach
like ntfs_fileattr_set() in fs/ntfs/file.c:

        /* chattr passes the unchanged read-only flags back to us too. */
        if (NInoCompressed(ni) || NInoWofCompressed(ni))
                readonly |=3D FS_COMPR_FL;
        if (NInoEncrypted(ni))
                readonly |=3D FS_ENCRYPT_FL;
        if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
                return -EOPNOTSUPP;

This is stronger, because userspace can express:
set flag X while making sure the flag Y is not set

in this case xflags =3D X, xflags_rw_mask =3D X, xflags_ro_mask =3D Y

It does not have to mean that Y is a readonly attribute
the filesystem itself could set it in rw_mask, but when user
puts it in ro_mask its a verification_mask rather than an ignore_mask

In both interpretations (verify/ignore) the sequence:

    ret =3D get_fileattr(&fa)
    ret =3D set_fileattr(&fa)

should work fine most of the time, but if some rdonly flag
can flip between the two calls (e.g. FS_XFLAG_PREALLOC)
then the set call would fail and this is not the expectation
wrt the existing FS_XFLAG_RDONLY_MASK flags.

Thanks,
Amir.
