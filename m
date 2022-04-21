Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A597C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 02:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383807AbiDUCmg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Apr 2022 22:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiDUCmX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Apr 2022 22:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A60C8DDB
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 19:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650508774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u5jXq0ikUBbT7BOBDMlxZS3HQ2vIua6Sd4Ddv3mL8QU=;
        b=L0p74zrltDjXeZ44WFVtyPHS1AZ3h8e9pInEwj/sQLNe4L+wCbjxepICOiaTxq+8JZn01s
        99pMigsqFA8K6uTz8CmFFwcdluVTTTmea3Cn0wxC6OlJl+AnCkCHGA56iGkK3lqs965sKj
        U6WMq9TNUUTrDKaU6wVfQSfQQ6knVpA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-nG2x6wzhM2KLySmxnyxMRg-1; Wed, 20 Apr 2022 22:39:33 -0400
X-MC-Unique: nG2x6wzhM2KLySmxnyxMRg-1
Received: by mail-ed1-f69.google.com with SMTP id eg29-20020a056402289d00b0041d6db0fbc9so2302743edb.9
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 19:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u5jXq0ikUBbT7BOBDMlxZS3HQ2vIua6Sd4Ddv3mL8QU=;
        b=fOcE8u/nyvo8TabQ2FU+iCovowWvwQQr6iiu6EI+kBUApUz+wtpx8wPUYeho4vrR6u
         hg6bsBLay3qELCX+grVW4pMFwWRhDGUfMTM7qoJ4Ea8J1JBnB6jEeFqRfuT/mgctaneb
         smpUq+44taxp7wvMQ0hVMncoMqDs5pW9KGYd5250zlq+S7gc8NTdV2uVlLX/ZZewtofh
         GGuuQD1PEsKFcBnoAQFE6Y+m9ExHgNe1rXvSYAlf8LLyzPzGDpcedmnzL8RgKj0zKBmd
         xy7D5lkbKDKHT52UFBr2XNswAx7Old1r/rTXoIBysQUjZILTrPyDFuYNl6BTFZkrubnt
         I/Fg==
X-Gm-Message-State: AOAM530NQ5gjHHrsoxPYCj/kMLI/u3IugDtcYIn9FL8BfvuaLYqxCegy
        4DzeX2RU7P4iuTGluQInPOML0HRLC1wZPPcxwjnshikDzgtLd2g/oRanum9Z1aR+Y/JOTPRxobu
        jSL2s62nvELH26f+sEoKhuqm9PpvkcvgGqOh6ww==
X-Received: by 2002:aa7:c40b:0:b0:41d:9886:90a0 with SMTP id j11-20020aa7c40b000000b0041d988690a0mr26088301edq.275.1650508772246;
        Wed, 20 Apr 2022 19:39:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDjJb/72uZ3+xnQSh0+4s9Q1p+EabYl0myy/V7P8P0W9WRErw3nmEfDHPnR4EqgFm3vZNqnDa+9VIsUBKKFmY=
X-Received: by 2002:aa7:c40b:0:b0:41d:9886:90a0 with SMTP id
 j11-20020aa7c40b000000b0041d988690a0mr26088292edq.275.1650508772121; Wed, 20
 Apr 2022 19:39:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220421000546.5129-1-pc@cjr.nz> <20220421000546.5129-2-pc@cjr.nz>
In-Reply-To: <20220421000546.5129-2-pc@cjr.nz>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Thu, 21 Apr 2022 12:39:21 +1000
Message-ID: <CAGvGhF7R4dyohbTg1+zVNiLpHp2x_oe3E+uFQZSr8fK0cspagA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: use correct lock type in cifs_reconnect()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "French, Steve" <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

looks good to me.
Reviewed-by me

On Thu, Apr 21, 2022 at 10:06 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> TCP_Server_Info::origin_fullpath and TCP_Server_Info::leaf_fullpath
> are protected by refpath_lock mutex and not cifs_tcp_ses_lock
> spinlock.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2c24d433061a..42e14f408856 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -534,12 +534,19 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
>  {
>         /* If tcp session is not an dfs connection, then reconnect to last target server */
>         spin_lock(&cifs_tcp_ses_lock);
> -       if (!server->is_dfs_conn || !server->origin_fullpath || !server->leaf_fullpath) {
> +       if (!server->is_dfs_conn) {
>                 spin_unlock(&cifs_tcp_ses_lock);
>                 return __cifs_reconnect(server, mark_smb_session);
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>
> +       mutex_lock(&server->refpath_lock);
> +       if (!server->origin_fullpath || !server->leaf_fullpath) {
> +               mutex_unlock(&server->refpath_lock);
> +               return __cifs_reconnect(server, mark_smb_session);
> +       }
> +       mutex_unlock(&server->refpath_lock);
> +
>         return reconnect_dfs_server(server);
>  }
>  #else
> --
> 2.35.3
>

