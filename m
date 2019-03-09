Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A821FC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D3FE20684
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRv3s414"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfCIAyd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:54:33 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35004 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfCIAyd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:54:33 -0500
Received: by mail-lj1-f194.google.com with SMTP id t13so18947633lji.2
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=16ud4jMmhJenO+6hP1I4CMHHfUpfgvmLo4x2gXgtJaI=;
        b=QRv3s4147aW9t+08x+o7ptKzw7MMnlEmE8D/gk+kzt29K6EoCbFSmSUtsHEVy6SWiO
         lh18A0MXfVo1k9uAH8GHK3rMQhqXQvEkXO47TlNrsPbo5JjqGFKAeaFdF09PzxTv0tZj
         bG5XBI1WZfVrOLbjcTPcyRQE5Eg9PvI2yrWq8EJuxI0EmOuvdBCCcellO4/rdhTMGvNk
         HKH/A+78YHO1Sa40PnA0MoVZbE6GcOIGHIqeyNt0W/kIM6avZs8YHK6JyAchp+n/bknA
         1THn+RmjzNJ9wEeE0kyjr8xVGsYM2cOue3iizW2tG8ekUDCQcRhVU2qtDm06T5IyTuTA
         zHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=16ud4jMmhJenO+6hP1I4CMHHfUpfgvmLo4x2gXgtJaI=;
        b=eX7pjZdUDRdV1jlLQ8g28n40+e2Y2g5nbOq25Mxz6UIBkwhXd2nT0uaqrT6be/veAm
         IVe3Tx2+NK5iXVGoDx1hWLcQJKPyzqCRIjcNJS6w2kdn3cXtvSQcwHJj/Bk0LhLNwUus
         Ojba3yvkhlQtO8tKEukxjO7kuJdIQo2ifpPoOAAMa9FryKCU8/FT1ezKI3OjUhl+WXQu
         6keyul7xIq8yHPO6oV/D42sX2FQNrSd8i3fqCw7oQpa8CeK+KSGZp7sw6o9c5mQHUwLW
         NmE1YPUbyc9cZCKFp9/gmqcZhMN9O+pPuo9AvO3DNOFxE158Z/p/mzAGg9K/7WNnwieU
         jTlA==
X-Gm-Message-State: APjAAAVrqExglVceqRRtXNbOExDj8h4g3X1fhBwLOPwK91JnrZ0OXLtO
        YL2jVeyO8w8oQj+GeVCtu+QgXXuALkly50Dz0Q==
X-Google-Smtp-Source: APXvYqyyRXu4Zqv50Ci/hLQGdK8St4J6z2hem3if4cExMVvUMQ58U4oZl7EUOQ+73hxFahyMvA0SsKmRWHwj4jk6uBs=
X-Received: by 2002:a2e:3807:: with SMTP id f7mr10603588lja.9.1552092871150;
 Fri, 08 Mar 2019 16:54:31 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-3-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-3-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:54:20 -0800
Message-ID: <CAKywueSf5k2BNKi_HbMpj8-a_Eg=T4Zwc_7HUujsKNc=mYdsxA@mail.gmail.com>
Subject: Re: [PATCH 2/6] cifs: pass flags down into wait_for_free_credits()
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
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 5c4becefde4b..8887db2cd582 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -477,15 +477,24 @@ smb_send(struct TCP_Server_Info *server, struct smb=
_hdr *smb_buffer,
>  }
>
>  static int
> -wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
> -                     int *credits, unsigned int *instance)
> +wait_for_free_credits(struct TCP_Server_Info *server, const int flags,
> +                     unsigned int *instance)
>  {
>         int rc;
> +       int *credits;
> +       int optype;
> +
> +       optype =3D flags & CIFS_OP_MASK;
>
>         *instance =3D 0;
>
> +       credits =3D server->ops->get_credits_field(server, optype);
> +       /* Since an echo is already inflight, no need to wait to send ano=
ther */
> +       if (*credits <=3D 0 && optype =3D=3D CIFS_ECHO_OP)
> +               return -EAGAIN;
> +
>         spin_lock(&server->req_lock);
> -       if (timeout =3D=3D CIFS_ASYNC_OP) {
> +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP) {
>                 /* oplock breaks must not be held up */
>                 server->in_flight++;
>                 *credits -=3D 1;
> @@ -516,7 +525,7 @@ wait_for_free_credits(struct TCP_Server_Info *server,=
 const int timeout,
>                          */
>
>                         /* update # of requests on the wire to server */
> -                       if (timeout !=3D CIFS_BLOCKING_OP) {
> +                       if ((flags & CIFS_TIMEOUT_MASK) !=3D CIFS_BLOCKIN=
G_OP) {
>                                 *credits -=3D 1;
>                                 server->in_flight++;
>                                 *instance =3D server->reconnect_instance;
> @@ -532,18 +541,7 @@ static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int flags,
>                       unsigned int *instance)
>  {
> -       int *val;
> -       int timeout, optype;
> -
> -       timeout =3D flags & CIFS_TIMEOUT_MASK;
> -       optype =3D flags & CIFS_OP_MASK;
> -
> -       val =3D server->ops->get_credits_field(server, optype);
> -       /* Since an echo is already inflight, no need to wait to send ano=
ther */
> -       if (*val <=3D 0 && optype =3D=3D CIFS_ECHO_OP)
> -               return -EAGAIN;
> -
> -       return wait_for_free_credits(server, timeout, val, instance);
> +       return wait_for_free_credits(server, flags, instance);
>  }
>
>  int
> --
> 2.13.6
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky
