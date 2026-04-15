Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9DD3822B2
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 22:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776293964; cv=pass; b=N2wIyyowta28mHcvaT9O/vf3YddYSMssBs6g68MTn486K/2epbHcRbNvC1CoZS+ggDe90bqSrt7ZBD78xSS3ExkmoZPyvrfOhly1R6NMJRjGWMWUb7NWTm00+J+csseXT1fIfU7ORamNVpJMjSNGJnXYUlaCCPbhFEaTixseKjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776293964; c=relaxed/simple;
	bh=CygN2f4QaWObr2X1WIoE5DQ26V0vCKqZgk1vy/h5/+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUWneoGz5N9Qbdlcl3J7fiUAj+ZK7+/ZMpnusU/bxHc1o1IgDASCt88Gt901CD9gb19ZfgNN8sCcQ9lLhhT+AwxwAZ5ZnIoBj1lNvbqrgHvAbzCgmngqHNLaSdmiKFZ17tlyrHlaCFEd6aeiLHJxj2UFDK9HWmSngtdDozCecRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ONT5uBcX; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONT5uBcX"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8acb7f2586bso32517386d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 15:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776293962; cv=none;
        d=google.com; s=arc-20240605;
        b=fbW0dkzjXv6UNtytFL87MrEh+tAVLWmMrqj2x4W45iVH0p7aWwMGeX5oLeuzu+bRB3
         4jIbgoyrOVGZDyI/ZlnOlU34vhd5z1DRA4BIUkCEr09FG0RPrcaDf2GxXm2uj1kIeto9
         mamek+OgdiiuL3oCw6ZzhqoFw9/AFNeHx2FXmxXqNDAWRBHlkd+7ct6v/Hepx3tgB2Cm
         5HIKESHyHaUspOfxJuWZOFagqa0UCGtGEkCIi8l189QJpIzmZJx4pmVsyfp1vHR6pDJH
         vVpWH1+C03USZL7IJjmTjZEnlkstM6TpR/9M8sQQb9xDIOYs6gvmRGdLtoK/DToor87a
         oYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g6FdDfKfhtKAEbngKgmRPj3/CQxzIPFS7vgMVzn1Knk=;
        fh=zoi0Qv/T53HraNCmheItLAuLxQTW5fNSOOKitD8GhHc=;
        b=BXdH/gqnXKnJ3Zj/sayHR/93sG6wFH0RLciGmM025UOnlGkic0gWwShbqCLm1UhPVS
         3XHzk8tSlf3syhPlST1eG2yByaaRnJ3j64xK9O0Agapav6ktQFTtd1+v3mSNHRSi3ly8
         GcBBhyxX4KguD9Qwb0vwH81Mgn3jkdC4M8Otp+EX1BQy3ZA2JSt4z0dui2nntVvO+KT3
         KRVzIQ4GyzkqwWPTNKFg+yJ4wU1DQZSWSKqA0IrcTYDPEowTg0Bh7jxS8nqx6Ut05aZY
         vEYUpva/Adods9JA1ysPtnD+k1s6ExnU6Ed7yzGLdMaCAwZarORlIQLsc21+QzvdTVE6
         OzRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776293962; x=1776898762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6FdDfKfhtKAEbngKgmRPj3/CQxzIPFS7vgMVzn1Knk=;
        b=ONT5uBcXkUPplBLjUlX7v5WhGXhhay1lYvsXUBruoy0xYB3WMfjcaj6P46lDVmrriy
         Q9c1RAiEjagVVrVg6y9VlfKYe1DHTF4UpG9AkiCqncL0CLYB9iuCJu4guxnexZHE9X98
         c6SUStFmneIbYy+WWW8lR+wONZu27PNW7wnwY6trWl2IyFdBn9IbulVXXnhUpXBsgsst
         yK9+9blvmUJm5/sN1YgjluBVRkQyw9ppHAP6/asm76oBr++i3eOVnsane2FMlgAii/YT
         sgSrKbOWzi9z1/PwSEmjbmy5CfcWemVLRtow7VH6rQKL/6dW98bByG4HJgQyCtZkwxQI
         uPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776293962; x=1776898762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g6FdDfKfhtKAEbngKgmRPj3/CQxzIPFS7vgMVzn1Knk=;
        b=Mljn+3hz+yAuNYrvWahH3cd96WCKKYJ/+Izg4T6mn3md4B9RFxJqLrctPiLnINWmyw
         fwUPCuLwDZbmK3Jf0bvFpB/WFcHFOON27i481XpBaLOaxg0wNu1SrTcXZ6L35n+rALdr
         OtWTHIzDIuABhBb8AZASLYgiRylTeJJ8cbdBMiwfgwlUV6/FGnxtyvnH6Ab5HxiLlcVn
         izz/X+xHj3Vc+MWWyae9oPaDbVl1lDLz3gUwAKSB1JmtRHY7zyJmamgmyhO/29ExxNWZ
         irpUaBodGrB2SZDKy340Oxz2MSvSOZ+J2rTGxSw2PgmCrFksFVxbyUfMKHZdwTE1W2FY
         FJ3Q==
X-Gm-Message-State: AOJu0YxjJu8H0KKnymiaM8dJYljHpp8LCg83FWDc7vSolmrAmDrSFlBB
	Ot/pifo2qnt1/d1EfMiw1CCvnUSdl5WOazZUom1BemTc/gHLuq3l2CIpE2UeQYZVM+rBDpDtVxZ
	lZvA/buz5s5774Fn225KOIwsT2LmIT8ZHiQ==
X-Gm-Gg: AeBDietrlEEtIBcwgDmdypiFT5adXrd0XfusULCCctko3AulbYZkEVrJJsHpbqfRXyu
	m/41lKJeiMwZvI37Le99BageKPjqgGFriN2yCrgD8800mbIR+Qc+JrhGn5U62uXj87I6XtoxKfh
	sQ8t19UZMBLp6wqkcFnPtjxnSzPShYpIPCDCtVUyc0yU0BXJvxVWkvDz9eUvxK57LR5XDYiZUTx
	eyDBzbGSQSrC/mKyGPpE5SinhnPNEVsaKotsWK5QB+88uJrYV8d4jykaUlT0kKwPengqJXO74vV
	b19i0SWMBmX7D1l1EHePN7/WN9bPfwh6a7EXLgg+dtDQ155UR/r/ZtCITkVd/ZozMphBq8jRARz
	d6KHA8by9m4MSzaRRHn+qYxCkf1oSmipYaRgZNNpT3DHt3uha7GgqwH73mIF6eQedcq3PBwpoQw
	PwmW4vvrZNCyhTgiIXawYWeWp53ecATeKi
X-Received: by 2002:a05:6214:5086:b0:8ac:ab69:3e64 with SMTP id
 6a1803df08f44-8acab69424cmr236918166d6.16.1776293961770; Wed, 15 Apr 2026
 15:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128134951.2331836-1-metze@samba.org> <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
 <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org> <7f3a633a-2992-45fe-8a97-43d217953d84@samba.org>
In-Reply-To: <7f3a633a-2992-45fe-8a97-43d217953d84@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Apr 2026 17:59:10 -0500
X-Gm-Features: AQROBzAtJrsT4pJVWZWjumYRw_hcoiqj5sf6mCDUCHcutgwHMVM7HiPcFHn_37I
Message-ID: <CAH2r5msb1PxQ66fpBMZOa0cbpL1CFC45D_+xLEfwEM0QrgijFA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: change git.samba.org to https
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Apr 15, 2026 at 8:54=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 28.11.25 um 19:00 schrieb Stefan Metzmacher via samba-technical:
> > Am 28.11.25 um 18:48 schrieb Steve French:
> >> On Fri, Nov 28, 2025 at 7:49=E2=80=AFAM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>>
> >>> This is the preferred way to access the server.
> >>
> >> Are you sure that is the preferred way?  75% of the entries in
> >> MAINTAINERS use "git git://" not "git http://" but ... I did notice
> >> that for all github and gitlab ones they use "git http://"
> >
> > It seems a lot of them were created long time ago.
> >
> >> But maybe for samba.org there is an advantage to https?!
> >
> > Yes, the admins of git.samba.org prefer that clients use https://
> > instead of git://
> >
> > I also checked what linux-net uses and it also uses https most of the t=
ime:
> >
> > $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep htt=
ps | wc -l
> > 178
> > $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep -v =
https | cut -d ' ' -f2-
> > Merge branch 'main' of git://git.infradead.org/users/willy/xarray.git
> > Merge branch 'master' of git://www.linux-watchdog.org/linux-watchdog-ne=
xt.git
> > Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
> > Merge branch 'next' of git://linuxtv.org/media-ci/media-pending.git
> > Merge branch 'docs-next' of git://git.lwn.net/linux.git
> > Merge branch 'master' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>
> can you submit this during the current merge window?
>
> Here's the commit again:
> https://lore.kernel.org/linux-cifs/20251128134951.2331836-1-metze@samba.o=
rg/
>
> Thanks!
> metze
>


--=20
Thanks,

Steve
