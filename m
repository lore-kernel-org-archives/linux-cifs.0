Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053CDAD24;
	Wed, 15 Jan 2025 00:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736900466; cv=none; b=C+Pu3yxWtczcF+o+uHsRmeugb5MtuJ49PGdEg46yI/cozQQ8cZHgIAnvPj1Dgi4d1n2oGKKCQxrn4ChIv/jG1p2uZ+wmiYJMQvB+kkRhjEb5yrvZRkjCaIx2Qd5axnQ39rDX1dGgIo9q4Yrp1i3K3LeDtNjXos3jhpac4B+qFeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736900466; c=relaxed/simple;
	bh=f5jk4aqSEQNCjNMJ+nm8tl3uhBAlvE8rUcyfNef6eWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nVXuZ/9ngQE8lq0CYXl2n2X1N/nIgMGqmNVO2fAGM70gUMdO6wknCQw4rDJMBXQfOM7jOL5ZNOGttcqQhLyOWXXdDWVPdJQ5Qclsnmrm6ygN24DvXx08ZF1c9bfhZqVvE8dKaB5zW3a88fVL2FCst5OKSINl7miKA7YFaFnSiU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVEsP5u0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVEsP5u0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F730C4CEE5;
	Wed, 15 Jan 2025 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736900465;
	bh=f5jk4aqSEQNCjNMJ+nm8tl3uhBAlvE8rUcyfNef6eWA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QVEsP5u0s0QrjaQcAODbCX+wCfud7KDpG41C7MPk/kSuZL+/3qCWF/khv8glu6nqc
	 jZmBya/6zBUpM68Ti5F3BXmf+Fl3g3BlEJ3FdQ0ELtbV3wejBESMrMGhJ2MWbbql/a
	 0OHXui1ZuhJCVo2ekL9VeJ3vjtK9aC0HfF6b/AX3DYBwPoNpjNyugq8yFfuZns1ssi
	 q3adoGlZUCwzu5ovBYojJqDPbPUvAeo/jMs0tO/Hcdor6Ekp6QH7fYGOgob2JA634u
	 AaNnEBQEg0quysboQIuiZID6CmUgssIk+3A0cx540plGVKShf9CCH/8D0fMlsYG9X2
	 w4yKR11VmUJew==
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-71e2bc5b90fso3178508a34.0;
        Tue, 14 Jan 2025 16:21:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU2Nd/3wXCjna+xr69jRVHYmbtBKCDh6QUpsCVdJPiAjHIVP65BOemJywTWjhwIXblQkvdxE7HpZV2QpQN5@vger.kernel.org, AJvYcCUlLSF+9eDtlo6WIeq7CDtbSAZDQA3iNaPCKaogGWEkIeDYjD3DC2Bl89N0zv8JcWFIxDp0oTEylnB7WFAC988=@vger.kernel.org, AJvYcCXzUY2Vtck32C/arzWnHAVfFXuxhj1R8Oxod1G7ZVZUKp/cDulEZs5ry3DH7vEnGwpCmnz9NYoNxW1Dzw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuuwhzj5rRdV1Sz4haayxrWlFid7q6yNl+VCc2RWRInL7+bckp
	E07xWRp77/lAInjNv+TRQoQRNk2ql6JWaMBEV0649WbKAIKS0U/GBH2hDjpb19NzoHBggaaXmmQ
	psgG84E8hWxgRzmtb9o5oVKdlKaE=
X-Google-Smtp-Source: AGHT+IFF3kzW8LhiLt4Uacj/whx/d+Mjozde9rk52W2pcA1ODB9t3G+pgd5RKfVu8G67O13jNj+40WhJ4jLRZgsqQfY=
X-Received: by 2002:a05:6870:6f14:b0:29e:5897:e9ed with SMTP id
 586e51a60fabf-2aa06982ebcmr17700517fac.35.1736900464803; Tue, 14 Jan 2025
 16:21:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b00cd043-7e52-4462-8bb7-b067095bd5fd@stanley.mountain>
 <CAKYAXd95gAZ4h1TJtFg2bKakSLQcR2294+mZ1tJY5zb2V-rhaA@mail.gmail.com> <2fb3efb4-a889-4b49-8100-51147d9ae426@stanley.mountain>
In-Reply-To: <2fb3efb4-a889-4b49-8100-51147d9ae426@stanley.mountain>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Jan 2025 09:20:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_a=u0KKGSAe7yZy+jhtQb5Mq2ZTX=WirL7mhr3QOkTtw@mail.gmail.com>
X-Gm-Features: AbW1kvbCUduJxkXLkS04EyE5981CFCX-rraRF3sSuyJgTFlaQaPptfze6DemhqA
Message-ID: <CAKYAXd_a=u0KKGSAe7yZy+jhtQb5Mq2ZTX=WirL7mhr3QOkTtw@mail.gmail.com>
Subject: Re: [PATCH RESEND] ksmbd: fix integer overflows on 32 bit systems
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2025 at 7:18=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Tue, Jan 14, 2025 at 04:53:18PM +0900, Namjae Jeon wrote:
> > On Mon, Jan 13, 2025 at 3:17=E2=80=AFPM Dan Carpenter <dan.carpenter@li=
naro.org> wrote:
> > >
> > > On 32bit systems the addition operations in ipc_msg_alloc() can
> > > potentially overflow leading to memory corruption.  Fix this using
> > > size_add() which will ensure that the invalid allocations do not succ=
eed.
> > You previously said that memcpy overrun does not occur due to memory
> > allocation failure with SIZE_MAX.
> >
> > Would it be better to handle integer overflows as an error before
> > memory allocation?
>
> I mean we could do something like the below patch but I'd prefer to fix
> it this way.
>
> > And static checkers don't detect memcpy overrun by considering memory
> > allocation failure?
>
> How the struct_size()/array_size() kernel hardenning works is that if
> you pass in a too large value instead of wrapping to a small value, the
> math results in SIZE_MAX so the allocation will fail.  We already handle
> allocation failures correctly so it's fine.
>
> The problem in this code is that on 32 bit systems if you chose a "sz"
> value which is (unsigned int)-4 then the kvzalloc() allocation will
> succeed but the buffer will be 4 bytes smaller than intended and the
> "msg->sz =3D sz;" assignment will corrupt memory.
>
> Anyway, here is how the patch could look like with bounds checking instea=
d
> of size_add().  We could fancy it up a bit, but I don't like fancy math.
Okay, There was a macro for max ipc payload size, So I have changed
INT_MAX to KSMBD_IPC_MAX_PAYLOAD.
I will apply it to #ksmbd-for-next-next.
Thanks!
>
> regards,
> dan carpenter
>
> diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.=
c
> index befaf42b84cc..e1e3bfff163c 100644
> --- a/fs/smb/server/transport_ipc.c
> +++ b/fs/smb/server/transport_ipc.c
> @@ -626,6 +626,9 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_bl=
ob, int blob_len)
>         struct ksmbd_spnego_authen_request *req;
>         struct ksmbd_spnego_authen_response *resp;
>
> +       if (blob_len > INT_MAX)
> +               return NULL;
> +
>         msg =3D ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) =
+
>                         blob_len + 1);
>         if (!msg)
> @@ -805,6 +808,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmb=
d_session *sess, int handle
>         struct ksmbd_rpc_command *req;
>         struct ksmbd_rpc_command *resp;
>
> +       if (payload_sz > INT_MAX)
> +               return NULL;
> +
>         msg =3D ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_=
sz + 1);
>         if (!msg)
>                 return NULL;
> @@ -853,6 +859,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmb=
d_session *sess, int handle
>         struct ksmbd_rpc_command *req;
>         struct ksmbd_rpc_command *resp;
>
> +       if (payload_sz > INT_MAX)
> +               return NULL;
> +
>         msg =3D ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_=
sz + 1);
>         if (!msg)
>                 return NULL;
> @@ -878,6 +887,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_rap(struct ksmbd_=
session *sess, void *payloa
>         struct ksmbd_rpc_command *req;
>         struct ksmbd_rpc_command *resp;
>
> +       if (payload_sz > INT_MAX)
> +               return NULL;
> +
>         msg =3D ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_=
sz + 1);
>         if (!msg)
>                 return NULL;
