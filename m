Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF50185E7F
	for <linux-cifs@vger.kernel.org>; Sat,  9 Aug 2025 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754755161; cv=none; b=GpGaJpfwwZmaOTvv59O4Fu8vrWaqmY5NIo0HwWGcaGJPmtDePziVap0SaT4RmxSl3Z+5Llqdj1KC7lXr5jGYRkL894qm4c/ScgXlE29bOLfzZX8mod07tsOm4hjP4RX6BIg222JA3+jbdPP+Ngm7xCztmLX+ddWpReClSy8rcjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754755161; c=relaxed/simple;
	bh=QzTsDy0CQvUL5Een31ZoCykFqunbpxRp3mWxHHLlH4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B/+es83MJRgyWnR02WwPMKe8gbw/JUNlHfYsF1BsVYlhFbxrOpP53/YGQxRMdSNrvDuPPBZFPIhRbGvg7aBMsxRzGHCX2MPUflQo6wUlbSaCig7jb4DTNdc/UX5ThczKC9rOndPaQou8m8KbayHVFOptNRWJCIohbovakje2YdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmxWCyU0; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmxWCyU0"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-70749d4c598so25806046d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 09 Aug 2025 08:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754755158; x=1755359958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toQHbXCNTiEZWoOE8dg9aMLFQgLW0LEQwkuXfilt0uo=;
        b=jmxWCyU00/7q6vwL3LiD/sgMrlOFS0vWGjSHWTxEvm0vGD5k8qVIAvl2V0GSvPRXgR
         A3fUhuWDTrwmPrYVvV85muW34JAwdhIKGVainLVRQWj3uQyrD2kwKV6DfmZMm6htRUvr
         s9NFDD3M5bJLYTUIP8WyPwHEYdsb9AdJ/1iAtXvbEBvcRf13H61Jftqir3eTReOab+lA
         Lz2v83VNFZ89EiEYQMHrbD/VguR0NUNE4tRDvxEmiwsa7PVh7ydeJfV0g/LENapFR9df
         DE9oZO4zHoHZ7UCu1wDN5iFIqtNM09nPs0rZT0T/AOjynqOuHM+6hHjGt14D6IObxO+l
         JT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754755158; x=1755359958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=toQHbXCNTiEZWoOE8dg9aMLFQgLW0LEQwkuXfilt0uo=;
        b=OAZV4YEB+rwqtVZZ6oKfxDyQ9aL9VEJnthlFy0mPhSWnyS/+1klGFxzYPmSNSvH0NN
         bLfxrqX0pRKN1Mrm6ydDBepQbMeAzheyBYHugV6z/q/FLlQIEZDXtesIackAHM+EZKN+
         aUp+d2pLvlVVRt/616TuEWXzlCs+QkKDsWq44pCYtFK7aI7G8/CLoglajeShX4E+QJ7F
         QZ47nTtvuzd7UzXVPl3G1/xWyeivNx7F7pEhM4W7tmgHVBvWSFmLgAurjfS9pZ1mk9Px
         YEwYwPmGbbM5xJYc1fVJKQnh/3dlQ84sqHFjyweuBchK+u4tgYLzfjhXtJZQPLNqkhKs
         MzNQ==
X-Gm-Message-State: AOJu0YzzwGOF1QfbsvBWTRqHc9zYfcG/tiSIFWSA27RSUyhVGSRKS0fZ
	Kp2CGX++rLNDSBgJipEdOFJM0qMrxg4B+0yrkU5yRf2R2FJYKyEgdlkgutAWiz3ngQBLi5aiQ6s
	QMlEBmmYYjUIo/FZUVJzZal08EVtSMB8=
X-Gm-Gg: ASbGnctwlZcJwL/Ld+GMGMihX7k93VEbfKmZr6v2bQ6/G0Dcj0MoNTd/Sjf4EzzHC5D
	uMgz9Z0M4110Hq7WWG/vIvYFkmhlcoGeD6fDjYkRzw42fbrWkw0gV+nkKB5apwHiemYq+n8B4du
	ElfxUvExdISqLa5iR0bfCmEQXXWGCJxxLgwmKKs5lX4B3i5WyLn/b6Px7HAhGDHKI+KHavxpWyK
	aLpd+0WuX//J2SJA08j1JBxAgAAaUg4mkHlTgcrKw==
X-Google-Smtp-Source: AGHT+IFyws0o2qLIQEDmrJkHJX34Op7e1GirxxwBJaULalYsiQkHt58eX0VDrlS2TSwgUYK1jCw9dlANfrJ6puhKfFM=
X-Received: by 2002:a05:6214:2422:b0:707:5bc5:861a with SMTP id
 6a1803df08f44-7099a1feb5emr90556276d6.17.1754755158437; Sat, 09 Aug 2025
 08:59:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754671444.git.metze@samba.org> <499154755d3d2d29d7092daffd16b01bc657974c.1754671444.git.metze@samba.org>
In-Reply-To: <499154755d3d2d29d7092daffd16b01bc657974c.1754671444.git.metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 9 Aug 2025 10:59:07 -0500
X-Gm-Features: Ac12FXztLCR12Ctp1I6OFS3pgsOP9hxBcdxKVOVApE8ZXoxBhqsCzy4x-LH8swk
Message-ID: <CAH2r5msY2bkoCyR4RK=NVzSp=gVhU9ujvDV-fR2-zkkSTnBBUQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING
 with more detailed states
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged patches 5 to 9 into cifs-2.6.git for-next (the others are
already upstream) pending more review and testing.

Let me know if updated versions of those 5 patches, or other
RDMA/smbdirect ones that belong in for-next

On Fri, Aug 8, 2025 at 11:49=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> The process of reaching a functional connection regresented by
> SMBDIRECT_SOCKET_CONNECTED, is more complex than using a single
> SMBDIRECT_SOCKET_CONNECTING state.
>
> This will allow us to remove a lot of special variables and
> completions in the following commits.
>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/client/smbdirect.c                  | 73 ++++++++++++++++++++--
>  fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++-
>  2 files changed, 79 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index c628e91c328b..1337d35a22f9 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -161,9 +161,36 @@ static void smbd_disconnect_rdma_work(struct work_st=
ruct *work)
>                 container_of(work, struct smbd_connection, disconnect_wor=
k);
>         struct smbdirect_socket *sc =3D &info->socket;
>
> -       if (sc->status =3D=3D SMBDIRECT_SOCKET_CONNECTED) {
> +       switch (sc->status) {
> +       case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
> +       case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
> +       case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
> +       case SMBDIRECT_SOCKET_CONNECTED:
>                 sc->status =3D SMBDIRECT_SOCKET_DISCONNECTING;
>                 rdma_disconnect(sc->rdma.cm_id);
> +               break;
> +
> +       case SMBDIRECT_SOCKET_CREATED:
> +       case SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED:
> +       case SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING:
> +       case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
> +       case SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED:
> +       case SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING:
> +       case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
> +       case SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED:
> +       case SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING:
> +       case SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED:
> +               /*
> +                * rdma_connect() never reached
> +                * RDMA_CM_EVENT_ESTABLISHED
> +                */
> +               sc->status =3D SMBDIRECT_SOCKET_DISCONNECTED;
> +               break;
> +
> +       case SMBDIRECT_SOCKET_DISCONNECTING:
> +       case SMBDIRECT_SOCKET_DISCONNECTED:
> +       case SMBDIRECT_SOCKET_DESTROYED:
> +               break;
>         }
>  }
>
> @@ -185,26 +212,39 @@ static int smbd_conn_upcall(
>
>         switch (event->event) {
>         case RDMA_CM_EVENT_ADDR_RESOLVED:
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ADD=
R_RUNNING);
> +               sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
> +               info->ri_rc =3D 0;
> +               complete(&info->ri_done);
> +               break;
> +
>         case RDMA_CM_EVENT_ROUTE_RESOLVED:
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ROU=
TE_RUNNING);
> +               sc->status =3D SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
>                 info->ri_rc =3D 0;
>                 complete(&info->ri_done);
>                 break;
>
>         case RDMA_CM_EVENT_ADDR_ERROR:
>                 log_rdma_event(ERR, "connecting failed event=3D%s\n", eve=
nt_name);
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ADD=
R_RUNNING);
> +               sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
>                 info->ri_rc =3D -EHOSTUNREACH;
>                 complete(&info->ri_done);
>                 break;
>
>         case RDMA_CM_EVENT_ROUTE_ERROR:
>                 log_rdma_event(ERR, "connecting failed event=3D%s\n", eve=
nt_name);
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ROU=
TE_RUNNING);
> +               sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
>                 info->ri_rc =3D -ENETUNREACH;
>                 complete(&info->ri_done);
>                 break;
>
>         case RDMA_CM_EVENT_ESTABLISHED:
>                 log_rdma_event(INFO, "connected event=3D%s\n", event_name=
);
> -               sc->status =3D SMBDIRECT_SOCKET_CONNECTED;
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNEC=
T_RUNNING);
> +               sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
>                 wake_up_interruptible(&info->status_wait);
>                 break;
>
> @@ -212,7 +252,8 @@ static int smbd_conn_upcall(
>         case RDMA_CM_EVENT_UNREACHABLE:
>         case RDMA_CM_EVENT_REJECTED:
>                 log_rdma_event(ERR, "connecting failed event=3D%s\n", eve=
nt_name);
> -               sc->status =3D SMBDIRECT_SOCKET_DISCONNECTED;
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNEC=
T_RUNNING);
> +               sc->status =3D SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
>                 wake_up_interruptible(&info->status_wait);
>                 break;
>
> @@ -481,6 +522,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc=
 *wc)
>                 info->negotiate_done =3D
>                         process_negotiation_response(response, wc->byte_l=
en);
>                 put_receive_buffer(info, response);
> +               WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_R=
UNNING);
> +               if (!info->negotiate_done)
> +                       sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
> +               else
> +                       sc->status =3D SMBDIRECT_SOCKET_CONNECTED;
> +
>                 complete(&info->negotiate_completion);
>                 return;
>
> @@ -556,6 +603,7 @@ static struct rdma_cm_id *smbd_create_id(
>                 struct smbd_connection *info,
>                 struct sockaddr *dstaddr, int port)
>  {
> +       struct smbdirect_socket *sc =3D &info->socket;
>         struct rdma_cm_id *id;
>         int rc;
>         __be16 *sport;
> @@ -578,6 +626,8 @@ static struct rdma_cm_id *smbd_create_id(
>         init_completion(&info->ri_done);
>         info->ri_rc =3D -ETIMEDOUT;
>
> +       WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED=
);
> +       sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING;
>         rc =3D rdma_resolve_addr(id, NULL, (struct sockaddr *)dstaddr,
>                 RDMA_RESOLVE_TIMEOUT);
>         if (rc) {
> @@ -598,6 +648,8 @@ static struct rdma_cm_id *smbd_create_id(
>         }
>
>         info->ri_rc =3D -ETIMEDOUT;
> +       WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDE=
D);
> +       sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING;
>         rc =3D rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
>         if (rc) {
>                 log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", r=
c);
> @@ -644,6 +696,9 @@ static int smbd_ia_open(
>         struct smbdirect_socket *sc =3D &info->socket;
>         int rc;
>
> +       WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_CREATED);
> +       sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED;
> +
>         sc->rdma.cm_id =3D smbd_create_id(info, dstaddr, port);
>         if (IS_ERR(sc->rdma.cm_id)) {
>                 rc =3D PTR_ERR(sc->rdma.cm_id);
> @@ -1085,6 +1140,9 @@ static int smbd_negotiate(struct smbd_connection *i=
nfo)
>         int rc;
>         struct smbdirect_recv_io *response =3D get_receive_buffer(info);
>
> +       WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_NEEDED);
> +       sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
> +
>         sc->recv_io.expected =3D SMBDIRECT_EXPECT_NEGOTIATE_REP;
>         rc =3D smbd_post_recv(info, response);
>         log_rdma_event(INFO, "smbd_post_recv rc=3D%d iov.addr=3D0x%llx io=
v.length=3D%u iov.lkey=3D0x%x\n",
> @@ -1540,7 +1598,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>         sc =3D &info->socket;
>         sp =3D &sc->parameters;
>
> -       sc->status =3D SMBDIRECT_SOCKET_CONNECTING;
> +       sc->status =3D SMBDIRECT_SOCKET_CREATED;
>         rc =3D smbd_ia_open(info, dstaddr, port);
>         if (rc) {
>                 log_rdma_event(INFO, "smbd_ia_open rc=3D%d\n", rc);
> @@ -1652,6 +1710,9 @@ static struct smbd_connection *_smbd_get_connection=
(
>
>         init_waitqueue_head(&info->status_wait);
>         init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
> +
> +       WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED=
);
> +       sc->status =3D SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
>         rc =3D rdma_connect(sc->rdma.cm_id, &conn_param);
>         if (rc) {
>                 log_rdma_event(ERR, "rdma_connect() failed with %i\n", rc=
);
> @@ -1660,10 +1721,10 @@ static struct smbd_connection *_smbd_get_connecti=
on(
>
>         wait_event_interruptible_timeout(
>                 info->status_wait,
> -               sc->status !=3D SMBDIRECT_SOCKET_CONNECTING,
> +               sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
>                 msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
>
> -       if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> +       if (sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_NEEDED) {
>                 log_rdma_event(ERR, "rdma_connect failed port=3D%d\n", po=
rt);
>                 goto rdma_connect_failed;
>         }
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/s=
mbdirect/smbdirect_socket.h
> index 3c4a8d627aa3..f43eabdd413d 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.h
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.h
> @@ -8,9 +8,19 @@
>
>  enum smbdirect_socket_status {
>         SMBDIRECT_SOCKET_CREATED,
> -       SMBDIRECT_SOCKET_CONNECTING,
> -       SMBDIRECT_SOCKET_CONNECTED,
> +       SMBDIRECT_SOCKET_RESOLVE_ADDR_NEEDED,
> +       SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
> +       SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED,
> +       SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED,
> +       SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
> +       SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED,
> +       SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED,
> +       SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
> +       SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED,
> +       SMBDIRECT_SOCKET_NEGOTIATE_NEEDED,
> +       SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
>         SMBDIRECT_SOCKET_NEGOTIATE_FAILED,
> +       SMBDIRECT_SOCKET_CONNECTED,
>         SMBDIRECT_SOCKET_DISCONNECTING,
>         SMBDIRECT_SOCKET_DISCONNECTED,
>         SMBDIRECT_SOCKET_DESTROYED
> --
> 2.43.0
>


--=20
Thanks,

Steve
