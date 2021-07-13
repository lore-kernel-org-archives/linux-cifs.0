Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B10C07E95
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 04:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74151611F1
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 04:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhGMFB7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jul 2021 01:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGMFB6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jul 2021 01:01:58 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67778C0613DD
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jul 2021 21:59:08 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id v6so10763055lfp.6
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jul 2021 21:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GCp326/kmQhUpxa5QOi5P5BF48+2bUVKo0UBdYSToZo=;
        b=anIWRjVV9a7jJlGmQWWU8jjd1j49Pv56LjnVDdn83X+UL38gukk1X08QUXXhtBlsZQ
         0LZiruuHq8Ixe5RZfMHUas7NotKEXWgz15BViIOxNJ/drOPpix16ZpPMOvaz5QGTZDAl
         77KVymxcEVxyH6Q3gjn1GKlt0+SjkLR5SPIyHaZ0D7lT/ggqIJWnqYbx+pLj2osM8jWn
         WuUj+eUUS6dc6ifpxOtVZR1vLmozil1i2iuZ5P/nHLmfyp2LKANMpDHzqfVt40NvHeH3
         iZejvDpH6KKuBCDDUql7IJ+3z39M+fee6Z/wCld8ak3mi5C9FyhgLb2Qf/AgRgzAD5XB
         ZL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GCp326/kmQhUpxa5QOi5P5BF48+2bUVKo0UBdYSToZo=;
        b=HgJmcqPjRTEw5sRDtvkjDrpKDAJ6/05a3ftn4cRQ5WjhahImT2+iq9colFzxKsDotr
         6MzEj4CApGrvjEsq62D5lBTBIZVr046gar9vHKQLeyyoO0T9seoT+UCS2S6+FtlL2Hss
         HNRhGpBd3qaz+rVQZc84AIdqZHbiLvdbHIWu8rF1jY6bJCayF57BPfhhwVguCJWtG/Oj
         NWJ0PZt+XUaFXgGgWDeY5V1NX/pUY1zVpP9oPPQcuFFys6/cbl+f7kV8AxXqtV72i2rE
         AqaO+Tciufmx3OTr0g3tQ+jQAH/k4BLYdIrxfuFemHf2F1WhFVbhOBNRWSJAsSiPh3w5
         3H2g==
X-Gm-Message-State: AOAM530M7d8x4DqreNoe7qrYi2EVkhBcmkyzHPtYUdQZaVreaqUsXx6Y
        UidCkzOhXrp4H+qtFW4TpvBq90uHuhRZw/67AU4=
X-Google-Smtp-Source: ABdhPJw65t/WG3FR7s0DxbzzWS3wbjKxS/FPiTUJ4xwuH2hGSaXIm9ZsqJKwRhChiqdZd/+BNwzM4W5Z0g4cQdW5B4w=
X-Received: by 2002:a05:6512:2316:: with SMTP id o22mr2006354lfu.175.1626152346607;
 Mon, 12 Jul 2021 21:59:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210713022259.2968733-1-lsahlber@redhat.com>
In-Reply-To: <20210713022259.2968733-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 12 Jul 2021 23:58:55 -0500
Message-ID: <CAH2r5mu3VWp1PA=87sw_eWSbx+UdQ3utBBrpd1ESiYM24YKp+g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Do not use the original cruid when following DFS
 links for multiuser mounts
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Mon, Jul 12, 2021 at 9:23 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213565
>
> cruid should only be used for the initial mount and after this we should use the current
> users credentials.
> Ignore the original cruid mount argument when creating a new context for a multiuser mount
> following a DFS link.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Cc: stable@vger.kernel.org # 5.11
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_dfs_ref.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index ec57cdb1590f..5c9a8778c99d 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -208,6 +208,10 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>                 else
>                         noff = tkn_e - (sb_mountdata + off) + 1;
>
> +               if (strncasecmp(sb_mountdata + off, "cruid=", 6) == 0) {
> +                       off += noff;
> +                       continue;
> +               }
>                 if (strncasecmp(sb_mountdata + off, "unc=", 4) == 0) {
>                         off += noff;
>                         continue;
> --
> 2.30.2
>


-- 
Thanks,

Steve
