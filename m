Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDBF30F815
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785695058; cv=pass; b=HH5Yt3u7logyUgqVd1Bat6DkyofknJSbE+kp+p9Gon5q9cXcmX8N33Zmxr7/Y69iHUrVwmXV7S0mlIM+Dud/iQO+knaWSjpGehfxFewg68eGP6CjKRw8ugbkBIv7mbY/QWp7pbRM/MSHbR6hHW99snU95VzzYckkywoWsZsYojQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785695058; c=relaxed/simple;
	bh=4r4q3g5VqzfhWh8kEQRXnv5b90zr1rjNtxEoRsVqBNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R6rVBuTwVwsK2huqpsTIOhyhwYJP3N6FRebLowH+CEZWiv2EZgoKZMQMhDJXde3EtTBlkQwtyx3UbbGcc3pO4ME7UP1+EJ8YTGy3dtzdXcbzqk9R4UzjxqWZkVbtAC2kKIliDVwY7cn8+FL5p1J4MwmpSag7KpGxo7zwIHupV48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ayn6Ysc4; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayn6Ysc4"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e53581361so134000585a.1
        for <linux-cifs@vger.kernel.org>; Sun, 02 Aug 2026 11:24:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785695056; cv=none;
        d=google.com; s=arc-20260327;
        b=rHEDRVHamckW3INDZFH+IaQW7fBHSKpR1mDFBdIPzyejvn2G3GMb5fymvi5+0KycRg
         Vtqq7YnY3wFrpduXUcLyCIyVGsW4QfOoSBdHMiA5YyUfYriP6+RQe5S2fxQMSguKIs4K
         qZ+B+IcsvyczcQ0QCZmi+14b65yK0QLf/zdMydPGlribGFKBGI23+ZoXP0TRFMraZZWM
         1JHSKbgaWLbKvzaf61/1jbF8DbHjxMD4wyBSwaDGuQIfQFYo1Ha/0nFHI+j4V1Hh3tKW
         xiC+PkChlJ/6/Tkin4vpKMS9Q0WgUpL+WXMFEbq9KRBFInxQX3kCxlW8gJrLwlAx66a2
         gnWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WP3qLqUIjgO7jrMLKGvU8i1TpA1teHZXvnJrB83KgPY=;
        fh=TnMB/whYb2dqoJ2mJgbOzN1S/x6RX32w/ozb6JMtcy8=;
        b=k7XTgjVV5flrQnE+rhxmWRa6wqAIHWLK7+mXcQjEqTDEA9iVXxn5otziOaYytT3CCc
         3kJpnXfrlIdWUxY3Fm3pR3rCUDtU5inJHwoRyFRfLZvvHFcbRZbHAN2kSnCHdxzjb7LB
         NQ1OXfA9FDTAQCQLysVBpc/bzYjFt7A0RbswSDcdX0iDzN/r4cPeyiwlOt4LCOxQGHm6
         /Xf8S5HTPxxdEU3unaRck3w0FnsqstB5HHSZ2eN+8DvG4KSLsX7OeosM4Pmkj7Zhugqg
         17JBtgDC0ypf/jfK/pOzWwN7JCYdn8ZKsgUb3h6joewjtGHoB1Bpoev4dVOmCteQKRlJ
         It8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785695056; x=1786299856; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WP3qLqUIjgO7jrMLKGvU8i1TpA1teHZXvnJrB83KgPY=;
        b=ayn6Ysc4pHH5ptRzn01JqD10Skg1Ir26FcvPjvS2VTJFbc4dZOePw7mOn9qrNgX+pr
         AcT4oWI6LJOOy0OveQpDJQaGODhX+ljxAX2FxVXF24uAcW1Eu2njMx+9hv3QGYv9vhPF
         bCDNBcCHrX/Hengq9XG0pKgAKuMCB0PK/0N/Uc9+DJLK7w932P9juD0nBuD4pg2Hmua3
         K18jzZeG0TUlhb0I4W6LWZMn42HWygt2PMw8U0pFtklvzK3OAOsU994AaBOSsHmzXX5i
         suXsuSZ3ynMJBoTeZGg7pgTu+vugtzMyMSfb0fwgsgMZcEG4r0fv1oTxgWv6HdoEANIi
         ubZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785695056; x=1786299856;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WP3qLqUIjgO7jrMLKGvU8i1TpA1teHZXvnJrB83KgPY=;
        b=nptowEXjXkuuCuMdKt3LNlw3tAMQeILqBvhyVJ+T9zVtodJIft8IJPjEC7g1pwpd7v
         1uXmJ6fmOXJTikpESUkS9LaBGjLPaJ2Os+FbKUsrW9LDCWRaqH+xg6v8TXOig+oYYqC9
         8sc1e8beNWkxpqQr0WgGGqNjO9n5uVIVafB64NqHzn41udKY7ttWrInPDyPOsdu1bKAL
         B0I/+Z4NZ7STg8iyb3bmVCrZRUkZjAdW9yPZGLoWHMrhDv3lQjP0nz7kkYOSlBE68cUK
         JEb00m2GDnvlfOZq7ChoaE6yWJXc0mYlUHZ86vjIGHEFH3SEsz2vHXSH6ZfbY7RdI2Fv
         hQSw==
X-Forwarded-Encrypted: i=1; AHgh+Rq03CMrnc264ZuD+GA+XqN+jwkxW/F6+qOOd8ddIljA6S1xBFFeWGPYE9DwGbw0ASqFh4YImwyDbeUx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9LvVXxSXHiwN/k6CA9aKaYJK636orzyu+RNXK8Zyvu4F5tb++
	HE2x2ofMHp9JSceEr0jEWT14XbAWE1oxb9DotlYAjS4jPffHE7oeposKOlyH4gZ4Mi6BFTfoAK4
	/SefutgmFVyAEGvQOBEI5gI1FZgKqQFU=
X-Gm-Gg: AR+sD12q5YOacRINZAmRksVrDYsrlr6Ew5W0yBCBDug1IndxzoLtgtswd6cp1O9JqCs
	wrZ5S2rszEZ9RJ5xY0DcjFLDDz8nqhGeSeIXBFQ0YwxuCh8TOjHVcAQCxDcQLR4P/2yA2O3lCgC
	BWck2lL9LDzWHrBxsGbpnTELlltzMgU8nciCvUNhvr5Mn/dGbMpS92SJpIZ/ZaDxIJGHRJPWnFV
	yLlo5sWSSZ2z+xtYlUjN+TFoP/Pz+EU8gGaZuvYp9zp1tYmjuwDDl8dHmHLI8cB9cRn+WoBNFo3
	fJuJPDnyNvmXV92GmzSwcxr1nKq8uXBo61GLkKjvLhXNut9cFjnXr77saaLZ1Re1paYnR9YPRTu
	vK8p9A0Q+CgpYgmcVPJs6PjtWA7RLluCGOulBx+/XZMs5X0rKL6NMuHvqrMtMyUSh3AdsnI5rCm
	YyssTsftiErXEuL40A2jjtLniu7IqR5cb0THI7eC2IiXiaezLM70k77VCB4UU=
X-Received: by 2002:a05:622a:908:b0:51c:857f:9c12 with SMTP id
 d75a77b69052e-52b5669de9cmr149737711cf.4.1785695055997; Sun, 02 Aug 2026
 11:24:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260802004809.1301715-1-shuangpeng.kernel@gmail.com>
In-Reply-To: <20260802004809.1301715-1-shuangpeng.kernel@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 2 Aug 2026 13:24:03 -0500
X-Gm-Features: AUfX_mz_5HOFDX4YQh7cjlt1h9LRNSHnEfYzC6TnVn8q_yfn1u7JQu3SFcr4XUA
Message-ID: <CAH2r5muLehYvO1FxJb9WjOwrK62bSOh8Ke2EzxRA3b=WS5gH4A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix use-after-free in cifs_try_adding_channels()
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sat, Aug 1, 2026 at 7:48=E2=80=AFPM Shuangpeng Bai
<shuangpeng.kernel@gmail.com> wrote:
>
> cifs_try_adding_channels() takes a temporary reference to an interface
> before dropping iface_lock. If cifs_ses_add_channel() fails, it drops
> that reference and then increments iface->weight_fulfilled.
>
> A concurrent interface list refresh can remove the list reference while
> channel creation is in progress. In that case, the failure-path
> kref_put() releases the last reference and frees iface. Updating
> weight_fulfilled afterward then accesses freed memory.
>
> Increment weight_fulfilled before dropping the temporary reference,
> keeping iface alive for the final access.
>
> Fixes: 6aac002bcfd5 ("cifs: failure to add channel on iface should bump u=
p weight")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>  fs/smb/client/sess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index de2012cc9cf3..7cf7dd104f7c 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -233,9 +233,9 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>                                 cifs_dbg(VFS, "failed to open extra chann=
el on iface:%pIS rc=3D%d\n",
>                                          &iface->sockaddr,
>                                          rc);
> -                               kref_put(&iface->refcount, release_iface)=
;
>                                 /* failure to add chan should increase we=
ight */
>                                 iface->weight_fulfilled++;
> +                               kref_put(&iface->refcount, release_iface)=
;
>                                 continue;
>                         }
>
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
