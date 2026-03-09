Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4802730F7F2
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074062; cv=pass; b=kwnV/Ail/YLC0V7jKV87SbFSaGyoV3szJyuOilpRnxGPbITDSqjvTeZVTOK3qicwU1oRcFdYbR3HRXWOdvuRWpDFlsPl0pPaoRmOAElpdZVqxnfaw1JbcoqQcg2JPGtVlK1tyVG1Xo4915/72JMsqVbEKqzxS+98oOlQQxWrNB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074062; c=relaxed/simple;
	bh=9coBkOo79EXBeNTnc1AKH81PaBwHi35k5oi7VBC2AKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrBAX8ljAiNtI19tZBGGAqADp+dsbXe+WOi4dn/9yhwHDAEO14Kex0AlRmPJ4VW0yFDDWM0sbMdQB3MNrPSCVK5eZB1i29CUrQF1cDp3yMtgIlVztV9FzHA5EiLEjz5nNxsnD6A8cqjii1+3T1dFZ1tCX6jB7mdPETQ2Af1NeY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOzG3AdR; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOzG3AdR"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-660a7aa6e44so9398355a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 09:34:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773074059; cv=none;
        d=google.com; s=arc-20240605;
        b=hVizp8cABDCGYrKVoyIrl5RfwfPb0bvMN9ndMalS9xFJAEQXFVSsaCzlMLkJwcwpRz
         kn6UMK7DgSeUaD8cKOlq5tCIh0QygL2SOWIHvWE+jhcw2gAFObIg7M39GNXGq//xuP7E
         CPR+3+FW1F+C0o7aRqYdm83nDYuXfLt9l7NUkPRFgKLAZUuHJEWjG2ik+ENaNEWYMjwJ
         YOP2W/QvX4q0dQCXHHl97yEef8Nl6yPC9z7MDwWNaM5aysVwVx4cHg2XzaaEDf1m4nx9
         68MdLU1+NhObCYRAx477gr3nlJ/+GrZxAH/gSGU544EK3Y/VklN0jwlT3HYSTZndeI6S
         YYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oy9DX0trpu0pCizzkFBsWPboHR1XBmQKIKlmRUfC4lQ=;
        fh=IgzW7Xi7yDyl8vCj07Hz+9x51W4O1b4UQK4fpYVK7dQ=;
        b=OuErBtpFMyCm9a65blvb0cOt+DGqD+B5SbROTVIB66HA9OL4EszfYs7hTMqpNgjHF0
         p3k1CMjpwH0e+6zGjd4oEh11AVGKuqFpo0ojxeTrgehJMY00Gvan8zfziptPldWku2iJ
         AgYZgFqtb+7zmKFSWFLfzqW5a3lxK/toYeK+MOrYy6svmK4g0Jif7tuuaCNXke+JpvRh
         HKNU7/KkqqBcO5GmMNBRKmgs6+bgJjdjcND+7JIyoo+hFqslmxauH0bfSDp+48VdPMWE
         A7Vvi4itxLHDas4RcUwONxQbpgPmWmH66GsUfSJTqJQTFyYvg8dX6cl11/fQlodTvSo+
         nkNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773074059; x=1773678859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oy9DX0trpu0pCizzkFBsWPboHR1XBmQKIKlmRUfC4lQ=;
        b=KOzG3AdRP+0Y6DdKBtIj9Fw/m8xRmWpBdoGT2FHLaqSx8wP9KoijnIKFIcvi58LxjG
         gVSGFw3i8oRPCzm7uDofGg8aUU5dVAeC0VKuNUuANVW1No3aQrFRW//1YA0E0cFQtElJ
         KCZCeLlAXwksxA+gx6NsKSaZmOu6OXbRo3OPYB49THdack0bw2gUNqq4qZuf55tMTmik
         6uod1Z6ORcBQH1AzjNOtbSGDU++IrktaP5MVdC1d6zPqe2JrSH7Yu3OUfuf0lwE8Bd6T
         EeTfA74Hq0kUe98ZIq6Od7ZcrQcNShjyTaxcDye+MLHUwLrm84SWeCbEwsqIsMRnPleq
         jFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773074059; x=1773678859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oy9DX0trpu0pCizzkFBsWPboHR1XBmQKIKlmRUfC4lQ=;
        b=e0jP6M5GhYyig47j03vJKJMq8HFSVehcXTYwyc3F365XFPjMaRuzvFOBYjMyAK9J8I
         r1eJJvAX+WSJmleYO+Xde1DEf7rgexz8A4KysMXNA37dGVtkc/W0cDGoqxpHQZAS4wS2
         7ZuwEIvSWnxGmWA1Bcexz4K9FOgR7C16blNBPZdFsL7Z8vcUN6cCB2/q5qsHLvl9sRjc
         iRQpe1RVxaPusPSgQgtqwXoq6eKOo2Hrp9P01A0PihQR2cRDZVhknoi+7jN4RlRtWr/O
         hg8alyvoosIAnKaAbS2PGrrzIV5lGL3xHLB0dUk+5PQMyuwkNf7b4FFIOs7Fuh71jhXg
         8crA==
X-Forwarded-Encrypted: i=1; AJvYcCXuguILQKhIvMZBE9PLVTqPbGb+Qj4H5DuwCQRTRXSn2dltvKY4dl0B5h8MYF6DRXIu8iQgHbz0+Mul@vger.kernel.org
X-Gm-Message-State: AOJu0YwDga8/DwY1pZJQz2h2NB3VvuL98cn1aHbWXl5tjZnHFpO4udXd
	6zxS7I1/47wyNTEOIoibIUp9Cd3lQxtfFwyh82f1h20QnTnvFzCjibT9z9eIA5LjX5DQ5bgai3I
	/V3ookZBavRqNN+0ysSzRqD4bJpev+EI=
X-Gm-Gg: ATEYQzy5mgFL+fRzK1YkQ11CYaBYvKW5i1DkZ4mr88ioc2vOJCSq8TDWPR+97+8kV3r
	Tbp0RZIvPqf/iEWl/apzlIoRROx1eA1CRpDUkWmyTFdvXrnO6EwZi3g+hLkJqzZFJcyJ/6wyVSL
	6B4+d1wf5p44NWAGqjvKOx/z0aChAAX9jowPykjKQQzH3bz4sHTm1VEN073n1c0A2c05AP9hOzW
	ci4wNccag9TXI6aCyXmUqns0PcPnHIV1jF63CfwU2AMp8b0PMMncGXlvLUbe0x+1+dtfCSP8Ywe
	Q5cczA==
X-Received: by 2002:a05:6402:358a:b0:660:f98d:228a with SMTP id
 4fb4d7f45d1cf-6619d5429a0mr5597450a12.24.1773074059331; Mon, 09 Mar 2026
 09:34:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com>
 <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
 <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com> <9ef8fa889e302e58846ca6d33957077f@manguebit.org>
In-Reply-To: <9ef8fa889e302e58846ca6d33957077f@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 9 Mar 2026 22:04:08 +0530
X-Gm-Features: AaiRm51PK3LwydRfCJATxh2mUKD-V3fpJf2RbBCwI3PUSPYwh-Ui9uAKbF2q1Gs
Message-ID: <CANT5p=rD_-Qxz+MgThps5D4icDsZhZ7Es3jr3FgdQuuxbmA5Bg@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Paulo Alcantara <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 7, 2026 at 4:49=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > On Fri, Mar 6, 2026 at 4:45=E2=80=AFPM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> >>
> >> On Wed, Mar 04, 2026 at 06:04:05PM +0530, Shyam Prasad N wrote: > On W=
ed, Mar 4, 2026 at 5:59=E2=80=AFPM <nspmangalore@gmail.com> wrote: From: Sh=
yam Prasad N <sprasad@microsoft.com>
> >> >
> >> > A proof-of-concept based on this draft from Bharath.
> >> > Looking for comments on how to improve.
> >>
> >> Looks good.
> >>
> >> Just one minor thing for now. To me the cifs.ko module version doesn't
> >> say much as it seems to be not reliable (apologies if I'm mistaken).
> >
> > It does get incremented every 10 weeks.
> >
> >> Also, the same version could have different implementations in differe=
nt
> >> distributions. modinfo -F srcversion cifs is a better way to
> >> differentiate cifs versions but not to compare versions. So the soluti=
on
> >> is either remove this or bump it in every change using X.Y.Z.
> >
> > We do bump the module version every kernel release, e.g. we are at
> > 2.59 in Linux 7.0 (7.0-rc2)
> > Would bump it when someone does a 'full backport' of most cifs fixes
> > to an earlier kernel.
>
> Who?
>
> >> Further, have you thought about how the client can use this in its fav=
or
> >> other than diagnosing/debugging a faulty server?
> >
> > I thought this was for the reverse - so the server support team can
> > get metrics on whether the client is an old client with known bugs
>
> The client version is entirely pointless, especially for distribution
> kernels.  The support team can't figure out by just looking at the
> client version as the backports are what really matter in terms of a
> distro kernel.  Most distro kernels don't even bother backporting those
> commits that bump the client version, which makes it even more
> inaccurate.
>
> >> I think we need to be clear on what is allowed here, to me it seems
> >> quirks, workarounds and perf tuning? Maybe this can be used to improve
> >> interaction between linux client and linux server?
> >
> > presumably primarily for customer support to be able to recognise
> > known client problems on clients accessing a server
>
> Neither the client or kernel version will tell you _exactly_ where the
> problem is in distro kernels.

Hi Paulo / Henrique,

Good points.
srcversion is probably something that can be unique for a specific
version. But is there a common place where srcversion values are
documented by distros today?
If that is the case, perhaps that with the combination of the kernel
version can tell us what cifs.ko the client machine is actually
running.

--=20
Regards,
Shyam
