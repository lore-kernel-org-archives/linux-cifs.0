Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF12B23B60C
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 06:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760682890; cv=none; b=s6bag1bhrb/LATmC9+s5I2xPn2ai77Y+eLfXrFdTWBR3mcKjOsCAUWlMAME79mEAWnRwpNB06Yql6qsx6DYHmiiNjsNApbbVmAgDcLEKoQ3MbGr7XLg3varoyp81hDR4rrGHwQkoPpnsifffuGyrSOUJ25Y8IxPRV2UKj5xNmE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760682890; c=relaxed/simple;
	bh=FmGlqOSLdpVuRUXv5uyudVuFaO7usP/3uO0pmnAFxZ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MxNBvWcjKCzaY4Vi9rEW/hDVwv0ADWAWnBOS811+FiT7cZaYeynLHEant/5Z0VxVmqIy/4Vfw/IpzPXcHVvgvX8cvYLC73z5R6FC+7YIGipKmcti5GpJ22+SvF4FvjZzBvc2fYBBkUgC0xRjtEbaE37y/9Fo8mkoUJLvq+O3OOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azGjNORt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azGjNORt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93006C116C6
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 06:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760682890;
	bh=FmGlqOSLdpVuRUXv5uyudVuFaO7usP/3uO0pmnAFxZ4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=azGjNORtbOJ3Lb3HLR/8abeWtD717U+VPij5d5MoI0uk5QU4Y/fduVkiKa4MHZSxM
	 9I9M6aQasVuQsIDGjbYD3LZNOBUFiPuwsa4pfoD1KVHZGUNjQzLTTVsgD3OAvn7zz9
	 BiU4XXmR7ZJ8YffHk1pDEbHhybOqBFFSwKj4LCTDthMEU/MVq/y9Gh2ZNoyZA0Chcr
	 QIvb0Ivq7Gf3o3XBJn4AIg0cV+kh9VFtfTeZ/WSerwBBP0un40qIAZ61UkFUWugXxW
	 oqWsE0fq1WPc+6A7aAiWF99DemdNdRG3n7fjOBFHKT9QlwOZD3L6REHq1xu9EYB65m
	 QMqxQOJoK2c+g==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3ee18913c0so279196066b.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 23:34:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YwXahqZ2MXvK+9ClkvsmTtYueaeyGRF95zXclNGZ7ynsseJQkca
	stKblNJiD8wvoYDi+8//6mRai5hfJMmQFymHy33KZOI2bHZadyC8AdSFcHm+u1ao1ksVYOmeQRt
	5GNyJDE68gRxGbAOiIdFfBaBcQ1tUVag=
X-Google-Smtp-Source: AGHT+IFVGI6hGZgq/IVyXInhEQoNjIcqnkxnI3GeDgTgck17sX6WA7uRoyAP6ROarDn3vO43FC5zSu7dwpVF8BkkNr0=
X-Received: by 2002:a17:907:7f8a:b0:b53:e871:f0fd with SMTP id
 a640c23a62f3a-b6474941574mr299751666b.52.1760682889117; Thu, 16 Oct 2025
 23:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016142109.1278810-1-metze@samba.org>
In-Reply-To: <20251016142109.1278810-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 17 Oct 2025 15:34:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd95632J0h1-Hp339LgTRdNhXTfwpcrS90-QcEGn3UfX-w@mail.gmail.com>
X-Gm-Features: AS18NWDjjq4byjT7CCdURYuuGWjCvQPTqpOmThyGDUpWCU4lu9oq7h65PF3IG9Y
Message-ID: <CAKYAXd95632J0h1-Hp339LgTRdNhXTfwpcrS90-QcEGn3UfX-w@mail.gmail.com>
Subject: Re: [PATCH v4] smb: server: allocate enough space for RW WRs and ib_drain_qp()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 11:21=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Make use of rdma_rw_mr_factor() to calculate the number of rw
> credits and the number of pages per RDMA RW operation.
>
> We get the same numbers for iWarp connections, tested
> with siw.ko and irdma.ko (in iWarp mode).
>
> siw:
>
> CIFS: max_qp_rd_atom=3D128, max_fast_reg_page_list_len =3D 256
> CIFS: max_sgl_rd=3D0, max_sge_rd=3D1
> CIFS: responder_resources=3D32 max_frmr_depth=3D256 mr_io.type=3D0
> CIFS: max_send_wr 384, device reporting max_cqe 3276800 max_qp_wr 32768
> ksmbd: max_fast_reg_page_list_len =3D 256, max_sgl_rd=3D0, max_sge_rd=3D1
> ksmbd: device reporting max_cqe 3276800 max_qp_wr 32768
> ksmbd: Old sc->rw_io.credits: max =3D 9, num_pages =3D 256
> ksmbd: New sc->rw_io.credits: max =3D 9, num_pages =3D 256, maxpages=3D20=
48
> ksmbd: Info: rdma_send_wr 27 + max_send_wr 256 =3D 283
>
> irdma (in iWarp mode):
>
> CIFS: max_qp_rd_atom=3D127, max_fast_reg_page_list_len =3D 262144
> CIFS: max_sgl_rd=3D0, max_sge_rd=3D13
> CIFS: responder_resources=3D32 max_frmr_depth=3D2048 mr_io.type=3D0
> CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: max_fast_reg_page_list_len =3D 262144, max_sgl_rd=3D0, max_sge_rd=
=3D13
> ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: Old sc->rw_io.credits: max =3D 9, num_pages =3D 256
> ksmbd: New sc->rw_io.credits: max =3D 9, num_pages =3D 256, maxpages=3D20=
48
> ksmbd: rdma_send_wr 27 + max_send_wr 256 =3D 283
>
> This means that we get the different correct numbers for ROCE,
> tested with rdma_rxe.ko and irdma.ko (in RoCEv2 mode).
>
> rxe:
>
> CIFS: max_qp_rd_atom=3D128, max_fast_reg_page_list_len =3D 512
> CIFS: max_sgl_rd=3D0, max_sge_rd=3D32
> CIFS: responder_resources=3D32 max_frmr_depth=3D512 mr_io.type=3D0
> CIFS: max_send_wr 384, device reporting max_cqe 32767 max_qp_wr 1048576
> ksmbd: max_fast_reg_page_list_len =3D 512, max_sgl_rd=3D0, max_sge_rd=3D3=
2
> ksmbd: device reporting max_cqe 32767 max_qp_wr 1048576
> ksmbd: Old sc->rw_io.credits: max =3D 9, num_pages =3D 256
> ksmbd: New sc->rw_io.credits: max =3D 65, num_pages =3D 32, maxpages=3D20=
48
> ksmbd: rdma_send_wr 65 + max_send_wr 256 =3D 321
>
> irdma (in RoCEv2 mode):
>
> CIFS: max_qp_rd_atom=3D127, max_fast_reg_page_list_len =3D 262144,
> CIFS: max_sgl_rd=3D0, max_sge_rd=3D13
> CIFS: responder_resources=3D32 max_frmr_depth=3D2048 mr_io.type=3D0
> CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: max_fast_reg_page_list_len =3D 262144, max_sgl_rd=3D0, max_sge_rd=
=3D13
> ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: Old sc->rw_io.credits: max =3D 9, num_pages =3D 256,
> ksmbd: New sc->rw_io.credits: max =3D 159, num_pages =3D 13, maxpages=3D2=
048
> ksmbd: rdma_send_wr 159 + max_send_wr 256 =3D 415
>
> And rely on rdma_rw_init_qp() to setup ib_mr_pool_init() for
> RW MRs. ib_mr_pool_destroy() will be called by rdma_rw_cleanup_mrs().
>
> It seems the code was implemented before the rdma_rw_* layer
> was fully established in the kernel.
>
> While there also add additional space for ib_drain_qp().
>
> This should make sure ib_post_send() will never fail
> because the submission queue is full.
>
> Fixes: ddbdc861e37c ("ksmbd: smbd: introduce read/write credits for RDMA =
read/write")
> Fixes: 4c564f03e23b ("smb: server: make use of common smbdirect_socket")
> Fixes: 177368b99243 ("smb: server: make use of common smbdirect_socket_pa=
rameters")
> Fixes: 95475d8886bd ("smb: server: make use smbdirect_socket.rw_io.credit=
s")
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Have you run checkpatch.pl before submitting the patch ?

WARNING: quoted string split across lines
#337: FILE: fs/smb/server/transport_rdma.c:2046:
+ pr_err("Possible CQE overrun: max_send_wr %d, "
+        "device reporting max_cqe %d max_qp_wr %d\n",

WARNING: quoted string split across lines
#350: FILE: fs/smb/server/transport_rdma.c:2059:
+ pr_err("Possible CQE overrun: rdma_send_wr %d + max_send_wr %d =3D %d, "
+        "device reporting max_cqe %d max_qp_wr %d\n",

WARNING: quoted string split across lines
#362: FILE: fs/smb/server/transport_rdma.c:2071:
+ pr_err("Possible CQE overrun: max_recv_wr %d, "
+        "device reporting max_cpe %d max_qp_wr %d\n",

total: 0 errors, 3 warnings, 305 lines checked
