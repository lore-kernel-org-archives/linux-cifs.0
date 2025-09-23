Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10B91339B1
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 05:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758605895; cv=none; b=QStyB8CCf6T9A8cH8ek231jFG01tt0Oq64ljbxiTRdgVjXNLrikinbl/2uSvc35fweb+d30AtS0UpVBCD+H38ce4v/KrWC1f/wGYf1faTR4L0RMq9VnGXZzrWhS4Ke6L412kEQifMbAFTsk6Jo9Whu4nOXGLhv+hub5H60LLmCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758605895; c=relaxed/simple;
	bh=EOoOnpQs6YyDzSI+veaBvVlvjbOTET+yGGhdCFRqna0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLkbSW4rWxVXdU+j9NA3pI/taCK3VMaM4xTS8gwQhNl/Z0Cw6n+MIf135mbmCJBqo5C/40Sz1TFtXzQkjqAY4tNMZjrpuHHqqMq4TXgy9PdUAqTf9qkPfmZMIy2sNTw3NKd6WlHeRmOawuOfoctBrBPUl1eUxS1Y4tFw4u+EpaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCdJ6t1D; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCdJ6t1D"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62fa99bcfcdso7481626a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758605892; x=1759210692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5TnOIXP/L6yFxogqtBX4woFkv4GJFL6zI+EQyFgUxA=;
        b=UCdJ6t1DC1RpgmQvCQDHdQ3lU0s0g/Q0pr5k8aardSDFe1CJ+r5/xfnEVuWvn5U6NY
         /kK/3Z3o75FPG3k70eWvCcF9A6I1YMfD42Mp5Lil23SN7dNKSDlSb1xzcce5rGsm/2YB
         W11igfQr4orUWOg2GqIuL/bWftnYZON5VdHs8+vTqzd0w9phGuRWr23fwgnrTB8zl6nG
         aYw5SWLaEncsiCpsGaLijurEEJRE50TzbCP/iJKihl1lf8HuDZBphjACLRwuBFgvSU7K
         ntd5GbQ7uRCvBS89OY2+U5vjWt5YGnfPXm0Q+iDPKguamWglNKTxlbG7a2gfEQ6m+gCn
         IJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758605892; x=1759210692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A5TnOIXP/L6yFxogqtBX4woFkv4GJFL6zI+EQyFgUxA=;
        b=f6SHDC+NblTQf3vcBOsK847B/J9GjdrMiFPPMXE8b3rdEZOoZM+8RRGyMz0NSh64bA
         ZbXuVsPHx1vLGSYxFGuF9PH9KJsKWAxAWsuJCqIlLUIYtKWaroid4gIf6l0YUkZFYbSe
         Cr+zDo0QdpSwQ/7M8DUphqMk+M+7aKJiqdMYIhGm6APn2ENJSzm02YZreUpmG2VQVFiN
         2RHkg+2ckFUNo6P+cH6bAgDwx4+zcGavFtOkzSAj7GdQ1y7/UCOlSOctkxUG5AF/AbeW
         M/0qQuVpCJurkepYkEk1DzMlORAxGetgwg+XkUhPs9LWSUqMwX/fBhPUx2mcBsdYh86v
         T4aw==
X-Forwarded-Encrypted: i=1; AJvYcCWVi37fpLdCkYUcBdJIBuXRSbJIJXFvjfsGL4gT4dDdfG3PSO0sSnwNpZ1c4AieSNckO1rxgqNjJHYu@vger.kernel.org
X-Gm-Message-State: AOJu0YxWmvTUvrFXqfbjdA9MslLGL2nFY2meRkQn3it9HT9SzfNenGTI
	/NpmDwwVndLbpaQBX7M/CYl95UuJaD/8tO9VhfYEYHE1yY9H2VSXXIF5ur8A6ALbVGniu5kerla
	HrVWxXFz8tw/sPhe49HpmeiYW+6myCX19TQ==
X-Gm-Gg: ASbGncsQRF/f1VttEN1eHxiYau+NlI+jJU/kcHbSG4KcLok9ZtLQRhZmw3DPz3+8jNt
	U8gU20f6INV01Z5Dy6D+ZGXLHMrzbuFkzvTCJYv40VC7g//ZUHYK3uANMUDkXy+depkY/P//ON3
	2WKonacRoitjrPLhSCV3GqJa6UEEPqyGkbsbDViP99JinNN84VFAyGyi5ahfn74IomyXuJAEVi1
	vhv9w==
X-Google-Smtp-Source: AGHT+IEzpijKMnKSTADDTESqo0dS98icco3yIEtadcafKmaa0Af3pEQfiXXdbOsuA2/8VdiKKSqXCeI9BJtovafp168=
X-Received: by 2002:a17:906:c115:b0:b04:1957:8e72 with SMTP id
 a640c23a62f3a-b302c107d12mr105625866b.65.1758605892097; Mon, 22 Sep 2025
 22:38:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <da3e2b5a-a5da-4526-9884-8789990ebf95@suse.com> <qmf3xwqq4hqj4issgci2g76eghytaqxihnrp236ithh2istkkf@n4s54vp3hblr>
In-Reply-To: <qmf3xwqq4hqj4issgci2g76eghytaqxihnrp236ithh2istkkf@n4s54vp3hblr>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Sep 2025 11:08:00 +0530
X-Gm-Features: AS18NWBTxuCv7i4z-yXrgAlVhw2ieHqpbpwgkyhzz1GdT__dTPlG9BzBUtPilJ8
Message-ID: <CANT5p=qH9aXGpQzcCwFZ81MGrKFYiGBHxejdy-oRAa_QN=k=Yw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: client: force multichannel=off when max_channels=1
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, rajasimandalos@gmail.com, 
	linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025 at 8:29=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 09/22, Henrique Carvalho wrote:
> >Hi Rajasi,
> >
> >On 9/22/25 5:24 AM, rajasimandalos@gmail.com wrote:
> >> From: Rajasi Mandal <rajasimandal@microsoft.com>
> >>
> >> Previously, specifying both multichannel and max_channels=3D1 as mount
> >> options would leave multichannel enabled, even though it is not
> >> meaningful when only one channel is allowed. This led to confusion and
> >> inconsistent behavior, as the client would advertise multichannel
> >> capability but never establish secondary channels.
> >>
> >> Fix this by forcing multichannel to false whenever max_channels=3D1,
> >> ensuring the mount configuration is consistent and matches user intent=
.
> >> This prevents the client from advertising or attempting multichannel
> >> support when it is not possible.
> >>
> >> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> >> ---
> >>  fs/smb/client/fs_context.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> >> index 072383899e81..43552b44f613 100644
> >> --- a/fs/smb/client/fs_context.c
> >> +++ b/fs/smb/client/fs_context.c
> >> @@ -1820,6 +1820,13 @@ static int smb3_fs_context_parse_param(struct f=
s_context *fc,
> >>              goto cifs_parse_mount_err;
> >>      }
> >>
> >> +    /*
> >> +     * Multichannel is not meaningful if max_channels is 1.
> >> +     * Force multichannel to false to ensure consistent configuration=
.
> >> +     */
> >> +    if (ctx->multichannel && ctx->max_channels =3D=3D 1)
> >> +            ctx->multichannel =3D false;
> >> +
> >>      return 0;
> >>
> >>   cifs_parse_mount_err:
> >
> >Do we even need ->multichannel flag at all? Maybe we could replace
> >->multichannel for a function that checks for max_channels > 1?
>
> I agree with Henrique.
>
> I'd actually like to propose going even further and having the whole
> module behaving as if multichannel was always on, even with
> max_channels=3D1 -- the only difference being the need to run the
> query_interfaces worker.
>
> This is probably work for another patch/series though.
>
>
> Cheers,
>
> Enzo
>

Although I agree with this line of thought, I'd want to do it slightly
differently.
max_channels should be a configurable option for users to tune the
number of max channels, even if the actual channel count is lower.
multichannel mount option should be kept to maintain backward
compatibility, but always be interpreted based on max_channels value.

In the future, we should make max_channels=3D16 the default, thereby
enabling multichannel by default. Users optionally can set
max_channels to a lower value.

--=20
Regards,
Shyam
