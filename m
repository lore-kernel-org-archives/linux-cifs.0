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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C4FC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jan 2021 01:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32ECD64DD1
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jan 2021 01:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhA1B0B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 20:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhA1BZ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 20:25:58 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66BC061573
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 17:25:18 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id c18so4385134ljd.9
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 17:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WLd3m2anYlo17qAtsO8VgbCYDsIU6XiczphB8GO6huw=;
        b=SoKadgDRoNoj6UGC70fPujkcwFTJbTZfdsCRUZ7zFqhFFp9pN/Vfepmhlr+k6H8BdN
         YCfzmtJlJOvlwg4zd2SEGF+Q/MLsexpz89EyBqjVpiWMszoNWHYD7cZmOl7tHdLcQrN2
         TwYn6jMVIAnJRn+H2gHlW8G9kbdSJuq2CcJeofCMiQja+n4vMXBdR6XjYK0x8TWbieUg
         C8bCJDZPtBIG8vrFgYyQyq//qeeKqTDDPhEVOmseAzuoh8Wx8Hs4HrTmYxtwvhUFjZQZ
         SHMUrHc4vk8pjq6Gqka2r7r0v3/ELIF2eIh1Uv7rWTQgM0n7xDyeHwPG3NgAKS4ILkdV
         AecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WLd3m2anYlo17qAtsO8VgbCYDsIU6XiczphB8GO6huw=;
        b=VM0Mo4zHmM8X+zSlhJpouO2x1pMo2tfbNmIULixI+/TqAf4bUJDOWVGSRxY49w7gYn
         39knbHYjYm7XwqHrsssb5HY3YaQ0YIpgIHd993P5NV68rfSq6eEtq2wmgQF7UPTPWJRv
         BMlatGhmqa+HP2VBdbs925NbOBEj0YmxGBwt5UqOzDdfWgY+PbNebNvLw9wn6PWCloQ7
         FNO5d04s+/S+Ft5Lig7L2zX5maghgsqHa6fFQp5ISDM90aJUWtjpv/PmjqUIOuoLytP0
         QGVWiRVVKpsLEeZxkMIc+XWCU5uMsoyGrMdh2oHhQS/cO2xGjsIlxbIyHDKi1ifRFo0S
         hsag==
X-Gm-Message-State: AOAM533vHAZ9O9kMaA5++VBrO62vBzVbG8SEiW/eJ2kMH8/YpifbFNFh
        xkSuHWkxuUR77/PeAK7iivE/vX2LTDPPAZn7ciTUGdsX24Y=
X-Google-Smtp-Source: ABdhPJxWx9kEFeFSk0sDQudKK0YOVgZ5UA6BjqHXogEnSCpCA4PfEhO0jaEzg5vJiwYvrIo13R0FVIpivr56+A03XGQ=
X-Received: by 2002:a2e:86c1:: with SMTP id n1mr138735ljj.148.1611797116842;
 Wed, 27 Jan 2021 17:25:16 -0800 (PST)
MIME-Version: 1.0
References: <CADajX4DzoNehHZGqpd+3Bh0yM2U=B6AwL6bJ2EM6t6hkvr7L4Q@mail.gmail.com>
 <20210127214434.3882-1-adam@adamharvey.name>
In-Reply-To: <20210127214434.3882-1-adam@adamharvey.name>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Jan 2021 19:25:05 -0600
Message-ID: <CAH2r5muXg8-8vQGXXq_4JO_HgnUkvzkPcOpU3FsBJC9YsbJvxA@mail.gmail.com>
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

Merged into cifs-2.6.git (seems harmless, and probably slightly safer
to include this - even though currently I can't reproduce the reported
problem).

Let me know if anyone else has been able to reproduce it - even with
Adam's suggested /etc/fstab line, I wasn't able to repro it.

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
