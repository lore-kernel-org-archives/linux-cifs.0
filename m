Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E4AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 03:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349077AbiARDHB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346492AbiARCtG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jan 2022 21:49:06 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0F8C06175D
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 18:41:21 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id d3so64811468lfv.13
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 18:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SfuS7i4CmtH30Nbs+DfTZaqSeCJrs+JBZZMqovJ/nL4=;
        b=Q0yRbfX6xnX9Hdx+4pS6mld8DmqX/Y2xyiXrv7fXXIlfbNDyfZfWG3s7dPpsK1oqTz
         iqER5GHlBB9uahjiudcWfWx2NTX3dQXoEbew6Hb3XMz2S4/muKagDsvgTOHbiEBEj3w3
         mDbMa2c7Kv8mjB3+0eHihL6tRBAHP/oupSAjfcF4A6xbj5aqkp+ISgPGOn8xFJqKd5Z2
         68PqEjsbvQ+2F4FeIpTBkHndfG62oZIL87zExGzJkt1X2u0iCD6pAgnX3yopE3YaziDB
         ARUd6H8j8yBIt/Z6fHT51HqA+Uwijqt/nNS0Ap8fpxW2IK54Cmej4A37kPB3b5Mdhskn
         4MSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SfuS7i4CmtH30Nbs+DfTZaqSeCJrs+JBZZMqovJ/nL4=;
        b=L4+UdMOL28ANNSWlo5S+U+WovTX8PoP9IRVC/iv3TqBeTxZ6ahCGQbg+499TZ7DA4T
         hgUIfwfCOg58ase3QFK1RQ+RI8g8AG6YPaQ05ExyZdvfUDZOg+oI7/ALOktX5wu0Usl1
         vZc3ZZjveMkDnE3yJC410FU5+tg323osHWXV0pWtVFjvsWxPv78tdzhVrirp1dtvmUK2
         Jfr4lF/0WlWLGH+e3vqsvQfAttBH+tH+u7tpfedSwrEMEB9b8YoI0xbJGe+Lt+OeAMjY
         SAPcuPR0ActcPWCbVV5a0XCVbha46nkRz7Ufu7H7i+MiNbkLnc7WyouKY+Lglf55glHk
         eWVQ==
X-Gm-Message-State: AOAM533X5Mo4OpQ2L1CWEB9lPjvt6ml71X0tkL5+8yGngm5Y3jOWcPlY
        PpYyQJmRehscggPHvv0Is25Jj2BLKU7W0ChqB8cR7ylN
X-Google-Smtp-Source: ABdhPJwUL/8wTOuquz+ngeC758oHOuphN1QCOjwrSVJbRaYH1sTdwjPcfsfafx3BTkHJn+Br+PMoJxVh8poEwm0pGOo=
X-Received: by 2002:a05:6512:3e02:: with SMTP id i2mr19262783lfv.667.1642473679805;
 Mon, 17 Jan 2022 18:41:19 -0800 (PST)
MIME-Version: 1.0
References: <20220118021657.2145245-1-lsahlber@redhat.com>
In-Reply-To: <20220118021657.2145245-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Jan 2022 20:41:05 -0600
Message-ID: <CAH2r5mvbgXVPC3r_fBzCpyb1FFTzy9fNtCZ-AJRcAeZ8bwv0sg@mail.gmail.com>
Subject: Re: [PATCH] cifs: serialize all mount attempts
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Would this slow things down much at boot time when you do have e.g. 3
mounts ... would end up serializing a bit more?

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
