Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC6522F386
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763426368; cv=none; b=Yl/esSGa7k9tsUeZNB9Nv5B5c2rJCUhcBZQY/6ZmStoPEWCdi5AJ7/EANc9oPK03/TKp5dyTQCaOeIX/gI+qBs9U2FVMVdwt85dQunb+BRg3tO9ki8CXBu6/tP/pbmsFwx8Ze/gmRj1ZSBFP5Ap49XDPugedqamtNBsd7/8pnrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763426368; c=relaxed/simple;
	bh=pcLM05SHl/RWX25C4jxHSyCtuAgCDcQTfwrmW4KgBeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kcDJ561yHxKZ627KTbq2PnSXatOSxm6VMK98V0KQKZHSM2G4P38CEgr3WMmKsarh9oYwjM/uiGLn2Wdwni32HX9kOJFaM0X5yvZeAH0R9n8BQdmWDkEulWBtcOPwdbLjmiaZenDEi0bkbhRGPJQ1LMEbJzUYlC/6/+xg/cgpHRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eovDP7zI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eovDP7zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD2DC2BCB4
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763426367;
	bh=pcLM05SHl/RWX25C4jxHSyCtuAgCDcQTfwrmW4KgBeM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eovDP7zI47PsfmuMqnlmpGSRIF12fMGZkyDvIXVRUQ9S8UwJjkgEr6VAjrBS5/ttF
	 3m2qNjKigD/fr0kK0gxnPY9T1kMXAzmGuqs/Jqfg6L4LT7vMyGCRhM2QZjKVcTvNFt
	 SE6QoNMO4K7JjYAG6v7qm+xpxC7qovUElNDVAqkvC2s31Xw2iM52uiVwPLKJUU20p9
	 pB07v3j4dvLo+Yt5d9MC6t8I9waF33L8FcbTleu8ALgs/NGgsTzv5cZ8pVjkJBdofH
	 IKe1PWTgFZte9oIQG/+OZ2qdY2uXwyXRyavbg26QTNwtNRA0ANH/UNgydfuFA/4zNY
	 kxhWzVq1zJETQ==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-644fcafdce9so768233a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 16:39:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVYkrk9fyTnSAWY14a3YwTys0UqZNM5xilc+KPHqip5gX6BHiwxefLGL1oi+SnS1vGgnw9VoqDvbLPE@vger.kernel.org
X-Gm-Message-State: AOJu0YzvU/hHDhE791pBjUxaCqZrkGDAgzgPXg2BkAUbtq0hLhiYxzQ4
	V1uMZnGtplfkgTgIGxQ5YYVGDKoFAFcwQsB9UUgbpsg4W8A2gJSucgg+EpgS4nOQQT9LTRqkoNx
	ATiJ1QXMlMiHDnxtmFy3XHwHfqdoSrmU=
X-Google-Smtp-Source: AGHT+IEmITrgzrMOnFZyB9tom2bJhAotJB3kGeRr2VlFkPS2uy6a/uNw2t+hwIqJ+HAXO4Iom3hs2wJs7yaPWlzwn70=
X-Received: by 2002:a05:6402:5112:b0:640:a356:e797 with SMTP id
 4fb4d7f45d1cf-64350e2092amr12359076a12.13.1763426365124; Mon, 17 Nov 2025
 16:39:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117085900.466432-1-dqfext@gmail.com> <cc80596c-f08d-465e-a503-bdb42fddbbae@samba.org>
In-Reply-To: <cc80596c-f08d-465e-a503-bdb42fddbbae@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Nov 2025 09:39:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9S4PPG_7Ea82=d5sRjNw5iPgv2MDNWBO7QnzP27poxnw@mail.gmail.com>
X-Gm-Features: AWmQ_bmSqRhcfSPj_YSi5UCaQGoPt-lC8rMJ8v-0AXAJTriZmKI3nEuS_p29C64
Message-ID: <CAKYAXd9S4PPG_7Ea82=d5sRjNw5iPgv2MDNWBO7QnzP27poxnw@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: server: avoid busy polling in accept loop
To: Stefan Metzmacher <metze@samba.org>, Qingfang Deng <dqfext@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 11:52=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 17.11.25 um 09:59 schrieb Qingfang Deng:
> > The ksmbd listener thread was using busy waiting on a listening socket =
by
> > calling kernel_accept() with SOCK_NONBLOCK and retrying every 100ms on
> > -EAGAIN. Since this thread is dedicated to accepting new connections,
> > there is no need for non-blocking mode.
> >
> > Switch to a blocking accept() call instead, allowing the thread to slee=
p
> > until a new connection arrives. This avoids unnecessary wakeups and CPU
> > usage. During teardown, call shutdown() on the listening socket so that
> > accept() returns -EINVAL and the thread exits cleanly.
> >
> > The socket release mutex is redundant because kthread_stop() blocks unt=
il
> > the listener thread returns, guaranteeing safe teardown ordering.
> >
> > Also remove sk_rcvtimeo and sk_sndtimeo assignments, which only caused
> > accept() to return -EAGAIN prematurely.
> >
> > Fixes: 0626e6641f6b ("cifsd: add server handler for central processing =
and tranport layers")
> > Signed-off-by: Qingfang Deng <dqfext@gmail.com>
>
> Reviewed-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next-next.
Thanks!
