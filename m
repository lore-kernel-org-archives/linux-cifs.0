Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F223BE
	for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 02:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739414811; cv=none; b=JshOpSwwtlM84u69Y6ov18sbSG+bfGIWJs+317j7hmaAcch5n3FAa+t2zxVNufMeUaWHgTV2tqvI8+BSDqc9YXslhRgOfDgsCIDYISsD3OI68ojGrxKxlD6MywozwgJB3eEcogTjkTJoWwNu7px/sDQAV8Au2oalIWrEMmhyiC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739414811; c=relaxed/simple;
	bh=iZqha4uH9T5jaJ3MsDjL1LZcHH5+5MuyLIk7ozQgi8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ClKMf4tKd/DUVamGF3tW9Gvi2UFcU8ezDHWCxg0mmx+vMymZ4H0izcDmZmTBhVMqJI1uKlOT6mEucuG11IbbCw/GNYJjnecqyBC0ziVFv9BGnsiUbQ48WgrvWvPfK8bZFWPjgQEsURgEXI5NGk2TjODZpkGDSi1LSzEBGDJC3fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMDFW34E; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMDFW34E"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5450622b325so324922e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 18:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739414807; x=1740019607; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eIei+y3G7pxbagfDLSWrf+hhrHioJ7Sl7XigvlgNmVk=;
        b=aMDFW34E5Rm1p5nP63pghttkFcPaeHWg2x+HSCtDFZ+xLoiteDZ/WuJVgcON3iQWv2
         ul3yztF0sXDSf89Wfhpnid0IhvAhhto4xtiB/1Xo2Eqs9b7rDF/R8emSla3FxjVKRufn
         brg+9CDWhijQrpVEAEMC9zsjYndC3cjek7BMyWvYIajt7mBfWdkReda2OU9h0/HHB+GW
         J168YsHu2mttRyyjAwFkDLlWZslBEbfLSschgaqFykpwfxn07n10RS40pIeDibKuWRL4
         pZpQDhsWOOwrRBNIWfKs4bWU2JkG8RSz/oTbxemc9HIcue4CTP/IPFH7scu4FpFqAX9y
         H0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739414807; x=1740019607;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eIei+y3G7pxbagfDLSWrf+hhrHioJ7Sl7XigvlgNmVk=;
        b=ULluTH1b1iISM4Ex1rqiOpL/u3VeJx+8ofA9s60S6s/orxgORMw5CHsUNGoIT6KGrJ
         O54bNhuxYOovyMS5SVbyeC3a5Vkdt8kuQ8f8RpQ8AuO/HsEXGaVRLQWpnt3ZydjwH2F4
         9WccZHhaGKYjjzpWoaHPaqW55XzngZNP7ylFMjV6ScEiN7Lb1XvAQA1kfdVaXf4dbe4L
         SVN8BL2MGa/hJE408fHMhlCqjIS+C8XL6QfkCdqhuchHCtqkmIm9iWSRt9m0fEiUS7Nb
         n7gn/2erM5wp3nh41uBwfVcT7f+XU9Cmr+W0o70bChehoi52iYfnf43RuGNfA0R33uUY
         QPMg==
X-Forwarded-Encrypted: i=1; AJvYcCUt7nWuo84DnnMyDbs6nmrg5tVBQDbR+mewyHgtk5vHVuxV4GFDlacdDidfIbqUbVP9IAbgHRB1N+qY@vger.kernel.org
X-Gm-Message-State: AOJu0YxN6tVYyHNQ8W+d8jbU9c8Y+7VRbFDWiTWIi88clCcLurq3RDyh
	KLoq4JhdMxcccuOqAUlmt2LwiDA965mCr1sFSAAoCZ4PtzhZ7/do9TUW0hIsgETksO2h3R0wzAT
	RtVpQAdKXzbuYsuLer/EtDufYjHo=
X-Gm-Gg: ASbGncv1+IgkTUT8JjhABUvRxospATTv9tYMGVUkdJrAHuU8KGmJxvtiGs+4Rk9ng2z
	rWRv3bMlJomjNCD8qU3RhiBTnxaZHMaAoMoeHGek/AQd8MQMUXVnf/fe8AQQBSYD+rtaR7MT2lQ
	==
X-Google-Smtp-Source: AGHT+IGc1piWFpGoRdX2grrYwEba3+Koaft3XQemObahTqDRlifjLxGqQJuO4dzcAoohEIBPiHnKQtlrBlXYNZ5CErY=
X-Received: by 2002:a05:6512:2244:b0:545:11fa:caf0 with SMTP id
 2adb3069b0e04-5451dd84c15mr421937e87.6.1739414806971; Wed, 12 Feb 2025
 18:46:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali> <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250212224330.g7wmpd225fripkit@pali> <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
 <CAH2r5mtzwOtokQjbX9NzzB6G==t5Wq3Xqz=-K+qqLuBnoKB15g@mail.gmail.com> <20250213000234.s5ugs57chvi7g7pa@pali>
In-Reply-To: <20250213000234.s5ugs57chvi7g7pa@pali>
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Feb 2025 20:46:35 -0600
X-Gm-Features: AWEUYZnnlp5WkkzUqTT836oxjqzMmQRn-LMKE_ZGvDC9OzhkrmxVOxrA9nhMP5Q
Message-ID: <CAH2r5mvvgoGvvgpBj09zCA1G=Heca3if8x41cuthmUxGTdNgRw@mail.gmail.com>
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000afebab062dfd113d"

--000000000000afebab062dfd113d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ok - how about this updated patch to getcifsacl?

Presumably the rc check for the getcifsacl retry is only needed by
more cifs-utils in last four years
due to this patch.

Author: Boris Protopopov <pboris@amazon.com>
Date:   Thu Nov 19 21:40:42 2020 +0000

    Extend cifs acl utilities to handle SACLs

    Extend getcifsacl/setcifsacl utilities to handle System ACLs (SACLs)
    in addition to Discretionary ACLs (DACLs). The SACL extensions depend
    on CIFS client support for system.cifs_ntsd_full extended attribute.

On Wed, Feb 12, 2025 at 6:02=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Wednesday 12 February 2025 17:47:19 Steve French wrote:
> > On Wed, Feb 12, 2025 at 4:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.c=
om> wrote:
> > >
> > > Pali Roh=C3=A1r <pali@kernel.org> writes:
> > >
> > > > On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> > > >> Pali Roh=C3=A1r <pali@kernel.org> writes:
> > > >>
> > > >> > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> > > >> >> Steve,
> > > >> >>
> > > >> >> The commit 438e2116d7bd ("cifs: Change translation of
> > > >> >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) b=
ecause it
> > > >> >> expects -EIO to be returned from getxattr(2) when the client ca=
n't read
> > > >> >> system.cifs_ntsd_full attribute and then fall back to system.ci=
fs_acl
> > > >> >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but=
 that's a
> > > >> >> different problem, though.
> > > >> >>
> > > >> >> Reproduced against samba-4.22 server.
> > > >> >
> > > >> > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> > > >> > translate -EPERM to -EIO. This will ensure that getcifsacl will =
work as
> > > >> > before as it would still see -EIO error.
> > > >>
> > > >> Sounds good.
> > > >>
> > > >> > But as discussed before, we need to distinguish between
> > > >> > privilege/permission error and other generic errors (access/io).
> > > >> > So I think that we need 438e2116d7bd commit.
> > > >>
> > > >> OK.
> > > >>
> > > >> > Based on linux-fsdevel discussion it is a good idea to distingui=
sh
> > > >> > between errors by mapping status codes to appropriate posix errn=
o, and
> > > >> > then updating linux syscall manpages.
> > > >>
> > > >> Either way, we shouldn't be leaking -EIO or -EPERM to userland fro=
m
> > > >> getxattr(2).  By looking at the man pages, -ENODATA seems to be th=
e
> > > >> appropriate error to return instead.
> > > >
> > > > It looks like there are missing error codes for getxattr. Because a=
ny
> > > > path based syscall can return -EACCES if trying to open path to whi=
ch
> > > > calling process does not have access.
> > > >
> > > > And EACCES is not mentioned nor documented in getxattr(2). Same app=
lies
> > > > for listxattr(2). Now I have tried listxattr() and it really return=
s
> > > > EACCES for /root/file called by nobody.
> > >
> > > Both man pages have this:
> > >
> > >         > In addition, the errors documented in stat(2) can also occu=
r.
> > >
> > > and stat(2) actually documents EACCES.
> > >
> > > > -EIO is generic I/O error. And I think that this error code could b=
e
> > > > returned by any I/O syscall when unknown I/O error occurs.
> > >
> > > Makes sense.
> > >
> > > > Returning -ENODATA for generic or unknown I/O error is a bad idea
> > > > because ENODATA (=3D ENOATTR) has already specific meaning when att=
ribute
> > > > does not exists at all (or process does not have access to it).
> > >
> > > You are right.
> > >
> > > > For me it makes sense to return -EIO and -EPERM by those syscalls. =
But
> > > > for getxattr() we cannot do it due that backward compatibility need=
ed by
> > > > getcifsacl application.
> > >
> > > -EACCES seems the correct one.  But yeah, we can't do it due to
> > >  getcifsacl(1) relying on -EIO.
> >
> > Since EIO is incorrect, we probably should fix getcifsacl ASAP so we
> > can start returning something more correct for this call e.g. -EACCESS
> > or -EPERM
> >
> > Since updating cifs-utils for newer kernels is relatively easy (and
> > the next version of cifs-utils has some security fixes so will be
> > easier to rollout), why don't we also change getcifsacl ASAP to handle
> > the correct rc to give us more freedom for cifs.ko to return the
> > correct error on newer kernels.  Thoughts about this change to
> > getcifsacl() function which would work with both old and newer kernels
> > with the rc mapping change?  Change to fix the cifs.ko mapping to EIO
> > could be delayed as well so cifs-utils with the updated check is
> > rolled out?!
>
> That should work too.
>
> Anyway, if I'm looking correctly at that getcifsacl.c code, it contains
> fallback from fetching SACL+DACL attribute (ATTRNAME_NTSD_FULL) to
> DACL-only attribute.
>
> And if the user does not have permission to access SACL then
> STATUS_PRIVILEGE_NOT_HELD is returned by the SMB server.
> STATUS_PRIVILEGE_NOT_HELD is being mapped to EPERM.
>
> So EACCES should not be needed there.
>
> If SMB server returns STATUS_ACCESS_DENIED (EACCES) then it means that
> user does not have access to path or DACL, and so fallback from
> SACL+DACL (ATTRNAME_NTSD_FULL) to DACL-only attribute is useless.
>
> > diff --git a/getcifsacl.c b/getcifsacl.c
> > index 123d11e..3c12789 100644
> > --- a/getcifsacl.c
> > +++ b/getcifsacl.c
> > @@ -447,7 +447,8 @@ getxattr:
> >                         free(attrval);
> >                         bufsize +=3D BUFSIZE;
> >                         goto cifsacl;
> > -               } else if (errno =3D=3D EIO && !(strcmp(attrname,
> > ATTRNAME_NTSD_FULL))) {
> > +               } else if (((errno =3D=3D EIO) || (errno =3D=3D EPERM) =
||
> > (errno =3D=3D EACCES)) &&
> > +                          !(strcmp(attrname, ATTRNAME_NTSD_FULL))) {
> >                         /*
> >                          * attempt to fetch SACL in addition to owner
> > and DACL via
> >                          * ATTRNAME_NTSD_FULL, fall back to owner/DACL =
via
> >
> >
> >
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

--000000000000afebab062dfd113d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-getcifsacl-fix-return-code-check-for-getting-full-AC.patch"
Content-Disposition: attachment; 
	filename="0001-getcifsacl-fix-return-code-check-for-getting-full-AC.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m72qjub70>
X-Attachment-Id: f_m72qjub70

RnJvbSA2YjFiZDFkNWY5NmZkNjRmYzY5N2NjZGU2NzFkNjM3OTljNzVlZDhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTIgRmViIDIwMjUgMjA6MjI6MDAgLTA2MDAKU3ViamVjdDogW1BBVENIXSBn
ZXRjaWZzYWNsOiBmaXggcmV0dXJuIGNvZGUgY2hlY2sgZm9yIGdldHRpbmcgZnVsbCBBQ0wKCk9s
ZGVyIGNsaWVudHMgaW5jb3JyZWN0bHkgbWFwcGVkIFNUQVRVU19QUklWSUxFR0VfTk9UX0hFTEQg
dG8KRUlPIGluc3RlYWQgb2YgRVBFUk0sIHNvIG1ha2Ugc3VyZSB3ZSBjaGVjayBmb3IgZWl0aGVy
IG9mIHRoZXNlIHJjCndoZW4gZGVjaWRpbmcgd2hldGhlciB0byBmYWxsIGJhY2sgdG8gcXVlcnlp
bmcganVzdCB0aGUgREFDTCAoYW5kCm93bmVyKSB3aGVuICBxdWVyeWluZyB0aGUgY29tcGxldGUg
QUNMIGluY2x1ZGluZyBTQUNMIChpZSBBdWRpdGluZwppbmZvcm1hdGlvbikgZmFpbHMgd2l0aCBp
bnN1ZmZpY2llbnQgcGVybWlzc2lvbnMuCgpDYzogQm9yaXMgUHJvdG9wb3BvdiA8cGJvcmlzQGFt
YXpvbi5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0
LmNvbT4KLS0tCiBnZXRjaWZzYWNsLmMgfCA1ICsrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2dldGNpZnNhY2wuYyBiL2dl
dGNpZnNhY2wuYwppbmRleCAxMjNkMTFlLi45NzQ3MWU5IDEwMDY0NAotLS0gYS9nZXRjaWZzYWNs
LmMKKysrIGIvZ2V0Y2lmc2FjbC5jCkBAIC00NDcsMTIgKzQ0NywxMyBAQCBnZXR4YXR0cjoKIAkJ
CWZyZWUoYXR0cnZhbCk7CiAJCQlidWZzaXplICs9IEJVRlNJWkU7CiAJCQlnb3RvIGNpZnNhY2w7
Ci0JCX0gZWxzZSBpZiAoZXJybm8gPT0gRUlPICYmICEoc3RyY21wKGF0dHJuYW1lLCBBVFRSTkFN
RV9OVFNEX0ZVTEwpKSkgeworCQl9IGVsc2UgaWYgKCgoZXJybm8gPT0gRUlPKSB8fCAoZXJybm8g
PT0gRVBFUk0pKSAmJgorCQkJICAgIShzdHJjbXAoYXR0cm5hbWUsIEFUVFJOQU1FX05UU0RfRlVM
TCkpKSB7CiAJCQkvKgogCQkJICogYXR0ZW1wdCB0byBmZXRjaCBTQUNMIGluIGFkZGl0aW9uIHRv
IG93bmVyIGFuZCBEQUNMIHZpYQogCQkJICogQVRUUk5BTUVfTlRTRF9GVUxMLCBmYWxsIGJhY2sg
dG8gb3duZXIvREFDTCB2aWEKIAkJCSAqIEFUVFJOQU1FX0FDTCBpZiBub3QgYWxsb3dlZAotCQkJ
ICogQ0lGUyBjbGllbnQgbWFwcyBTVEFUVVNfUFJJVklMRUdFX05PVF9IRUxEIHRvIEVJTworCQkJ
ICogT2xkZXIgQ0lGUyBjbGllbnQgbWFwcyBTVEFUVVNfUFJJVklMRUdFX05PVF9IRUxEIHRvIEVJ
TyBpbnN0ZWFkIG9mIEVQRVJNCiAJCQkgKi8KIAkJCWZwcmludGYoc3RkZXJyLCAiV0FSTklORzog
SW5zdWZmaWNpZW50IHByaXZpbGVkZ2VzIHRvIGZldGNoIFNBQ0wgZm9yICVzXG4iLAogCQkJCWZp
bGVuYW1lKTsKLS0gCjIuNDMuMAoK
--000000000000afebab062dfd113d--
