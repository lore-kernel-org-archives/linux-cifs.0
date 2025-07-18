Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C0E1B4257;
	Fri, 18 Jul 2025 04:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752811850; cv=none; b=pDWTUJ/voM7kMV1UWIfa/42zpgkrZitTTqXFMOm3oCiwAqyq/P05V+8zq5C0WgpH3/1KvRRn2NBfeS7wVO6e0xqjLUqsLGRterPkRaLtp5l6nHKe9mM4X6cKUJT3Wtpanivxmb0xhc/FgkYRpTbwi53XOjeoSaaKEB+r0jbGtIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752811850; c=relaxed/simple;
	bh=0kG+z2/LJCfSnSV7UBYxQFmnrO9me+wV/mZOX+SXjJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hCqbdc2f5oZKkX3a0qssTR+PchQQhKA2821SSSGsa9DCh0sCmpB4UQjh80+dydS854ceLZVCDvQozg/Bx5f1hqh3UeZ1FWSq3MX3uBeddiYwXfmySHqB4ki6nVJ2kUMTGbNfC24UUSU2NhtrjUU39VjwbqKaeocq4i4Oy5n0MRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PU6pRLBG; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PU6pRLBG"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fabb948e5aso18121156d6.1;
        Thu, 17 Jul 2025 21:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752811848; x=1753416648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dRyzcJTSxiNH+JE+i8uz41OReOTdbs1ekB4pJU70Bs=;
        b=PU6pRLBG2g40kww0cJOI3Pf5SWnO5GTtzdnrRo+MqNnWKuJa0+QZsQiopzmuv6JfYW
         Rx0p/ZqWMp2MIOQQrqC6aR6EDeKl0j0njC04YC9y9rpFe7NYVWhJy4tYwCS532ECm6rF
         9AGaN7T7ZwRIxllbpRNf/opsUy0uiuVBYtr/YQz4oUOXjc755OXDHCXQuKLWmDB7MDYS
         adJBRCw/JdmzIEa+QuvI2mhBIySq3dLv+KzeYTwkipMqfj+mquvzPdh77DsCMiG4DKvc
         5wMfpGAv6/z/DwSb2+KFPF5RCfT1lBffyJP9rLwuQA4RX6yLbQ9w7EDy2ZhgD2BMLs1Z
         hHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752811848; x=1753416648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dRyzcJTSxiNH+JE+i8uz41OReOTdbs1ekB4pJU70Bs=;
        b=Y9gHu0+f5FKaYKPFVWwGmG4d92PHh1ifk6j/QIU2zhiSD1117uNxiOJvOW6z84jHvn
         4VsPcu03ivFEB84tCtDRVurkgCTv9hfpHVWEJODInPzY0crD9Z2Ps++YonyGSGiEbwTK
         8zHaMTzwzs5odmAvvYxUgkuiZGc0jszWgqOLMr1+D1C8dzTi0Oa/f/0jgs8bY0e8qRiJ
         6fSzGyo2YmF1wshpa9ab9OlYLqmYibfQ0Khi+osqlYy9qTukVMzqoDL207bgdU4yyiZN
         0twfU0LOdFpXsgUo3INZGcbn/9OvqZ/3R8ww1mymDavDJ3mBPFye4F6H5FDYss+TbFnc
         tzqw==
X-Forwarded-Encrypted: i=1; AJvYcCWW3O0mcVYR4PYRIGY/sCtA9bJn9EJdczFOtsTSNSSrtPWuwEznvHkRpy0t01dNzWnLdZ6YvD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMSIqHmfAV6DU/gAMZ67oELcMYCberCUpJ74PIZx1rpEQ8osEb
	hozWiFPEjUE4mgfH450ZLj6iBiWDxU75Q4ZcZw8LiG9mL4IARxWYqzYZ8g7EKjSgYFu2CEq7s1O
	iSvHbxlEwHxOdENy5WjYYsrU+iBoD1Zk=
X-Gm-Gg: ASbGncvElGPSf56/0YqNQ5PhYVb3/2o4drU6ps1knbiIYelF84VwFn17aN5xIcHSD9O
	pNZFsAQQusccy5mYboUfRfn728DGU5yGxl3Te0NrMO62DxODWKXOFD7Vcih6SA7GdUIfIihTpvC
	OLhvRvHdFsw3wBd3A5kXF00sVc1pQEMwqOeK8iRM8xk2rGMwdsHQng3BeSOdyXhmKJzaBayAggG
	HJfW9aphzRYdA7079oIq+lY3xC7rm+m8P1iQmoD
X-Google-Smtp-Source: AGHT+IET/V1XYF8JgnXMYmpFBHfWr+BbeRgOXfteBZls2NqtVBKQLyn1/NdCZshWfFdmZ2NvCk8Alek3+W2dry3SXC4=
X-Received: by 2002:a05:6214:33c1:b0:704:7b9a:8515 with SMTP id
 6a1803df08f44-704f6b525bfmr165640006d6.38.1752811847523; Thu, 17 Jul 2025
 21:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717120653.821375-1-sprasad@microsoft.com>
In-Reply-To: <20250717120653.821375-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 17 Jul 2025 23:10:36 -0500
X-Gm-Features: Ac12FXzDPGpi3fYiM_K-CMhTUptL_mqzq41-Qhi0Plvgn_IJWK_vXdJ8A_kWAFc
Message-ID: <CAH2r5mt7O=e531xfLB8-7jyyoOm_Hj+7akzCHFX9EcOhQ_uyDA@mail.gmail.com>
Subject: Re: [PATCH] cifs: reset iface weights when we cannot find a candidate
To: nspmangalore@gmail.com
Cc: linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	meetakshisetiyaoss@gmail.com, pc@manguebit.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

applied to cifs-2.6.git for-next pending additional testing and review

On Thu, Jul 17, 2025 at 7:06=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> We now do a weighted selection of server interfaces when allocating
> new channels. The weights are decided based on the speed advertised.
> The fulfilled weight for an interface is a counter that is used to
> track the interface selection. It should be reset back to zero once
> all interfaces fulfilling their weight.
>
> In cifs_chan_update_iface, this reset logic was missing. As a result
> when the server interface list changes, the client may not be able
> to find a new candidate for other channels after all interfaces have
> been fulfilled.
>
> Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based o=
n speed")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/sess.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 330bc3d25bad..0a8c2fcc9ded 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -332,6 +332,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct T=
CP_Server_Info *server)
>         struct cifs_server_iface *old_iface =3D NULL;
>         struct cifs_server_iface *last_iface =3D NULL;
>         struct sockaddr_storage ss;
> +       int retry =3D 0;
>
>         spin_lock(&ses->chan_lock);
>         chan_index =3D cifs_ses_get_chan_index(ses, server);
> @@ -360,6 +361,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct T=
CP_Server_Info *server)
>                 return;
>         }
>
> +try_again:
>         last_iface =3D list_last_entry(&ses->iface_list, struct cifs_serv=
er_iface,
>                                      iface_head);
>         iface_min_speed =3D last_iface->speed;
> @@ -397,6 +399,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct =
TCP_Server_Info *server)
>         }
>
>         if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
> +               list_for_each_entry(iface, &ses->iface_list, iface_head)
> +                       iface->weight_fulfilled =3D 0;
> +
> +               /* see if it can be satisfied in second attempt */
> +               if (!retry++)
> +                       goto try_again;
> +
>                 iface =3D NULL;
>                 cifs_dbg(FYI, "unable to find a suitable iface\n");
>         }
> --
> 2.43.0
>


--=20
Thanks,

Steve
