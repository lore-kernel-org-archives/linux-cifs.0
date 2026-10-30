Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793364171;
	b=Ig64kjsy7eK444SQHPHP2m/MwacibFFu2WHcF79OIJApGIPtxMgykYe+Sdlm8+CO3n6K
	 p+0Y95ScdPrV8+xmHIa8xNeKNh3QBhxXEwOddlrIyk2an6V423Uul/LR4gS5KeNpR9Nc3
	 RfnunrljzfBNSy34uymMwptZAQRJ5H2+tADxSisHASvb2dDpT3HUCp8KHqowD99HQ7hp2
	 +aLp4W3ySCPwqOtuTUEHSujcpmUK79vUpzs6/57KGEzR4E/jGOqFfxODWnlYAhX+RihS8
	 uyguMh9lGhNPMxyRjEzfajfuxw8H3OMly6fNqWl8MzYSjdpxlAzOi9FNKzUblcjZJ8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793364171;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=dRLoK9jlTNJJs7zPjgVZeCjp+dpCJB+jK2/EPp3bJqQ=;
	b=vkMFu5i3vFuGnkzmvpHbgfqyJq8U/aa12wiMsUKVqbGgQo6L3FQ94AzBvBeIA8gwMJ/N
	 5IGly/sBiaE/yhkeOv9tyz9wxh0tVc3lQZYyqvZvguxFadLUHkGOV2UKH11b8sc2pY4nc
	 wdo4LD+O2umdbhdvHSs1/fJjFO3rVEG1kh5yuuZFq8kyYj0yzR9x4a6yghzxtRoqMbxMm
	 3/IOZ0KyCs3cqK8bxNxLM5rwH/yDiwAr16R26RKrYYEfEGpvKJ03WXrXCpADgqXxrlfgs
	 yEciR9EBFWkVvRbo94vD7XkyMhITKSiWsPHedhpJDCZlAMMaMSC18FkVRf1uB37W8qQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bmpvdW5Z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EBF606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 12:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64EBF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bmpvdW5Z
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b1d8944cb0so971274a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 30 Oct 2026 05:42:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793364169; cv=none;
        d=google.com; s=arc-20260327;
        b=lmQvRubHwZpfrgs2CuoVrcXX/4BRCD/y2V67L9KQoBJPSZwTuinfJnM48D9WSNRUDJ
         uzDh0POZVtwjQXbdHqOBi4AjCAgufaoYw6iOWgiVp3g4HPe0kzBu9ip7NuWjCJ/QkI0A
         WJ+GXft+9SA06aMmVlQ/jghYSTN86mxbbYS955+b98b8CmAP0+glsxUmzQilCHqMONb3
         cSgxU/L4AT3pf0R/r4uYT1CCoyl0sTwfPykVnmpBGR0wO2Fp5638cy9ho5f8aBV+uOaK
         b9wGVt04kDEQFf9I+inrUugCXFWKpjTXvJjCxYbF88uFp8YpbeO+Adtre4wGUHL+Fgyw
         IODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dRLoK9jlTNJJs7zPjgVZeCjp+dpCJB+jK2/EPp3bJqQ=;
        fh=7PDl07VxEo6UCVxG5cwhj+9XqbtT5+cEzcL1xMdDW8c=;
        b=TK+eNQVOazcCdSPxja16kW3gpvLyruh/2tWx8+KdZB8K8rgikfZRQ9RzFv1E0M7fTC
         p5A86sw0rYVIMFp+5pfke2Bdmt19ZKvez0bUtJzzDikpnx2833D5VOX3rFfCfgcmqszY
         k1jHhF0xkBDsYOOtOI473OfARHmQXzBfIo3ii/kBc6Kj+bm4NTGsGZLi5AnROyz30j1B
         y2omgrScNTpuFfzLwDQ30ow29G1D+kbP64HyRDwrFvKTeaei/gOoPd/HFN6IBxYLPjTx
         EUnDTiJHRzTfc+JUulWp4tSZGpgoO825azaATtPZClC5K644oxSlzZeaa2INfw3NRbEP
         g+rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793364169; x=1793968969; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dRLoK9jlTNJJs7zPjgVZeCjp+dpCJB+jK2/EPp3bJqQ=;
        b=bmpvdW5ZppdRTiQ8uX1Yq4j4v1IxOPT6B6YpBueR5p+9oeiNlik3/Q2cZyBP4psm7J
         b1iOd8WDRy6SOckVPaBQISrAcCNnUuc2AB2FdGKohYIPrLdDmukq1wOyhyHIzOaOKwKE
         xEUq3OcTDrHcaSlQODcBb6qp7yCu1DwzoQrVhYzOA5cZAYHtKxBfQRCiATCooMTndJ+y
         pGaQpHpQ7YWs0WyDInQG3Y/wELLTkMu6MsjzUwpA05NhUTcosZhu49dQi2elIigIgkSH
         OFgtsUgGuZAEH9PyPf4ZSdWMJNzzLnVOvUEEUzYl8kE0K5AFR9P6SbX7dfUj7oVQ3zLw
         mCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793364169; x=1793968969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dRLoK9jlTNJJs7zPjgVZeCjp+dpCJB+jK2/EPp3bJqQ=;
        b=koQz2UfLH4gXftX8oT1pOsc99iHVhjOw7ROeJ8C9/5x+RlJWwF0M0LtX8fdeonuRBP
         yLz9YCeK/TJGDQlsjVboJeCGzRan4b7pdhTVyIXp+/zsrGCIfd3r0cd6SK/8dS1uZQMo
         Ks+z/xvv0YJOdYxu+ianbszz//07QP0FPCnKa6plOkIJD2HYT/UhoWU7GLJudIUUlnfQ
         VcgnBC9Op4UkUqchhROhfVUHKy0gmrMHddmxqAlWun6x01GQhbvH/XM8cKUDGuNhRYEm
         fet1TDv6L1068g7AfGrgw1Lm4qE8BM9r855Bj1+4x4OmqRXxz1yW6MMx3B5BbSb4Wsrx
         OMEA==
X-Forwarded-Encrypted: i=1; AKwUvByS2OfLLFXrRZp70rayOVu4T2ZUQIJ5waGV0xdPiuue9HDUdYnUjyWECpVwgYvruEuZxXEWpIjE88bn@vger.kernel.org
X-Gm-Message-State: AFq9FYLTYf0++B5jklXCKheeSzafQ9HkX2Q3bYNI1xTlA/jwJFXzGUWY
	N+EEXWU5YwWYR9x4WpQVF1uvBxlsw8wxLgpZ+kWEObhqw575bimEPNj8BVK8P32pVBUMOc3z5N7
	75APn6WfMIjGCizouBPIFoS+G1S6nEuA=
X-Gm-Gg: AYBFou1ZkOfweT+egKffLZcZiubxVkAQdlbwuwHxz15TH4AlX/twXBVCi9gP2ntDqQ4
	xQL/fLFKlxGdZY5fYLxbUUp6CZomjKf6VDZW+t6nQnu8zlqo+xQ6qkIhkODm7vRJtx28HMQv1ym
	LRa+Bn+qZOdoNUrcMRS0C6dNspzsiShN7+3hhnIncnS3qEHXzWTdokL7wDWQWkXTg0/S04Y/pF/
	VnFCgGGx1WGxY7KbGcZYIzm71BTT7Gatl5w6VzarFo5SiZEsZJZijbOMgYB3kTea5wFwq1gNkY+
	qsDfPi+x/w3xvtbWTqhlAXYIjy4yzWdvVMw6mr9S1vNqYJUcqYX01rd9XjPXb+DYCbOwsksE/N0
	UD+ZoIwFUg408bVoZNMgr6NukQdfnh+ljpVh5X5nZVSIGUb0dLqIf4oD2gM3SO1VMUd4696yByw
	F2kWTcUCRdzwegOtLr5Q==
X-Received: by 2002:a05:6402:44c8:b0:6b1:e87d:5b60 with SMTP id
 4fb4d7f45d1cf-6b4d4686cc2mr1271118a12.15.1793364168541; Fri, 30 Oct 2026
 05:42:48 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030121255.257615100@linuxfoundation.org> <20261030121255.340929047@linuxfoundation.org>
In-Reply-To: <20261030121255.340929047@linuxfoundation.org>
From: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Date: Fri, 30 Oct 2026 19:42:36 +0700
X-Gm-Features: AclHuK_OHGVjNArrfT-XDMiHY3ZkV98D-6dtJnTj0YyqP88y2MaTBsOnzKj9YMI
Message-ID: <CANTrAmwxWR3z+M=QQ66FJShrF0EBR7Akxvxqm5U_cE0FuutGGA@mail.gmail.com>
Subject: Re: [PATCH 7.2 03/10] smb: smbdirect: release failed pending sockets
 of a listener
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sashiko <sashiko-bot+sashiko@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Stefan Metzmacher <metze@samba.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg and Stefan,

Thank you for fixing the SMB Direct listener backlog issue and
for considering the fix for 7.2-stable.

I also appreciate you preserving my Reported-by credit.

Best regards,
Lee Seong Hyeon

On Fri, Oct 30, 2026 at 7:15=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 7.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Stefan Metzmacher <metze@samba.org>
>
> [ Upstream commit 328c7e307e8411899e2f90beae83da9e4c45d700 ]
>
> A child of a listener only left the listen.pending or listen.ready
> list via smbdirect_socket_accept() or when the listener was
> destroyed. So every connection that failed before it was accepted
> (negotiate timeout, peer disconnect, invalid negotiate request, ...)
> stayed on the list and counted against the backlog until the listener
> was destroyed. After about backlog (10 for ksmbd) such connections
> smbdirect_listen_connect_request() rejected every new connection with
> -EBUSY, so an unauthenticated peer was able to permanently stop
> ksmbd from accepting SMB-Direct connections.
>
> Now a failed child moves itself to a new listen.orphaned list at the
> end of smbdirect_socket_cleanup_work(), after the disconnect was
> started, and queues listen.purge_orphaned_work, which releases it
> with smbdirect_socket_release(), without holding the listener's
> rdma_lock_handler() lock, in the same way smbdirect_socket_destroy()
> does for the remaining children. Orphaned sockets still count against
> the backlog until they are released.
>
> sc->accept.listener is now only changed under listener->listen.lock
> and whoever clears it is responsible for releasing the socket:
> smbdirect_socket_accept(), purge_orphaned_work or the destroy of the
> listener.
>
> In order to make that work:
>
> - a struct smbdirect_socket that is a listener is now freed via
>   kfree_rcu(), so that a child can dereference sc->accept.listener
>   under rcu_read_lock(), even if the listener is released concurrently.
>
> - smbdirect_listen_connect_request() adds nsc to the listen.pending
>   list and sets nsc->accept.listener before it calls
>   smbdirect_accept_connect_request(), and always returns 0 so the
>   rdma_cm core keeps the connection id and nsc owns it. On a non-zero
>   return it schedules nsc's teardown with
>   smbdirect_socket_schedule_cleanup(), which orphans it off the
>   listener so that purge_orphaned_work releases it; nsc destroys its
>   own connection id with rdma_destroy_id() in that teardown. The
>   teardown has to be deferred because the rdma_cm core holds nsc's
>   id_priv->handler_mutex across the handler, so nsc->rdma.cm_id must
>   not be destroyed synchronously from here. That same handler_mutex
>   (and the listener's) also guarantees nsc can't go away under us,
>   so setting the listener before the call is safe and lets a failure
>   orphan nsc.
>
> - smbdirect_accept_negotiate_recv_work() no longer moves a socket to
>   the ready list if it already failed or no longer belongs to the
>   listener. Every accepting socket has a listener, so if
>   sc->accept.listener is already cleared, it no longer sends a
>   negotiate response, as the socket is about to be released.
>
> - smbdirect_socket_destroy() of the listener disables
>   purge_orphaned_work and also releases the orphaned sockets.
>
> Fixes: dc691b91ad16 ("smb: smbdirect: introduce smbdirect_socket_{listen,=
accept}()")
> Reported-by: Lee Seong Hyeon <ihopenre@gmail.com>
> Closes: https://lore.kernel.org/linux-cifs/CANTrAmxL5sWU8Sn29JAGZvSq5PBB2=
OA+VKA0MHsZJMesagtfzA@mail.gmail.com/
> Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
> Closes: https://sashiko.dev/#/patchset/cover.1791224972.git.metze%40samba=
.org
> Closes: https://sashiko.dev/#/patchset/cover.1791229120.git.metze%40samba=
.org
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Paulo Alcantara <pc@manguebit.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/smb/smbdirect/accept.c   | 141 +++++++++++++++++++++++-------------
>  fs/smb/smbdirect/internal.h |   2 +
>  fs/smb/smbdirect/listen.c   | 137 ++++++++++++++++++++++++++++++++---
>  fs/smb/smbdirect/socket.c   |  57 ++++++++++++++-
>  fs/smb/smbdirect/socket.h   |  42 +++++++++++
>  5 files changed, 314 insertions(+), 65 deletions(-)
>
> diff --git a/fs/smb/smbdirect/accept.c b/fs/smb/smbdirect/accept.c
> index 039c9bfbd8acd..66db978bd8f73 100644
> --- a/fs/smb/smbdirect/accept.c
> +++ b/fs/smb/smbdirect/accept.c
> @@ -19,15 +19,33 @@ int smbdirect_accept_connect_request(struct smbdirect=
_socket *sc,
>                                      const struct rdma_conn_param *param)
>  {
>         struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> -       struct smbdirect_recv_io *recv_io;
> +       struct smbdirect_recv_io *recv_io =3D NULL;
>         u8 peer_initiator_depth;
>         u8 peer_responder_resources;
>         struct rdma_conn_param conn_param;
>         __be32 ird_ord_hdr[2];
>         int ret;
>
> -       if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_CREATED))
> -               return -EINVAL;
> +       /*
> +        * Install the real event handler (and the event we expect next)
> +        * before anything that can fail. On an early error the caller
> +        * (smbdirect_listen_connect_request()) only schedules our deferr=
ed
> +        * cleanup and returns 0 to the rdma_cm core, which keeps the cm_=
id, so
> +        * the cm_id must already carry smbdirect_accept_rdma_event_handl=
er():
> +        * it turns any unexpected event (e.g. RDMA_CM_EVENT_DEVICE_REMOV=
AL)
> +        * into a clean smbdirect_socket_schedule_cleanup(). Otherwise th=
e
> +        * placeholder smbdirect_socket_rdma_event_handler() installed by
> +        * smbdirect_socket_init_accepting() stays in place and returns -=
ESTALE,
> +        * which makes the rdma_cm core destroy the cm_id behind the back=
 of our
> +        * pending teardown.
> +        */
> +       sc->rdma.expected_event =3D RDMA_CM_EVENT_ESTABLISHED;
> +       sc->rdma.cm_id->event_handler =3D smbdirect_accept_rdma_event_han=
dler;
> +
> +       if (SMBDIRECT_CHECK_STATUS_WARN(sc, SMBDIRECT_SOCKET_CREATED)) {
> +               ret =3D -EINVAL;
> +               goto cleanup;
> +       }
>
>         /*
>          * First set what the we as server are able to support
> @@ -47,7 +65,7 @@ int smbdirect_accept_connect_request(struct smbdirect_s=
ocket *sc,
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_accept_init_params() failed %1pe\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto init_params_failed;
> +               goto cleanup;
>         }
>
>         ret =3D smbdirect_connection_create_qp(sc);
> @@ -55,7 +73,7 @@ int smbdirect_accept_connect_request(struct smbdirect_s=
ocket *sc,
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_create_qp() failed %1pe\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto create_qp_failed;
> +               goto cleanup;
>         }
>
>         ret =3D smbdirect_connection_create_mem_pools(sc);
> @@ -63,7 +81,7 @@ int smbdirect_accept_connect_request(struct smbdirect_s=
ocket *sc,
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_create_mem_pools() failed %=
1pe\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto create_mem_failed;
> +               goto cleanup;
>         }
>
>         recv_io =3D smbdirect_connection_get_recv_io(sc);
> @@ -72,7 +90,7 @@ int smbdirect_accept_connect_request(struct smbdirect_s=
ocket *sc,
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_get_recv_io() failed %1pe\n=
",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto get_recv_io_failed;
> +               goto cleanup;
>         }
>         recv_io->cqe.done =3D smbdirect_accept_negotiate_recv_done;
>
> @@ -86,7 +104,7 @@ int smbdirect_accept_connect_request(struct smbdirect_=
socket *sc,
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "smbdirect_connection_post_recv_io() failed %1pe\=
n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto post_recv_io_failed;
> +               goto cleanup;
>         }
>         /*
>          * From here recv_io is known to the RDMA QP and needs ib_drain_q=
p and
> @@ -122,14 +140,12 @@ int smbdirect_accept_connect_request(struct smbdire=
ct_socket *sc,
>         /* explicitly set above */
>         WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED=
);
>         sc->status =3D SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
> -       sc->rdma.expected_event =3D RDMA_CM_EVENT_ESTABLISHED;
> -       sc->rdma.cm_id->event_handler =3D smbdirect_accept_rdma_event_han=
dler;
>         ret =3D rdma_accept(sc->rdma.cm_id, &conn_param);
>         if (ret) {
>                 smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
>                         "rdma_accept() failed %1pe\n",
>                         SMBDIRECT_DEBUG_ERR_PTR(ret));
> -               goto rdma_accept_failed;
> +               goto cleanup;
>         }
>
>         /*
> @@ -143,31 +159,25 @@ int smbdirect_accept_connect_request(struct smbdire=
ct_socket *sc,
>
>         return 0;
>
> -rdma_accept_failed:
> +cleanup:
>         /*
> -        * The recv_io posted above is now owned by the QP (recv_io was s=
et to
> -        * NULL after a successful post).  smbdirect_connection_destroy_q=
p()
> -        * calls ib_drain_qp(), whose completion
> -        * (smbdirect_accept_negotiate_recv_done) returns the recv_io to =
the
> -        * free list via smbdirect_connection_put_recv_io().  It therefor=
e MUST
> -        * run BEFORE smbdirect_connection_destroy_mem_pools(): otherwise=
 the
> -        * posted recv_io is still outstanding when kmem_cache_destroy() =
runs
> -        * ("Slab cache still has objects") and is later freed into an
> -        * already-destroyed mempool (mempool_free_bulk NULL-ptr-deref).
> +        * No RDMA state is torn down here, and in particular sc is not
> +        * released: the caller (smbdirect_listen_connect_request()) owns=
 that
> +        * decision and schedules sc's teardown via
> +        * smbdirect_socket_schedule_cleanup() on a non-zero return. All =
of the
> +        * RDMA state - the QP, the memory pools and the cm_id itself - i=
s then
> +        * torn down asynchronously by smbdirect_socket_cleanup_work() ->
> +        * smbdirect_socket_release() -> smbdirect_socket_destroy(), whic=
h
> +        * drains the QP (returning any posted recv_io to the pool) befor=
e
> +        * destroying the memory pools and destroys the cm_id with
> +        * rdma_destroy_id(), all in the correct order.
> +        *
> +        * The only resource not reachable by that teardown is a recv_io =
that
> +        * was taken from the pool but not yet posted to the QP (recv_io =
is set
> +        * to NULL after a successful post), so hand it back here.
>          */
> -       smbdirect_connection_destroy_qp(sc);
> -       smbdirect_connection_destroy_mem_pools(sc);
> -       return ret;
> -post_recv_io_failed:
> -       /* post failed: recv_io was not accepted by the QP, still in hand=
 */
>         if (recv_io)
>                 smbdirect_connection_put_recv_io(recv_io);
> -get_recv_io_failed:
> -       smbdirect_connection_destroy_mem_pools(sc);
> -create_mem_failed:
> -       smbdirect_connection_destroy_qp(sc);
> -create_qp_failed:
> -init_params_failed:
>         return ret;
>  }
>
> @@ -301,6 +311,7 @@ static void smbdirect_accept_negotiate_recv_work(stru=
ct work_struct *work)
>         struct smbdirect_socket *sc =3D
>                 container_of(work, struct smbdirect_socket, connect.work)=
;
>         struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> +       struct smbdirect_socket *lsc;
>         struct smbdirect_recv_io *recv_io;
>         struct smbdirect_negotiate_req *nreq;
>         unsigned long flags;
> @@ -463,29 +474,55 @@ static void smbdirect_accept_negotiate_recv_work(st=
ruct work_struct *work)
>          */
>         sp->max_fragmented_send_size =3D max_fragmented_size;
>
> -       if (sc->accept.listener) {
> -               struct smbdirect_socket *lsc =3D sc->accept.listener;
> -               unsigned long flags;
> +       /*
> +        * Every accepting socket was created by
> +        * smbdirect_listen_connect_request() and has a
> +        * listener. If it's already cleared, the listener
> +        * (or its purge_orphaned_work) is responsible for
> +        * releasing us, so we must not send a negotiate
> +        * response.
> +        *
> +        * The memory of the listener is freed via kfree_rcu(),
> +        * see smbdirect_listen_orphan_socket().
> +        */
> +       rcu_read_lock();
> +       lsc =3D READ_ONCE(sc->accept.listener);
> +       if (!lsc) {
> +               rcu_read_unlock();
> +               return;
> +       }
>
> -               spin_lock_irqsave(&lsc->listen.lock, flags);
> -               list_del(&sc->accept.list);
> -               list_add_tail(&sc->accept.list, &lsc->listen.ready);
> +       spin_lock_irqsave(&lsc->listen.lock, flags);
> +       /*
> +        * The listener (or its purge_orphaned_work)
> +        * may have cleared sc->accept.listener in the
> +        * meantime and is responsible for releasing us.
> +        *
> +        * If we already failed, we're either
> +        * already on the orphaned list or
> +        * smbdirect_socket_cleanup_work() will
> +        * move us there.
> +        *
> +        * In both cases we must not move us
> +        * to the ready list.
> +        */
> +       if (sc->accept.listener =3D=3D lsc && !READ_ONCE(sc->first_error)=
) {
> +               list_move_tail(&sc->accept.list, &lsc->listen.ready);
>                 wake_up(&lsc->listen.wait_queue);
> -               spin_unlock_irqrestore(&lsc->listen.lock, flags);
> -
> -               /*
> -                * smbdirect_socket_accept() will call
> -                * smbdirect_accept_negotiate_finish(nsc, 0);
> -                *
> -                * So that we don't send the negotiation
> -                * response that grants credits to the peer
> -                * before the socket is accepted by the
> -                * application.
> -                */
> -               return;
>         }
> +       spin_unlock_irqrestore(&lsc->listen.lock, flags);
> +       rcu_read_unlock();
>
> -       ntstatus =3D le32_to_cpu(STATUS_SUCCESS);
> +       /*
> +        * smbdirect_socket_accept() will call
> +        * smbdirect_accept_negotiate_finish(nsc, 0);
> +        *
> +        * So that we don't send the negotiation
> +        * response that grants credits to the peer
> +        * before the socket is accepted by the
> +        * application.
> +        */
> +       return;
>
>  not_supported:
>         smbdirect_accept_negotiate_finish(sc, ntstatus);
> @@ -838,7 +875,7 @@ struct smbdirect_socket *smbdirect_socket_accept(stru=
ct smbdirect_socket *lsc,
>                                        struct smbdirect_socket,
>                                        accept.list);
>         if (nsc) {
> -               nsc->accept.listener =3D NULL;
> +               WRITE_ONCE(nsc->accept.listener, NULL);
>                 list_del_init_careful(&nsc->accept.list);
>                 arg->is_empty =3D list_empty_careful(&lsc->listen.ready);
>         }
> diff --git a/fs/smb/smbdirect/internal.h b/fs/smb/smbdirect/internal.h
> index e9959e6dc13ae..69d0c9f899dec 100644
> --- a/fs/smb/smbdirect/internal.h
> +++ b/fs/smb/smbdirect/internal.h
> @@ -74,6 +74,8 @@ void __smbdirect_socket_schedule_cleanup(struct smbdire=
ct_socket *sc,
>
>  void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc);
>
> +void smbdirect_listen_orphan_socket(struct smbdirect_socket *sc);
> +
>  int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
>                                       enum smbdirect_socket_status expect=
ed_status,
>                                       int unexpected_errno,
> diff --git a/fs/smb/smbdirect/listen.c b/fs/smb/smbdirect/listen.c
> index 2f78bcaedbf82..3c91f00d95ce4 100644
> --- a/fs/smb/smbdirect/listen.c
> +++ b/fs/smb/smbdirect/listen.c
> @@ -10,6 +10,78 @@
>  static int smbdirect_listen_rdma_event_handler(struct rdma_cm_id *id,
>                                                struct rdma_cm_event *even=
t);
>
> +/*
> + * This is called by a socket that failed while it
> + * is still on the pending or ready list of its
> + * listener, typically at the end of
> + * smbdirect_socket_cleanup_work(), when the
> + * disconnect was already started.
> + *
> + * It moves itself to the orphaned list and
> + * lets smbdirect_listen_purge_orphaned_work()
> + * release it. Otherwise it would stay on the
> + * pending or ready list until the listener is
> + * destroyed and fill up the backlog, so that
> + * no new connections would be accepted.
> + *
> + * It's fine to call this more than once.
> + */
> +void smbdirect_listen_orphan_socket(struct smbdirect_socket *sc)
> +{
> +       struct smbdirect_socket *lsc;
> +       unsigned long flags;
> +
> +       /*
> +        * The memory of the listener is freed via
> +        * kfree_rcu(), so it's safe to dereference it
> +        * under rcu_read_lock(), even if sc->accept.listener
> +        * is cleared and the listener is released concurrently.
> +        */
> +       rcu_read_lock();
> +       lsc =3D READ_ONCE(sc->accept.listener);
> +       if (!lsc) {
> +               rcu_read_unlock();
> +               return;
> +       }
> +
> +       spin_lock_irqsave(&lsc->listen.lock, flags);
> +       if (sc->accept.listener =3D=3D lsc) {
> +               list_move_tail(&sc->accept.list, &lsc->listen.orphaned);
> +               queue_work(lsc->workqueues.cleanup, &lsc->listen.purge_or=
phaned_work);
> +       }
> +       spin_unlock_irqrestore(&lsc->listen.lock, flags);
> +       rcu_read_unlock();
> +}
> +
> +static void smbdirect_listen_purge_orphaned_work(struct work_struct *wor=
k)
> +{
> +       struct smbdirect_socket *lsc =3D
> +               container_of(work, struct smbdirect_socket, listen.purge_=
orphaned_work);
> +       struct smbdirect_socket *psc, *tsc;
> +       LIST_HEAD(orphaned_list);
> +       unsigned long flags;
> +
> +       /*
> +        * Clearing accept.listener under listen.lock
> +        * makes us responsible for releasing them.
> +        */
> +       spin_lock_irqsave(&lsc->listen.lock, flags);
> +       list_splice_tail_init(&lsc->listen.orphaned, &orphaned_list);
> +       list_for_each_entry(psc, &orphaned_list, accept.list)
> +               WRITE_ONCE(psc->accept.listener, NULL);
> +       spin_unlock_irqrestore(&lsc->listen.lock, flags);
> +
> +       /*
> +        * We don't hold the listener's rdma_lock_handler()
> +        * lock here, see smbdirect_socket_destroy()
> +        * for why that's important.
> +        */
> +       list_for_each_entry_safe(psc, tsc, &orphaned_list, accept.list) {
> +               list_del_init(&psc->accept.list);
> +               smbdirect_socket_release(psc);
> +       }
> +}
> +
>  int smbdirect_socket_listen(struct smbdirect_socket *sc, int backlog)
>  {
>         int ret;
> @@ -47,6 +119,9 @@ int smbdirect_socket_listen(struct smbdirect_socket *s=
c, int backlog)
>         sc->rdma.cm_id->event_handler =3D smbdirect_listen_rdma_event_han=
dler;
>         rdma_unlock_handler(sc->rdma.cm_id);
>
> +       INIT_WORK(&sc->listen.purge_orphaned_work,
> +                 smbdirect_listen_purge_orphaned_work);
> +
>         ret =3D rdma_listen(sc->rdma.cm_id, backlog);
>         if (ret) {
>                 sc->first_error =3D ret;
> @@ -214,6 +289,7 @@ static int smbdirect_listen_connect_request(struct sm=
bdirect_socket *lsc,
>         size_t backlog =3D max_t(size_t, 1, lsc->listen.backlog);
>         size_t psockets;
>         size_t rsockets;
> +       size_t osockets;
>         int ret;
>
>         if (!smbdirect_frwr_is_supported(&new_id->device->attrs)) {
> @@ -254,14 +330,21 @@ static int smbdirect_listen_connect_request(struct =
smbdirect_socket *lsc,
>         spin_lock_irqsave(&lsc->listen.lock, flags);
>         psockets =3D list_count_nodes(&lsc->listen.pending);
>         rsockets =3D list_count_nodes(&lsc->listen.ready);
> +       /*
> +        * Orphaned sockets still count against
> +        * the backlog until they are released by
> +        * smbdirect_listen_purge_orphaned_work().
> +        */
> +       osockets =3D list_count_nodes(&lsc->listen.orphaned);
>         spin_unlock_irqrestore(&lsc->listen.lock, flags);
>
>         if (psockets > backlog ||
>             rsockets > backlog ||
> -           (psockets + rsockets) > backlog) {
> +           osockets > backlog ||
> +           (psockets + rsockets + osockets) > backlog) {
>                 smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
> -                       "Backlog[%d][%zu] full pending[%zu] ready[%zu]\n"=
,
> -                       lsc->listen.backlog, backlog, psockets, rsockets)=
;
> +                       "Backlog[%d][%zu] full pending[%zu] ready[%zu] or=
phaned[%zu]\n",
> +                       lsc->listen.backlog, backlog, psockets, rsockets,=
 osockets);
>                 return -EBUSY;
>         }
>
> @@ -279,22 +362,54 @@ static int smbdirect_listen_connect_request(struct =
smbdirect_socket *lsc,
>         if (ret)
>                 goto set_settings_failed;
>
> +       /*
> +        * Publish nsc on the pending list with accept.listener set befor=
e
> +        * smbdirect_accept_connect_request() calls rdma_accept(). Once t=
he
> +        * connection can establish, smbdirect_accept_negotiate_recv_work=
()
> +        * may run and it must observe accept.listener, otherwise nsc wou=
ld
> +        * be left stranded on the pending list forever.
> +        *
> +        * The listener's handler_mutex is held while we're called, so
> +        * smbdirect_socket_destroy() of the listener can't reach nsc on =
the
> +        * pending list before we're done.
> +        *
> +        * From here nsc is published on the pending list: on failure of
> +        * smbdirect_accept_connect_request() below we schedule nsc's tea=
rdown,
> +        * which orphans nsc off the listener so
> +        * smbdirect_listen_purge_orphaned_work() -> smbdirect_socket_rel=
ease()
> +        * releases it.
> +        */
>         spin_lock_irqsave(&lsc->listen.lock, flags);
>         list_add_tail(&nsc->accept.list, &lsc->listen.pending);
> -       nsc->accept.listener =3D lsc;
> +       WRITE_ONCE(nsc->accept.listener, lsc);
>         spin_unlock_irqrestore(&lsc->listen.lock, flags);
>
>         ret =3D smbdirect_accept_connect_request(nsc, &event->param.conn)=
;
> -       if (ret)
> -               goto accept_connect_failed;
> +       if (ret) {
> +               /*
> +                * The rdma_cm core holds both the listener's and nsc's
> +                * id_priv->handler_mutex across this CONNECT_REQUEST han=
dler,
> +                * so neither can go away under us here and nsc cannot re=
ceive
> +                * any rdma event: it is safe to hand nsc to its teardown=
.
> +                *
> +                * That teardown must be deferred though: nsc->rdma.cm_id
> +                * (=3D new_id) has its handler_mutex held by us, so it c=
annot be
> +                * destroyed synchronously from here.
> +                * smbdirect_socket_schedule_cleanup() only queues work;
> +                * smbdirect_socket_cleanup_work() then orphans nsc off t=
he
> +                * listener and smbdirect_listen_purge_orphaned_work() re=
leases
> +                * it, destroying nsc's cm_id with rdma_destroy_id().
> +                */
> +               smbdirect_socket_schedule_cleanup(nsc, ret);
> +       }
>
> +       /*
> +        * Always return 0 so the rdma_cm core keeps new_id: nsc owns it =
now.
> +        * On success it stays connected; on failure its deferred teardow=
n
> +        * above destroys it.
> +        */
>         return 0;
>
> -accept_connect_failed:
> -       spin_lock_irqsave(&lsc->listen.lock, flags);
> -       list_del_init(&nsc->accept.list);
> -       nsc->accept.listener =3D NULL;
> -       spin_unlock_irqrestore(&lsc->listen.lock, flags);
>  set_settings_failed:
>  set_params_failed:
>         /*
> diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
> index c36cb7cc0088b..e270e36b3145e 100644
> --- a/fs/smb/smbdirect/socket.c
> +++ b/fs/smb/smbdirect/socket.c
> @@ -319,6 +319,15 @@ void __smbdirect_socket_schedule_cleanup(struct smbd=
irect_socket *sc,
>          * (smbdirect_socket_destroy) to reap.
>          */
>         if (sc->listen.backlog !=3D -1) { /* was a listener */
> +               /*
> +                * We don't move them to the orphaned list here,
> +                * each child does that itself at the end of its
> +                * smbdirect_socket_cleanup_work(), see
> +                * smbdirect_listen_orphan_socket(). Only that checks
> +                * accept.listener, which is still NULL for a child
> +                * that smbdirect_listen_connect_request() is still
> +                * setting up and will release itself on failure.
> +                */
>                 spin_lock_irqsave(&sc->listen.lock, flags);
>                 list_splice_init(&sc->listen.ready, &sc->listen.pending);
>                 list_for_each_entry_safe(psc, tsc, &sc->listen.pending, a=
ccept.list)
> @@ -427,6 +436,15 @@ static void smbdirect_socket_cleanup_work(struct wor=
k_struct *work)
>          * instances of one class -- harmless, but lockdep cannot tell).
>          */
>         if (sc->listen.backlog !=3D -1) { /* was a listener */
> +               /*
> +                * We don't move them to the orphaned list here,
> +                * each child does that itself at the end of its
> +                * smbdirect_socket_cleanup_work(), see
> +                * smbdirect_listen_orphan_socket(). Only that checks
> +                * accept.listener, which is still NULL for a child
> +                * that smbdirect_listen_connect_request() is still
> +                * setting up and will release itself on failure.
> +                */
>                 spin_lock_irqsave(&sc->listen.lock, flags);
>                 list_splice_init(&sc->listen.ready, &sc->listen.pending);
>                 list_for_each_entry_safe(psc, tsc, &sc->listen.pending, a=
ccept.list)
> @@ -486,6 +504,18 @@ static void smbdirect_socket_cleanup_work(struct wor=
k_struct *work)
>          * in order to notice the broken connection.
>          */
>         smbdirect_socket_wake_up_all(sc);
> +
> +       /*
> +        * If we're still on the pending or ready list
> +        * of a listener, we started the disconnect
> +        * as far as possible above, so we move ourself
> +        * to the orphaned list of the listener,
> +        * which will release us.
> +        *
> +        * This is a no-op internally if
> +        * sc->accept.listener is NULL.
> +        */
> +       smbdirect_listen_orphan_socket(sc);
>  }
>
>  static void smbdirect_socket_destroy(struct smbdirect_socket *sc)
> @@ -544,6 +574,7 @@ static void smbdirect_socket_destroy(struct smbdirect=
_socket *sc)
>         disable_work_sync(&sc->recv_io.posted.refill_work);
>         disable_work_sync(&sc->idle.immediate_work);
>         disable_delayed_work_sync(&sc->idle.timer_work);
> +       disable_work_sync(&sc->listen.purge_orphaned_work);
>
>         if (sc->rdma.cm_id)
>                 rdma_lock_handler(sc->rdma.cm_id);
> @@ -607,6 +638,19 @@ static void smbdirect_socket_destroy(struct smbdirec=
t_socket *sc)
>         spin_lock_irqsave(&sc->listen.lock, flags);
>         list_splice_tail_init(&sc->listen.ready, &pending_list);
>         list_splice_tail_init(&sc->listen.pending, &pending_list);
> +       /*
> +        * purge_orphaned_work is already disabled above,
> +        * so we also need to release the orphaned sockets.
> +        *
> +        * Clearing accept.listener under listen.lock
> +        * makes us responsible for releasing them and
> +        * prevents them from moving themselves to
> +        * the orphaned list via
> +        * smbdirect_listen_orphan_socket().
> +        */
> +       list_splice_tail_init(&sc->listen.orphaned, &pending_list);
> +       list_for_each_entry(psc, &pending_list, accept.list)
> +               WRITE_ONCE(psc->accept.listener, NULL);
>         spin_unlock_irqrestore(&sc->listen.lock, flags);
>
>         /* It's not possible for upper layer to get to reassembly */
> @@ -650,7 +694,6 @@ static void smbdirect_socket_destroy(struct smbdirect=
_socket *sc)
>                         "release %zu pending sockets\n", psockets);
>         list_for_each_entry_safe(psc, tsc, &pending_list, accept.list) {
>                 list_del_init(&psc->accept.list);
> -               psc->accept.listener =3D NULL;
>                 smbdirect_socket_release(psc);
>         }
>         if (sc->listen.backlog !=3D -1) /* was a listener */
> @@ -777,7 +820,17 @@ static void smbdirect_socket_release_destroy(struct =
kref *kref)
>          * in DESTROYED state, before we free the memory.
>          */
>         smbdirect_socket_destroy_sync(sc);
> -       kfree(sc);
> +
> +       /*
> +        * Only a listener (backlog !=3D -1) is ever dereferenced
> +        * via sc->accept.listener under rcu_read_lock(), see
> +        * smbdirect_listen_orphan_socket(). Other sockets can be
> +        * freed immediately.
> +        */
> +       if (sc->listen.backlog !=3D -1) /* was a listener */
> +               kfree_rcu(sc, refs.rcu);
> +       else
> +               kfree(sc);
>  }
>
>  void smbdirect_socket_release(struct smbdirect_socket *sc)
> diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
> index c09eddd8ad16d..14114a2567a2e 100644
> --- a/fs/smb/smbdirect/socket.h
> +++ b/fs/smb/smbdirect/socket.h
> @@ -151,6 +151,12 @@ struct smbdirect_socket {
>                  * the disconnect refcount.
>                  */
>                 struct kref destroy;
> +
> +               /*
> +                * smbdirect_socket_release_destroy() uses
> +                * kfree_rcu(), see accept.listener.
> +                */
> +               struct rcu_head rcu;
>         } refs;
>
>         /* RDMA related */
> @@ -216,6 +222,16 @@ struct smbdirect_socket {
>                  * only be > 0.
>                  */
>                 int backlog;
> +               /*
> +                * Sockets on pending or ready that failed
> +                * move themselves to orphaned and queue
> +                * purge_orphaned_work, which releases them.
> +                * So that they are freed while the listener
> +                * is still alive. They still count against
> +                * the backlog until they are released.
> +                */
> +               struct list_head orphaned;
> +               struct work_struct purge_orphaned_work;
>         } listen;
>
>         /*
> @@ -226,7 +242,30 @@ struct smbdirect_socket {
>          * connection.
>          */
>         struct {
> +               /*
> +                * This is only set, protected by
> +                * listener->listen.lock, while the socket
> +                * is owned by the listener (on its pending,
> +                * ready or orphaned list). The one who clears
> +                * it is responsible for releasing the socket.
> +                *
> +                * The memory of a struct smbdirect_socket is
> +                * freed via kfree_rcu(), so the listener
> +                * can be dereferenced under rcu_read_lock(),
> +                * even if accept.listener is cleared and
> +                * the listener is released concurrently.
> +                */
>                 struct smbdirect_socket *listener;
> +               /*
> +                * Linkage on one of the listener's
> +                * listen.{pending,ready,orphaned} lists.
> +                *
> +                * accept.list and accept.listener are set
> +                * together under listener->listen.lock before
> +                * smbdirect_accept_connect_request() is called,
> +                * so whenever the socket is on one of those lists
> +                * accept.listener is that listener (never NULL).
> +                */
>                 struct list_head list;
>         } accept;
>
> @@ -588,6 +627,9 @@ static __always_inline void smbdirect_socket_init(str=
uct smbdirect_socket *sc)
>         spin_lock_init(&sc->listen.lock);
>         INIT_LIST_HEAD(&sc->listen.pending);
>         INIT_LIST_HEAD(&sc->listen.ready);
> +       INIT_LIST_HEAD(&sc->listen.orphaned);
> +       INIT_WORK(&sc->listen.purge_orphaned_work, __smbdirect_socket_dis=
abled_work);
> +       disable_work_sync(&sc->listen.purge_orphaned_work);
>         sc->listen.backlog =3D -1; /* not a listener */
>         init_waitqueue_head(&sc->listen.wait_queue);
>
> --
> 2.53.0
>
>
>
