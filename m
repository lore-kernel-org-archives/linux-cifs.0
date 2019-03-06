Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35604C43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 17:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF46206DD
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 17:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6zneZHf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfCFRdD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:33:03 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45213 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfCFRdD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Mar 2019 12:33:03 -0500
Received: by mail-lf1-f67.google.com with SMTP id f16so9533499lfk.12
        for <linux-cifs@vger.kernel.org>; Wed, 06 Mar 2019 09:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ib1W+EyW3GnDBTusFKMW85ESOf3gOHJ0j4zdaWz/row=;
        b=V6zneZHfJdPeye8U9BzOeTBXtQQVlX+Om6p9wZ4hlE5qhIdTP4iIwTrp4dXJHAx8kv
         tCEKLDBPsrmYcLsTayOZWGwfgdHQW54fP+F+gzrHQKN4kc5MekqMDEbFS9hW1DQXrYaM
         NfYSczzmA7MDrbtAUv/8uZsuB2ffyODW1uDsC0xNSqYDGZbfIykp2sdLXzJMPiKRyGsE
         43PhVZtPahpIAmkfqZSkqxute1oDoJVfFHnhWynV8AsXCKYpF8vBBYuo8MmmvKRp8Sq7
         k3gaf+g6i3HME7CDWce3DzdVtbZf4+ybNscyvXmo7ziqLctw4FCNtVqVIBUDaKfh3R4H
         OJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ib1W+EyW3GnDBTusFKMW85ESOf3gOHJ0j4zdaWz/row=;
        b=M6VhFns9/StRGJOf6J4ry+1LNYL5/UfXzE4kWHvAUpdVEc6XUv96PHT8xQIQ1vGg4U
         39Ljhy6Wtuz3Ebdur7epyysEI3RFXFx15Ql8r6Z8r905sJg9fPbGO5UC+hdAS4CSjvWW
         tzRhqL+Vdal9wy4EwLDLBnzyLBstmw57oJXDZc7cD19ikpKLG9eYvFxvGt2Y+7CnTosz
         rufjmCkQ7JVDQWLiNHi7hc958ZumVNTapcKY1hEYfJlQlVs6X6xQV6lXc0kbgczUeJ7Z
         IMy+O6wQymrv2UifgRkSEFqZ62fLAOLnsBzoZfJvl6/4Jt1WBZaZvdiGnUB4rEZEpUD2
         n3WA==
X-Gm-Message-State: APjAAAVL/lKUCgrTnyo1oAnt0Lpe9tRZd6uqqzQnPBtIbFmeOX8XZpf0
        9+caEvWabjsJn5UNSA4JMnIBBddnOeM9oVv8yA==
X-Google-Smtp-Source: APXvYqxDgj3VlLu1PoEcxywr8ApPjKZHgKxFExFa7PGAj6jCsW7Yi6mG5N5bH83dkWo9RerBOWNO6iyX3QNYd8sjUYs=
X-Received: by 2002:a19:2d44:: with SMTP id t4mr4412106lft.90.1551893580752;
 Wed, 06 Mar 2019 09:33:00 -0800 (PST)
MIME-Version: 1.0
References: <20190306041546.10419-1-lsahlber@redhat.com> <20190306041546.10419-6-lsahlber@redhat.com>
In-Reply-To: <20190306041546.10419-6-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 6 Mar 2019 09:32:48 -0800
Message-ID: <CAKywueRFjXs160fV2m-jsNPtLnBvqaHWJmJZ+SN5+yhjbtVmtA@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: add a timeout argument to wait_for_free_credits
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

=D0=B2=D1=82, 5 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 21:45, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> A negative timeout is the same as the current behaviour, i.e. no timeout.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index f4ec9635dab2..3263e8b3a57d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -478,11 +478,18 @@ smb_send(struct TCP_Server_Info *server, struct smb=
_hdr *smb_buffer,
>
>  static int
>  wait_for_free_credits(struct TCP_Server_Info *server, const int num_cred=
its,
> -                     const int flags, unsigned int *instance)
> +                     const int timeout, const int flags,
> +                     unsigned int *instance)
>  {
>         int rc;
>         int *credits;
>         int optype;
> +       long int t;
> +
> +       if (timeout < 0)
> +               t =3D MAX_JIFFY_OFFSET;
> +       else
> +               t =3D msecs_to_jiffies(timeout);
>
>         optype =3D flags & CIFS_OP_MASK;
>
> @@ -507,11 +514,16 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int num_credits,
>                 if (*credits < num_credits) {
>                         spin_unlock(&server->req_lock);
>                         cifs_num_waiters_inc(server);
> -                       rc =3D wait_event_killable(server->request_q,
> -                               has_credits(server, credits, num_credits)=
);
> +                       rc =3D wait_event_killable_timeout(server->reques=
t_q,
> +                               has_credits(server, credits, num_credits)=
, t);
>                         cifs_num_waiters_dec(server);
> -                       if (rc)
> -                               return rc;
> +                       if (!rc) {
> +                               cifs_dbg(VFS, "wait timed out after %d ms=
\n",
> +                                        timeout);
> +                               return -EAGAIN;

It would be hard to distinguish different EAGAIN reasons in the upper
layers. As of now we use EAGAIN as retryable error indicating the
upper layer to retry. This case is different because the retry most
likely won't help and the sequential fallback is needed. In
compound_send_recv() we return -ENOTSUPP if there is not enough
credits to satisfy compounding and the number of requests in flight
doesn't promise to get new credits in future.

I suggest to return the same error code here (-ENOTSUPP). Probably
this particular error code isn't ideal choice and suggestions to
change it are welcome.

> +                       }
> +                       if (rc =3D=3D -ERESTARTSYS)
> +                               return -ERESTARTSYS;
>                         spin_lock(&server->req_lock);
>                 } else {
>                         if (server->tcpStatus =3D=3D CifsExiting) {
> @@ -537,12 +549,19 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int num_credits,
>                             *credits <=3D MAX_COMPOUND) {
>                                 spin_unlock(&server->req_lock);
>                                 cifs_num_waiters_inc(server);
> -                               rc =3D wait_event_killable(server->reques=
t_q,
> +                               rc =3D wait_event_killable_timeout(
> +                                       server->request_q,
>                                         has_credits(server, credits,
> -                                                   MAX_COMPOUND + 1));
> +                                                   MAX_COMPOUND + 1),
> +                                       t);
>                                 cifs_num_waiters_dec(server);
> -                               if (rc)
> -                                       return rc;
> +                               if (!rc) {
> +                                       cifs_dbg(VFS, "wait timed out aft=
er %d ms\n",
> +                                                timeout);
> +                                       return -EAGAIN;
> +                               }
> +                               if (rc =3D=3D -ERESTARTSYS)
> +                                       return -ERESTARTSYS;
>                                 spin_lock(&server->req_lock);
>                                 continue;
>                         }
> @@ -569,7 +588,8 @@ static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int flags,
>                       unsigned int *instance)
>  {
> -       return wait_for_free_credits(server, 1, flags, instance);
> +       return wait_for_free_credits(server, 1, -1, flags,
> +                                    instance);
>  }
>
>  int
> --
> 2.13.6
>

--
Best regards,
Pavel Shilovsky
