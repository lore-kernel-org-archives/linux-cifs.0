Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE4025A350
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754383718; cv=none; b=Cz/aXdRr42l6f+2onG8xbYlj5KIIubQunUt5N5e1GGh5YL87EphKrK/Z+bl0o2loTvGP8ssDZrGBykxUfqboOukCeoTO/pYfnLvDMRWWYoFTUnBc8FQUqj3B6yq5XD6SynqsGSvHnvvI8H8Y5VDlCR6zoFqiFJatBB3QKoctFBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754383718; c=relaxed/simple;
	bh=fC2sPesJaWB3vGS89DrAE+1B7+NtGw7FUUhJTtAJBSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qbf0GkNhUPhtZYWoQkBAlv2MGTAOY80ddCQAjcuQwkqpPu7q+43RYtcQKXQrbSKrZDreKOGKd16b6+TUa3BwhXZs9DyoKimBKkmk/maFfle5sJHr8dubVOV7uIip3GuP0qZhiX2hdH3nEvgO8/37K8vNXQAH5Y+/fkq8LSyVdpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/42iUsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/42iUsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D48CC4CEFC
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 08:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754383718;
	bh=fC2sPesJaWB3vGS89DrAE+1B7+NtGw7FUUhJTtAJBSU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=b/42iUsCIMt5dMcLQerMlV2P4BOR4H+k6pwXpMvQEoUZ5BTV71/x2TH1TDhq2Adpj
	 KtNbrxd3GY2aN14CvcJthNxzuyHgQMSl/6AR8wRs7A8CUux6zLbVTqKi1g5Fy5mAtG
	 KMpD9I7g3B0dE9p1UPgYZoa7+g5kJPoA4aJlJCZCZ4adun1fIMOJwRh0CW8l+XgUTg
	 +66sqKX0nrGMXtNV9BHaDMa3dHcafPzoD/5LcpLbhs8pHYqdMMmLGsmajmy65laeST
	 +Y3br11yLrn6wqZEdsIGjcA3CoHSLX4P4kvJbIjyJ4zmp80qNJOpKF+ZIAWc5rFN9g
	 X+7m3icV/cnEA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-af922ab4849so771669266b.3
        for <linux-cifs@vger.kernel.org>; Tue, 05 Aug 2025 01:48:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YxY0csqTvNooGPfJ0eU1bsxb2pMj1OtjLfs835q6AMfwouoc2LY
	0sRRuvZDbFGhgkau8EttUa06+gbbqMHIPPIhxkmBlvWlTONfvguef7SkMAF9vTFayt3ibEZlKEl
	PZ79xF2Q4SxYR7+QCC6YJw8l0U+D0yt0=
X-Google-Smtp-Source: AGHT+IFmIl/8zAWy1JkAgJEaMj5eAr6p08BQSFWK5JB9Ng4kiDAEG3UGvl+nll8cNsJrKPsSubymdKTI0hacn72qD7A=
X-Received: by 2002:a17:907:6e8f:b0:ae3:bb0a:1ccd with SMTP id
 a640c23a62f3a-af94006657emr1404181666b.26.1754383716960; Tue, 05 Aug 2025
 01:48:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754309565.git.metze@samba.org>
In-Reply-To: <cover.1754309565.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 5 Aug 2025 17:48:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9U1EE4DjPdkzzB0FA_Smd3xpm9CBHpy_3rzczxEQdQ_w@mail.gmail.com>
X-Gm-Features: Ac12FXwGxO7sQmxjLH1RYAT4OCSCkz3f8FfTOE-Q__AA-1ueu0mP4GF4gVvgfrw
Message-ID: <CAKYAXd9U1EE4DjPdkzzB0FA_Smd3xpm9CBHpy_3rzczxEQdQ_w@mail.gmail.com>
Subject: Re: [PATCH 0/4] smb:server: fix possible use after free problems
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 4, 2025 at 9:16=E2=80=AFPM Stefan Metzmacher via samba-technica=
l
<samba-technical@lists.samba.org> wrote:
>
> While refactoring the client and server smbdirect code I
> noticed a few problems where we might hit use after free
> style problems.
>
> In order to allow backports I decided to fix the problems
> before trying to move things to common code.
>
> The client has similar problems, I've sent a separate
> patchset for the client already.
>
> Stefan Metzmacher (4):
>   smb: server: remove separate empty_recvmsg_queue
>   smb: server: make sure we call ib_dma_unmap_single() only if we called
>     ib_dma_map_single already
>   smb: server: let recv_done() consitently call
>     put_recvmsg/smb_direct_disconnect_rdma_connection
>   smb: server: let recv_done() avoid touching data_transfer after
>     cleanup/move
I have directly fixed a typo : consitently -> consistently
Applied 4 patches into #ksmbd-for-next-next.
Thanks!
>
>  fs/smb/server/transport_rdma.c | 97 ++++++++++++----------------------
>  1 file changed, 35 insertions(+), 62 deletions(-)
>
> --
> 2.43.0
>
>
