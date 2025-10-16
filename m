Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEFF23EA90
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 16:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760630835; cv=none; b=jdALhSB1spEnKeYPKcotvR5083rC2GBOQZALgJlvsNemjmroUkuO8gAZRqFXz0fJoJGquVoIhemrrZN3YknJGZ4BGcCVdRKF+mCbHcyNUNJbFjAQHsRw1w4Orkw6grXhvqsJ5yjMEuHtwlww3XvsRc001vQyd6ZfMv6OpIlpSvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760630835; c=relaxed/simple;
	bh=2kvXyUUxnQiRu4W1jNS7ThbAhDTwGrzkt1l4g/rAQdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FgOZVatuVk55WJk2vAj4kxcMI6unp7QXCVet7TD5IZugz7c6uIU/JheTGpc+s0FvU7pwJZyDwG9eUtjF9OPVtd/O4F1/nCuAp+OHWOox3VdbKwepqYl905ZxKlIwhd05z0fWe7jGHhtz5RY0lPearPLztXwZTyqo4pDUOenM4oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LuwBBhhT; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LuwBBhhT"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-87c1f61ba98so5552806d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760630833; x=1761235633; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mjTbA0sX3YmEDWHnoqrAo3k445C5wGiyk40QLZEC38=;
        b=LuwBBhhTNIPzX3jHlJMXjVltm4qepnPIgbBg2SzapVnPxgnRqFqP6mvPuBAxHkql/j
         XD4UMLuw4kTYilFB7s8B8DGNpZ0IbfCCPJr4kLOG79WjxQN8VKJrABEd8rjj/wdJaM8Y
         wxOIgvU6+7Vv2ljXHSqM3+uMriyoQNuPJADiTXY3rc53+VViutOMBFFNqNF5Jmsuf90v
         Lr3fArKMtW+RynUmAluDO05b4pXjX4r17jjh4LVfX8zZPjoaylOKdP9DegB4FXRFTZEz
         bYt82XerpbvqfU7M9rhf/LoZP8V4eMz3rg9gZub3S40129bFVpkeKDEMrdpB1Kbuhcyt
         oFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760630833; x=1761235633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mjTbA0sX3YmEDWHnoqrAo3k445C5wGiyk40QLZEC38=;
        b=ssaNo2xZwfaqtu3tC2zKDCU5Kq1qE7v8sF+gBejDi/BRcawfiuHo4BJW8pgPPIoOLn
         8X1omOXc20DNbyKlkCN4Cn9nSP6UakwyQBiUCK8kQXTfLlMOusqq2r+BcYJuLdua2UH/
         iK9913DTnaSmpvxmd1I613UFv/R9LjIzgx+8MI/vRIInN+I46YzcXOHrBTl8c+yLSae2
         K3He4i3C97XUQrmx+EDwIKz6LLSajySUX3J47kT5rQWJGLG6khAf0VeQk8KJ7UMC6I3s
         Hw7SHY4heN0pMtIzTJYH3j4pyyFs7JO4+lSAIaTwxuPAE052Cn7IXWTPKuA47V3pienJ
         HOuQ==
X-Gm-Message-State: AOJu0YzXH53+dtWJHOZbwBXd0UgpKh5qpqHsE7suMgg2YoCnA6/0PFDu
	wOIP8OK5rXzC6hNjNs/uw7+AeGcYg5Nc/TKF6RqyFYgNu1ZbBzkcKMRTeebxzGk329Li4ab4wKG
	yOcSd1sdpZL0aKyqHCDUWKlQTmUaxZok=
X-Gm-Gg: ASbGncveX9zbMIBivMFNF0cv9R/e+x/J6JGQcHx1YOgNgQu1EMHuYFPjDzDYJL2qB79
	22badkJy7+yXHFC6cdSEBoFeKLkRZHFykfJsEnCpLdS49/qS6a2AH4eKqORvrNynwI/Vg08+055
	/KQqmTqbVygpJUkSCdis0M0SLKqKloGN42Yq3EcxPSJJsVmSOkZN2bqdqx1JrnIjUjYWWdBBuKB
	hN/OCoSPhayzeyddvKH4gsA845OQ40qk2uTgT9teg+5OR03DKx+h6DPobNbODeoeuB005M9OxEh
	PuoaELyzuV8PA5zlBJ5wweFeIB87+3M1g9cI3Zf7Otl9HpTM3SKSlsVizghz2ehXZYlusNx/UIZ
	dewvpmwjq7ItWJgpEbjqyVdU4B+k9xNTbAa5vaTdDN+TGytRi4s8Ullogd3ozoNl8qpZkn9ENLM
	th3L+DlOickg==
X-Google-Smtp-Source: AGHT+IHfdrmpAAe+6u5rZ2hA9QAmXHRBqtz3vA5wO3r5QxEcAw1oGkWJnPytvAjLtY8qu4apA3Z/rsHBGwVHh782d9s=
X-Received: by 2002:a05:6214:2b81:b0:87c:210f:93e1 with SMTP id
 6a1803df08f44-87c210f9ca0mr3846326d6.42.1760630832537; Thu, 16 Oct 2025
 09:07:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016105421.1234955-1-metze@samba.org>
In-Reply-To: <20251016105421.1234955-1-metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Oct 2025 11:07:00 -0500
X-Gm-Features: AS18NWBDe9btg5tj1B6C2TU9Hk1MChMqixwd6KSOEpAtc-jWyDQqVNC6UHUqfuE
Message-ID: <CAH2r5mu0DAmBeW_Mgs7w2csv3PVS_X2TNcDgMSBS4TDC61G6+A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: allocate enough space for MR WRs and ib_drain_qp()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

applied to cifs-2.6.git for-next pending additional review and testing

On Thu, Oct 16, 2025 at 5:54=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> The IB_WR_REG_MR and IB_WR_LOCAL_INV operations for smbdirect_mr_io
> structures should never fail because the submission or completion queues
> are too small. So we allocate more send_wr depending on the (local) max
> number of MRs.
>
> While there also add additional space for ib_drain_qp().
>
> This should make sure ib_post_send() will never fail
> because the submission queue is full.
>
> Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
> Fixes: cc55f65dd352 ("smb: client: make use of common smbdirect_socket_pa=
rameters")
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/client/smbdirect.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 49e2df3ad1f0..068e1069eca5 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -1767,6 +1767,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>         struct smbdirect_socket *sc;
>         struct smbdirect_socket_parameters *sp;
>         struct rdma_conn_param conn_param;
> +       struct ib_qp_cap qp_cap;
>         struct ib_qp_init_attr qp_attr;
>         struct sockaddr_in *addr_in =3D (struct sockaddr_in *) dstaddr;
>         struct ib_port_immutable port_immutable;
> @@ -1838,6 +1839,25 @@ static struct smbd_connection *_smbd_get_connectio=
n(
>                 goto config_failed;
>         }
>
> +       sp->responder_resources =3D
> +               min_t(u8, sp->responder_resources,
> +                     sc->ib.dev->attrs.max_qp_rd_atom);
> +       log_rdma_mr(INFO, "responder_resources=3D%d\n",
> +               sp->responder_resources);
> +
> +       /*
> +        * We use allocate sp->responder_resources * 2 MRs
> +        * and each MR needs WRs for REG and INV, so
> +        * we use '* 4'.
> +        *
> +        * +1 fot ib_drain_qp()
> +        */
> +       memset(&qp_cap, 0, sizeof(qp_cap));
> +       qp_cap.max_send_wr =3D sp->send_credit_target + sp->responder_res=
ources * 4 + 1;
> +       qp_cap.max_recv_wr =3D sp->recv_credit_max + 1;
> +       qp_cap.max_send_sge =3D SMBDIRECT_SEND_IO_MAX_SGE;
> +       qp_cap.max_recv_sge =3D SMBDIRECT_RECV_IO_MAX_SGE;
> +
>         sc->ib.pd =3D ib_alloc_pd(sc->ib.dev, 0);
>         if (IS_ERR(sc->ib.pd)) {
>                 rc =3D PTR_ERR(sc->ib.pd);
> @@ -1848,7 +1868,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>
>         sc->ib.send_cq =3D
>                 ib_alloc_cq_any(sc->ib.dev, sc,
> -                               sp->send_credit_target, IB_POLL_SOFTIRQ);
> +                               qp_cap.max_send_wr, IB_POLL_SOFTIRQ);
>         if (IS_ERR(sc->ib.send_cq)) {
>                 sc->ib.send_cq =3D NULL;
>                 goto alloc_cq_failed;
> @@ -1856,7 +1876,7 @@ static struct smbd_connection *_smbd_get_connection=
(
>
>         sc->ib.recv_cq =3D
>                 ib_alloc_cq_any(sc->ib.dev, sc,
> -                               sp->recv_credit_max, IB_POLL_SOFTIRQ);
> +                               qp_cap.max_recv_wr, IB_POLL_SOFTIRQ);
>         if (IS_ERR(sc->ib.recv_cq)) {
>                 sc->ib.recv_cq =3D NULL;
>                 goto alloc_cq_failed;
> @@ -1865,11 +1885,7 @@ static struct smbd_connection *_smbd_get_connectio=
n(
>         memset(&qp_attr, 0, sizeof(qp_attr));
>         qp_attr.event_handler =3D smbd_qp_async_error_upcall;
>         qp_attr.qp_context =3D sc;
> -       qp_attr.cap.max_send_wr =3D sp->send_credit_target;
> -       qp_attr.cap.max_recv_wr =3D sp->recv_credit_max;
> -       qp_attr.cap.max_send_sge =3D SMBDIRECT_SEND_IO_MAX_SGE;
> -       qp_attr.cap.max_recv_sge =3D SMBDIRECT_RECV_IO_MAX_SGE;
> -       qp_attr.cap.max_inline_data =3D 0;
> +       qp_attr.cap =3D qp_cap;
>         qp_attr.sq_sig_type =3D IB_SIGNAL_REQ_WR;
>         qp_attr.qp_type =3D IB_QPT_RC;
>         qp_attr.send_cq =3D sc->ib.send_cq;
> @@ -1883,12 +1899,6 @@ static struct smbd_connection *_smbd_get_connectio=
n(
>         }
>         sc->ib.qp =3D sc->rdma.cm_id->qp;
>
> -       sp->responder_resources =3D
> -               min_t(u8, sp->responder_resources,
> -                     sc->ib.dev->attrs.max_qp_rd_atom);
> -       log_rdma_mr(INFO, "responder_resources=3D%d\n",
> -               sp->responder_resources);
> -
>         memset(&conn_param, 0, sizeof(conn_param));
>         conn_param.initiator_depth =3D sp->initiator_depth;
>         conn_param.responder_resources =3D sp->responder_resources;
> --
> 2.43.0
>


--=20
Thanks,

Steve
