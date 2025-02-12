Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E841FBC9C
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 23:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739404055; cv=none; b=Qy/9hoWtWhyrVnGyBCwoeFAVJ7U9KWD88XaDJzFQTDI7sRcfLWXpkaD2+0aNuhzvA+jjcHOxiKUwmqXu0gyqf48yYmw32ZD2DRTnj1g47eWupiQ6dSCl+4LttS0tk19pqKBI0lmJ1JNmXpXBve6aE8HNzHJ1JrP5uiF7sjFoEGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739404055; c=relaxed/simple;
	bh=aOAuSb15ntxLwAPA2gpQvv9ppWTEIJ3eLmgznIUjXoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DRTiFPYTbrkXln9eVbGFKHOYQCQ/2dlv0EJSA/oxS9s5wJwzBgV7FibOmm+MpcEYdShU8VEYIf+nzdPDVZXeXOY5l3+Lg5C96hlr8M3JeTF1rv42zKSP0hvgmyba/60MO7d+8/ujUhnrjOfHlvGgwArU3rUMzSuF3u33iFG2K5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WUc8IdK0; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WUc8IdK0"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5451d1d56a7so300631e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 15:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739404051; x=1740008851; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h9g2cp4o7vlcuavFPZ0nrSJO7M/sj84y7KfRUMWizrI=;
        b=WUc8IdK0zCD77jwS0w13TKEckCh7imRdA0P0lhKK7FBg6dk4lCpgtB7mGoHlVh8hoK
         XgYdDWLhOn6pL1rjU1GJhlRVS5vubrCaZ1TeWN5eTrFTqeD80ErX6R/P9fzsnXgsyOHM
         nxZyOhZiegDwlHM5Af9GlKix4pCiVRwmFWTRlymmJqeCJeRDL52+FYWSyydafZoiblaS
         TxSfvWsHvHyP3FmADtPoGSedfx5wOrqv146crq3dObVDMQ8DVhZVCYaYNwFBNUspJ+2e
         hylQVGeFgjb5p92OxvXiHVXm/GbPIrFx1WqaouXptWg+GN3a7U8rO4wPFJV+6Idh9Syc
         Rb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739404051; x=1740008851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h9g2cp4o7vlcuavFPZ0nrSJO7M/sj84y7KfRUMWizrI=;
        b=MrBGYFoRJWPIHbthRFTJAEg2N+matILxM6JwN8+VbCYnz6aJO6qpsAiddjge4Fe06o
         EtxPlvD+p7NvYb7Fctj0yvBrpRJ5LAZ/+8tD9IpZdmmNMuLgiB3kEPK3p7fxTt6Tmw5U
         rbX6rwzMg9dkJt1x/Z8GrzNw9i6kjq7kDNrtudwcvRvgdMinM+uIU7w8a8RSGmU/fDxF
         e+z+eFs5TdP4Qo5zy6Eb4H8ntahi92pdW1vSbPbDpePeVoku5rCC03c9SYTERNb7eA0H
         E2+3P9dwLx5AbAA5daBFvEp29JzO/o8TsM+jKtso8pKj0w/M+JK3i1p0GXLFJAl0dGCi
         robw==
X-Forwarded-Encrypted: i=1; AJvYcCXsh9v+LGiVNxhCYBkZyVmddMUNnzC4V7CViRWehoq3Gf7k8g+f6o6gNMUcAp6mRIuJ+rysu2DL853A@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh3BnfbbB9ttqwetd8nSxoVaO/t1n7AOwyanuR2/Am2+nakKHd
	sWN5e/Dr74hKML+8WAD6ng5fuG8HcY4GY08I+JKJTODUKLkrgvLFO/V5xcrXmDCkjbNQcoJu6RM
	gzwj522RrCWveG6apOjwTx2JyBDDYgqs4
X-Gm-Gg: ASbGncs6x20nUJVTkiP+B1AGZ4xWe0yvjQuH49cWpXQs/NaMnA0GKLPg4W6F7V/wZqc
	tl8P39XTIH7XcuOFPLNQv60G9Y49w/os7Dra9Euh5P6sbJNGTiChjmc+cWnEKsQxlKTpvpM2pHQ
	==
X-Google-Smtp-Source: AGHT+IFkHm3XFgMRSrLs3I4zgIMyPt6Fc/T5B1QoHwqopAbCZJeVXk7FnHxGZAbqR+rvzHbwbDsb9m9115YwHicsLS4=
X-Received: by 2002:a05:6512:10d2:b0:545:16ef:d5fa with SMTP id
 2adb3069b0e04-5451dfdbf37mr204885e87.12.1739404051086; Wed, 12 Feb 2025
 15:47:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali> <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250212224330.g7wmpd225fripkit@pali> <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
In-Reply-To: <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Feb 2025 17:47:19 -0600
X-Gm-Features: AWEUYZmWWVxTX8F6iP3NNQafIUf9s1axdUxaYmaTNsVmPFh_HETccwU5KljQfyo
Message-ID: <CAH2r5mtzwOtokQjbX9NzzB6G==t5Wq3Xqz=-K+qqLuBnoKB15g@mail.gmail.com>
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
To: Paulo Alcantara <pc@manguebit.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000962fa2062dfa907c"

--000000000000962fa2062dfa907c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 4:58=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Pali Roh=C3=A1r <pali@kernel.org> writes:
>
> > On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> >> Pali Roh=C3=A1r <pali@kernel.org> writes:
> >>
> >> > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> >> >> Steve,
> >> >>
> >> >> The commit 438e2116d7bd ("cifs: Change translation of
> >> >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) becau=
se it
> >> >> expects -EIO to be returned from getxattr(2) when the client can't =
read
> >> >> system.cifs_ntsd_full attribute and then fall back to system.cifs_a=
cl
> >> >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but tha=
t's a
> >> >> different problem, though.
> >> >>
> >> >> Reproduced against samba-4.22 server.
> >> >
> >> > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> >> > translate -EPERM to -EIO. This will ensure that getcifsacl will work=
 as
> >> > before as it would still see -EIO error.
> >>
> >> Sounds good.
> >>
> >> > But as discussed before, we need to distinguish between
> >> > privilege/permission error and other generic errors (access/io).
> >> > So I think that we need 438e2116d7bd commit.
> >>
> >> OK.
> >>
> >> > Based on linux-fsdevel discussion it is a good idea to distinguish
> >> > between errors by mapping status codes to appropriate posix errno, a=
nd
> >> > then updating linux syscall manpages.
> >>
> >> Either way, we shouldn't be leaking -EIO or -EPERM to userland from
> >> getxattr(2).  By looking at the man pages, -ENODATA seems to be the
> >> appropriate error to return instead.
> >
> > It looks like there are missing error codes for getxattr. Because any
> > path based syscall can return -EACCES if trying to open path to which
> > calling process does not have access.
> >
> > And EACCES is not mentioned nor documented in getxattr(2). Same applies
> > for listxattr(2). Now I have tried listxattr() and it really returns
> > EACCES for /root/file called by nobody.
>
> Both man pages have this:
>
>         > In addition, the errors documented in stat(2) can also occur.
>
> and stat(2) actually documents EACCES.
>
> > -EIO is generic I/O error. And I think that this error code could be
> > returned by any I/O syscall when unknown I/O error occurs.
>
> Makes sense.
>
> > Returning -ENODATA for generic or unknown I/O error is a bad idea
> > because ENODATA (=3D ENOATTR) has already specific meaning when attribu=
te
> > does not exists at all (or process does not have access to it).
>
> You are right.
>
> > For me it makes sense to return -EIO and -EPERM by those syscalls. But
> > for getxattr() we cannot do it due that backward compatibility needed b=
y
> > getcifsacl application.
>
> -EACCES seems the correct one.  But yeah, we can't do it due to
>  getcifsacl(1) relying on -EIO.

Since EIO is incorrect, we probably should fix getcifsacl ASAP so we
can start returning something more correct for this call e.g. -EACCESS
or -EPERM

Since updating cifs-utils for newer kernels is relatively easy (and
the next version of cifs-utils has some security fixes so will be
easier to rollout), why don't we also change getcifsacl ASAP to handle
the correct rc to give us more freedom for cifs.ko to return the
correct error on newer kernels.  Thoughts about this change to
getcifsacl() function which would work with both old and newer kernels
with the rc mapping change?  Change to fix the cifs.ko mapping to EIO
could be delayed as well so cifs-utils with the updated check is
rolled out?!

diff --git a/getcifsacl.c b/getcifsacl.c
index 123d11e..3c12789 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -447,7 +447,8 @@ getxattr:
                        free(attrval);
                        bufsize +=3D BUFSIZE;
                        goto cifsacl;
-               } else if (errno =3D=3D EIO && !(strcmp(attrname,
ATTRNAME_NTSD_FULL))) {
+               } else if (((errno =3D=3D EIO) || (errno =3D=3D EPERM) ||
(errno =3D=3D EACCES)) &&
+                          !(strcmp(attrname, ATTRNAME_NTSD_FULL))) {
                        /*
                         * attempt to fetch SACL in addition to owner
and DACL via
                         * ATTRNAME_NTSD_FULL, fall back to owner/DACL via



Thanks,

Steve

--000000000000962fa2062dfa907c
Content-Type: text/x-patch; charset="US-ASCII"; name="getcifsacl.diff"
Content-Disposition: attachment; filename="getcifsacl.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_m72k6yv50>
X-Attachment-Id: f_m72k6yv50

ZGlmZiAtLWdpdCBhL2dldGNpZnNhY2wuYyBiL2dldGNpZnNhY2wuYwppbmRleCAxMjNkMTFlLi5h
NTY2ZGQ3IDEwMDY0NAotLS0gYS9nZXRjaWZzYWNsLmMKKysrIGIvZ2V0Y2lmc2FjbC5jCkBAIC00
NDcsNyArNDQ3LDggQEAgZ2V0eGF0dHI6CiAJCQlmcmVlKGF0dHJ2YWwpOwogCQkJYnVmc2l6ZSAr
PSBCVUZTSVpFOwogCQkJZ290byBjaWZzYWNsOwotCQl9IGVsc2UgaWYgKGVycm5vID09IEVJTyAm
JiAhKHN0cmNtcChhdHRybmFtZSwgQVRUUk5BTUVfTlRTRF9GVUxMKSkpIHsKKwkJfSBlbHNlIGlm
ICgoKGVycm5vID09IEVJTykgfHwgKGVycm5vID09IEVQRVJNKSB8fCAoZXJybm8gPT0gRUFDQ0VT
KSkgJiYKKwkJCSAgICEoc3RyY21wKGF0dHJuYW1lLCBBVFRSTkFNRV9OVFNEX0ZVTEwpKSkgewog
CQkJLyoKIAkJCSAqIGF0dGVtcHQgdG8gZmV0Y2ggU0FDTCBpbiBhZGRpdGlvbiB0byBvd25lciBh
bmQgREFDTCB2aWEKIAkJCSAqIEFUVFJOQU1FX05UU0RfRlVMTCwgZmFsbCBiYWNrIHRvIG93bmVy
L0RBQ0wgdmlhCg==
--000000000000962fa2062dfa907c--
