Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91B49652;
	Mon,  9 Dec 2024 21:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733779547; cv=none; b=GNQUfQWw32Ty9Ot1E12Inj50k2aiVxueUA/u5guGqTDtnT4mC2RUgb4xbEy6A7kR2yFZJIZwAYREp6JBRNvSfGE30obYnApWpmnWxZECKj/auadBHgs0JuQFckdMSjBQcTLMoATF/+llAQKVKM0lB+sBVJaaBe6e7TjZvh6mNNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733779547; c=relaxed/simple;
	bh=g5HFjiOZUjF/D90uSjk0XG5lsmwTIwA2Yi2NkConJ/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frAAmoM8epl7H0V3uJUYImSzu6BrZp4y5hlYj0wYY+Lj2nG5A6t0RkrRJ6Dx43uYsSYVFjUMKbNWTNNL4AZZjmgdKJ3XvdOjdEqcNLpqVpJYCLYSF5jRwPx9s1QeUu7xoXZNQiWlVxdDLqQpoZkUoY9RJjIT2FXZ844xlrwQrVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Og14MM06; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Og14MM06"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53ffaaeeb76so2127075e87.0;
        Mon, 09 Dec 2024 13:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733779544; x=1734384344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53NmjpME1xHX7DX/jgKMbQey7g7GeYI01hf4hjnj9q4=;
        b=Og14MM06ml3LmxMP76UUbdvP8N/cMYwHnkWhEh3Oi3jhZwzPsRCihkzgGJdvx+Rfbp
         KD711huIWNhTxRZMNrHYjKeKtG1C87AL4TcT3E9MfOOwP/+HE3EUwK89kpOmEaKaquVI
         1aW/11799a2kdlMXiCU31xyTURCGRf8026ddXLbNIomSKujPmevmGNUhS17f+mrXI5sb
         gfUef/fj4/2foFWTUlSfxZaIQ1F565Z0UyfEpEKnmWQrhRW5vrNMTZkTzHBUps4LeM7+
         JuINRL1gzAikwhPAGYcM8HL/a6PibiROgJBSBQCTe60nhBsZfMocyTIvt+bcSwW0bHeS
         yywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733779544; x=1734384344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53NmjpME1xHX7DX/jgKMbQey7g7GeYI01hf4hjnj9q4=;
        b=Z/02yFU29/kXXdlL4eAUbMGQFlT2TdkTmdmGnTU6UcsJ2WvdI+Vo8TgldMimborSru
         1MaKmfAyj4K1XsfvXdogWX183ffRNKCM2Ql+JHzHmXdF5cGZiuJNnxQeAdwLpYRQJqSl
         R57Ibp69GU+LQfvDHrkVjcdnqUk5yQad8UEQe5l0JFs4EhBs6lvq4ZFW26sLhqVva1tB
         tPqQpWqQUnxYh4yb/s8okN695XuPxJS+fSikxNhQsWV+CePFD+WMpKWpPvTppldYZeTL
         FVOsJyTa9wNPcdvBkmnMu2uYwGMSOSKt0L4nUnponI1FPFz11RaXzPvt+RdEJnSmGP5a
         7uXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZtln1G7p/6gLgGi8u843ocv7Q6kH+pGrenYfHLrc8lCBDjzAswIwOiC7szfm0a2l8CWohex6DzauU@vger.kernel.org, AJvYcCWx4HqBeFq/HIDyXwgRYGTTw8jUAHf7FFcKpVb54PvXqaf02wznbsPtIEm4HwA2Vy3MNZ0BEgrn+4Z0CFfY@vger.kernel.org
X-Gm-Message-State: AOJu0YxRtxt9tkOau9PFCJ1E/s2RLZoNGdW+heoaotMNDsDdRcvwaG0V
	474P+6cMio91k+hokHrZrh1cN5Z+Y5CqXXn4ua+4cyRkypgHFnJZFUeNg0E3grrGwMHWD9lldAp
	bvTOFSggjJmX0G3rayRMKwn86G2U=
X-Gm-Gg: ASbGncsuQi/mwVRWbN9XN8HS0AiiR+WMT9kMdMvzfBrN40g6WAYuCgLavHFACm5cnvw
	oaM+TWmM1Z1a7EMzvyV7rd8IptM+ObYaX+g5ptSUrWK1lYysbL2tMzeI7jbK4QArG
X-Google-Smtp-Source: AGHT+IHTDwqErjmIWofxz5/aGKnw+3l4AJ7nvW1mEqhxbKvkpvWY4PENkEagDjvrMk9CtW+nkydmoJbaUqhQmqrjCNY=
X-Received: by 2002:a05:6512:39c8:b0:53e:3804:579f with SMTP id
 2adb3069b0e04-53e38045800mr5583727e87.47.1733779542767; Mon, 09 Dec 2024
 13:25:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209110708.40045-2-thorsten.blum@linux.dev>
In-Reply-To: <20241209110708.40045-2-thorsten.blum@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Mon, 9 Dec 2024 15:25:31 -0600
Message-ID: <CAH2r5mvDEcu_-QkS=e-sUx3-_OAbz93P=pO7M-7B_aatKfRbrw@mail.gmail.com>
Subject: Re: [RESEND PATCH] cifs: Use str_yes_no() helper in cifs_ses_add_channel()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Dec 9, 2024 at 5:10=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.d=
ev> wrote:
>
> Remove hard-coded strings by using the str_yes_no() helper function.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/smb/client/sess.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 0bb77f9ec686..3306fb655136 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -488,11 +488,11 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>
>         if (iface->sockaddr.ss_family =3D=3D AF_INET)
>                 cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rd=
ma:%s ip:%pI4)\n",
> -                        ses, iface->speed, iface->rdma_capable ? "yes" :=
 "no",
> +                        ses, iface->speed, str_yes_no(iface->rdma_capabl=
e),
>                          &ipv4->sin_addr);
>         else
>                 cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rd=
ma:%s ip:%pI6)\n",
> -                        ses, iface->speed, iface->rdma_capable ? "yes" :=
 "no",
> +                        ses, iface->speed, str_yes_no(iface->rdma_capabl=
e),
>                          &ipv6->sin6_addr);
>
>         /*
> --
> 2.47.1
>
>


--=20
Thanks,

Steve
