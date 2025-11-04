Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2C531B117
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762267804; cv=none; b=BcZNqe+Lt2cPK1pdd9fhbt/SZWxRsK1ZtFO6wwyqN42OzDsACJdB9LBU3ELgMqpblWBI6FWW7YUFLaI/2MdWkrOiOwJwdvRqpeYL+F3Pp8h9vWbyP5FRfl1QIihFu231Ad99Yw675vB4SWZWf+Y7Bvk5mqxy4MMQVWIyzeUoQis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762267804; c=relaxed/simple;
	bh=xgp2V3Vv6zgoDyJrvfBPnzdHLnSqIutTb8KpHDCNPFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHVmUJN5Pd+zucGdS9sBBacetCYcn+9AsaSI2BSqk45k88H66ybDPmmE+sDq/708lxCMMR8pVqcFeXfhxrS+UnviYcTRnBwDKa/6LPbI1INS+8Oix21WqfP/K6ZfuybUEqOGr8XMunBlPK1Tm3/GztVxRT2aIlmhLv81KdLE3Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4fDn5aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4fDn5aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914FFC19424
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762267803;
	bh=xgp2V3Vv6zgoDyJrvfBPnzdHLnSqIutTb8KpHDCNPFc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V4fDn5aQX0+pXEDUpH+YctBFOkK0emhig8aq0FZp5T9W5ZPnHRzGsXPuDV0K6WntY
	 sa0Du6RLn7CI8lxqb5AcRFicixrElsTcFDgwtrsy2yEDBuO3rob3SJjiyb/+dvkdg/
	 Kj0mJW5sQi2inMEXISFvITQZ5u2J1S5yqfrCwwlrdK8/cymUGt6GBQC4WOAMSWHZyx
	 6d8ngicu8In/m1qaxk97DSDeRzrtCHKkOa29/ry3rH6JF7FWHSVoy0Ziv4KCEm3OZP
	 8BZak7udkojgKnLGN8J9VkU0LVO4T6oVq4DmdhLoh1igSEUtGKNzmg7bYeMYAwlyFh
	 YGaAwTg8nXrpA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b403bb7843eso232463166b.3
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 06:50:03 -0800 (PST)
X-Gm-Message-State: AOJu0Yymv0It0ZMKQ8t8kcCqHVVTqI2R7gK1amE3TGoPHJQv03/unvJn
	6toyIBlOG99EazH/TZwReUx6eiSlqKFf0bjUDfah42hWdamq69nxSIx/kZNawD6OStjaWr0MPJ4
	ZyqZVy0hsEbaBeU3OJBaIQkNuDRfPOYo=
X-Google-Smtp-Source: AGHT+IGzA7GMS/QJfPJvsatjqrgqJi0wCOBpHDnKqz9vM7VIoB8TNapZmlWQN+KJ6NE6uDICv6wjSrL3zj40tmpOUqc=
X-Received: by 2002:a17:907:7253:b0:b6d:5003:8746 with SMTP id
 a640c23a62f3a-b707016b330mr1731011366b.21.1762267801721; Tue, 04 Nov 2025
 06:50:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761742839.git.metze@samba.org> <8f1cd9a8-d292-4129-abed-9e6082ee397b@samba.org>
In-Reply-To: <8f1cd9a8-d292-4129-abed-9e6082ee397b@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 4 Nov 2025 23:49:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-S1HJbeM3uf8hC-nQPuf+eZEC=ygTKq01Ywm_w6Mt_QQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmgo9t71mog58gM6ga2RfHBELPCn0Dm-Z5VZP7SR3KUwq8p9TZVj2vaJcc
Message-ID: <CAKYAXd-S1HJbeM3uf8hC-nQPuf+eZEC=ygTKq01Ywm_w6Mt_QQ@mail.gmail.com>
Subject: Re: [PATCH v2 000/127] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 7:49=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi,
>
> I already used these debugging features:
>
> CONFIG_KASAN_SHADOW_OFFSET=3D0xdffffc0000000000
> CONFIG_HAVE_ARCH_KASAN=3Dy
> CONFIG_HAVE_ARCH_KASAN_VMALLOC=3Dy
> CONFIG_CC_HAS_KASAN_GENERIC=3Dy
> CONFIG_KASAN=3Dy
> CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=3Dy
> CONFIG_KASAN_GENERIC=3Dy
> CONFIG_KASAN_INLINE=3Dy
> CONFIG_KASAN_STACK=3Dy
> CONFIG_KASAN_VMALLOC=3Dy
> CONFIG_KASAN_EXTRA_INFO=3Dy
>
> But now I turned on a lot more debugging features:
>
> CONFIG_PRINTK_CALLER=3Dy
> CONFIG_STACKTRACE_BUILD_ID=3Dy
> CONFIG_DEBUG_INFO_COMPRESSED_ZSTD=3Dy
> CONFIG_DEBUG_SECTION_MISMATCH=3Dy
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=3D0xffffffff
> CONFIG_PAGE_EXTENSION=3Dy
> CONFIG_PAGE_OWNER=3Dy
> CONFIG_PAGE_TABLE_CHECK=3Dy
> CONFIG_DEBUG_PAGE_REF=3Dy
> CONFIG_PTDUMP_DEBUGFS=3Dy
> CONFIG_DEBUG_KMEMLEAK=3Dy
> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=3D16000
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=3Dy
> CONFIG_DEBUG_OBJECTS=3Dy
> CONFIG_DEBUG_OBJECTS_FREE=3Dy
> CONFIG_DEBUG_OBJECTS_TIMERS=3Dy
> CONFIG_DEBUG_OBJECTS_WORK=3Dy
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=3Dy
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=3D0
> CONFIG_WQ_WATCHDOG=3Dy
> CONFIG_PROVE_LOCKING=3Dy
> CONFIG_PROVE_RAW_LOCK_NESTING=3Dy
> CONFIG_LOCK_STAT=3Dy
> CONFIG_DEBUG_RT_MUTEXES=3Dy
> CONFIG_DEBUG_SPINLOCK=3Dy
> CONFIG_DEBUG_MUTEXES=3Dy
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=3Dy
> CONFIG_DEBUG_RWSEMS=3Dy
> CONFIG_DEBUG_LOCK_ALLOC=3Dy
> CONFIG_LOCKDEP=3Dy
> CONFIG_LOCKDEP_BITS=3D15
> CONFIG_LOCKDEP_CHAINS_BITS=3D16
> CONFIG_LOCKDEP_STACK_TRACE_BITS=3D19
> CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=3D14
> CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=3D12
> CONFIG_DEBUG_ATOMIC_SLEEP=3Dy
> CONFIG_TRACE_IRQFLAGS=3Dy
> CONFIG_TRACE_IRQFLAGS_NMI=3Dy
> CONFIG_DEBUG_IRQFLAGS=3Dy
> CONFIG_PROVE_RCU=3Dy
> CONFIG_RCU_TRACE=3Dy
> CONFIG_RING_BUFFER_ALLOW_SWAP=3Dy
> CONFIG_PREEMPTIRQ_TRACEPOINTS=3Dy
> CONFIG_TRACE_PREEMPT_TOGGLE=3Dy
> CONFIG_IRQSOFF_TRACER=3Dy
> CONFIG_PREEMPT_TRACER=3Dy
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=3Dy
>
> And that luckily revealed some cases where
> I called functions which might sleep in a
> ib_post_recv completion function that
> is called in a softirq as the client uses
> IB_POLL_SOFTIRQ.
>
> I means that I needed to deferr some of the
> smbdirect_connect_negotiate_recv_done and
> smbdirect_accept_negotiate_recv_done logic
> to the workqueue.
>
> And I added some includes to smbdirect_socket.h,
> as some sparc cross compile bot was complaining
> about a failing build.
>
> I also did a few minor changes like using
> sc->ib.dev consistently.
>
> As well as setting sc->first_error as early as possible.
>
> I took the current ksmbd-for-next-next at
> commit 2bd117c715790585d69a06bd5f795520fc67ce86
> and rebased it on v6.18-rc4 and then removed my patches
> and added the modified once on top.
>
> The result can be found in my for-6.19/fs-smb-20251104-v3 branch,
> at commit a73e9e7470238121b87b2128da2ed1fff9fd6d4b:
> git fetch https://git.samba.org/metze/linux/wip.git for-6.19/fs-smb-20251=
104-v3
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/head=
s/for-6.19/fs-smb-20251104-v3
>
> The whole diff between the old and new patchset
> follows below:
>
> The new branch should replace ksmbd-for-next-next...
I will replace them with new ones.
Thanks!

>
> Thanks!
> metze
>
>   fs/smb/common/smbdirect/smbdirect_accept.c     | 154 +++++++++++++++---=
----
>   fs/smb/common/smbdirect/smbdirect_connect.c    | 171 +++++++++++++++++-=
-------
>   fs/smb/common/smbdirect/smbdirect_connection.c |  91 +++++++++++--
>   fs/smb/common/smbdirect/smbdirect_socket.h     |  15 +++
>   4 files changed, 316 insertions(+), 115 deletions(-)
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_accept.c b/fs/smb/common/s=
mbdirect/smbdirect_accept.c
> index 0ed3f43a7397..3455e7327663 100644
> --- a/fs/smb/common/smbdirect/smbdirect_accept.c
> +++ b/fs/smb/common/smbdirect/smbdirect_accept.c
> @@ -192,25 +192,14 @@ static int smbdirect_accept_init_params(struct smbd=
irect_socket *sc)
>         return 0;
>   }
>
> +static void smbdirect_accept_negotiate_recv_work(struct work_struct *wor=
k);
> +
>   static void smbdirect_accept_negotiate_recv_done(struct ib_cq *cq, stru=
ct ib_wc *wc)
>   {
>         struct smbdirect_recv_io *recv_io =3D
>                 container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
>         struct smbdirect_socket *sc =3D recv_io->socket;
> -       struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> -       struct smbdirect_negotiate_req *nreq;
> -       u16 min_version;
> -       u16 max_version;
> -       u16 credits_requested;
> -       u32 preferred_send_size;
> -       u32 max_receive_size;
> -       u32 max_fragmented_size;
> -       struct smbdirect_send_io *send_io =3D NULL;
> -       struct smbdirect_negotiate_resp *nrep;
> -       struct ib_send_wr send_wr;
> -       u32 ntstatus;
> -       int posted;
> -       int ret;
> +       const struct smbdirect_socket_parameters *sp =3D &sc->parameters;
>
>         if (unlikely(wc->status !=3D IB_WC_SUCCESS || WARN_ON_ONCE(wc->op=
code !=3D IB_WC_RECV))) {
>                 if (wc->status !=3D IB_WC_WR_FLUSH_ERR)
> @@ -235,18 +224,98 @@ static void smbdirect_accept_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>         mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
>                          msecs_to_jiffies(sp->keepalive_interval_msec));
>
> -       ib_dma_sync_single_for_cpu(wc->qp->device,
> +       ib_dma_sync_single_for_cpu(sc->ib.dev,
>                                    recv_io->sge.addr,
>                                    recv_io->sge.length,
>                                    DMA_FROM_DEVICE);
>
> -       if (wc->byte_len < sizeof(*nreq)) {
> +       if (wc->byte_len < sizeof(struct smbdirect_negotiate_req)) {
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "wc->byte_len=3D%u < %zu\n",
> -                       wc->byte_len, sizeof(*nreq));
> +                       wc->byte_len, sizeof(struct smbdirect_negotiate_r=
eq));
>                 goto error;
>         }
>
> +       /*
> +        * We continue via the workqueue as we may have
> +        * complex work that might sleep.
> +        *
> +        * The work should already/still be disabled,
> +        * but smbdirect_connection_put_recv_io() disables
> +        * it again.
> +        *
> +        * Note that smbdirect_connection_put_recv_io()
> +        * only moved recv_io into the free list, but
> +        * we didn't call smbdirect_connection_recv_io_refill()
> +        * yet, so it won't be reused, but the cleanup code
> +        * on disconnect is able to find it, disables
> +        * recv_io->complex_work again.
> +        */
> +       smbdirect_connection_put_recv_io(recv_io);
> +       INIT_WORK(&recv_io->complex_work, smbdirect_accept_negotiate_recv=
_work);
> +       queue_work(sc->workqueue, &recv_io->complex_work);
> +       return;
> +
> +error:
> +       /*
> +        * recv_io.posted.refill_work is still disabled,
> +        * so smbdirect_connection_put_recv_io() won't
> +        * start it.
> +        */
> +       smbdirect_connection_put_recv_io(recv_io);
> +       smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
> +}
> +
> +static void smbdirect_accept_negotiate_recv_work(struct work_struct *wor=
k)
> +{
> +       struct smbdirect_recv_io *recv_io =3D
> +               container_of(work, struct smbdirect_recv_io, complex_work=
);
> +       struct smbdirect_socket *sc =3D recv_io->socket;
> +       struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> +       struct smbdirect_negotiate_req *nreq;
> +       u16 min_version;
> +       u16 max_version;
> +       u16 credits_requested;
> +       u32 preferred_send_size;
> +       u32 max_receive_size;
> +       u32 max_fragmented_size;
> +       struct smbdirect_send_io *send_io =3D NULL;
> +       struct smbdirect_negotiate_resp *nrep;
> +       struct ib_send_wr send_wr;
> +       u32 ntstatus;
> +       int posted;
> +       int ret;
> +
> +       /*
> +        * make sure we won't start again...
> +        */
> +       disable_work(work);
> +
> +       /*
> +        * Note recv_io is already part of the free list,
> +        * as smbdirect_connect_negotiate_recv_done() called
> +        * smbdirect_connection_put_recv_io(), but
> +        * it won't be reused before we call
> +        * smbdirect_connection_recv_io_refill() below.
> +        */
> +
> +       if (unlikely(sc->first_error))
> +               return;
> +
> +       if (sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
> +               /*
> +                * Something went wrong...
> +                */
> +               smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
> +                       "status=3D%s first_error=3D%1pe local: %pISpsfc r=
emote: %pISpsfc\n",
> +                       smbdirect_socket_status_string(sc->status),
> +                       SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> +                       &sc->rdma.cm_id->route.addr.src_addr,
> +                       &sc->rdma.cm_id->route.addr.dst_addr);
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
> +       }
> +
>         nreq =3D (struct smbdirect_negotiate_req *)recv_io->packet;
>         min_version =3D le16_to_cpu(nreq->min_version);
>         max_version =3D le16_to_cpu(nreq->max_version);
> @@ -281,7 +350,8 @@ static void smbdirect_accept_negotiate_recv_done(stru=
ct ib_cq *cq, struct ib_wc
>         if (credits_requested =3D=3D 0) {
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "invalid: credits_requested =3D=3D 0\n");
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         if (max_receive_size < SMBDIRECT_MIN_RECEIVE_SIZE) {
> @@ -289,7 +359,8 @@ static void smbdirect_accept_negotiate_recv_done(stru=
ct ib_cq *cq, struct ib_wc
>                         "invalid: max_receive_size=3D%u < %u\n",
>                         max_receive_size,
>                         SMBDIRECT_MIN_RECEIVE_SIZE);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         if (max_fragmented_size < SMBDIRECT_MIN_FRAGMENTED_SIZE) {
> @@ -297,7 +368,8 @@ static void smbdirect_accept_negotiate_recv_done(stru=
ct ib_cq *cq, struct ib_wc
>                         "invalid: max_fragmented_size=3D%u < %u\n",
>                         max_fragmented_size,
>                         SMBDIRECT_MIN_FRAGMENTED_SIZE);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         /*
> @@ -327,12 +399,6 @@ static void smbdirect_accept_negotiate_recv_done(str=
uct ib_cq *cq, struct ib_wc
>          */
>         sp->max_fragmented_send_size =3D max_fragmented_size;
>
> -       /*
> -        * Give recv_io back to the recv_io.free.list,
> -        * so that the refill can also post it.
> -        */
> -       smbdirect_connection_put_recv_io(recv_io);
> -
>         /*
>          * Prepare for receiving data_transfer messages
>          */
> @@ -350,7 +416,8 @@ static void smbdirect_accept_negotiate_recv_done(stru=
ct ib_cq *cq, struct ib_wc
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_recv_io_refill() failed %1p=
e\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(posted));
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         /*
> @@ -365,11 +432,11 @@ static void smbdirect_accept_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>         send_io =3D smbdirect_connection_alloc_send_io(sc);
>         if (IS_ERR(send_io)) {
>                 ret =3D PTR_ERR(send_io);
> -               send_io =3D NULL;
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_alloc_send_io() failed %1pe=
\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, ret);
> +               return;
>         }
>         send_io->cqe.done =3D smbdirect_accept_negotiate_send_done;
>
> @@ -430,7 +497,9 @@ static void smbdirect_accept_negotiate_recv_done(stru=
ct ib_cq *cq, struct ib_wc
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "ib_dma_mapping_error() failed %1pe\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto error;
> +               smbdirect_connection_free_send_io(send_io);
> +               smbdirect_connection_schedule_disconnect(sc, ret);
> +               return;
>         }
>
>         send_io->sge[0].length =3D sizeof(*nrep);
> @@ -455,30 +524,19 @@ static void smbdirect_accept_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>                 smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_post_send_wr() failed %1pe\=
n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto error;
> +               /*
> +                * Note smbdirect_connection_free_send_io()
> +                * does ib_dma_unmap_page()
> +                */
> +               smbdirect_connection_free_send_io(send_io);
> +               smbdirect_connection_schedule_disconnect(sc, ret);
> +               return;
>         }
>
>         /*
>          * smbdirect_accept_negotiate_send_done
>          * will do all remaining work...
>          */
> -       return;
> -
> -error:
> -       /*
> -        * recv_io.posted.refill_work is still disabled,
> -        * so smbdirect_connection_put_recv_io() won't
> -        * start it.
> -        */
> -       if (recv_io)
> -               smbdirect_connection_put_recv_io(recv_io);
> -       /*
> -        * Note smbdirect_connection_free_send_io()
> -        * does ib_dma_unmap_page()
> -        */
> -       if (send_io)
> -               smbdirect_connection_free_send_io(send_io);
> -       smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
>   }
>
>   static void smbdirect_accept_negotiate_send_done(struct ib_cq *cq, stru=
ct ib_wc *wc)
> diff --git a/fs/smb/common/smbdirect/smbdirect_connect.c b/fs/smb/common/=
smbdirect/smbdirect_connect.c
> index eb8e903c9fce..b9544a6ef59b 100644
> --- a/fs/smb/common/smbdirect/smbdirect_connect.c
> +++ b/fs/smb/common/smbdirect/smbdirect_connect.c
> @@ -536,23 +536,14 @@ static void smbdirect_connect_negotiate_send_done(s=
truct ib_cq *cq, struct ib_wc
>         }
>   }
>
> +static void smbdirect_connect_negotiate_recv_work(struct work_struct *wo=
rk);
> +
>   static void smbdirect_connect_negotiate_recv_done(struct ib_cq *cq, str=
uct ib_wc *wc)
>   {
>         struct smbdirect_recv_io *recv_io =3D
>                 container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
>         struct smbdirect_socket *sc =3D recv_io->socket;
> -       struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> -       struct smbdirect_negotiate_resp *nrep;
> -       u16 negotiated_version;
> -       u16 credits_requested;
> -       u16 credits_granted;
> -       u32 status;
> -       u32 max_readwrite_size;
> -       u32 preferred_send_size;
> -       u32 max_receive_size;
> -       u32 max_fragmented_size;
> -       int posted;
> -       int ret;
> +       const struct smbdirect_socket_parameters *sp =3D &sc->parameters;
>
>         if (unlikely(wc->status !=3D IB_WC_SUCCESS || WARN_ON_ONCE(wc->op=
code !=3D IB_WC_RECV))) {
>                 if (wc->status !=3D IB_WC_WR_FLUSH_ERR)
> @@ -574,18 +565,96 @@ static void smbdirect_connect_negotiate_recv_done(s=
truct ib_cq *cq, struct ib_wc
>         mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
>                          msecs_to_jiffies(sp->keepalive_interval_msec));
>
> -       ib_dma_sync_single_for_cpu(wc->qp->device,
> +       ib_dma_sync_single_for_cpu(sc->ib.dev,
>                                    recv_io->sge.addr,
>                                    recv_io->sge.length,
>                                    DMA_FROM_DEVICE);
>
> -       if (wc->byte_len < sizeof(*nrep)) {
> +       if (wc->byte_len < sizeof(struct smbdirect_negotiate_resp)) {
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "wc->byte_len=3D%u < %zu\n",
> -                       wc->byte_len, sizeof(*nrep));
> +                       wc->byte_len, sizeof(struct smbdirect_negotiate_r=
esp));
>                 goto error;
>         }
>
> +       /*
> +        * We continue via the workqueue as we may have
> +        * complex work that might sleep.
> +        *
> +        * The work should already/still be disabled,
> +        * but smbdirect_connection_put_recv_io() disables
> +        * it again.
> +        *
> +        * Note that smbdirect_connection_put_recv_io()
> +        * only moved recv_io into the free list, but
> +        * we didn't call smbdirect_connection_recv_io_refill()
> +        * yet, so it won't be reused, but the cleanup code
> +        * on disconnect is able to find it, disables
> +        * recv_io->complex_work again.
> +        */
> +       smbdirect_connection_put_recv_io(recv_io);
> +       INIT_WORK(&recv_io->complex_work, smbdirect_connect_negotiate_rec=
v_work);
> +       queue_work(sc->workqueue, &recv_io->complex_work);
> +       return;
> +
> +error:
> +       /*
> +        * recv_io.posted.refill_work is still disabled,
> +        * so smbdirect_connection_put_recv_io() won't
> +        * start it.
> +        */
> +       smbdirect_connection_put_recv_io(recv_io);
> +       smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
> +}
> +
> +static void smbdirect_connect_negotiate_recv_work(struct work_struct *wo=
rk)
> +{
> +       struct smbdirect_recv_io *recv_io =3D
> +               container_of(work, struct smbdirect_recv_io, complex_work=
);
> +       struct smbdirect_socket *sc =3D recv_io->socket;
> +       struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> +       struct smbdirect_negotiate_resp *nrep;
> +       u16 negotiated_version;
> +       u16 credits_requested;
> +       u16 credits_granted;
> +       u32 status;
> +       u32 max_readwrite_size;
> +       u32 preferred_send_size;
> +       u32 max_receive_size;
> +       u32 max_fragmented_size;
> +       int posted;
> +       int ret;
> +
> +       /*
> +        * make sure we won't start again...
> +        */
> +       disable_work(work);
> +
> +       /*
> +        * Note recv_io is already part of the free list,
> +        * as smbdirect_connect_negotiate_recv_done() called
> +        * smbdirect_connection_put_recv_io(), but
> +        * it won't be reused before we call
> +        * smbdirect_connection_recv_io_refill() below.
> +        */
> +
> +       if (unlikely(sc->first_error))
> +               return;
> +
> +       if (sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
> +               /*
> +                * Something went wrong...
> +                */
> +               smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
> +                       "status=3D%s first_error=3D%1pe local: %pISpsfc r=
emote: %pISpsfc\n",
> +                       smbdirect_socket_status_string(sc->status),
> +                       SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> +                       &sc->rdma.cm_id->route.addr.src_addr,
> +                       &sc->rdma.cm_id->route.addr.dst_addr);
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
> +       }
> +
>         nrep =3D (struct smbdirect_negotiate_resp *)recv_io->packet;
>         negotiated_version =3D le16_to_cpu(nrep->negotiated_version);
>         credits_requested =3D le16_to_cpu(nrep->credits_requested);
> @@ -623,7 +692,16 @@ static void smbdirect_connect_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "invalid: negotiated_version=3D0x%x\n",
>                         negotiated_version);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNREFUSE=
D);
> +               return;
> +       }
> +
> +       if (status !=3D 0) {
> +               smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
> +                       "invalid: status=3D0x%x !=3D 0x0\n",
> +                       status);
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNREFUSE=
D);
> +               return;
>         }
>
>         if (max_receive_size < SMBDIRECT_MIN_RECEIVE_SIZE) {
> @@ -631,7 +709,8 @@ static void smbdirect_connect_negotiate_recv_done(str=
uct ib_cq *cq, struct ib_wc
>                         "invalid: max_receive_size=3D%u < %u\n",
>                         max_receive_size,
>                         SMBDIRECT_MIN_RECEIVE_SIZE);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         if (max_fragmented_size < SMBDIRECT_MIN_FRAGMENTED_SIZE) {
> @@ -639,19 +718,22 @@ static void smbdirect_connect_negotiate_recv_done(s=
truct ib_cq *cq, struct ib_wc
>                         "invalid: max_fragmented_size=3D%u < %u\n",
>                         max_fragmented_size,
>                         SMBDIRECT_MIN_FRAGMENTED_SIZE);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         if (credits_granted =3D=3D 0) {
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "invalid: credits_granted =3D=3D 0\n");
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         if (credits_requested =3D=3D 0) {
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "invalid: credits_requested =3D=3D 0\n");
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         if (preferred_send_size > sp->max_recv_size) {
> @@ -659,14 +741,8 @@ static void smbdirect_connect_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>                         "invalid: preferred_send_size=3D%u < max_recv_siz=
e=3D%u\n",
>                         preferred_send_size,
>                         sp->max_recv_size);
> -               goto error;
> -       }
> -
> -       if (status !=3D 0) {
> -               smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
> -                       "invalid: status=3D0x%x !=3D 0x0\n",
> -                       status);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         /*
> @@ -701,7 +777,8 @@ static void smbdirect_connect_negotiate_recv_done(str=
uct ib_cq *cq, struct ib_wc
>                         "invalid: max_readwrite_size=3D%u < PAGE_SIZE(%lu=
)\n",
>                         max_readwrite_size,
>                         PAGE_SIZE);
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>         sp->max_frmr_depth =3D sp->max_read_write_size / PAGE_SIZE;
>
> @@ -716,11 +793,14 @@ static void smbdirect_connect_negotiate_recv_done(s=
truct ib_cq *cq, struct ib_wc
>          */
>         sp->max_fragmented_send_size =3D max_fragmented_size;
>
> -       /*
> -        * Give recv_io back to the recv_io.free.list,
> -        * so that the refill can also post it.
> -        */
> -       smbdirect_connection_put_recv_io(recv_io);
> +       ret =3D smbdirect_connection_create_mr_list(sc);
> +       if (ret) {
> +               smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> +                       "smbdirect_connection_create_mr_list() failed %1p=
e\n",
> +                       SMBDIRECT_DEBUG_ERR_PTR(ret));
> +               smbdirect_connection_schedule_disconnect(sc, ret);
> +               return;
> +       }
>
>         /*
>          * Prepare for receiving data_transfer messages
> @@ -731,14 +811,6 @@ static void smbdirect_connect_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>                 recv_io->cqe.done =3D smbdirect_connection_recv_io_done;
>         recv_io =3D NULL;
>
> -       ret =3D smbdirect_connection_create_mr_list(sc);
> -       if (ret) {
> -               smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -                       "smbdirect_connection_create_mr_list() failed %1p=
e\n",
> -                       SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto error;
> -       }
> -
>         /*
>          * We should at least post 1 smbdirect_recv_io!
>          */
> @@ -747,7 +819,8 @@ static void smbdirect_connect_negotiate_recv_done(str=
uct ib_cq *cq, struct ib_wc
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_recv_io_refill() failed %1p=
e\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto error;
> +               smbdirect_connection_schedule_disconnect(sc, -ECONNABORTE=
D);
> +               return;
>         }
>
>         /*
> @@ -756,18 +829,6 @@ static void smbdirect_connect_negotiate_recv_done(st=
ruct ib_cq *cq, struct ib_wc
>          * the waiter.
>          */
>         smbdirect_connection_negotiation_done(sc);
> -
> -       return;
> -
> -error:
> -       /*
> -        * recv_io.posted.refill_work is still disabled,
> -        * so smbdirect_connection_put_recv_io() won't
> -        * start it.
> -        */
> -       if (recv_io)
> -               smbdirect_connection_put_recv_io(recv_io);
> -       smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
>   }
>
>   __SMBDIRECT_PUBLIC__
> diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/comm=
on/smbdirect/smbdirect_connection.c
> index ae9626888b5c..cc22e8b2f4d3 100644
> --- a/fs/smb/common/smbdirect/smbdirect_connection.c
> +++ b/fs/smb/common/smbdirect/smbdirect_connection.c
> @@ -742,6 +742,8 @@ int smbdirect_connection_create_mem_pools(struct smbd=
irect_socket *sc)
>                         goto err;
>                 recv_io->socket =3D sc;
>                 recv_io->sge.length =3D 0;
> +               INIT_WORK(&recv_io->complex_work, __smbdirect_socket_disa=
bled_work);
> +               disable_work_sync(&recv_io->complex_work);
>                 list_add_tail(&recv_io->list, &sc->recv_io.free.list);
>         }
>
> @@ -757,6 +759,10 @@ void smbdirect_connection_destroy_mem_pools(struct s=
mbdirect_socket *sc)
>         struct smbdirect_recv_io *recv_io, *next_io;
>
>         list_for_each_entry_safe(recv_io, next_io, &sc->recv_io.free.list=
, list) {
> +               /*
> +                * The work should already be disabled
> +                */
> +               disable_work_sync(&recv_io->complex_work);
>                 list_del(&recv_io->list);
>                 mempool_free(recv_io, sc->recv_io.mem.pool);
>         }
> @@ -833,9 +839,10 @@ struct smbdirect_recv_io *smbdirect_connection_get_r=
ecv_io(struct smbdirect_sock
>         unsigned long flags;
>
>         spin_lock_irqsave(&sc->recv_io.free.lock, flags);
> -       msg =3D list_first_entry_or_null(&sc->recv_io.free.list,
> -                                      struct smbdirect_recv_io,
> -                                      list);
> +       if (likely(!sc->first_error))
> +               msg =3D list_first_entry_or_null(&sc->recv_io.free.list,
> +                                              struct smbdirect_recv_io,
> +                                              list);
>         if (likely(msg)) {
>                 list_del(&msg->list);
>                 sc->statistics.get_receive_buffer++;
> @@ -851,6 +858,11 @@ void smbdirect_connection_put_recv_io(struct smbdire=
ct_recv_io *msg)
>         struct smbdirect_socket *sc =3D msg->socket;
>         unsigned long flags;
>
> +       /*
> +        * Should already be disabled anyway.
> +        */
> +       disable_work(&msg->complex_work);
> +
>         if (likely(msg->sge.length !=3D 0)) {
>                 ib_dma_unmap_single(sc->ib.dev,
>                                     msg->sge.addr,
> @@ -874,6 +886,11 @@ static void smbdirect_connection_reassembly_append_r=
ecv_io(struct smbdirect_sock
>   {
>         unsigned long flags;
>
> +       /*
> +        * The work should already/still be disabled
> +        */
> +       disable_work(&msg->complex_work);
> +
>         spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
>         list_add_tail(&msg->list, &sc->recv_io.reassembly.list);
>         sc->recv_io.reassembly.queue_length++;
> @@ -968,6 +985,14 @@ __SMBDIRECT_PRIVATE__
>   void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *=
sc,
>                                               int error)
>   {
> +       struct smbdirect_recv_io *recv_io, *recv_tmp;
> +       unsigned long flags;
> +
> +       if (sc->first_error =3D=3D 0)
> +               sc->first_error =3D error;
> +       if (sc->first_error =3D=3D 0)
> +               sc->first_error =3D -ECONNABORTED;
> +
>         /*
>          * make sure other work (than disconnect_work)
>          * is not queued again but here we don't block and avoid
> @@ -979,10 +1004,19 @@ void smbdirect_connection_schedule_disconnect(stru=
ct smbdirect_socket *sc,
>         sc->idle.keepalive =3D SMBDIRECT_KEEPALIVE_NONE;
>         disable_delayed_work(&sc->idle.timer_work);
>
> -       if (sc->first_error =3D=3D 0)
> -               sc->first_error =3D error;
> -       if (sc->first_error =3D=3D 0)
> -               sc->first_error =3D -ECONNABORTED;
> +       /*
> +        * If any complex work was scheduled we
> +        * should disable it (only happens during
> +        * negotiation)...
> +        *
> +        * Note that sc->first_error is set before,
> +        * so any future smbdirect_connection_get_recv_io()
> +        * will see it and return NULL.
> +        */
> +       spin_lock_irqsave(&sc->recv_io.free.lock, flags);
> +       list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.lis=
t, list)
> +               disable_work(&recv_io->complex_work);
> +       spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
>
>         switch (sc->status) {
>         case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
> @@ -1037,12 +1071,17 @@ static void smbdirect_connection_disconnect_work(=
struct work_struct *work)
>   {
>         struct smbdirect_socket *sc =3D
>                 container_of(work, struct smbdirect_socket, disconnect_wo=
rk);
> +       struct smbdirect_recv_io *recv_io, *recv_tmp;
> +       unsigned long flags;
>
>         /*
>          * This should not never be called in an interrupt!
>          */
>         WARN_ON_ONCE(in_interrupt());
>
> +       if (sc->first_error =3D=3D 0)
> +               sc->first_error =3D -ECONNABORTED;
> +
>         /*
>          * make sure this and other work is not queued again
>          * but here we don't block and avoid
> @@ -1055,8 +1094,19 @@ static void smbdirect_connection_disconnect_work(s=
truct work_struct *work)
>         sc->idle.keepalive =3D SMBDIRECT_KEEPALIVE_NONE;
>         disable_delayed_work(&sc->idle.timer_work);
>
> -       if (sc->first_error =3D=3D 0)
> -               sc->first_error =3D -ECONNABORTED;
> +       /*
> +        * If any complex work was scheduled we
> +        * should disable it (only happens during
> +        * negotiation)...
> +        *
> +        * Note that sc->first_error is set before,
> +        * so any future smbdirect_connection_get_recv_io()
> +        * will see it and return NULL.
> +        */
> +       spin_lock_irqsave(&sc->recv_io.free.lock, flags);
> +       list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.lis=
t, list)
> +               disable_work(&recv_io->complex_work);
> +       spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
>
>         switch (sc->status) {
>         case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
> @@ -1216,6 +1266,24 @@ static void smbdirect_connection_destroy(struct sm=
bdirect_socket *sc)
>         disable_work_sync(&sc->idle.immediate_work);
>         disable_delayed_work_sync(&sc->idle.timer_work);
>
> +       /*
> +        * If any complex work was scheduled we
> +        * should disable it (only happens during
> +        * negotiation)...
> +        *
> +        * Note was already set in sc->first_error in
> +        * smbdirect_connection_schedule_disconnect() or
> +        * smbdirect_connection_disconnect_work(), both
> +        * before time before:
> +        * spin_lock_irqsave(&sc->recv_io.free.lock, flags),
> +        * so any future smbdirect_connection_get_recv_io()
> +        * will see it and return NULL. And we don't
> +        * need to get the lock here again, while
> +        * trying disable_work_sync().
> +        */
> +       list_for_each_entry_safe(recv_io, recv_tmp, &sc->recv_io.free.lis=
t, list)
> +               disable_work_sync(&recv_io->complex_work);
> +
>         if (sc->rdma.cm_id)
>                 rdma_lock_handler(sc->rdma.cm_id);
>
> @@ -1231,9 +1299,8 @@ static void smbdirect_connection_destroy(struct smb=
direct_socket *sc)
>         spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
>         list_splice_tail_init(&sc->recv_io.reassembly.list, &all_list);
>         spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
> -       list_for_each_entry_safe(recv_io, recv_tmp, &all_list, list) {
> +       list_for_each_entry_safe(recv_io, recv_tmp, &all_list, list)
>                 smbdirect_connection_put_recv_io(recv_io);
> -       }
>         sc->recv_io.reassembly.data_length =3D 0;
>
>         smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
> @@ -2002,7 +2069,7 @@ void smbdirect_connection_recv_io_done(struct ib_cq=
 *cq, struct ib_wc *wc)
>         mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
>                          msecs_to_jiffies(sp->keepalive_interval_msec));
>
> -       ib_dma_sync_single_for_cpu(wc->qp->device,
> +       ib_dma_sync_single_for_cpu(sc->ib.dev,
>                                    recv_io->sge.addr,
>                                    recv_io->sge.length,
>                                    DMA_FROM_DEVICE);
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/s=
mbdirect/smbdirect_socket.h
> index 65f25fc4b4a7..ef151ff1c02a 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.h
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.h
> @@ -6,6 +6,13 @@
>   #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
>   #define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
>
> +#include <linux/wait.h>
> +#include <linux/workqueue.h>
> +#include <linux/kref.h>
> +#include <linux/mempool.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +#include <linux/completion.h>
>   #include <rdma/rw.h>
>
>   enum smbdirect_socket_status {
> @@ -617,6 +624,14 @@ struct smbdirect_recv_io {
>   #define SMBDIRECT_RECV_IO_MAX_SGE 1
>         struct ib_sge sge;
>
> +       /*
> +        * We may need to handle complex
> +        * work that might sleep and are
> +        * not allowed to run in an interrupt
> +        * context.
> +        */
> +       struct work_struct complex_work;
> +
>         /* Link to free or reassembly list */
>         struct list_head list;
>
>
