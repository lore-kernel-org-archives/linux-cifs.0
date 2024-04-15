Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880982897
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191860; cv=none; b=B3uQFo7EQ6lyT0zVW2SUtcJFBHbqK1SPgeZaOBE5+D0/1AhFoYJImOVAoaskQZCohRvtjzf8VavP1II+nlHoE6DokDJD+lw2VLFOxcPfdqOqCWWr8mdV5PdTSdc5ZD4i4BWHdT0K1/QnatfXmCdW1xVLfovOSBoEQOKpfkjFedw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191860; c=relaxed/simple;
	bh=QpitrI4m4SSpuBQzWmpZincm0RndiUiH+YSB+2tVc84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rV9HlmciQUgr7I2t4dMLyYfIthuiY/L/R4cnKE+i2EfHiEBRrQX5UUfZd+GJUPK0z7eqyj8A/MVA3ZKjUxIdygUp96sBly2njPqsQ4nCN2W+0h7Cgi1XUA7lAOIFNnQqdJfsEcGXXMzlbnTDt96t2D3jQpu7WX4zo5rAd3KF33w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UoaXBles; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UoaXBles"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-516d2600569so4064600e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 07:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713191857; x=1713796657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wbs9qVkkGGMY81GIgZjIRjXaABmFteXtLrGaTrRO98=;
        b=UoaXBlesLBrkZfbU7vPVYT5ZNRQOXF3/Iqdf2TO4jM3PpomER7EfxThvCN0UrDkcCl
         34bytw/ZcPyhBD7WCpbOXSVRtPk+1OYBKXHpFiM7haBHcWR6UUM6egvS5lzog3SIQSAq
         b5X30DiJw4/l5bEKPvgBS9arhVDMHjXzdfGz+grwZu+2h2FJvx1q8At5GUoN6SHXXr3r
         RkRtH0vzio9JtCoZbv8Y04v3GrgdrdWbdwGmIOKu0dZ1RCUmc6lZjysZ4LHHRmWwXk1N
         EpmSdnPQHmXkgdo4W/Pd4TLzG8seZyoqLej4hRe/1c/hzpEYUnHNDbSBQl3GYph84zXM
         z0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713191857; x=1713796657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wbs9qVkkGGMY81GIgZjIRjXaABmFteXtLrGaTrRO98=;
        b=M/JxNdWPC+VFVr5ynbxTGDtxxTOANYNw+5ymabSfoR/gnU+d0feM1XPHgFBfzodwAa
         uRmTG8zFCYZu9L38elmKxolFQuErOpqLpJVnFLsuZlHtSh/AKIpoMZyVjEFNx8eHF2Xy
         zt0y40yscRdrUbVWvmhVjCwkgVVBy0LakPkIPJz0Refil3lNbNDoO/QWAB9+xJm8r/5z
         tx7rn2cMSe6/GSHFLH43bj5fXlhJcYm+ZLMR0LMATGqBkjzQicqHwzHQbS7iUxclD9xi
         Doujflfp8FDKz5jNADddxo9Ux/cDzZtFVupdUhuA6PCNnwMgD0kU16OIHJEbAu5hsQd/
         BU9A==
X-Forwarded-Encrypted: i=1; AJvYcCXfOBtcG4paY7oc0w3/dfPRo5lldgHotlhxQF0N7R+oMBfBxrd5cl07Rz5vkgQLAQEw48D0LsGtv/4VpzDsBr4Lt+U3R4/qWdGkrA==
X-Gm-Message-State: AOJu0Yw9vSPGReJdJhqVA8wd31TE6WqfaUmKuYueoAwclmQfF3YMAixn
	NnX++LYB0hfZax12MVfQxgLMAH4O6TEyKXON8dWUupeuv68AofbHUr2ztwVbonf8KW24smOvEdC
	8UdyX9Q7wwkcSQTS7roHIyliqBojh6Uu9
X-Google-Smtp-Source: AGHT+IHaRGFSrfBAsW0xcksvOEOo/ImscHiqewHwM8xN7Bl2iO+IzkXGmSTAXmHI2n0UOqPy9PLkFdzsw4L3kpoUEzw=
X-Received: by 2002:a05:6512:2fc:b0:517:8e01:2668 with SMTP id
 m28-20020a05651202fc00b005178e012668mr6824654lfq.67.1713191856994; Mon, 15
 Apr 2024 07:37:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6127852.nNyiNAGI2d@nimes> <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
 <7050532.CnaeKSotiK@nimes> <c71f4bd1-b3b6-7862-d5e3-ee30ae174d45@draigBrady.com>
In-Reply-To: <c71f4bd1-b3b6-7862-d5e3-ee30ae174d45@draigBrady.com>
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Date: Mon, 15 Apr 2024 16:37:25 +0200
Message-ID: <CAHpGcMJL6rngGunfAfCet9S4eqQ8TE6xgHPwhWx9KA=Ef0aW2w@mail.gmail.com>
Subject: Re: bug#70214: 'install' fails to copy regular file to autofs/cifs,
 due to ACL or xattr handling
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>
Cc: Bruno Haible <bruno@clisp.org>, 70214@debbugs.gnu.org, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Am So., 14. Apr. 2024 um 00:43 Uhr schrieb P=C3=A1draig Brady <P@draigbrady=
.com>:
> On 13/04/2024 20:29, Bruno Haible wrote:
> > Hi P=C3=A1draig,
> >
> > I wrote:
> >>> 5) The same thing with 'cp -a' succeeds:
> >>>
> >>> $ build-sparc64/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
> >>> 0
> >>> $ build-sparc64-no-acl/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo=
 $?
> >>> 0
> >
> > You wrote:
> >> The psuedo code that install(1) uses is:
> >>
> >> copy_reg()
> >>     if (x->set_mode) /* install */
> >>       set_acl(dest, x->mode /* 600 */)
> >>         ctx->acl =3D acl_from_mode ( /* 600 */)
> >>         acl_set_fd (ctx->acl) /* fails EACCES */
> >>         if (! acls_set)
> >>            must_chmod =3D true;
> >>         if (must_chmod)
> >>           saved_errno =3D EACCES;
> >>           chmod (ctx->mode /* 600 */)
> >>           if (save_errno)
> >>             return -1;
> >
> > And, for comparison, what is the pseudo-code that 'cp -a' uses?
> > I would guess that there must be a relevant difference between both.
>
> The cp pseudo code is:
>
> copy_reg()
>    if (preserve_xattr)
>      copy_attr()
>        ret =3D attr_copy_fd()
>        if (ret =3D=3D -1 && require_preserve_xattr /*false*/)
>          return failure;
>    if (preserve_mode)
>      copy_acl()
>        qcopy_acl()
>          #if USE_XATTR /* true */
>            fchmod() /* chmod before setting ACLs as doing after may reset=
 */
>            return attr_copy_fd() /* successful if no ACLs in source */
>          #endif
>
> If however you add ACLs in the source, you induce a similar failure:
>
> $ setfacl -m u:nobody:r /var/tmp/foo3942
> $ src/cp -a /var/tmp/foo3942 foo3942; echo $?
> src/cp: preserving permissions for =E2=80=98foo3942=E2=80=99: Permission =
denied
> 1
>
> The corresponding strace is:
>
> fchmod(4, 0100640)                      =3D 0
> flistxattr(3, NULL, 0)                  =3D 24
> flistxattr(3, "system.posix_acl_access\0", 24) =3D 24
> fgetxattr(3, "system.posix_acl_access", NULL, 0) =3D 44
> fgetxattr(3, "system.posix_acl_access", "\2\0...\4", 44) =3D 44
> fsetxattr(4, "system.posix_acl_access", "\2\0...\4", 44, 0) =3D -1 EACCES=
 (Permission denied)

Why does CIFS think EACCES is an appropriate error to return here? The
fchmod() succeeds, so changing the file permissions via fsetxattr()
should really succeed as well.

Thanks,
Andreas
