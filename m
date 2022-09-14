Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC2FECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 05:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiINF3B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 01:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiINF2y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 01:28:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BAB6C768
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 22:28:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a26so3404758ejc.4
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 22:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=BzT0PePZlBjNzr2eqXEA1QVqN3HYoWiGqky/r83OEq4=;
        b=Tg6UbrH/j9/S0aF1FHwQULYri71qV7GoA1THwHgEeKj7+a85dy+Php8mgbLcCxWXet
         yh59KAJGPe0N7m9xsPupY7XMH19CnTQYZbouLtVJeXpmw0Asq/Dpg8OVqy0t+Fcab+Ze
         Gx5BTzIbjvpDmUFB2FV3B5Epx2vwpiPLBp2pU2jeATY46OPa5+G5xWrMnfmYU1zuP2rz
         D+EXGrqINjZ60vUnd9kkntOUOu+p9WkBBIQ5PlpfYHwGIU5D724rNgQbazB/oQTsv2MA
         232BveQCmkHzDzc1TsFotfBYgUabk58Hi4fyMVPZ8wqd3IAkoAEaWgTy4Y1RnGgqv7yQ
         cjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=BzT0PePZlBjNzr2eqXEA1QVqN3HYoWiGqky/r83OEq4=;
        b=66lXdRZByfYSR3g1Zuc6w3c4T11CEtetMwtiPeI2R75/FVOgOIsd5NUJNLyQAG3+Q7
         xhylT2vpOrYC5voqKC95XKb0iQ/ZwW98gcuho//EEAUCC4se+0ixtXBSzRhTYtkqruHh
         UgN+im98lwxpHWux+QU7kEXup9wN2KiP+/EL7KybPpMnh5mrMSckn4Wl78hFgQh23OEP
         Cu+ViYebLbkPhDLcWaYcKkzxUkOAFk9GBzTruHNJRZt3lHBM/xQgBQQrg3GY9SgoDlhA
         8u9WHM0kR735dAC0vocxo25JN9vbZ34qfPMBq59WoOiwqqAwOJlljBAweZTzQ81lcxCw
         fP4Q==
X-Gm-Message-State: ACgBeo27MJDwQCHSM5PYkLTUFmhxYe3r4PhKWbYCjuuxjDgcXDnDNkK8
        hMxRUDmNfUFxYoWAnlLuUOsTG9wYsWQ7wefPCu4=
X-Google-Smtp-Source: AA6agR6Rc9GlSDMrRq8y98HCEfG5b/aSv8RmqbSO23gu4cfcR+bHxDWIQP3yW7oCfJZIXZRY/GiCl+PBt3L5AYNxSmE=
X-Received: by 2002:a17:906:4548:b0:77d:3c16:2e9b with SMTP id
 s8-20020a170906454800b0077d3c162e9bmr9933878ejq.757.1663133314513; Tue, 13
 Sep 2022 22:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220914043451.18797-1-pc@cjr.nz>
In-Reply-To: <20220914043451.18797-1-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 14 Sep 2022 15:28:21 +1000
Message-ID: <CAN05THR1nd8crCNxe=pVdo0WGKM6BvVFRZCOE_GrDZZkZ08Qeg@mail.gmail.com>
Subject: Re: [PATCH] cifs: add missing spinlock around tcon refcount
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM

On Wed, 14 Sept 2022 at 14:47, Paulo Alcantara <pc@cjr.nz> wrote:
>
> Add missing spinlock to protect updates on tcon refcount in
> cifs_put_tcon().
>
> Fixes: d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 251753d0a54b..23fc48aa2ed6 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2350,7 +2350,9 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>         ses = tcon->ses;
>         cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
>         spin_lock(&cifs_tcp_ses_lock);
> +       spin_lock(&tcon->tc_lock);
>         if (--tcon->tc_count > 0) {
> +               spin_unlock(&tcon->tc_lock);
>                 spin_unlock(&cifs_tcp_ses_lock);
>                 return;
>         }
> @@ -2359,6 +2361,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>         WARN_ON(tcon->tc_count < 0);
>
>         list_del_init(&tcon->tcon_list);
> +       spin_unlock(&tcon->tc_lock);
>         spin_unlock(&cifs_tcp_ses_lock);
>
>         /* cancel polling of interfaces */
> --
> 2.37.3
>
