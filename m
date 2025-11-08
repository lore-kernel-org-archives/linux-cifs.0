Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D870F1A262A
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 04:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762576664; cv=none; b=EjevuQfWl30zaiAEJkYtVNlmZAoUfxnmG/JpZU2kxPNkDG/j8enH0MXn0ongVtkA9pHXNC+tdzHSHDYOJwu7CgaznVrjEgzG9GwAw135lPBSt/JL1ZaFE5hYpEBP/PmCrrPbzBJnYj/S+zFRsbo+exGgLb65P+aXfqY7H8ZcDKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762576664; c=relaxed/simple;
	bh=eLraf8FnW47yTxroFlhzJ1U9czGxv2PN4l/nHj3JSNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VfEs5ZA0N56KJT9y88NAJz2xm1bae6Shi1Z4uvXDupdnniFgHn4QR8vkqRZg//I+NhqR5YCivsF3/+YM7UBhtiPnnWjIrV5s3XQacDCpLtrEWmJ2X/EuUgx1nFPlqrjW1Wrh8ngp1afycAcchoomZo+VWlCU40eB+Hl31JIkbtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYfYf0HM; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYfYf0HM"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b472842981fso181749266b.1
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 20:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762576661; x=1763181461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6KLcC9Dx8BV8ZlTNUqU1ioG2cskDrJt3lJvdWPoSCY=;
        b=WYfYf0HMt3wnUWQnAlcXqdwz/rSReqPdSQv/i2eAkUhb1MVWQVVVxtRdLooYooEb/U
         JUiIcW6PFsASE4wu4+PaZ7C9obftP/1moFxsKrvPkUzTgg1aGihFKTXtAFHDGr2chHy4
         dXTofmet3JJu0wuO6Kmbx9ZYbHNZJlHU6CtRib1liR9fbe1FGPKUyKNCaIXb1C+FuIfg
         LhuJFmDBivzTeS++b2jgG7FsBDRbj4EY4cv5qZGDY6Y4WpdcfxdXCTLtgpAesQdFUkKN
         fUs6gq7GlOT6+Ytm2UGrmRpeF3d/Lk2iG+/WWhHv6yERale7l6wDUnWy6pgjEHRLsUNc
         HiYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762576661; x=1763181461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H6KLcC9Dx8BV8ZlTNUqU1ioG2cskDrJt3lJvdWPoSCY=;
        b=fvJ0h7GlfkeT7Lc/O8qUUazr7x4DYuj4u7vEgqavFE8UUf2WASLunb4T+P0Cetw0c4
         Z8+XodLzZjT8E17wkGl4SGlXCy+OguCuinegVzw3B82UOyssrpqz2JyNhQXWUtdErYUY
         EOBT+vkWF2g/loPqULERaJQefGOnpmJpJ8l0hjGgUcW2Qoq1zy2q0S+BSWrJgMdPsjBR
         DrL4FUb9uhiUOmHUWZ6NtutYQPR748Vb5oBE47go66g8dmEohRnufJ6FKBla3VU2fTXm
         CN99im1j0j2bnO52a7A0kNN7kneRdobwkvkHRa7Tk9SVZsD3kARCmorXU8nF7/qMcDo3
         E41Q==
X-Forwarded-Encrypted: i=1; AJvYcCVU+WHNTa/kPhLSCiNkbZWyZUFG3JxahdL98H0AsmJdj5njo2VIw4CNP3Yae0Rsw1n0AUsn9AMhm91p@vger.kernel.org
X-Gm-Message-State: AOJu0YwpqPFMmUuVGclHhfwVa/czZgZRIKVRR5a03DSgX4BB28l7lZbL
	PaJCbaxa+mN80SqftxOJHcZdN69z1X/z0kUh0Yx5vAfGgorJnhtK+IXlyVnHEjPXRKD9lJXqByV
	jxG1lZNENdUES21gm62DVDqcvyA/GhSWvISeV
X-Gm-Gg: ASbGncslWvI8OZFT0Xfje7/q1Pn6XOb5acvT7Tf1cDEEcHkPoekZOnVBXgTqOKoCpUN
	qoZi3YdDwelI5uj/3nhNOVQYyBY8WLJkdFH8WlIvcObANLncj5QQ3CeSqTv9W4NkDnzgWLkQcsi
	OI/dogmfz5maaL1w/sRnesQAFSAwbQkMVn8Af3FDrfmQ/sfX4JGZ0x8ytOaEyymlZ0X63Qp6r4/
	AzrpGpV+74/9TJ5Pl4LvQ3MSt3WX1yaFnTnBPV3RW/6qJOKXwscbbrJEaE=
X-Google-Smtp-Source: AGHT+IFUOYrLUjrCzhLUZre+v6Aa6zfSgpAO4H/Sa1EvhIkcpBMMwXynhux90SF7ym9IAId8uEW/McesBeE+VjgIC5I=
X-Received: by 2002:a17:906:794b:b0:b72:5734:9fd3 with SMTP id
 a640c23a62f3a-b72e05626b1mr169599366b.32.1762576661108; Fri, 07 Nov 2025
 20:37:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtLBAwfk7YbgRkCnA4S7uNyiTGs7kDssa697pci=rCYDw@mail.gmail.com>
 <ONR9GWFvdJx39b1jAUTFBGjhqlY1LgZhwHECF_OroUZSCW0dGQHjcNSBDtiLfxdP1-Ly3UufUTo17bw5Kea5LTglBll2vZjWw9V8aGnMKvg=@joshua.hu>
 <CAH2r5mvcOwmJjSyewm06uyEfXKsfdEWS9ZYgr3aiD-ia+XF2Qg@mail.gmail.com>
In-Reply-To: <CAH2r5mvcOwmJjSyewm06uyEfXKsfdEWS9ZYgr3aiD-ia+XF2Qg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 8 Nov 2025 10:07:29 +0530
X-Gm-Features: AWmQ_bnAzeAV8cXMrG46l165Or5ZKqBnl4yPFEx9P82OTC9TG2Ce3WlQKu2uTmY
Message-ID: <CANT5p=rLO8t6aHPO3qMKXzVOVuN3HPtUo0rGuHh0PFBbcRSfOA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: validate change notify buffer before copy
To: Steve French <smfrench@gmail.com>
Cc: Joshua Rogers <reszta@joshua.hu>, CIFS <linux-cifs@vger.kernel.org>, 
	Joshua Rogers <linux@joshua.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 10:01=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Added mention of it in the description (see below).  Let me know if
> that is incorrect.   Interesting that I don't see other kernel patches
> noting that interesting sounding tool (yet)
>
>     smb: client: validate change notify buffer before copy
>
>     SMB2_change_notify called smb2_validate_iov() but ignored the return
>     code, then kmemdup()ed using server provided OutputBufferOffset/Lengt=
h.
>
>     Check the return of smb2_validate_iov() and bail out on error.
>
>     Discovered with help from the ZeroPath security tooling.
>
>     Signed-off-by: Joshua Rogers <linux@joshua.hu>
>     Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>     Cc: stable@vger.kernel.org
>     Fixes: e3e9463414f61 ("smb3: improve SMB3 change notification support=
")
>     Signed-off-by: Steve French <stfrench@microsoft.com>
>
> On Fri, Nov 7, 2025 at 9:22=E2=80=AFAM Joshua Rogers <reszta@joshua.hu> w=
rote:
> >
> > Is it possible to slightly change the commit msg to include "Found with=
 ZeroPath"? As this bug was, indeed, found with a tool called ZeroPath.
> >
> > Thank you.
> >
> >
> > On Friday, 7 November 2025 at 11:23, Steve French <smfrench@gmail.com> =
wrote:
> >
> > >
> > >
> > > SMB2_change_notify called smb2_validate_iov() but ignored the return
> > > code, then kmemdup()ed using server provided OutputBufferOffset/Lengt=
h.
> > >
> > > Check the return of smb2_validate_iov() and bail out on error.
> > >
> > > See attached (lightly updated to fix checkpatch warnings from Joshua'=
s
> > > original patch)
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
>
Looks good to me.

--=20
Regards,
Shyam
