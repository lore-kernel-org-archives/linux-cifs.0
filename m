Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50CAC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B80A20857
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqXamsTu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfCIA4A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:56:00 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36646 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfCIA4A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:56:00 -0500
Received: by mail-lf1-f68.google.com with SMTP id 197so5587142lfz.3
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iC9hT7kKV0nYNWeYsdQ56nLs3vraXNZ9a0xJnj5IfYM=;
        b=UqXamsTuW6RKMHnPlG3rUHUz8jkX5vJpniAtcBFQsEy0tSKibpdu7+fhVidr8MutVr
         5J8Gsmyl1k6wzbwL+UhOYhquLR4GsYh2U+m/9u96V3GBAz1BjWiSBvPGjuOkNIDSrKcC
         sdGYmiCV2kLy3PotwV8srQ3xE22yv/S06zs8RpNwAJhqMPMjxR0aUSmJTQSMBIGniXYd
         Q0CISubBwH1zTfESN4BnihY1E2LKlGULelKQ2VrtzxpHuf4LA30KGyRH7Uf35wKCcvb9
         0rpPYDpIA74kM7yKLs6/2DsADZfuX/m1zBSXl9iwtW/tE3uQ11F8HFpGjJa/1E6c17AN
         gFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iC9hT7kKV0nYNWeYsdQ56nLs3vraXNZ9a0xJnj5IfYM=;
        b=sfMzKp9BlBM3M7y9i0wBkXfrF5mCZ80dPgn+XoIy4p9rbW1DVk/dvO92BATtFli42W
         /V/PhfwsayYCPAufxF6acQv+EqrmsZrHrNDRG5YdRKISniBfNndAthHoO2uYp8FdViAo
         kJHfZObwCVv64E+Mca5487Zf471GdsrAB22p0M4r8jG8OncShNzU9rI5l3qajJG3YwTD
         HKsP55wBOblmVcQMTa0L7CGK3WJRQ87j86802dwc0j6eUTP27EQIRcez4dIVki57pSqs
         9VjvDUUGFolQd+coJ2VPHC0hGp9T4Z1DtphkxE8uwnVJnRRd79V3ZpYl3dLaNcJoR6Bx
         sSKA==
X-Gm-Message-State: APjAAAWrxdW/me+0oUaGCre9MBv/kX8Tn6i7sI/N4AmH4mu/BwXNRMwp
        +58KQN+yLxBvwx7YWNG/SnLfuPiEokuesS3y5Q==
X-Google-Smtp-Source: APXvYqxUwRkphHaLgegXAANQqc5Ml3IXqsSFpCCK6XakJgJNR5K7lUmdmPEiXS0hfK02gmK51FOTDgXpt8nsQMdcH+k=
X-Received: by 2002:ac2:5230:: with SMTP id i16mr11709231lfl.119.1552092958267;
 Fri, 08 Mar 2019 16:55:58 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-5-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-5-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:55:47 -0800
Message-ID: <CAKywueQqMy41cDC_8LmmqZjU+Wj3TsQZgUdyn3VaX1-0M0gA8Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: prevent starvation in wait_for_free_credits for
 multi-credit requests
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
> Reserve the last MAX_COMPOUND credits for any request asking for >1 credi=
t.
> This is to prevent future compound requests from becoming starved while w=
aiting
> for potentially many requests is there is a large number of concurrent
> singe-credit requests.
>
> However, we need to protect from servers that are very slow to hand out
> new credits on new sessions so we only do this IFF there are 2*MAX_COMPOU=
ND
> (arbitrary) credits already in flight.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index baf15194aa3d..f4ec9635dab2 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -520,6 +520,34 @@ wait_for_free_credits(struct TCP_Server_Info *server=
, const int num_credits,
>                         }
>
>                         /*
> +                        * For normal commands, reserve the last MAX_COMP=
OUND
> +                        * credits to compound requests.
> +                        * Otherwise these compounds could be permanently
> +                        * starved for credits by single-credit requests.
> +                        *
> +                        * To prevent spinning CPU, block this thread unt=
il
> +                        * there are >MAX_COMPOUND credits available.
> +                        * But only do this is we already have a lot of
> +                        * credits in flight to avoid triggering this che=
ck
> +                        * for servers that are slow to hand out credits =
on
> +                        * new sessions.
> +                        */
> +                       if (!optype && num_credits =3D=3D 1 &&
> +                           server->in_flight > 2 * MAX_COMPOUND &&
> +                           *credits <=3D MAX_COMPOUND) {
> +                               spin_unlock(&server->req_lock);
> +                               cifs_num_waiters_inc(server);
> +                               rc =3D wait_event_killable(server->reques=
t_q,
> +                                       has_credits(server, credits,
> +                                                   MAX_COMPOUND + 1));
> +                               cifs_num_waiters_dec(server);
> +                               if (rc)
> +                                       return rc;
> +                               spin_lock(&server->req_lock);
> +                               continue;
> +                       }
> +
> +                       /*
>                          * Can not count locking commands against total
>                          * as they are allowed to block on server.
>                          */
> --
> 2.13.6
>

We need to watch how the the approach above work in real workloads but
it looks promising.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
