Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C842C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0630320684
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0mIoUNQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfCIAx4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:53:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39093 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfCIAx4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:53:56 -0500
Received: by mail-lf1-f68.google.com with SMTP id m13so2002251lfb.6
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g746yEpVycWAYJMn7ue2lO1icmOgJaoKc8LPmRpJGZc=;
        b=W0mIoUNQsQfeUFoSWJJG+Sx0EQqmryBJK5yrjhPoAViEtADAc40iki6s+0OrVpPXf+
         qTxu67VDCXQOe6sAozQ2bYqRvBtZK7vRuiMTEJFfkJGJCQtBi7YltwYHaNQ5kRkj6B1d
         jQetqwM388my0qkArEQEXbqYn5avALj1OihLpdcqNC88feeRNNE9cpTcH3ZlE2NiiWIL
         qz8uYWLLMyMXrhUt6yun6/vSxBoSmuXpMWem3i1HBu/gk3Yh0+8VnNIIwFUntDKfJnfm
         ubKlOkYnmg7/s1wFJCi/LbHUCfm9dBRZCbs7lPKBklFTxgZOJPB7h2FDKX3rj6BpUk5R
         tyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g746yEpVycWAYJMn7ue2lO1icmOgJaoKc8LPmRpJGZc=;
        b=QX9oqlU1MoVWb3n7WDXLrXcwF3J2qSjq76yRr/PgbkrH7l1eOe1e9tPlQGh6vNBgsa
         k00zTyb/quhO/lXcf5gsc8w6eivKdFMXiyTaDTkC/KYcD1VLHnfYhq3RVvyCFloDo5wg
         G+SEs05dbFBmtXiAi834Bu6RxaPFI7F1akN/lKMYnibh0yG/aygL9KgHskezrkTsx5B1
         g1nU1J8YD8VvL7iinl9pMd4fGQDgJVeIHaHzYVQou98giRhTq7QhqqfOKiLLAGZDxq8o
         yPMLaHqqRZudqSkVT9Oc2FCt37+8htC4ROQh7e65TQAKYZNNaykBegQ/U1uPTpafmuYU
         70sw==
X-Gm-Message-State: APjAAAXQT3cdl7CqkZMhqs9XuzLE4zaePAfX+nqpdhKxzhodLsG4Mmd0
        d+N0Yl8tnIh0V1dHNpOTm8ulA1WxpKnMqy9nOQ==
X-Google-Smtp-Source: APXvYqz/gZuQa0Hkn29KYqe7VCKBxu2RZA4CqNsxCgjUu94zwrusoGHdGrrD1pAFChnWkNK23BZJLIhUDFIagG6nFHw=
X-Received: by 2002:a19:520e:: with SMTP id m14mr11465524lfb.64.1552092833964;
 Fri, 08 Mar 2019 16:53:53 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-2-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:53:43 -0800
Message-ID: <CAKywueSpgw3GcSNQp4C74-gzjuWDOeJ83R0-rbibY0+0GPZksw@mail.gmail.com>
Subject: Re: [PATCH 1/6] cifs: change wait_for_free_request() to take flags as argument
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 7 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 19:35, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> and compute timeout and optyp from it.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 849a45d7d732..5c4becefde4b 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -529,15 +529,20 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int timeout,
>  }
>
>  static int
> -wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
> -                     const int optype, unsigned int *instance)
> +wait_for_free_request(struct TCP_Server_Info *server, const int flags,
> +                     unsigned int *instance)
>  {
>         int *val;
> +       int timeout, optype;
> +
> +       timeout =3D flags & CIFS_TIMEOUT_MASK;
> +       optype =3D flags & CIFS_OP_MASK;
>
>         val =3D server->ops->get_credits_field(server, optype);
>         /* Since an echo is already inflight, no need to wait to send ano=
ther */
>         if (*val <=3D 0 && optype =3D=3D CIFS_ECHO_OP)
>                 return -EAGAIN;
> +
>         return wait_for_free_credits(server, timeout, val, instance);
>  }
>
> @@ -637,16 +642,16 @@ cifs_call_async(struct TCP_Server_Info *server, str=
uct smb_rqst *rqst,
>                 mid_handle_t *handle, void *cbdata, const int flags,
>                 const struct cifs_credits *exist_credits)
>  {
> -       int rc, timeout, optype;
> +       int rc;
>         struct mid_q_entry *mid;
>         struct cifs_credits credits =3D { .value =3D 0, .instance =3D 0 }=
;
>         unsigned int instance;
> +       int optype;
>
> -       timeout =3D flags & CIFS_TIMEOUT_MASK;
>         optype =3D flags & CIFS_OP_MASK;
>
>         if ((flags & CIFS_HAS_CREDITS) =3D=3D 0) {
> -               rc =3D wait_for_free_request(server, timeout, optype, &in=
stance);
> +               rc =3D wait_for_free_request(server, flags, &instance);
>                 if (rc)
>                         return rc;
>                 credits.value =3D 1;
> @@ -862,8 +867,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>                    const int flags, const int num_rqst, struct smb_rqst *=
rqst,
>                    int *resp_buf_type, struct kvec *resp_iov)
>  {
> -       int i, j, rc =3D 0;
> -       int timeout, optype;
> +       int i, j, optype, rc =3D 0;
>         struct mid_q_entry *midQ[MAX_COMPOUND];
>         bool cancelled_mid[MAX_COMPOUND] =3D {false};
>         struct cifs_credits credits[MAX_COMPOUND] =3D {
> @@ -873,7 +877,6 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>         unsigned int first_instance =3D 0;
>         char *buf;
>
> -       timeout =3D flags & CIFS_TIMEOUT_MASK;
>         optype =3D flags & CIFS_OP_MASK;
>
>         for (i =3D 0; i < num_rqst; i++)
> @@ -924,8 +927,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>          * Ensure we obtain 1 credit per request in the compound chain.
>          */
>         for (i =3D 0; i < num_rqst; i++) {
> -               rc =3D wait_for_free_request(ses->server, timeout, optype=
,
> -                                          &instance);
> +               rc =3D wait_for_free_request(ses->server, flags, &instanc=
e);
>
>                 if (rc =3D=3D 0) {
>                         credits[i].value =3D 1;
> @@ -1048,7 +1050,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
>                                            rqst[0].rq_nvec);
>
> -       if (timeout =3D=3D CIFS_ASYNC_OP)
> +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
>                 goto out;
>
>         for (i =3D 0; i < num_rqst; i++) {
> @@ -1185,7 +1187,7 @@ SendReceive2(const unsigned int xid, struct cifs_se=
s *ses,
>  int
>  SendReceive(const unsigned int xid, struct cifs_ses *ses,
>             struct smb_hdr *in_buf, struct smb_hdr *out_buf,
> -           int *pbytes_returned, const int timeout)
> +           int *pbytes_returned, const int flags)
>  {
>         int rc =3D 0;
>         struct mid_q_entry *midQ;
> @@ -1216,7 +1218,7 @@ SendReceive(const unsigned int xid, struct cifs_ses=
 *ses,
>                 return -EIO;
>         }
>
> -       rc =3D wait_for_free_request(ses->server, timeout, 0, &credits.in=
stance);
> +       rc =3D wait_for_free_request(ses->server, flags, &credits.instanc=
e);
>         if (rc)
>                 return rc;
>
> @@ -1255,7 +1257,7 @@ SendReceive(const unsigned int xid, struct cifs_ses=
 *ses,
>         if (rc < 0)
>                 goto out;
>
> -       if (timeout =3D=3D CIFS_ASYNC_OP)
> +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
>                 goto out;
>
>         rc =3D wait_for_response(ses->server, midQ);
> @@ -1358,8 +1360,7 @@ SendReceiveBlockingLock(const unsigned int xid, str=
uct cifs_tcon *tcon,
>                 return -EIO;
>         }
>
> -       rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 0,
> -                                  &instance);
> +       rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP, &inst=
ance);
>         if (rc)
>                 return rc;
>
> --
> 2.13.6
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky
