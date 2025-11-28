Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72B23E32D
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764353126; cv=none; b=LL0tqyhAK0yGW4KFJ1oap2yje8NrweopBgWk6o7KvXERwVB9QuR8S3xOFZVYE7Kx03RJSjX4oBbpHyvjeXDmGfRgaXhsJDFqk8RDjdV/Ddkj0tBw63bBLCjbz69hJcwr1bLfKov8WmlgT8fC0V5wvnn9mQZzduSj1mnS/H8Qg6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764353126; c=relaxed/simple;
	bh=AZGnYXwiFB8xFFsfjVyigYLzTKmi1fyeMEcI7yVADKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iYhyrWCwjnbhHfAlYe8oHlq1t3Pgpm6RW7ER2UPIsLRHblveI5NJuSKyMwHLSspGuiecAk3DHGwJWwqzWtIBXYC+RU5RNX4wxIiXyzKEZY/3tnJ4eMh4sqo7qd0Rc2CJohgzDWty/kc7geTWC0svzCJLyMY6de2vXCmIuEVd2H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aVx+Rvak; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVx+Rvak"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8845498be17so25532266d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 10:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764353123; x=1764957923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iblWJYFLhEPZEekWX9bjkM9Q6W3amI2DaahGKFaHeSo=;
        b=aVx+RvakAKe5O09KYAkqFeDkz0HglF6h7IVoCiBk6cmljAotfClzX+QRmX37EzYGeu
         QQMkdPkUTB3ZW4Un1Qe/ilt0F19CsD0mvVJ849Fz0w6GiVSi8OZQnwM1OCVIX2UQlZ8z
         c+n9Q/TXXnj5bXUmq5TqfPql4RnP4IP6xO0kj73nvBExA5hdkqSDzNKNTJVFruJW0YyZ
         gVnb+Kfq5UFMbpzclhvkXnUnxZyA1hKcfrwEEYpi6bjFCQMP6TbgyWI4OpomRpkFsVX4
         Vi1qja3GsPn8hgPBXjUyQdZj0Pf4+A6jhGnNvWMHU4o4rtgr+hxHoAYjPdHwnHb2Rn02
         MQfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764353123; x=1764957923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iblWJYFLhEPZEekWX9bjkM9Q6W3amI2DaahGKFaHeSo=;
        b=DEjbtJ3pGOiU6o2bxxr/H69md1JOSF/dyGLttJc91vXdiYZ0g8IEVN/D2CyDbDV7Fu
         GPZV1Z0smKYBPxRWVn5EhbH0s2SsHr6wnZPBxjnnQ/a6WhTTGtjimoYbzC5ZvpaQdk8+
         ADTY4F8ID7JNy8zal2Nls1U0VLtCtrVZxhoYvqsKF7MxsjMs7UDk44i1QHfdu2dM8hXg
         qB2VA2A181dg610/fhUIYeqdtZtSfs/EFwvvoV0qCZXX4NubnBS6AuEKCD5v32Z4Iq2k
         kQF/RLz3xhWr5+Q9f+ARaGArUtCGKtQUN2TZ2Na6xTN/XW8cfFzaRdUAUS+mTdkP28cm
         lj9w==
X-Forwarded-Encrypted: i=1; AJvYcCV9Cwd2J7X40rcckXsbcM+KFRmPSVvjHKEqf7Bmt1nZuDA4UuiqZRlAB6+ytmvThfxZ098ZJgwFB8oI@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo2FU+Ygr66G29RI8aDgN6u+Ok/bw4r5DgFVv5m89ODWpaO0rz
	24xBM7nf7R2Nm4aGfnbXhnSnvpfN7L8fSEdpBYr+AztsUwWLapUpmN3Kri/ZKK6inVZeg5k2mAu
	CKN5ssy2cH8b2NUjwwBHb24PNZsWhBZE=
X-Gm-Gg: ASbGnct5GA+YK+5d8fh2+pk8NYl8U5LPNbM05l4wsy2GOSzcsm3o1/lSmvCfdJ5TtVe
	qLxTbh00fhhcIIdsTvUQu91twkBKBbXVG4eh96oPstsk67MTcDzxMXaELRkIHMNC4E0M4b+cZ5H
	/OHb0gnByJRR7oKVEwGWzL6qUeNPnwXCN2HHZjkR6x/TcLxKabh/n1rUbZYE7kGYHmWExitnz0O
	QXYNY7A1dish3DZ9m2nmvTfWclSwZ60YPs5gjPYjJaKZgJWl+AOyMTU87y0LGxGGtUrQkUIutkY
	h1GsmpXKzMOjZHqpaaWEI03yiRpbWRwgDEfWs4EuZ3aCRB7WwUoeYZJej37Ij9uiipEIHrDKfoI
	ob7MzHrEu+HZjSWAXHvS0uBD9UlO6OmcXFM+it4L1ZSa6MQUR2iYi19K9h3I3eDYnOtCTG8zxug
	rKZTvuU5tVHA==
X-Google-Smtp-Source: AGHT+IE1Egk3uc3On6b4xc1ND9PrzzxRokT93SiD1K9Uv0/6fiwr2g2EEThmeYRQQbQDPchakpISv4fwGrnqvfQYWhw=
X-Received: by 2002:a05:6214:1d2a:b0:882:3759:9155 with SMTP id
 6a1803df08f44-8847c498cf0mr450397956d6.21.1764353123376; Fri, 28 Nov 2025
 10:05:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
 <bd2237e6-86e7-40c8-8635-8ba6c0573cbe@samba.org> <CAKYAXd8QhE_=zoK3pLqd0M-8Zw8M0auTw-P5yoqe6DioGXtsaQ@mail.gmail.com>
 <CAH2r5mv0BLnF9+ori1ZfoaYfBLXcscjuFkkAjggSY+aroKDRiw@mail.gmail.com> <b1f6271b-3c2a-493a-a404-7cdacd791acb@samba.org>
In-Reply-To: <b1f6271b-3c2a-493a-a404-7cdacd791acb@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 28 Nov 2025 12:05:12 -0600
X-Gm-Features: AWmQ_bnv0tt_gwaQVQbva_bkjq_YH42RpQb9CN4otFXd_HrZJipFfRJtfKPBZ2w
Message-ID: <CAH2r5msgoZ2aeDfvP-Np=RM-twJ0K6EhQb0xkh=iM=u015KiMg@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

i only see changes in two of the patches (see below) - will update
ksmbd-for-next to include the version from your branch
(for-6.19/fs-smb-20251128-v5).  Does that match what you saw?

smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel/6-11-27-25$ diff
0004-smb-server-relax-WARN_ON_ONCE-SMBDIRECT_SOCKET_-chec.patch
~/metze/wip/197/0039-smb-server-relax-WARN_ON_ONCE-SMBDIRECT_SOCKET_-chec.p=
atch
1c1
< From 225825bffc9602e34e26199f1c635ee59c5de2e4 Mon Sep 17 00:00:00 2001
---
> From 0ee0418c34b31975ffe76d8d6d93ebbe9600c532 Mon Sep 17 00:00:00 2001
3,4c3,4
< Date: Tue, 25 Nov 2025 09:55:56 +0100
< Subject: [PATCH 4/6] smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
---
> Date: Tue, 25 Nov 2025 15:21:53 +0100
> Subject: [PATCH 039/197] smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET=
_*)
168,169c168,169
<  fs/smb/server/transport_rdma.c | 39 +++++++++++++++++++++++++++-------
<  1 file changed, 31 insertions(+), 8 deletions(-)
---
>  fs/smb/server/transport_rdma.c | 40 +++++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 8 deletions(-)
172c172
< index e2be9a496154..2d360fd08f5f 100644
---
> index e2be9a496154..4e7ab8d9314f 100644
175c175,184
< @@ -231,6 +231,9 @@ static void
smb_direct_disconnect_rdma_work(struct work_struct *work)
---
> @@ -19,6 +19,8 @@
>  #include <rdma/rdma_cm.h>
>  #include <rdma/rw.h>
>
> +#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smb_direct_disconnect_rdma_c=
onnection(__sc)
> +
>  #include "glob.h"
>  #include "connection.h"
>  #include "smb_common.h"
> @@ -231,6 +233,9 @@ static void smb_direct_disconnect_rdma_work(struct wo=
rk_struct *work)
185c194
< @@ -241,9 +244,6 @@ static void
smb_direct_disconnect_rdma_work(struct work_struct *work)
---
> @@ -241,9 +246,6 @@ static void smb_direct_disconnect_rdma_work(struct wo=
rk_struct *work)
195,199c204
< @@ -284,9 +284,13 @@ static void
smb_direct_disconnect_rdma_work(struct work_struct *work)
<  smb_direct_disconnect_wake_up_all(sc);
<  }
<
< +#define __SMBDIRECT_SOCKET_DISCONNECT(__sc)
smb_direct_disconnect_rdma_connection(__sc)
---
> @@ -287,6 +289,9 @@ static void smb_direct_disconnect_rdma_work(struct wo=
rk_struct *work)
209c214
< @@ -296,9 +300,6 @@ smb_direct_disconnect_rdma_connection(struct
smbdirect_socket *sc)
---
> @@ -296,9 +301,6 @@ smb_direct_disconnect_rdma_connection(struct smbdirec=
t_socket *sc)
219c224
< @@ -639,7 +640,18 @@ static void recv_done(struct ib_cq *cq, struct ib_wc=
 *wc)
---
> @@ -639,7 +641,18 @@ static void recv_done(struct ib_cq *cq, struct ib_wc=
 *wc)
239c244
< @@ -1725,7 +1737,18 @@ static int smb_direct_cm_handler(struct
rdma_cm_id *cm_id,
---
> @@ -1725,7 +1738,18 @@ static int smb_direct_cm_handler(struct rdma_cm_id=
 *cm_id,
smfrench@smfrench-ThinkPad-P16s-Gen-2:~/smb3-kernel/6-11-27-25$ diff
0005-smb-client-relax-WARN_ON_ONCE-SMBDIRECT_SOCKET_-chec.patch
~/metze/wip/197/0040-smb-client-relax-WARN_ON_ONCE-SMBDIRECT_SOCKET_-chec.p=
atch
1c1
< From 76e8c8c28af17cf66e79beea48278dd5b5ed5d52 Mon Sep 17 00:00:00 2001
---
> From 1e5535ff36f83e8cd664fc6d9d318b482a0ff9d8 Mon Sep 17 00:00:00 2001
3,4c3,4
< Date: Tue, 25 Nov 2025 09:55:57 +0100
< Subject: [PATCH 5/6] smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
---
> Date: Tue, 25 Nov 2025 15:21:54 +0100
> Subject: [PATCH 040/197] smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET=
_*)
46c46
< index c6c428c2e08d..9ee8d1048284 100644
---
> index c6c428c2e08d..788a0670c4a8 100644
49c49,57
< @@ -186,6 +186,9 @@ static void smbd_disconnect_rdma_work(struct
work_struct *work)
---
> @@ -7,6 +7,7 @@
>  #include <linux/module.h>
>  #include <linux/highmem.h>
>  #include <linux/folio_queue.h>
> +#define __SMBDIRECT_SOCKET_DISCONNECT(__sc) smbd_disconnect_rdma_connect=
ion(__sc)
>  #include "../common/smbdirect/smbdirect_pdu.h"
>  #include "smbdirect.h"
>  #include "cifs_debug.h"
> @@ -186,6 +187,9 @@ static void smbd_disconnect_rdma_work(struct work_str=
uct *work)
59c67
< @@ -197,9 +200,6 @@ static void smbd_disconnect_rdma_work(struct
work_struct *work)
---
> @@ -197,9 +201,6 @@ static void smbd_disconnect_rdma_work(struct work_str=
uct *work)
69,71c77
< @@ -240,8 +240,12 @@ static void smbd_disconnect_rdma_work(struct
work_struct *work)
<  smbd_disconnect_wake_up_all(sc);
<  }
---
> @@ -242,6 +243,9 @@ static void smbd_disconnect_rdma_work(struct work_str=
uct *work)
73d78
< +#define __SMBDIRECT_SOCKET_DISCONNECT(__sc)
smbd_disconnect_rdma_connection(__sc)

On Fri, Nov 28, 2025 at 4:17=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 28.11.25 um 05:53 schrieb Steve French:
> > On Thu, Nov 27, 2025 at 9:19=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.=
org> wrote:
> >
> >> On Fri, Nov 28, 2025 at 12:54=E2=80=AFAM Stefan Metzmacher <metze@samb=
a.org>
> >> wrote:
> >>>
> >>> Am 26.11.25 um 02:07 schrieb Namjae Jeon:
> >>>> On Wed, Nov 26, 2025 at 8:50=E2=80=AFAM Namjae Jeon <linkinjeon@kern=
el.org>
> >> wrote:
> >>>>>
> >>>>> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@s=
amba.org>
> >> wrote:
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> here are some small cleanups for a problem Nanjae reported,
> >>>>>> where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> >>>>>> by a Windows 11 client.
> >>>>>>
> >>>>>> The patches should relax the checks if an error happened before,
> >>>>>> they are intended for 6.18 final, as far as I can see the
> >>>>>> problem was introduced during the 6.18 cycle only.
> >>>>>>
> >>>>>> Given that v1 of this patchset produced a very useful WARN_ONCE()
> >>>>>> message, I'd really propose to keep this for 6.18, also for the
> >>>>>> client where the actual problem may not exists, but if they
> >>>>>> exist, it will be useful to have the more useful messages
> >>>>>> in 6.16 final.
> >>>> Anyway, Applied this patch-set to #ksmbd-for-next-next.
> >>>> Please check the below issue.
> >>>
> >>> Steve, can you move this into ksmbd-for-next?
> >> Steve, There are more patches in ksmbd-for-next-next.
> >> Please apply the following 6 patches in #ksmbd-for-next-next to
> >> #ksmbd-for-next.
> >>
> >> 3858665313f1 (HEAD -> ksmbd-for-next-next, origin/ksmbd-for-next-next)
> >> ksmbd: ipc: fix use-after-free in ipc_msg_send_request
> >> b9c7d4fe6e93 smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> >> checks in recv_done() and smbd_conn_upcall()
> >> 6c5ceb636d08 smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
> >> checks in recv_done() and smb_direct_cm_handler()
> >> d02a328304e5 smb: smbdirect: introduce
> >> SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
> >> 340255e842d5 smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helpe=
r
> >> 01cba263d1bd ksmbd: vfs: fix race on m_flags in vfs_cache
>
> It seems these are the v2 patches, please use v3,
> the difference is that the __SMBDIRECT_SOCKET_DISCONNECT
> defines are moved up in order to let the patches on top work
> with out modifications. I noticed the difference while
> doing a rebase on ksmbd-for-next and get conflicts.
>
> Thanks!
> metze
>


--=20
Thanks,

Steve
