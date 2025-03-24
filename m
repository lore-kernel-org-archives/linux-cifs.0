Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDFE26159A
	for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742836681; cv=none; b=d27MLg+qDwyZCRsIqpcb7W8NXIKXiI0BIR2V377vPUS26ZMJoX1OBJgBng/Q0Ttm62eCDdNd/WG3lYaaRDHVK06XgNS2yh21Zf6QOCWUs317SJJ2U7m45f5+fmxoIAjQfMT/09REY9KXJja7n438yf0k455QwvaZJndnVp1WiaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742836681; c=relaxed/simple;
	bh=xsyOfn5fKLq83W1krCJEz0KehmW3XdTh686BnGCbRmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r6XQL3Qsrpkn/lfWME5b3dfHFzAZ0M/69JM9cx4DK9/DhHwZpJPMokxZiOjgreIABxuHDc9hwHa0lNMVvkqo2AODjAXd9+hSLKxfmifydC/F1okiZqHQ9+B6RNvFIBeMejQqMN49+ajt4/13tpK9PeQMvSnxLY+ILBRnMDft8os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fZL73dLE; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZL73dLE"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-549946c5346so5049802e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 10:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742836678; x=1743441478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fN67jBvQkzxhyXu8jXo1NKowdZorK6/Q6OUt2cD0LEQ=;
        b=fZL73dLEgDpD9z1Jq2w5hO1akWeOL2nPyX6Ah9M7j8MZmQiptZo0dFbQIQZyS2Bcir
         rjVRk+8gCp3bJ7AvI4zXDsYPt1Vcuj+erCmVpgLBg2OhEnNQ49kMw8lLv/3qPwGHf0pX
         FvVRsAkChqQpgahuRyA74m2Kel3ENdbiFbB6WwGlt6+FN5OtXql3PdXcfzK7nPiFyJqk
         GK+zOmrnfu8dGGTge0m0W+NB96j/DMDUIp0jLzL4coR4y/mCWUh6YYQTSeuJljrFRQGf
         DVQb8h5r0bTBsPzvrkO0LoEOxSqweyk0X063JSb87XUpMKTzenF9LOU3axmKzTVFqkpP
         PzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742836678; x=1743441478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fN67jBvQkzxhyXu8jXo1NKowdZorK6/Q6OUt2cD0LEQ=;
        b=FEup9QHGgsnM8YxPY0yN5hhV6ojoSXoa11+g6awj4pfGbloPhMPh1kElKPw8Cp/neq
         EIr3liN4NW+5C9eCQlOP+eCxGKnmP7o6wqB2KNgFcO/JXmxRNKBkF1lgDH8P4rV+Gf8H
         UeoaFisvMl7sOFad8EWIWmkCT7pw/0eCRxZrxJUK+gErUhIY+VBD23f4CeQ04xVlhzNn
         Ay35xJTBKFKGATw+RsGuL6UcDIPH60MkUkVDsljxj5RkobdV19EPkRpTsg0JnSt0ifpG
         iEkQLJasbWBN56AjxSrKUEmnehctlX/r3D4XYtGWxMdtntKYrXi7f8vkTLSKUGHpsDEB
         zD3g==
X-Forwarded-Encrypted: i=1; AJvYcCXqLfrnNgIbbUVk6YD/bNOp530kNo344yedj/XVFgKXfGBHLOZnlBnMPJcbgD+ZnS/V1DfGwqbwuHpy@vger.kernel.org
X-Gm-Message-State: AOJu0YzOMlmjtfak1g6bmW5HrtbwhaMq7LWKQW+4739BbDVMfqHF3wwO
	m/R3zUmFFlnal59jpf10i/XGoiz5cz2gn8hGYTnDkKqkHTmlVeuW0zOWqkmeSjHF/GHbCnulz4d
	NL2OSq+n1WF+L0LiogHC4W1oipcK+W0XY
X-Gm-Gg: ASbGncuuIDujEgZxipY5QNIe8PbF8F9gl46+704gnjWkJUcYRgkfD48hARkoOrq/Y7b
	MY4/qumjPtpxETHcbsd4mZOS6gy3gBicY2P0nNkvbegyN4Mvu5LYADzuaPZBbapn2Y5cDUu2Mej
	WshsDXcdhRgI0rr/fI5Hb8Ur6X8gt6h3+YUdrvC7xLZ5WgQtooO42TCw7aVLoh
X-Google-Smtp-Source: AGHT+IGJnoo0qbgiuvWSiwGtmvdKRogM434kGUsu77rjwQuvERPOPKKE8aSa/1qoOAMBl0T/KIlPAdGfhl6H75qDypU=
X-Received: by 2002:a05:6512:2216:b0:549:39ca:13fc with SMTP id
 2adb3069b0e04-54ad650bb80mr5804562e87.49.1742836677643; Mon, 24 Mar 2025
 10:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali> <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali> <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
 <20250323103647.rsex63eilfdziqaj@pali> <02d5d5dccd2fa592baa2d16020d049cd@manguebit.com>
 <20250324082310.fbvnxo6cmuwv2clx@pali> <CAH2r5mvaM1y3xEL+yiFDMHRVZg2j48hwVaQa+BL8f+23Y7VwrQ@mail.gmail.com>
 <20250324170736.zcqqv3rv7ycjr4da@pali>
In-Reply-To: <20250324170736.zcqqv3rv7ycjr4da@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 24 Mar 2025 12:17:48 -0500
X-Gm-Features: AQ5f1JrGuirHG5Hxk4G6ZwClzC7K6_Vn4RXu5FvXjUaRNV1L_bdUNHh9FHgbGPU
Message-ID: <CAH2r5mvjL3-PqGqxbXrBKyR4DP++=2KjYj6Z-e5AqXNyB-yMog@mail.gmail.com>
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> I just wanted to be sure that we have not forgot for something

On that subject, given the business of the week (LSF/MM/Storage
summit) and merge window opening up, it is very possible we could miss
patches (and over 40 of yours to still rereview as well, and decide
what is safest to cherrypick of those) - so let me know if I have
missed critical patches.   There are some very urgent ones (e.g.
finding out why multichannel to ksmbd broke just before 6.13 kernel
came out) and the directory lease fixes (and perf improvements)

On Mon, Mar 24, 2025 at 12:07=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> On Monday 24 March 2025 10:33:06 Steve French wrote:
> > On Mon, Mar 24, 2025 at 3:23=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> > >
> > > On Sunday 23 March 2025 21:36:56 Paulo Alcantara wrote:
> > > > Pali Roh=C3=A1r <pali@kernel.org> writes:
> > > >
> > > > > Hello, I would like to ask, how you handled this regression? Have=
 you
> > > > > taken this my fix to address it? Or is it going to be addresses i=
n other
> > > > > way?
> > > >
> > > > It's already fixed in cifs-utils-7.2 by commit 8b4b6e459d2a
> > > > ("getcifsacl: fix return code check for getting full ACL").
> > >
> > > Ok, and into kernel is not going to be addressed that regression for
> > > older cifs-utils?
> >
> > I thought we had decided that it was risky to intentionally return the
> > wrong return code to
> > userspace, to workaround an app bug (especially since it is easier to u=
pdate
> > cifs-utils than update the kernel, and also since cifs-utils update to
> > 7.3 is strongly
> > encouraged for users due to multiple security issues fixed)
> >
> > --
> > Thanks,
> >
> > Steve
>
> Ok, fine. I just wanted to be sure that we have not forgot for something.



--=20
Thanks,

Steve
