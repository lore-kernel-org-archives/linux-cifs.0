Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B0FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 03:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351606AbiARDy3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348155AbiARDyT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jan 2022 22:54:19 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79D2C037028
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 19:43:09 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m1so65436263lfq.4
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 19:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qGsDmJkw8dPiztr6msGMN+vMl5AMfliEVmlxBJivCUw=;
        b=lgiDrkMmYAGBC3QMiszQ+WGlLzWFBvpwPRMCBHjiXI68JOq3hX0/DXfnF+M/nOWcdG
         5Wv9dW7iCLGNeIjDqDB8D+FJkmDtAijOJIWjHqDzLkUxRFR9d4YwhISBf92Qdeb7Ht3b
         4f9X5kgxyfWHk+l0zEeIFzPSy02azYeNfXForld34vTv/E1GnY8NKPZ5jAdce5O/6DeP
         A3rTa5J/M7rynOEWxwX11bxeQAAvqy9YvX/m1hOL90C8qZo79OIQGbSWzI7XojXwVhYL
         hjUc15+NS9avR0RPxmZCKwWK0f2raMKP644elfQy/XinquhFHafH6iHUvGeMLhP0E3S1
         le9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qGsDmJkw8dPiztr6msGMN+vMl5AMfliEVmlxBJivCUw=;
        b=qSqAMgFEf6MEIKA/SevjxGMyW0nu2ic3Ny0HT0Gw8Cecu6g6jH4QO+p94JNAnjkR0E
         b1H/jMWCJ3a9U9h5N1QcOZW0ql+7gRThJNziWBJh0SxVP286Zozqgibvk+Y/LgHdol/f
         ml3FfOABAufXFG3Nvhu+xZsVVVvN8aUYHoNo71EwMUToEM+AqnUFbRDndz4Jdyg0woi1
         CMkZ5318o77/p2XrwAsywIH1gL0zyuy1cPfXz+7DH9H/C2dIA29iTE2i/imO4ENf6Wez
         O0arRLVLedm3fFaD2JixdaXADBKHPaG8GlHbUv088Pp4UoCrIrlUOcJDsBCuSo/KRVd5
         keqw==
X-Gm-Message-State: AOAM530GP+XQ4jFsu1CMHw0m8MKqCargIkVIwduC0kflNIlgKePF54QA
        Y96okIuOimKS26E7l9fIrCSMHMyBnCzff+hxB8w=
X-Google-Smtp-Source: ABdhPJzBZqu29Hir32ZBP27vFEQ1GHsben10Iwg6R5oYfeI62nkC52+PUt/O8vlNITlLNOx1iM1PM4SNZ19i13WVitE=
X-Received: by 2002:a19:7416:: with SMTP id v22mr18655287lfe.595.1642477388023;
 Mon, 17 Jan 2022 19:43:08 -0800 (PST)
MIME-Version: 1.0
References: <20220118021657.2145245-1-lsahlber@redhat.com>
In-Reply-To: <20220118021657.2145245-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Jan 2022 21:42:57 -0600
Message-ID: <CAH2r5mtDfpA8dsS3bE8-NsDmVc6_=vkx_wBKFva7hSpt4cCRAA@mail.gmail.com>
Subject: Re: [PATCH] cifs: serialize all mount attempts
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

What would happen if on boot you had 3 servers in fstab, the first two
of which time out due to bad address (or in my case port 445 blocked
for the internet but not for local servers in the house), does it slow
down bootup? Does it slow down the mount to the 3rd server (which is
reachable)?

Would it slow things down too much in some cases?

On Mon, Jan 17, 2022 at 8:17 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 2008434
>
> Some servers, such as Windows2016 have a very low number of concurrent mounts that
> they allow from each client.
> This can be a problem if you have a more than a handful (==3 in this case)
> of cifs entries in your fstab and cause a number of the mounts there to randomly fail.
>
> Add a global mutex and use it to serialize all mount attempts.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/fs_context.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index e3ed25dc6f3f..7ec35f3f0a5f 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -37,6 +37,8 @@
>  #include "rfc1002pdu.h"
>  #include "fs_context.h"
>
> +static DEFINE_MUTEX(cifs_mount_mutex);
> +
>  static const match_table_t cifs_smb_version_tokens = {
>         { Smb_1, SMB1_VERSION_STRING },
>         { Smb_20, SMB20_VERSION_STRING},
> @@ -707,10 +709,14 @@ static int smb3_get_tree_common(struct fs_context *fc)
>  static int smb3_get_tree(struct fs_context *fc)
>  {
>         int err = smb3_fs_context_validate(fc);
> +       int ret;
>
>         if (err)
>                 return err;
> -       return smb3_get_tree_common(fc);
> +       mutex_lock(&cifs_mount_mutex);
> +       ret = smb3_get_tree_common(fc);
> +       mutex_unlock(&cifs_mount_mutex);
> +       return ret;
>  }
>
>  static void smb3_fs_context_free(struct fs_context *fc)
> --
> 2.30.2
>


-- 
Thanks,

Steve
