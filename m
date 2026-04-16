Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02503A4F32
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 11:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340751; cv=pass; b=Js71JhG4L40tP0tA0DXbz4JeH11x/rF44bZQN4oNKMcRxX4+U9mLm3OTyWGaKK3fD3WlLUhozAWIwcmMPlxT8K3glLbr6vN3KbOAJe/N4428WZJz6Nlk1pHiSOwmvJzpZF3iOO1pdtHpf5mSYnqVbEsjoClnY9XQDxhrwaMDCt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340751; c=relaxed/simple;
	bh=Bw7/eU46XNMmEAY5yaZoewjP327xtGOJwYlC+oEFeMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YWe3e+VDVJDTfm01QPUqXAs7RVyzqW+lKVaRY/Hf/eV6PNWMTWHvBIhm4oxhKnhvr7C8aP/c2ztSlCqltxtmu7bBvPxmsMaMhkcZncDB8MS58aR+eU39bajdJGyFuLaIo1oUp2BenMYwt80lce675DzYbudD9o+SoZ8NbQyDYto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yv/iJipA; arc=pass smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yv/iJipA"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-9568159ee07so2807624241.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 04:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776340749; cv=none;
        d=google.com; s=arc-20240605;
        b=bpiiaGKWIqA8uGk77qvC9Qk8+CpAiI+GKqRHVDkU7xYiHUwGF3TsG6aFm6sWPtY7pM
         WHc8tf74RoQeAPiS1FZwMCkIqOnckDZuzCeAdYClgTcqDmjLfz1bdgrf152dAhjK/JDA
         1DPt9Bk5hZn4Cu3Oagxomtj5qkGNwNIii+aqoDuRhQBvMxEqnuMKXklMO97LwCW5wliM
         pHw+RwsDhr+DzcF7dgGyI26mp4EowQh+pQ24+gVrzHNiRGl0KelbrUflJhpWNJ9Yy2fM
         zD0M/2K3k2muftPTSEC1cRvJXHhLzh7bzN+Od6QuueM1dvfCrjAR1MeTgSda2bfsWzlR
         yUeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JqYJ8R4iGWahwud4pP2JmsmCHvSHhoaPalUrCsDrudA=;
        fh=GjnxhxlgSyhLKJbsvzbFd+qDJFQni7Jz1eQbniyW1jc=;
        b=lSrD6/td/1tOwE8cM/6ksa0SsIVZyKwC6gxQp+8EX9dnZ1B5jjsXCMQ8Rv3rO7c3HL
         bHyAuNXeDvY9+ZKtsWhLboyFu9JHLSgFHMQFTOA+UbSwQCyX7NKh0tl3yhaB6aJPaoGM
         +zT8n+ZVg5z6n+Lj1OvxBOY8JaaL5HRLPz5AJdzDdCcr7vFERqq6igeHvZOwAEc/8Mj/
         cxD5ObipPDs1w/FBXlNNpngRUFzaVGTsBicw45FoPypjVZbSITStUsqVZAouctkshI29
         pYAd50qSrLqfxMDeenoiAPLh7NoqMoE1aLr3ylelH/HO9omjYEu2OHJNOeuzzz9dywex
         MLjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776340749; x=1776945549; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqYJ8R4iGWahwud4pP2JmsmCHvSHhoaPalUrCsDrudA=;
        b=Yv/iJipAA+nhsL4hM00ueWwDagedY8BECDRzHx12spLwNgoS8ZakY4zrK2dkiR6l2J
         mQ3pEXXlrCi9kMRBkZi2YHE6qORxLcsWe+D8l+wjDn8HWOrCtWjKCgf5gVQmenh2NByp
         MCPNQ/tGjC/7AKKVlE3P3sIa6vn80p3d3lTSYo8ONK1oz6WoMzmPVNtYluTYxoNlq/gl
         23amyKa5o+u6+Qji1591D7SZNcgKyeEHjHsrOnz+jlamox/cVrUC1NkqUB4QzAKYFrCI
         XYiMktKmpNaISctvSp/Zchtq++MLrF/hVgPWAelzahh5Lq/eJ/sH7+6gxH0vD3vgUtNt
         7D/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340749; x=1776945549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JqYJ8R4iGWahwud4pP2JmsmCHvSHhoaPalUrCsDrudA=;
        b=qKejwrajAGrKQ5fomn0Ln2zyXIpobumhI2MFV4lBRkUGAUHDgpzKtyHnQL7r5CO2Xd
         JZn4lgdhuSPeO9hEfmcjgdKK4QRVk28QGKZA8T+nDuBs0EdS+lOXbJ853Rre+QnAF/V8
         BivSLJhJL9CorPRfKTa4IJ9oZJ8KO3lcYU30Uy0BuqD9PhUfVeT5F2cfI2hALcgw6leA
         1wfTTCMPhUpvdPcQ6wFaHSe3LrQBl/8cCGhfEmn2ZXQun94Ap6RT1t/a/Vnia4a+onEF
         sOq8YzE7JZMwUZjsH5dlVLnyJxXU1PMEItI+6Bcx/Ylt10gi5Jj+HSARQI5CPzO89v/p
         bZnA==
X-Forwarded-Encrypted: i=1; AFNElJ8CbZjcZvknp6XFKoz/CMkwt2+5SR+LHnja0vQSPRpW9iCzPXfgxmD6/4txsi9ndUKNu1SqyIfknEll@vger.kernel.org
X-Gm-Message-State: AOJu0YykKZfVSzl9SlonGrVCCB7tUIfUJ8iMGNzBRJhpNkdOCuA7vUv5
	JPonD8XNBtwD+DkGPNfuokWNBwT0QbDewuC5imQUvXwv0qw4jGviaOF2cSFpveNlp1Mgosf+qiJ
	iXHWZmqtBik07emVHP+Rgm3buOnPKbBbIp3+lzQb9Pg==
X-Gm-Gg: AeBDieszNSj/Jx24c+TxQIvwbkelv21V42qorX2XesEEe21IHsEAnT+uohhtG5gQVqF
	ZPcRMfgVaSAyej21CxXFoXLvkFvQESfEncl+FUHWv+me6G5j2Ef4ThpdrRz9BoID6dnSYIfnchT
	UnBnEZsxlD1K8rNtYS+K7hcmwlKECKDtSJXU4fPkuR86GZ6oq2YZQtPHQn/ZuJauHzAqVMJkL25
	FE5CQENvqpih59E2M/1SfzBQpol/5FcSrPhXuU5lVDf5ypUcFNAzIkiT2GSmpH6Q3ujbuP09cmL
	BGjveFhlCd/lKX7u2Naq1snc2nHEiRjEiij8tnWkXQ==
X-Received: by 2002:a05:6102:6a94:b0:607:a3cb:4573 with SMTP id
 ada2fe7eead31-60a00c36c76mr12126981137.26.1776340748680; Thu, 16 Apr 2026
 04:59:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
 <20260328172314.45807-2-dorjoychy111@gmail.com> <2026-04-16-selfless-milky-wasps-shin-p6liRL@cyphar.com>
In-Reply-To: <2026-04-16-selfless-milky-wasps-shin-p6liRL@cyphar.com>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Thu, 16 Apr 2026 17:58:57 +0600
X-Gm-Features: AQROBzAEjiDzwaGAEKhFLRhObmxO2qMMzryZZhbLCURVPls0DvUuWHW8g_k7mMU
Message-ID: <CAFfO_h5kWCYszymaY=tPAbpU=PjLFxsND+CWSYtypN4iuW+qPw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] openat2: new OPENAT2_REGULAR flag support
To: Aleksa Sarai <cyphar@cyphar.com>, jlayton@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
	adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, davem@davemloft.net, andreas@gaisler.com, idryomov@gmail.com, 
	amarkuze@redhat.com, slava@dubeyko.com, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, shuah@kernel.org, miklos@szeredi.hu, 
	hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 5:41=E2=80=AFPM Aleksa Sarai <cyphar@cyphar.com> wr=
ote:
>
> On 2026-03-28, Dorjoy Chowdhury <dorjoychy111@gmail.com> wrote:
> > This flag indicates the path should be opened if it's a regular file.
> > This is useful to write secure programs that want to avoid being
> > tricked into opening device nodes with special semantics while thinking
> > they operate on regular files. This is a requested feature from the
> > uapi-group[1].
> >
> > A corresponding error code EFTYPE has been introduced. For example, if
> > openat2 is called on path /dev/null with OPENAT2_REGULAR in the flag
> > param, it will return -EFTYPE. EFTYPE is already used in BSD systems
> > like FreeBSD, macOS.
> >
> > When used in combination with O_CREAT, either the regular file is
> > created, or if the path already exists, it is opened if it's a regular
> > file. Otherwise, -EFTYPE is returned.
> >
> > When OPENAT2_REGULAR is combined with O_DIRECTORY, -EINVAL is returned
> > as it doesn't make sense to open a path that is both a directory and a
> > regular file.
> >
> > [1]: https://uapi-group.org/kernel-features/#ability-to-only-open-regul=
ar-files
> >
> > Signed-off-by: Dorjoy Chowdhury <dorjoychy111@gmail.com>
> > ---
>
> Aside from the nit below, feel free to take a
>
> Reviewed-by: Aleksa Sarai <aleksa@amutable.com>
>

Thanks for reviewing!

> > diff --git a/fs/open.c b/fs/open.c
> > index 681d405bc61e..a6f445f72181 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -960,7 +960,7 @@ static int do_dentry_open(struct file *f,
> >       if (f->f_mapping->a_ops && f->f_mapping->a_ops->direct_IO)
> >               f->f_mode |=3D FMODE_CAN_ODIRECT;
> >
> > -     f->f_flags &=3D ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
> > +     f->f_flags &=3D ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | OPENAT2=
_REGULAR);
>
> It's not clear to me why you dropped this, I didn't see a review
> mentioning it either. (General note: Ideally the cover letter changelog
> would mention who suggested a change in brackets after the changelog
> line so it's easier to track where a change might've come from.)
>

Thanks for the general note. I will keep that in mind.

The review was from Jeff Layton in v5
https://lore.kernel.org/linux-fsdevel/5fcc2a6e6d92dae0601c6b3b8faa8b2f83981=
afb.camel@kernel.org/
" 1. OPENAT2_REGULAR leaks into f_flags - do_dentry_open() strips
open-time-only flags (O_CREAT|O_EXCL|O_NOCTTY|O_TRUNC)
  but does not strip OPENAT2_REGULAR. When a regular file is
successfully opened via openat2() with this flag, the bit
  persists in file->f_flags and will be returned by fcntl(fd, F_GETFL)."

I think it makes sense to strip off as OPENAT2_REGULAR is an open time
only flag (like O_CREAT and the others already), right?

Regards,
Dorjoy
