Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8529248869
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752599285; cv=none; b=kF8AyoF0rKLnOw88h6fAY/Fo6LoZgAhyWjgY7DaFQxcugg7jPPuTRWS6Ibmz8gGoyAU5+vh4InBNrIV0RMyKL0dpupxqxi6BpnxexD6xHM8QqW+qMxoxStpRgCP6OTI24IatYxSFu5EgcDoxpyEyMVR4ieFjoIWAR0J7JNxvGME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752599285; c=relaxed/simple;
	bh=7P/gaeGnDb1RxtZFcbGdxChkkbqOyUQbjZO5pbcOEVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MO9UATGjjAHMQldXfWFeZ/oVqi/Rjy1u7xxjvy2Q8DKcCqb/LlViwWew24OK8koxCijSk1HDU9loDTe8TjPD6SddUwqsTo30NWR8zD05W2z8HcSO4lMMAXLvbncSxGx3ZD1NmrqVxsY7GGwpO5ogNGuJ2kk0S4ZMJXSwIiV7qKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TmsCzHzB; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TmsCzHzB"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4a5840ec53dso62677191cf.0
        for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 10:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752599283; x=1753204083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddvGN+rLSCBQUAL799t/0Ffiq8mPRK+5qqR1wncm+EI=;
        b=TmsCzHzBpJKx2pUq8hsuYDQbOqxZYNZVc/dTOKFyzAjp+S4hSQgeqdv/EXIDeibNyq
         SbbsJV1CryZPBIDrlrOsqSUJHrDnPHiyvHhGiMkXSKmFSllDDQnYoU4kwmuPo2aXJwzq
         IsoCioFHOh01K+ctXfl+g4sdGOdMMSll9F9BC2ly4peDwdmJ5+19Am2DGljsyz2RmgJX
         /5H184P/M10Us+rQobEjPswLFnt7Tn3Yi5hgdo0m9aXn20wxSMjp+T7r0lUfpfolkHsl
         bf+2RwTk3BjFd7UEKnFphCXtNgeDPxqGUN1MOJOTEgRHkOrBDsK3k/Co8lcVDABMXcsv
         mmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752599283; x=1753204083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddvGN+rLSCBQUAL799t/0Ffiq8mPRK+5qqR1wncm+EI=;
        b=Pw0fEUF47tzHkKgz/fqtRBEHOnLgxNx5eUKbB81s6xjJBHZwKU8voKD76BkPQTRIMh
         7/mJZN+2D8RrOyd8cGrGSkGyU8JH0VUSr6KXfeDzqhxYgmAzv2f3Z5VDzFoi5gsmo1eG
         uEvYshP6beDixUIb6/+pR1ZMI7u+MJ0QEBsmcs+Rd7ch++6Nq7c/chT0XxRl0MqesZUy
         Jw2Nb1+jyHc4skLFZt5a1PLWOPfKDgTkytNfFcWcYfUQw4Lo0ev0k1MjtSw7CATqsO0V
         OWghmKP+SR8wJO4BsTAp5e3JCZg4uHTXygXZDh5jZDPwDGLdpghwvFXu8QbNbWpIS14g
         G1nA==
X-Forwarded-Encrypted: i=1; AJvYcCXYZw5WbOFgTKXyyB/H3tSjgHq5gWIVtpATMZdp+VZMkU2Uc/1sLFlF2OlGFp0G3xjhzRB7nPYpBj7C@vger.kernel.org
X-Gm-Message-State: AOJu0Yw66P2AJMqveqXbPI7ZuTXvoGadCpmNgUSD9fBbD5Z7FagJ27sY
	RmGW+5Es/KVw3ODzCv6pYGjQ3VuDBPf8BkvaXpnsTDBgAheltPfpngHdx6fxTi0zK//ph0YvRmB
	wfYjmKXCZ7yzMZGAVLAnHnigvCj4VcgkhD3p7
X-Gm-Gg: ASbGncvng8VZZBWbYG6TMVFsRBaj+Zs3URaGBLvuhpC+syCc6d+6I3hftgpAHT1nZ2a
	U+d4L3wWxVcg0OW9SMhX0uA9zW7qyi1So4ZlZsYj9adcGQc4pK5OAvA4X6myHfFWiGjKgWFN64P
	9KXLHTaYRgp2R98cOyTr/q1A8QtXtMIQexTBLQkuh6Z0JuvJ3DSx1IhwgQj1q/baEXrO5J+3uvY
	OqwJszRRmMCUHjZS4lmdVd56NxcaH8Rv31Jb1mG
X-Google-Smtp-Source: AGHT+IGl18I8wSFRg3pzRlBSgUHj9cFx4GWI7KnJMg7FAehUJNVUPaIuFGfzfMqufKMlUoPBG6ooDPpOj4RueskEI2Q=
X-Received: by 2002:ac8:5a46:0:b0:4ab:77c2:af0a with SMTP id
 d75a77b69052e-4ab9098125bmr4072941cf.3.1752599281951; Tue, 15 Jul 2025
 10:08:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation> <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org> <20250714165844.4hctlrwegfspiius@pali>
 <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
 <20250714192404.j3dw6l3afgm2voe6@pali> <CAH2r5msRGGHyy0GdNgVYBVN+8NzfevDS-wtzr9TO5jF5NmoxHQ@mail.gmail.com>
 <20250714211016.zqddwjdvybeplgdf@pali> <CAH2r5mumdvhWTNOCEGV-dT8aQVJrUQEDep0GEBn_CbKF+o3kjQ@mail.gmail.com>
 <20250715080911.julhkkcf7an56q4w@pali>
In-Reply-To: <20250715080911.julhkkcf7an56q4w@pali>
From: Steve French <smfrench@gmail.com>
Date: Tue, 15 Jul 2025 12:07:50 -0500
X-Gm-Features: Ac12FXyeXBmUa92csKI2DTxG4hKOJy0Ry1bLetfgXTDsn4Y7zWlUyqakK7-dMHY
Message-ID: <CAH2r5mvAuffmNwgJZ=n3m4aj4Xn45unK1ENPEdL_=pG-S3XHCw@mail.gmail.com>
Subject: Re: Samba support for creating special files (via reparse points)
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>, 
	samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2025 at 3:09=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Monday 14 July 2025 22:28:45 Steve French wrote:
> > On Mon, Jul 14, 2025 at 4:10=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> > >
> > > On Monday 14 July 2025 15:30:26 Steve French wrote:
> > > > > But generally this is not Linux centric, but rather generic to an=
y other
> > > > implementations.
> > > >
> > > >
> > > > If they are supporting the SMB311 Linux Extensions why wouldn't the=
y want
> > > > to support special files? All of the servers which currently suppor=
t the
> > > > extensions do
> > > > Thanks,
> > >
> > > Because of that possible filesystem limitation (like fat or proc or f=
use).
> >
> > That is a moot point because even if the mount has FAT or FUSE mounts
> > under it, the server can still support reparse points on that share.  A=
 share
> > often crosses fs type boundaries, so it is always going to be possible =
to
> > setup a share where creating special files will work for only some of t=
he
> > subdirectories - but at least for those cases with the suggested change
> > we will return a more accurate return code (e.g. EACCES in some cases)
>
> That is not fully truth. Crossing a mount point in mounted SMB share is
> signaled by the new mount point over SMB and so the SMB client is
> interpreting it like a new share and reading fs attributes for that

That does not look correct.
I just tried this to Samba (mounting to the root of my laptop, and cd into
various subdirectories on various mounts with fs) and none of them triggere=
d
query fs information.

> crossed path. Linux SMB client is already doing it and correctly handles
> crossed mount points. It also shows crosses in the "mount" output.

Looking at mount output I see no difference after crossing multiple
mount points under the same share, no automounts were created eg
and nothing new shows up in /proc/fs/cifs/DebugData or /proc/mounts

> > > > Steve
> > > >
> > > > On Mon, Jul 14, 2025, 2:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.=
org> wrote:
> > > >
> > > > > On Monday 14 July 2025 12:31:03 Steve French wrote:
> > > > > > > It does not matter if the client or server is POSIX or not. A=
lso on
> > > > > > > POSIX systems there are filesystems without the support for s=
pecial
> > > > > > > files and it is common scenario on more UNIX systems that for
> > > > > particular
> > > > > > > mount are special files completely disabled for security reas=
ons.
> > > > > >
> > > > > > If it is disabled for security reasons, then probably better to=
 still
> > > > > > send the request and let the server return the correct return c=
ode
> > > > > > (e.g. access denied rather than "not supported").   But for Lin=
ux fs
> > > > > > the only examples I can think of where all special files are di=
sabled
> > > > > > are VFAT and some pseudo-filesystems like /proc
> > > > >
> > > > > In case it is disabled for security reasons and server wants to a=
nnounce
> > > > > that it is "available but disabled for security reasons" rather t=
han
> > > > > "not support at all", then yes it makes sense to send the request=
 and
> > > > > let it fail with ACCESS error with all those cleanup related issu=
es.
> > > > > But in this case server should announce the support that it is av=
ailable
> > > > > for clients.
> > > > >
> > > > > In Linux it is not only VFAT. It is also slightly modern exfat. A=
nd also
> > > > > whatever is connected over fuse to userspace.
> > > > >
> > > > > But generally this is not Linux centric, but rather generic to an=
y other
> > > > > implementations.
> > > > >
> > > > > > On Mon, Jul 14, 2025 at 11:58=E2=80=AFAM Pali Roh=C3=A1r <pali@=
kernel.org> wrote:
> > > > > > >
> > > > > > > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > > > > > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > > > > > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > > > > > > It's an oversight I'm afraid.
> > > > > > > > >
> > > > > > > > > hm... it seems reparse points support is mandatory for SM=
B3 POSIX
> > > > > so I
> > > > > > > > > wonder what this additional checks buys us.
> > > > > > >
> > > > > > > No. It is not mandatory. Getting or setting of reparse points=
 is done
> > > > > > > via IOCTLs which are optional. Also fs attribute for reparse =
points is
> > > > > > > optional.
> > > > > > >
> > > > > > > And that make sense as there are still lot of filesystems whi=
ch do not
> > > > > > > support reparse points (e.g. FAT) and this fs attribute is ex=
actly what
> > > > > > > server announce for clients and applications to tell feature =
support.
> > > > > > > So application would know what features are provided and whic=
h not on
> > > > > > > particular share. Server can support reparse points on share =
A but does
> > > > > > > not have to support it on share B. E.g. when A is NTFS and B =
is FAT.
> > > > > > >
> > > > > > > > > While I agree that generally we should likely set this, f=
or SMB3
> > > > > POSIX
> > > > > > > > > the client should probably not check this and we should k=
eep it
> > > > > out of
> > > > > > > > > the spec.
> > > > > > > >
> > > > > > > > one additional thought: it seems like a valid scenario to b=
e able to
> > > > > support
> > > > > > > > SMB3 POSIX on a server that does not support xattrs on the =
backing
> > > > > > > > filesystem and hence may not have a way of storing arbitrar=
y reparse
> > > > > points.
> > > > > > >
> > > > > > > xattrs and reparse points are two completely different things=
, and they
> > > > > > > should not be mixed or exchanged.
> > > > > > >
> > > > > > > For example FAT on older Windows versions supported xattrs (I=
'm not
> > > > > sure
> > > > > > > if recent Windows version still support them), but does not a=
nd never
> > > > > > > supported reparse points.
> > > > > > >
> > > > > > > For checking if xattrs (in MS terminology called Extended Att=
ributes or
> > > > > > > abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDED_AT=
TRIBUTES.
> > > > > > >
> > > > > > > Again, application can check if server share supports xattrs =
by this
> > > > > > > fs attribute and decide what to do next.
> > > > > > >
> > > > > > > > In SMB3 POSIX we're just using them as a wire transport, no=
t
> > > > > necessarily
> > > > > > > > expecting full support from the server.
> > > > > > > >
> > > > > > > > Hence, for Samba I see the following change
> > > > > > > >
> > > > > > > >     smbd: announce support for FILE_SUPPORTS_REPARSE_POINTS=
 if the
> > > > > share
> > > > > > > > supports EAs
> > > > > > >
> > > > > > > FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) !=3D
> > > > > FILE_SUPPORTS_REPARSE_POINTS (0x80)
> > > > > > >
> > > > > > > > ---
> > > > > > > >  source3/smbd/vfs.c | 3 +++
> > > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > > > > > > > index 76895f52e039..ea3fa4c8784f 100644
> > > > > > > > --- a/source3/smbd/vfs.c
> > > > > > > > +++ b/source3/smbd/vfs.c
> > > > > > > > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(stru=
ct
> > > > > > > > connection_struct *conn,
> > > > > > > >         if (lp_nt_acl_support(SNUM(conn))) {
> > > > > > > >                 caps |=3D FILE_PERSISTENT_ACLS;
> > > > > > > >         }
> > > > > > > > +       if (lp_ea_support(SNUM(conn))) {
> > > > > > > > +               caps |=3D FILE_SUPPORTS_REPARSE_POINTS;
> > > > > > > > +       }
> > > > > > > >
> > > > > > > >         caps |=3D lp_parm_int(SNUM(conn), "share", "fake_fs=
caps", 0);
> > > > > > > >
> > > > > > > > https://gitlab.com/samba-team/samba/-/merge_requests/4104
> > > > > > > >
> > > > > > > > For the client this would mean, it must allow reparse point=
s for the
> > > > > special
> > > > > > > > files if SMB3 POSIX is negotiated.
> > > > > > > >
> > > > > > > > Makes sense?
> > > > > > > >
> > > > > > > > -slow
> > > > > > >
> > > > > > > I do not think that this is a good idea at all. It would just
> > > > > complicate
> > > > > > > things, make more incompatibilities and prevent using FAT or =
any other
> > > > > > > filesystem without mknod support, including cases when server=
 itself is
> > > > > > > configured to not support mknod for e.g. security reasons.
> > > > > > >
> > > > > > > FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute which =
says if
> > > > > the
> > > > > > > reparse point of any type are supported. If it was decided th=
at special
> > > > > > > files, like fifos or character devices are represented as rep=
arse
> > > > > points
> > > > > > > then for share/filesystem on which are special files supporte=
d, server
> > > > > > > has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attribute=
.
> > > > > > >
> > > > > > > And if the server itself supports special files, but particul=
ar
> > > > > > > filesystem like FAT does not support it, then server should n=
ot
> > > > > announce
> > > > > > > the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > > > >
> > > > > > > This is how it was designed and how it is used.
> > > > > > >
> > > > > > > It does not matter if the client or server is POSIX or not. A=
lso on
> > > > > > > POSIX systems there are filesystems without the support for s=
pecial
> > > > > > > files and it is common scenario on more UNIX systems that for
> > > > > particular
> > > > > > > mount are special files completely disabled for security reas=
ons.
> > > > > > >
> > > > > > >
> > > > > > > So the result is that also when POSIX extensions are negotiat=
ed, it is
> > > > > > > important and required to know by POSIX client whether partic=
ular
> > > > > > > exported share supports reparse points / special files or not=
.
> > > > > > > And FILE_SUPPORTS_REPARSE_POINTS is already there for it.
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > > >
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
