Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573016;
	b=4CMtJ0cMLw5zy+bNrjJsK3xsQFG17DbSJLFyCd0I0w0Rrgu7gqYLyPxglcVWbYzwPpq+
	 Vb3csrSEzsaogEUYhFnSK7b4Kd/D7mXViQZU+J3TJqMVSJX1uLsEScdKyM2/lzoKOCDPu
	 fGqZKAkIyof64ADmZAVFwzLUOt/sreNGq7FzUAVEu3lTHMBSRkqnZyTmHx2Sd3OQPHuto
	 1JAF/n3mDUgLlWmyVlwy36UnyydZFwPZg1rO665w9RIAxNUKLMh9H8F8gNiRyx9zf9wPA
	 l0AejUY8Hao0d3az60lUtNeUonFvnli9nPONxGrWvz3PVaKALaKB3cBQRQaszl0qJQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573016;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SIf+wKLYHtIOa2fs6GA+xJQ9mhiGEJQi8Vfrtnjdw4w=;
	b=y8HG6C+CMNqix3ikgQxycr94SfrB7f6Zulw9HZNHi+vx8hNlKz65MfD/cP/fRL4oRtVZ
	 SMkIuXlLCS4P34RrozqJg88XUfX5V7zSiNlJyNdRkDsbJLFvaaqsmneq9nhtwuvvUS5h8
	 8MtU6R/JYlVN6F+0rhuEpzZB1sBdV1GQqbpALL7IIOg9HBqMSXQQ4zZ/B+BEskBWp2MOe
	 QuHmluv3eY6bNdf5O2SY2q/naZ8BChBF81pILHLVEiDpPLIlP4/8OWXlOHqvK8B/YTM0i
	 v01EJG6iCnwvkeBefas5lSo4vtoy/jMLVMWJ5PW4+x4Xw9XNvmXIqdq9bW0TFzfS9IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gU6KFtyX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26381606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 08:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gU6KFtyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34A1F000D0
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 08:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792573015;
	bh=SIf+wKLYHtIOa2fs6GA+xJQ9mhiGEJQi8Vfrtnjdw4w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gU6KFtyXA/eWF6UAj1J+fcVGy744HCQe+rorS9Y4zWwgTi+XXVuVhRzl7gHJyU8Oo
	 WoPzNGFmjKWUByO5sUlv0lOWWvTcIrKXRnIhp7kNi4V0FT8FumM3106eH7nNVlZGjd
	 csxLp9SE6sGldurxb7MLEOcmfvbGC5Q1WQJ+RjDvb8iJ8xgkMyDJNBVwcFOslyPMN7
	 2fQSxE1dabLQusZEVTD6PAGWE2kci7K+KnC/QtZpGjKIRdyUhEAETu+3qD4Nkj0/RJ
	 qMamiMudZOKn/Xdwqz+dX0n3Cz3xz2EbfsU/B3+Ob0xx0VZSQUObTRd3TmcVxhORIq
	 YT/irfw3m3tQg==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so634624a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:56:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByGjK+ttBgKAnK/vMl3d6hBknXPvpTFq5SVaHRM0HILhVScQarGJuC+ubPVgLl8ubSl+RGX2KZmCqmi@vger.kernel.org
X-Gm-Message-State: AFq9FYLDTxMzkGzfhCCrn1ep8ADi8jNfHkZq8GsBTYyjsjZ9f6RV96nn
	mn233cEr1zTHW2ApcHHtdGOQn4nvkZ1/AfU52hAtGSdp+mrHxscxYFsno4IqecS6q1s9EXapsUR
	+TjtORNrivkPbngmhQ5WeP8+nXfrECHI=
X-Received: by 2002:a17:907:8687:b0:c35:d50a:1352 with SMTP id
 a640c23a62f3a-c4679607763mr110430566b.11.1792573014394; Wed, 21 Oct 2026
 01:56:54 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792345559.git.jan.koester@gmx.net> <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
 <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org> <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
 <9b5b0f6c-9105-4e30-8608-6f222b0e2a6e@samba.org> <TYZPR02MB6959812BFC392957EDDA8C67E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
In-Reply-To: <TYZPR02MB6959812BFC392957EDDA8C67E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 17:56:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ppcrwJEcjFzsqOq0SoD81E5GXDU1utEVP6=ywaL+o9w@mail.gmail.com>
X-Gm-Features: AclHuK-rqrXSSN_U5qyAKwHz67uGRda1ZtrQ0Kdn46xBn0-lPSiH6U1qPyisTB8
Message-ID: <CAKYAXd9ppcrwJEcjFzsqOq0SoD81E5GXDU1utEVP6=ywaL+o9w@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Wang Zhaolong <wangzhaolong3@outlook.com>
Cc: Ralph Boehme <slow@samba.org>, Stefan Metzmacher <metze@samba.org>, Jan Koester <jan.koester@gmx.net>, 
	linux-cifs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Wang Zhaolong <wangzhaolong@fygo.io>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, wang zhaolong <wangzhaolong@fnnas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 12:52=E2=80=AFAM Wang Zhaolong
<wangzhaolong3@outlook.com> wrote:
>
> Hi Ralph,
>
>
> > may I ask: why? What's the benefit over using something mature and Open=
 Source that already does all that and more?
> >
> > Just curious. :)
> >
> > Cheers!
> > -slow
>
>
> Fair question! :)
>
> When I first had this idea, integration between ksmbd and Samba's AD serv=
ices
> was still fairly limited, so I started thinking about a more tightly
> integrated solution for ksmbd-based NAS systems.
>
> It's great to see the community making progress on this, including Jan's
> recent patches. I'm happy to see that happening.
>
> At the same time, I'd still like to try something different: a small,
> Rust-based AD DC built with ksmbd in mind. I don't know yet whether it'll=
 offer
> any real advantages over Samba, but I think it's worth exploring.
I strongly support this work. The benefit, as I see it, is that a
GPLv2-compatible AD DC implementation integrated with ksmbd could
provide both file sharing and domain-controller services in one
ksmbd-based solution. This could be useful for NAS systems that need
to keep their software stack GPLv2-compatible.

Thanks.
