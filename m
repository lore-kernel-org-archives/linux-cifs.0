Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996F1C2F2
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 03:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747195152; cv=none; b=fpqMom0sRtr28ftpY1Hz1jkZcSh7zxdFurNf5gdwJma9uFsRtjITvwTDE9c390UJ8VHTFLq2U0ZxzBnas6bnI29ymWL0kJkPanRgMbQlCIdJIJm+AryFMd0YVzeaR8Viw9DZkYw+WCxFCh65pp2LIOp+nOEhGN/qQX6GjeBPB7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747195152; c=relaxed/simple;
	bh=ZIhLhABD83f+unST5NpB4wfJJQrvgpbSl2iYB9VD5VM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KlaqeswitYFN0mPnVY4l32R6UNeYm3N0Pj0OmgEh4Gfdlrf7CawYNegaPMj1jTwF6NjAWVdsEzLF7/OAjZhMw5D/50neNptgezC0SJSJzP6cXKlQpYvbOmclDFAew+tq4hdUCkGPP1Pt+g5UcA/u/T06z+LEjnIf2kXKpRS9zRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZNBogHKl; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZNBogHKl"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-54fd1650b83so4302362e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 13 May 2025 20:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747195149; x=1747799949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIhLhABD83f+unST5NpB4wfJJQrvgpbSl2iYB9VD5VM=;
        b=ZNBogHKlDLOZzcVJn8CLz+fNUDGsh0FxE6m2gyzN++2OOMakGmCVMWxySIufAGJ03W
         L2AdCQAkaQdM1BhtCXt+ExTqzRQRvQJ96XM0lrOqcmW+qPRpErFfBEoRrttOkr029tCw
         Y7Af3pbe/3XNZJ8Df79vsPRqPBhxlpWU+U1RB53eXkp4dk6+jxGQQcr/5Tsek8XVfyvz
         PTUMLcpic9TpeOXMENzPSR2+0bf9QItxj2KjTMWgOUgZkwIkIeAlVBO46MwKUbsUNdz8
         OTeBmkQqY7D6AI2U5m0XBkzObKOgg4N0ojGwV6SRSMpPEQydW4Pr0o/m14D2TjkzaQ+D
         glAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747195149; x=1747799949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZIhLhABD83f+unST5NpB4wfJJQrvgpbSl2iYB9VD5VM=;
        b=WxsLB+9xdyGmiGuVWK9hTMrsfsJxUq/9873i+K4yRxsDnifpCXokNrtaSNzhERiVU8
         JDNu7dPsTmxydgoZJBXFbcDhjDAoN7++deBxerlnSh5IfhVXIN6LgM1NPmbY2THawnsQ
         uzqwrRNJwra1hXdHEIvsaIasJiGG/dmfH6hayOayUN+7ObbKdITG26Y/tseZbosokp6y
         0qLKK5CKERzLB9k2vOcUB38fEkF13iunUZJBbA5xrosvEZJ9dFA/atrbCNoHMZuSq+59
         9JAdFnWJk9MgdHwmu0CT9f86ssoCYwInYsxCI3aGJblVJ/07KoeWi5NvQoeq6iybjN8v
         a6nQ==
X-Gm-Message-State: AOJu0Yx3ukwtwk7IKv+UOfeOXSGTopw7OFNg7ajZnFb1QiAuD6wUsEL5
	XwcG1gLyMRfo7ggcNeGKKZmQxLi/QtewdR2WFy38ohV3HQwBAoTcchTXhNfoi/q76J2nUtb9js5
	u6cXovtlZoFHJNkXeHyZwp5hFq8E=
X-Gm-Gg: ASbGncu8kwiTbfgHPP4q3ZJTfxh+UbDAzbg4h7vUW3ODexVN5fxU4z4iDT2Z2fd4ce8
	c5OlQFvuWXtLJF8cT8uceqc0TbHVAkDU2S32+hT7HN33z+7TyihSfgSEYCXRgSuxZ+N63A9BCNg
	WJwOalL8QSWP5DwdBvxPjFTfmGTw6+jJuYiayz0eOR4Q51hykp3ptSoW5/GoJjcLZ1hSYzIsBUI
	fzqfg==
X-Google-Smtp-Source: AGHT+IFaJAguwFn5KOQQO/JKEnGGyow/fJbRLrGa2ug96fRtNSRQ4k9tcEaiwKIibz7PkWy7mBbz/yU5bbbIa3RKpuc=
X-Received: by 2002:a05:651c:1502:b0:307:9555:dc5e with SMTP id
 38308e7fff4ca-327ed0a1499mr6108221fa.3.1747195148383; Tue, 13 May 2025
 20:59:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALMA0xaVdk3qwkb-92QqF2+6z+=oxbBWDR1hYEoE2WUc7jVGkw@mail.gmail.com>
 <CAH2r5mvLwetOfEnoKLaEjsKbgzM_i54L2=9eq1q5oSAbitG4nQ@mail.gmail.com> <CALMA0xYFaOP3QGDUPQwxeEi=jG-B6QdXOU9Y9LekKNnMiYy8qg@mail.gmail.com>
In-Reply-To: <CALMA0xYFaOP3QGDUPQwxeEi=jG-B6QdXOU9Y9LekKNnMiYy8qg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 13 May 2025 22:58:57 -0500
X-Gm-Features: AX0GCFuzz5nEgMRE2JZt55yPqzegZyVaxHpagOVEBMmqrTuTkKwPaovyBO-UQJM
Message-ID: <CAH2r5ms4X4vRkqOcBAPZs8Wn21pk1V+Pt_u9_bypw2ziOjMG_g@mail.gmail.com>
Subject: Re: [PATCH] getcifsacl, setcifsacl: use <libgen.h> for basename
To: Zhixu Liu <zhixu.liu@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-utils and smb3-utils repos pending additional testing/revi=
ew

On Mon, May 12, 2025 at 9:15=E2=80=AFPM Zhixu Liu <zhixu.liu@gmail.com> wro=
te:
>
> cifscreds: use <libgen.h> for basename
>
> fix another implicit declaration of function 'basename' in musl
>
> On Sat, May 3, 2025 at 1:18=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
> >
> > merged into cifs-utils for-next (and smb3-utils for-next in github as w=
ell)
> >
> > On Fri, May 2, 2025 at 10:27=E2=80=AFAM Zhixu Liu <zhixu.liu@gmail.com>=
 wrote:
> > >
> > > basename() is defined in <libgen.h> only in musl, while glibc defines=
 it
> > > in <string.h> too, which is not standard behavior.
> > >
> > > please see attachment for the patch, thanks.
> > > --
> > > Z. Liu
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Z. Liu



--=20
Thanks,

Steve
