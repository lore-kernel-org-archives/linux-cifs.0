Return-Path: <SRS0=EccA=ZH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DACC432C3
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Nov 2019 18:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60E7D2073A
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Nov 2019 18:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTyAc5ic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfKOSHT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Nov 2019 13:07:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36526 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfKOSHT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Nov 2019 13:07:19 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so11642253lja.3
        for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2019 10:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P0a/7pinETVU2y7rcC2a1yzcR8w4kpPt0k2ABAMgF+c=;
        b=UTyAc5icDn4yEM7zQbgF+RwIJEf+58ZA2iFnyi4h/aSjTbRSrSvjeknxRCh0YGJbDd
         4tic1yxg+BMKywO5cEf2Q+Cp5NZmY7Wf+iHO3epaW4I92z37lPZnFf7OBBqA+OCg2KG0
         J02k70yK2aRxm4RR7T4//G6lmlw4EEJYVB+xjVnRfMLjM7oBptsKir2/oXgXI82yyO9r
         5YlLk7CPLEbZATPK87nJtmbQxGdNeJyKs6tmUD8E+Dhu91Nr46BodDc3XiCBs2XcAjge
         8QMDypr2NLuxLsGwCuEQvJcAo15C3RVvnsmt38h6bU0KIQbeGOj3SRMNjKr5pfiFCoO8
         IQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P0a/7pinETVU2y7rcC2a1yzcR8w4kpPt0k2ABAMgF+c=;
        b=pdRn1uFQrxV8MLTxZ3EoZbobMEWlrD+FahgWlfqjQ5RJ+gAj0tEG77w1dVAIn6U15C
         Y/fTiaSiXZ1hNgkkgB4QbB+x2GQT9DMzzknqFei4aebsCzaPJ4n/Gzm2dG4OSVryC1pZ
         7HQoNMT2jViRHL8Lu1dYv9R8qUG4JWh3gBxhIK6jqR3b8HOdv9ZZkNSrbNPY0L6BG32C
         27PMB0XjsTbyQWDify5kWYcFJMIaSiVYcmNIIJO5mt0XFxeNUQ0hk7pJ6r5oM98ZB+GP
         FdkcCcZ2wr2xm78hd5o0if3+qKnQijvxh5gF53qOBJ9mJ7SBgLVimSNV9AG7cXUafCtQ
         u4fw==
X-Gm-Message-State: APjAAAVkckAFHCjTeczC7MoXeoKIBFxT3yNwC4SLM2RAaiklmfv7jmBx
        ojydUMd9ERj+CQXwSuY73o2fpNsQuaSNoGz99g==
X-Google-Smtp-Source: APXvYqwlHwIdNAllJTOAdZ2QpM8zjoq2zQgzuCk9DsZFLXFOCFQNBD0GVubvxGAzjhFkHtZUUE427rpX0ilajXcT+9E=
X-Received: by 2002:a2e:898a:: with SMTP id c10mr11995921lji.177.1573841236700;
 Fri, 15 Nov 2019 10:07:16 -0800 (PST)
MIME-Version: 1.0
References: <20191114061646.22122-1-lsahlber@redhat.com> <20191114061646.22122-2-lsahlber@redhat.com>
In-Reply-To: <20191114061646.22122-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 15 Nov 2019 10:07:05 -0800
Message-ID: <CAKywueRUUfLcRMze1P5pgF8KPcizYdhFH_TBbBAZGr0fZa1ikw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix race between compound_send_recv() and the
 demultiplex thread
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 22:17, Ronni=
e Sahlberg <lsahlber@redhat.com>:
>
> There is a race where the open() may be interrupted between when we recei=
ve the reply
> but before we have invoked the callback in which case we never end up cal=
ling
> handle_cancelled_mid() and thus leak an open handle on the server.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c   | 1 -
>  fs/cifs/transport.c | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccaa8bad336f..802604a7e692 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1223,7 +1223,6 @@ cifs_demultiplex_thread(void *p)
>                         if (mids[i] !=3D NULL) {
>                                 mids[i]->resp_buf_size =3D server->pdu_si=
ze;
>                                 if ((mids[i]->mid_flags & MID_WAIT_CANCEL=
LED) &&
> -                                   mids[i]->mid_state =3D=3D MID_RESPONS=
E_RECEIVED &&
>                                     server->ops->handle_cancelled_mid)
>                                         server->ops->handle_cancelled_mid=
(
>                                                         mids[i]->resp_buf=
,
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index ca3de62688d6..0f219f7653f3 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>                                  midQ[i]->mid, le16_to_cpu(midQ[i]->comma=
nd));
>                         send_cancel(server, &rqst[i], midQ[i]);
>                         spin_lock(&GlobalMid_Lock);
> -                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITT=
ED) {
> +                       if (is_interrupt_error(rc)) {
>                                 midQ[i]->mid_flags |=3D MID_WAIT_CANCELLE=
D;
>                                 midQ[i]->callback =3D cifs_cancelled_call=
back;
>                                 cancelled_mid[i] =3D true;
> --
> 2.13.6
>

It doesn't seem that RC may be anything other than -ERESTARTSYS but
is_interrupt_error() should work.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
