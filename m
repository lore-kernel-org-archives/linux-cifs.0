Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8C8286D57
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 23:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773273127; cv=pass; b=EogZiCadWNi4AYJS89xr5p52UNOBTkhHiK66miikk2T2mfDi11lzT8Sgosl3s+zcqKfQmo9mOXDPU7aUT9VrWwRrEMM39NhtKUM6NnfHx3pVWmrZYZfqd91+8kb7QzD/9AXkd8m3aVVXn3ox7a/tWsnn1wxVCBDo9Ew5YdtvOFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773273127; c=relaxed/simple;
	bh=aIkffOjGqTfw8EYv0ooqwQA2XrSIDdmpDM/eDv2AoHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qn0bAcu9dKMHGEZau+fRZlJJlbVwsPc+hCU45Oa41/f94CKIDsIJcu8nRZMMAiCw+IusLVXkgFjUb0dpakIfDSlwHLMS0FSpGBuHPJK8VMh1a3kTdEtIntpp2dDsdXcsF1Ftle1jCg5Vz7JmSrGv6den/34fFkK9AcnQdK7NVug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOX1nlE7; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOX1nlE7"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89a018cbbf8so20441836d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773273125; cv=none;
        d=google.com; s=arc-20240605;
        b=QUKndZLs5ZL4qH/93/fFBjQAchTbRX6vMcCqeo5GbfcX7TFXBrIGzIg96+KqMfWTCC
         f0pX0yS9XxOzBve900yTj+fVl2Uz2D96lBrYqnOh++1mFtgxymQ5WUUq8fF/q0zNWahL
         TCcsf3ShyktkTG+cmOiCxMRdN7Gm6DmJtsfeL3M/GCMDzPYbhb9jX1rGzUpC+Cmfnkjz
         NmY202xhuTo+v780jNlpvTsYAj43CX5qMSP75zYtBDCXqbAe+eOdYdP8KugKTgVPyAvc
         ASMSabA6fDvHo3lIBuRZZoBwi4hf+v0kZaZxKx0AIFQubsVegCyUzgVBqTz4tDH4OxTt
         kdzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aak02bl+tOxupaPAiu+YapXXnDf1p18gRXzhDpE7U48=;
        fh=i7T/fe869XmcdGV6Q/8XPyeXiErX5esmf/V3ZtnCP30=;
        b=AuTFxoBs1VaZU1+Jv2oBgbcUK4Ny63LllfMv0ryoUXacTJE7pFOjwxMwy5Ik7LEf6R
         HyiqnMX+2I/8D6qNGgaRnuGNeFSo4mt+kWg7RVZHZ+mS+vzzUYnL8TBQQXr9Szl4Apig
         Qqk4ub0Xy7/vcGrNNewgAobAD4MIFm2AyjsbFHkm68eNSYZcn1LLOq74L2dJPldq3IEu
         cbp3jLJ/61065kKD/ZR2iRP5eiTyUz4VsudfZcwPqTAv55UHRiXfMbenFr1wn9/qlNIy
         4rBAGYYm+GAhDWJP0nzPhOEWE9lRz+LdL+TJhMT4yadigTBFJ3G7I+5CFGfQ8Ek7dumI
         3wcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773273125; x=1773877925; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aak02bl+tOxupaPAiu+YapXXnDf1p18gRXzhDpE7U48=;
        b=SOX1nlE7kL75LYKij7m7KC2G7WWBxuG6wUIQrhxHEk9+9iVB+VE9jjsVBJDGlB6PYn
         X5NHPQ+DIjUQ1WJ2rhS2u1AxkqDO8riy/mXjafSo8hibc6gEUQlvXxqm5Msvf0H4zyMg
         b1e0fBKDEEwFHOcxSTNjVF1KeDwOpBdgtRbMFv9E6CKFAJE1TmkCOkKp/zryEr7Gu1OH
         KQZ1vGpARLOlHl4An7/sMKZlNzInIWDVv79r9QxgJNEINAie/gWTJ1/wlvFRrGpin80o
         uWM/HFvYdXuUmxWwT2bGTS+QSqwQhqsfoSFxOBCzGxqfVolrAi8CFneDXWBDGYqm/hEF
         t1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773273125; x=1773877925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aak02bl+tOxupaPAiu+YapXXnDf1p18gRXzhDpE7U48=;
        b=EoruHb8OZDqo2h103pFcqLWUNdXhU5dFSmUf5GP6lzK8/o23rirKz6A70hzoMGVfJ/
         6ch6pmL+5ldn4FDykyDe7rhmslVRhnI7pw42H6poX8Yd52MoppfNY41kRIodTfh0ABss
         VIsUPOTfSZXPhse2+9sokhKnAQf1H5g6IqPVWYi9qHjkyg1Vjt/t6nrfrxL0GblbmEnz
         rUfG/vdriOXojC1aTGVswO35IaeYvN453BAH6ca4Fx7tajyS+0qWFj9X8g+rZQNRmnMQ
         o2tIdYlEH4nrkX4PWEc3zQ0/EXB8yhF4p83cim/5kf9TsrHTZpD5xwH1YdzUrMg9UCcU
         /OMA==
X-Forwarded-Encrypted: i=1; AJvYcCVJQxTr7P3AaZ5hkcPm8BaCyBojng5NUGESh6jGJW7yM2DOE4ElmZI5PUuZtkqnMUqGgqdQTf1TmMeS@vger.kernel.org
X-Gm-Message-State: AOJu0YyYraE7aOfKP1XYuMYRaYqAYUPvLAjk3eZYAuQVVUPsbe7ln6y9
	Iypot5ojJHoCNwJypmk9K4ReSrw9bm7iseb/qQ3J4XHSuK+44CTk1ULZqS/vLg9ieOwjhy0TCkh
	LKy5xVnDuv1Ob4odhgwaRna3pyV9vi5w=
X-Gm-Gg: ATEYQzyqLF03OFVzOMNvMlWsX5iojfjm6yRqd524qqH2o2LlVIVrxlAxXtCxkB6KAOg
	0VzwdH/j/8fTYcfsuWU6SBkdmxtZdXkfM/hhQEdEkU6MvR/CG+r7+O4KPfIRpMnakJvdBeH8oI6
	nGN4Zwrx1rud0b7evrBMQxdyKTI6PLVqPbAaEjDjnW0zHBXStDhBug/rCVcPs0JaJRHuzFf5dDX
	Yd1mlQ96Fb1CPdi0kTr0CT6+q0WRMNtEPWKCEZWjCvdiTvzy6mOyBrnx926ERprkJTON7ZZYr8W
	bvfP/XOChPzH9d/xZFeHjcsUZyv0P3Yp/2/11qZJ9uLVuaJhp23etlmnGVrO1ZcDiUozL9Ikir/
	mh1o6gira4FTHl56ItCwXRqPAkyRIQAXyPLPbvghP5bz5yrMV+AAeoypjhqN6ezlhIG+l2X75UW
	DegVAnFZp7hch0c2gqgI0B
X-Received: by 2002:a05:6214:19c9:b0:89a:77b:837e with SMTP id
 6a1803df08f44-89a729d8f3emr26275396d6.6.1773273125385; Wed, 11 Mar 2026
 16:52:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311231723.751558-1-henrique.carvalho@suse.com>
In-Reply-To: <20260311231723.751558-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Mar 2026 18:51:53 -0500
X-Gm-Features: AaiRm52w23mPBC3G4ypnbWAzbkKeH8taEUOrvVOe6GbIGt5Bj-pX_iL9f9xwLwU
Message-ID: <CAH2r5mtsdSJBZ=b5ABm=Gq4sfakb7ZXrx0N7AF0_1TTkVqn6Zg@mail.gmail.com>
Subject: Re: [PATCH v3] smb: client: fix iface port assignment in parse_server_interfaces
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org, stable@vger.kernel.org, 
	"Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated in cifs-2.6.git for-next

On Wed, Mar 11, 2026 at 6:17=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> parse_server_interfaces() initializes interface socket addresses with
> CIFS_PORT. When the mount uses a non-default port this overwrites the
> configured destination port.
>
> Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr=
,
> causing reconnect attempts to use the wrong port after server interface
> updates.
>
> Use the existing port from server->dstaddr instead.
>
> Cc: stable@vger.kernel.org
> Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
> Tested-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> v2 -> v3:
> - add spin_lock around server->dstaddr access
> v1 -> v2:
> - read the port once from server->dstaddr before parsing iface entries
>   and considering *server* ss_family
> - update the commit message to describe the fix more clearly
> - adjust the Fixes tag to fe856be475f7 ("CIFS: parse and store info on if=
ace queries"),
>   as the later commit only exposed the bug rather than introducing it
>
>
>  fs/smb/client/smb2ops.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 7f2d3459cbf9..612057318de2 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -628,6 +628,7 @@ parse_server_interfaces(struct network_interface_info=
_ioctl_rsp *buf,
>         struct smb_sockaddr_in6 *p6;
>         struct cifs_server_iface *info =3D NULL, *iface =3D NULL, *niface=
 =3D NULL;
>         struct cifs_server_iface tmp_iface;
> +       __be16 port;
>         ssize_t bytes_left;
>         size_t next =3D 0;
>         int nb_iface =3D 0;
> @@ -662,6 +663,15 @@ parse_server_interfaces(struct network_interface_inf=
o_ioctl_rsp *buf,
>                 goto out;
>         }
>
> +       spin_lock(&ses->server->srv_lock);
> +       if (ses->server->dstaddr.ss_family =3D=3D AF_INET)
> +               port =3D ((struct sockaddr_in *)&ses->server->dstaddr)->s=
in_port;
> +       else if (ses->server->dstaddr.ss_family =3D=3D AF_INET6)
> +               port =3D ((struct sockaddr_in6 *)&ses->server->dstaddr)->=
sin6_port;
> +       else
> +               port =3D cpu_to_be16(CIFS_PORT);
> +       spin_unlock(&ses->server->srv_lock);
> +
>         while (bytes_left >=3D (ssize_t)sizeof(*p)) {
>                 memset(&tmp_iface, 0, sizeof(tmp_iface));
>                 /* default to 1Gbps when link speed is unset */
> @@ -682,7 +692,7 @@ parse_server_interfaces(struct network_interface_info=
_ioctl_rsp *buf,
>                         memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
>
>                         /* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore the=
se */
> -                       addr4->sin_port =3D cpu_to_be16(CIFS_PORT);
> +                       addr4->sin_port =3D port;
>
>                         cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
>                                  &addr4->sin_addr);
> @@ -696,7 +706,7 @@ parse_server_interfaces(struct network_interface_info=
_ioctl_rsp *buf,
>                         /* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore the=
se */
>                         addr6->sin6_flowinfo =3D 0;
>                         addr6->sin6_scope_id =3D 0;
> -                       addr6->sin6_port =3D cpu_to_be16(CIFS_PORT);
> +                       addr6->sin6_port =3D port;
>
>                         cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
>                                  &addr6->sin6_addr);
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
