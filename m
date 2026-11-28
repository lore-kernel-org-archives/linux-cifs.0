Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795825484;
	b=4qoCxI36oKIqFFu9lIMa9IDCxIxfQ4b0AMy2vclHapRzWNHindcZjRoRGg7jihZezSzm
	 7ria0dMAY5+XpxloWz5rBKTMAEDODLIyy5t03fv+pyExHHK+dlQXZE2VuCeu1VwaUmyZl
	 /BIy243I8oqBo8j1XUBSQEBqH3fk/0azi+EVJaimmZuaMAajr3rlNPYeMc1SqM8CqF+UU
	 eMX+y8bnPCSZiB6zjfBZHsI8r49x1Rzbgr3Vh/FaYUpdGDck0TI0Cgy4+N+ra+RW9+JbV
	 +7rdy1J6w7LkjCJ3wwJRd/PlBwn1hC9Grq+Imdf+Lvlpr26VMNm+4KO3Ho1IU5cZQfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795825484;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=kbF0ayRK7A42V9PluM+QRCXY5pLtAoqGXnrJeUTkud0=;
	b=iUjzeTcaB2JV4GcStpgRNC+ToPXaIcdMIbRhAc3FvLiql/drB0dFj0uJTyD9RAFR/xRc
	 QFlQf3AlHpUgenJUW1f9cpU4KR4VYCIn/RSLIRXL/7v8rfbjorCYqhRUI+VgblzSl4z0C
	 5TWsYzVk7JcS5nil1cCMLvfBGnNBQF5KbY46SvBldFCX6oIg19G+lI9xFWe8J0Vm1qyqg
	 9xUG2ZILiYrLPw2DshB6GDlPIHCSHi1P+VJw57GVBcT+WfZ1Sh68jUf5hHaRxCJtuBhbz
	 22t3DTK4CNn5yefKJKoqma2/oUCUYMBiAEoh2qdpqcrU+oYDnzFz2sqfMbgqiHo3qVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbuiGtpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221F2606A31E
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbuiGtpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BA51F0089B
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 00:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795825483;
	bh=kbF0ayRK7A42V9PluM+QRCXY5pLtAoqGXnrJeUTkud0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UbuiGtppP0YULEjJOCiJPpTCvUYohawEd2LH3woZlrRqZ2GSG1B1oI//1bdWaHNhI
	 ZeknOywUPSSgcn1mFHKu5I5WSrhdu3slt2eGY39B3Z1whuWlotgKwOw/QqOpcU2D0g
	 9IeDF2BMdLKhXdKvQ/x+ipl98kN8yy+7lb4JndoHwTrHQRrlUwS6cIBPfFmu+Gj6Bm
	 UDX2FBlcD3NCYk4jqdW5+t3fu44Uy4YeQRMsJjCWrHVuhZwKuzmQOY6LIjGGwC+9Ax
	 7bNRA/PeGiXzCQsYO5ZVM1+N021lf1qooWIbM/SFlRczhtQJibCw62ixbUe8iwopW/
	 rUL3iAOFZc8rw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4395d31228so1480554466b.1
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 16:24:43 -0800 (PST)
X-Gm-Message-State: APuU4Z8/PD9jtkjq58Nb0F55RxqMVFvzBi0F66LMrby+3QXBt6WjHgmr
	C1ya6GDpO8WWdk/FVzeALppKTl7b98vOZqY23zKzcaiXg5IV9FBgwycVP/Ymg+XBKNg3i1X9OhJ
	nlw7EH/xX8EOh9hGnOpGZ6kCCIb8UqS0=
X-Received: by 2002:a17:906:9e2b:b0:c26:2a2:b91d with SMTP id
 a640c23a62f3a-c513a39f13fmr1772529966b.6.1795825482450; Fri, 27 Nov 2026
 16:24:42 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1795797772.git.metze@samba.org> <17d7f96be20a7eb039cbb3833598f634d786a487.1795797772.git.metze@samba.org>
In-Reply-To: <17d7f96be20a7eb039cbb3833598f634d786a487.1795797772.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 09:24:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_LfmOVG7rwRV9DJ-LgPssgmDcnrBZUp=S_qb64wiPQoA@mail.gmail.com>
X-Gm-Features: Aa3M54pOLJ2etpRwjA2njLPzAg1_EP9n_05P_jnBmk-RIKlMxNNkI2wj57O86-4
Message-ID: <CAKYAXd_LfmOVG7rwRV9DJ-LgPssgmDcnrBZUp=S_qb64wiPQoA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: server: don't leak the smbdirect listener socket
 on errors
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 1:49=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> smb_direct_listen() only assigned listener->socket after
> smbdirect_socket_listen() succeeded. If setting the parameters,
> binding (e.g. -EADDRINUSE) or listening failed, the error path called
> smb_direct_listener_destroy() with listener->socket still NULL, so the
> socket and its rdma cm id were never released.
>
> Assign listener->socket right after the socket is created, so
> smb_direct_listener_destroy() releases it on all error paths.
>
> Fixes: 2eff5e51f976 ("smb: server: make use of smbdirect_socket_{listen,a=
ccept}()")
> Cc: stable@vger.kernel.org
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Cc: linux-cifs@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-983b1ca6-9d6c-4aab-bcc6-2909770bd=
ced
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it with Ian's tags to #ksmbd-for-next.
Thanks!
