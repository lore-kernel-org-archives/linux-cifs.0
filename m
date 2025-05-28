Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0135479FE;
	Wed, 28 May 2025 03:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748403593; cv=none; b=L3Vrf7SFqs2e+UaCLLmHuvH/YTJpUHltN1uF445DjwiGbL3ZM57ePWbsII5nNGbKQxyWrWqey8TzdnS2vdw4PHZKfzWvwqGYOOdlHUnio7pBI1tSTv3lnTsu1q7FZmDN8s58oCZ88lLtjoqd6g/Gx2185qH6/0M7DcAOTPtCEYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748403593; c=relaxed/simple;
	bh=ITNiBSM0+JT9vnYQuQVNXjD+6FP9rFnIlOdwWGPSEF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=otxI6xDQjwBchenhjyKaIulPCIVrBaQDkUXka3wbxGLIoJC1nybbFZ5GsrH/bBnU57JR0Vm7mTeNByjnOpwT89SrGPzFE7KyPAJH7HaQHfLz0Hxdf+R4zkLqqtJQdGLdiOMMQPXd+9hng+GQigE/xfWo3kHBFlNfHuoMTeL4fZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+GknRdv; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+GknRdv"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3105ef2a071so45596661fa.1;
        Tue, 27 May 2025 20:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748403590; x=1749008390; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k97S9wR51qc4/fnvH9KOEJ16r71ViYeaIlgZl3YKvtw=;
        b=O+GknRdv3j1JXWmrRhpsImFGDitOINitpsGJdfV0alCtO/qZosedmb5RSzq2GMvbPc
         QM4bH5x4J0ZGPwCzoyUiMIUDJip0x50H4eS1e/1nYoSfr1PCMpY+2ShXrGEjyCX5hxMz
         UGVl/KEWXgAcQt5EvUEm/Hkpsx36CyNsfzMjfE4fT/F9PcTALTogSx2ESjwBcmSenOwL
         SVvb/J0FkETUwGLEgVEQIR+I8q2sECxYoIE6Uh8oWc11NxbM60ctQqVn0lCIHXOCaa6z
         b+94wYcTD2lTm7lBpRWlAOl8lzLUWT9m6GNNzUWpGwkTjyndn4G9wc4dEPPV/QS07IEE
         Z5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748403590; x=1749008390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k97S9wR51qc4/fnvH9KOEJ16r71ViYeaIlgZl3YKvtw=;
        b=N4mUjD9ZVdfVvBOtrCe7NyZy1m2etID8/q+ufcYtXN1nIUVp82DeGTjg14k0o0Puka
         Vi0SsNBRBNbJAC04vtecjnZGRAfEQ5DLSLHp7aLODXtfw9qlnEd49saemVBsdbePnx4w
         tmfgtpVLQLVTWuIelYE5HU2nTjxRDGRPCN0bRXpD0q0ElaKFoqAyoDBQdgwhF6OVpSOx
         Dr2p63EM2Rw27ndVBtGNKAH/YP4hBRgn/VxnDuqK/w/JBuS+bJSxf8QHl/hnuvbZb/Bb
         pCkol4ILHsmeTkXbhA9wKPrBQtFPYPD7J4XhXdM3hmNiZTWmKZu41GskYtsoK23X7wD4
         3cTA==
X-Forwarded-Encrypted: i=1; AJvYcCVqmVvREUIO+aGk3g/Lf/HS/iz94Z3tVexsCviFUyXx3QOv1bkd9g+vHOdorlCyNpT9A/UXX+O0rjmF@vger.kernel.org, AJvYcCXqsX00W9ejiFx55zNU/FH32ftUOKG+o5TEh5cnZkN8eCBpcdMFvAmc3Wjm48aaITRZrZiWuY3ATQfun3lz@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm86tafXASDApgZfT89j70s1S2goXUWcuaB2Zgn+kJPyfXczWp
	K1wHDdH8J8Ig5yb+Ibh/0z8mOJGfYfs9CuyvL5mO7ccX09PQkxGxJkPBYeDnV3FlQYVxF+KtPuB
	iAAI2Nk+tvVyYPSENPgwTv49eWdce9g4=
X-Gm-Gg: ASbGnctLIJDtuyMpiEu7aoCRoJNhcJsINYE8RzPW1hBrf6FsygIDSq5Dfn/TY2S/kJm
	8t0+Svl5KKmAhLlJVq7YbvnowgSg5r9EbGPXDK5ngk2KGdd+ZqQ/ZAtWR8lPzWqZYzCUCeXliYz
	SNs+iJChplOXO1QeWH1yaOuo6CZ+rXoULOWyXsNtmPR0sx/ZagVCgJgCb3NJjrcfws6w==
X-Google-Smtp-Source: AGHT+IEIsd+uvunloDLIb1uC3D1QnCMBn9VDz+WUTsaj2OqUoWw8XlfPOWmq1JhAOND5a/jIHeqlS6sni3hDgI1rTqA=
X-Received: by 2002:a05:651c:1548:b0:30b:c9cb:47e5 with SMTP id
 38308e7fff4ca-3295b9abf22mr50089171fa.8.1748403589739; Tue, 27 May 2025
 20:39:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250528031531.171356-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20250528031531.171356-1-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 27 May 2025 22:39:37 -0500
X-Gm-Features: AX0GCFseYEkO9h9MIMfPfbft45khzPT7ofYg9blN_jrcSn2i60KgD6fYt_5tAI4
Message-ID: <CAH2r5mtAYV925FbL-5GPGvk3wMG5u0027_icNtUw6uZ9yOBqyw@mail.gmail.com>
Subject: Re: [PATCH] smb/client: use sock_create_kern() in generic_ip_connect()
To: chenxiaosong@chenxiaosong.com, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	David Laight <david.laight.linux@gmail.com>, Wang Zhaolong <wangzhaolong1@huawei.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Weren't there issues brought up earlier with using sock_create_kern
due to network namespaces and refcounts?

On Tue, May 27, 2025 at 10:18=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Change __sock_create() to sock_create_kern() for explicitness.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/connect.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 6bf04d9a5491..3275f2ff84cb 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3350,8 +3350,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
>                 struct net *net =3D cifs_net_ns(server);
>                 struct sock *sk;
>
> -               rc =3D __sock_create(net, sfamily, SOCK_STREAM,
> -                                  IPPROTO_TCP, &server->ssocket, 1);
> +               rc =3D sock_create_kern(net, sfamily, SOCK_STREAM, IPPROT=
O_TCP, &server->ssocket);
>                 if (rc < 0) {
>                         cifs_server_dbg(VFS, "Error %d creating socket\n"=
, rc);
>                         return rc;
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
