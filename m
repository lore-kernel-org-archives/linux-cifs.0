Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203BCC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E18AC20857
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r6D1PRQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfCIAys (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:54:48 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38830 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfCIAys (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:54:48 -0500
Received: by mail-lj1-f195.google.com with SMTP id 199so18924368ljj.5
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BCBoBzi3+RDJGLB3zwgyihxAUFIcZWwfJCOP5Q6D8e4=;
        b=r6D1PRQPlK+ujhfWrKlhzbUyiu5tlQmJoxz/m5E++mHCx5YdkVjGCikc9K3Oje6cCQ
         hEBdlCDysdtLuCgnKA32EON9VNYvRmUQdYgUn1FnXq50//Fom2u96VQbSsXr4jaLmKXG
         EsVA1MZ84Sgbcmaf+8zxy36CoclHquHsUaVt1x6Ew4wTDQyhHthrVSzCRE95Smkwo+c3
         /p3JURZXcbQa+5QE8Zp9sXrp8v8tG2gYdA2y8zZn1v9RPX3XNb+iPH4mexevbwgNTwwu
         5g9P4WdavzvohnypHJhA/WbfUxcfbecqAHswbQeDiWu2ugz9qZFQ6EvGuFBlQhzA7+1O
         R/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BCBoBzi3+RDJGLB3zwgyihxAUFIcZWwfJCOP5Q6D8e4=;
        b=EH+B0i6CWqYUTeKeQI6kR123F8KdwkiXBhWigkBgmmbv3Qlhl+Gf2xYV27per2NDmZ
         ou8OfiX/J8cBKjmoTutE2rYEfeVgpFlMWboGQUqfMjA1bPAGMj9WugNEbYBKTcgaSwre
         BhACfUoumxlT07dRgqvI8QJeJyN/FMjpF1xdLB8GLvH6f1BGt1aDUa11F3c/jQSN0/Qj
         fzTtzL9wU7ahFACa5f8txpkM1dZ1iem61tqKED/J4U6OtwLMH/oR7/sYRpVB6TTSh6ZO
         Ip1vJxXlg8vuINjJAqGQA/z/IEeJMhkwy4ztzX5VkrjkxWKdiEjhWUt4f26u9PcBpX8v
         iSfg==
X-Gm-Message-State: APjAAAXx3VhBB1L50+WP7DaDs3KvL/2cjVVmpE+eSOozVh0wNAVcNdiT
        htC+EE5RfCorfZptB0LQ7OY6yD0z44zDzldq+g==
X-Google-Smtp-Source: APXvYqxrdWe0Laa3ZTOoXdBrxaRqoNvNlEw8h3AGkvNnvt+FqwJp0qw2JPwH5nS/i5j1evC5WfNvTR9uZ4UNOUlXu84=
X-Received: by 2002:a2e:9ad1:: with SMTP id p17mr10781698ljj.30.1552092885499;
 Fri, 08 Mar 2019 16:54:45 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-4-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-4-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:54:34 -0800
Message-ID: <CAKywueTgMupDPkPkeUXa6281o3mWANeGrzfswyXH8LaAk8W5SQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] cifs: wait_for_free_credits() make it possible to
 wait for >=1 credits
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
> Change wait_for_free_credits() to allow waiting for >=3D1 credits instead=
 of just
> a single credit.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |  4 ++--
>  fs/cifs/smb2ops.c   |  2 +-
>  fs/cifs/transport.c | 14 +++++++-------
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 31c63e7437fd..bc2bb14b2180 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -734,13 +734,13 @@ in_flight(struct TCP_Server_Info *server)
>  }
>
>  static inline bool
> -has_credits(struct TCP_Server_Info *server, int *credits)
> +has_credits(struct TCP_Server_Info *server, int *credits, int num_credit=
s)
>  {
>         int num;
>         spin_lock(&server->req_lock);
>         num =3D *credits;
>         spin_unlock(&server->req_lock);
> -       return num > 0;
> +       return num >=3D num_credits;
>  }
>
>  static inline void
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 1243407c9546..15bc7953b7a6 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -185,7 +185,7 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server,=
 unsigned int size,
>                         spin_unlock(&server->req_lock);
>                         cifs_num_waiters_inc(server);
>                         rc =3D wait_event_killable(server->request_q,
> -                                       has_credits(server, &server->cred=
its));
> +                               has_credits(server, &server->credits, 1))=
;
>                         cifs_num_waiters_dec(server);
>                         if (rc)
>                                 return rc;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 8887db2cd582..baf15194aa3d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -477,8 +477,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_h=
dr *smb_buffer,
>  }
>
>  static int
> -wait_for_free_credits(struct TCP_Server_Info *server, const int flags,
> -                     unsigned int *instance)
> +wait_for_free_credits(struct TCP_Server_Info *server, const int num_cred=
its,
> +                     const int flags, unsigned int *instance)
>  {
>         int rc;
>         int *credits;
> @@ -504,11 +504,11 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int flags,
>         }
>
>         while (1) {
> -               if (*credits <=3D 0) {
> +               if (*credits < num_credits) {
>                         spin_unlock(&server->req_lock);
>                         cifs_num_waiters_inc(server);
>                         rc =3D wait_event_killable(server->request_q,
> -                                                has_credits(server, cred=
its));
> +                               has_credits(server, credits, num_credits)=
);
>                         cifs_num_waiters_dec(server);
>                         if (rc)
>                                 return rc;
> @@ -526,8 +526,8 @@ wait_for_free_credits(struct TCP_Server_Info *server,=
 const int flags,
>
>                         /* update # of requests on the wire to server */
>                         if ((flags & CIFS_TIMEOUT_MASK) !=3D CIFS_BLOCKIN=
G_OP) {
> -                               *credits -=3D 1;
> -                               server->in_flight++;
> +                               *credits -=3D num_credits;
> +                               server->in_flight +=3D num_credits;
>                                 *instance =3D server->reconnect_instance;
>                         }
>                         spin_unlock(&server->req_lock);
> @@ -541,7 +541,7 @@ static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int flags,
>                       unsigned int *instance)
>  {
> -       return wait_for_free_credits(server, flags, instance);
> +       return wait_for_free_credits(server, 1, flags, instance);
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
