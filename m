Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9DFC4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 02:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B60221ED
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 02:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgLRCjw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 21:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgLRCjw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 21:39:52 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A358C0617A7;
        Thu, 17 Dec 2020 18:39:11 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 23so1585006lfg.10;
        Thu, 17 Dec 2020 18:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZE86BXyvArdHmgN9djhka1IqmUM9a7VE+3q/p0XrV0c=;
        b=i+/2IQ8vPOj6GMP0ej97DYBocXFLt7tnedy+7IAvrbynfHqKfJVfcIywuakRFNe2Dx
         9ScfMXSgYR70aVNx+Pr8KTLUhxx2xwiXl8gmSK8pQjgKAhxDga4Hlvy0aoGzSFc47jJ7
         XteetgFJJjdmy7PWDWzYd8wso4JuFP2AlvX43P8tnua6cN+9GzBlbyNXzUxMd34abuf7
         iEySw1vfa67O0moks5LwWH032/rtijtxY6aXd44zr4XsXO3NexKbwbk9G13j64uvaQbg
         Zv8yQCWGRNMwZ21lLVs3hJrgyq7SUdCjysSDxBgP7J+95r2wHFzzwcW7kBu6DCHfmKOp
         6s3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZE86BXyvArdHmgN9djhka1IqmUM9a7VE+3q/p0XrV0c=;
        b=FshBHJi/9gj6j+UQ6BA8ewWr9U0tgEe1Tx2wu+E/oGToz5WBDFXF5n+AKGsChv9/cy
         3RSrTcBiptqnTHCOalwsi/zD6byU9OgDcAJIijb9JQo//m5bAnPz12bYLp1waTXfxCQT
         6T2zE3A5W4+nz2PoOoIH+QBGQE9ymsO4x6HrjtH6+hJzUArldVcOuUqBhQL1HtD1Rhuj
         70f8XgVN0PPKnnCIeQJ2Xfm8J7LnRQ5yn8CQuHp03MB5/sH0f8mvEHGbBxsslF1UqhB8
         Voc8CxeqBnUfEzkrLRKxmDspdzTz+jWN2S76iCoHNgch3Wg/UKFnshzd7L75KGEg1IW/
         BfBg==
X-Gm-Message-State: AOAM53112FuNRieiwsVgoWiwxIJk5L0/zxkfuq/z/UbKlU4xX14giEaF
        hR2TeWFWzNpLCa810xs25I/ocyoHwt6UyX5dF3Q=
X-Google-Smtp-Source: ABdhPJywNGOuoIbh6tqnO0fPuTXa+f/Ysukt3QGAm1SZ+S0rVRjf8wz0e+ZS6U16CCOBr3wXkMgUnH1cJgslyrSbA7E=
X-Received: by 2002:a2e:8eda:: with SMTP id e26mr863678ljl.272.1608259150084;
 Thu, 17 Dec 2020 18:39:10 -0800 (PST)
MIME-Version: 1.0
References: <X9s6nGDLt4xreaYN@mwanda> <X9s7By4IDIcG4D+w@mwanda>
In-Reply-To: <X9s7By4IDIcG4D+w@mwanda>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Dec 2020 20:38:58 -0600
Message-ID: <CAH2r5mvvevajfzFrj0Q2GGDYV1en8aupf8RM_23hA1qa23RLbg@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: Re-indent cifs_swn_reconnect()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>,
        Samuel Cabrero <scabrero@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged these three into cifs-2.6.git for-next pending testing

On Thu, Dec 17, 2020 at 5:04 AM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> This code is slightly nicer if we flip the cifs_sockaddr_equal()
> around and pull all the code in one tab.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/cifs/cifs_swn.c | 64 ++++++++++++++++++++++++----------------------
>  1 file changed, 33 insertions(+), 31 deletions(-)
>
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index 91163d3cf8b7..d35f599aa00e 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -484,41 +484,43 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
>
>         /* Store the reconnect address */
>         mutex_lock(&tcon->ses->server->srv_mutex);
> -       if (!cifs_sockaddr_equal(&tcon->ses->server->dstaddr, addr)) {
> -               ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
> -                               &tcon->ses->server->swn_dstaddr);
> -               if (ret < 0) {
> -                       cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__, ret);
> -                       goto unlock;
> -               }
> -               tcon->ses->server->use_swn_dstaddr = true;
> +       if (cifs_sockaddr_equal(&tcon->ses->server->dstaddr, addr))
> +               goto unlock;
>
> -               /*
> -                * Unregister to stop receiving notifications for the old IP address.
> -                */
> -               ret = cifs_swn_unregister(tcon);
> -               if (ret < 0) {
> -                       cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
> -                                       __func__, ret);
> -                       goto unlock;
> -               }
> +       ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
> +                                     &tcon->ses->server->swn_dstaddr);
> +       if (ret < 0) {
> +               cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__, ret);
> +               goto unlock;
> +       }
> +       tcon->ses->server->use_swn_dstaddr = true;
>
> -               /*
> -                * And register to receive notifications for the new IP address now that we have
> -                * stored the new address.
> -                */
> -               ret = cifs_swn_register(tcon);
> -               if (ret < 0) {
> -                       cifs_dbg(VFS, "%s: Failed to register for witness notifications: %d\n",
> -                                       __func__, ret);
> -                       goto unlock;
> -               }
> +       /*
> +        * Unregister to stop receiving notifications for the old IP address.
> +        */
> +       ret = cifs_swn_unregister(tcon);
> +       if (ret < 0) {
> +               cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
> +                        __func__, ret);
> +               goto unlock;
> +       }
>
> -               spin_lock(&GlobalMid_Lock);
> -               if (tcon->ses->server->tcpStatus != CifsExiting)
> -                       tcon->ses->server->tcpStatus = CifsNeedReconnect;
> -               spin_unlock(&GlobalMid_Lock);
> +       /*
> +        * And register to receive notifications for the new IP address now that we have
> +        * stored the new address.
> +        */
> +       ret = cifs_swn_register(tcon);
> +       if (ret < 0) {
> +               cifs_dbg(VFS, "%s: Failed to register for witness notifications: %d\n",
> +                        __func__, ret);
> +               goto unlock;
>         }
> +
> +       spin_lock(&GlobalMid_Lock);
> +       if (tcon->ses->server->tcpStatus != CifsExiting)
> +               tcon->ses->server->tcpStatus = CifsNeedReconnect;
> +       spin_unlock(&GlobalMid_Lock);
> +
>  unlock:
>         mutex_unlock(&tcon->ses->server->srv_mutex);
>
> --
> 2.29.2
>
>


-- 
Thanks,

Steve
