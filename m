Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0A0ECAAD2
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 21:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiIAVhf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 17:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIAVhe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 17:37:34 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B22975FEA
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 14:37:33 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id i1so196997vsc.9
        for <linux-cifs@vger.kernel.org>; Thu, 01 Sep 2022 14:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=FGOsEvYylSdEAN4G9DpvLcYH40lfqNxR+hHuauVoHeE=;
        b=OvloGDHRylQaE2YduHELhqCYiadWb0FZpJzCdV2sj1BNLnjA5hruFCFlwC9QMorhdm
         44GrLsWGpG8gHE2GuldBrR/EwPDs2qcI2AVemae5u0txZ26bu1BpPp4g6cogEBzFvOJF
         xRrdscadozuGrOxxXcSRUseLsNyOcvs2n1PzbXVF+hE29wPuI8ODv0FDY/Bf5mRsjdM7
         SpbIHfnO5reo+Tit2Jp97d5zr+ShoQOLlWUfcMlnf68Ie+xBgYRR+UFLkXb1H4JH+T7I
         wg0hj02ZBal63Gvfbf1Dvf+2ZSa7bMlI15PeMM8HGiyMsSJX3I1t4Ob0ox9HArXMXldC
         xXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=FGOsEvYylSdEAN4G9DpvLcYH40lfqNxR+hHuauVoHeE=;
        b=pPjpJY9y7XkpGegpvdNOxV3o3v00MgIgG6rZYNctegFsSf0ln+oFOYyEy5F/iy09ns
         KIF0XS0ARzB2hrtK/htbNdCFsWKCiy3KzU2MDYIOyYebzEH8WN+vjGopHwxfmSfGNi/j
         E45oqKpPuaU7t6RetzyWTf8bFh1NONCIZx8fdk+UYnP8AMIbbI/PFz93k/zp75pth4C6
         hpz7JQgzAlhpxw1jyP1ITOOfwgUyd83fJ4g/vrzKnGHOf/ovUZzvJGQOEu2wq+MpoNtR
         vrAeaSbvheM3w8EpbqQh7BQLn2VEspgy3ElSvIuYoCkzOjeCSmkLUM6bW2vPdNsHKpHW
         5gLw==
X-Gm-Message-State: ACgBeo0Hor25tIAn4qG+Z9M6Lx63+3HrFq4cmKgRGwpg2pPMu3vD0GPz
        PizjxAkdDp6m3F1BqppfhVV9PbyIxOXZZ9f29Hg=
X-Google-Smtp-Source: AA6agR6IMYXyAiB0lYFIMb6jYvO0O4fk7SL7MpBBqVi1KXUzFVMLYjHwnmWrEz0YWdN4bKwhrXUlfERB5LvgVsYfLBo=
X-Received: by 2002:a67:ce90:0:b0:388:4905:1533 with SMTP id
 c16-20020a67ce90000000b0038849051533mr10239523vse.17.1662068252259; Thu, 01
 Sep 2022 14:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <YxDaZxljVqC/4Riu@jeremy-acer> <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer> <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
In-Reply-To: <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Sep 2022 16:37:21 -0500
Message-ID: <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 1, 2022 at 4:21 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Fri, 2 Sept 2022 at 04:34, Jeremy Allison <jra@samba.org> wrote:
> >
> > On Thu, Sep 01, 2022 at 08:41:08PM +0300, atheik wrote:
> > >On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
> > >>On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
> > >>>
> > >>>Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
> > >>>as you say that should be man 5k smb.conf. Sounds ok to me.
> > >>>
> > >>>But the second thing I'm concerned about is the reuse of the smb.conf
> > >>>filename. It's perfectly possible to install both Samba and ksmbd on
> > >>>a system, they can be configured to use different ports, listen on
> > >>>different interfaces, or any number of other deployment approaches.
> > >>>
> > >>>And, Samba provides MUCH more than an SMB server, and configures many
> > >>>other services in smb.conf. So I feel ksmbd should avoid such filename
> > >>>conflicts. To me, calling it "ksmbd.conf" is much more logical.
> > >>
> > >>+1 from me. Having 2 conflicting file contents both wanting
> > >>to be called smb.conf is a disaster waiting to happen.
> > >
> > >ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
> > >Samba when it comes to the common subset of functionality they share.
> > >ksmbd-tools has 7 global parameters that Samba does not have, but other
> > >than, share parameters and global parameters of ksmbd-tools are subset
> > >of those in Samba. Samba and ksmbd-tools do not have any conflicting
> > >file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
> > >collide with and never overshadows smb.conf(5) of Samba. Please, help
> > >me understand what sort of disaster this could lead to.
> >
> > Samba adds and or changes functionality in smb.conf all
> > the time, without coordination with ksmbd. If you call
> > your config file smb.conf then we would have to coordinate
> > with you before any changes.
> >
> > Over time, the meaning/use/names of parameters will drift
> > apart leading to possible conflicts.

I do like that Namjae et al made the format of the .conf file very similar
to the format of Samba's smb.conf file though.   I realize there some
users complain that there are too many smb.conf parameters for Samba,
but he seemed to pick a reasonably subset of them for ksmbd.
Samba is a much larger project with many more smb.conf parameters
but it does reduce confusion making the parameter names similar
where possible e.g. "workgroup", "guest account", (share) path, read only, etc.
and fortunately the default directories for the two smb.conf files are
different so at least the daemons don't use the same file.
-- 
Thanks,

Steve
