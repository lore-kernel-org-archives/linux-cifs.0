Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447DA3F23C8
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768914814; cv=none; b=cXFLd7MhSODU2BDOwP1QBytIhSk9K6n6q1LTuQJ4+j75ok+XpkXF1qTqI7NflS5T9rQvqT73cCbdA6g+ZhaUpK25lP4iVg/Rb4EOSohqgq6yyb0bMj7PI4P6KqZPmefVZp/UyfH7WUzn5BXEdDKxcL00lKyfgww6NllENC0rvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768914814; c=relaxed/simple;
	bh=bzkfotPOvWHcE2VqgYlqDYWp4nEzKeKm65QBSmSooao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gpqAdrT+0lpTnIOnP0a+dgDAXXA8XS/bUhcmscOPjKZvCLpETcU/UWJsgv/cvV1p6iCYeZroMv/E+JzqJ3AcL6O/bR/RUL4oOSRXhXOzSfNsFmvjNeBKmcQttpGRtLAoOad4nnKQymcdeXercwX2Kka4+4lMdn8aJwxR/NtmT7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gX6Uoe3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gX6Uoe3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51E7C4AF0B
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768914813;
	bh=bzkfotPOvWHcE2VqgYlqDYWp4nEzKeKm65QBSmSooao=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gX6Uoe3Tdfu7asCIBzCm07LhcH7jZyee+euPRrobsECY8twYS5xMUmgLk1E9BCrD2
	 5JQdXWb2QoI0BM9DRtNXubiS7yFhoEg9pCOjyXj1BbcvcEQE/1zio6FCBiqOGxFL39
	 6DMp4r8qAdajShd25zY0twPuNPvWIauEyMSGwaNu1dKlNmLNFCJIUYXj3BkWtfeUB/
	 vW38Kd92SOXa6Hv/vCMrVJ1ILidlyY/WutigsCj6yf0WFMA2mt7rv6SS8Sbr764Ci7
	 7f46pwNPwF8SEoGRISrwtIwaV3Tu/WdUFAY7IbtIUP8xzI8DPJxjuSh/sF74m+piWz
	 hoimlVsI48G3g==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so9184263a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 05:13:33 -0800 (PST)
X-Gm-Message-State: AOJu0Yz/Evdw1312YtdXOJANRYDJqdQJuVsIlwwXTTTd8PtxeNCCb4IF
	y1OU8GkWxdBIzWxOB8roVKjjWiV6yV/TCzFLWYqAaWLdIUCZoUGmhSSBKr1rqI7Bwq0S4E+otqS
	yvH5dHl/5S7AqDwtzXuOC8lHsJxAN+vs=
X-Received: by 2002:a05:6402:2348:b0:64b:7307:9b00 with SMTP id
 4fb4d7f45d1cf-657ff2a6953mr1629238a12.5.1768914812500; Tue, 20 Jan 2026
 05:13:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119174310.437091-1-metze@samba.org>
In-Reply-To: <20260119174310.437091-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 Jan 2026 22:13:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_vHZuewx53Qthz41sF7EMg_LP68V7+89nwxULwh4WGFA@mail.gmail.com>
X-Gm-Features: AZwV_QgbnctspUoFVMpm-bxThkzx72hvyKXJEWeGpz7h-FHXQcMgyUZxvpSWLwQ
Message-ID: <CAKYAXd_vHZuewx53Qthz41sF7EMg_LP68V7+89nwxULwh4WGFA@mail.gmail.com>
Subject: Re: [PATCH] smb: server: fix comment for ksmbd_vfs_kern_path_start_removing()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 2:43=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> This was found by sparse...
>
> Fixes: 1ead2213dd7d ("smb/server: use end_removing_noperm for for target =
of smb2_create_link()")
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: NeilBrown <neil@brown.name>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next-next.
Thanks!
