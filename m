Return-Path: <SRS0=XjJ0=SD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2776EC43381
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 19:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2F5620857
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Apr 2019 19:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqskOpEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfDATZP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Apr 2019 15:25:15 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35628 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfDATZP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Apr 2019 15:25:15 -0400
Received: by mail-lf1-f66.google.com with SMTP id u21so7165044lfu.2;
        Mon, 01 Apr 2019 12:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SeB5cZmeS2wDZl+OIG8bU3nCFcvCNwg23R8L0yarYGg=;
        b=dqskOpEOnHeQx2GT3y2+RkOYimypiE7iUQqyOKQpILW0R//vWltNaYUMu5qlSgGWvo
         0pAzzx4Pd8HmxpeHc4hJXmBSB7+2cflGWmRXijmkbaP2cJwv08Hcc5rAhQ3ENwCa1syY
         7/3xrZcRspzWCYOnd5eAFrS0eT4rn1dDtliByFk2/dH7ZNiGVlLxNd4oo7lV2Ho9xEg6
         shEbAF6MCwbmsIJnGp9JHIce0f5G/v9zynFB9/KTReZNSlvqNOHhrMYgHt2Q/GkHRscV
         MAuwaataMemvcoblcoeOPDogyJWNV7n3HpG9OFI4Y4CwLEW9Lvx6s5BQtQ0APYF/0uax
         F+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SeB5cZmeS2wDZl+OIG8bU3nCFcvCNwg23R8L0yarYGg=;
        b=UBQ153mMRCNDx7ivfn0G3rjivFpa/8Qhu05hywY99OWe88l83003WUjXKj2a6gBGq5
         qsgruj89boNtPyRN99zDl8sb2uZWGwG45Z2BKWhw0L/jT9S6/qbhY+PMzVbqDk5fKoYa
         YKjZUoaEiVWC1sS8N4l57vvRZCHfkU4zvTUMucAbeMKqhvp51IotxYkfxi8w1AlPHQ4t
         SVPmymGGjzX9GWJNhRDAfFAQBVqFAUYSekOoK14Rdj+/P2VwDLfHw8uCNqXDw5Jopr6+
         cFQj/xtce5glLxgHI9KKHMdyUrtyVZOTANtVmbJXpJN71TxNKm7WQsQfJ6gMXn0fufo/
         AvPQ==
X-Gm-Message-State: APjAAAVcFDX0RuB6YHh+WydqIYueBCqNPhJpYwkbS2EVHq3SzwwMkQZW
        XAHbLHhVwaInYrc/ND7CU0I68Uaan4s/q/UqbIDaygdjfg==
X-Google-Smtp-Source: APXvYqxLEUvTJKfQVnvqN5h5+cPl926DjHn5QMAixrk3BK2MxWA3WakbKrAE5NNauceiUP8M5NvaQ/uH2Owq89w43J8=
X-Received: by 2002:a19:f707:: with SMTP id z7mr783343lfe.61.1554146713214;
 Mon, 01 Apr 2019 12:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190331235344.1610-1-lsahlber@redhat.com>
In-Reply-To: <20190331235344.1610-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 1 Apr 2019 12:24:59 -0700
Message-ID: <CAKywueSJs0yBOom_K_WS166Z77envB86MzG9ysUTXQVqvCsxjw@mail.gmail.com>
Subject: Re: [PATCH] cifs: a smb2_validate_and_copy_iov failure does not mean
 the handle is invalid.
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 31 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 16:54, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> It only means that we do not have a valid cached value for the
> file_all_info structure.
>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 7cfafac255aa..728437f8c45d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -733,14 +733,12 @@ int open_shroot(unsigned int xid, struct cifs_tcon =
*tcon, struct cifs_fid *pfid)
>         qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_=
file_all_info))
>                 goto oshr_exit;
> -       rc =3D smb2_validate_and_copy_iov(
> +       if (!smb2_validate_and_copy_iov(
>                                 le16_to_cpu(qi_rsp->OutputBufferOffset),
>                                 sizeof(struct smb2_file_all_info),
>                                 &rsp_iov[1], sizeof(struct smb2_file_all_=
info),
> -                               (char *)&tcon->crfid.file_all_info);
> -       if (rc)
> -               goto oshr_exit;
> -       tcon->crfid.file_all_info_is_valid =3D 1;
> +                               (char *)&tcon->crfid.file_all_info))
> +               tcon->crfid.file_all_info_is_valid =3D 1;
>
>   oshr_exit:
>         mutex_unlock(&tcon->crfid.fid_mutex);
> --
> 2.13.6
>

Looks correct.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
