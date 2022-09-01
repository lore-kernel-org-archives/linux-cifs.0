Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9906BECAAD3
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 22:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiIAW1x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 18:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbiIAW1i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 18:27:38 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B598F3FA11
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 15:25:30 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id n18so202587uaq.5
        for <linux-cifs@vger.kernel.org>; Thu, 01 Sep 2022 15:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5mqh9UXmkuXOTh6qYvVQLpFrtlmJnOHBDf6chgx9Gms=;
        b=SRSzX6gckrUhKLOa91bgoJbeBGC3dNL0HqY/pwBhFhR7SHvI+PF89S6L0PE7QgN79o
         haHhUoP/g7dLlM1UgsSzuys83EgBCeN9PEaXSX9ihDFRHBeh5uMDiPnV6okS9FF9e8DU
         BUB89Lu/m7H1y8bj644tQVDrq22RcdBBNeCecr5b/Tp8MsxDB3HYio3tYoiB38/yKpOA
         0F68HjZY6I1aYe9rMVjA+hLaw5/TdgYzv3U3TzkoHalPUUuN3bwMlDh/kBt+QNcgYkpU
         ClOhQ7uwWPnD5OaWoMqxO0HwRsmOj6JcBOhsJ8ZuLrPMtpWc/7faeH7gVpkJeFW1IZyD
         Y0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5mqh9UXmkuXOTh6qYvVQLpFrtlmJnOHBDf6chgx9Gms=;
        b=emJCu2K79rH/ybStV6gSdbRlQyQLqte/eH7e1PO4p8dcCwwrHEEAshfI1IcAIuwcXI
         NPsQ1dWbaV3uZTYZRxs4PNnwQ12znTdxZpOI4qw34YJHJGuJ9HlYgnmuj6d6GuF974R4
         Ta6v53OQRzILDSArhUn06LSxM/K8i66siWYYS5PjuE8fdfWQaVk9R5UjFCNBU5Nm46ym
         EXCNioDFqxUh7bZTGpL1O1RdkzLO51/iQ+jLTpSAHVQntL/trj8wjXJ2GKEVOc5DODmX
         bmZwfGE4AQuNtl1mmU4VaWC/+2NNjs10lgekJvGA8vQMW3FPi1BzHELBP1WlQpBnE95U
         iggw==
X-Gm-Message-State: ACgBeo3+0M+gQg0yTUmulr3m0zP3sRA0woOdu107vUahtGjoVDwhYNo/
        f4oRxxX0WrNGKdaMgToZpMMmWovmPPUHAdRwxrQ=
X-Google-Smtp-Source: AA6agR5QrBk9yqKvxBE0C8o5s5NzsUYSpoN0EU6YWVbOC3PxiEE8Ba8XSx/ZK/SBETtXTWcOCfom0vydxJRcvFTMhE0=
X-Received: by 2002:a05:6130:10b:b0:37f:a52:99fd with SMTP id
 h11-20020a056130010b00b0037f0a5299fdmr9584161uag.96.1662071071115; Thu, 01
 Sep 2022 15:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <YxDaZxljVqC/4Riu@jeremy-acer> <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer> <b6a1bc91-0aae-2520-9fb8-dfe6caa46315@talpey.com>
In-Reply-To: <b6a1bc91-0aae-2520-9fb8-dfe6caa46315@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Sep 2022 17:24:20 -0500
Message-ID: <CAH2r5muR48e+x1DNiV3=oRvwBC6exW6Xg_bGVfu2OGQovqUoQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     Jeremy Allison <jra@samba.org>, atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I do think that one obvious thing that is missing is a simple python
script or slightly more complex GUI tool that would allow better
autoconfiguring a share for ksmbd without having to understand the
ksmbd.conf/smb.conf format (and a different tool for Samba - although
to be fair for Samba various vendors and some distros have tools to do
this), but in the short term, a few more example smb.conf/ksmbd.conf
files might help (maybe in the wiki?)

On Thu, Sep 1, 2022 at 1:52 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 9/1/2022 2:30 PM, Jeremy Allison wrote:
> > On Thu, Sep 01, 2022 at 08:41:08PM +0300, atheik wrote:
> >> On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
> >>> On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
> >>>>
> >>>> Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
> >>>> as you say that should be man 5k smb.conf. Sounds ok to me.
> >>>>
> >>>> But the second thing I'm concerned about is the reuse of the smb.conf
> >>>> filename. It's perfectly possible to install both Samba and ksmbd on
> >>>> a system, they can be configured to use different ports, listen on
> >>>> different interfaces, or any number of other deployment approaches.
> >>>>
> >>>> And, Samba provides MUCH more than an SMB server, and configures many
> >>>> other services in smb.conf. So I feel ksmbd should avoid such filename
> >>>> conflicts. To me, calling it "ksmbd.conf" is much more logical.
> >>>
> >>> +1 from me. Having 2 conflicting file contents both wanting
> >>> to be called smb.conf is a disaster waiting to happen.
> >>
> >> ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
> >> Samba when it comes to the common subset of functionality they share.
> >> ksmbd-tools has 7 global parameters that Samba does not have, but other
> >> than, share parameters and global parameters of ksmbd-tools are subset
> >> of those in Samba. Samba and ksmbd-tools do not have any conflicting
> >> file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
> >> collide with and never overshadows smb.conf(5) of Samba. Please, help
> >> me understand what sort of disaster this could lead to.
> >
> > Samba adds and or changes functionality in smb.conf all
> > the time, without coordination with ksmbd. If you call
> > your config file smb.conf then we would have to coordinate
> > with you before any changes.
>
> And vice-versa. For example, ksmbd supports RDMA and can be
> configured to use interfaces with kernel-internal names,
> for example "enp2s0" or "mlx5/1". These files do not in fact
> subset one another, in either direction.
>
> > Over time, the meaning/use/names of parameters will drift
> > apart leading to possible conflicts.
>
> Personally I think they're already in conflict, having taken
> several days to work them all out wile setting up my new
> machines. And, um, I think I know what I'm doing. Heaven
> help the newbie.
>
> > Plus it leads to massive user confusion (am I running
> > smbd or ksmbd ? How do I tell ? etc.).
>
> +1
>
> Tom.
>
> > It is simple hygene to keep these names separate.
> >
> > Please do so.
> >



-- 
Thanks,

Steve
