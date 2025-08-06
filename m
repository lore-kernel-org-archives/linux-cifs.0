Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DE21C84AE
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501788; cv=none; b=CF9cpUzjUNeMORJHMegeTgKgqA1zcji1rQv6tVdIQJkgD/JnkPFSrJOTsk0MT5yCqWWm+3FkTSf3bLkXSYOXZj6uzPKqQFf1bc44aZvJvjiTn9kJSGlP9gLqfs0UtfjU436nRsk+0g3ugFYLToeSDt05NJ4YdlQ9gdnZvx1EMYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501788; c=relaxed/simple;
	bh=hL/La+d2qcue72KFJcg6Rye5BBifBlcwMOj+/WrnA4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9l2rqfLbTKf3NFwjAAG2JShbDKogfu9yB+xd2bJ4NNExpN77GYoK29Yy6Fz5iat4vQRqCsK3r64QIuQvfgA//nInRuTi4g1iS6NTRPUvCgBYp1YrkYg8jLxW7TBr3Ftly01PRUalb1qYcecYyuvLgGWA19U7Z4NO1f9hbfDaOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FejfswKa; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FejfswKa"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-709233a8609so2238306d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 10:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754501786; x=1755106586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tG4y0K7FYmkF3TagTYhqUQIG9HWksFFKdI76rAJxy/s=;
        b=FejfswKaRHbLCJ67T1AcvTpwNF/FeMbedV3LaLmHHHwDBYyZLarP2i/RzGYH7it46H
         a3gEzBgKbuAW6+NzOJjX2zwbCUKPo9L68Lwsfc1spKy1AS9tOHp9yycCAMFfr0OTkXss
         ZSR399KeTDq6IpU6JY8oQw3vUcphfDsMz8KjQ2JORJydi/aEZqkVFJZHrVQ6cZDlbHZ3
         xapZkNqxhjOmJ7xEITBHpAVlolfbkiOT7UDM5Qg36Qe5lynSZSn7awRio84kC2UjbW/i
         zZVa9KXNOHd2UKChTMrozJF3rA0O7TpzSL0qWa07TW5gR+EshIw6LSzwN81znf2Kc5VP
         mkkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754501786; x=1755106586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tG4y0K7FYmkF3TagTYhqUQIG9HWksFFKdI76rAJxy/s=;
        b=ZtQo41JIVBMsk6/NvlbCwxicPbgCNAS/H8KNg6b6LtWgpjIjGI7ZJhCjtAYWKF418k
         GPjwJ14drh96HIReefPPKVKRBNHozYiZNQdVKiCVLWerRZizgYWNUFA6R9yY1rao/u/r
         kuQEFdjYSvUkERxkoOwGaBlmPsNJzn5nE7vYFQTu+rPzDk+NAw5/zhmUwb2K6aELBEe4
         0Wl43xeKuhc0Y+Pjfw17puBdfNrDwSoooTaj0ZBl2CN34RnW3W7YyQojt+66Uco07zz7
         t4rSV+YAzEEEPs7auWBuC/UtTThIzH2XAP3ssfIvCjFYxRE05WkNoQi10EqFSyuj527+
         9fYw==
X-Forwarded-Encrypted: i=1; AJvYcCX+iYkEPY7n5UCU5swKcEsDmxRwnPf76pgtf3mfPj2j729Q8hPYsy79VVai1tU34PO3M0F7uT+3/u0S@vger.kernel.org
X-Gm-Message-State: AOJu0YzByDg6TJJ4f8R7ughEOFdbGsqHkO1e4srLa2VvROvSxVCymztZ
	voAo5xnPLGScQHQ6IaInq08PfRRMS+IBHNHuIGtSMpmf9jo41NLGTQLKTP4sLTsKEyBek+vgC+j
	7XGeg+3uHrQOQvyr1RJ0J9NGOK0kNyb8=
X-Gm-Gg: ASbGncsSuywfzkSbmRl6Kt5Z/F2D2b4LIVQ+YDaQkrA+G87TkFDgcoZrUbEoFXeBQYJ
	0grDHAriIiS3sLrVzqpkuGtGrlMynPdqNVSSa574+Xgfatli69J+b8yS/p0KKTCv6XIn/y7jXNk
	OIDlXukfwqXolucbihgpaolcGq1EnttvwIhCteIWJ20KjCF+ojJ/mhRU/fzgCjpWaAXRtcLPHS3
	KBSu1IPI3s50u/bAdxRfVYxCFjfKlZB9O0ihIYs
X-Google-Smtp-Source: AGHT+IGzDcfD2qHIG+mo+ege+DagqvA1//azNfvfnb2yuZhTKVYr/uEN5fZ1dpc/wNqlmJwHHc/bqD5u2cmGzM7JurA=
X-Received: by 2002:a05:6214:c48:b0:705:816:6179 with SMTP id
 6a1803df08f44-7097af9e47emr48063806d6.38.1754501785658; Wed, 06 Aug 2025
 10:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754308712.git.metze@samba.org> <0b80cf1a140280ca75ac21d5577a141e433d35f7.1754308712.git.metze@samba.org>
 <a9dc02a1-ab9c-4bc6-8a69-b0794bf258fd@samba.org>
In-Reply-To: <a9dc02a1-ab9c-4bc6-8a69-b0794bf258fd@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 Aug 2025 12:36:14 -0500
X-Gm-Features: Ac12FXz5nBcw2Aidgmewa8OmdQn9_4ZsgrKDmfpHKRql0Q-wm6uVMzLfTrGU90w
Message-ID: <CAH2r5mv_QySzx-PhdXmdYLo_u0ZD__8-sOafyk=UrvSYziiM9Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <stfrench@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Done

On Wed, Aug 6, 2025 at 6:39=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi Steve,
>
> can you please squash this into the commit? Otherwise it introduces
> as new use-after-free problem with request->info.
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 7377216e033d..5d1fa83583f6 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -286,8 +286,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc =
*wc)
>         if (wc->status !=3D IB_WC_SUCCESS || wc->opcode !=3D IB_WC_SEND) =
{
>                 log_rdma_send(ERR, "wc->status=3D%d wc->opcode=3D%d\n",
>                         wc->status, wc->opcode);
> -               mempool_free(request, request->info->request_mempool);
> -               smbd_disconnect_rdma_connection(request->info);
> +               mempool_free(request, info->request_mempool);
> +               smbd_disconnect_rdma_connection(info);
>                 return;
>         }
>
> Thanks!
> metze
>
> Am 04.08.25 um 14:10 schrieb Stefan Metzmacher:
> > We should call ib_dma_unmap_single() and mempool_free() before calling
> > smbd_disconnect_rdma_connection().
> >
> > And smbd_disconnect_rdma_connection() needs to be the last function to
> > call as all other state might already be gone after it returns.
> >
> > Cc: Steve French <smfrench@gmail.com>
> > Cc: Tom Talpey <tom@talpey.com>
> > Cc: Long Li <longli@microsoft.com>
> > Cc: linux-cifs@vger.kernel.org
> > Cc: samba-technical@lists.samba.org
> > Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
> > Signed-off-by: Stefan Metzmacher <metze@samba.org>
> > ---
> >   fs/smb/client/smbdirect.c | 14 ++++++++------
> >   1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> > index 754e94a0e07f..b6c369088479 100644
> > --- a/fs/smb/client/smbdirect.c
> > +++ b/fs/smb/client/smbdirect.c
> > @@ -281,18 +281,20 @@ static void send_done(struct ib_cq *cq, struct ib=
_wc *wc)
> >       log_rdma_send(INFO, "smbd_request 0x%p completed wc->status=3D%d\=
n",
> >               request, wc->status);
> >
> > -     if (wc->status !=3D IB_WC_SUCCESS || wc->opcode !=3D IB_WC_SEND) =
{
> > -             log_rdma_send(ERR, "wc->status=3D%d wc->opcode=3D%d\n",
> > -                     wc->status, wc->opcode);
> > -             smbd_disconnect_rdma_connection(request->info);
> > -     }
> > -
> >       for (i =3D 0; i < request->num_sge; i++)
> >               ib_dma_unmap_single(sc->ib.dev,
> >                       request->sge[i].addr,
> >                       request->sge[i].length,
> >                       DMA_TO_DEVICE);
> >
> > +     if (wc->status !=3D IB_WC_SUCCESS || wc->opcode !=3D IB_WC_SEND) =
{
> > +             log_rdma_send(ERR, "wc->status=3D%d wc->opcode=3D%d\n",
> > +                     wc->status, wc->opcode);
> > +             mempool_free(request, request->info->request_mempool);
> > +             smbd_disconnect_rdma_connection(request->info);
> > +             return;
> > +     }
> > +
> >       if (atomic_dec_and_test(&request->info->send_pending))
> >               wake_up(&request->info->wait_send_pending);
> >
>


--=20
Thanks,

Steve
