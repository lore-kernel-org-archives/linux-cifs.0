Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85CB22655B
	for <linux-cifs@vger.kernel.org>; Sat, 11 Oct 2025 20:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760212973; cv=none; b=M0Oyi8wrLDAryB6RvqwOml9lAON7B/Ptx2C2QaOt0my/kIPHgiSJnr4nO5dToRNH9deyac8xk4iUJrOvoTM9XL+56g9fgN40fU0vRIYmIYifcgrwWZH2s7JE29QkCf3JXv1ooNvlmc4x+v5iD135xqAJYR5qwBS6bvvuTi+P7hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760212973; c=relaxed/simple;
	bh=uKELvK+Pabr7Cacwb8UIBERYWif8VOC/Fn/heHRHgdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m6+ud+4yLAYFoA5gZfm3rHHvhPKCXgLLz9PcnHUNUxMmDrWkTH93TgI1DSK3WS0OoRfx0F+fjUw93viQTBZDKtakpv7N5AFwPC2/yQ8SNU2Y2waHSOJeaebs/05iQF3UASGnm2uGTIofcFN4I/UJyCZDmXWGkzvpYkcUypTqLE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yw7pWgLa; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yw7pWgLa"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-87a0801ba1aso477003085a.2
        for <linux-cifs@vger.kernel.org>; Sat, 11 Oct 2025 13:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760212970; x=1760817770; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xkr5Es7W1sfU77GvysO3I+d49t0a9ilRQJudJAibtUM=;
        b=Yw7pWgLaQoD10kVLOmX/9Hr2IE20ZUZMQINXnfAqf5653lRq2V/QNH2DGzWXiwbq2z
         1D9CmNHRS4gLUc+L8MMIsQy5uVN+eTob1v9MzQlj9IGc4DQCkrOy3Oz3WiWGCKGDZxjV
         qqPloWwMeWiH1Bhy5BI/n9kh9HUJ7aOvVPf5WMcgcCmR60MDp1jZ1MkfswXv0vWxSMyl
         RLxTN4zTqlnlIe/WBSgLHJR9xOh+H4iswlDnS0gV44stp7Auvs9hvad4Sp/55dbbrME4
         vX6FqlNv4wClzVt99z9CJE2JAIC/MY+ao2B7P8qIWa7oGCFPTZXuWuJagfXOPPoFXTkR
         2nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760212970; x=1760817770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkr5Es7W1sfU77GvysO3I+d49t0a9ilRQJudJAibtUM=;
        b=nb55HK4eIjD02ET2CkF8ombylwsZWmjZCz0lPaDcaMqG8m6DhS5CHQcVZAWzMM2MTA
         iow9Y22Y7lagxyMr3V7Yj8UZR2KqXr1AI0vTPJY+3WkQr6I+AaF4aKBLgHso487dQvNX
         ed0eRQjs7vOqCv8H9FqCYdfziJr1JY90I4onPeeqwTx4ABm0POir6lLfNtG2S6P6tCpQ
         95ttXzIwVAO6wiDRvlRX+f/FjPHl+9Xn7hl35XHwyFL+MSqIBbs7+NZMsuDZW/6A1FIq
         HEsj8YNyNQRs4WDz+Hzp8b1149FtIPsMCJorgLCG6vCxGruEebwrd8IVDI9/MkYdARKM
         xwjw==
X-Gm-Message-State: AOJu0YzC0A/o3DeHm7cOwTfdwrDQnUfvbjYnS6UzxOKB/gyZ4UYeSttE
	lO4tSg73Knl5io2ak1j0Yv5fHOxUm13AR5Vbdxh/lNEs5FMYz4tQJLCxFwU/AHcYaYOtv2eZPRt
	q8sVBWjq4FmonD/BWIf0WmJRPH3Diw+4=
X-Gm-Gg: ASbGncuIY2hBHDCi0sIkZRUna4EMSqO5LTRsocULg4VCIbIz5bimrhKP4Gnn69pVzPy
	pZc5ePAHA/WWnN8A3yhI408tYskwCbYyRH6zIAcA6FDybrD+Tg/PkA4BkLfCn5KZTfptmvgdAUM
	vIQD/wqmIDhUN3lsvV/GZgtXQy6RWZgnSzyNhWNw4JOvOajxmKOlRhadZZBIa+4lc0wEMO/I9Kb
	qGvXWBwjGdhZ5xQSDPKvo4t7TyyNRxhr6OATeC0LPOh5ruBTRe4mCjOg+YHMMjq4TqAOhf+ue6S
	88w5ccnsN2GWdorNhsqqT0mpnlK5HmIcmphr42muEor5+9AN1ur8utQ9lcieajtamWU79Ne80Wh
	zT+Gx0yI0YU01CeeHeI+HwdW8CfC8Pr6EIVOMe+2TX+r8RwzAznM=
X-Google-Smtp-Source: AGHT+IG9ZCiwfq5KyR/1TeCl3i0cP2OQ4leD6REdC5/3Qk1b9iGVKiA0Gxr/3psvpoZZ40crdSe1lNPJ/iiBnZaSH1U=
X-Received: by 2002:ac8:7e96:0:b0:4e0:a9d6:d554 with SMTP id
 d75a77b69052e-4e6ead5427emr236273121cf.38.1760212970368; Sat, 11 Oct 2025
 13:02:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <10e2a3a5-e109-44b5-ba3c-3e8c40d76361@web.de>
In-Reply-To: <10e2a3a5-e109-44b5-ba3c-3e8c40d76361@web.de>
From: Steve French <smfrench@gmail.com>
Date: Sat, 11 Oct 2025 15:02:38 -0500
X-Gm-Features: AS18NWDvFK4gyGSPs9eyGmSKOV3bV8TQqhZdaEEWV_hSRnuKNvbTBU9D0yth8t4
Message-ID: <CAH2r5muxz0q6E+8NQiAxDRgWRfbwjsRN9fnoQXjyV_u9WXFh-w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Omit one redundant variable assignment in cifs_xattr_set()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Bharath SM <bharathsm@microsoft.com>, Boris Protopopov <bprotopopov@hotmail.com>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Fri, Oct 10, 2025 at 7:56=E2=80=AFAM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 10 Oct 2025 14:48:13 +0200
>
> The local variable =E2=80=9Crc=E2=80=9D is assigned a value in an if bran=
ch without
> using it before it is reassigned there.
> Thus delete this assignment statement.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/client/xattr.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
> index b88fa04f5792..029910d56c22 100644
> --- a/fs/smb/client/xattr.c
> +++ b/fs/smb/client/xattr.c
> @@ -178,7 +178,6 @@ static int cifs_xattr_set(const struct xattr_handler =
*handler,
>                         memcpy(pacl, value, size);
>                         if (pTcon->ses->server->ops->set_acl) {
>                                 int aclflags =3D 0;
> -                               rc =3D 0;
>
>                                 switch (handler->flags) {
>                                 case XATTR_CIFS_NTSD_FULL:
> --
> 2.51.0
>
>


--=20
Thanks,

Steve
