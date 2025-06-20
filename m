Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A423B229B1E
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 09:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750412992; cv=none; b=SYWBIHIhBi410uHwFYeOSRASG7FZ2BKG+zeG+qGS8acofWV2cOw6Raq4rvTR8U3yeKcBVGOo0Kttw9LuabMgY/UU7tSZYGXxbqSgsfqc4Qu39fMHmtkQ73c8j7K7zwx37d5D8jJkJnPOZLKwtZzPuVXnqiYoKKHGZ8wsgNqQG0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750412992; c=relaxed/simple;
	bh=jQ7z3TzFKIcZF4szqA7Pk7bttdFBLPElFd66Rb3mMPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tFKfC75XvqxQpYSX4durO2fZIYRPWwFkBaAWoRS1rUBPCNgyvqYPlyJUqp0+exyJhB9FKX+5Ndu3uOrO+3t5nh3KYhYdrQdgQ3Qu1N0CkXL+qZD2KNCjEfb4lv5+2VSzh1dmXjflZ7Cf8x0uhM2mo7QgTDJ7JC5bBnTHjBQpwpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P91KaP1r; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P91KaP1r"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6070293103cso2913424a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 02:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750412989; x=1751017789; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NGO4rQIlN6JEeJeuZGWAnzvlZp1SmK0FZXDYqoQ77g=;
        b=P91KaP1rqHbXDQbUuieACcxW4XZiF6egE25KTobynV5RwoGg2WKaX32nKy6aqfWin/
         spWNCxrO3R0d2e9Ue8gFwmHBcrPUYTmLjJAE1/+kTYHUKFpm6duyE3lSXLSlyhToFOUB
         iY0IKDxIP8faWpr4Y5isgu7n94ZOUtWjupYbWM8cdQpRd+Lsktkac4a51w6Saq1mhUjf
         vhzhzUFiO5mAedxN+ayyFTi3Acm/v5BdrtV7tWUeNMsD79yDkpXv+woUkHZAXQEq6d5/
         zdBlbIzqvlK1OOgap7hvoS6tl5FUsokjfmEISIAZyiYOB64eFRuqoxkR+lKRkXQzhD1l
         xzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750412989; x=1751017789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+NGO4rQIlN6JEeJeuZGWAnzvlZp1SmK0FZXDYqoQ77g=;
        b=frVI/zS3q2FAcrIxlxaX/suQ2JTffzYUl0sri/aCIfYoT5G0CHd28ydAiU0lPiEO6S
         cxx1XoDmkCdIhP7B7JCdtNWYeFV6j45NDzR5wB1elW5O4cTiDnfg2v5lluV6EVJj3cVN
         +/7nWwtaaVIZdOrDPiGGkdgyCmfTLr+8F1g9HVN1y9d+2wwrCJHdrBtYhvgDxcbl8F1s
         FE8JbFSn1cANvouiPIX1sg33+LlJYXZPZ7hbWiujp67IzMZFnVodmIcIyRNgQ904xlfX
         0+PTeRhYi3rgex4PrMAVnPblU/+nS7InHjtQr9hZ3asn55UxCOIFLb7oM3CB2pqTJ5w+
         XwLg==
X-Gm-Message-State: AOJu0YyKuC/nKoPIxSNUnzKQnvsXOnEvzNJDIgCbdlSFqH2YKe86aNDh
	IxVztI7MthNilu5MusaodcHB9OQwe+BMAXqoP7QyvhyAleScxO+sY8Oem0jB/QoFu/+llxHJC0c
	69ykN2Z1A7HJaRWhJC3aqoPFA5PIJzms=
X-Gm-Gg: ASbGncv6DfzssQU/J8Z6xsGY7395KPGoJrnm2CsShDoyFn7W7gnMcXfVHPyx20RK+JD
	H2EmNkpR3XbxnTmOJFGANgFxgMsR6xbLidMDlP+sRv8AaNlo3BvkoZNgxLWWF2lA1fsnUxo0Vhd
	/rmlPeQ+QWQF/kYUBSQmigAgbv5hJJ7fonXTc83V7uQA==
X-Google-Smtp-Source: AGHT+IE1mJ2i4DQ11camQhT50yskOISqfqojEnRoyEC71ilbvmWK12vG3qjmiGBSM5wS9afTZJ9CdE8rjW7aA35AuWo=
X-Received: by 2002:a05:6402:848:b0:609:7e19:f10f with SMTP id
 4fb4d7f45d1cf-60a1ca0edfbmr1803612a12.0.1750412988895; Fri, 20 Jun 2025
 02:49:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com> <20250619153538.1600500-6-bharathsm@microsoft.com>
In-Reply-To: <20250619153538.1600500-6-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 20 Jun 2025 15:19:37 +0530
X-Gm-Features: Ac12FXwPKB23BGfIE3KjagZDg8C0066FooiMRMY5PkMxCocA3EAG2uGtZMIh2L8
Message-ID: <CANT5p=pFUQNt95JVZKuNdr+S_5oVfU-q9-AjX60JdYGZHzmdfw@mail.gmail.com>
Subject: Re: [PATCH 6/7] smb: Fix potential divide-by-zero issue when
 iface_min_speed is 0
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 9:06=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Address potential divide-by-zero issue when iface_min_speed is 0
> by adding proper handling to prevent undefined behavior.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 2 +-
>  fs/smb/client/sess.c       | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 3fdf75737d43..bc56f315e2e0 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -599,7 +599,7 @@ static int cifs_debug_data_proc_show(struct seq_file =
*m, void *v)
>                                 seq_printf(m, "\n\t%d)", ++j);
>                                 cifs_dump_iface(m, iface);
>
> -                               iface_weight =3D iface->speed / iface_min=
_speed;
> +                               iface_weight =3D iface_min_speed ? (iface=
->speed / iface_min_speed) : 0;
>                                 seq_printf(m, "\t\tWeight (cur,total): (%=
zu,%zu)"
>                                            "\n\t\tAllocated channels: %u\=
n",
>                                            iface->weight_fulfilled,
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index ec0db32c7d98..697170be6591 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -218,7 +218,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>                                 continue;
>
>                         /* check if we already allocated enough channels =
*/
> -                       iface_weight =3D iface->speed / iface_min_speed;
> +                       iface_weight =3D iface_min_speed ? (iface->speed =
/ iface_min_speed) : 0;
>
>                         if (iface->weight_fulfilled >=3D iface_weight)
>                                 continue;
> @@ -387,7 +387,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct T=
CP_Server_Info *server)
>                 }
>
>                 /* check if we already allocated enough channels */
> -               iface_weight =3D iface->speed / iface_min_speed;
> +               iface_weight =3D iface_min_speed ? (iface->speed / iface_=
min_speed) : 0;
>
>                 if (iface->weight_fulfilled >=3D iface_weight)
>                         continue;
> --
> 2.43.0
>
>

Good spot.
Might want to add the Fixes tag:
Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces
based on speed")

--=20
Regards,
Shyam
