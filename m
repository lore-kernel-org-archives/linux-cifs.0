Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288A18A956
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 01:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771290185; cv=pass; b=C7rdmztaivZrXrztBfCCrUjyFb0/xlpsGxYBz3qPs56U2IQ073q4QHMj4Z0EzB8QVnjiIeT4q38Eo1IAv2ImSBVGXiUxmnov6EWl+zUHwrzSeEPUJaZZQWLEygDChjC8jbGbJpHRBMXtbZ7Ilw7keVlEAsp0LW9HhdAubWhRPCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771290185; c=relaxed/simple;
	bh=YoLFKiuiYfmiscIRlwX892wv7k5db/LbmXB6/RaLZw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdBbc2/CPYqRZFSeDjCjWVagKytnghHfKu/DZtBABYqfhDbdRAAuZGgDXdabi2nNtLDq7vVxTI2fJqEX0LRdChCC64HQk8XTf/SjaNxUZj0iOnPi9n7Lv47Ldu5kRF1lpcaaKNv1rOg+WxUKVYZlDV2Fd+zNX/pBQNKKU3yZbeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XfrZvf5E; arc=pass smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfrZvf5E"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb513e860cso221989285a.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 17:03:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771290183; cv=none;
        d=google.com; s=arc-20240605;
        b=lxMzCJ4MBSHD+hgyxpvsN3ktOJ03swhTvXiSNGvem3WvXRP8+RTtkUUDmW5PxX0C2j
         qDRMkjtnMOlDy27C7RBbp30epsWv+uk6Ihjx1nmokdDMg28FrHmG+gm9SvFGylNzbIQ3
         aiOs9jxvoM7HqP2OZv+sRdQH20MKHUyskxw/fFs/mw60KE+LQPK9szEDR5dICT/ULRv9
         wsMxPqYJH4b/nOAkpxX5U5qXJH69kJSRS64Na/my6IZkzNmwqBgm+dNAm4+IPZLtQNXA
         FEDwVmYeUDjpw7dYdf9NU8QhzxgLRBRxPBuUj4bd7ndzEtQaLsghsZQgLWKF37qK8HDP
         e+8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ab/89WsPFzLoQCrdBmafzC9YRTx2QuTnSinw87I/Poc=;
        fh=aIzavqEU9K9SpdU5NIfB+MEy++IQqQpFfDtdXcKUeQk=;
        b=KOIU9H8wu14yAO/CKv6Esh30YTRiqhyvM1zStOulgota48C0qKQnG7DU80N7sZjV3+
         XoeO4Lc8sGAkVfIfxrjCa5pfAxF5hDIGf9LCM6OxiEoOJd+kpNLNgkh3mdaFikIRIbGF
         nWdH6iGwGL9lHt7Jqds5MlNcbZ1+xJ08/eNE+MxnS2GcnLdGDq0Re/LXaOfbV1BRIi6Z
         TZkQxpjdghzznqYVXlgNOGUnEoowvwgDkVHBKxQNN7fBfwIysYqLUYcYvHNbyHSyJWj0
         bUJle1hGYalh4x4sOEC5mJpHx93oITqTpO7AMrgNlSQVK62c3p4Hip3mokzP9PvOybHH
         5akQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771290183; x=1771894983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ab/89WsPFzLoQCrdBmafzC9YRTx2QuTnSinw87I/Poc=;
        b=XfrZvf5E+HJaNGy/eXOHjivrBSskf5uPC0SNVrpMveLDWIzHHzOI1kyB1fjEg4LkKJ
         9VM9dg2fUKnvMN7d7DhGIJjK1oXy5o72FL+blA4wi/q9zF6nGZt45FxRvstB/70zpNun
         C4LvpFGOabim7oMSLHnQtkyLUcExAgOzBTe+Rqke/rY6tU866CWYwJaCl4OPrvjuq3pW
         wzUYST+pzX2e5QFCZ1po6+AZPCSs0OG28gdRNwH6sVZQU0KLYa/sagPTG34XafYiZAWg
         AQ6RRgF4TF9mYwxiCVk7JlVQfkwELqgzWDIzHE0xtCna8/+MLMeJHFJbUcQFLqiGNBfC
         vuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771290183; x=1771894983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ab/89WsPFzLoQCrdBmafzC9YRTx2QuTnSinw87I/Poc=;
        b=ZqgJ/DhsmR/MdRDXD5KC9XvSzB2Cq0gZlTk/8WqMRakj72WLEattKbejGtiIGc9eJj
         tAsDnui8EVIMYKmZ7l8QE+UkbcGq5FW3ZzfXO2vtNvfksItu8zpVIRhWFH1+IcTw5m1L
         Ust3NjOHfauExD11mi2zQ+HVvrsT+6TRe2JPFop6kbreEQkaKo8fiu8mtM19VNh4CFt8
         nHWvzTas3FJzgoop8gp3P+4AWRvi+gwul2f9ig6HHS7j6n9WX2s16H77zd5Zd+Ch8bUA
         euC0Zp0yv4vZJQRmvbQfg1BSewHKNhpWvJTl2eJLzl0l7AZO53mCrFN2blOM5BOrUauP
         cWCg==
X-Forwarded-Encrypted: i=1; AJvYcCUVnr4yghQRM8GnB1TERBL8PWD7EleWRb5RIsDx6fykCB4rbCMRCwljOyov+3KyojTInAWqWwzY/xKH@vger.kernel.org
X-Gm-Message-State: AOJu0YyHK5sm+jlkcRq6nRj2PSql+NJl/47NxHA98w+Rz/59WnQz5nDa
	3XmIev/86F154/y4DjSTqI/QZC9XLCXcrv9SNzf+Pq7UYB+4vaqmqfxzrlH0gEJvch2q+/3rEyN
	BoUOM0dcF4jPFAnC8ZGsDSTvpk/309ac=
X-Gm-Gg: AZuq6aJ4e3We9+ah38nDg02CMfqdhW+XdRIQ4kpJiPc7Lp+ITrG6Z+muqfQC+mMiYgs
	FuTT+C210lNTl1OS/MKRUTVanvQMy17nUBNKCNloJeA1n7gfW9KIa9AJ4ub6A4b3NzyT5Lykmo6
	552v0Swv76DHzip+ndNv66alzeMKu8+TJejzWv9B27N3ek+gYkfeH+0U/XdEL6KKZ/Uvb3XD75v
	nLe8lfi4eaRZkWgOCJvYs6X1uaXdSFTRrLnRnitPsoRJH1iPtN4FZ3R513SsNcHZS/xF6P88wEM
	HWqbFd+rp32PKNF9lB0uUh892IDWHEpUtgrmeyxCEKVJjhszLqaAeNdBnUCB3y0gm1W5txD1+3i
	HqhTuF3bQOoBUdvGyISGdYlN5LLKFVbwSSeteyiq+1A4ei8Bd2tH7bqKVGi8N54ZGTs65lAbWx+
	BYwDfdQoyHSBdHvjul3N+7470BpEgB1ciY
X-Received: by 2002:a05:620a:46a0:b0:8ca:7b14:16d4 with SMTP id
 af79cd13be357-8cb42461df5mr1405362185a.63.1771290182838; Mon, 16 Feb 2026
 17:03:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770311507.git.metze@samba.org> <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org> <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
 <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
 <CAH2r5muf=Th_AbA7SZaQKApyvr81FMB8WF-5yZ3ihzap1swQWg@mail.gmail.com>
 <98d25ce1-1f1a-4517-89f0-8956bffaf9d3@samba.org> <CAH2r5mswN8W652Br4QQTzhtDXtXKvqea=dWVfUFF+xDYfOx6HA@mail.gmail.com>
 <28d94c9f-b85e-4746-bb08-188090409682@samba.org> <CAH2r5mtA=DdpEiyqspNG3eoyjkGajnEwoRnOyXyBimDtCND9ig@mail.gmail.com>
 <c5aef237-2a12-4be5-b917-de502780be85@samba.org> <CAH2r5msAAN-EgOmRnoO7R4RPu2suNr+mgk5c5JAj9b-_kjwymg@mail.gmail.com>
 <237aa80d-8bd2-4dad-9975-85e11e2bf1fd@samba.org>
In-Reply-To: <237aa80d-8bd2-4dad-9975-85e11e2bf1fd@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Feb 2026 19:02:51 -0600
X-Gm-Features: AaiRm500tYHW_VJ6q7fYsaxgR3mDIo8qVgTNLl8m4yvhY0jURNyUS0fhYcNQmwA
Message-ID: <CAH2r5ms2EYJMm+764mJ2nLZRBz2R7+5LAeKfxZ1mb13uSSoYiw@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Arnd Bergmann <arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated ksmbd-for-next with the patches from your
for-7.0/smbdirect-ko-20260216-v8 branch

Let me know if any testing or review issues.

On Mon, Feb 16, 2026 at 7:49=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Steve,
>
> for-7.0/smbdirect-ko-20260216-v8 at commit:
> 8a2259252f084fe55411346d58a1160fc69b7d30
> git fetch https://git.samba.org/metze/linux/wip.git for-7.0/smbdirect-ko-=
20260216-v8
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/head=
s/for-7.0/smbdirect-ko-20260216-v8
>
> fixes 3 problems:
> compared to for-7.0/smbdirect-ko-20260213-v7:
>
> - We use BUILD_BUG_ON(sizeof(*batch) > sizeof(*storage));
>    instead of BUILD_BUG_ON(sizeof(*batch) < sizeof(*storage));
>    Closes: https://lore.kernel.org/oe-kbuild-all/202602141417.hsmt2AAb-lk=
p@intel.com/
> - We now use [SMBDIRECT_DEBUG_]ERR_PTR(ret) with %1pe
>    instead of errname(ret) with %s
>    Closes: https://lore.kernel.org/oe-kbuild-all/202602141435.Sm9ZppiO-lk=
p@intel.com/
> - We use 'select SG_POOL' for the client as long
>    as smbdirect_all_c_files.c is used
>    Closes: https://lore.kernel.org/linux-cifs/20260216105404.2381695-1-ar=
nd@kernel.org/
>
> The overall diff to the current ksmbd-for-next
> (at commit 2a43d1cf4bd3bc0cff03f0926e83895a7462ad05) is pasted below:
>
> Please replace ksmbd-for-next with commit
> 8a2259252f084fe55411346d58a1160fc69b7d30,
>
> Thanks!
> metze
>
>   fs/smb/client/smbdirect.c                      |  5 ++---
>   fs/smb/common/smbdirect/smbdirect_connection.c | 26 +++++++++++++------=
-------
>   fs/smb/common/smbdirect/smbdirect_devices.c    |  3 ++-
>   fs/smb/common/smbdirect/smbdirect_internal.h   |  1 -
>   fs/smb/common/smbdirect/smbdirect_main.c       |  3 ++-
>   fs/smb/common/smbdirect/smbdirect_mr.c         | 21 +++++++++++--------=
--
>   fs/smb/common/smbdirect/smbdirect_socket.c     |  3 ++-
>   fs/smb/server/transport_rdma.c                 | 25 ++++++++++++-------=
------
>   8 files changed, 44 insertions(+), 43 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index de3b51fa2d62..ff80072dc9ff 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -5,7 +5,6 @@
>    *   Author(s): Long Li <longli@microsoft.com>
>    */
>
> -#include <linux/errname.h>
>   #include "smbdirect.h"
>   #include "cifs_debug.h"
>   #include "cifsproto.h"
> @@ -325,8 +324,8 @@ static struct smbd_connection *_smbd_get_connection(
>
>         ret =3D smbdirect_connect_sync(sc, dstaddr);
>         if (ret) {
> -               log_rdma_event(ERR, "connect to %pISpsfc failed: %s\n",
> -                              dstaddr, errname(ret));
> +               log_rdma_event(ERR, "connect to %pISpsfc failed: %1pe\n",
> +                              dstaddr, ERR_PTR(ret));
>                 goto connect_failed;
>         }
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/comm=
on/smbdirect/smbdirect_connection.c
> index 813ddd87c6ae..1e946f78e935 100644
> --- a/fs/smb/common/smbdirect/smbdirect_connection.c
> +++ b/fs/smb/common/smbdirect/smbdirect_connection.c
> @@ -968,7 +968,7 @@ smbdirect_init_send_batch_storage(struct smbdirect_se=
nd_batch_storage *storage,
>         struct smbdirect_send_batch *batch =3D (struct smbdirect_send_bat=
ch *)storage;
>
>         memset(storage, 0, sizeof(*storage));
> -       BUILD_BUG_ON(sizeof(*batch) < sizeof(*storage));
> +       BUILD_BUG_ON(sizeof(*batch) > sizeof(*storage));
>
>         smbdirect_connection_send_batch_init(batch,
>                                              need_invalidate_rkey,
> @@ -1111,10 +1111,10 @@ int smbdirect_connection_send_single_iter(struct =
smbdirect_socket *sc,
>
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
>                 smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
> -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
>                         smbdirect_socket_status_string(sc->status),
>                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> -                       errname(-ENOTCONN));
> +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
>                 return -ENOTCONN;
>         }
>
> @@ -1273,10 +1273,10 @@ int smbdirect_connection_send_wait_zero_pending(s=
truct smbdirect_socket *sc)
>                    sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
>                 smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
> -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
>                         smbdirect_socket_status_string(sc->status),
>                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> -                       errname(-ENOTCONN));
> +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
>                 return -ENOTCONN;
>         }
>
> @@ -1305,10 +1305,10 @@ int smbdirect_connection_send_iter(struct smbdire=
ct_socket *sc,
>
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
>                 smbdirect_log_write(sc, SMBDIRECT_LOG_INFO,
> -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
>                         smbdirect_socket_status_string(sc->status),
>                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> -                       errname(-ENOTCONN));
> +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
>                 return -ENOTCONN;
>         }
>
> @@ -1485,8 +1485,8 @@ int smbdirect_connection_post_recv_io(struct smbdir=
ect_recv_io *msg)
>         ret =3D ib_post_recv(sc->ib.qp, &recv_wr, NULL);
>         if (ret) {
>                 smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
> -                       "ib_post_recv failed ret=3D%d (%s)\n",
> -                       ret, errname(ret));
> +                       "ib_post_recv failed ret=3D%d (%1pe)\n",
> +                       ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
>                 ib_dma_unmap_single(sc->ib.dev,
>                                     msg->sge.addr,
>                                     msg->sge.length,
> @@ -1716,8 +1716,8 @@ int smbdirect_connection_recv_io_refill(struct smbd=
irect_socket *sc)
>                 ret =3D smbdirect_connection_post_recv_io(recv_io);
>                 if (ret) {
>                         smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
> -                               "smbdirect_connection_post_recv_io failed=
 rc=3D%d (%s)\n",
> -                               ret, errname(ret));
> +                               "smbdirect_connection_post_recv_io failed=
 rc=3D%d (%1pe)\n",
> +                               ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
>                         smbdirect_connection_put_recv_io(recv_io);
>                         return ret;
>                 }
> @@ -1802,10 +1802,10 @@ int smbdirect_connection_recvmsg(struct smbdirect=
_socket *sc,
>   again:
>         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
>                 smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
> -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
>                         smbdirect_socket_status_string(sc->status),
>                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> -                       errname(-ENOTCONN));
> +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
>                 return -ENOTCONN;
>         }
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_devices.c b/fs/smb/common/=
smbdirect/smbdirect_devices.c
> index d1a251141145..3ace41af2200 100644
> --- a/fs/smb/common/smbdirect/smbdirect_devices.c
> +++ b/fs/smb/common/smbdirect/smbdirect_devices.c
> @@ -249,7 +249,8 @@ __init int smbdirect_devices_init(void)
>
>         ret =3D ib_register_client(&smbdirect_ib_client);
>         if (ret) {
> -               pr_err("failed to ib_register_client: %d %s\n", ret, errn=
ame(ret));
> +               pr_crit("failed to ib_register_client: %d %1pe\n",
> +                       ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
>                 return ret;
>         }
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common=
/smbdirect/smbdirect_internal.h
> index 09a4ce8ed863..30a1b8643657 100644
> --- a/fs/smb/common/smbdirect/smbdirect_internal.h
> +++ b/fs/smb/common/smbdirect/smbdirect_internal.h
> @@ -8,7 +8,6 @@
>
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> -#include <linux/errname.h>
>   #include "smbdirect.h"
>   #include "smbdirect_pdu.h"
>   #include "smbdirect_public.h"
> diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/common/smb=
direct/smbdirect_main.c
> index 266d00da25f6..fe6e8d93c34c 100644
> --- a/fs/smb/common/smbdirect/smbdirect_main.c
> +++ b/fs/smb/common/smbdirect/smbdirect_main.c
> @@ -91,7 +91,8 @@ static __init int smbdirect_module_init(void)
>         destroy_workqueue(smbdirect_globals.workqueues.accept);
>   alloc_accept_wq_failed:
>         mutex_unlock(&smbdirect_globals.mutex);
> -       pr_crit("failed to loaded: %d (%s)\n", ret, errname(ret));
> +       pr_crit("failed to loaded: %d (%1pe)\n",
> +               ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
>         return ret;
>   }
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdi=
rect/smbdirect_mr.c
> index 5e9420d01fe3..32668c58efb0 100644
> --- a/fs/smb/common/smbdirect/smbdirect_mr.c
> +++ b/fs/smb/common/smbdirect/smbdirect_mr.c
> @@ -43,8 +43,9 @@ int smbdirect_connection_create_mr_list(struct smbdirec=
t_socket *sc)
>                 if (IS_ERR(mr->mr)) {
>                         ret =3D PTR_ERR(mr->mr);
>                         smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -                               "ib_alloc_mr failed ret=3D%d (%s) type=3D=
0x%x max_frmr_depth=3D%u\n",
> -                               ret, errname(ret), sc->mr_io.type, sp->ma=
x_frmr_depth);
> +                               "ib_alloc_mr failed ret=3D%d (%1pe) type=
=3D0x%x max_frmr_depth=3D%u\n",
> +                               ret, SMBDIRECT_DEBUG_ERR_PTR(ret),
> +                               sc->mr_io.type, sp->max_frmr_depth);
>                         goto ib_alloc_mr_failed;
>                 }
>                 mr->sgt.sgl =3D kcalloc(sp->max_frmr_depth,
> @@ -173,8 +174,8 @@ smbdirect_connection_get_mr_io(struct smbdirect_socke=
t *sc)
>                                        sc->status !=3D SMBDIRECT_SOCKET_C=
ONNECTED);
>         if (ret) {
>                 smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -                       "wait_event_interruptible ret=3D%d (%s)\n",
> -                       ret, errname(ret));
> +                       "wait_event_interruptible ret=3D%d (%1pe)\n",
> +                       ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
>                 return NULL;
>         }
>
> @@ -304,8 +305,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_=
socket *sc,
>         ret =3D ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr-=
>dir);
>         if (!ret) {
>                 smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -                       "ib_dma_map_sg num_pages=3D%u dir=3D%x ret=3D%d (=
%s)\n",
> -                       num_pages, mr->dir, ret, errname(ret));
> +                       "ib_dma_map_sg num_pages=3D%u dir=3D%x ret=3D%d (=
%1pe)\n",
> +                       num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(=
ret));
>                 goto dma_map_error;
>         }
>
> @@ -348,8 +349,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_=
socket *sc,
>         }
>
>         smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -               "ib_post_send failed ret=3D%d (%s) reg_wr->key=3D0x%x\n",
> -               ret, errname(ret), reg_wr->key);
> +               "ib_post_send failed ret=3D%d (%1pe) reg_wr->key=3D0x%x\n=
",
> +               ret, SMBDIRECT_DEBUG_ERR_PTR(ret), reg_wr->key);
>
>   map_mr_error:
>         ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
> @@ -435,8 +436,8 @@ void smbdirect_connection_deregister_mr_io(struct smb=
direct_mr_io *mr)
>                 ret =3D ib_post_send(sc->ib.qp, wr, NULL);
>                 if (ret) {
>                         smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -                               "ib_post_send failed ret=3D%d (%s)\n",
> -                               ret, errname(ret));
> +                               "ib_post_send failed ret=3D%d (%1pe)\n",
> +                               ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
>                         smbdirect_mr_io_disable_locked(mr);
>                         smbdirect_socket_schedule_cleanup(sc, ret);
>                         goto done;
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/s=
mbdirect/smbdirect_socket.c
> index 073df565f347..74e31b35a2f6 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.c
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.c
> @@ -71,7 +71,8 @@ int smbdirect_socket_init_new(struct net *net, struct s=
mbdirect_socket *sc)
>         ret =3D rdma_set_afonly(id, 1);
>         if (ret) {
>                 rdma_destroy_id(id);
> -               pr_err("%s: rdma_set_afonly() failed %1pe\n", __func__, e=
rrname(ret));
> +               pr_err("%s: rdma_set_afonly() failed %1pe\n",
> +                      __func__, SMBDIRECT_DEBUG_ERR_PTR(ret));
>                 return ret;
>         }
>
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdm=
a.c
> index 5a577a9b0bf8..706a2c897948 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -12,7 +12,6 @@
>   #include <linux/kthread.h>
>   #include <linux/list.h>
>   #include <linux/string_choices.h>
> -#include <linux/errname.h>
>
>   #include "glob.h"
>   #include "connection.h"
> @@ -413,8 +412,8 @@ static int smb_direct_listen(struct smb_direct_listen=
er *listener,
>
>         ret =3D smbdirect_socket_create_kern(net, &sc);
>         if (ret) {
> -               pr_err("smbdirect_socket_create_kern() failed: %d %s\n",
> -                      ret, errname(ret));
> +               pr_err("smbdirect_socket_create_kern() failed: %d %1pe\n"=
,
> +                      ret, ERR_PTR(ret));
>                 return ret;
>         }
>
> @@ -440,28 +439,28 @@ static int smb_direct_listen(struct smb_direct_list=
ener *listener,
>                                      smb_direct_logging_vaprintf);
>         ret =3D smbdirect_socket_set_initial_parameters(sc, sp);
>         if (ret) {
> -               pr_err("Failed smbdirect_socket_set_initial_parameters():=
 %d %s\n",
> -                      ret, errname(ret));
> +               pr_err("Failed smbdirect_socket_set_initial_parameters():=
 %d %1pe\n",
> +                      ret, ERR_PTR(ret));
>                 goto err;
>         }
>         ret =3D smbdirect_socket_set_kernel_settings(sc, IB_POLL_WORKQUEU=
E, KSMBD_DEFAULT_GFP);
>         if (ret) {
> -               pr_err("Failed smbdirect_socket_set_kernel_settings(): %d=
 %s\n",
> -                      ret, errname(ret));
> +               pr_err("Failed smbdirect_socket_set_kernel_settings(): %d=
 %1pe\n",
> +                      ret, ERR_PTR(ret));
>                 goto err;
>         }
>
>         ret =3D smbdirect_socket_bind(sc, (struct sockaddr *)&sin);
>         if (ret) {
> -               pr_err("smbdirect_socket_bind() failed: %d %s\n",
> -                      ret, errname(ret));
> +               pr_err("smbdirect_socket_bind() failed: %d %1pe\n",
> +                      ret, ERR_PTR(ret));
>                 goto err;
>         }
>
>         ret =3D smbdirect_socket_listen(sc, 10);
>         if (ret) {
> -               pr_err("Port[%d] smbdirect_socket_listen() failed: %d %s\=
n",
> -                      port, ret, errname(ret));
> +               pr_err("Port[%d] smbdirect_socket_listen() failed: %d %1p=
e\n",
> +                      port, ret, ERR_PTR(ret));
>                 goto err;
>         }
>
> @@ -473,8 +472,8 @@ static int smb_direct_listen(struct smb_direct_listen=
er *listener,
>                               "ksmbd-smbdirect-listener-%u", port);
>         if (IS_ERR(kthread)) {
>                 ret =3D PTR_ERR(kthread);
> -               pr_err("Can't start ksmbd listen kthread: %d %s\n",
> -                      ret, errname(ret));
> +               pr_err("Can't start ksmbd listen kthread: %d %1pe\n",
> +                      ret, ERR_PTR(ret));
>                 goto err;
>         }
>
>


--=20
Thanks,

Steve
