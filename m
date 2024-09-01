Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618282D058
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 03:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725162168; cv=none; b=scYoemSu2Ymt9rM4uwFqDg8VZ6woE7+LiONstsd87nmD7ZVf1jM6eL1Kmm8k6q+w91yA6Aetq/tnlpsNCsQ4Iq0h/ef5GU4gwBzhgy1d0kh2BsBRfk9Mi0ehX4mSzaqqbq/16y0VG5ngOrCEuSzYjJmgOTH/SBesscvlqifAbqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725162168; c=relaxed/simple;
	bh=4LQgqvbtZmtS3L8uOexjmnUaKhCaPmrIGTLA8Kf7X5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ax+Wl4kowbp8H/7zNLrR2zU6xJaczeFUzSE34XzU9+4b9CUW3VxmxU4229V3+DjnnCHya4vO4QmFJt7SzEeFxBmWX/tsKSnvBABLlD1Yrp871GXsNURFb2SnZ1Snzah5RG98RmrMGWEziMlEaS5ZF+p47V9OA7XTUwz9o3tqkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aim9zaqi; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aim9zaqi"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5334b0e1a8eso4141080e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 31 Aug 2024 20:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725162164; x=1725766964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6NKTz935L/d5xpf1Y+e0Uyg/R4JJQvjY282vlOGq7Q=;
        b=Aim9zaqi9+vs6jaOI/qLyGzd54xtRkXB2sAUIlurIJPE0kTy7ILulq5833sI7FuF7D
         uUar2quWiv73wAAYGPea4swJfNnCrLly+Fim/S/a6tB4nzxYt3kH8i2fnAK4L7DsIOnQ
         CO1+5VBgR/qaJahG2PNkYowzSZq6FP4JUymHAtVB7+P1bi5WS4VdjQpNghNBwq3qIwi6
         dAvtH1qZuegsghgZy3hEY068py27nC1i0HIwMPtEOBe3MRoBTF5TYpNm/E2oIj2yD9Jh
         o93h7jIW5Pg8k/0kLLEpAaKGMq1Px4NO95DpXKedlnqEmAo6ZP2fhOqqp3Ksn4N0Om/t
         t3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725162164; x=1725766964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6NKTz935L/d5xpf1Y+e0Uyg/R4JJQvjY282vlOGq7Q=;
        b=g8vyoH5G+XAOvHtwiMOIIGH6wZrlyXikbPM7UQXGIqsu+zb7ous7OlGQ/jzVt/WcoB
         TDd3DbvHotjWp+KZnW/s5xieaZf38t/8qdlGKmFljcQg5zJOnCPqBlvQtgi/ieIVqyB5
         7xWh6/wtaoSUrtQ7H9F0vc7esmxSjcM8pkwuG/6uEs7Wz++J7I6sB5h/0sk5QLDYe37h
         qooDkGtIeTUYpmDo/orA30hd3w5jZCc0eWn+cytI8+PSTAc7c4rREHKNCF6k2d6iGnxr
         lNJuj0POAhzqdzkP0hs0Drk9FZu/Udqgfai/wU2JoUsPJwPqK/vlI+Y6mxzkDNcLVucZ
         LvRg==
X-Gm-Message-State: AOJu0YxdndRSuHgY35G9Fuqm1saUPJnVFizjdjI9Gczhpf/WKqJIqV5r
	y418WqEBwb6e9kzAD0XXdQroms1f9kFT3K44lzzQhmaqk4o78Th+kno7EnmB4owW6MhPt2iiwLM
	we0xYGcpLo7PMGmT6ffcT7BXP5yc=
X-Google-Smtp-Source: AGHT+IFU/jqk3/5I6dyyQLkd1yJMuf03xN5+CuSHz8GFIIhf9jwgqMxVH02fFofLd9+xnsqd0+M41l/Ce25NzMzWn74=
X-Received: by 2002:a05:6512:ba4:b0:533:4722:ebb0 with SMTP id
 2adb3069b0e04-53546afa222mr4996149e87.6.1725162164092; Sat, 31 Aug 2024
 20:42:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901014734.141366-1-pc@manguebit.com>
In-Reply-To: <20240901014734.141366-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 22:42:33 -0500
Message-ID: <CAH2r5mtKKphsebo9Qy4FmOXzAbx=zXdx0otMYE_T5ijqq5KuMg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix hang in wait_for_response() for negproto
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Rickard Andersson <rickaran@axis.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

when I tried this - it took much longer than expected to time out.
How long do you expect mount to hang with your patch?

On Sat, Aug 31, 2024 at 8:47=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Call cifs_reconnect() to wake up processes waiting on negotiate
> protocol to handle the case where server abruptly shut down and had no
> chance to properly close the socket.
>
> Simple reproducer:
>
>   ssh 192.168.2.100 pkill -STOP smbd
>   mount.cifs //192.168.2.100/test /mnt -o ... [never returns]
>
> Cc: Rickard Andersson <rickaran@axis.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/connect.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index c1c14274930a..e004b515e321 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -656,6 +656,19 @@ allocate_buffers(struct TCP_Server_Info *server)
>  static bool
>  server_unresponsive(struct TCP_Server_Info *server)
>  {
> +       /*
> +        * If we're in the process of mounting a share or reconnecting a =
session
> +        * and the server abruptly shut down (e.g. socket wasn't closed p=
roperly),
> +        * wait for at least an echo interval (+7s from rcvtimeo) when at=
tempting
> +        * to negotiate protocol.
> +        */
> +       spin_lock(&server->srv_lock);
> +       if (server->tcpStatus =3D=3D CifsInNegotiate &&
> +           time_after(jiffies, server->lstrp + server->echo_interval)) {
> +               spin_unlock(&server->srv_lock);
> +               cifs_reconnect(server, false);
> +               return true;
> +       }
>         /*
>          * We need to wait 3 echo intervals to make sure we handle such
>          * situations right:
> @@ -667,7 +680,6 @@ server_unresponsive(struct TCP_Server_Info *server)
>          * 65s kernel_recvmsg times out, and we see that we haven't gotte=
n
>          *     a response in >60s.
>          */
> -       spin_lock(&server->srv_lock);
>         if ((server->tcpStatus =3D=3D CifsGood ||
>             server->tcpStatus =3D=3D CifsNeedNegotiate) &&
>             (!server->ops->can_echo || server->ops->can_echo(server)) &&
> --
> 2.46.0
>


--=20
Thanks,

Steve
