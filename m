Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4498B1B040D
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752514277; cv=none; b=jP/DRUw+ZXLjbaN/HFOyFMSiE4oIu82YPyMluI9cst7qK0mKDwVbZ5WNockPUEUVf74jqKj//PPiGAqKAcq5xcYmGHQ6SY14Y2cLkpqUjXtySDUfv9NSNsNFrSZAlZtGDPq17BSdobU5NzxDLupD/b+XBxwndUYQZIySmz1wpm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752514277; c=relaxed/simple;
	bh=pzfZpTb+O+sger9V/SjE+TaR33fBNRv6xVIXnIz190k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dsx7azwC+TCHB905532HYnKpp7noS5DTdCfY+lnM7YAEjT//AIqrA0jUf4kj14QtDzuzJ0IUrQxIByQUHLwKJzoj/eT6GZIHblwX6wSQg6mEN2lYziCKoy2pLzlV70NbW7haa0dD5phrYhvsijGQTOmzbr6Y8T9bv6SHaMT4SuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wi+YKvFy; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wi+YKvFy"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso41628936d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 10:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752514275; x=1753119075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAUcekZTSbbnjQ9iCGpnMI2DRkfrJFHhbVGWyYUqFS0=;
        b=Wi+YKvFyZt1d503cD4CCOX2Jwb1ZX3IPt/NKUVY9vcFXBezsEnyrUtZeq6/koWc4R0
         AITLVd4C+sRrAxqEt9HBBpOjDGvawU4S5anW5ZXhNRonwN6ie/4HqVO159o5ehT0r1xZ
         jAMeCamv49/6un5dKNH3gTDcGL8otVl435nQHBU01pTi/iDjnrBYhMY5iiquaoGNUKf0
         9Ac5swhMpOU85mKeXhjpy7W5dSUV6ZcsVvf2mAQGp9cwYrgKgtwLJ8Blr3vZKJi5Ijqm
         Jl+UYARwqW7qzuN5+iFAQCiDSzyHGWWFDrP0tLOgRCuyAGk/uz8JPtkX0vY1r9kqbPyD
         0poA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752514275; x=1753119075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAUcekZTSbbnjQ9iCGpnMI2DRkfrJFHhbVGWyYUqFS0=;
        b=AbH0oLhrCC9YhWdlYyRBqZTeRVNM98us0aKkK7JwzJCtXI1QKFx13T3T/MEmkspknJ
         7O24ykZ8KF7K9+oxW0y2daeIx+JW9hVeJnh1xIxRzMiu+yFvSi2U7XiwDV8HnsBQ1/SG
         1Q/tpHpsuuUybXal3XfV7nXwEeLDXZ91FATptRqokzER89lhEVS/HNasP80f6WtNwHLS
         TJj2mjQ3cRtbQ1UHo4/xVDW3BscML1ECN5SD17vScdCTCEO6bJblHCE6Jc7Y3qT7a8rX
         qbRL59mOEHV/dQuJZFYBu2M9thsbMY1SkjdS49bGyf6CGSuObXkRuSD2v61aGruHPiac
         i3FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgQRg8qFLmmjTn7/DSRjt98OKHjjmFSOQOKuIn4zdiVC4h+WEPvqXzkAQELtK2YHlk5kwem4zXGdiH@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9gUmbKkdgd6Ym4h14/2K13EGGAzQn2dFDXQe1D2HnPuJFmE/K
	YzckMGPSbDiiwMmaHfPtzfCWzH8dYEdW2227VvIGPdl/0aICU9+wpARRawCJnUGVuSXygdQpmM/
	osrs6YfWxTORBrd2ALzn8vkRtWoKL0lQ=
X-Gm-Gg: ASbGnct3HOfCwWzIQE848irdHPOoePEHRRdBxjxRebSG97P3Z7xGQMQa8I4eY7cwR2s
	qyJK+B4Uado7lJn0ouK+WHikdh0bhtVu/5ApsbaspmsiIreG6AZPCjPTx3VpRzDacVU8AWMSNVR
	Qw+rNGyFWl9arBqpdIxnMdUdIboGmEUaJwPYerh+tW4vgWGz6YAEyk0cvnM6WsDQ0l9CZE6fCtH
	tXT/a8i26U8/sDjxzqJ/sDv1lBIpdwGv7ZPgYtKLw==
X-Google-Smtp-Source: AGHT+IG4FtpvRedJZf3hiyetQ//slqTthyU/gOcJhJNeC8EMT7HjT1WjEJP2E95oycFDl1BEtPGhTrFsQPB6DtDjHvQ=
X-Received: by 2002:a05:6214:5d0c:b0:6f8:e66b:578e with SMTP id
 6a1803df08f44-704a70328d0mr215909776d6.32.1752514274721; Mon, 14 Jul 2025
 10:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation> <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org> <20250714165844.4hctlrwegfspiius@pali>
In-Reply-To: <20250714165844.4hctlrwegfspiius@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 14 Jul 2025 12:31:03 -0500
X-Gm-Features: Ac12FXyJKlWCdvZJ4yTBnDKpC_uW6aM04Gf_6hGmIItvlwzAZDiqush6GMbjknM
Message-ID: <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
Subject: Re: Samba support for creating special files (via reparse points)
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>, vl@samba.org, 
	samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> It does not matter if the client or server is POSIX or not. Also on
> POSIX systems there are filesystems without the support for special
> files and it is common scenario on more UNIX systems that for particular
> mount are special files completely disabled for security reasons.

If it is disabled for security reasons, then probably better to still
send the request and let the server return the correct return code
(e.g. access denied rather than "not supported").   But for Linux fs
the only examples I can think of where all special files are disabled
are VFAT and some pseudo-filesystems like /proc

On Mon, Jul 14, 2025 at 11:58=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > It's an oversight I'm afraid.
> > >
> > > hm... it seems reparse points support is mandatory for SMB3 POSIX so =
I
> > > wonder what this additional checks buys us.
>
> No. It is not mandatory. Getting or setting of reparse points is done
> via IOCTLs which are optional. Also fs attribute for reparse points is
> optional.
>
> And that make sense as there are still lot of filesystems which do not
> support reparse points (e.g. FAT) and this fs attribute is exactly what
> server announce for clients and applications to tell feature support.
> So application would know what features are provided and which not on
> particular share. Server can support reparse points on share A but does
> not have to support it on share B. E.g. when A is NTFS and B is FAT.
>
> > > While I agree that generally we should likely set this, for SMB3 POSI=
X
> > > the client should probably not check this and we should keep it out o=
f
> > > the spec.
> >
> > one additional thought: it seems like a valid scenario to be able to su=
pport
> > SMB3 POSIX on a server that does not support xattrs on the backing
> > filesystem and hence may not have a way of storing arbitrary reparse po=
ints.
>
> xattrs and reparse points are two completely different things, and they
> should not be mixed or exchanged.
>
> For example FAT on older Windows versions supported xattrs (I'm not sure
> if recent Windows version still support them), but does not and never
> supported reparse points.
>
> For checking if xattrs (in MS terminology called Extended Attributes or
> abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDED_ATTRIBUTES.
>
> Again, application can check if server share supports xattrs by this
> fs attribute and decide what to do next.
>
> > In SMB3 POSIX we're just using them as a wire transport, not necessaril=
y
> > expecting full support from the server.
> >
> > Hence, for Samba I see the following change
> >
> >     smbd: announce support for FILE_SUPPORTS_REPARSE_POINTS if the shar=
e
> > supports EAs
>
> FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) !=3D FILE_SUPPORTS_REPARSE=
_POINTS (0x80)
>
> > ---
> >  source3/smbd/vfs.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > index 76895f52e039..ea3fa4c8784f 100644
> > --- a/source3/smbd/vfs.c
> > +++ b/source3/smbd/vfs.c
> > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(struct
> > connection_struct *conn,
> >         if (lp_nt_acl_support(SNUM(conn))) {
> >                 caps |=3D FILE_PERSISTENT_ACLS;
> >         }
> > +       if (lp_ea_support(SNUM(conn))) {
> > +               caps |=3D FILE_SUPPORTS_REPARSE_POINTS;
> > +       }
> >
> >         caps |=3D lp_parm_int(SNUM(conn), "share", "fake_fscaps", 0);
> >
> > https://gitlab.com/samba-team/samba/-/merge_requests/4104
> >
> > For the client this would mean, it must allow reparse points for the sp=
ecial
> > files if SMB3 POSIX is negotiated.
> >
> > Makes sense?
> >
> > -slow
>
> I do not think that this is a good idea at all. It would just complicate
> things, make more incompatibilities and prevent using FAT or any other
> filesystem without mknod support, including cases when server itself is
> configured to not support mknod for e.g. security reasons.
>
> FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute which says if the
> reparse point of any type are supported. If it was decided that special
> files, like fifos or character devices are represented as reparse points
> then for share/filesystem on which are special files supported, server
> has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
>
> And if the server itself supports special files, but particular
> filesystem like FAT does not support it, then server should not announce
> the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
>
> This is how it was designed and how it is used.
>
> It does not matter if the client or server is POSIX or not. Also on
> POSIX systems there are filesystems without the support for special
> files and it is common scenario on more UNIX systems that for particular
> mount are special files completely disabled for security reasons.
>
>
> So the result is that also when POSIX extensions are negotiated, it is
> important and required to know by POSIX client whether particular
> exported share supports reparse points / special files or not.
> And FILE_SUPPORTS_REPARSE_POINTS is already there for it.



--=20
Thanks,

Steve
