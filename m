Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1598E14A8B
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 03:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760324725; cv=none; b=GRJVTI0fcL09GlD1KEMcIUDJ/k6KUR0qoVXaYOKUeEISVVm8IhJbRYKcWjP4vXf0rBap9o1bThjcIEuXTASKGkKqqoJZMjBLci0FZBRz2ryjGE8reE8V/T9FSf+AvQ2mgLdtxwtDbBN7opCBd27KL+NrQQhz3a/rnEGTwk5AtIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760324725; c=relaxed/simple;
	bh=LB823DSu0I/dpeUVPCiKCr1mPvlI7JQrBF2t23MNi0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0OMoyKddUm46LeCjK0ubD0Q+mbCRF/mHGhnLT/yshyVi1mi+6ToKyGMFWp7HFzF/yRv0ntQjNwoj11y5HOPb22uZOLeO2FYLiDmJYmbtgdKdAacaF1SSoglGVpiP+jHG7JmHWtwKpjJmHPIHL9M/rlMvZuPRYShgBOhRydGsl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEw8rgCl; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEw8rgCl"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-78f15d5846dso61339286d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 20:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760324723; x=1760929523; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHAqGhh/ixHW+v9mccbsdYXuyyKdgiAAP3DIPnvHpvs=;
        b=nEw8rgClFZk6KBL1V3CJyUb3ImJGtm5RGawS+EJAPSYD531zrvSoKN1G2V9CkswBkW
         MP2Czyf1pAt5V4p6YwpgvOwIA+5cT0p3dAXTfrRgM0ruJtS9TTMec+vqFERuGSHdZQuu
         a88ZPU1M9zlcU0yz3zA2TtTeHLxT2gqbp2wqP+mAJviI9osQB4Qv13UDI9rgVlM8h+HP
         xvch/fItQtMV44fzpxO5RWiwX35caUfrGysh5KWEGC6aedT/JO3wUk6NpfiEBw2v3c8z
         TIVgf1u7lFXIur9SmXh4QhNRveJA9byA6hwpEZ/wzuwNYrDhOQ18BCXpuLHknlDz5sPk
         +UJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760324723; x=1760929523;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qHAqGhh/ixHW+v9mccbsdYXuyyKdgiAAP3DIPnvHpvs=;
        b=mgwf+l2jg7zXOsKs3vAL03jJ0h/bSL25tARBr3UaIHkvku/Qo6RdYZ16t4GBciJlS/
         XDFMHA2cJhPk2WoVgs8gwf+fcByj+OYbFBmmjP6paF70VaZYjXPgxhuMpdp1ybZDYy5M
         8tGdj28db/M1EiND1dUK1aWnVDGy4C7qigL4OkoeMx4XA4Bl28c81I8LiuP1wMLg6MPY
         uDLBZvrOArRzPuWKmLZz1lT3X0XHKcFR6m7aj73obJRAx5i5LMMqUndQeyPknlPZLueh
         RO1o63zkM1I+mN0i0sMi37FpEISo34T/WzEjXsAAYw/dIYrgFaplAoK4R6kQDbDZkLNn
         oMEQ==
X-Gm-Message-State: AOJu0YxCj3HEyXrlu0e1c2c4BgESw7f4Ipo2tbvKwQJ2Igu2RZhZT0ck
	C/nddnj2pMGJyqo5LqXteRQRk2VpGLgVdDiK/NLAcwJmHxejYT4WUJqXzZhPzPFq36sbLRHoVkj
	0BROpyKdFLIxuo293s9g33Uiz6ntGlVM=
X-Gm-Gg: ASbGncvN2xT1I0dGK1gzc8YPzZj18BJgHDjzO6Y2zl6LPZpwgDHv/2QSuFyMIw7V67G
	lN7w+QntYpffYHxKIjvO60LoAgeUuXLSHIPNvSSa3I0YDCCtppactB7mK1QYbtNoucQua7EKOEs
	o4Ut6T+ziHF483q31/zhqbQrVjGng1Lz7pg367iLx0emtGSIGr2NnDZYo+pZQIImxlRWlx6qfi/
	KGJ0PrVmaD8Or7Y018Jw9O3AEiAdwNUgrxaPbG55ojhOJh9KOyAgu9DA0g8Ug8q9xwMcT2vSPBp
	KkRYtDwA4RzaTkfEd4hjBpC//2DcueO5ybrBa6eN4qL2SZgGCcpGU40FF6Hu9pIYsQbWiAOoAQT
	UXOEPol0thuCZZVtPR3ZilqLUQ4epv+zKnbWn2tAP
X-Google-Smtp-Source: AGHT+IGDwTSeSw8sMShsBfmLNXRL+l5FjSlGRN765Q6/KfQ0u9Esino45KVYsQZMHmm3/nGdQnVEF8SEli+vXx+F6YM=
X-Received: by 2002:ad4:5c8b:0:b0:782:f478:8ef6 with SMTP id
 6a1803df08f44-87b2ef3fd05mr271912316d6.53.1760324722984; Sun, 12 Oct 2025
 20:05:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760295528.git.metze@samba.org>
In-Reply-To: <cover.1760295528.git.metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 12 Oct 2025 22:05:11 -0500
X-Gm-Features: AS18NWBXSKZ22IKuewh1gVJmA-cWkMqgUW3PAEIT_pZFb0XSxNvkXaBGJYNOaDg
Message-ID: <CAH2r5mt=6mwgy=d6kmB--V0f8GbxWooBH4pD56bDUouMOaDXrQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] improve smbdirect_mr_io lifetime
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending more testing

On Sun, Oct 12, 2025 at 2:10=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> these patches improve and simplify our handling of
> smbdirect_mr_io structures and their lifetime.
>
> smbd_register_mr() returns a pointer to struct smbdirect_mr_io
> and smbd_deregister_mr() gives the pointer back.
>
> But currently the memory itself is managed by the connection
> (struct smbdirect_socket) and smbd_destroy() has a strange
> wait loop in order to wait for smbd_deregister_mr() being
> called. It means code in smbd_destroy() is aware of
> the server mutex in the generic smb client handling above
> the transport layer.
>
> These patches do some cleanups and fixes before changing
> the logic to use a kref and a mutex in order to allow
> smbd_deregister_mr() being called after smbd_destroy()
> as the memory of smbdirect_mr_io will stay in memory
> but will be detached from the connection.
>
> This makes the code independent of cifs_server_[un]lock()
> and will allow us to move more smbdirect code into common
> functions (shared between client and server).
>
> I think these should go into 6.18.
>
> Stefan Metzmacher (10):
>   smb: smbdirect: introduce smbdirect_mr_io.{kref,mutex} and
>     SMBDIRECT_MR_DISABLED
>   smb: client: change smbd_deregister_mr() to return void
>   smb: client: let destroy_mr_list() call list_del(&mr->list)
>   smb: client: let destroy_mr_list() remove locked from the list
>   smb: client: improve logic in allocate_mr_list()
>   smb: client: improve logic in smbd_register_mr()
>   smb: client: improve logic in smbd_deregister_mr()
>   smb: client: call ib_dma_unmap_sg if mr->sgt.nents is not 0
>   smb: client: let destroy_mr_list() call ib_dereg_mr() before
>     ib_dma_unmap_sg()
>   smb: client: let destroy_mr_list() keep smbdirect_mr_io memory if
>     registered
>
>  fs/smb/client/smbdirect.c                  | 312 ++++++++++++++-------
>  fs/smb/client/smbdirect.h                  |   2 +-
>  fs/smb/common/smbdirect/smbdirect_socket.h |  11 +-
>  3 files changed, 224 insertions(+), 101 deletions(-)
>
> --
> 2.43.0
>


--=20
Thanks,

Steve
