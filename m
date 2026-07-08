Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDB4422538
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 10:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783506858; cv=none; b=IXX02cygNqbqq/DyZhfpdebHSXOBFel2MjXIV8a3mpWbx/SNwtvoz+7u40HjVJNqLo3B+rBsItnkmsL9I3Q+vCsMfDNEP48p6bCUqgzj/0rFFJ96mBKr96MCDtET8Eh/oX6RNl44jJM8h74+Y3Q/LCShgcY8V7jO76KY89DvV28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783506858; c=relaxed/simple;
	bh=dKrfa1Yzbv3QOzMgGT+zW9vrJJIjszafiO2kn4bPA70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t6SXxkI9WYQU7rxGjcGHHYziv9aU4H3QbsM+TksDqrhcYqLIzGhqLF2JYUc6a2Zo7hEP7waNDp3a7QSOZYCeTCXiX1DMrDs39tUX8zAMjPaXW/TzLSurEJQMVqJIoVT2qgeYJyJ8iwVilYg7L4GN58M73ugAXfNJj/q3jF4vVcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kS4jAB+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kS4jAB+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5C11F00AC4
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 10:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783506848;
	bh=P5jTTjqEJapeLcDOUSTBT37c4fQte49n0JgcyhCW9mQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kS4jAB+cOHxfz1vZ1Unz5tUGXgonC448qpfG/hiyy1+SOnaqDDcuvTbrvo2GjgBxj
	 wBQaMvc1ip9clZOcS0F3LWqQk8CUSsFEU4Bki6liMqnB0hNegZJCUKH3qlckqoyg9W
	 L5PToMCk9Ij2fqR3FDFOjhdcJpe/e3BTRS1+GfWgZ9lMJgLLBPzbuOLHWfaQVzzJ7i
	 jRMPVdDEa0rXnNUMpctItNO4j/mJeyg3ixu7UufRGlHPz21L0uce4PeYj6clS+TeqV
	 4dhdpVcTxsKA9kC8ZZTOKwa4BYpPWzZvl21iBC0/keOhIT+A3g83SlYRtCWWu6/LQb
	 SGypObUubQABg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15d111ca99so41737166b.0
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 03:34:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqjuJffifafyJ2eCPZZXQGlyPWahdsbCldfFcdTcBGBI3dXMt8aBENRkQDetleLcuJrE2sdUt57Olci@vger.kernel.org
X-Gm-Message-State: AOJu0YyqRRkK/6rcXAsz24CbDM5R5qSBHOPG1V6HrvoN8zoh5VHX2nNp
	7MH3BWuKdoj5p0CNx5pXGVVWdRxM6RN1yPkwCOmUp/skDyqpMi9Hedxls59DCFF93FXC6003Mdm
	M53NNbhMeFaL+KBSux5zIq2QXxvxfW1g=
X-Received: by 2002:a17:906:d962:b0:c12:8fe9:3a42 with SMTP id
 a640c23a62f3a-c15ce0c291cmr58960866b.35.1783506847483; Wed, 08 Jul 2026
 03:34:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Jul 2026 19:33:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_1Emq0LhBQJtvWkPU+EkaQ6_3UmBxQogTcDau4tBpBrw@mail.gmail.com>
X-Gm-Features: AVVi8CcBtVXSxgMNA7HyQ2p5rwK608QE5aymQYDz57yPB_hn-11VLrOB0DDNCqo
Message-ID: <CAKYAXd_1Emq0LhBQJtvWkPU+EkaQ6_3UmBxQogTcDau4tBpBrw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] smb/server: improve async interim response
 handling for compound requests
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 11:56=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> v1->v2: send compound prefix before async pending response,
>         then send STATUS_PENDING as a standalone response.
>
> v1: https://lore.kernel.org/linux-cifs/20260702110522.911411-1-chenxiaoso=
ng@chenxiaosong.com/
>
> I am currently implementing the ksmbd change notify feature, and I have
> encountered the following issue.
>
> Before this patchset, no CREATE response:
>
>   Windows client compound request:
>     CREATE dir; CHANGE_NOTIFY, fid =3D compound fid
>
>   Server response:
>     CHANGE_NOTIFY STATUS_PENDING, AsyncId =3D N
>
> After this patchset:
>
>   Server response:
>     CREATE dir SUCCESS, fid =3D X
>     CHANGE_NOTIFY STATUS_PENDING, AsyncId =3D N
>
> ChenXiaoSong (3):
>   smb/server: send compound prefix before async pending response
>   smb/server: introduce struct ksmbd_transport_write
>   smb/server: use MSG_EOR for async interim response
Applied them to #ksmbd-for-next-next.
Thanks!
