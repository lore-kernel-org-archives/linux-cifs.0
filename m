Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76D11C3C1D;
	Tue, 14 Jan 2025 07:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736841210; cv=none; b=nD7BW02F9kGG75llzS/QANXK8LyBi37hZpLge/aaCJxvR4jUXXaqbrRu2FcyvFKDHb7ceI/JX9N6ufe3zvNzlK/4Mj9Li45bXIkQdaLdv8/U/zp8zzQuO1sAgQb44C9UWy5uC5huM4hbp4oHqJHAY7nR5RRN5zUkIYSao08VOuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736841210; c=relaxed/simple;
	bh=63VgHGphQCIs8YfTA8UgmH/w3X7QlOENsh5Hq2JEu94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=calOfoaiVij65qilguSTnhkfLsaQaUxPkz8LrOu/iRmqMFtebuBOrL2RkVnHiBPy36o2IVQp3qfY4XeeGoVtKq36PzqGN5MwQvXLMBuK2i6hYE67wu3AB5OlPgohel2msgTJGqL0gVk+ZDGQ/uFJEYXUeH5tLZ59NNYGB61RZ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPWiPFuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPWiPFuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D6EC4CEE4;
	Tue, 14 Jan 2025 07:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736841210;
	bh=63VgHGphQCIs8YfTA8UgmH/w3X7QlOENsh5Hq2JEu94=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pPWiPFuI07bRksnNX0VJOllM1rEoWX1SgHJ2iQ+T8s1xF9e+H74Ocw4maUut1bUap
	 jJxikFVXA9U2DMF2IwiGIrIqjlDKrAUtZ/G4mZo8SY8PQ01uM2DdcjApWp8IwjiNGN
	 9XrQVzrpNZpTb8TPGpYoq43iyU3pSdItNTuNa+verVY0PBhwD4y1p2fvKtfz96MRQb
	 0Db6nUlVs1DmmcrfZyUTZPKgxXRlbeyWBvl3l2V05w9Jmxdl2JgAhImwqIGVEdrqxo
	 QasAtVPvI3SbfnxRUL2OpsDAVEog9YHSHuLjPxtYIdrEa0CLGK/hducHeQKJPSBS8B
	 xtT1VqyDi1/Wg==
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3eba0f09c3aso1673455b6e.1;
        Mon, 13 Jan 2025 23:53:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVMGN/1EkgMQjR7QfJPoOYlXMWZyI5BouN22HVDdvOHa1eihwZ9pT6zkraWQyGv4lFmhYbJbDegTGMnPtcZpAY=@vger.kernel.org, AJvYcCVlK5i6VBvEeFEC/vbOg1qhnGm5oihYG+f+CCwla3NQE8wz4618vKPFymJKmPQcwmrIy4P2I8wYtKh9KA==@vger.kernel.org, AJvYcCWw3DOpsqLTw0l7LfR1M1lTptjJP0XJkDfS0v5SzlX+RvtvoXnn1QVsBNKxqcPp5XFcsEoKHKWBHtMDHEOw@vger.kernel.org
X-Gm-Message-State: AOJu0YzFMSRcQtM0wRbrwQYmuMAhFWjTfGWbhofqAqKvh12rTJH6F0LJ
	K9IVbC8N5jp6TNXflmRuiJZH3Bb/5a30U3rOM5cyV2VvOrGbTxz8H77/TRc+x4f+4Px8JDZ7cRk
	NU+Vtg/5RMP6tNcRi5uW/Ix8Jm84=
X-Google-Smtp-Source: AGHT+IHmLF0eUtPIzaHIUSZG0mgmC6bZW8vZrCVLDkp0z1bOJDpfDAonHA/0kukXKqvGx9dhDF7Jm+aL0BdotsiBUD4=
X-Received: by 2002:a05:6808:1a0e:b0:3e3:bd1c:d584 with SMTP id
 5614622812f47-3ef2ec6ddfbmr18226301b6e.9.1736841209610; Mon, 13 Jan 2025
 23:53:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b00cd043-7e52-4462-8bb7-b067095bd5fd@stanley.mountain>
In-Reply-To: <b00cd043-7e52-4462-8bb7-b067095bd5fd@stanley.mountain>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 14 Jan 2025 16:53:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd95gAZ4h1TJtFg2bKakSLQcR2294+mZ1tJY5zb2V-rhaA@mail.gmail.com>
X-Gm-Features: AbW1kvZZrVoZIpBloSVmTznaPSQlR5WRH3iv0Bm1p0q9P4ZGAjgd6BxkvdeYwwc
Message-ID: <CAKYAXd95gAZ4h1TJtFg2bKakSLQcR2294+mZ1tJY5zb2V-rhaA@mail.gmail.com>
Subject: Re: [PATCH RESEND] ksmbd: fix integer overflows on 32 bit systems
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025 at 3:17=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On 32bit systems the addition operations in ipc_msg_alloc() can
> potentially overflow leading to memory corruption.  Fix this using
> size_add() which will ensure that the invalid allocations do not succeed.
You previously said that memcpy overrun does not occur due to memory
allocation failure with SIZE_MAX.
Would it be better to handle integer overflows as an error before
memory allocation?
And static checkers don't detect memcpy overrun by considering memory
allocation failure?

Thanks.
> In the callers, move the two constant values
> "sizeof(struct ksmbd_rpc_command) + 1" onto the same side and use
> size_add() for the user controlled values.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> I sent this patch in Oct 2023 but it wasn't applied.
> https://lore.kernel.org/all/205c4ec1-7c41-4f5d-8058-501fc1b5163c@moroto.m=
ountain/
> I reviewed this code again today and it is still an issue.
>
>  fs/smb/server/transport_ipc.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.=
c
> index befaf42b84cc..ec72c97b2f0b 100644
> --- a/fs/smb/server/transport_ipc.c
> +++ b/fs/smb/server/transport_ipc.c
> @@ -242,7 +242,7 @@ static void ipc_update_last_active(void)
>  static struct ksmbd_ipc_msg *ipc_msg_alloc(size_t sz)
>  {
>         struct ksmbd_ipc_msg *msg;
> -       size_t msg_sz =3D sz + sizeof(struct ksmbd_ipc_msg);
> +       size_t msg_sz =3D size_add(sz, sizeof(struct ksmbd_ipc_msg));
>
>         msg =3D kvzalloc(msg_sz, KSMBD_DEFAULT_GFP);
>         if (msg)
> @@ -626,8 +626,8 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_bl=
ob, int blob_len)
>         struct ksmbd_spnego_authen_request *req;
>         struct ksmbd_spnego_authen_response *resp;
>
> -       msg =3D ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) =
+
> -                       blob_len + 1);
> +       msg =3D ipc_msg_alloc(size_add(sizeof(struct ksmbd_spnego_authen_=
request) + 1,
> +                                    blob_len));
>         if (!msg)
>                 return NULL;
>
> @@ -805,7 +805,8 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmb=
d_session *sess, int handle
>         struct ksmbd_rpc_command *req;
>         struct ksmbd_rpc_command *resp;
>
> -       msg =3D ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_=
sz + 1);
> +       msg =3D ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) +=
 1,
> +                                    payload_sz));
>         if (!msg)
>                 return NULL;
>
> @@ -853,7 +854,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmb=
d_session *sess, int handle
>         struct ksmbd_rpc_command *req;
>         struct ksmbd_rpc_command *resp;
>
> -       msg =3D ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_=
sz + 1);
> +       msg =3D ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) +=
 1, payload_sz));
>         if (!msg)
>                 return NULL;
>
> @@ -878,7 +879,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_rap(struct ksmbd_=
session *sess, void *payloa
>         struct ksmbd_rpc_command *req;
>         struct ksmbd_rpc_command *resp;
>
> -       msg =3D ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_=
sz + 1);
> +       msg =3D ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) +=
 1, payload_sz));
>         if (!msg)
>                 return NULL;
>
> --
> 2.45.2
>
