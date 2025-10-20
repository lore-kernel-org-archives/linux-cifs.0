Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F423FFD
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 01:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760923120; cv=none; b=fhlUbnZp51YP2jIS6MYXnNpRgGhaCN6uiA5oAyHq5ztb2aoxvp5k2p2BU7m0XdFduUK594VZn5Omft0UqpvsqcQ6kpOCslRGnhzRmPQdI/DEHcFFRr+ui+insTN2pgbZ71x/jce0jFI8VUDX97hDfT+SmQBF9zX3hTZaDrGhXwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760923120; c=relaxed/simple;
	bh=XV6atz4EwtITnFq29ESZy9zjh32cqDrsW6hrdVttNmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F/6wkUQpygBOYd+T7//UfGqf8qxG8yiQ5E493de61+4tYI4V2EO6Y9aqE8eYhwJJnwNzRS04+/Oj/KjJj6x4N9hI9RKT5tpUPM+AfPwKU/WiMnqkn2Wb1lKXkhA+xD1w8y7AkC6qVvHay8N1ENEzKzlMnb3bDAr6sSC5uUAJA5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dDz8E82M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dDz8E82M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1778DC116B1
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 01:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760923120;
	bh=XV6atz4EwtITnFq29ESZy9zjh32cqDrsW6hrdVttNmc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dDz8E82M5ZdAN8+UqRAH3ly6pJBHGavuRXFqq4aa9zq9MKR/3y3gQA5JgRBLrVxGo
	 Fg/rlFMtAqoFRSVBn/kiTFsaW+tM0S1t0sruko054oTgxLXpiIm76G0osRodk3STEc
	 Y3MiwuMmQrtY8J2nDE8nXFUUiZDLgHt+6C+/txMDMTiwEJqIvZaPXojth5BKO5pU8I
	 BtoyTy5lbHTVgYZs1GjJl6C9R4JXccC7AcsgSSt604vGGhNZHjYgCjSULfHcnTmKYS
	 v0DaZ053eUkWmdyzwkhU0KRNAwAprPFZCFWTCh61ajO4Q8ORTP4imBSk1Ez/IfzR8H
	 UBAGqlGVkiG2g==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63c4f1e7243so2258687a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 18:18:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YxqSMvbqZZowhE19f2zXvj68dKjvKtaJL7D5KcZ9eOgyYsdSZTG
	/0zEP4ErU+0EE6iEfhawJSzIQViEO0/io3Ig0Y7fJWTSEx7B8nMeYhU+4O/yhqsWGfNkZrMXnFP
	RzNlMTDWq6PepTZiD2+8mx9+tjVer5qk=
X-Google-Smtp-Source: AGHT+IE14oQqrNgjb6tAHMizeorwjtvCCmzGmbogDqECZTljTXIGFRJ1Vg7eiiyckQ1JZFTfxoObbt9lzLUSfn4r4tg=
X-Received: by 2002:a05:6402:40c5:b0:63c:1e95:dd4c with SMTP id
 4fb4d7f45d1cf-63c1f6cea34mr11370754a12.27.1760923118682; Sun, 19 Oct 2025
 18:18:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017095502.1532414-1-metze@samba.org>
In-Reply-To: <20251017095502.1532414-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Oct 2025 10:18:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-v+LX4jED3taHgB=TkiBckipiHfcOysifgbJBCG3QEVg@mail.gmail.com>
X-Gm-Features: AS18NWDHzk0KiQsmnXt-b4jlkcbxi1i1B2tWYfFtpWdHWaVziSa5ajLJ9kz9S4U
Message-ID: <CAKYAXd-v+LX4jED3taHgB=TkiBckipiHfcOysifgbJBCG3QEVg@mail.gmail.com>
Subject: Re: [PATCH v5] smb: server: allocate enough space for RW WRs and ib_drain_qp()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 6:55=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
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
Applied it to #ksmbd-for-next-next.
Thanks!
