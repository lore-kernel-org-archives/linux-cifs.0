Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8AB12B69
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atmke36H"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-50e80d14404so2984730e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 09:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703869368; x=1704474168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isTzEV5UE0pjGK+XqZlgHESWnrYMvY1ZoOVUhuCF5QY=;
        b=atmke36H8dSaJF7fpXkgKOcuWn27nQH+migSbZkE14P0HaSZGL/PygbCm+BSh57v4z
         L5m0+yosJb6NOlqyWcYbKZ7xNKyzG9eJnmL0cEzxaOX760fBqippWxDKsMU6QA0kbkpK
         /ZvZUfRxAmzK2CzlB01NbpCCvniPGIbpgu74YWEhAkkYRESs3+mXUjhKNoB9noJ6/zU6
         CxCQl6adwnczxdoZCyjLTOgPqx631I3Yw8olw3EBCToCfjsg3tsegrkwQwVySkCLCK6u
         EAH5YmfDCDa0oPDK/nYIxGlu5Fnhhc229x2nuSg9uUZysuboaoXWE/nN75q4lU7XNOsG
         pF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703869368; x=1704474168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=isTzEV5UE0pjGK+XqZlgHESWnrYMvY1ZoOVUhuCF5QY=;
        b=kCBFVxFsEvUFO7MfgMbaXQNhnTyrX77EPA1F5dtHeXRLa15lzePavd4pxabwIJLWis
         Y4rpgIb2IKEtqQLycx4tVzyr5L0RHzIz3WxWeFlzCtpJSuSQkSc1FVOD64FOu6jkheHv
         80ThvhyTCyZEdWdAEME3UhVjbOr7dsMdRff/QumKd4wPDfQLvgU8Lz4NI9txQW+W6ZCJ
         y/T8Lhk3r9VIzR9XCnp4AKA0WSC+6JYj23ZfFaJTYCaZHTehGqVoH2ptsznRM4iTVjlD
         WOCYVYxNE0LeBBMR//bsvuCRJo0QuYS0ISxp8BTiVDSRAfSlU5qUh4OjQsYZ2Jm4C7ZD
         KgjA==
X-Gm-Message-State: AOJu0YyPecSowlkya2pVwFcABmYCPVxJreXPAvkJUlhbZPh1SpW1yBD2
	IsAPuuBmDRJYq4b2RIer7KFNGG1j4Qk2ZPPKsdIlQbJG
X-Google-Smtp-Source: AGHT+IEP9VusOUBXhRIOTL2f+DSfBqxzOmcXuBqP77ImBbxr31CtmKYDHNp/JCl6gQ5SPpJSSz6xJOoE0ddjw/DYiAU=
X-Received: by 2002:a05:6512:1388:b0:50e:74f3:c320 with SMTP id
 fc8-20020a056512138800b0050e74f3c320mr6230703lfb.21.1703869367394; Fri, 29
 Dec 2023 09:02:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229111618.38887-1-sprasad@microsoft.com> <20231229111618.38887-3-sprasad@microsoft.com>
In-Reply-To: <20231229111618.38887-3-sprasad@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 29 Dec 2023 22:32:36 +0530
Message-ID: <CANT5p=reagZz5yL-3wutgyk0ePR=eRLkLqt3DYhW=kTXuvOXfQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: cifs_pick_channel should skip unhealthy channels
To: smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2023 at 4:46=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> cifs_pick_channel does not take into account the current
> state of the channel today. As a result, if some channels
> are unhealthy, they could still get picked, resulting
> in unnecessary errors.
>
> This change checks the channel transport status before
> making the choice. If all channels are unhealthy, the
> primary channel will be returned anyway.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/transport.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 4f717ad7c21b..f8e6636e90a3 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -1026,6 +1026,19 @@ struct TCP_Server_Info *cifs_pick_channel(struct c=
ifs_ses *ses)
>                 if (!server || server->terminate)
>                         continue;
>
> +               /*
> +                * do not pick a channel that's not healthy.
> +                * if all channels are unhealthy, we'll use
> +                * the primary channel
> +                */
> +               spin_lock(&server->srv_lock);
> +               if (server->tcpStatus !=3D CifsNew &&
> +                   server->tcpStatus !=3D CifsGood) {
> +                       spin_unlock(&server->srv_lock);
> +                       continue;
> +               }
> +               spin_unlock(&server->srv_lock);
> +
>                 /*
>                  * strictly speaking, we should pick up req_lock to read
>                  * server->in_flight. But it shouldn't matter much here i=
f we
> --
> 2.34.1
>
Please skip this patch. I'll submit a revised patch next week.

--=20
Regards,
Shyam
