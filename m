Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA4CC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 03:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiERDSQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 23:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiERDSQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 23:18:16 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68DA5D5E4
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 20:18:14 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id j2so1617527ybu.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 20:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mnKHZ6yZXjMcV9e7HjNN6uxjcpiLO6/HPremomaM/0k=;
        b=RnXVx5xbRIldXMSPpDpJKjNfsP9HnpBqdlXiKTFXi1kspiz8WoRkeT5MkbQU29X2UA
         PMBTYGPDoIqhdARNKbSOtHI5ovc3nD46fJlwuVsRC8qasqlIppdnvSQEZseMNmXWDicQ
         f3eQuFIvOMVuzoq9T9birbdIUQR3KtDh+PIVIEOIPOABlGC934xw3ofewpZol6JcpgUn
         EU6PUrbFTYh7JxjZr0tB93C0OvFII8lnkY9hzgBoUJEnF2FATT7hID6f9KXeLVtPUBxh
         UxTUFj2o9+qjpvqDwiF3GMbJLsrGvZ7HJn//Nw0xKG0jvuUUtGl5+jW3Fl1SpO9V68k4
         UZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mnKHZ6yZXjMcV9e7HjNN6uxjcpiLO6/HPremomaM/0k=;
        b=mGi72ZeWcJWTcP9uS9QAlggOxohmYGQpdXbH6tfGfMAZVzhtMq/0AeeR3Juxq16PQy
         1yAgfv8sx97bF/h5haT3uGcja6f7p365GfEV7xo82IiidkeGOcmzNkHIYaZHyklIRULs
         XV2EyfnLO5vVk3nfGscu+VjXIP/Is5aCbzbr1qwQpEcRl9TH+YbhYv7Bl7tbEW8pUSJ6
         EKWZ641JJEddxprkRrVMmoGX3BL0HuSua1WEkbgjJ6s+ElEy8V5DNGs5MJCPRSJ9fT+E
         5leHYzmn2mlkurOyrPBXFQwl4VI6nBlsgpPykM2gOyOvxrjM+4k4mM5yB4880Nvr6GSR
         KPaA==
X-Gm-Message-State: AOAM533xduoVrMdmU+Qiiic/uTlmE7WnU+Mgn2QhVOoZ6DJOv1f26Xwh
        HnRwroC7/Qvb8HOtrjLDUuAB6d+3WhfcNM+u9kPVcUzu
X-Google-Smtp-Source: ABdhPJzStwcLvRghsXiJiu+9pme4DhAJb8/YJPzzQBfnt+f+w/CIHk9wJfFP0ddpPnrSvKkpoLFSVgF5VuGkF9WpFrc=
X-Received: by 2002:a25:9984:0:b0:64b:3091:b4df with SMTP id
 p4-20020a259984000000b0064b3091b4dfmr24525902ybo.469.1652843893610; Tue, 17
 May 2022 20:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <91188ht5vqi7kq3ml5d3a48sjo9ltqjko3@4ax.com>
In-Reply-To: <91188ht5vqi7kq3ml5d3a48sjo9ltqjko3@4ax.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 18 May 2022 13:18:02 +1000
Message-ID: <CAN05THT8uZiDC_PS+HYyLAytGOze_nrVkzq9zbHSMiHYpB+3ug@mail.gmail.com>
Subject: Re: getxattr() on cifs sometimes hangs since kernel 5.14
To:     Forest <forestix@sonic.net>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 18 May 2022 at 13:15, Forest <forestix@sonic.net> wrote:
>
> When running on recent kernel versions, this system call on a cifs-mounted
> file sometimes takes an unusually long time:
>
> getxattr("/cifsmount/dir/image.jpg", "user.baloo.rating", NULL, 0)
>
> The call normally returns in under 10 milliseconds, but on kernel 5.14+, it
> sometimes takes over 30 seconds with no significant client or server load.
>
> Discovered while using gwenview to browse 100+ 1.5 MiB images on a samba share
> mounted via /etc/fstab. While quickly flipping through the images, the problem
> often occurs within 20 seconds. Gwenview freezes until the call completes.
>
> Client:
>   kernel versions 5.14 and later
>   mount.cifs 6.11
>   Gwenview 20.12.3
>   Debian Bullseye
>   4-core amd64
> Server:
>   Samba 4.13.13-Debian
>   Debian Bullseye
>   6-core arm64
>
> A git bisect identified kernel commit 9e992755be8f as the problematic change.
> The problem does not occur when any of the following are true:
> - Client is running a kernel from before that commit.
> - The nouser_xattr mount option is used on the cifs share.
> - Gwenview accesses the files via smb:// URL instead of a cifs mount.
>
> I don't know Gwenview's internals, but using its strace output as a guide, I
> have written a potential reproducer. It succeeds at triggering slow getxattr()
> calls, though not nearly as slow as those triggered by Gwenview. I can post it
> if that would be helpful.


Please post the reproducer. It will be useful for testing as well as
verifying if a potential fix.
If the reproducer is simple enough we might add it to our buildbot.
