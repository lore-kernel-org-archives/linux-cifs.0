Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E25C1CEADB
	for <linux-cifs@vger.kernel.org>; Wed, 19 Mar 2025 23:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742426405; cv=none; b=FR7NnzSHgyXjOVXs5iEwpnPxONtKlzoLGfrfbKs1dhQVnsFIE9l5lki2gGFDMNqdFxpVcP689JIXdQhAEeNZOvT5SWt/lL+KlmBkjoB+KeqLN7xlaS/tgKJQKaQvZvuAKYWqC0b/PX/AR3VAMigCB8SSpENoNF/EOda/3hZtVhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742426405; c=relaxed/simple;
	bh=iMAeC1Z/yoz3OQeicjPl98bnXp2TlwyzfvzR/npQNxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pcj58tgrTGS25Cp62VOsCq3ri7I0Xq0MMcXHh15xNBa9uxeuvtFUr8Fb170+Ws9PxSGwEF20AhcrLXPvjqNIplLiYQVW5c/LS1/4FfwGhAWaJUhHjIRGsgYaSbgDzDuNeF3nAPUtBIkTO2LM6aOWcQ+L9hC6S7GfavcurM1Wag8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwKFQajK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwKFQajK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDC1C4CEE4
	for <linux-cifs@vger.kernel.org>; Wed, 19 Mar 2025 23:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742426404;
	bh=iMAeC1Z/yoz3OQeicjPl98bnXp2TlwyzfvzR/npQNxY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nwKFQajKk3Lf7YxjwSGsxo2uZdxYkOi+7xLEEvx774WCbRqcyvXinHuhstTSDRonN
	 dHrEZs9WbLVUjN0MwRGmbOGvWNjKoAPfZnntZEDm4k9Z5/DtsVryJOxtWyaTVUJYrK
	 0ldUTFPB37KQBZnIyaAEvoAqqg5Ox9hAmn8Eakmwmn7RjjdcLkQJD2cS0NIMUoVQmG
	 ed+6Y9at/1oN9PWzb8pcz60OGiOPJuH0my5a1hU+LqIsI16npLojFKg++pbt6/iYaE
	 Aqft+P8bAc24I/yez1w9abn3KkqTaBBDTXyyWrh+U9sVXW63l4HgXQrj3d8A0nmh64
	 +ihJk6l6VB1tg==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2a9ef75a20dso189666fac.2
        for <linux-cifs@vger.kernel.org>; Wed, 19 Mar 2025 16:20:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YyzbYRFIn4OYa3ioKw5QTORr1/GTS2FD2ydOkPIo26fUqaInbh0
	piKYPi2fxSRqGJKtKklvAcPbSrrWfK3uvloHdkfuN0z+HyWl+8EO7DzN8daKE3Yd/4N4mMA5tx+
	TwFXO8O3ySP3VfKEo7A0nzEDP2Hc=
X-Google-Smtp-Source: AGHT+IGdafFHrQBxEmYgI8EPxM99Rk2OkPMWgu4N1aAznOY04k/U87dBVYPPDb01+i2XJVaMK5ieJlNIi/1L9sUMQzI=
X-Received: by 2002:a05:6870:d8c9:b0:2c2:37d2:c1d1 with SMTP id
 586e51a60fabf-2c7456fe684mr3542962fac.26.1742426403856; Wed, 19 Mar 2025
 16:20:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318123826.5406-1-linkinjeon@kernel.org> <20250319091723.GI1322339@unreal>
In-Reply-To: <20250319091723.GI1322339@unreal>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Mar 2025 08:19:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_B08gXyUe1XG1+TwAAAUhCeYnrEkcu51Q-TWX7t7iYbg@mail.gmail.com>
X-Gm-Features: AQ5f1JqNeW6BvPDk6bQkLafk4rH0R45kPBsj68rHKz8eDxRzbugWew4rEvmn9qw
Message-ID: <CAKYAXd_B08gXyUe1XG1+TwAAAUhCeYnrEkcu51Q-TWX7t7iYbg@mail.gmail.com>
Subject: Re: [PATCH] Revert "ksmbd: fix missing RDMA-capable flag for IPoIB
 device in ksmbd_rdma_capable_netdev()"
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, atteh.mailbox@gmail.com, 
	Kangjing Huang <huangkangjing@gmail.com>, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2025 at 6:17=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Tue, Mar 18, 2025 at 09:38:26PM +0900, Namjae Jeon wrote:
> > This reverts commit ecce70cf17d91c3dd87a0c4ea00b2d1387729701.
> >
> > Revert the GUID trick code causing the layering violation.
> > I will try to allow the users to turn RDMA-capable on/off via sysfs lat=
er
> >
> > Cc: Kangjing Huang <huangkangjing@gmail.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/smb/server/transport_rdma.c | 40 +++++++++-------------------------
> >  1 file changed, 10 insertions(+), 30 deletions(-)
> >
> > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_r=
dma.c
> > index 1b9f3aee8b4b..9837a41641ce 100644
> > --- a/fs/smb/server/transport_rdma.c
> > +++ b/fs/smb/server/transport_rdma.c
> > @@ -2142,7 +2142,8 @@ static int smb_direct_ib_client_add(struct ib_dev=
ice *ib_dev)
> >       if (ib_dev->node_type !=3D RDMA_NODE_IB_CA)
> >               smb_direct_port =3D SMB_DIRECT_PORT_IWARP;
> >
> > -     if (!rdma_frwr_is_supported(&ib_dev->attrs))
> > +     if (!ib_dev->ops.get_netdev ||
> > +         !rdma_frwr_is_supported(&ib_dev->attrs))
>
> <...>
>
> > +                     ndev =3D smb_dev->ib_dev->ops.get_netdev(smb_dev-=
>ib_dev,
> > +                                                            i + 1);
>
> Can you please use ib_device_get_netdev()?
> ULPs are not supposed to call to ops.* directly.
Okay, I will do that in another patch.

Thanks!
>
> Thanks
