Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9891C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 01:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB89720830
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 01:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tZYUY8EK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfCBBl2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Mar 2019 20:41:28 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34104 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfCBBl1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Mar 2019 20:41:27 -0500
Received: by mail-lf1-f67.google.com with SMTP id d26so2677365lfa.1
        for <linux-cifs@vger.kernel.org>; Fri, 01 Mar 2019 17:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tBIADDeKBik7mtNjyYRX8K26dsMbIpiLBJWy1g4H5Uo=;
        b=tZYUY8EKlwHS6mpL4JCugpgyHl4TJ5RAUgqKqcOBrsvs2ty4PJlCX6koyiSDw3Kk/d
         vLYHhX3y0OGxosQ9uRg2RQ89FPZ6Oh6TKkaixDec7yZJlyqNxEPwx1MQDEpxPY/4KaJP
         1VifysKW7H9f/8R4FTEu46jZ0+GK6UZRX+C20I1E0YUPA0rzh3qQ2RXcYuXXfm3JGM35
         KBkg46nDuPRYaQKsOuQ3l+XCYyXJOeSlOB4W1KD+45CtGz7Lw08xbSSQHS2IEx4OZmDP
         OkKvltr8ESSsS0ZcrKmxU1CzGcVAv0Y8sUnbs1wn/QerL0cz9guUoiv174Aa1Jb5/euX
         /KGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tBIADDeKBik7mtNjyYRX8K26dsMbIpiLBJWy1g4H5Uo=;
        b=f/nDMeQPO+u+FWRHBSoa5KxrsyHb1nsTv6pO1hA4xi2RiGfXo4xJATIdXVHIlLUSFa
         eospwYFI+27O1isRUAMMSg5y99hfRJyJ0dX9uhVYyraRuyt0dLSK1axJ4T/h3Kshqd1m
         IVd1RhiJB/mwEvTBS21dNxrzU/Oora92gwTp3UNzVjnZgZ6zevLtzy2FkNwJZS7qeC4P
         Jm+BW1uZoCbWNsWZzlb5RZyCSe7EwKNf52qsS1o7+69cIvrxm19TeCK7cGA7IrxsHm6f
         BzBusResMHeR/7sNi+4aeW/XRU9jxsK3seBKoL2Qgq2r3n5MCnYxjsG0BXljPKyRTxSN
         3EZQ==
X-Gm-Message-State: APjAAAUKG4Rf0RwtzLa6CsZxMWoQmmOTwm15ur4Vx7YI2CnBxJAnYEtV
        B0wgX3/x2Qoan2JHLxoCC+Z8mpWC1sjbBBegEQ==
X-Google-Smtp-Source: APXvYqw8ZD/tYHzrg6l6xGVsHd7WIqbKMOkToX8UdvmFDWS8jZbpZz4hBqed9jAbw5VwuB/Lp7H7vQz3KjRTwiCXDZI=
X-Received: by 2002:ac2:5087:: with SMTP id f7mr4824245lfm.42.1551490885743;
 Fri, 01 Mar 2019 17:41:25 -0800 (PST)
MIME-Version: 1.0
References: <20190228062405.32107-1-lsahlber@redhat.com> <20190228062405.32107-5-lsahlber@redhat.com>
In-Reply-To: <20190228062405.32107-5-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 1 Mar 2019 17:41:14 -0800
Message-ID: <CAKywueSuZovHMSN32ANv5+0M-EvTHFDKx7OPssy2soo56OeHRQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] cifs: prevent starvation in wait_for_free_credits for
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

=D1=81=D1=80, 27 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 22:26, Ronni=
e Sahlberg <lsahlber@redhat.com>:
>
> Reserve the last MAX_COMPOUND credits for any request asking for >1 credi=
t.
> This is to prevent future compound requests from becoming starved while w=
aiting
> for potentially many requests is there is a large number of concurrent
> singe-credit requests.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index baf15194aa3d..4ff832fce2e9 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -520,6 +520,29 @@ wait_for_free_credits(struct TCP_Server_Info *server=
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
> +                        */
> +                       if (!optype && num_credits =3D=3D 1 &&

What if server decides to grants us credits gradually? E.g. granted
only 2 during negotiate protocol and session setup. The tree connect
will wait forever here.

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


--
Best regards,
Pavel Shilovsky
