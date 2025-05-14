Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1A752F88
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747237496; cv=none; b=SuvRxT2DCZ9hX0bjmmdNWgc1KNVsVg+JZIWzP7YvAZZKKBukp9ZlrA8F8nFv+WR6Pm+7x5CRrWBI0vEOu0UE8ar3Spd4P0b37dNwaizfyiOCogTTx9WnHXfNJ9txMhosE94x6Kt74nqiK0Apl9fOpZ+nUuU5YchHqwC/WSoO/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747237496; c=relaxed/simple;
	bh=Vffh6vcaaEFvrKwHS4j0CJ6y15UnwgbfiBs/VghroE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MEFxQU9AkKHMOvpVhj5ZvW6lv55/inr47wl7GzNogSbVAg7q1HCKG5VBnCxBtA5ALuJLBsMXkQwwqIb+vG94XX33ypvOKV2ZSwRJawXyehuLhcQjT4rJVi71Jlu5I5lvMeQ/0QjNHkp8FUPkGzMu7cT6v3azQeohCIyQmnQy0tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBFit60y; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBFit60y"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30db1bd3bddso65295391fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747237493; x=1747842293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zj2EY+tSLG21oTzdSM+dLvMFhkVFk0PiE2hJYjWUEKY=;
        b=UBFit60yMibVoN0oftROK1mNItlh10mzndxHY8F+g1c8LT94JDhiXzjdbT0tGnk8tk
         8P9ezGRnGNjveq9jcRAXpcv4rJW5BY3G3XU/tzXt8IUe7E7vBg1hyYuwzOUdwlWMRzWt
         DYVcMNpzccTXEXLJ2lXffCuOuWW9W1ukeSYCoj37OlCexhXijQ3/TPVEUS1TOQjygOWE
         IyvR3p2KWsYbPshOH3GXptFczJv2ZnBaIbWJazCXV4HmKGD87s2sv5FopidLHhLBNgNz
         yctcqtAYfrgsFj8iE2nkZmfZhTFPTp8jZXt3vZLVeGDYMELJk5om7u6CN8NJRBVQEzZf
         aYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747237493; x=1747842293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zj2EY+tSLG21oTzdSM+dLvMFhkVFk0PiE2hJYjWUEKY=;
        b=IAtzXbEg046e+7CZrkzTKdBSQWXhk92X/FRJR+FSML8EgsOBMktS4RqkNgMFslDr7L
         EY7inCvAtUNll2QjrTeJOrOeD4k6kWuM7uSPDDnluGlotmZmCVwpFAktcDt1HoIUU51u
         MOzdIoFi59GWm1z2DVZzBu8MfhcSCS9eNkhBZvDIR8ZUtVfHMR8Ph4hAghZLQ6JA69Mi
         7hULDCrbzJbhyfct0IQDYdTZG8PhLipiml/lhm7e9DseRaFaC+ETO1k6HCg2gsuU4sOd
         qiIFCrPzm4gWmcODW/iAEcmniFUIRaYyWnNhVwmk8zG3kRyNnyvoOLAZPkGePH0JOK1H
         bSnA==
X-Gm-Message-State: AOJu0YwVkq158KWwhLmVGBCckDGi8xbdfml0QBrkmDXkKocN2vNvjYeO
	mfSkP76FQFB5nzdsLETh5uPT1/pFCwmuLKSssAYsnKk6JN3dfgE1sd9j47mrkodmyu7I78l4swa
	DnCBhBWSRuzJbDLdtSF1QsNW8Jr0=
X-Gm-Gg: ASbGnctDV7Vk9+mqAX9+MJIBMgt3JVCVSA5F+XhqnNVAmkX2h0Zh8uCh52584HfJBYs
	xazKxvlXiE1ReECfuqqm8EpEa9khkbcFy1heIMJ6zHyPxJIo1ZOjs0JggwFQFX2YXhyulwjyNEe
	skwp0wubxxkCAR1deSts4lfiT3fqDR2j/04De3uHDKeeAgVn/mxQlZ6CHZX3eIs1F9mFg=
X-Google-Smtp-Source: AGHT+IGb6HOPg1CgDGWVro/njAlyDE7OlWqd7IvyHG5qar1Pg31AJlFGPhjr/Mot8DSEgJrKUKspu8ZOfzYo8MV+VFo=
X-Received: by 2002:a05:651c:502:b0:30c:50ff:1a4e with SMTP id
 38308e7fff4ca-327ed1020a0mr15405351fa.18.1747237492583; Wed, 14 May 2025
 08:44:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515012323.28f38839@deetop.local.jro.nz>
In-Reply-To: <20250515012323.28f38839@deetop.local.jro.nz>
From: Steve French <smfrench@gmail.com>
Date: Wed, 14 May 2025 10:44:40 -0500
X-Gm-Features: AX0GCFvFb_vi4IXMLV8Glpi9Pbjz1Za-GWHNoyWFUES63mQi2YJ2wMTyPOPyEDQ
Message-ID: <CAH2r5ms-tRqbGSWP1ih5J8oNkVdKwLOh3_ZP5D0YDKi=Tn78Wg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix memory leak during error handling for
 POSIX mkdir
To: Jethro Donaldson <devel@jro.nz>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Am tempted to change all the other calls to free_rsp_buf() in smb2pdu.c
> to pass rsp_iov.iov_base, even though none of the other cases where *rsp =
is
> passed seem to exhibit the above problem.
<>
> If that sounds like a good idea, please advise if a separate patch is pre=
ferred or a v2 of this one.

The larger change is too late to go in 6.15 so larger patch would be
best to do separately

On Wed, May 14, 2025 at 8:37=E2=80=AFAM Jethro Donaldson <devel@jro.nz> wro=
te:
>
> smb: client: fix memory leak during error handling for POSIX mkdir
>
> The response buffer for the CREATE request handled by smb311_posix_mkdir(=
)
> is leaked on the error path (goto err_free_rsp_buf) because the structure
> pointer *rsp passed to free_rsp_buf() is not assigned until *after* the
> error condition is checked.
>
> As *rsp is initialised to NULL, free_rsp_buf() becomes a no-op and the le=
ak
> is instead reported by __kmem_cache_shutdown() upon subsequent rmmod of
> cifs.ko if (and only if) the error path has been hit.
>
> Pass rsp_iov.iov_base to free_rsp_buf() instead, similar to the code in
> other functions in smb2pdu.c for which *rsp is assigned late.
>
> Signed-off-by: Jethro Donaldson <devel@jro.nz>
> ---
>
> Follow up on "smb: client: fix zero length for mkdir POSIX create context=
"
>
> Am tempted to change all the other calls to free_rsp_buf() in smb2pdu.c
> to pass rsp_iov.iov_base, even though none of the other cases where *rsp =
is
> passed seem to exhibit the above problem. Reasoning:
>
>  a) more robust to re-ordering during future change,
>  b) easier to follow (acquire/release via same pointer), and
>  c) more consistent
>
> If that sounds like a good idea, please advise if a separate patch is
> preferred or a v2 of this one.
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index e7118501fdcc..ed3ffcb80aef 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2967,7 +2967,7 @@ int smb311_posix_mkdir(const unsigned int xid, stru=
ct inode *inode,
>         /* Eventually save off posix specific response info and timestamp=
s */
>
>  err_free_rsp_buf:
> -       free_rsp_buf(resp_buftype, rsp);
> +       free_rsp_buf(resp_buftype, rsp_iov.iov_base);
>         kfree(pc_buf);
>  err_free_req:
>         cifs_small_buf_release(req);
>
>
> base-commit: e2d3e1fdb530198317501eb7ded4f3a5fb6c881c
> --
> 2.49.0
>


--=20
Thanks,

Steve
