Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53255405F7
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771180280; cv=pass; b=AdwJkwFz+9s7jzpbGUjsIrwnwUl+YFEPGZp6WGrEX787I8lPTSF4k/BQdC5dG88BvBtvtkskM7xxevjLyZlnVYSIaOnklLJ9zlauiB1Pv9G1tk8WdZO4ukZpg3UE3lTCCiSUsenqkUrga3EEA0ZSUKTSJdGLk9LsoA8+8DvV92I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771180280; c=relaxed/simple;
	bh=ErWBm5CL7YSkGZXzXcC+RRCLZvynOX20MPjQy1/jDi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o9bBi4HTpQetmncASvV49nHPf+noCGXxH6ageTxgnGPeHwvuuCCJZUzguTffi+JhX1zT8dYE/4P6QIIJKFtyf3QXBwnYpjGo0+bwyBOlAGzWqAz4y3CnE1joQx1l5bzXGuiwaRZxYJLKyvFxKVeo3QapBoXjYYfS9DBWspT5obw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OMiMXDLM; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OMiMXDLM"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb20bcff5aso259748685a.3
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 10:31:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771180278; cv=none;
        d=google.com; s=arc-20240605;
        b=QSq/c0wOyUVwMvCNytWb7xixxnhJtFEwvGbGqv2LsaG4TfvNtaaMOOXZJz7R0fHmlP
         NrQ2+nhbErrXSNTnVwFY6UhC2mVRusujdvqJmGgCaYQB2Jg8c2vQZ5QNduXdU7eKkfyh
         o5ACiBtXP/iBuWU8HgHQWL6F/TsEsqI+lUlP5072Z1XtHE/ESweOHqtaeYe263vdssCp
         9VRkVdk57VseVW16HVAtO9NRcB7gOiEdzVBk86AFGOzuH1FvR93ervsri6dvg4cHgc5z
         8QtANPBuFPq9pu+aIklpTMPAwfFiGqk7N1HREOnoA3Yz/ozgsFbsDHtmuDR6jeFdz8Mm
         LfIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xn9OAhwKNy5uqb7ZYDomvzXJwrhCH2LkxjnVjiYpnhE=;
        fh=/tZ910HZ3HlTzDVf/by/4iKXr3tLzGJu/HACYrJHxso=;
        b=Wi2ziJE0/QZ6Ju6+xGg6Vpf+rxTjthqJqWXLscvQ2101n/SW8dLeWd8wVbmCw4PnCu
         rGSTETGrbwHjPkIdc0XMt+Zb/8BADsqgQfeZlG8XO4xaZFrzhZuyCF8xPHwkM19s0xoW
         9IgXW8mmqfoxAcM74NobgCPekQCsblBtKOMWsAakwys9YERuCOa927StvLgo8YRRgSba
         hvlQlNVgGQ3LpdmJs3BAxT+0/v4l/qZu37jivmx0oFJJquLkbucNiI3LN+WUBi3aEa4U
         ZiCeJLw/2ooSht0ZIDNqEduDsuwM5hMREs3pHt/+Dn7yWytWJXaJMMWht6x7DNfR8WW/
         fqyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771180278; x=1771785078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xn9OAhwKNy5uqb7ZYDomvzXJwrhCH2LkxjnVjiYpnhE=;
        b=OMiMXDLMYLevKI0vIwldGt9XW3A/Wg/Gl+vbT0YyZkHofszdum5hUkfo9JtJZdBrWw
         7BSob4HcBWuVBj4UtMyvTNYRzis2Qe/IX5OV4/+CRnKnRecvVT6UfwrAcjtjPazdE8F/
         C+oSHmOe9Mc/jkAL/cdHcxYRy1hEO8y73iW6VhunT54Cy7w7ntZ9mEEKRAZQxZ6M/Ocq
         HUcwCGfkgV0YNbzxyDgRneyWYBJKzpEpNUo+lLw5ey5CCrRoShcfZQS9NmlmhU8Z47A/
         qIQWqQz3k8h+AFxYVOkx0pW/AY56iVtrljyOWzWCbAkotPZSS8h80TOStAngpVNywREW
         0Xrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771180278; x=1771785078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xn9OAhwKNy5uqb7ZYDomvzXJwrhCH2LkxjnVjiYpnhE=;
        b=gu0SqZnr4rcd3xi1GH5D2b7TuLE9q5k+J3KlPhjnOG3Un3tB4V3woLD0yeyOaXfAgr
         v3OE+BdX416khDJqko59VhHVvIB4jHplxHO1lnS+h6PQVNhSG+k0laxSENGX22Gzr/3f
         3M3umq6rzIISI0Jhidj92QOTkrU8AYtR2qBoqnaR36NKTNeNVxPfTfXZV2mmjWjh4GYY
         Y+fz8VQSyjgJrclUyhZlqgMso6STpYCu5tGxnRos/MFOrK3IsHyL4yTNtSR9/OB6e8rK
         549Wukk995q2KvbL6D7H51aoLSfPZhGIoMMGw5co9iZAW/MPF+u+yrAt82hT18d0+Wfg
         /A/w==
X-Forwarded-Encrypted: i=1; AJvYcCXARoobBeDubu+/kwR/KB+3XeNvsp4OED6ylk0pyjGYnZn3Xm7gsovlKX6eZETM3h+thLn+NU5H0How@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv/3rApROi5sC2S61+fgKpDVEJG/2CdPBlSCXdggeOu5sGXfN8
	Gqc9AymYunm7XSD7rr7q9X3HlfF+8ZhiHiBCCA46RgrOOtPSxRCmVhNBFmocKJPdEz2qz2io4yh
	4leiBQ2j7KeQheUIyY+17u0q77L8QWPZh+Q==
X-Gm-Gg: AZuq6aL+GoS1avEZGOXvrz+inoOAvXTm/yCVMt8dPU1eBnU7XuLvOpoIfkAqUfBvTIW
	JZAc0Xs90qKUAnPdhkqfka2+bG5CL04DD/c5lMPjUT55T7zvuewTKKO8b60CsBKMNhZEw1M3Hp2
	gQsdWuB4G9AkQDoW7s8l8C4Vd4RTtjU5ogXM4w7QzuXwMYSuVOps0qG3ICj+Fy4obkAcCrGSWNh
	6nKdLiUMq5X/Y0JGjLx+mJ2blmF0NiLXdbUmKExIrOWUHRDmmX05qM6U0VlNobBDc1zgLHgybJx
	dN4N3pN6vmHd3BAFcsWTYJOyw4mbUQsPWpxuZNmYRqYYw2KWV641qvr30QgxsrfARfMBYgWbk8Q
	o7BFltu3GCnYzp/fJeHXmj8nzx51cBRtl8aUmHzKB5aGUPBmztLCDP3nSz7t6c9mYSRL7lIKp5M
	H6Toz5urKzALIwiSyyYKME
X-Received: by 2002:a05:622a:28c:b0:4f0:24e2:8de6 with SMTP id
 d75a77b69052e-506a83452e3mr110216511cf.64.1771180278158; Sun, 15 Feb 2026
 10:31:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205010012.2011764-1-aadityakansal390@gmail.com> <b36e2732-0678-48c4-a50e-58512b4d9f6c@gmail.com>
In-Reply-To: <b36e2732-0678-48c4-a50e-58512b4d9f6c@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 15 Feb 2026 12:31:06 -0600
X-Gm-Features: AaiRm51J8BTnL10dTK4N7QNSOVRielLPpLr0-CEdslzYNNSSoiPBG0FlX-Spobw
Message-ID: <CAH2r5mt+608DDhj93Fa55PZ_-1yfJZTa5v4LQ-D48V9ZYPDJUA@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: terminate session upon failed client
 required signing
To: Aaditya Kansal <aadityakansal390@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2026 at 7:17=E2=80=AFAM Aaditya Kansal
<aadityakansal390@gmail.com> wrote:
>
>
>
> On 2/5/26 06:30, Aaditya Kansal wrote:
> > Currently, when smb signature verification fails, the behaviour is to l=
og
> > the failure without any action to terminate the session.
> >
> > Call cifs_reconnect() when client required signature verification fails=
.
> > Otherwise, log the error without reconnecting.
> >
> > Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> > ---
> > Changes in v2:
> > - reconnect only triggered when client required signature verification =
fails
> > ---
> >  fs/smb/client/cifstransport.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstranspor=
t.c
> > index 28d1cee90625..6c1fbf0bef6d 100644
> > --- a/fs/smb/client/cifstransport.c
> > +++ b/fs/smb/client/cifstransport.c
> > @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, struc=
t TCP_Server_Info *server,
> >
> >               iov[0].iov_base =3D mid->resp_buf;
> >               iov[0].iov_len =3D len;
> > -             /* FIXME: add code to kill session */
> > +
> >               rc =3D cifs_verify_signature(&rqst, server,
> >                                          mid->sequence_number);
> > -             if (rc)
> > +             if (rc) {
> >                       cifs_server_dbg(VFS, "SMB signature verification =
returned error =3D %d\n",
> >                                rc);
> > +
> > +                     if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)) =
{
> > +                             cifs_reconnect(server, true);
> > +                             return rc;
> > +                     }
> > +             }
> >       }
> >
> >       /* BB special case reconnect tid and uid here? */
> Hi, I am writing this as a ping for this patch. Thanks

merged into cifs-2.6.git for-next but had to rebase it to merge into
current code.

Have you verified the behavior of default (smb3.1.1) mounts as well?

--=20
Thanks,

Steve
