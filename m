Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792544469;
	b=ibXwFR9TkYGcsBuTyLe0vsoJRWKhYw6skyx2OAcJgFrj1diXs4E5NhEymhNdQ/58kmeU
	 7wz59HpeHaX7nKBEV/8tb5lTJF4YPHLjLPALyTicc86QsPep6mEK5ZiSXw0ws1FBwcnL7
	 wE/G7oMSlPdZbbnzMcWmyEsyJ2YJ3k9E/VEikoE3KFcKwkhgQT48dJE1L0Q7Q1C5WNImr
	 kpo/WgYe/7UY05bhSGoasbO6+VyPcSoh/SXWLyT8WWhYJqI2JoWL+XzOBG4GB94HvJpYn
	 nKg37l7qCUAQYckGtsGj4zXR9n3SnwWcvzJ4KzxzS7DRfN6r5VPu8TlD1aAxl7Ncy+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792544469;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6pZl7H+m/F05vED4XTANYaHy3Lyal/we3koTknJDsHE=;
	b=HG1RgRsTxDDZDSJoaJJKuzISY2/o+cHTKCCJBZ5dJOM3bVWkWYelqXJkUG5zXUHgqnp1
	 XshA6f57Jt2UT6qBXk0QZII2g/e43uU87sJONlu1shLOw0NkLBgLRW51CW8evyzGfNPEp
	 wSSXKzRQSqdsbdqv7p51pmlNqQpYN7V5Igi8otV4kOzGSg22u/Zcgb3NHz37RcSwbjnpX
	 /zXXSCJV+qKHd103H+bGb5MzEjLVasHOkztC5fLlz55BQ+0A0A2CpUDIosNBlT2+N5fMu
	 P7p/CJQ7/fk+1SDQ4ujENhavD6FitOx4MmTQOiSjsD+gA4a0ZWlZHoRgQlgH1O0phxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="F4h2/vTd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E17606A31D
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F4h2/vTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94221F000D0
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792544468;
	bh=6pZl7H+m/F05vED4XTANYaHy3Lyal/we3koTknJDsHE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=F4h2/vTd/cxt1p8XxCSS6IVzK1+zhv1Dcn9OPqqQ+eik7uHX5ylZEAPVwURywcY4S
	 xNBXygQjiY+rp3/kOXw0epnGNpO31UXL+G/73ciXalUfUWPHqAFu+fJDrliDy0GRbm
	 asLJW6erF35CJzyKuLM4wVwthM6cnkReKSPcIOeexk4eDWIL2GvnOWgK9pDmSSP7+r
	 CtAsG7NaKdXTHeQ58fHv+p2iD4kkJMEw9hmK30dxrHHInjS+pb8yg97VELFRhvW6U5
	 m+xAYL3yKR2FNfbPJWYM2UwodAp8x+PmAXX03mUb8sBcW8PhGBsO0OvGfgXrk42R5+
	 TMr3xRkytayXg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso16779266b.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:01:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwUm5fmHSICpBxD3+B+soO9h0Ls74w4Hv4029sfkVR4hY7rtSL2y6cfZOuFm4zsb4zGWVWTGGmzzNFb@vger.kernel.org
X-Gm-Message-State: AFq9FYKmonZF5EzAAO+jVLcAtlDKDSotYBgaIEsath3ru9rdS1IghgD0
	zqesOzHZRnQtSKGUD0B4TVb0GeKNGFseLv2GfT0QbHRc/0S2LE+eELu+kgwJ60RUqsB/nE21heR
	eS5s6hL0g16HRxXSMPdcLXwdroLQCCGk=
X-Received: by 2002:a17:907:9702:b0:c40:dfec:50c6 with SMTP id
 a640c23a62f3a-c46796374c8mr48048766b.21.1792544467341; Tue, 20 Oct 2026
 18:01:07 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020143553.105014-1-dokunevdmitriy@gmail.com> <20261020143553.105014-3-dokunevdmitriy@gmail.com>
In-Reply-To: <20261020143553.105014-3-dokunevdmitriy@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 10:00:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-iYs1x2XDr5X6H9--uTgVE=wzh=oZN+iajK6YC37=WEA@mail.gmail.com>
X-Gm-Features: AclHuK9r13l7KTM1l1C6m2fLBRU9vQe1FyQ5jG_pjkTGHVpXIoj6wkN_vZMOohY
Message-ID: <CAKYAXd-iYs1x2XDr5X6H9--uTgVE=wzh=oZN+iajK6YC37=WEA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ksmbd: do not release session id 0 on init failure
To: Dmitriy Okunev <dokunevdmitriy@gmail.com>
Cc: lvc-project@linuxtesting.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Steve French <stfrench@microsoft.com>, 
	Ze Tan <tanze@kylinos.cn>, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 11:36=E2=80=AFPM Dmitriy Okunev
<dokunevdmitriy@gmail.com> wrote:
>
> When __session_create() fails before __init_smb2_session() assigns an
> id, sess->id remains 0 because the session was allocated with kzalloc.
> ksmbd_session_destroy() then calls ksmbd_release_id(&session_ida,
> sess->id), and since ida_alloc_min() has not yet been called,
> ida_free(ida, 0) triggers:
>
>   ida_free called for id=3D0 which is not allocated.
>   WARNING: lib/idr.c:594 at ida_free+0x18c/0x250
>   ...
>   ksmbd_release_id+0xd/0x10
>   ksmbd_session_destroy+0x2d5/0x380
>   ksmbd_smb2_session_create+0x131/0x160
>   ...
>
> Add a check for sess->id > 0  before  the release,
> since ids are allocated starting from 1
> (ida_alloc_min(ida,1,...)).
>
> Found by Linux Verification Center (linuxtesting.org).
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
Thanks for the patches. All three issues have already been fixed in
#ksmbd-for-next by commit dc6aa1ba8b7f ("ksmbd: limit sessions on each
connection")

https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/commit/?=
id=3Ddc6aa1ba8b7fff8800ad9bf143f17d308e02ec68

Thanks.
