Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DF3303C85
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 23:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757547368; cv=none; b=JMR6YwoiwzfObtIvwJzPc55rohclo6b6jkkc/rQx8CYbgCxfiFGO73HzJGXoaKuEqmiA/AD3J2QzQtS5XSV5KH2KnaOZVJ2GzRf0lSRY4owSDc7cPxJJ7YbTQ2zYSOO+jh3CrwypzEPnzyV1h5+yBdP3pXrtlSbmdkiJkl+fRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757547368; c=relaxed/simple;
	bh=i9leR6L+WicB6x8WhQZe7wlsxarJX0GqvR0t/Hg5zDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VfUiR8UODq79Bj/Ja4hvxYgxepqJrwIfTQYufweZJkjHzcJ/nR6voPGyRwtqlZC3FJQtLbb4biIBInzUlaBgFABaxRqvkubWMo/ReSVr+wEp1I59taNbP1L6inXLzcbbUE+/tYG0ll0g6UTu0gQVCYc8uC+ol2RF9yOuK6EwTmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUh1kPiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUh1kPiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DA4C4CEF0
	for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757547367;
	bh=i9leR6L+WicB6x8WhQZe7wlsxarJX0GqvR0t/Hg5zDQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WUh1kPiFrL2COTHahviWy6/+8K/dw7ITJfuALg8YKZZlNIcdyaC2wC5Ui5PlNc0Xr
	 7wgVVdJWr89lOWgI+abF1U3R4dITdRyr3JNrfdLDoHgyd60cngH1uxYolfv+cZQe2o
	 UZyWC+tJeWE3uwtE9tW5JMjXR5uK5qfRUXS20ZxUAmBv6neX0pglAetr9COkiqq1HF
	 lCvomgc2T9hO8+h7JfG+OhR5OQRRJ9zElaRa0j7gySlNttv9Dx1P8PWaE0GAoMsNCH
	 wxBdPW0vgsBX0yHOb+vN5qA9e5DY7zNHA7kAyJIh7f7QSgLSREVopagGl2IKeYdcpW
	 C41QLRHdWzUIg==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6228de28242so237118a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 16:36:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXakmQ8EeBLO1m3pK/WkiEJ0yjgwDFzjgT46kCgR7r366oUg2hN3aMS2LF8l/1GGlX65TymrYqHqQCx@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi7DFBnotl94USaugji6XxNMDztdMyjqLZwddySOqHcswMRNnr
	0JyM6NdSOPauYZYvBIjkLCuVK5t0Oojyx4ws+vh318mgCrp5HzJ0l83ykSu5bIYZcDnNWXUYKYJ
	+okFusrSpM6QDY2F+RClpfqB9+zkUCFw=
X-Google-Smtp-Source: AGHT+IH9ABmYs11y8MjsI68VnD3LYgM2hqYpmp6tEZr0C9c02Tas4nbKcLrWKy8I09b9mbc5ZsWz4q0DNu9j8mryMng=
X-Received: by 2002:a50:99d4:0:b0:61c:1d41:41bb with SMTP id
 4fb4d7f45d1cf-62e7b7c0b71mr925044a12.16.1757547365945; Wed, 10 Sep 2025
 16:36:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1756139607.git.metze@samba.org> <e6c0ddfe-8942-47a0-8277-b4176a5918e0@samba.org>
 <CAH2r5msKSbUfOVXUabNQep3s2H4kW0AMnDh0XA68Pk3_oqaHCQ@mail.gmail.com> <642872f4-e076-4588-b011-920479b06949@samba.org>
In-Reply-To: <642872f4-e076-4588-b011-920479b06949@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 11 Sep 2025 08:35:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8fJtjESeMiNmAACw8jGkEU_JWCQd3=9XFf_rdx6TxqUw@mail.gmail.com>
X-Gm-Features: AS18NWAb9I02lNZVlKVNYxAQYQ96tj62pHFyLDpvONfTffNv2iRnFFcHwn9iGCs
Message-ID: <CAKYAXd8fJtjESeMiNmAACw8jGkEU_JWCQd3=9XFf_rdx6TxqUw@mail.gmail.com>
Subject: Re: replace for-next-next... Re: [PATCH v4 000/142] smb:
 smbdirect/client/server: make use of common structures
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 4:05=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Steve, hi Namjae,
Hi Metze,
>
> I found "ksmbd: smbdirect: validate data_offset and data_length field of =
smb_direct_data_transfer"
> https://git.samba.org/?p=3Dksmbd.git;a=3Dcommitdiff;h=3D927f8fe05e334d016=
c598d2cc965161c2808d9ba
> in ksmbd-for-next-next.
>
> I added a Fixes and Reviewed-by tag
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3Dfa36db4=
e8d62aa9c3ba1200323d8e01e4eb88b19
> and two additional patches:
I will update it with your tags.
> ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_re=
cv_size
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3D9e88117=
4900e53dd2b17c0c0933cc4395ceb47a6
Looks good to me. I will apply it to #ksmbd-for-next-next.

> smb: client: let recv_done verify data_offset, data_length and remaining_=
data_length
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff;h=3D174faee=
a9ee496b724206d405b74db8b05729f11
Looks good to me. Reviewed-by: Namjae Jeon <linkinjeon@kernel.org> for
this client patch.

Thanks!
>
> I think these should go into 6.17.
>
> As there as conflicts with for-next-next I rebased it again
> and made sure each commit compiles and the result still passes
> the tests I made last time.
>
> The result can be found under
> git fetch https://git.samba.org/metze/linux/wip.git for-6.18/fs-smb-20250=
910-v6
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/head=
s/for-6.18/fs-smb-20250910-v6
>
> Please have a look and replace for-next-next again...
> The diff against the current for-next-next (e2e99af785ee91ce20c6d583e3966=
60494db77a2)
> and for-6.18/fs-smb-20250910-v6 (1fb2a52741e836f54a4691cbd74d9d70d736e506=
) follows below.
>
> Thanks!
> metze
>
>   fs/smb/client/smbdirect.c                  | 19 ++++++++++++++++++-
>   fs/smb/common/smbdirect/smbdirect_socket.h |  2 +-
>   fs/smb/server/transport_rdma.c             | 25 +++++++++++++++++------=
--
>   3 files changed, 36 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 322334097e30..6215a6e91c67 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -548,7 +548,9 @@ static void recv_done(struct ib_cq *cq, struct ib_wc =
*wc)
>         struct smbdirect_socket *sc =3D response->socket;
>         struct smbdirect_socket_parameters *sp =3D &sc->parameters;
>         u16 old_recv_credit_target;
> -       int data_length =3D 0;
> +       u32 data_offset =3D 0;
> +       u32 data_length =3D 0;
> +       u32 remaining_data_length =3D 0;
>         bool negotiate_done =3D false;
>
>         log_rdma_recv(INFO,
> @@ -600,7 +602,22 @@ static void recv_done(struct ib_cq *cq, struct ib_wc=
 *wc)
>         /* SMBD data transfer packet */
>         case SMBDIRECT_EXPECT_DATA_TRANSFER:
>                 data_transfer =3D smbdirect_recv_io_payload(response);
> +
> +               if (wc->byte_len <
> +                   offsetof(struct smbdirect_data_transfer, padding))
> +                       goto error;
> +
> +               remaining_data_length =3D le32_to_cpu(data_transfer->rema=
ining_data_length);
> +               data_offset =3D le32_to_cpu(data_transfer->data_offset);
>                 data_length =3D le32_to_cpu(data_transfer->data_length);
> +               if (wc->byte_len < data_offset ||
> +                   wc->byte_len < (u64)data_offset + data_length)
> +                       goto error;
> +
> +               if (remaining_data_length > sp->max_fragmented_recv_size =
||
> +                   data_length > sp->max_fragmented_recv_size ||
> +                   (u64)remaining_data_length + (u64)data_length > (u64)=
sp->max_fragmented_recv_size)
> +                       goto error;
>
>                 if (data_length) {
>                         if (sc->recv_io.reassembly.full_packet_received)
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/s=
mbdirect/smbdirect_socket.h
> index 8542de12002a..91eb02fb1600 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.h
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.h
> @@ -63,7 +63,7 @@ const char *smbdirect_socket_status_string(enum smbdire=
ct_socket_status status)
>         case SMBDIRECT_SOCKET_DISCONNECTING:
>                 return "DISCONNECTING";
>         case SMBDIRECT_SOCKET_DISCONNECTED:
> -               return "DISCONNECTED,";
> +               return "DISCONNECTED";
>         case SMBDIRECT_SOCKET_DESTROYED:
>                 return "DESTROYED";
>         }
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdm=
a.c
> index 33d2f5bdb827..e371d8f4c80b 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -538,7 +538,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc =
*wc)
>         case SMBDIRECT_EXPECT_DATA_TRANSFER: {
>                 struct smbdirect_data_transfer *data_transfer =3D
>                         (struct smbdirect_data_transfer *)recvmsg->packet=
;
> -               unsigned int data_length;
> +               u32 remaining_data_length, data_offset, data_length;
>                 u16 old_recv_credit_target;
>
>                 if (wc->byte_len <
> @@ -548,15 +548,24 @@ static void recv_done(struct ib_cq *cq, struct ib_w=
c *wc)
>                         return;
>                 }
>
> +               remaining_data_length =3D le32_to_cpu(data_transfer->rema=
ining_data_length);
>                 data_length =3D le32_to_cpu(data_transfer->data_length);
> -               if (data_length) {
> -                       if (wc->byte_len < sizeof(struct smbdirect_data_t=
ransfer) +
> -                           (u64)data_length) {
> -                               put_recvmsg(sc, recvmsg);
> -                               smb_direct_disconnect_rdma_connection(sc)=
;
> -                               return;
> -                       }
> +               data_offset =3D le32_to_cpu(data_transfer->data_offset);
> +               if (wc->byte_len < data_offset ||
> +                   wc->byte_len < (u64)data_offset + data_length) {
> +                       put_recvmsg(sc, recvmsg);
> +                       smb_direct_disconnect_rdma_connection(sc);
> +                       return;
> +               }
> +               if (remaining_data_length > sp->max_fragmented_recv_size =
||
> +                   data_length > sp->max_fragmented_recv_size ||
> +                   (u64)remaining_data_length + (u64)data_length > (u64)=
sp->max_fragmented_recv_size) {
> +                       put_recvmsg(sc, recvmsg);
> +                       smb_direct_disconnect_rdma_connection(sc);
> +                       return;
> +               }
>
> +               if (data_length) {
>                         if (sc->recv_io.reassembly.full_packet_received)
>                                 recvmsg->first_segment =3D true;
>
>
>
>
