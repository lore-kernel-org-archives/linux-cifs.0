Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE80E17C
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 04:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725165451; cv=none; b=r4r0q+3zHfdHh1S+VAlAUXdgJzKd1/q7Xf8mzfE0SW+LGr1muhSs2cyeJn/nzN/s3aPQuyippdkt5Xcnleo4ke576a8rVwmFdOSVALslIp9cGdTu4Ny+XOxW7JBVhlxkXhHTX63z+xhSxXnSbO/KYWlIo/7hJlhnfl2j2xP1nEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725165451; c=relaxed/simple;
	bh=EoWSHSBS1dfDF7vLdULCHWnf9sQKbTN+9t1kZT5kg1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qzv9tUQZCFRKpRKIz3Yr0cXYASrI7eVC3wm1rK+14anx2ybAENGAPm6ukxi4qE8xuOky3Qf/7bGLp9j+4S271GP+kG+RHCgs/MTo5jiFr9K6Gk4bRJi2xxjMrDib0NVM6Xmh9rg5+foxkWbQB2dqtHcfDPmV4RuPMB6WLCEtKIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIDhYq6d; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIDhYq6d"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5343e75c642so4162358e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 31 Aug 2024 21:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725165448; x=1725770248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FahsIAj/T8MbJFKRGKBNQyVhtkRbnetJXm9FP9CRTbs=;
        b=CIDhYq6dbAgKqoM0qWbd2ul9QfaT00v6lh9bULzb3hYY8ir3drxZcrd5sS2rf3d/Dh
         r5oWxtCFGJmg9YzpM37fZT0TnzQAR6Mc3limwLCClw8LjNhJl0hgbfd6OlqhZuF3wl36
         HtRY6ASE77Dr2+VA9wYLGUmuuhozEw+/r+YjAvNwnyp2bfr6BSUdIxCsTOS1/XuCSjox
         EZNLKsG6hEnDF0gppJF3P3SXdFMVEwEtTiIT5bdL9Vo6lAIzMZ2y6HcyKVCuPn2wSIhU
         6fbVJ+RUE6hJns5s9iYT1t0h15VaVBQDIqAeQxMY3IDL/bpILXnza2yJCBP7FQ9ChWp1
         F10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725165448; x=1725770248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FahsIAj/T8MbJFKRGKBNQyVhtkRbnetJXm9FP9CRTbs=;
        b=ABHsBwjHU3dSsM+/YKL0tWcmHh00riXS3jDUbhXdkG9/GuvlVkcC/yH7MGwe1kNhSc
         wN7koc0JDX8j0qIHfAfL/h1NpLN88ehKJh/Ab0w6xzRjRFnEv8jhsgJcGu29VIIbUBva
         WT6Me14g1ZEL7mFnhxj8AnjPmbo3AMqkNI6Xwelk9G1XhyMHR6BTlSSeOWB5c7d8nP06
         vqs3PFWscp2WrMK6pDRQta5kyLBioQDOkOJZBC1K0Elnwq6NzU6DhnV+PhXrzYCMGKNk
         Y+P9wswhJdY0W5jhD5ZuBHsFFoBWqkK7jqS1HFs5Yt60iL1zwZU7k52c9wF7mgmZnTFn
         tgLQ==
X-Gm-Message-State: AOJu0YzrFUDrATxbk5HCNfRgULZqNxOaBuZTIe+pFyuN2rF7sk7Jxl9Y
	Odxoqml349zuYBungoU9pNAn0QBpxTzKk4dWPlp0Hq/of8oUOsXQNHRwVlxtTEa25/mMMqBXYD/
	NXRapCF7VmF/pMH02zJhldP0B0RkECI/HVzY=
X-Google-Smtp-Source: AGHT+IEx3HDChuesQhNZ7jKZ8J3cn/jmimR+I9xrIqq1n8LPJKLlPJg8RY/RZROWaD2arqqbY2NzwaqIsTJXN6zinGs=
X-Received: by 2002:a05:6512:1281:b0:52e:76e8:e18e with SMTP id
 2adb3069b0e04-53546afaf96mr3436699e87.7.1725165447547; Sat, 31 Aug 2024
 21:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901014734.141366-1-pc@manguebit.com>
In-Reply-To: <20240901014734.141366-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 23:37:16 -0500
Message-ID: <CAH2r5mvw-sdzD7Z_J9tdDaxd0feE49VHyoRsiZaxQVVSALFLXw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix hang in wait_for_response() for negproto
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Rickard Andersson <rickaran@axis.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged to cifs-2.6.git for-next pending testing and
additional review

I am a little worried that the timeout is too long though (for mount
to fail in your example)

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
