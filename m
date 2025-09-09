Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F5C173
	for <linux-cifs@vger.kernel.org>; Tue,  9 Sep 2025 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376067; cv=none; b=SVwGrl6FDY3fRgEKmlNrls+ppt9vrZpYRM1FgxVZveN1OvzQGmMatVS8V7wlzdMBaXqO8vAJ+RkNLvPZONXdWL05PL4/zHgwt0q64SuJ0EqrOhSIJnECkpSoLHKVs9G21dV0i90o2/0hQpoO5PgNTcdchbpFkufd6p6oi8eDGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376067; c=relaxed/simple;
	bh=7KAOacfH+SbFHRuxV0J6XvKQa/Clv5OzYetLHeA9JBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WPvIpwdDPXNkFOf9fSk/AroNeD249zyClWZQ+3K2fSirPQBaU9m1nHDYK7bWa/HzpSyPTlnRnsbnZj0nBIf9uoP1B0eVERkqO/cwd77ppShAnQ4JpjWMqdMoC3pGvwQMS8TAj93jwFt7VysqrhoQjKQUj6bsaS1MD5glfoUglFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPEN0upp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPEN0upp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6E2C4CEF9
	for <linux-cifs@vger.kernel.org>; Tue,  9 Sep 2025 00:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757376067;
	bh=7KAOacfH+SbFHRuxV0J6XvKQa/Clv5OzYetLHeA9JBQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FPEN0uppZveKnOIGD/9Fbyxwn1V18VkrTLtTEW/W7HjtkHW9TngepYOV9zmB2t9Lc
	 V8/eMpbEXsWNZJwuiT7lcAJEIyMYsWXVk+AhL/xQYyOc6YuaLWLY4mBK32vxK13M6n
	 GiQQjfPI+CziWenBCrlBitFNgiHI8dPJ0T9DNtjju0HhTdzRGXzVfpHTjAjGSXFUR/
	 aBHi0wO467WChbJjnKNLUxwQgUr0EWMDxIbsjlueFUQDqKiSbSxeXtEutUyZb7z99F
	 xB2EC0SXRARg5FdhKh0sRsF7c7bn9rHx+shJqm+CCV5NxkdJrFxCN7reh58PEhZSye
	 HyS2lQDsZ6DKQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6188b793d21so8002080a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 08 Sep 2025 17:01:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YzXiwqLc8JAgao81OBli+t21O4hF0hgv/X+vY7DamsLCBaDZQi4
	7Du18nbbBbyym++mymq396wO6fJGtNpGn6fKNnfuwXSI1wQ1addjahbBAsSaMGQ2O84g8vTmf/c
	MZO4bMaUjpUJspvMCPCogj/ZEASup2a0=
X-Google-Smtp-Source: AGHT+IHMG87rWhKPRxgR3criSOV0YPnuu+DkddMargIGsGCIKqq7yCAdVrjyDI0qfUzHheRjWySJMuiGg/uLv35Kjuc=
X-Received: by 2002:a17:906:6a17:b0:b04:25e6:2dc7 with SMTP id
 a640c23a62f3a-b04b140a60dmr927063066b.18.1757376065169; Mon, 08 Sep 2025
 17:01:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1756139607.git.metze@samba.org> <e6c0ddfe-8942-47a0-8277-b4176a5918e0@samba.org>
In-Reply-To: <e6c0ddfe-8942-47a0-8277-b4176a5918e0@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 9 Sep 2025 09:00:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_-WG6cn8Ab-sR6A-j++HNEeSiB2qB7qX4U6RZQ3SGOfg@mail.gmail.com>
X-Gm-Features: AS18NWClXcZCYg97uzTRs5Tl-e0NS2rS3CahW_hLdJqwKDB2oDI7lC36qScr2Lc
Message-ID: <CAKYAXd_-WG6cn8Ab-sR6A-j++HNEeSiB2qB7qX4U6RZQ3SGOfg@mail.gmail.com>
Subject: Re: replace for-next-next... Re: [PATCH v4 000/142] smb:
 smbdirect/client/server: make use of common structures
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 1:08=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi Steve,
>
> here's the branch that could replace your
> for-next-next (6eede6a6805fb50e3131b4b8182e10a17c9005b1)
>
> git fetch https://git.samba.org/metze/linux/wip.git for-6.18/fs-smb-20250=
908-v5
> (d762704985c3bd93e2d2e9ab224f5795baea63e1)
>
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/head=
s/for-6.18/fs-smb-20250908-v5
Very nice. It will make it easier to review your patches also.
And please Cc me on your smb client patches too.
Thanks.
>
> The first 3 patches are the main reason why the rebase is needed.
> 7a9cd9e986c1f6ce3a64f4329b2e795bf24752ae smb: server: let smb_direct_writ=
ev() respect SMB_DIRECT_MAX_SEND_SGES
> 329efe5eb73f7b7604dab6b08f16bb6c3e500690 smb: smbdirect: introduce smbdir=
ect_socket_status_string()
> ab7a3a9ece72bce4f601d6224aa9243b7e090ca9 smb: client: adjust smbdirect re=
lated output of cifs_debug_data_proc_show()
>
> In addition send_io.pending.wait_queue is changed to send_io.pending.zero=
_wait_queue to indicate
> it's woken when count gets zero.
>
> send_io.pending.dec_wait_queue is introduced to replace info->wait_post_s=
end instead of dropping
> the logic around it, that gets woken on every decrement.
>
> The diff between the branches below:
>
> Please replace your for-next-next if you're happy.
>
> Thanks!
> metze
>
>   fs/smb/client/cifs_debug.c                 |  41 +++----
>   fs/smb/client/smbdirect.c                  |  30 ++++--
>   fs/smb/common/smbdirect/smbdirect_socket.h |  55 +++++++++-
>   fs/smb/server/transport_rdma.c             | 167 +++++++++++++++++++---=
-------
>   4 files changed, 210 insertions(+), 83 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index b4d70b51c456..35c4d27d2cc0 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -457,52 +457,53 @@ static int cifs_debug_data_proc_show(struct seq_fil=
e *m, void *v)
>                 sc =3D &server->smbd_conn->socket;
>                 sp =3D &sc->parameters;
>
> -               seq_printf(m, "\nSMBDirect (in hex) protocol version: %x =
"
> -                       "transport status: %x",
> +               seq_printf(m, "\nSMBDirect protocol version: 0x%x "
> +                       "transport status: %s (%u)",
>                         SMBDIRECT_V1,
> +                       smbdirect_socket_status_string(sc->status),
>                         sc->status);
> -               seq_printf(m, "\nConn receive_credit_max: %x "
> -                       "send_credit_target: %x max_send_size: %x",
> +               seq_printf(m, "\nConn receive_credit_max: %u "
> +                       "send_credit_target: %u max_send_size: %u",
>                         sp->recv_credit_max,
>                         sp->send_credit_target,
>                         sp->max_send_size);
> -               seq_printf(m, "\nConn max_fragmented_recv_size: %x "
> -                       "max_fragmented_send_size: %x max_receive_size:%x=
",
> +               seq_printf(m, "\nConn max_fragmented_recv_size: %u "
> +                       "max_fragmented_send_size: %u max_receive_size:%u=
",
>                         sp->max_fragmented_recv_size,
>                         sp->max_fragmented_send_size,
>                         sp->max_recv_size);
> -               seq_printf(m, "\nConn keep_alive_interval: %x "
> -                       "max_readwrite_size: %x rdma_readwrite_threshold:=
 %x",
> +               seq_printf(m, "\nConn keep_alive_interval: %u "
> +                       "max_readwrite_size: %u rdma_readwrite_threshold:=
 %u",
>                         sp->keepalive_interval_msec * 1000,
>                         sp->max_read_write_size,
>                         server->rdma_readwrite_threshold);
> -               seq_printf(m, "\nDebug count_get_receive_buffer: %llx "
> -                       "count_put_receive_buffer: %llx count_send_empty:=
 %llx",
> +               seq_printf(m, "\nDebug count_get_receive_buffer: %llu "
> +                       "count_put_receive_buffer: %llu count_send_empty:=
 %llu",
>                         sc->statistics.get_receive_buffer,
>                         sc->statistics.put_receive_buffer,
>                         sc->statistics.send_empty);
>                 seq_printf(m, "\nRead Queue "
> -                       "count_enqueue_reassembly_queue: %llx "
> -                       "count_dequeue_reassembly_queue: %llx "
> -                       "reassembly_data_length: %x "
> -                       "reassembly_queue_length: %x",
> +                       "count_enqueue_reassembly_queue: %llu "
> +                       "count_dequeue_reassembly_queue: %llu "
> +                       "reassembly_data_length: %u "
> +                       "reassembly_queue_length: %u",
>                         sc->statistics.enqueue_reassembly_queue,
>                         sc->statistics.dequeue_reassembly_queue,
>                         sc->recv_io.reassembly.data_length,
>                         sc->recv_io.reassembly.queue_length);
> -               seq_printf(m, "\nCurrent Credits send_credits: %x "
> -                       "receive_credits: %x receive_credit_target: %x",
> +               seq_printf(m, "\nCurrent Credits send_credits: %u "
> +                       "receive_credits: %u receive_credit_target: %u",
>                         atomic_read(&sc->send_io.credits.count),
>                         atomic_read(&sc->recv_io.credits.count),
>                         sc->recv_io.credits.target);
> -               seq_printf(m, "\nPending send_pending: %x ",
> +               seq_printf(m, "\nPending send_pending: %u ",
>                         atomic_read(&sc->send_io.pending.count));
> -               seq_printf(m, "\nMR responder_resources: %x "
> -                       "max_frmr_depth: %x mr_type: %x",
> +               seq_printf(m, "\nMR responder_resources: %u "
> +                       "max_frmr_depth: %u mr_type: 0x%x",
>                         sp->responder_resources,
>                         sp->max_frmr_depth,
>                         sc->mr_io.type);
> -               seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x"=
,
> +               seq_printf(m, "\nMR mr_ready_count: %u mr_used_count: %u"=
,
>                         atomic_read(&sc->mr_io.ready.count),
>                         atomic_read(&sc->mr_io.used.count));
>   skip_rdma:
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index d3cd89bd2cc7..322334097e30 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -412,7 +412,9 @@ static void send_done(struct ib_cq *cq, struct ib_wc =
*wc)
>         }
>
>         if (atomic_dec_and_test(&sc->send_io.pending.count))
> -               wake_up(&sc->send_io.pending.wait_queue);
> +               wake_up(&sc->send_io.pending.zero_wait_queue);
> +
> +       wake_up(&sc->send_io.pending.dec_wait_queue);
>
>         mempool_free(request, sc->send_io.mem.pool);
>   }
> @@ -1017,6 +1019,23 @@ static int smbd_post_send_iter(struct smbdirect_so=
cket *sc,
>                 goto wait_credit;
>         }
>
> +wait_send_queue:
> +       wait_event(sc->send_io.pending.dec_wait_queue,
> +               atomic_read(&sc->send_io.pending.count) < sp->send_credit=
_target ||
> +               sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
> +
> +       if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> +               log_outgoing(ERR, "disconnected not sending on wait_send_=
queue\n");
> +               rc =3D -EAGAIN;
> +               goto err_wait_send_queue;
> +       }
> +
> +       if (unlikely(atomic_inc_return(&sc->send_io.pending.count) >
> +                               sp->send_credit_target)) {
> +               atomic_dec(&sc->send_io.pending.count);
> +               goto wait_send_queue;
> +       }
> +
>         request =3D mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
>         if (!request) {
>                 rc =3D -ENOMEM;
> @@ -1098,14 +1117,10 @@ static int smbd_post_send_iter(struct smbdirect_s=
ocket *sc,
>         request->sge[0].length =3D header_length;
>         request->sge[0].lkey =3D sc->ib.pd->local_dma_lkey;
>
> -       atomic_inc(&sc->send_io.pending.count);
>         rc =3D smbd_post_send(sc, request);
>         if (!rc)
>                 return 0;
>
> -       if (atomic_dec_and_test(&sc->send_io.pending.count))
> -               wake_up(&sc->send_io.pending.wait_queue);
> -
>   err_dma:
>         for (i =3D 0; i < request->num_sge; i++)
>                 if (request->sge[i].addr)
> @@ -1119,7 +1134,10 @@ static int smbd_post_send_iter(struct smbdirect_so=
cket *sc,
>         atomic_sub(new_credits, &sc->recv_io.credits.count);
>
>   err_alloc:
> +       if (atomic_dec_and_test(&sc->send_io.pending.count))
> +               wake_up(&sc->send_io.pending.zero_wait_queue);
>
> +err_wait_send_queue:
>         /* roll back send credits and pending */
>         atomic_inc(&sc->send_io.credits.count);
>
> @@ -2118,7 +2136,7 @@ int smbd_send(struct TCP_Server_Info *server,
>          * that means all the I/Os have been out and we are good to retur=
n
>          */
>
> -       wait_event(sc->send_io.pending.wait_queue,
> +       wait_event(sc->send_io.pending.zero_wait_queue,
>                 atomic_read(&sc->send_io.pending.count) =3D=3D 0 ||
>                 sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/s=
mbdirect/smbdirect_socket.h
> index c62d12f63e13..8542de12002a 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.h
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.h
> @@ -28,6 +28,49 @@ enum smbdirect_socket_status {
>         SMBDIRECT_SOCKET_DESTROYED
>   };
>
> +static __always_inline
> +const char *smbdirect_socket_status_string(enum smbdirect_socket_status =
status)
> +{
> +       switch (status) {
> +       case SMBDIRECT_SOCKET_CREATED:
> +               return "CREATED";
> +       case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
> +               return "RESOLVE_ADDR_NEEDED";
> +       case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
> +               return "RESOLVE_ADDR_RUNNING";
> +       case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
> +               return "RESOLVE_ADDR_FAILED";
> +       case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
> +               return "RESOLVE_ROUTE_NEEDED";
> +       case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
> +               return "RESOLVE_ROUTE_RUNNING";
> +       case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
> +               return "RESOLVE_ROUTE_FAILED";
> +       case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
> +               return "RDMA_CONNECT_NEEDED";
> +       case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
> +               return "RDMA_CONNECT_RUNNING";
> +       case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
> +               return "RDMA_CONNECT_FAILED";
> +       case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
> +               return "NEGOTIATE_NEEDED";
> +       case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
> +               return "NEGOTIATE_RUNNING";
> +       case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
> +               return "NEGOTIATE_FAILED";
> +       case SMBDIRECT_SOCKET_CONNECTED:
> +               return "CONNECTED";
> +       case SMBDIRECT_SOCKET_DISCONNECTING:
> +               return "DISCONNECTING";
> +       case SMBDIRECT_SOCKET_DISCONNECTED:
> +               return "DISCONNECTED,";
> +       case SMBDIRECT_SOCKET_DESTROYED:
> +               return "DESTROYED";
> +       }
> +
> +       return "<unknown>";
> +}
> +
>   enum smbdirect_keepalive_status {
>         SMBDIRECT_KEEPALIVE_NONE,
>         SMBDIRECT_KEEPALIVE_PENDING,
> @@ -107,7 +150,14 @@ struct smbdirect_socket {
>                  */
>                 struct {
>                         atomic_t count;
> -                       wait_queue_head_t wait_queue;
> +                       /*
> +                        * woken when count is decremented
> +                        */
> +                       wait_queue_head_t dec_wait_queue;
> +                       /*
> +                        * woken when count reached zero
> +                        */
> +                       wait_queue_head_t zero_wait_queue;
>                 } pending;
>         } send_io;
>
> @@ -271,7 +321,8 @@ static __always_inline void smbdirect_socket_init(str=
uct smbdirect_socket *sc)
>         init_waitqueue_head(&sc->send_io.credits.wait_queue);
>
>         atomic_set(&sc->send_io.pending.count, 0);
> -       init_waitqueue_head(&sc->send_io.pending.wait_queue);
> +       init_waitqueue_head(&sc->send_io.pending.dec_wait_queue);
> +       init_waitqueue_head(&sc->send_io.pending.zero_wait_queue);
>
>         INIT_LIST_HEAD(&sc->recv_io.free.list);
>         spin_lock_init(&sc->recv_io.free.lock);
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdm=
a.c
> index 6e4c2bf7dd93..33d2f5bdb827 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -366,7 +366,7 @@ static void free_transport(struct smb_direct_transpor=
t *t)
>         }
>
>         wake_up_all(&sc->send_io.credits.wait_queue);
> -       wake_up_all(&sc->send_io.pending.wait_queue);
> +       wake_up_all(&sc->send_io.pending.zero_wait_queue);
>
>         disable_work_sync(&sc->recv_io.posted.refill_work);
>         disable_delayed_work_sync(&sc->idle.timer_work);
> @@ -818,7 +818,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc =
*wc)
>         }
>
>         if (atomic_dec_and_test(&sc->send_io.pending.count))
> -               wake_up(&sc->send_io.pending.wait_queue);
> +               wake_up(&sc->send_io.pending.zero_wait_queue);
>
>         /* iterate and free the list of messages in reverse. the list's h=
ead
>          * is invalid.
> @@ -879,7 +879,7 @@ static int smb_direct_post_send(struct smbdirect_sock=
et *sc,
>         if (ret) {
>                 pr_err("failed to post send: %d\n", ret);
>                 if (atomic_dec_and_test(&sc->send_io.pending.count))
> -                       wake_up(&sc->send_io.pending.wait_queue);
> +                       wake_up(&sc->send_io.pending.zero_wait_queue);
>                 smb_direct_disconnect_rdma_connection(sc);
>         }
>         return ret;
> @@ -1206,78 +1206,130 @@ static int smb_direct_writev(struct ksmbd_transp=
ort *t,
>         struct smb_direct_transport *st =3D SMBD_TRANS(t);
>         struct smbdirect_socket *sc =3D &st->socket;
>         struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> -       int remaining_data_length;
> -       int start, i, j;
> -       int max_iov_size =3D sp->max_send_size -
> +       size_t remaining_data_length;
> +       size_t iov_idx;
> +       size_t iov_ofs;
> +       size_t max_iov_size =3D sp->max_send_size -
>                         sizeof(struct smbdirect_data_transfer);
>         int ret;
> -       struct kvec vec;
>         struct smbdirect_send_batch send_ctx;
> +       int error =3D 0;
>
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED)
>                 return -ENOTCONN;
>
>         //FIXME: skip RFC1002 header..
> +       if (WARN_ON_ONCE(niovs <=3D 1 || iov[0].iov_len !=3D 4))
> +               return -EINVAL;
>         buflen -=3D 4;
> +       iov_idx =3D 1;
> +       iov_ofs =3D 0;
>
>         remaining_data_length =3D buflen;
>         ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=3D%u\n", buflen);
>
>         smb_direct_send_ctx_init(&send_ctx, need_invalidate, remote_key);
> -       start =3D i =3D 1;
> -       buflen =3D 0;
> -       while (true) {
> -               buflen +=3D iov[i].iov_len;
> -               if (buflen > max_iov_size) {
> -                       if (i > start) {
> -                               remaining_data_length -=3D
> -                                       (buflen - iov[i].iov_len);
> -                               ret =3D smb_direct_post_send_data(sc, &se=
nd_ctx,
> -                                                               &iov[star=
t], i - start,
> -                                                               remaining=
_data_length);
> -                               if (ret)
> +       while (remaining_data_length) {
> +               struct kvec vecs[SMBDIRECT_SEND_IO_MAX_SGE - 1]; /* minus=
 smbdirect hdr */
> +               size_t possible_bytes =3D max_iov_size;
> +               size_t possible_vecs;
> +               size_t bytes =3D 0;
> +               size_t nvecs =3D 0;
> +
> +               /*
> +                * For the last message remaining_data_length should be
> +                * have been 0 already!
> +                */
> +               if (WARN_ON_ONCE(iov_idx >=3D niovs)) {
> +                       error =3D -EINVAL;
> +                       goto done;
> +               }
> +
> +               /*
> +                * We have 2 factors which limit the arguments we pass
> +                * to smb_direct_post_send_data():
> +                *
> +                * 1. The number of supported sges for the send,
> +                *    while one is reserved for the smbdirect header.
> +                *    And we currently need one SGE per page.
> +                * 2. The number of negotiated payload bytes per send.
> +                */
> +               possible_vecs =3D min_t(size_t, ARRAY_SIZE(vecs), niovs -=
 iov_idx);
> +
> +               while (iov_idx < niovs && possible_vecs && possible_bytes=
) {
> +                       struct kvec *v =3D &vecs[nvecs];
> +                       int page_count;
> +
> +                       v->iov_base =3D ((u8 *)iov[iov_idx].iov_base) + i=
ov_ofs;
> +                       v->iov_len =3D min_t(size_t,
> +                                          iov[iov_idx].iov_len - iov_ofs=
,
> +                                          possible_bytes);
> +                       page_count =3D get_buf_page_count(v->iov_base, v-=
>iov_len);
> +                       if (page_count > possible_vecs) {
> +                               /*
> +                                * If the number of pages in the buffer
> +                                * is to much (because we currently requi=
re
> +                                * one SGE per page), we need to limit th=
e
> +                                * length.
> +                                *
> +                                * We know possible_vecs is at least 1,
> +                                * so we always keep the first page.
> +                                *
> +                                * We need to calculate the number extra
> +                                * pages (epages) we can also keep.
> +                                *
> +                                * We calculate the number of bytes in th=
e
> +                                * first page (fplen), this should never =
be
> +                                * larger than v->iov_len because page_co=
unt is
> +                                * at least 2, but adding a limitation fe=
els
> +                                * better.
> +                                *
> +                                * Then we calculate the number of bytes =
(elen)
> +                                * we can keep for the extra pages.
> +                                */
> +                               size_t epages =3D possible_vecs - 1;
> +                               size_t fpofs =3D offset_in_page(v->iov_ba=
se);
> +                               size_t fplen =3D min_t(size_t, PAGE_SIZE =
- fpofs, v->iov_len);
> +                               size_t elen =3D min_t(size_t, v->iov_len =
- fplen, epages*PAGE_SIZE);
> +
> +                               v->iov_len =3D fplen + elen;
> +                               page_count =3D get_buf_page_count(v->iov_=
base, v->iov_len);
> +                               if (WARN_ON_ONCE(page_count > possible_ve=
cs)) {
> +                                       /*
> +                                        * Something went wrong in the ab=
ove
> +                                        * logic...
> +                                        */
> +                                       error =3D -EINVAL;
>                                         goto done;
> -                       } else {
> -                               /* iov[start] is too big, break it */
> -                               int nvec  =3D (buflen + max_iov_size - 1)=
 /
> -                                               max_iov_size;
> -
> -                               for (j =3D 0; j < nvec; j++) {
> -                                       vec.iov_base =3D
> -                                               (char *)iov[start].iov_ba=
se +
> -                                               j * max_iov_size;
> -                                       vec.iov_len =3D
> -                                               min_t(int, max_iov_size,
> -                                                     buflen - max_iov_si=
ze * j);
> -                                       remaining_data_length -=3D vec.io=
v_len;
> -                                       ret =3D smb_direct_post_send_data=
(sc, &send_ctx, &vec, 1,
> -                                                                       r=
emaining_data_length);
> -                                       if (ret)
> -                                               goto done;
>                                 }
> -                               i++;
> -                               if (i =3D=3D niovs)
> -                                       break;
>                         }
> -                       start =3D i;
> -                       buflen =3D 0;
> -               } else {
> -                       i++;
> -                       if (i =3D=3D niovs) {
> -                               /* send out all remaining vecs */
> -                               remaining_data_length -=3D buflen;
> -                               ret =3D smb_direct_post_send_data(sc, &se=
nd_ctx,
> -                                                               &iov[star=
t], i - start,
> -                                                               remaining=
_data_length);
> -                               if (ret)
> -                                       goto done;
> -                               break;
> +                       possible_vecs -=3D page_count;
> +                       nvecs +=3D 1;
> +                       possible_bytes -=3D v->iov_len;
> +                       bytes +=3D v->iov_len;
> +
> +                       iov_ofs +=3D v->iov_len;
> +                       if (iov_ofs >=3D iov[iov_idx].iov_len) {
> +                               iov_idx +=3D 1;
> +                               iov_ofs =3D 0;
>                         }
>                 }
> +
> +               remaining_data_length -=3D bytes;
> +
> +               ret =3D smb_direct_post_send_data(sc, &send_ctx,
> +                                               vecs, nvecs,
> +                                               remaining_data_length);
> +               if (unlikely(ret)) {
> +                       error =3D ret;
> +                       goto done;
> +               }
>         }
>
>   done:
>         ret =3D smb_direct_flush_send_list(sc, &send_ctx, true);
> +       if (unlikely(!ret && error))
> +               ret =3D error;
>
>         /*
>          * As an optimization, we don't wait for individual I/O to finish
> @@ -1286,7 +1338,7 @@ static int smb_direct_writev(struct ksmbd_transport=
 *t,
>          * that means all the I/Os have been out and we are good to retur=
n
>          */
>
> -       wait_event(sc->send_io.pending.wait_queue,
> +       wait_event(sc->send_io.pending.zero_wait_queue,
>                    atomic_read(&sc->send_io.pending.count) =3D=3D 0 ||
>                    sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED && ret =3D=3D 0)
> @@ -1620,7 +1672,7 @@ static int smb_direct_send_negotiate_response(struc=
t smbdirect_socket *sc,
>                 return ret;
>         }
>
> -       wait_event(sc->send_io.pending.wait_queue,
> +       wait_event(sc->send_io.pending.zero_wait_queue,
>                    atomic_read(&sc->send_io.pending.count) =3D=3D 0 ||
>                    sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED)
> @@ -1773,6 +1825,11 @@ static int smb_direct_init_params(struct smbdirect=
_socket *sc,
>                 return -EINVAL;
>         }
>
> +       if (device->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE) {
> +               pr_err("warning: device max_send_sge =3D %d too small\n",
> +                      device->attrs.max_send_sge);
> +               return -EINVAL;
> +       }
>         if (device->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
>                 pr_err("warning: device max_recv_sge =3D %d too small\n",
>                        device->attrs.max_recv_sge);
> @@ -1785,7 +1842,7 @@ static int smb_direct_init_params(struct smbdirect_=
socket *sc,
>
>         cap->max_send_wr =3D max_send_wrs;
>         cap->max_recv_wr =3D sp->recv_credit_max;
> -       cap->max_send_sge =3D max_sge_per_wr;
> +       cap->max_send_sge =3D SMBDIRECT_SEND_IO_MAX_SGE;
>         cap->max_recv_sge =3D SMBDIRECT_RECV_IO_MAX_SGE;
>         cap->max_inline_data =3D 0;
>         cap->max_rdma_ctxs =3D sc->rw_io.credits.max;
>
>
