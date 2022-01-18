Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF37CC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 16:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242917AbiARQYL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 11:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbiARQYH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jan 2022 11:24:07 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8182C061574
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 08:24:06 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id e3so70108306lfc.9
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jan 2022 08:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8bVGbF/R36qoh4Mic/8KJh0/oLABb53Jr0jfqfEBvUg=;
        b=HtorDj2KLNrc/4NI2zoAxM4V8hX30AE6vOBhkFr1plVtJyCvRn6ZNrXm/TPIbf51wF
         eymTPKwBD5V8Z8tmgEhcId7U6DSRSpKdyGRKzVdjIv4+wZ9j1S+R3rlboz2wn4Nhytbc
         Q0+B6H3YJ6xSW7F+GRuHEXjOIp/hZFXdL+8aAvOyxGLAfyzkB0eR7EW9IfPJkohFQDgH
         oCIA4ePg0UNusyo2G8xvYPI8J1kydmXhSciMzgVs6GCNjRWFvkp+tWIFQikqOC7GvmE+
         f4n2u9Yg1cTvWn15fnSbXKp14dymXWjfFjisUQoBHwk36EnuU167BGMMYxPVdVvK2nDo
         BayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8bVGbF/R36qoh4Mic/8KJh0/oLABb53Jr0jfqfEBvUg=;
        b=saY6/cMpSQEXO1t2BmbibtG2NI5q8vqes7XPvluV9fLqV4FvnsTC3XdlVJmF9ugOLo
         zzN+v9VQbRS43i9zTLrThzUOPzdXpoqmQwLYXmT79CRtSLuHEIbpiz38pAorupK8uJRd
         ueVjc89NLaGLR184OD1YQNKO1yJkI8bs7rkrp+6tryh4YNBRx4j662smrXT0PEglsFb6
         Fr3wXyCDZtldvcjfhs3CMPlpLeT5L6osEbCshyWsRGNoRjwitx+fynzles6009XWg6H0
         nYMyZkzQ1gD40EUklqnYyblr1z0jgVmFZ5vRKBA2iPqoBZiDajaGihWvFI/PcFIUuPA8
         1gLA==
X-Gm-Message-State: AOAM531RCOL6SAPwwrR+ScaxMIctIM20wd7l2vWm8SlTRDbr7I4mn3US
        hpxKLyWOaYMCUeyxTfPE23moZug27MjXbfSoaiiVIKBY
X-Google-Smtp-Source: ABdhPJx6W+KA880pD1f6FFvtXZIClcAFYK4kroCDylTxRwaqAonuBXhle2yRXFc25Z2e5dwt0Xj8mcmhnX2iZ1Nr0Hc=
X-Received: by 2002:ac2:4c41:: with SMTP id o1mr22507032lfk.545.1642523044887;
 Tue, 18 Jan 2022 08:24:04 -0800 (PST)
MIME-Version: 1.0
References: <20220118074512.2153136-1-lsahlber@redhat.com>
In-Reply-To: <20220118074512.2153136-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 18 Jan 2022 10:23:53 -0600
Message-ID: <CAH2r5mvcNEbvechpxWDGyW+4WnZtAjQkFLKtineEVraK+67gUg@mail.gmail.com>
Subject: Re: [PATCH] cifs: serialize all mount attempts
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am curious why serializing on a per-socket mutex
(TCP_Server_info)->srv_mutex doesn't work?

On Tue, Jan 18, 2022 at 1:45 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 2008434
>
> If we try to perform multiple concurrent mounts ot the same server we might
> end up in a situation where:
> Thread #1                          Thread #2
>     creates TCP connection
>     Issues NegotiateProtocol
>     ...                            Pick the TCP connection for Thread #1
>                                    Issue a new NegotiateProtocol
>
> which then leads to the the server kills off the session.
> There are also other a similar race where several threads ending up
> withe their own unique tcp connection that all go to the same server structure ....
>
> The most straightforward way to fix these races with concurrent mounts are to serialize
> them. I.e. only allow one mount to be in progress at a time.
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
