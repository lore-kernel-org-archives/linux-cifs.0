Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72027586E
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 11:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754654102; cv=none; b=lasWIu/P2JGgVMejA0TywGcvXoGaDtuMvgs87CRxLad+TMec9dGgMrzUbhHLhY7/dvf41nT/XO7S1sDenUgPbAqtSAoZNdVeQGKKIppEJNI2UwihqB1mTzpT1pqLOI35jDOWN/Pbg9cR9gKLIUb6lCecVGEIG2ODMIh1YkPCkFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754654102; c=relaxed/simple;
	bh=sj5p3Y5Ns9VwOsqCnY7ZMwZFQNS+BKhUk0K6mXkEH+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BVUbfu7lwi6nlXF1bKfhiiC52Xjq4AF2xQdxw9iJCYujFhyJ/TiFyAqpB4MhfJ9x8Pvxxr15b77RPeHjbaN/7H28g7WLp/aRFW8JFryZja/ObNReK6pvEKdKva0op2kueNsrXsaFx3QI3sTT41QKBSarZOcf+oUzWT2WHB2taIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nN4YkROI; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nN4YkROI"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-af95525bac4so392288266b.0
        for <linux-cifs@vger.kernel.org>; Fri, 08 Aug 2025 04:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754654099; x=1755258899; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LSZFnRwInfSCSBSnMCkxYYr/JTYJDD5k1HBNvUhwgEg=;
        b=nN4YkROI5TCFmgfKKphiMaagJwSDcYwSqcoW+GUhBUxmvvWSukabkR2HSkLLLKUwrd
         uoDIJ6p9ZNz00h95/xld8XIEea0UWpyUDAxp9INL7kHeqU61/4Ii7uOZgCIGLnO1TDy1
         1wqqOFKFZ/hrUEGIHzCgbvhxJHuk7/388qjiY6HOcnqzebCJGbM4DpsHedD2Q1Z0yoBg
         GgZ7CWbB1nrrnwgokA0DF9O1sLNtmozAR54B14dFXLJhN6lWxBLa7utlfsz/f5r0I8Gs
         3eQw2MwtmHORQMUBztF+WssqT0nsYQ3FlTAbDR9kBC6Akfh1ts4aIgOQy0/iDPGiQcXC
         L3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754654099; x=1755258899;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSZFnRwInfSCSBSnMCkxYYr/JTYJDD5k1HBNvUhwgEg=;
        b=FQgzWJkGDfLdC96lJbnc3TZ9yNkPzlAPLaZWb76p77viQhXrWCePs2cBw4E7fc93sV
         oKVw0gfZaHIDhrvJTPc5xKpfK17aaG5jENMjeI+nFW/NSOUIuSUlRqMCWUV1q5Grik2v
         P2TXzhb9f44g4so8SPypOMEaEEUAqOHR6gs9MjGrBuoFoTYgzy0OFG9tQYPWN+5XSEU3
         Ow6xgjEfTZtw4HxP7hJHqpZ/k1zWnJGeBM3eoIOj5yQk+NkcQCzjNwf5fsrz6AnxZ73C
         Jv+oG1fovAQVRg5IZgW05ltX5O6wh3/V393ul5hYVHUUdHzlTjlAQRT2Y5vZo5YCgcIr
         pAJg==
X-Gm-Message-State: AOJu0YzvgcTWUyAdd5zy+yQ/18+YUVdfHdw464E7pUnnfl5u1LoVgo3s
	+ZDu26zJ+0Ui2pXJg6LSFZsoeWwZHTD5kxRtxElAsO6XQsWlTxL8IA2AQL1QENli6H/KjAxmNxi
	n3P3PianBLorOYgw9T7vChKNZI4cGQeQ=
X-Gm-Gg: ASbGncsawN0g0H27rmz99xnx8NDKwcwIV7RuBHY4MUe7wrC2wSutiZ4g18ZFJNUTauv
	M5r0vT+zRHQJTuRM2OeMhrGYdF0HqvAi9B/ldWM9wZArBYDVMFwtMfl75FZHzIb/4RZx+z0zQKN
	zfEm2VWPLynoZsKbIWY2aL86DKCYqZWxBrUN9WwZ3d5vY7i3ntAUCkzxSLmjHr8XSR6kiDC+ugX
	qeio85BMmuO6X+tjIU=
X-Google-Smtp-Source: AGHT+IEgoloMxDvdyDEpQhUd9vXeT/hZXsc/8i9W3RXv3F/venRU4gM3e0RQFETccAFxgOBTXt9hYaz/8hdPlUB8WPg=
X-Received: by 2002:a17:907:8693:b0:af9:3c05:b73f with SMTP id
 a640c23a62f3a-af9c6540ecbmr255236366b.41.1754654098615; Fri, 08 Aug 2025
 04:54:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754582143.git.metze@samba.org> <c1dd7da5ea65b9867693eb9ecfedf9f35f71b5d3.1754582143.git.metze@samba.org>
In-Reply-To: <c1dd7da5ea65b9867693eb9ecfedf9f35f71b5d3.1754582143.git.metze@samba.org>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 8 Aug 2025 17:24:45 +0530
X-Gm-Features: Ac12FXxzZOwWGjdElySdr0-ERTar42tj1JIgd-VTvFbHMqZeNJ_22oOLEsYNSS4
Message-ID: <CAFTVevXk40jHJqdHyt1gfKHC6wuGMTR49mZMjZ1W-e+t_+eNsw@mail.gmail.com>
Subject: Re: [PATCH 9/9] smb: client: make use of smbdirect_socket.status_wait
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000040acda063bd93edb"

--00000000000040acda063bd93edb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Metze,

&sc -> status_wait is initialized in _smbd_get_connection() in line
1691 but it is being used by smbd_ia_open() -> smbd_create_id() before
that. This is giving an OOPS on RDMA mount (attached).
Could you please check?

Thanks
Meetakshi

On Thu, Aug 7, 2025 at 9:46=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> This will allow us to have common helper functions soon.
>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/client/smbdirect.c | 32 ++++++++++++++++----------------
>  fs/smb/client/smbdirect.h |  2 --
>  2 files changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index ab5b7ae04032..f36226e0331b 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -187,34 +187,34 @@ static int smbd_conn_upcall(
>         case RDMA_CM_EVENT_ADDR_RESOLVED:
>                 WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ADD=
R_RUNNING);
>                 sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_NEEDED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 break;
>
>         case RDMA_CM_EVENT_ROUTE_RESOLVED:
>                 WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ROU=
TE_RUNNING);
>                 sc->status =3D SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 break;
>
>         case RDMA_CM_EVENT_ADDR_ERROR:
>                 log_rdma_event(ERR, "connecting failed event=3D%s\n", eve=
nt_name);
>                 WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ADD=
R_RUNNING);
>                 sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 break;
>
>         case RDMA_CM_EVENT_ROUTE_ERROR:
>                 log_rdma_event(ERR, "connecting failed event=3D%s\n", eve=
nt_name);
>                 WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ROU=
TE_RUNNING);
>                 sc->status =3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 break;
>
>         case RDMA_CM_EVENT_ESTABLISHED:
>                 log_rdma_event(INFO, "connected event=3D%s\n", event_name=
);
>                 WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNEC=
T_RUNNING);
>                 sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_NEEDED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 break;
>
>         case RDMA_CM_EVENT_CONNECT_ERROR:
> @@ -223,7 +223,7 @@ static int smbd_conn_upcall(
>                 log_rdma_event(ERR, "connecting failed event=3D%s\n", eve=
nt_name);
>                 WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNEC=
T_RUNNING);
>                 sc->status =3D SMBDIRECT_SOCKET_RDMA_CONNECT_FAILED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 break;
>
>         case RDMA_CM_EVENT_DEVICE_REMOVAL:
> @@ -232,12 +232,12 @@ static int smbd_conn_upcall(
>                 if (sc->status =3D=3D SMBDIRECT_SOCKET_NEGOTIATE_FAILED) =
{
>                         log_rdma_event(ERR, "event=3D%s during negotiatio=
n\n", event_name);
>                         sc->status =3D SMBDIRECT_SOCKET_DISCONNECTED;
> -                       wake_up(&info->status_wait);
> +                       wake_up(&sc->status_wait);
>                         break;
>                 }
>
>                 sc->status =3D SMBDIRECT_SOCKET_DISCONNECTED;
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 wake_up_interruptible(&sc->recv_io.reassembly.wait_queue)=
;
>                 wake_up_interruptible_all(&info->wait_send_queue);
>                 break;
> @@ -498,7 +498,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc =
*wc)
>                 } else {
>                         sc->status =3D SMBDIRECT_SOCKET_CONNECTED;
>                 }
> -               wake_up_interruptible(&info->status_wait);
> +               wake_up_interruptible(&sc->status_wait);
>                 return;
>
>         /* SMBD data transfer packet */
> @@ -602,7 +602,7 @@ static struct rdma_cm_id *smbd_create_id(
>                 goto out;
>         }
>         rc =3D wait_event_interruptible_timeout(
> -               info->status_wait,
> +               sc->status_wait,
>                 sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ADDR_RUNNING,
>                 msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
>         /* e.g. if interrupted returns -ERESTARTSYS */
> @@ -629,7 +629,7 @@ static struct rdma_cm_id *smbd_create_id(
>                 goto out;
>         }
>         rc =3D wait_event_interruptible_timeout(
> -               info->status_wait,
> +               sc->status_wait,
>                 sc->status !=3D SMBDIRECT_SOCKET_RESOLVE_ROUTE_RUNNING,
>                 msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
>         /* e.g. if interrupted returns -ERESTARTSYS */
> @@ -1136,7 +1136,7 @@ static int smbd_negotiate(struct smbd_connection *i=
nfo)
>                 return rc;
>
>         rc =3D wait_event_interruptible_timeout(
> -               info->status_wait,
> +               sc->status_wait,
>                 sc->status !=3D SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
>                 secs_to_jiffies(SMBD_NEGOTIATE_TIMEOUT));
>         log_rdma_event(INFO, "wait_event_interruptible_timeout rc=3D%d\n"=
, rc);
> @@ -1363,7 +1363,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
>                 rdma_disconnect(sc->rdma.cm_id);
>                 log_rdma_event(INFO, "wait for transport being disconnect=
ed\n");
>                 wait_event_interruptible(
> -                       info->status_wait,
> +                       sc->status_wait,
>                         sc->status =3D=3D SMBDIRECT_SOCKET_DISCONNECTED);
>         }
>
> @@ -1688,7 +1688,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>         log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
>                 &addr_in->sin_addr, port);
>
> -       init_waitqueue_head(&info->status_wait);
> +       init_waitqueue_head(&sc->status_wait);
>         init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
>
>         WARN_ON_ONCE(sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED=
);
> @@ -1700,7 +1700,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>         }
>
>         wait_event_interruptible_timeout(
> -               info->status_wait,
> +               sc->status_wait,
>                 sc->status !=3D SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING,
>                 msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
>
> @@ -1757,7 +1757,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>         destroy_caches_and_workqueue(info);
>         sc->status =3D SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
>         rdma_disconnect(sc->rdma.cm_id);
> -       wait_event(info->status_wait,
> +       wait_event(sc->status_wait,
>                 sc->status =3D=3D SMBDIRECT_SOCKET_DISCONNECTED);
>
>  allocate_cache_failed:
> diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
> index 62458a8fd109..79ab43b7ac19 100644
> --- a/fs/smb/client/smbdirect.h
> +++ b/fs/smb/client/smbdirect.h
> @@ -45,8 +45,6 @@ enum keep_alive_status {
>  struct smbd_connection {
>         struct smbdirect_socket socket;
>
> -       wait_queue_head_t status_wait;
> -
>         struct work_struct disconnect_work;
>         struct work_struct post_send_credits_work;
>
> --
> 2.43.0
>
>

--00000000000040acda063bd93edb
Content-Type: text/plain; charset="US-ASCII"; name="rdma_oops.txt"
Content-Disposition: attachment; filename="rdma_oops.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_me2roqiv0>
X-Attachment-Id: f_me2roqiv0

WyAyOTcyLjA1MDY2MV0gQ0lGUzogQXR0ZW1wdGluZyB0byBtb3VudCAvLzEwLjUuMC4xMy9NeVNo
YXJlDQpbIDI5NzIuMDUwNzA0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUgcGFnZSBmYXVsdCBmb3Ig
YWRkcmVzczogZmZmZmZmZmZmZmZmZmZlOA0KWyAyOTcyLjA1NDIyOV0gI1BGOiBzdXBlcnZpc29y
IHJlYWQgYWNjZXNzIGluIGtlcm5lbCBtb2RlDQpbIDI5NzIuMDU2MjQyXSAjUEY6IGVycm9yX2Nv
ZGUoMHgwMDAwKSAtIG5vdC1wcmVzZW50IHBhZ2UNClsgMjk3Mi4wNTgzNTddIFBHRCBhMzE2M2Yw
NjcgUDREIGEzMTYzZjA2NyBQVUQgYTMxNjQxMDY3IFBNRCAwDQpbIDI5NzIuMDYwNTk3XSBPb3Bz
OiBPb3BzOiAwMDAwIFsjMV0gU01QIE5PUFRJDQpbIDI5NzIuMDYyMjU2XSBDUFU6IDEyIFVJRDog
MCBQSUQ6IDIwODA0MCBDb21tOiBtb3VudC5jaWZzIFRhaW50ZWQ6IEcgVyBPRSA2LjE2LjA2LjE3
KyAjMSBWT0xVTlRBUlkNClsgMjk3Mi4wNjYxNzddIFRhaW50ZWQ6IFtXXT1XQVJOLCBbT109T09U
X01PRFVMRSwgW0VdPVVOU0lHTkVEX01PRFVMRQ0KWyAyOTcyLjA2ODcyOV0gSGFyZHdhcmUgbmFt
ZTogTWljcm9zb2Z0IENvcnBvcmF0aW9uIFZpcnR1YWwgTWFjaGluZS9WaXJ0dWFsIE1hY2hpbmUs
IEJJT1MgSHlwZXItViBVRUZJIFJlbGVhc2UgdjQuMSAwMy8wOC8yMDI0DQpbIDI5NzIuMDczMDAx
XSBSSVA6IDAwMTA6cHJlcGFyZV90b193YWl0X2V2ZW50KzB4MTBlLzB4MTMwDQpbIDI5NzIuMDc1
MDI0XSBDb2RlOiAwOCA0ZCA4ZCA0NCAyNCAwOCA0OCA4ZCA1NyBlOCA0OCA4OSBmZSA0YyAzOSBj
NyA3NCAxZCA0YyA4OSBjNyBlYiAxMyA0OCA4YiA0MiAxOCA0OCA4OSBmNyA0OCA4ZCA1MCBlOCA0
OSAzOSBjMCA3NCAwOCA0OCA4OSBjNiA8ZjY+IDAyIDEwIDc1IGU4IDQ4IDhiIDA3IDQ4IDg5IDQ4
IDA4IDQ5IDg5IDQ3IDE4IDQ5IDg5IDdmIDIwIDQ4IDg5DQpbIDI5NzIuMDgyMzU2XSBSU1A6IDAw
MTg6ZmZmZmQxZGEwZTcxYjg1MCBFRkxBR1M6IDAwMDEwMDA3DQpbIDI5NzIuMDg0NDM1XSBSQVg6
IGZmZmZkMWRhMGU3MWI4ZjAgUkJYOiAwMDAwMDAwMDAwMDAwMDAxIFJDWDogZmZmZmQxZGEwZTcx
YjhmMA0KWyAyOTcyLjA4NzIzOV0gUkRYOiBmZmZmZmZmZmZmZmZmZmU4IFJTSTogMDAwMDAwMDAw
MDAwMDAwMCBSREk6IGZmZmY4ZjFlYzNhOTI4MTANClsgMjk3Mi4wOTAxMTZdIFJCUDogZmZmZmQx
ZGEwZTcxYjg3OCBSMDg6IGZmZmY4ZjFlYzNhOTI4MTAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQpb
IDI5NzIuMDkyOTcwXSBSMTA6IGZmZmZkMWRhMGU3MWI4ODggUjExOiAwMDAwMDAwMDAwMDAwMDAy
IFIxMjogZmZmZjhmMWVjM2E5MjgwOA0KWyAyOTcyLjA5NTgxNV0gUjEzOiBmZmZmOGYxZWQ4NjRh
OGMwIFIxNDogMDAwMDAwMDAwMDAwMDI0NiBSMTU6IGZmZmZkMWRhMGU3MWI4ZDgNClsgMjk3Mi4w
OTg3NjhdIEZTOiAwMDAwNzBjZDFkMzFiNzgwKDAwMDApIEdTOmZmZmY4ZjI3MWJjZTMwMDAoMDAw
MCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMA0KWyAyOTcyLjEwMTk1NV0gQ1M6IDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzDQpbIDI5NzIuMTA0MzIzXSBDUjI6IGZm
ZmZmZmZmZmZmZmZmZTggQ1IzOiAwMDAwMDAwMTQxOTdkMDAwIENSNDogMDAwMDAwMDAwMDM1MGVm
MA0KWyAyOTcyLjEwNzEzNV0gQ2FsbCBUcmFjZToNClsgMjk3Mi4xMDgyNjVdIDxUQVNLPg0KWyAy
OTcyLjEwOTE0NV0gX3NtYmRfZ2V0X2Nvbm5lY3Rpb24rMHhhNDMvMHgxOTcwIFtjaWZzXQ0KWyAy
OTcyLjExMTMxMF0gPyBzcnNvX3JldHVybl90aHVuaysweDUvMHg1Zg0KWyAyOTcyLjExMjk0MF0g
PyBfX3BmeF9hdXRvcmVtb3ZlX3dha2VfZnVuY3Rpb24rMHgxMC8weDEwDQpbIDI5NzIuMTE1MDEz
XSBzbWJkX2dldF9jb25uZWN0aW9uKzB4MjYvMHg1MCBbY2lmc10NClsgMjk3Mi4xMTY5NTddIGNp
ZnNfZ2V0X3RjcF9zZXNzaW9uKzB4NmE4LzB4OTcwIFtjaWZzXQ0KWyAyOTcyLjExOTE1Ml0gY2lm
c19tb3VudF9nZXRfc2Vzc2lvbisweDQ4LzB4MWMwIFtjaWZzXQ0KWyAyOTcyLjEyMTM1OF0gZGZz
X21vdW50X3NoYXJlKzB4N2IvMHhiMTAgW2NpZnNdDQpbIDI5NzIuMTIzMTYxXSA/IHNyc29fcmV0
dXJuX3RodW5rKzB4NS8weDVmDQpbIDI5NzIuMTI0NzY3XSA/IF9fd2FrZV91cF9rbG9nZCsweDU2
LzB4NzANClsgMjk3Mi4xMjY0MDddID8gc3Jzb19yZXR1cm5fdGh1bmsrMHg1LzB4NWYNClsgMjk3
Mi4xMjgxNzldID8gdnByaW50a19lbWl0KzB4MTVkLzB4MzcwDQpbIDI5NzIuMTI5ODQ2XSA/IHNy
c29fcmV0dXJuX3RodW5rKzB4NS8weDVmDQpbIDI5NzIuMTMxNDYxXSA/IF9fa21hbGxvY19ub2Rl
X3RyYWNrX2NhbGxlcl9ub3Byb2YrMHgxNzIvMHg1MjANClsgMjk3Mi4xMzM4MTNdIGNpZnNfbW91
bnQrMHg1Yi8weDJlMCBbY2lmc10NClsgMjk3Mi4xMzU1NDldIGNpZnNfc21iM19kb19tb3VudCsw
eDE4MC8weDdlMCBbY2lmc10NClsgMjk3Mi4xMzc2MjZdID8gdnByaW50aysweDE4LzB4NDANClsg
Mjk3Mi4xMzg5OTddID8gc3Jzb19yZXR1cm5fdGh1bmsrMHg1LzB4NWYNClsgMjk3Mi4xNDA2OTJd
ID8gX3ByaW50aysweDVmLzB4ODANClsgMjk3Mi4xNDIxNjNdIHNtYjNfZ2V0X3RyZWUrMHgxNmQv
MHgzNjAgW2NpZnNdDQpbIDI5NzIuMTQ0MDE1XSB2ZnNfZ2V0X3RyZWUrMHgyYS8weGYwDQpbIDI5
NzIuMTQ1NDExXSBwYXRoX21vdW50KzB4NTAwLzB4YjAwDQpbIDI5NzIuMTQ2ODM5XSA/IHNyc29f
cmV0dXJuX3RodW5rKzB4NS8weDVmDQpbIDI5NzIuMTQ4NDc5XSBfX3g2NF9zeXNfbW91bnQrMHgx
MTYvMHgxNTANClsgMjk3Mi4xNTA0OTNdIHg2NF9zeXNfY2FsbCsweDIwODIvMHgyMGQwDQpbIDI5
NzIuMTUyNjY3XSBkb19zeXNjYWxsXzY0KzB4N2IvMHg0ZjANClsgMjk3Mi4xNTQ2NDldID8gc3Jz
b19yZXR1cm5fdGh1bmsrMHg1LzB4NWYNClsgMjk3Mi4xNTY4MTVdID8gX19oYW5kbGVfbW1fZmF1
bHQrMHhhOWMvMHgxMDkwDQpbIDI5NzIuMTU5MjMyXSA/IF9fcHV0X3VzZXJfOCsweGQvMHgyMA0K
WyAyOTcyLjE2MTA2MF0gPyBzcnNvX3JldHVybl90aHVuaysweDUvMHg1Zg0KWyAyOTcyLjE2MzEw
OV0gPyBjb3VudF9tZW1jZ19ldmVudHMrMHhiYS8weDFhMA0KWyAyOTcyLjE2NTI0N10gPyBzcnNv
X3JldHVybl90aHVuaysweDUvMHg1Zg0KWyAyOTcyLjE2NzE5Ml0gPyBoYW5kbGVfbW1fZmF1bHQr
MHhiYy8weDMwMA0KWyAyOTcyLjE2OTExOF0gPyBzcnNvX3JldHVybl90aHVuaysweDUvMHg1Zg0K
WyAyOTcyLjE3MTAxMl0gPyBkb191c2VyX2FkZHJfZmF1bHQrMHgxYjkvMHg4NjANClsgMjk3Mi4x
NzMxNTJdID8gc3Jzb19yZXR1cm5fdGh1bmsrMHg1LzB4NWYNClsgMjk3Mi4xNzUwOTBdID8gaXJx
ZW50cnlfZXhpdF90b191c2VyX21vZGUrMHgyZS8weDI0MA0KWyAyOTcyLjE3NzUxOV0gPyBzcnNv
X3JldHVybl90aHVuaysweDUvMHg1Zg0KWyAyOTcyLjE3OTQ2N10gPyBpcnFlbnRyeV9leGl0KzB4
MWQvMHgzMA0KWyAyOTcyLjE4MTQ3M10gPyBzcnNvX3JldHVybl90aHVuaysweDUvMHg1Zg0KWyAy
OTcyLjE4MzU1NF0gPyBleGNfcGFnZV9mYXVsdCsweDg0LzB4MTUwDQpbIDI5NzIuMTg1NDAyXSBl
bnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Ni8weDdlDQpbIDI5NzIuMTg3NzA4XSBS
SVA6IDAwMzM6MHg3MGNkMWQxMmFmMGUNClsgMjk3Mi4xODk3MDZdIENvZGU6IDQ4IDhiIDBkIDBk
IDdmIDBkIDAwIGY3IGQ4IDY0IDg5IDAxIDQ4IDgzIGM4IGZmIGMzIDY2IDJlIDBmIDFmIDg0IDAw
IDAwIDAwIDAwIDAwIDkwIGYzIDBmIDFlIGZhIDQ5IDg5IGNhIGI4IGE1IDAwIDAwIDAwIDBmIDA1
IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgZGEgN2UgMGQgMDAgZjcgZDgg
NjQgODkgMDEgNDgNClsgMjk3Mi4xOTc2ODNdIFJTUDogMDAyYjowMDAwN2ZmZWNiMDlmMDI4IEVG
TEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwYTUNClsgMjk3Mi4yMDEyNTRd
IFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDAwMDAwMDAwMDAwMGEgUkNYOiAwMDAwNzBj
ZDFkMTJhZjBlDQpbIDI5NzIuMjA0NDEwXSBSRFg6IDAwMDA2MGFjYzU1OGE0N2UgUlNJOiAwMDAw
NjBhY2M1NThhNGU0IFJESTogMDAwMDdmZmVjYjBhMDYwOA0KWyAyOTcyLjIwNzY4N10gUkJQOiAw
MDAwN2ZmZWNiMDlmMGUwIFIwODogMDAwMDYwYWNlYTgzZWViMCBSMDk6IDAwMDAwMDAwMDAwMDAw
MDANClsgMjk3Mi4yMTA4NjVdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAw
MDAyNDYgUjEyOiAwMDAwNjBhY2M1NThhMDQ3DQpbIDI5NzIuMjE0MTEwXSBSMTM6IDAwMDA2MGFj
ZWE4M2ZmMjAgUjE0OiAwMDAwN2ZmZWNiMGEwNjA4IFIxNTogMDAwMDcwY2QxZDMyYTAwMA0KWyAy
OTcyLjIxNzM3OF0gPC9UQVNLPg0KWyAyOTcyLjIxODY1Nl0gTW9kdWxlcyBsaW5rZWQgaW46IHJw
Y3JkbWEgc3VucnBjIHJkbWFfdWNtIGliX2lzZXIgbGliaXNjc2kgc2NzaV90cmFuc3BvcnRfaXNj
c2kgc2l3IGliX3V2ZXJicyBjaWZzKE9FKSBubHNfdXRmOCBjaWZzX21kNCBuZXRmcyB0bHMgcXJ0
ciBjZmc4MDIxMSA4MDIxcSBnYXJwIG1ycCBzdHAgbGxjIHh0X2Nvbm50cmFjayBuZl9jb25udHJh
Y2sgbmZfZGVmcmFnX2lwdjYgbmZfZGVmcmFnX2lwdjQgeHRfb3duZXIgeHRfdGNwdWRwIG5mdF9j
b21wYXQgbmZfdGFibGVzIHhfdGFibGVzIGJpbmZtdF9taXNjIG5sc19pc284ODU5XzEgaW50ZWxf
cmFwbF9tc3IgaW50ZWxfcmFwbF9jb21tb24gam95ZGV2IG1hY19oaWQgaHlwZXJ2X2RybSBwb2x5
dmFsX2NsbXVsbmkgc2VyaW9fcmF3IGhpZF9nZW5lcmljIGdoYXNoX2NsbXVsbmlfaW50ZWwgaGlk
X2h5cGVydiBhZXNuaV9pbnRlbCBodl9uZXR2c2MgaHlwZXJ2X2ZiIGhpZCBoeXBlcnZfa2V5Ym9h
cmQgdm1nZW5pZCBrc21iZCBzY2hfZnFfY29kZWwgY2lmc19hcmM0IG5sc191Y3MyX3V0aWxzIHJk
bWFfY20gaXdfY20gaWJfY20gaWJfY29yZSBkbV9tdWx0aXBhdGggbXNyIG52bWVfZmFicmljcyBl
ZmlfcHN0b3JlIG5mbmV0bGluayBhdXRvZnM0IFtsYXN0IHVubG9hZGVkOiBjaWZzXQ0KWyAyOTcy
LjI0NDE1Nl0gQ1IyOiBmZmZmZmZmZmZmZmZmZmU4DQpbIDI5NzIuMjQ2MTE5XSAtLS1bIGVuZCB0
cmFjZSAwMDAwMDAwMDAwMDAwMDAwIF0tLS0NClsgMjk3Mi4zNDUyNjddIFJJUDogMDAxMDpwcmVw
YXJlX3RvX3dhaXRfZXZlbnQrMHgxMGUvMHgxMzANClsgMjk3Mi4zNDc5ODNdIENvZGU6IDA4IDRk
IDhkIDQ0IDI0IDA4IDQ4IDhkIDU3IGU4IDQ4IDg5IGZlIDRjIDM5IGM3IDc0IDFkIDRjIDg5IGM3
IGViIDEzIDQ4IDhiIDQyIDE4IDQ4IDg5IGY3IDQ4IDhkIDUwIGU4IDQ5IDM5IGMwIDc0IDA4IDQ4
IDg5IGM2IDxmNj4gMDIgMTAgNzUgZTggNDggOGIgMDcgNDggODkgNDggMDggNDkgODkgNDcgMTgg
NDkgODkgN2YgMjAgNDggODkNClsgMjk3Mi4zNTY1MTNdIFJTUDogMDAxODpmZmZmZDFkYTBlNzFi
ODUwIEVGTEFHUzogMDAwMTAwMDcNClsgMjk3Mi4zNTkxNTBdIFJBWDogZmZmZmQxZGEwZTcxYjhm
MCBSQlg6IDAwMDAwMDAwMDAwMDAwMDEgUkNYOiBmZmZmZDFkYTBlNzFiOGYwDQpbIDI5NzIuMzYy
NDUzXSBSRFg6IGZmZmZmZmZmZmZmZmZmZTggUlNJOiAwMDAwMDAwMDAwMDAwMDAwIFJESTogZmZm
ZjhmMWVjM2E5MjgxMA0KWyAyOTcyLjM2NTc4Ml0gUkJQOiBmZmZmZDFkYTBlNzFiODc4IFIwODog
ZmZmZjhmMWVjM2E5MjgxMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDANClsgMjk3Mi4zNjkyOTVdIFIx
MDogZmZmZmQxZGEwZTcxYjg4OCBSMTE6IDAwMDAwMDAwMDAwMDAwMDIgUjEyOiBmZmZmOGYxZWMz
YTkyODA4DQpbIDI5NzIuMzcyOTA3XSBSMTM6IGZmZmY4ZjFlZDg2NGE4YzAgUjE0OiAwMDAwMDAw
MDAwMDAwMjQ2IFIxNTogZmZmZmQxZGEwZTcxYjhkOA0KWyAyOTcyLjM3NjQ1NV0gRlM6IDAwMDA3
MGNkMWQzMWI3ODAoMDAwMCkgR1M6ZmZmZjhmMjcxYmNlMzAwMCgwMDAwKSBrbmxHUzowMDAwMDAw
MDAwMDAwMDAwDQpbIDI5NzIuMzgwMjcxXSBDUzogMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6
IDAwMDAwMDAwODAwNTAwMzMNClsgMjk3Mi4zODMxNjFdIENSMjogZmZmZmZmZmZmZmZmZmZlOCBD
UjM6IDAwMDAwMDAxNDE5N2QwMDAgQ1I0OiAwMDAwMDAwMDAwMzUwZWYwDQpbIDI5NzIuMzg2NTUx
XSBub3RlOiBtb3VudC5jaWZzWzIwODA0MF0gZXhpdGVkIHdpdGggaXJxcyBkaXNhYmxlZA==
--00000000000040acda063bd93edb--
