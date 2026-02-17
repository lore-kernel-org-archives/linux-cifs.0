Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965E41B7F4
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 02:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771294629; cv=pass; b=WrUN7rWckA0uL+KTQA4blIhGFKqf9FbASCFZxnOkfDJTDL2zDK9UlSmZF+oxl3Pvuu+nvcmfbft+uB1Sn+tVMwch5IzFss6qcyDVZ0g1tdmUWbVH57HYHZtGA+BI1cxoHcmByVTjVlyxaS7jX1okRC40kTR3PGenluh1pkugbFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771294629; c=relaxed/simple;
	bh=McQbJr9Ix4X45kVJQsQFfSkn67Nk/JDXHqmHfyj1eJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XRzsPTppAIpmRvz+aSqqN6VPAgRwWtVAV9CNS9WlQFp9p+DP7fA673RBo/4iczd8eWnLAuItNpzZLksT5Q8YE4wbDtWc6rAW72v/LWXNFnoVV10mzWuZBHAth30aAu4OPuEA+XNv/DvxMCj3/coUz+UtR7mSUYsB+LwzdIzhGQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T1hcZRRW; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1hcZRRW"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8946f12b1cfso45965866d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 18:17:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771294626; cv=none;
        d=google.com; s=arc-20240605;
        b=i11NVCKUyrv2ZTIqIP/nKWJpYSFACH1BxX1SsDCwXnBnoV80eNN5JJg5uJ8dUpLgHY
         WTMWPYhynmALG+khgdqpbo/9OMNfVmuXZxVgkwLUlLULbWmnIwr4JviforRVEUNvTxKu
         ubKC5l266ogPXVBtekJ/7gmMPOHb47D6oR5Vw8wbfmCKFslRgdi3PX2pX5QNCZkWC4GL
         +AOBzpj7A69IREiZOuPou6KS1Phvoejm9Tv1YTB2rFJC9QLhPv/t0dmEhu6OXRC8Wqk1
         SXJpQRJNeWvf7PDuTLVe3wkTT0VepvI5T44TlRfcLbNcXpkL9r2MuNG9eP78BjOLOpGl
         48kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cR6VTTPeEYv4X8MyBPhRt1sEm1kqq2t1Zlngde9BXy0=;
        fh=aF5DQk/ip18bz4FPVmDexryXNT/IpNE4WR6DKTDyGPQ=;
        b=WsrltnFmiu92tedU2y19oA8D2sZlrQrdKzAmZqlboQD1PUOtjfZox5gvZMj4iE3VyO
         SdZsLeA6R5icTXpbaZ/rCpXY+/Sv00m/QkMPptCF4NGu2r9QQO++7Jo40DO/ORtEGrUv
         fpiSBpQFYmg231NlMqn4Z34LHh89OOl2JjB2AugPlCJ8u0Drd61vbi+u751N3ACIJE92
         y6LOD75/WpGRdSlTOnwRSwIA1cixA0efOFFndzPzq5Pzr8gp9k2/t68kG/w64PuLjJ/q
         BP5BpZpR/eAAC1w5zsS+u6KXkaacpkRHpZ/CS0i+6I9ZDgyXxqU4rjoZvAVCFwjNEcda
         dKkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771294626; x=1771899426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cR6VTTPeEYv4X8MyBPhRt1sEm1kqq2t1Zlngde9BXy0=;
        b=T1hcZRRW7UzVgXzC0Sag+hwDGgi4qCZ1oih+0TLYVW7cKBQYHwLDLLYN7kxXLhbHuM
         uHD4ISMwTvJP8tJAWkJuVvlnLyDgDCQw8bi9SOlxTuY14hvalbz3OaxD3EmJY3gsZtz3
         EqwGuPEugm4pcOlLtTr/ra1Xs4rk5Yb8GtZiBurH1ded3kzpLG2f6TReItGn0lR/vBQu
         3JdDkzD67uLV+BZ/yaFCldqfLvQrlPEWYI4hbv27JklfRZ4+EnGDwEudRivs/L6imzXp
         z+lFe5gn58ZZS5Ef42pouG0sC9KeuSIw78paYP0f+4/LhlPe7FV0jd0Kdu/mPYPFCFFo
         NYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771294626; x=1771899426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cR6VTTPeEYv4X8MyBPhRt1sEm1kqq2t1Zlngde9BXy0=;
        b=LQrTqg+jDkMUsSkH4HA3gAfXJrhTUgL1U1DjlPqF3QVoph3q5ESqc3/CydakUtMdwD
         jdpNQp6OjqIfWjEfDdkQN+fplLM94tkcWqZLaOpHsG5+QvAQnRiiBUrnGvRF0gl6G8GG
         5UsnWnbEmDKrCsQSJ6QmB9DMV5w5AkH2eyv9LJvmCPfevGSR5+Zd2TGpuOptdbbryxgG
         cbgmVzrHVayaOr/hTEaKUo8t7PpZmiZV0PK7KTYiDJjFcuAT1inWykNU+jsg44bWzhP2
         +woyxqaY6fwaBiyxn5rkiVL1EJhEbWv9tXxWTKy1h72zlEFPihM1JiLiSEAVi2xgzDat
         l6+A==
X-Forwarded-Encrypted: i=1; AJvYcCULS7HLFuYivDToksoMmgybonE66AJCQa4aCg0VKkCob68c7voI6kO1DommDkhUQ4cg93+fPVabosDg@vger.kernel.org
X-Gm-Message-State: AOJu0YwW+znsJ1FLS6xlLWR0hkXDvfWPCt5ELburOoH8WGRQEPWsggU2
	0ZKkG9edncEOQ6HXiM0UF7anjR7X4YgLd1vPmDE+moyvdDIdSJGfbG+JbUSOLqIQYOu0Tot673A
	9YKjijDxYKvJRv/3X187lePIK3TzTz6M=
X-Gm-Gg: AZuq6aIl2UrZEa4zYewhoeIczzYYCJrOgTfmnsUeJjXYm7fNvA0NeNKzY6a78+Nu4IW
	Y51U/qXyaZid30Zg/AkYZdXcq9j8qxGuRyKBvGBaNC733US8jIua6IewXysj4am8TRadkCwtf1h
	Z7Nj6ytkxK5bYlgFod6fkMsgEbNuHWy3+p94bZd7tbQ4uoO/ceeGx4KymyHC2bouv1FAHsC5df1
	DWmCqt1csMuy4J1sV851F9FZg2WCDRs2lrg1/fl3KzwhcyHYB3P5lB1jdSbcsBX8kIgtlGY36hD
	GCJauf06D2JB4WVZkrTARzMD4pPKsPy7mgP6jP1UYF6daIEuoHy83AiU5XJSzwcOHQZf+QeJw3F
	muZJGKZYGojcEKyf4mQ0w5dpiY9mOOvnT2K/AwbjbtzJO+WcSYRggQ6ww9qRi1SUMskYNBNtmFC
	4phSaBbwRc3MsrC6qQS6Q6ppxMz/3W2bWD
X-Received: by 2002:ac8:5f50:0:b0:501:48e9:68f with SMTP id
 d75a77b69052e-506a8356556mr158345981cf.62.1771294626212; Mon, 16 Feb 2026
 18:17:06 -0800 (PST)
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
 <237aa80d-8bd2-4dad-9975-85e11e2bf1fd@samba.org> <CAH2r5ms2EYJMm+764mJ2nLZRBz2R7+5LAeKfxZ1mb13uSSoYiw@mail.gmail.com>
In-Reply-To: <CAH2r5ms2EYJMm+764mJ2nLZRBz2R7+5LAeKfxZ1mb13uSSoYiw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Feb 2026 20:16:54 -0600
X-Gm-Features: AaiRm50MJv9VZwlEkjFZcQpVAVSXs_sVl-0YCjBMeH5KzPlRYqqJ-QFQtZVOvCU
Message-ID: <CAH2r5mvmLYjJnxZmH3Mdawpk97Os7Zk9t_m=FrVOAXALNTw7hw@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Arnd Bergmann <arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed build warnings on two files when I build with your updated
branch. See below:

  CHECK   client/smbdirect.c
client/smbdirect.c:97:1: error: bad integer constant expression
client/smbdirect.c:97:1: error: static assertion failed:
"MODULE_INFO(parmtype, ...) contains embedded NUL byte"
client/smbdirect.c:98:1: error: bad integer constant expression
client/smbdirect.c:98:1: error: static assertion failed:
"MODULE_INFO(parm, ...) contains embedded NUL byte"
client/smbdirect.c:104:1: error: bad integer constant expression
client/smbdirect.c:104:1: error: static assertion failed:
"MODULE_INFO(parmtype, ...) contains embedded NUL byte"
client/smbdirect.c:105:1: error: bad integer constant expression
client/smbdirect.c:105:1: error: static assertion failed:
"MODULE_INFO(parm, ...) contains embedded NUL byte"
  CC [M]  server/server.o
  CHECK   server/server.c
server/server.c:629:1: error: bad integer constant expression
server/server.c:629:1: error: static assertion failed:
"MODULE_INFO(author, ...) contains embedded NUL byte"
server/server.c:630:1: error: bad integer constant expression
server/server.c:630:1: error: static assertion failed:
"MODULE_INFO(description, ...) contains embedded NUL byte"
server/server.c:631:1: error: bad integer constant expression
server/server.c:631:1: error: static assertion failed:
"MODULE_INFO(license, ...) contains embedded NUL byte"
server/server.c:632:1: error: bad integer constant expression
server/server.c:632:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"
server/server.c:633:1: error: bad integer constant expression
server/server.c:633:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"
server/server.c:634:1: error: bad integer constant expression
server/server.c:634:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"
server/server.c:635:1: error: bad integer constant expression
server/server.c:635:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"
server/server.c:636:1: error: bad integer constant expression
server/server.c:636:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"
server/server.c:637:1: error: bad integer constant expression
server/server.c:637:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"
server/server.c:638:1: error: bad integer constant expression
server/server.c:638:1: error: static assertion failed:
"MODULE_INFO(softdep, ...) contains embedded NUL byte"

On Mon, Feb 16, 2026 at 7:02=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> updated ksmbd-for-next with the patches from your
> for-7.0/smbdirect-ko-20260216-v8 branch
>
> Let me know if any testing or review issues.
>
> On Mon, Feb 16, 2026 at 7:49=E2=80=AFAM Stefan Metzmacher <metze@samba.or=
g> wrote:
> >
> > Hi Steve,
> >
> > for-7.0/smbdirect-ko-20260216-v8 at commit:
> > 8a2259252f084fe55411346d58a1160fc69b7d30
> > git fetch https://git.samba.org/metze/linux/wip.git for-7.0/smbdirect-k=
o-20260216-v8
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/he=
ads/for-7.0/smbdirect-ko-20260216-v8
> >
> > fixes 3 problems:
> > compared to for-7.0/smbdirect-ko-20260213-v7:
> >
> > - We use BUILD_BUG_ON(sizeof(*batch) > sizeof(*storage));
> >    instead of BUILD_BUG_ON(sizeof(*batch) < sizeof(*storage));
> >    Closes: https://lore.kernel.org/oe-kbuild-all/202602141417.hsmt2AAb-=
lkp@intel.com/
> > - We now use [SMBDIRECT_DEBUG_]ERR_PTR(ret) with %1pe
> >    instead of errname(ret) with %s
> >    Closes: https://lore.kernel.org/oe-kbuild-all/202602141435.Sm9ZppiO-=
lkp@intel.com/
> > - We use 'select SG_POOL' for the client as long
> >    as smbdirect_all_c_files.c is used
> >    Closes: https://lore.kernel.org/linux-cifs/20260216105404.2381695-1-=
arnd@kernel.org/
> >
> > The overall diff to the current ksmbd-for-next
> > (at commit 2a43d1cf4bd3bc0cff03f0926e83895a7462ad05) is pasted below:
> >
> > Please replace ksmbd-for-next with commit
> > 8a2259252f084fe55411346d58a1160fc69b7d30,
> >
> > Thanks!
> > metze
> >
> >   fs/smb/client/smbdirect.c                      |  5 ++---
> >   fs/smb/common/smbdirect/smbdirect_connection.c | 26 +++++++++++++----=
---------
> >   fs/smb/common/smbdirect/smbdirect_devices.c    |  3 ++-
> >   fs/smb/common/smbdirect/smbdirect_internal.h   |  1 -
> >   fs/smb/common/smbdirect/smbdirect_main.c       |  3 ++-
> >   fs/smb/common/smbdirect/smbdirect_mr.c         | 21 +++++++++++------=
----
> >   fs/smb/common/smbdirect/smbdirect_socket.c     |  3 ++-
> >   fs/smb/server/transport_rdma.c                 | 25 ++++++++++++-----=
--------
> >   8 files changed, 44 insertions(+), 43 deletions(-)
> >
> > diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> > index de3b51fa2d62..ff80072dc9ff 100644
> > --- a/fs/smb/client/smbdirect.c
> > +++ b/fs/smb/client/smbdirect.c
> > @@ -5,7 +5,6 @@
> >    *   Author(s): Long Li <longli@microsoft.com>
> >    */
> >
> > -#include <linux/errname.h>
> >   #include "smbdirect.h"
> >   #include "cifs_debug.h"
> >   #include "cifsproto.h"
> > @@ -325,8 +324,8 @@ static struct smbd_connection *_smbd_get_connection=
(
> >
> >         ret =3D smbdirect_connect_sync(sc, dstaddr);
> >         if (ret) {
> > -               log_rdma_event(ERR, "connect to %pISpsfc failed: %s\n",
> > -                              dstaddr, errname(ret));
> > +               log_rdma_event(ERR, "connect to %pISpsfc failed: %1pe\n=
",
> > +                              dstaddr, ERR_PTR(ret));
> >                 goto connect_failed;
> >         }
> >
> > diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/co=
mmon/smbdirect/smbdirect_connection.c
> > index 813ddd87c6ae..1e946f78e935 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_connection.c
> > +++ b/fs/smb/common/smbdirect/smbdirect_connection.c
> > @@ -968,7 +968,7 @@ smbdirect_init_send_batch_storage(struct smbdirect_=
send_batch_storage *storage,
> >         struct smbdirect_send_batch *batch =3D (struct smbdirect_send_b=
atch *)storage;
> >
> >         memset(storage, 0, sizeof(*storage));
> > -       BUILD_BUG_ON(sizeof(*batch) < sizeof(*storage));
> > +       BUILD_BUG_ON(sizeof(*batch) > sizeof(*storage));
> >
> >         smbdirect_connection_send_batch_init(batch,
> >                                              need_invalidate_rkey,
> > @@ -1111,10 +1111,10 @@ int smbdirect_connection_send_single_iter(struc=
t smbdirect_socket *sc,
> >
> >         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> >                 smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
> > -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> > +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
> >                         smbdirect_socket_status_string(sc->status),
> >                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> > -                       errname(-ENOTCONN));
> > +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
> >                 return -ENOTCONN;
> >         }
> >
> > @@ -1273,10 +1273,10 @@ int smbdirect_connection_send_wait_zero_pending=
(struct smbdirect_socket *sc)
> >                    sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
> >         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> >                 smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
> > -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> > +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
> >                         smbdirect_socket_status_string(sc->status),
> >                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> > -                       errname(-ENOTCONN));
> > +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
> >                 return -ENOTCONN;
> >         }
> >
> > @@ -1305,10 +1305,10 @@ int smbdirect_connection_send_iter(struct smbdi=
rect_socket *sc,
> >
> >         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> >                 smbdirect_log_write(sc, SMBDIRECT_LOG_INFO,
> > -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> > +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
> >                         smbdirect_socket_status_string(sc->status),
> >                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> > -                       errname(-ENOTCONN));
> > +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
> >                 return -ENOTCONN;
> >         }
> >
> > @@ -1485,8 +1485,8 @@ int smbdirect_connection_post_recv_io(struct smbd=
irect_recv_io *msg)
> >         ret =3D ib_post_recv(sc->ib.qp, &recv_wr, NULL);
> >         if (ret) {
> >                 smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
> > -                       "ib_post_recv failed ret=3D%d (%s)\n",
> > -                       ret, errname(ret));
> > +                       "ib_post_recv failed ret=3D%d (%1pe)\n",
> > +                       ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >                 ib_dma_unmap_single(sc->ib.dev,
> >                                     msg->sge.addr,
> >                                     msg->sge.length,
> > @@ -1716,8 +1716,8 @@ int smbdirect_connection_recv_io_refill(struct sm=
bdirect_socket *sc)
> >                 ret =3D smbdirect_connection_post_recv_io(recv_io);
> >                 if (ret) {
> >                         smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
> > -                               "smbdirect_connection_post_recv_io fail=
ed rc=3D%d (%s)\n",
> > -                               ret, errname(ret));
> > +                               "smbdirect_connection_post_recv_io fail=
ed rc=3D%d (%1pe)\n",
> > +                               ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >                         smbdirect_connection_put_recv_io(recv_io);
> >                         return ret;
> >                 }
> > @@ -1802,10 +1802,10 @@ int smbdirect_connection_recvmsg(struct smbdire=
ct_socket *sc,
> >   again:
> >         if (sc->status !=3D SMBDIRECT_SOCKET_CONNECTED) {
> >                 smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
> > -                       "status=3D%s first_error=3D%1pe =3D> %s\n",
> > +                       "status=3D%s first_error=3D%1pe =3D> %1pe\n",
> >                         smbdirect_socket_status_string(sc->status),
> >                         SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
> > -                       errname(-ENOTCONN));
> > +                       SMBDIRECT_DEBUG_ERR_PTR(-ENOTCONN));
> >                 return -ENOTCONN;
> >         }
> >
> > diff --git a/fs/smb/common/smbdirect/smbdirect_devices.c b/fs/smb/commo=
n/smbdirect/smbdirect_devices.c
> > index d1a251141145..3ace41af2200 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_devices.c
> > +++ b/fs/smb/common/smbdirect/smbdirect_devices.c
> > @@ -249,7 +249,8 @@ __init int smbdirect_devices_init(void)
> >
> >         ret =3D ib_register_client(&smbdirect_ib_client);
> >         if (ret) {
> > -               pr_err("failed to ib_register_client: %d %s\n", ret, er=
rname(ret));
> > +               pr_crit("failed to ib_register_client: %d %1pe\n",
> > +                       ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >                 return ret;
> >         }
> >
> > diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/comm=
on/smbdirect/smbdirect_internal.h
> > index 09a4ce8ed863..30a1b8643657 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_internal.h
> > +++ b/fs/smb/common/smbdirect/smbdirect_internal.h
> > @@ -8,7 +8,6 @@
> >
> >   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > -#include <linux/errname.h>
> >   #include "smbdirect.h"
> >   #include "smbdirect_pdu.h"
> >   #include "smbdirect_public.h"
> > diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/common/s=
mbdirect/smbdirect_main.c
> > index 266d00da25f6..fe6e8d93c34c 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_main.c
> > +++ b/fs/smb/common/smbdirect/smbdirect_main.c
> > @@ -91,7 +91,8 @@ static __init int smbdirect_module_init(void)
> >         destroy_workqueue(smbdirect_globals.workqueues.accept);
> >   alloc_accept_wq_failed:
> >         mutex_unlock(&smbdirect_globals.mutex);
> > -       pr_crit("failed to loaded: %d (%s)\n", ret, errname(ret));
> > +       pr_crit("failed to loaded: %d (%1pe)\n",
> > +               ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >         return ret;
> >   }
> >
> > diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smb=
direct/smbdirect_mr.c
> > index 5e9420d01fe3..32668c58efb0 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_mr.c
> > +++ b/fs/smb/common/smbdirect/smbdirect_mr.c
> > @@ -43,8 +43,9 @@ int smbdirect_connection_create_mr_list(struct smbdir=
ect_socket *sc)
> >                 if (IS_ERR(mr->mr)) {
> >                         ret =3D PTR_ERR(mr->mr);
> >                         smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> > -                               "ib_alloc_mr failed ret=3D%d (%s) type=
=3D0x%x max_frmr_depth=3D%u\n",
> > -                               ret, errname(ret), sc->mr_io.type, sp->=
max_frmr_depth);
> > +                               "ib_alloc_mr failed ret=3D%d (%1pe) typ=
e=3D0x%x max_frmr_depth=3D%u\n",
> > +                               ret, SMBDIRECT_DEBUG_ERR_PTR(ret),
> > +                               sc->mr_io.type, sp->max_frmr_depth);
> >                         goto ib_alloc_mr_failed;
> >                 }
> >                 mr->sgt.sgl =3D kcalloc(sp->max_frmr_depth,
> > @@ -173,8 +174,8 @@ smbdirect_connection_get_mr_io(struct smbdirect_soc=
ket *sc)
> >                                        sc->status !=3D SMBDIRECT_SOCKET=
_CONNECTED);
> >         if (ret) {
> >                 smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> > -                       "wait_event_interruptible ret=3D%d (%s)\n",
> > -                       ret, errname(ret));
> > +                       "wait_event_interruptible ret=3D%d (%1pe)\n",
> > +                       ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >                 return NULL;
> >         }
> >
> > @@ -304,8 +305,8 @@ smbdirect_connection_register_mr_io(struct smbdirec=
t_socket *sc,
> >         ret =3D ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, m=
r->dir);
> >         if (!ret) {
> >                 smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> > -                       "ib_dma_map_sg num_pages=3D%u dir=3D%x ret=3D%d=
 (%s)\n",
> > -                       num_pages, mr->dir, ret, errname(ret));
> > +                       "ib_dma_map_sg num_pages=3D%u dir=3D%x ret=3D%d=
 (%1pe)\n",
> > +                       num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PT=
R(ret));
> >                 goto dma_map_error;
> >         }
> >
> > @@ -348,8 +349,8 @@ smbdirect_connection_register_mr_io(struct smbdirec=
t_socket *sc,
> >         }
> >
> >         smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> > -               "ib_post_send failed ret=3D%d (%s) reg_wr->key=3D0x%x\n=
",
> > -               ret, errname(ret), reg_wr->key);
> > +               "ib_post_send failed ret=3D%d (%1pe) reg_wr->key=3D0x%x=
\n",
> > +               ret, SMBDIRECT_DEBUG_ERR_PTR(ret), reg_wr->key);
> >
> >   map_mr_error:
> >         ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir=
);
> > @@ -435,8 +436,8 @@ void smbdirect_connection_deregister_mr_io(struct s=
mbdirect_mr_io *mr)
> >                 ret =3D ib_post_send(sc->ib.qp, wr, NULL);
> >                 if (ret) {
> >                         smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> > -                               "ib_post_send failed ret=3D%d (%s)\n",
> > -                               ret, errname(ret));
> > +                               "ib_post_send failed ret=3D%d (%1pe)\n"=
,
> > +                               ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >                         smbdirect_mr_io_disable_locked(mr);
> >                         smbdirect_socket_schedule_cleanup(sc, ret);
> >                         goto done;
> > diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common=
/smbdirect/smbdirect_socket.c
> > index 073df565f347..74e31b35a2f6 100644
> > --- a/fs/smb/common/smbdirect/smbdirect_socket.c
> > +++ b/fs/smb/common/smbdirect/smbdirect_socket.c
> > @@ -71,7 +71,8 @@ int smbdirect_socket_init_new(struct net *net, struct=
 smbdirect_socket *sc)
> >         ret =3D rdma_set_afonly(id, 1);
> >         if (ret) {
> >                 rdma_destroy_id(id);
> > -               pr_err("%s: rdma_set_afonly() failed %1pe\n", __func__,=
 errname(ret));
> > +               pr_err("%s: rdma_set_afonly() failed %1pe\n",
> > +                      __func__, SMBDIRECT_DEBUG_ERR_PTR(ret));
> >                 return ret;
> >         }
> >
> > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_r=
dma.c
> > index 5a577a9b0bf8..706a2c897948 100644
> > --- a/fs/smb/server/transport_rdma.c
> > +++ b/fs/smb/server/transport_rdma.c
> > @@ -12,7 +12,6 @@
> >   #include <linux/kthread.h>
> >   #include <linux/list.h>
> >   #include <linux/string_choices.h>
> > -#include <linux/errname.h>
> >
> >   #include "glob.h"
> >   #include "connection.h"
> > @@ -413,8 +412,8 @@ static int smb_direct_listen(struct smb_direct_list=
ener *listener,
> >
> >         ret =3D smbdirect_socket_create_kern(net, &sc);
> >         if (ret) {
> > -               pr_err("smbdirect_socket_create_kern() failed: %d %s\n"=
,
> > -                      ret, errname(ret));
> > +               pr_err("smbdirect_socket_create_kern() failed: %d %1pe\=
n",
> > +                      ret, ERR_PTR(ret));
> >                 return ret;
> >         }
> >
> > @@ -440,28 +439,28 @@ static int smb_direct_listen(struct smb_direct_li=
stener *listener,
> >                                      smb_direct_logging_vaprintf);
> >         ret =3D smbdirect_socket_set_initial_parameters(sc, sp);
> >         if (ret) {
> > -               pr_err("Failed smbdirect_socket_set_initial_parameters(=
): %d %s\n",
> > -                      ret, errname(ret));
> > +               pr_err("Failed smbdirect_socket_set_initial_parameters(=
): %d %1pe\n",
> > +                      ret, ERR_PTR(ret));
> >                 goto err;
> >         }
> >         ret =3D smbdirect_socket_set_kernel_settings(sc, IB_POLL_WORKQU=
EUE, KSMBD_DEFAULT_GFP);
> >         if (ret) {
> > -               pr_err("Failed smbdirect_socket_set_kernel_settings(): =
%d %s\n",
> > -                      ret, errname(ret));
> > +               pr_err("Failed smbdirect_socket_set_kernel_settings(): =
%d %1pe\n",
> > +                      ret, ERR_PTR(ret));
> >                 goto err;
> >         }
> >
> >         ret =3D smbdirect_socket_bind(sc, (struct sockaddr *)&sin);
> >         if (ret) {
> > -               pr_err("smbdirect_socket_bind() failed: %d %s\n",
> > -                      ret, errname(ret));
> > +               pr_err("smbdirect_socket_bind() failed: %d %1pe\n",
> > +                      ret, ERR_PTR(ret));
> >                 goto err;
> >         }
> >
> >         ret =3D smbdirect_socket_listen(sc, 10);
> >         if (ret) {
> > -               pr_err("Port[%d] smbdirect_socket_listen() failed: %d %=
s\n",
> > -                      port, ret, errname(ret));
> > +               pr_err("Port[%d] smbdirect_socket_listen() failed: %d %=
1pe\n",
> > +                      port, ret, ERR_PTR(ret));
> >                 goto err;
> >         }
> >
> > @@ -473,8 +472,8 @@ static int smb_direct_listen(struct smb_direct_list=
ener *listener,
> >                               "ksmbd-smbdirect-listener-%u", port);
> >         if (IS_ERR(kthread)) {
> >                 ret =3D PTR_ERR(kthread);
> > -               pr_err("Can't start ksmbd listen kthread: %d %s\n",
> > -                      ret, errname(ret));
> > +               pr_err("Can't start ksmbd listen kthread: %d %1pe\n",
> > +                      ret, ERR_PTR(ret));
> >                 goto err;
> >         }
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
