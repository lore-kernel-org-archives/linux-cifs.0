Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94C6C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Nov 2021 09:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbhKVJcN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbhKVJcM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Nov 2021 04:32:12 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E000CC061714
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 01:29:05 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so73918697eda.12
        for <linux-cifs@vger.kernel.org>; Mon, 22 Nov 2021 01:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1Nw/wamKqCxNQCPnHsnXRdnYd3/HL2OyNDY7VJGOGQ=;
        b=cp+Y91MAiWYK/LJT2eNwpPdgG4aN11K3/6ExwiCyN5BScBWp5G1XWx+yyd5mXxYh+D
         ZWxqkSC08SO4Pa4/SOmt00i66R77TBSQIu2KNajRjWIy1CW3DtQx3mhPTxVPivKqteg0
         +GrIO4YkxmkjUu60sQqIqifh999jAgBP2cdaAfDyTIApu5EUFPouaDx/oLGH2MTZWAlU
         PwYt72YHB8h2KcJqokcs7T48xph2S9genR8rE6R8tBsZHkdMKGIgLoEIweFBZo+jeuBJ
         l1iRCwvArA25aeheq+UgPWvmzFejiNTKaQJQ9i/5py8ES1cEl65OlCQYP2Rvn3S4WCOY
         7xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1Nw/wamKqCxNQCPnHsnXRdnYd3/HL2OyNDY7VJGOGQ=;
        b=y/4E2GRz4vK/Z3oSpPo6O/utc/cTSiuzgeyD5GYs6jwWoDOk/PVbL5K5IuizCYdjSF
         DzI214GGiCk+yCESMaLL4Q3u/qQRnk3m6UBblUfqS2gRwpXorSdHWEwu4o6P12yt3dCH
         4Et1Ok8E5ZSKFjGRv7c8/pJb3XY9bdrUxMgIywutZuoIjUadVMA4aMOCA6rOSgiH0B+g
         h55vQNOzYG3f7xj0GVOG3mc2lqDpIJWFcrlzo7K+DIcFeVr8F0LfkWp7fWg+/apGbQ76
         PV5JUaY5AkdvgU4+JYXfXFuMo17oTX/BjUrOeJ4zFqUUaHtKVjEDKliiWqA+5AmFgIGQ
         0f/g==
X-Gm-Message-State: AOAM532t2WwYS0MM6TsVFARC3eEZK6cJMuP/01cE7XBSVV+UK+IV3uxG
        /Yh+Pn2scSbjpb8E32I0plMfXjX4kH4AxJhmHemmZhctMvfGGLCK
X-Google-Smtp-Source: ABdhPJyBWJAu/a2/6ed7/l/fykF6++Di1TIVbMs5/G+1yH6Cwu9HJPYjdhLy2P9gImfhABkkkGkKT73BhaA2w5iWeDU=
X-Received: by 2002:a05:6402:2930:: with SMTP id ee48mr64642011edb.295.1637573344479;
 Mon, 22 Nov 2021 01:29:04 -0800 (PST)
MIME-Version: 1.0
References: <20211121114009.6039-1-linkinjeon@kernel.org>
In-Reply-To: <20211121114009.6039-1-linkinjeon@kernel.org>
From:   Marios Makassikis <mmakassikis@freebox.fr>
Date:   Mon, 22 Nov 2021 10:28:53 +0100
Message-ID: <CAF6XXKWr0w5hsKgs2QLh+W9=+T2xK_OkNM7_cBjKFSpLfN_V4w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: fix file transfer stuck at 99%
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Nov 21, 2021 at 12:40 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> When user set share name included upper character in smb.conf,
> Windows File transfer will stuck at 99%. When copying file, windows send
> SRVSVC GET_SHARE_INFO command to ksmbd server. but ksmbd store after
> converting share name from smb.conf to lower cases. So ksmbd.mountd
> can't not find share and return error to windows client.
> This patch find share using name converted share name from client to
> lower cases.
>
> Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  mountd/rpc_srvsvc.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
> index 8608b2e..f3b4d06 100644
> --- a/mountd/rpc_srvsvc.c
> +++ b/mountd/rpc_srvsvc.c
> @@ -169,8 +169,11 @@ static int srvsvc_share_get_info_invoke(struct ksmbd_rpc_pipe *pipe,
>  {
>         struct ksmbd_share *share;
>         int ret;
> +       gchar *share_name;
>
> -       share = shm_lookup_share(STR_VAL(hdr->share_name));
> +       share_name = g_ascii_strdown(STR_VAL(hdr->share_name),
> +                       strlen(STR_VAL(hdr->share_name)));
> +       share = shm_lookup_share(share_name);
>         if (!share)
>                 return 0;
>
> @@ -188,9 +191,12 @@ static int srvsvc_share_get_info_invoke(struct ksmbd_rpc_pipe *pipe,
>         }
>
>         if (ret != 0) {
> +               gchar *server_name = g_ascii_strdown(STR_VAL(hdr->server_name),
> +                               strlen(STR_VAL(hdr->server_name)));
> +
>                 ret = shm_lookup_hosts_map(share,
>                                            KSMBD_SHARE_HOSTS_DENY_MAP,
> -                                          STR_VAL(hdr->server_name));
> +                                          server_name);
>                 if (ret == 0) {
>                         put_ksmbd_share(share);
>                         return 0;
> --
> 2.25.1
>

Awesome work tracking this down. This raises a question though: why is
ksmbd.mountd
converting share names to lowercase to begin with ?

I checked samba, and the share name sent back to the client has the same case as
defined in smb.conf.
