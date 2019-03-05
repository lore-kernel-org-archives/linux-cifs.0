Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4B3C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 02:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5D8206B6
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 02:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQ0KkP7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfCEChx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Mar 2019 21:37:53 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42473 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfCEChw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Mar 2019 21:37:52 -0500
Received: by mail-qt1-f194.google.com with SMTP id u7so7497066qtg.9
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 18:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tDoPVqCr8XRIGIhOKpvobm2Sz54usEgkrSrpJeyyzag=;
        b=VQ0KkP7bwi1YdbRaNVpwcUlW1I9Ez7Jf9Ul0VCXsJZkf1bcsQdkTOhk8RZxmJE6dNk
         GODGZM1um4zkwa+4kzABkbWw6hCA9hcZMV4KYLmcZZPHr4qJusJS6RVsEpFaCJKLxRgG
         2ZouTVvUGzmzhDSoqBXac+rqk8rgZYVdmMU0sIFImjqV0SD2tzvIYJYLYJq4Y8mZmWtL
         xcdhicHS3DtP0+Kn3hlqmspau7TTaVl8ZKRUPwtoLnTmu2CGbhCJdbKXyDTYCfgdNqZq
         7gP2Oby0I4cObJCqxCAGYVzYOXQ457QCNH4Sk3e4s7wNSUAQz1E6iderPmwNSJIpFW8E
         kaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tDoPVqCr8XRIGIhOKpvobm2Sz54usEgkrSrpJeyyzag=;
        b=nP/vp76LsefiNMewE9dKlY0edrux2CtwFljJAOxGY6tfYS3pWL1CoFAAU5apT0EwTS
         PJL7iapa22jZpVRN6te0otxUq8UcH1ubASJnC58F7T97gHqAtUtDsRje/13o6FmVfy8R
         aOZ2v8x0fuoecjdI8Ke1v/LosmeI0AzjYQjXOVByArLZLPAHlwkD+pvBxqo7z0voduTD
         scMztDIurOl1vVRHuqkQFO5xQJ5vsdWlKJnSPEB1He49gkpm2cqP4LCTpnE1zjrfbWPp
         760PAh63Biu3anTTpLHvJHZzRTzjc6szrbuhfALGeiXjx4yyxD0jVNuAxBCFPg5TTGsE
         hewg==
X-Gm-Message-State: APjAAAWa6xi5E7lDQcN6GIA4RH1h21DFqPbhG4zHYU+QXAPsaMztmTBV
        ci3aSZULAzjRCOTkubSKQeQG6AwFeYUdxJavlXM=
X-Google-Smtp-Source: APXvYqzl+J/ekHnQr+ZtzInIBvK9Nnwuy+tkDWYw87JTccIJ+h75PJn1f245s/ZuUscsM39/RUV3muPqqeYYYgEICHA=
X-Received: by 2002:a0c:93ab:: with SMTP id f40mr394652qvf.59.1551753471620;
 Mon, 04 Mar 2019 18:37:51 -0800 (PST)
MIME-Version: 1.0
References: <1551750481-17919-1-git-send-email-pshilov@microsoft.com>
In-Reply-To: <1551750481-17919-1-git-send-email-pshilov@microsoft.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 5 Mar 2019 12:37:40 +1000
Message-ID: <CAN05THSyBA=-8V-1yRpu62B_BHqwptMrJzrfkPzOHVfynP=HnA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix read after write for files with read caching
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Tue, Mar 5, 2019 at 11:48 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> When we have a READ lease for a file and have just issued a write
> operation to the server we need to purge the cache and set oplock/lease
> level to NONE to avoid reading stale data. Currently we do that
> only if a write operation succedeed thus not covering cases when
> a request was sent to the server but a negative error code was
> returned later for some other reasons (e.g. -EIOCBQUEUED or -EINTR).
> Fix this by turning off caching regardless of the error code being
> returned.
>
> The patches fixes generic tests 075 and 112 from the xfs-tests.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/file.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9b53f33..4c144c1 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3096,14 +3096,16 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
>          * these pages but not on the region from pos to ppos+len-1.
>          */
>         written = cifs_user_writev(iocb, from);
> -       if (written > 0 && CIFS_CACHE_READ(cinode)) {
> +       if (CIFS_CACHE_READ(cinode)) {
>                 /*
> -                * Windows 7 server can delay breaking level2 oplock if a write
> -                * request comes - break it on the client to prevent reading
> -                * an old data.
> +                * We have read level caching and we have just sent a write
> +                * request to the server thus making data in the cache stale.
> +                * Zap the cache and set oplock/lease level to NONE to avoid
> +                * reading stale data from the cache. All subsequent read
> +                * operations will read new data from the server.
>                  */
>                 cifs_zap_mapping(inode);
> -               cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
> +               cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=%p after write\n",
>                          inode);
>                 cinode->oplock = 0;
>         }
> --
> 2.7.4
>
