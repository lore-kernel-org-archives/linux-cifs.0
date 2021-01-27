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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C8CC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 23:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB7E564DD9
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 23:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhA0XTx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhA0XTL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 18:19:11 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5DEC06174A
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 15:18:21 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id t8so4102043ljk.10
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 15:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rWAxWSWKCDf3ARolITXWp71Ne/Vli8JDIqInwII5HOY=;
        b=UgOrYD7CXSiIjfOQifNdCdbJsHd2CoS6VOHUNvZ2ZByyqY+qfYp41wsIVZX/D6GKi8
         ItPJZi0Cl1uymjrD01p63QJfnUd45Kk9a5sO8Qc5JKvPLR+ohHNNTcPYZ5wZfWkHRdBE
         jly8kh9bBVVOjNGxj11/CVauRtiqqoNYIF5saxl3VTddPIfmB16kTMRiG/rcTeEtSHYP
         pnHWaQDmoYiw2nXG7maZ+NuHIoSpNQhIm8S1GvGSfBM6SyLg0FmH8NtsNIQvfB0Lhr/V
         +4j81Bv6yoke+1EatUYiUEwbhETfHcCIEraJrzjqK7CczzLVek3OW1CZLoU8msn4pIJF
         QQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rWAxWSWKCDf3ARolITXWp71Ne/Vli8JDIqInwII5HOY=;
        b=OQDwTm2yIK0KkkqJP4dPqiHHe0npP1hbL78XgodsuUCcPChqzaZOTEgFoaqf5A9pvF
         wYNegaPtuvAIl4uheyJdQl2Q+XG5c+HsrGasGAKJzFLI8+AClSfSE9qH+mE4XX2ug0pQ
         bNL6MFdX5nWfMbahsmNd4MSTj4s83UinsV3uEH8QOGAokCYud4jA30/Zz5t8KuqBQRK2
         4RjbriN6YpwNGPp5r76m9Uiw2OSScFEEYy1TO98EWtIN/0tlC0HOJsHWBgGSIk3wAQmd
         jeXwbxrx6PkKm220/6r48fSlLpsUPCvJYwcvN6MaO9E3BB/YZHcRuFOE0CGVgB3LcQ6y
         MhOQ==
X-Gm-Message-State: AOAM531+0WMIu4MwvLNWS2y6JRmrGDdNkyio8Ue41bQ8E4jvZbubN9wI
        BFZhXyx7dSOWmOS44rJzqOV2xbjmIxu0VilZOXM=
X-Google-Smtp-Source: ABdhPJy6LIYtGsZW3+f3pbnpRMTflDJLSVG/OqHsZnOpUh5R4en0XT0oV28xGBYcQpr1T5oLrYNuz1T3yXftU3z0tAc=
X-Received: by 2002:a2e:9d8e:: with SMTP id c14mr7079964ljj.477.1611789499678;
 Wed, 27 Jan 2021 15:18:19 -0800 (PST)
MIME-Version: 1.0
References: <CADajX4DzoNehHZGqpd+3Bh0yM2U=B6AwL6bJ2EM6t6hkvr7L4Q@mail.gmail.com>
 <20210127214434.3882-1-adam@adamharvey.name>
In-Reply-To: <20210127214434.3882-1-adam@adamharvey.name>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Jan 2021 17:18:08 -0600
Message-ID: <CAH2r5ms5FXALbcfvfXo7bR7WXEzCk-jeosoQWk28DdUad++qEA@mail.gmail.com>
Subject: Re: [PATCH] cifs: ignore auto and noauto options if given
To:     Adam Harvey <adam@adamharvey.name>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch looks harmless, but am curious if other people can repro
this.  I tried it on 5.11-rc4 (cifs-utils version 6.11).  I tried it
with and without the mount helper (mount.cifs).  I couldn't get it to
fail with 'noauto'

Anyone else able to repro the problem?

On Wed, Jan 27, 2021 at 3:44 PM Adam Harvey <adam@adamharvey.name> wrote:
>
> In 24e0a1eff9e2, the noauto and auto options were missed when migrating
> to the new mount API. As a result, users with noauto in their fstab
> mount options are now unable to mount cifs filesystems, as they'll
> receive an "Unknown parameter" error.
>
> This restores the old behaviour of ignoring noauto and auto if they're
> given.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Signed-off-by: Adam Harvey <adam@adamharvey.name>
> ---
>  fs/cifs/fs_context.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 076bcadc756a..62818b142e2e 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -175,6 +175,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
>         fsparam_flag_no("exec", Opt_ignore),
>         fsparam_flag_no("dev", Opt_ignore),
>         fsparam_flag_no("mand", Opt_ignore),
> +       fsparam_flag_no("auto", Opt_ignore),
>         fsparam_string("cred", Opt_ignore),
>         fsparam_string("credentials", Opt_ignore),
>         {}
> --
> 2.30.0
>


-- 
Thanks,

Steve
