Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2B221E0B7
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754683657; cv=none; b=b4ZcZI3Jy2I9unce2AyqjC/06HkIWCTmSE5T1Dn1hUM5TAXX3hMOfQcPotYDnc3nOB2kmsC+wxpv7FBmsK1AVtxe1kScyx1A27rIusNCf66i+RkcJLI5FwIMerZbPUoIoUY35lbPV+TTXpDd4uu6GCkza2TsNbwg6fLo0jnVrmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754683657; c=relaxed/simple;
	bh=4sBjvW9oKVwapDuvIRuN8F+3vFOD6m56+3deKsPqFSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T1XXdgirdsFgXjg69L1qgJXJ2+SkYboAYyN7QiNfqBmy+VKtbM4Rsth3Gynb5XLlUnfWpgbvJaPpn5S6m4i177QLYbMFebgDfUnW978qPcJk1lWL9VYjKj2sH1OmL9hPnEy+GdcPrC878CXyu2GFGugC/EGWLd08NkpB1PZJ/gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnlG475w; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnlG475w"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-7074bad053aso23877046d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 08 Aug 2025 13:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754683654; x=1755288454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUoTMAoErc9Ie+35ZcYUPcZ/dkpaPa6zDrNAWyDO6Ds=;
        b=cnlG475wgtkwzTpY0sZmlwiw1Lv2a/C5tgEf1pG6mTLA9bsrAh2uVtRNPIED1Tj3Wy
         Qw0YEr+BWvaKQ7SRU409nJnTRp5DjDBc8lHG5Owr7xvrJC3plcuRudrOOR2ejgj0uWb/
         71615YXKeDG7J2657msb4/Yguu9q2Q4cdMD0FuL5gQCfiJKHkTahzKaRNsxNKF4t/xve
         ljpKdKQJ6czARhIeJD4G/FxXeTzVnflrkjrYYFwu0Ep7HIj313umqAHW73gmhClG6vtv
         dl1jqwsQLhFZFIzQhS8QLd1hnKF3SjVs/ZrezgJN0UysyDkkX8jNagFKSgvbMEV59ZhH
         XSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754683654; x=1755288454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUoTMAoErc9Ie+35ZcYUPcZ/dkpaPa6zDrNAWyDO6Ds=;
        b=bf4YZHjBaxj/Q+41Yea+ogUmHytzwCR+tDJoFiLD61FXfw20/7No7s/teenTy/yMq/
         IokwQsx6bGwu+X143KVrVT+MAEgAsT+rkhgSD6Kg9Q9hXm3Fy98cuYs7bWmcgxRFvljF
         ++8i7/o0jFjkWbL3gap8SK/tLo2RxGGqYzRWJHY6vgbfZe0OwOmuXhFmI1JvDvT1YNW+
         1xXECBccVHj4bNRupy+q9WzAEzKg0rU+a+3sWf0OW6MDaqyeyiNoHb67CzIvE5vaDmvo
         LUb/VHF6Gd3jveMH/hctIawEedkaHiag+nem9dudmsuY81TyKzzEO3+tW2wnxbCG7Lxi
         HLpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYbhv9EgfqZyBoV//4/3i68u14MZbetRSjSvnFTJcobONIwU4G/By/tsa/pSU5wLtQW3Hi5y8gtjj6@vger.kernel.org
X-Gm-Message-State: AOJu0YxqwszJ0Ve76w8i5CWmbbffs8e1RCSUcWNFUeYMbAHbaiciEJqD
	jvThKtTPQU5CH/XBrEH+vgfNkkUbT7+eh7+ql3/mwo2ntBghaf7vXX9mQ6w4cyARn1DXnjKcjlZ
	CwzeUSZxj2X9cmMc/U8WT07WRl8XvgS0=
X-Gm-Gg: ASbGncuPThDDMCRMjRyamyeRQl0HSECymP7Mg/+SDcHVH9dGiB09uKLz4eAB7Ajba3o
	NN3QoQwqRK5QX6eMDIQOJBA0JYnpVPF8mK2EBRnHAskAcDdeSklZMKS8TjeZEYH9143mK/LOY/q
	8hXHd0LDs7vfJiWDYvVubsKwoMh23Ga8RtdrH5+FXRTtwiDa+hm3PgY85iPia6KUm5vXe5nvLW9
	z1ZJViRF9OHUVuBUmAt7TgGlvZWv4z2lH7fDZSqXg==
X-Google-Smtp-Source: AGHT+IHG2Ow28NvN1a1tphMShmJ9oTq+jP3PaJJMNrYN5lU5MiCqOouCurz3lfiSbpm8DlkSWPdrga73IJ/x2XPFLyw=
X-Received: by 2002:a05:6214:f0b:b0:707:49da:e95b with SMTP id
 6a1803df08f44-7099a4c7d2bmr71949266d6.39.1754683654440; Fri, 08 Aug 2025
 13:07:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm>
 <20250806203705.2560493-1-dhowells@redhat.com> <2938703.1754673937@warthog.procyon.org.uk>
 <dseje3czotanrhlafvy6rp7u5qoksqu6aaboyyh4l36wt42ege@huredpkntg2t>
In-Reply-To: <dseje3czotanrhlafvy6rp7u5qoksqu6aaboyyh4l36wt42ege@huredpkntg2t>
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Aug 2025 15:07:23 -0500
X-Gm-Features: Ac12FXwM2BGxXKU1PWLQZ8eKUDgqePjv8Px0n5YI081L1LjbsNoqdqPUURON5uw
Message-ID: <CAH2r5mtpeifZ8ckEvzvQE2U8Qau1N1vQFiG-DUY+sNLR9YKk3w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES
 and use netmem allocator
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Tom Talpey <tom@talpey.com>, David Howells <dhowells@redhat.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We should also retest compression with Linux client to current Windows
- IIRC there were still multiple things missing.

Patches / ideas welcome :)

On Fri, Aug 8, 2025 at 2:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> On 08/08, David Howells wrote:
> >Hi Enzo,
> >
> >> >     (d) Compression should be a matter of vmap()'ing these pages to =
form
> >> >             the source buffer, allocating a second buffer of pages t=
o form a
> >> >             dest buffer, also in a bvecq, vmapping that and then doi=
ng the
> >> >             compression.  The first buffer can then just be replaced=
 by the
> >> >             second.
> >>
> >> OTOH, compression can't be in-place because SMB2 says that if
> >> compression fails, the original uncompressed request must be sent (i.e=
.
> >> src must be left untouched until smb_compress() finishes).
> >
> >I've got a change which should achieve this, but it seems I can't test i=
t.
> >None of ksmbd, samba and azure seem to support it:-/
>
> Yes, Windows 11 or Windows Server 2022+ only.
>
> Compression for ksmbd and samba have been on my TODO list for too long,
> I should get back to it :/
>
> Anyway, if you want me to test, just send me the patches.
> I have your linux-fs remote as well, if that's easier.
>
>
> Cheers,
>
> Enzo
>


--=20
Thanks,

Steve
