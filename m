Return-Path: <SRS0=YW4u=SZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244BEC10F03
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Apr 2019 18:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFDB220685
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Apr 2019 18:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJbW3JQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfDWSDH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Apr 2019 14:03:07 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41070 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfDWSDH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Apr 2019 14:03:07 -0400
Received: by mail-lf1-f65.google.com with SMTP id t30so12450730lfd.8
        for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2019 11:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SYoc0BN0Jbe95iTj5s6u4ayhICEyInZn5H6TDih1uec=;
        b=eJbW3JQzD49BcVhnYJ/cObxgj6PHHnur9ukRl3iInq7SuWCp23+HECevroYCUrIUCY
         xPmNhIVkXelkdiUMWltUwztxtrqyfCM4gpecVXf08pGWLeF4kjGsVu5uM+jZP6x6bLaH
         /J1+s32BNXMgsA73Phgzc1qcwqixGL3l0Jivs4Y3+cKhZhKgXgiaegRlyEry2H5w65a2
         O7Wv2QKovkCUJ0RYq3cnhzGzSPqa6UzEtA8kBp0oMvhOM9eyv41dFGx0+TOdRFThgcvI
         eANsxfG+dsRDnqDK/FCxEjeOwibs/IBwlkj9wHnYztquOPTgHk18b5kYp74AOtRP+s2I
         aVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SYoc0BN0Jbe95iTj5s6u4ayhICEyInZn5H6TDih1uec=;
        b=muvUtgKdSHdIdWxg4NdvdYt9daA0kbikY6hufMZOYwWEaS3oaKXWmGpXHM610k1nGj
         fh2tsmaT21DLD8BDFM8SwsMZtAntzQUsjEBnYTyAGUUpXEtcE1X26mGvu00Qn0fvZUPS
         m7OLucq36vQ633UNLKPgTiybHjTpZ1nthsfxahaIDnaWpMLesCi0uWqIwUxcFfEBAeEQ
         +b/BlEQovCcimHNdMw9m5UhuRSsihxRWeur1pvB7RMqq8aERos5OG6rKmULM+L7TQXtj
         rlUqv9TYd8ImstWpav+4k9zRNolcy43gm6EtRt5HSnXrBxZsy/6dgCRNrYJmUxDMqeNe
         1hMg==
X-Gm-Message-State: APjAAAWa2sp8/xlDxJrZu+uMd+3s+ovu0BBLSn2Y/PV/kPYBMYBrK6aU
        9qozUvVF+Af21XqfwDDrYGmrYXhuI7SFBultTw==
X-Google-Smtp-Source: APXvYqxBhZTDPVDNyz4sOHniXjbaXjEw6890KdvttcMrywOI6+ugWW48adK1sg7rt1Q58GOByR3VGUOYI80oBNojSAo=
X-Received: by 2002:ac2:52b1:: with SMTP id r17mr6678023lfm.39.1556042584993;
 Tue, 23 Apr 2019 11:03:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190423032749.30799-1-lsahlber@redhat.com>
In-Reply-To: <20190423032749.30799-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 23 Apr 2019 11:02:53 -0700
Message-ID: <CAKywueQCViFC3W083J6tb=-oMP2iHAdm89oG73W+hAn451s4ig@mail.gmail.com>
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

=D0=BF=D0=BD, 22 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 21:40, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 5c59c498f56a..3b80884ddf0f 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -971,7 +971,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>                    const int flags, const int num_rqst, struct smb_rqst *=
rqst,
>                    int *resp_buf_type, struct kvec *resp_iov)
>  {
> -       int i, j, optype, rc =3D 0;
> +       int i, j, optype, opmask, rc =3D 0;
>         struct mid_q_entry *midQ[MAX_COMPOUND];
>         bool cancelled_mid[MAX_COMPOUND] =3D {false};
>         struct cifs_credits credits[MAX_COMPOUND] =3D {
> @@ -981,6 +981,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>         char *buf;
>
>         optype =3D flags & CIFS_OP_MASK;
> +       opmask =3D flags & (CIFS_ASYNC_OP|CIFS_NO_RESP);
>
>         for (i =3D 0; i < num_rqst; i++)
>                 resp_buf_type[i] =3D CIFS_NO_BUFFER;  /* no response buf =
yet */
> @@ -1073,8 +1074,13 @@ compound_send_recv(const unsigned int xid, struct =
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
> +        * will not receive a response to - return credits back
> +        */
> +       if (rc < 0 ||
> +           (optype =3D=3D CIFS_OBREAK_OP &&
> +            opmask =3D=3D (CIFS_ASYNC_OP|CIFS_NO_RESP))) {
>                 for (i =3D 0; i < num_rqst; i++)
>                         add_credits(ses->server, &credits[i], optype);
>                 goto out;
> --
> 2.13.6
>
Thanks for looking into it. Let's me clarify the defines here because
their names are not straightforward and require changes:

#define   CIFS_ASYNC_OP         2    /* do not wait for response */

meaning that we don't need a response - probably there won't be a one
(in SMB1 Oplock case). This is confusing because we also have
cifs_call_async that does asynchronous processing of the responses.

#define   CIFS_NO_RESP      0x040    /* no response buffer required */

meaning that a response buffer is not needed but the error code is.

The problem with SMB1 oplocks was introduced when credits calculation
was moved to the demultiplex thread. The server might not respond to
such a request at all - that's why it is a special case.

So, CIFS_NO_RESP flags should be handled like we do today - no changes
are needed here. We wait for a response but just do not return a
buffer to the caller. CIFS_ASYNC_OP handling has a bug that it missed
to add credits back once we send such a request. Prior to credit
movement to the demultiplex thread label "out" has the code to add
credits back. So I think the only fix that is needed here is:

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5c59c49..26e249d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1095,8 +1095,11 @@ compound_send_recv(const unsigned int xid,
struct cifs_ses *ses,
                smb311_update_preauth_hash(ses, rqst[0].rq_iov,
                                           rqst[0].rq_nvec);

-       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
+       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP) {
+               for (i =3D 0; i < num_rqst; i++)
+                       add_credits(ses->server, &credits[i], optype);
                goto out;
+       }

        for (i =3D 0; i < num_rqst; i++) {
                rc =3D wait_for_response(ses->server, midQ[i]);

It worked locally against Samba server for me.

I would also suggest as a separate change to rename:

CIFS_ASYNC_OP to CIFS_NO_WAIT, and

CIFS_NO_RESP to CIFS_NO_RESP_BUF

to reflect the exact meanings.

--
Best regards,
Pavel Shilovsky
