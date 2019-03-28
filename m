Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959EFC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 00:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58958206B8
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 00:17:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hz+atwiI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfC1ARh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 20:17:37 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44746 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfC1ARh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Mar 2019 20:17:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id u9so12593992lfe.11
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2019 17:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qR4D6DFJFW1Q3ZJtLmnnH574zW7Gsge0kQnq101vGTA=;
        b=hz+atwiIj+pu/c0aFIzAy7E1qXksO2XAQCoCN4SAoqGKGVHmcOAK37XrOXw5T3X0Xo
         CfjLcvRs0dimbv5HOioaWOpi/8nbI6XV9lH45kHNz4UVx3JkfLAkAIi1ImzZJnmaqCML
         SQkp3IwC6HxAvv3Dgo5wEHwMqr3wkC1lTh0Ebhi41HHgNpcSp65FODyQ55CU65jMGLI2
         vL2EbXtXoAMEAZCS0HNcj40BPuiesZpH41mlfnS+lz665K1Sw9D5QyQez8g9SEkYNceC
         ZKEm8zYdDjl/n4qZuhhFTmJobm45LPkziXEPfblHW7H8IbD2Lo/1YRLEd+DfNg23R1+a
         vZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qR4D6DFJFW1Q3ZJtLmnnH574zW7Gsge0kQnq101vGTA=;
        b=D1A18bLDN+HGiva0Xy1gV5F/ST4S7uVzYWRgmY6b+rtYuphf763tN2dTfPYcuKEXXF
         gjZFxnjdL9aI6ge0RaPmH7DE/PBnlVDvjvfFEfvNpd52HneqmFYs3/nYNv6xRoJOzNRd
         jD/wdMcqpE1bMVxfozJNCgGQTWjIL19iYTGzNlXvEHotJuKNXP95qfvDu/XDokPUEYBn
         JVQ3wGDmQLDc0xOtftvzse1dS0IvpYcg6iQSTRkcF36JWVgI8/QrSulwxIgLhUxrBGoC
         3kfUpLyO4o+LLmjIB5K7XgTSM8tYltaPh2gwE/pFfD+/tOAzzg/ltBWl8JBCoDMhqeea
         CbNA==
X-Gm-Message-State: APjAAAUcNljaXLeQGUBxntnEiNqqwnm8r3/iZ89yweArhJup8psKnNbV
        uiWvChUa0slZv7LTc4a5MHw0Di0j1bYS/0H2HA==
X-Google-Smtp-Source: APXvYqx47nriN3EVJNlDrMcCI+m703/b5UPafiQYEZ8wvxub58hQ4oD9YINMrtsRIpkVq+ySa0EkRaaOK5Sp7zqd+0c=
X-Received: by 2002:ac2:4421:: with SMTP id w1mr12618051lfl.97.1553732255631;
 Wed, 27 Mar 2019 17:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190327235742.6236-1-lsahlber@redhat.com>
In-Reply-To: <20190327235742.6236-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Mar 2019 17:17:24 -0700
Message-ID: <CAKywueSYWYzG9tz0Batwu5OSCM+9wvHd0ggRzpQXQqncyZK+Bg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix kref underflow in close_shroot()
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 27 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 16:58, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Fix a bug where we used to not initialize the cached fid structure at all
> in open_shroot() if the open was successful but we did not get a lease.
> This would leave the structure uninitialized and later when we close the =
handle
> we would in close_shroot() try to kref_put() an uninitialized refcount.
>
> Fix this by always initializing this structure when we are about to retur=
n
> 0/success but make the extra kref_get() on the refcount conditional to
> whether we got a lease or not.
> This extra get() is only used to hold the structure until we get a lease
> break from the server at which point we will kref_put() it during lease
> processing.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 1022a3771e14..4f0fb53cd0de 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -724,14 +724,6 @@ int open_shroot(unsigned int xid, struct cifs_tcon *=
tcon, struct cifs_fid *pfid)
>         else
>                 goto oshr_exit;
>
> -
> -       memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> -       tcon->crfid.tcon =3D tcon;
> -       tcon->crfid.is_valid =3D true;
> -       kref_init(&tcon->crfid.refcount);
> -       kref_get(&tcon->crfid.refcount);
> -
> -
>         qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info))
>                 goto oshr_exit;
> @@ -745,6 +737,20 @@ int open_shroot(unsigned int xid, struct cifs_tcon *=
tcon, struct cifs_fid *pfid)
>         tcon->crfid.file_all_info_is_valid =3D 1;
>
>   oshr_exit:
> +       /*
> +        * If we return 0/success then we must also initialize this struc=
t.
> +        * If we got a lease we need to take out an extra get() to keep
> +        * the structure around until we receive the actual lease break.
> +        */
> +       if (rc =3D=3D 0) {
            ^^^
This will still leak a handle if smb2_validate_and_copy_iov failed above.

--
Best regards,
Pavel Shilovsky
