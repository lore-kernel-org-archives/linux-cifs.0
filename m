Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B81C04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 05:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiI2FSS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 01:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiI2FSR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 01:18:17 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97207D69F2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:18:16 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id m65so404217vsc.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eRGbNCojgSjKwuQ98gfvxoZ1w6/gTxELhwZI6lbj3JE=;
        b=cq9ZTNIhzzCg+4rrcxQjbd0/yPGIp+XU24HTUdVoQgKMqXvLMgZ9BfC9uS7Wgjl9K7
         sxr/o9/WizlY9r6n5uiq1r5aM68wTUJeSYsuCLJEv3nkAIOPd/Bog4c2jRt6Obe0Wg+N
         QdJEbdNTTiPcvbB9aYmlt5Lkt3wr0xl2i6v51xlwEsoQL33hoLZC0CrKQlb0Ucd2WcBi
         NKB4isJ28p1HzFm0uxIDVWdTHN/z2cS1zz8P/6ROLrBhi3nioIwI87SHJG/Pj1JiCI/6
         8lqNllR1ivQFkq9TH4QXuA5wBb9Fui6odjN3XW1FsseSxbnUKXiegicn4gNmNY80o8ax
         C1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eRGbNCojgSjKwuQ98gfvxoZ1w6/gTxELhwZI6lbj3JE=;
        b=VC3lxJR/wen6fPwapVRdmJ+Qg0UqN1ps7EOW8zMBUbAMm/7lbKnKWz4ES3opdWY8RK
         //Pc0WUBpS4Ikq2cRO3OfbXz28YOH9EAoVExFp04Yxs2hLyoi9zrpwlMVutG/JXPG8S1
         rG2FJ272MlO6dYIPl5Y/itRNV3wYMukFqagxN4t4kGzjrWbhkDPUcbt6jmDdHzWQf6RR
         G1+og4It5tqs6lPO1LBqxP6Zx84mAmwku6xc1I6q5w6sSejWF5MWGvoWvl+QuRn+BFyu
         ad0H6UjxKd8nsiKahUrAa9Uc9SIytmDEVQB0PJu4kKOMYm7I5QSfRFaupXKi16cVSzG5
         ETgg==
X-Gm-Message-State: ACrzQf0kcK0/h5JEb8J8MWHI7Ron0UEKrxdrHc4qMtstGv/5T5WOMc1R
        y8K99El0ETs0PAYemOhU9kvXqyBXsFSIg4uKgxvQ5c3B
X-Google-Smtp-Source: AMsMyM7qzcQx0bRW9icBcG455ASbK9PU6vhf5F+jZj8hj33d2CXq6Xw0d6QMIxF66T8Sq4rtb/g7r63SDBw3FZ+mnLk=
X-Received: by 2002:a05:6102:215a:b0:39a:c2c6:cc5d with SMTP id
 h26-20020a056102215a00b0039ac2c6cc5dmr432156vsg.61.1664428695480; Wed, 28 Sep
 2022 22:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220929015637.14400-1-ematsumiya@suse.de> <20220929015637.14400-2-ematsumiya@suse.de>
In-Reply-To: <20220929015637.14400-2-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 00:18:04 -0500
Message-ID: <CAH2r5mtx1JKD0S7SQfiJ51yjW17wpaygm-sfKOsGMeQqZxPXQw@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] smb3: rename encryption/decryption TFMs
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

looks fine - merged into cifs-2.6.git for-next

still reviewing/testing others in the series.  Feedback on those would
be appreciated.

On Wed, Sep 28, 2022 at 8:57 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Detach the TFM name from a specific algorithm (AES-CCM) as
> AES-GCM is also supported, making the name misleading.
>
> s/ccmaesencrypt/enc/
> s/ccmaesdecrypt/dec/
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/cifsencrypt.c   | 12 ++++++------
>  fs/cifs/cifsglob.h      |  4 ++--
>  fs/cifs/smb2ops.c       |  3 +--
>  fs/cifs/smb2transport.c | 12 ++++++------
>  4 files changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 46f5718754f9..f622d2ba6bd0 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -743,14 +743,14 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
>                 server->secmech.hmacmd5 = NULL;
>         }
>
> -       if (server->secmech.ccmaesencrypt) {
> -               crypto_free_aead(server->secmech.ccmaesencrypt);
> -               server->secmech.ccmaesencrypt = NULL;
> +       if (server->secmech.enc) {
> +               crypto_free_aead(server->secmech.enc);
> +               server->secmech.enc = NULL;
>         }
>
> -       if (server->secmech.ccmaesdecrypt) {
> -               crypto_free_aead(server->secmech.ccmaesdecrypt);
> -               server->secmech.ccmaesdecrypt = NULL;
> +       if (server->secmech.dec) {
> +               crypto_free_aead(server->secmech.dec);
> +               server->secmech.dec = NULL;
>         }
>
>         kfree(server->secmech.sdesccmacaes);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index ae7f571a7dba..cbb108b15412 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -171,8 +171,8 @@ struct cifs_secmech {
>         struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
>         struct sdesc *sdesccmacaes;  /* ctxt to generate smb3 signature */
>         struct sdesc *sdescsha512; /* ctxt to generate smb3.11 signing key */
> -       struct crypto_aead *ccmaesencrypt; /* smb3 encryption aead */
> -       struct crypto_aead *ccmaesdecrypt; /* smb3 decryption aead */
> +       struct crypto_aead *enc; /* smb3 AEAD encryption TFM (AES-CCM and AES-GCM) */
> +       struct crypto_aead *dec; /* smb3 AEAD decryption TFM (AES-CCM and AES-GCM) */
>  };
>
>  /* per smb session structure/fields */
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 421be43af425..d1528755f330 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -4344,8 +4344,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>                 return rc;
>         }
>
> -       tfm = enc ? server->secmech.ccmaesencrypt :
> -                                               server->secmech.ccmaesdecrypt;
> +       tfm = enc ? server->secmech.enc : server->secmech.dec;
>
>         if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
>                 (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 4640fc4a8b13..d4e1a5d74dcd 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -904,7 +904,7 @@ smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
>  {
>         struct crypto_aead *tfm;
>
> -       if (!server->secmech.ccmaesencrypt) {
> +       if (!server->secmech.enc) {
>                 if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
>                     (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
>                         tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
> @@ -915,23 +915,23 @@ smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
>                                  __func__);
>                         return PTR_ERR(tfm);
>                 }
> -               server->secmech.ccmaesencrypt = tfm;
> +               server->secmech.enc = tfm;
>         }
>
> -       if (!server->secmech.ccmaesdecrypt) {
> +       if (!server->secmech.dec) {
>                 if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
>                     (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
>                         tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
>                 else
>                         tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
>                 if (IS_ERR(tfm)) {
> -                       crypto_free_aead(server->secmech.ccmaesencrypt);
> -                       server->secmech.ccmaesencrypt = NULL;
> +                       crypto_free_aead(server->secmech.enc);
> +                       server->secmech.enc = NULL;
>                         cifs_server_dbg(VFS, "%s: Failed to alloc decrypt aead\n",
>                                  __func__);
>                         return PTR_ERR(tfm);
>                 }
> -               server->secmech.ccmaesdecrypt = tfm;
> +               server->secmech.dec = tfm;
>         }
>
>         return 0;
> --
> 2.35.3
>


-- 
Thanks,

Steve
