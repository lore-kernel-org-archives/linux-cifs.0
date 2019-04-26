Return-Path: <SRS0=UR+C=S4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDEDC43219
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 16:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FA6820693
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 16:38:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M922P+zn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfDZQip (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:38:45 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41785 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfDZQip (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Apr 2019 12:38:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id t30so2821039lfd.8
        for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2019 09:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ErQEnsFkP8x7xCaVKi0lbTo9k5fTFDkg0q7ctBfn9kc=;
        b=M922P+znJ4hhVzaJnsdrduhvE/FGhSkWzdAP+xdt6aP2EbPrMYLAlyBnE0g8JDdMuX
         fyWuZO7iBE1SseA2lGGVYPOj/tRHZkw7qps2SwRYh3d8tzu77GDLLiYtC7Krh99L0uqI
         np7yAA35Xn5BlwSbVToI5QNCRw0rVxmyvmj/FfsNtpmmwGj3MLPPzE92sSTEDr84sG3C
         pEV+3iqwUmTNqdjgg7ZD85xLp1Shx6wKm5UiKG4CFO4f9n5PLnI0Z/eR6EPfNNJ7G6m7
         GjTBjGI9OyvFHTKI4/qiJc5Unt8EJQ/ep7F6HhEkAjfKzAvRRZazU3yJhWR8wRMRGemx
         5t+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ErQEnsFkP8x7xCaVKi0lbTo9k5fTFDkg0q7ctBfn9kc=;
        b=ga+r3ilnrhc7w1H1lchhWBMawcssPjsWs0K0KUN2Q5BKmRgrGHffAE3bJaWXrhUTjp
         aETVHEoM/kVYlD0f+TuHaq7sH+vHeuOqIQJEZQkPRk1Vj8kpVeJQohyl6tcHvmnqgSVa
         2+RFUcI/raVHOBwWXH3PWXgWUvVrHHD6KXn8r4yJYE0cDoa2HRkKag+QPypA0Ye72DV0
         oNRWIbj2eo/cNG6RpL74C5Ms2lwIOfXXObdDpwOXwkyG6QeiHw8xzCmU5ZxCnVr5QvR3
         Y22LEKQkeot0tKjQhYTdi2V7r5Tq6IrJZeO+1o6f9XHesB3pxQE6l8dxxvJd+HWHKzWD
         y5dg==
X-Gm-Message-State: APjAAAUw81WCTSm2D5mhKqMRrS3SXXQ+qCkiNeLmGKRwJPycBElPI4P8
        WfxCuP+xByMTM5MWAtvesJ07SQSevgJbWCLTwA==
X-Google-Smtp-Source: APXvYqxQhTuDkiEb2hc1Py+qaRnhNTTQ86OAOiYxcMNUTevotAfiTk5doTjyjSyN9MCwl3ihmmUWgWy9vgOM9CCuJeg=
X-Received: by 2002:ac2:52b1:: with SMTP id r17mr16858026lfm.39.1556296723666;
 Fri, 26 Apr 2019 09:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190426003223.4763-1-lsahlber@redhat.com> <20190426003223.4763-2-lsahlber@redhat.com>
In-Reply-To: <20190426003223.4763-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 26 Apr 2019 09:38:31 -0700
Message-ID: <CAKywueSHDP06n+5a-z-Q3wB1nRSrceMDLLTYx+EsCtpoS_iTYA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
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

=D1=87=D1=82, 25 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 18:43, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |  1 +
>  fs/cifs/cifssmb.c   |  2 +-
>  fs/cifs/transport.c | 10 +++++-----
>  3 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 621640195713..7a65124f70f9 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1701,6 +1701,7 @@ static inline bool is_retryable_error(int error)
>
>  #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
>  #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sendi=
ng */
> +#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
>
>  /* Security Flags: indicate type of session setup needed */
>  #define   CIFSSEC_MAY_SIGN     0x00001
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f43747c062a7..6050851edcb8 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tco=
n *tcon,
>
>         if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
>                 /* no response expected */
> -               flags =3D CIFS_ASYNC_OP | CIFS_OBREAK_OP;
> +               flags =3D CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_O=
P;
>                 pSMB->Timeout =3D 0;
>         } else if (waitFlag) {
>                 flags =3D CIFS_BLOCKING_OP; /* blocking operation, no tim=
eout */
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 5c59c498f56a..5573e38b13f3 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1073,8 +1073,11 @@ compound_send_recv(const unsigned int xid, struct =
cifs_ses *ses,
>
>         mutex_unlock(&ses->server->srv_mutex);
>
> -       if (rc < 0) {
> -               /* Sending failed for some reason - return credits back *=
/
> +       /*
> +        * If sending failed for some reason or it is an oplock break tha=
t we

probably indicate that it is SMB1 oplock break?

> +        * will not receive a response to - return credits back
> +        */
> +       if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
>                 for (i =3D 0; i < num_rqst; i++)
>                         add_credits(ses->server, &credits[i], optype);

A no-op callback is still needed to be set here or above for
CIFS_NO_SRV_RSP requests. Otherwise we may end up adding credits
twice: here and in the demultiplex thread.

>                 goto out;
> @@ -1095,9 +1098,6 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
>                                            rqst[0].rq_nvec);
>
> -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
> -               goto out;
> -
>         for (i =3D 0; i < num_rqst; i++) {
>                 rc =3D wait_for_response(ses->server, midQ[i]);
>                 if (rc !=3D 0)
> --
> 2.13.6
>


--
Best regards,
Pavel Shilovsky
