Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4354262A6
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 02:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775009009; cv=pass; b=s6AtG07ajeS0I4mBzum/MW9MeCCz82voqhGMTySzOGE8gh3I39TkIM05GTs5fadpu3JQinQSSG1f5X25/G8dhXUQmItjJmRwksxzNZozVEquQnC9/yhtx8y8IraIJ1F4rmQ88qBg3kmaOHFGPHk2MPNteXKQiyhwKBucij4C2Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775009009; c=relaxed/simple;
	bh=bkq4RJvRpdOkYigdy1BNCZbiY0QSPiawTZRFjMzYhLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rge1hTnvAa2fyrNFGTB5aXt0XUezvwuxUMqIk6JMQITUImOy/bIdFr3pCE72tv8DGR7bQvixwhDuugSGRbJjQ2/oDCzsQitChoIv3sKgb8xkEcPhWSC0mBRo/0ii/u82adHJh/hU1CN3HUC+MGxRRWaWiLSd2MTb+zSt9GHoizU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4DEfysm; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4DEfysm"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a05c388b27so33387276d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 19:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775009007; cv=none;
        d=google.com; s=arc-20240605;
        b=EnKzd9IgZIg3aKFnJ345zrrfIVW3eEfUGXOICh6Infj+BCJQIKb8uxUiRaE6DBzubt
         pWvJY/uUlYBhpmL2yUrWQ+Db1J8JyKiAz9S3lX/gwa3mlrDELusGxSn7yxyMD4+MwBIr
         4zDeAqLggN7G8KLU5C0DIm/rcKsGtms+GCdTrgwR38T5NWImI6oUQigXYfJTISASoFK0
         j2VtmbnVBpHt1lM6EpRnyRx32tdmWAETsapnHn9a43CHA8wA47vgfDTd/FiQki1T65ze
         6/Kt658LRsFiW+ID+gLaXIMa+1TCvu6P1ZN38/SfKFxvf3vYfeXkkinlYJidPJUZrFyL
         E0mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wba8BQ5iBpRLr0k7eoQQztZkAbyDnpsTrBKn6QloPdk=;
        fh=vRNBWFAgmJneg5/L0xNXSNEPpclt8jjSgYn2oPgQ700=;
        b=Xy+THJIbD0f91uGnGQ1vPxexyiG8MGm6ys6rnJH60kP00/jSip7RtBzAz59IGgJdZU
         GhNvawTZztuMVUIJXky3lKvTyXtj2j8shZlPWgZEQCPRMBPU48Rx4Q3CMypBsHQilH+8
         y3JHjQaAQr7H8PCrA5U+TVrf4rfwmkjajg0fhWZDtwPY0Nobi/CiR4gNu7m/8k+sScta
         Gzr9PNkpTpPOkXz9HGS2M90L5kHF4FqxmB/KLE+07MAMieGHkhT5EFUIh2FyiC1y/rWB
         Npg1YENeL9y0f25yB+j/Mq0csCAPDnhv7AwC2bv8X+f+GB2KKEE97anUknWxaN/LXjfH
         qSWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775009007; x=1775613807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wba8BQ5iBpRLr0k7eoQQztZkAbyDnpsTrBKn6QloPdk=;
        b=e4DEfysm+P+tRlknWSR0Ay8AJrrhxBSmTfN7muoh2fSRPSmKYHGLlVppZMAyi7E5Hc
         btWR992xBhprqxPLQbgDGx8vPijSjK1xisByqIMkAqf4RwzVKk4EeFpl+tZ26gWZLm60
         PzE7Nsuufr+d5pMeHgF5uJ32G7fsKmPpLid9hRyKlqs/SjiBRpLKL5l+6/IXwRb4mOH+
         3mvLPLO1a3KR+VpjQ6LkKo2cTv6UQAvPVFqihoP40aqtDQHvmmlU49GAYjbjfNQZJzG9
         mu9gsmHVLBUvvuDzGNfLAMZHYxuycGJ3ugLYDwkmHSlQj27yp9UEGbHyi8dGfglR7Gx9
         aAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775009007; x=1775613807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wba8BQ5iBpRLr0k7eoQQztZkAbyDnpsTrBKn6QloPdk=;
        b=l/vaizgDUBCOM65R92SCcXzJQe7Q9k/pFLuehS+D0T3IYUQoay4zwocPWRo1Y3VS0N
         xhS1SPGgXDWTp+XwNVcIuhV4KC9FX7h7b2MWuLO8gpfBEl3SV5Jc6I7U6pofTY3i/+TW
         YbbtLknEmQ8xgk2bQFucaObEPiUgGQvobpXEVZWzUd6NNv39ivBc4bi/pBzjmng2Eefm
         RAXUmkmkk8grB/lkqykfohToPEKwt7U4Hi3Sav8YMsMcinXW/CLZ8Q/CHz2h1htm85M3
         APdQqISUNC9LeYV/YJn/KXWtFGM93T80jxNI9d+fCtmj8B4i1E9bKiMKFUBndPIvQtY4
         hKHw==
X-Gm-Message-State: AOJu0YxBNgHNsGQJIiDbQTVm3a5pNLFV0EX29d8SeVTmOQ7uGhxSuXCN
	tDv20lh/0sHWQ3ArmVDrVYKrfRDLB/m5YKo1ZVM+mzcrFN3yPc6C84GTjEwu9kGdU7+RiHz+16j
	u57Llzo5x0sp66dfzDAC0zIWBUrx3xxU=
X-Gm-Gg: ATEYQzzKuhYCBY4led4WWa2UPWidfw2+KbTx6CdIIOA2avzM+EYpZZlfUBpvWSdBQTo
	U0biWpf3w/iLq1Eo6uLL88Js+JmGWYzgcyO3pTXccI/PMeV/Ic08zzDdHPx4Z5y3xUj+6y39X05
	Q0U4dtMC572ohi24IuvjF5bGPtyCNUtbjOS00ZelCEdnxAdS5NgGCW646gwBHf9bk2b2IPAeGBB
	apHdfL6hEwbGpdhYrxPLH8el4q7T5x3i8zODBybBZncTkMdottbgEfURHBvfbh0RhBH2m2zJoJJ
	S3HmZBmF0cu9msNzRfb3HpAH29vthq0lHhQEfoPPEdsamv01XDVjEgrfH6CnTiwd4Qo0ZzQi5Ij
	ncJ3yBwS5apJrurGxnM5vOFs3eC5xcp3J1G/ZhiOOr+iXiKpIPShma6YFMqVfQIUb2bnMq7/Ze0
	XkrVfeMmRxmr5SGYQ0mBKw
X-Received: by 2002:ad4:5bec:0:b0:899:fc48:4e68 with SMTP id
 6a1803df08f44-8a436f15162mr27021716d6.4.1775009006728; Tue, 31 Mar 2026
 19:03:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260331000911.16062-1-ddiss@suse.de> <CAH2r5mu56K0Ew8XHaVEsGK9KgxHv34WN5EkXTKUvFtxydFp9zQ@mail.gmail.com>
 <20260401115824.447004b8.ddiss@suse.de>
In-Reply-To: <20260401115824.447004b8.ddiss@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Tue, 31 Mar 2026 21:03:15 -0500
X-Gm-Features: AQROBzAb8JEvLX-PRxa8sW63ZEGKDOXr5_cV5b-YJRUodLKr0jgKP_zV8bRahj8
Message-ID: <CAH2r5mvzMVcjiRsK353Q0JNAN6E2pW+qe5XnQbOs8+PGpbe50w@mail.gmail.com>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
To: David Disseldorp <ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, Bruno Bierbaumer <bruno@bierbaumer.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.  Fixed the RB tag

On Tue, Mar 31, 2026 at 7:58=E2=80=AFPM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> On Tue, 31 Mar 2026 18:56:05 -0500, Steve French wrote:
>
> > added RB from Henrique and updated
> > git.samba.org/data/git/cifs-utils.git and
> > https://github.com/smfrench/smb3-utils for-next
>
> Thanks Steve. FWIW, the reviewed-by tag has an incorrect email address:
>   Reviewed-by: Henrique Carvalho <[2]henrique.carvalho@suse.com>
> Should be
>   Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> I'll close the corresponding PR at
> https://github.com/smfrench/smb3-utils/pull/16
>
> Cheers, David
>
> > On Mon, Mar 30, 2026 at 7:10=E2=80=AFPM David Disseldorp <ddiss@suse.de=
> wrote:
> > >
> > > The existing (j > pass_length) check is insufficient to avoid dst buf=
fer
> > > overrun into the start of the adjacent struct parsed_mount_info field=
.
> > > Check for overrun before writing to dst, and account for comma-expans=
ion
> > > and null-termination.
> > >
> > > Bug: https://bugzilla.samba.org/show_bug.cgi?id=3D16044
> > >
> > > Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
> > > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > > ---
> > >  mount.cifs.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mount.cifs.c b/mount.cifs.c
> > > index 1923913..d41ca6a 100644
> > > --- a/mount.cifs.c
> > > +++ b/mount.cifs.c
> > > @@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_i=
nfo, const char *src,
> > >         unsigned int i =3D 0, j =3D 0;
> > >
> > >         while (src[i]) {
> > > -               if (src[i] =3D=3D ',')
> > > -                       dst[j++] =3D ',';
> > > -               dst[j++] =3D src[i++];
> > > -               if (j > pass_length) {
> > > +               if (j + 2 >=3D pass_length) {
> > >                         fprintf(stderr, "Converted password too long!=
\n");
> > >                         return EX_USAGE;
> > >                 }
> > > +               if (src[i] =3D=3D ',')
> > > +                       dst[j++] =3D ',';
> > > +               dst[j++] =3D src[i++];
> > >         }
> > >         dst[j] =3D '\0';
> > >         if (is_pass2)
> > > --
> > > 2.51.0
> > >
> >
> >
>


--=20
Thanks,

Steve
