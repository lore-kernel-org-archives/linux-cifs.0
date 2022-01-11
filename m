Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAD4C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jan 2022 21:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244296AbiAKVlL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244288AbiAKVlL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 16:41:11 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D62C06173F;
        Tue, 11 Jan 2022 13:41:10 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id x7so1289020lfu.8;
        Tue, 11 Jan 2022 13:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfXoAe+Vr+wVYpAjUIwEml+WxjdDvaFLuGHxawax4dI=;
        b=TC0pmGpn3hr9VXbQQ74r4BDQQEllW9JeN3eeTIadmMbbY1D8baGxOFdJEoARQtYMs0
         7D8yUFtaGv6sANxEc/VSM8IRUQjEsreLAa1lcHak9yvBsMYeVPcsnXBnkXzxsGOKOclz
         O08RF+BEf5sjYj6u7PPLyi83lBCM1jkma6PU17aTfrq+xpeoFF61oo1sy41D26b+8CO8
         2IzG+Ble9qig1OIbVABc9RjqPhyUDCR/7NzffXVvDP6MjgGC4HQZ7D5X8VOX+/VlpqUn
         AscMcLncvlESH5uFzqOUx5c53vmwjp77Kag5di+MaNxrMtnll3QS0hdvaCkIKkGC8Gga
         C+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfXoAe+Vr+wVYpAjUIwEml+WxjdDvaFLuGHxawax4dI=;
        b=hXloPi/fDu8XHIE9e+PUbkdubiAq5zi2OgYGY81tzzKzuBgDIf7JjX00jtmDUDdukA
         bOeV+w7mPC/12sIhWc9/QEYtPd0d1EzKs/gv8el2BMR2B7lpl5e+Kgc02PH6+kQ6aTCM
         ytItupMKRFsRFnGWdl47PyNaTTPtmSa5VulVCrbNDe7O2rd9MTMct7RiHS29+GXbG5b7
         LzxNzvOaeiMCiYpaLw9FIvJKktWlPB+uPTDYuJbOX4+uUqTikm8BO1ytFKJ5LIUMrbhb
         OI9dO4kG4u270OO3lIGo5hVfYlOONR17Lss4iOPhOHmGxuDX0u9Kq5KJnEKEM/OCTr+O
         SnWg==
X-Gm-Message-State: AOAM532tVgSmPhSu3DklWggy9gurgGTDPNaS+EVuIjMR4ujSvl85yt2u
        8UmihDFJakXccSvTZWjLC+F++Tu8eo68IzQJsd0=
X-Google-Smtp-Source: ABdhPJw4OLUWqvCpcDqUSuvMj9lAi1g2N7kIL3KMpZb6//moWAFGpxg63qUB5ebSf5RsSu+gcaApisEgWYUhPy39qs8=
X-Received: by 2002:a05:6512:3e02:: with SMTP id i2mr4638095lfv.667.1641937268836;
 Tue, 11 Jan 2022 13:41:08 -0800 (PST)
MIME-Version: 1.0
References: <20220111071716.GC11243@kili>
In-Reply-To: <20220111071716.GC11243@kili>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 Jan 2022 15:40:58 -0600
Message-ID: <CAH2r5mtpdxfAcuThHDs+-UHFf1S=dmSxyXkk2NbaxMwd6FwfQA@mail.gmail.com>
Subject: Re: [PATCH] cifs: uninitialized variable in cifs_get_next_mid()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        samba-technical <samba-technical@lists.samba.org>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

That was fixed similarly a couple of days ago by a patch from Enzo

commit 1913e1116a3174648cf2e6faedf29204f31cc438
Author: Enzo Matsumiya <ematsumiya@suse.de>
Date:   Fri Jan 7 19:51:39 2022 -0300

    cifs: fix hang on cifs_get_next_mid()

    Mount will hang if using SMB1 and DFS.

    This is because every call to get_next_mid() will, unconditionally,
    mark tcpStatus to CifsNeedReconnect before even establishing the
    initial connect, because "reconnect" variable was not initialized.

On Tue, Jan 11, 2022 at 5:03 AM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> The "reconnect" was never initialized to false.
>
> Fixes: 220c5bc25d87 ("cifs: take cifs_tcp_ses_lock for status checks")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/cifs/smb1ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 54319a789c92..6b1b048b36ae 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -163,7 +163,8 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
>  {
>         __u64 mid = 0;
>         __u16 last_mid, cur_mid;
> -       bool collision, reconnect;
> +       bool reconnect = false;
> +       bool collision;
>
>         spin_lock(&GlobalMid_Lock);
>
> --
> 2.20.1
>
>


-- 
Thanks,

Steve
