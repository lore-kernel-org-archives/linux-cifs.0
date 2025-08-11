Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381393FE7
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 03:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754883649; cv=none; b=UoJt9mpMBG3bbDlp2KCnCCHdce4QLEmq0Lf+Uhhh8mjLh6iytU8BeRyAjgIUGgXvoZHj3/2D5oWypmYjjO3vtgrmeF+G0ZGaCX4ksa5L5tM6yriGHUPf4uqL511tkGs783rzkK98HpQwjeApd5DCaxaXRv4dBEMDz0auTAtqC7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754883649; c=relaxed/simple;
	bh=x4v/9rPIKkynB8Jjr6+k4JjcgC/uLQapR4hxgzwSUL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dcQ6F49qy596s1ttmZ5Um6Osf/T9Rnyg1Gylvy0+Fm71WiHBcYMeFGZICBRzCJABUc3UGTBQd5qPb/N5hlS1W6aQIyX0ceGhdtOsE1fAgNJR/JrIEEDr/JwteFMPvnHb35jGooMK7jTKBjZSIowyAezVVM5fdliWI8tckaum3Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoWPNMxw; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoWPNMxw"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70744318bb3so34890256d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 10 Aug 2025 20:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754883647; x=1755488447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ziyj8WUVAHq9tryz3EJdJekvctOVHPHIBPoz9x+fYrE=;
        b=FoWPNMxwjrcdJXWsHyPXfGjE9HrvJ2Oou5McbpLKuV7c1DHbOmjZwRzEvFe9kaB+f5
         /qxSgKV926Z2WtwkK4nLAQU3ZOEy3CXE4BxqhupD+1vb2Y/pTP08tx4tYm8fhUnqCxhh
         zhuB0WwJBjVqo9hePQYJIPMHoe/vUJT3jMSWWPbfWKgSyLAZrBefgwnf3x3DBjcmpwQw
         iEs0DT+NwL3Ou84TK2neabXqceTx2fham7hSR7eqTr7cwQvuffMsubO2gzE/2hpmpRJ0
         d/1vl/qX3rBtzGYvaZAk6Bf6Ee+E7NGgUh/Hun8ob2KQuW5qWKH4yMSNT2o16YtqxrJ9
         xKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754883647; x=1755488447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ziyj8WUVAHq9tryz3EJdJekvctOVHPHIBPoz9x+fYrE=;
        b=D8auX4qUhdrrlxDTYniiVJNLz7cl5hEfJdRcHZCSwyaPt7G1TFR6v36gtusOmE6OlK
         tXc3G4MryWXGA8o+j+722mpvWlaTZ4UGiCCIK8L1tMWuaDwiXnuBlLfZCt1aLfnFGlw0
         GNN7RYhFfgLMq9LhyipVMnr29yG/V990ZLb7sAYV0V9pRrUiPcun+fL1aV/hITzwfAaH
         cS5GT1uyWiOVmPz3CbQ6rmjYuUMwcCtilpMCvU2+YLs7dfjzF0m9kp+X9V62a84nMHVP
         wOJCrtWRujcqKszRvaV8TR9obrkQ2fVoNNkwx+tYHpbAcX1fYuhVf1wcDRNrXiss+zHE
         6brQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkEtTlLzS6RGmoHOHwZ4h0QZ8rbU6fzmk0nAW1TBPCN4tBwc9diC1i3o4xBh3ctbboa/4czzzDQ/t5@vger.kernel.org
X-Gm-Message-State: AOJu0YxhLFnLXB7MEy9Gzwz8CploCbcOK+X4mQ8NW1aA4+J6OOxzMnBm
	MRVb0PCajycFY/q0iYDP+ytNAuEhIuFVMR25sd+qmbddm2wgoKE0wW6PncPlfT16gUIkaxBSvzU
	b6B+TM7EMSBTz88lmX7Mr+vFRNT8dYj0=
X-Gm-Gg: ASbGncuifKtIYWk+Nj3SkfX6Pf7xhIHoNE6hldNdTeWXC0gR8DllHjW/sa2IJDOhs0p
	/IE/ynJra91wPbAjv4nYsH6cQU1yaSJE7+F647peY6dye1loseCgl9GU2DAQ2j5G/4d19nRURcM
	Ky++xdd0fVyNclzSpVLzsoHifOBpTus9vV27sKs9P755gZmYEpsVxa2hMbc+xfuIhywM5CGvX8K
	vARDbJKmNAoP5Je2VfLrAirpXLUkpAJl6iBYz7EFXIQ8eZfqz8h
X-Google-Smtp-Source: AGHT+IH+iwRqf8v9jviCl8+PAnHP/11qwyWxtoGyjQKk5SQ1MPSH0ecwEP38JMP6P0ZAYmNVqi55JA3D0llFZ35/+oM=
X-Received: by 2002:a05:6214:21a6:b0:707:3ad0:1f15 with SMTP id
 6a1803df08f44-7099a227bf3mr150302896d6.18.1754883647018; Sun, 10 Aug 2025
 20:40:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801090724.2903515-1-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250801090724.2903515-1-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Aug 2025 22:40:35 -0500
X-Gm-Features: Ac12FXyM7s4diFMR26VERmJ8PquCbCWIsw1KNM-OW287EvTT8YbumF787ZcNNeU
Message-ID: <CAH2r5mvoi52XODat6tTGO=508fD+-UZHUwug61wF-U3+cx-hqw@mail.gmail.com>
Subject: Re: [PATCH -next] smb: client: remove redundant lstrp update in
 negotiate protocol
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I may have missed this one in the mailing list last week - any
thoughts on whether to add it to for-next

On Fri, Aug 1, 2025 at 4:07=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> Commit 34331d7beed7 ("smb: client: fix first command failure during
> re-negotiation") addressed a race condition by updating lstrp before
> entering negotiate state. However, this approach may have some unintended
> side effects.
>
> The lstrp field is documented as "when we got last response from this
> server", and updating it before actually receiving a server response
> could potentially affect other mechanisms that rely on this timestamp.
> For example, the SMB echo detection logic also uses lstrp as a reference
> point. In scenarios with frequent user operations during reconnect states=
,
> the repeated calls to cifs_negotiate_protocol() might continuously
> update lstrp, which could interfere with the echo detection timing.
>
> Additionally, commit 266b5d02e14f ("smb: client: fix race condition in
> negotiate timeout by using more precise timing") introduced a dedicated
> neg_start field specifically for tracking negotiate start time. This
> provides a more precise solution for the original race condition while
> preserving the intended semantics of lstrp.
>
> Since the race condition is now properly handled by the neg_start
> mechanism, the lstrp update in cifs_negotiate_protocol() is no longer
> necessary and can be safely removed.
>
> Fixes: 266b5d02e14f ("smb: client: fix race condition in negotiate timeou=
t by using more precise timing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/connect.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 205f547ca49e..a2c49683be66 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4205,11 +4205,10 @@ cifs_negotiate_protocol(const unsigned int xid, s=
truct cifs_ses *ses,
>             server->tcpStatus =3D=3D CifsGood) {
>                 spin_unlock(&server->srv_lock);
>                 return 0;
>         }
>
> -       server->lstrp =3D jiffies;
>         server->tcpStatus =3D CifsInNegotiate;
>         server->neg_start =3D jiffies;
>         spin_unlock(&server->srv_lock);
>
>         rc =3D server->ops->negotiate(xid, ses, server);
> --
> 2.34.3
>
>


--=20
Thanks,

Steve
