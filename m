Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDE4C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CDC464F03
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhBYS0X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhBYS0W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 13:26:22 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A87C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:25:41 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id r25so6630606ljk.11
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIKwveMbSpfjvRXdXiKLrlqGX8NLzgXC7SM99fMwuYc=;
        b=mhivKdrE87rkaHnAClRmvsrZvBsjq3p26kUHmx1DaTj0wqMQBYbaCoNSESsg7sISP9
         7EMG2JHGxfgVvMQjT4GVo+D0GfyT1IYkL/rHK8yXGhg2TcnHW/ux39sPgTVvSQ7vUEn0
         +AB4A0V35W/wLKGa/UaP9CrEPxF7N1jbh/83OV5pd5czXiSiUo1fwjxhDnV5msFjd/4y
         OI+JaxEd+1/0Xa5+v9O6Ji8boQtIEsxDVsYlSqAnNJTrUvoBpdrvrTEB3dqLz58xe27R
         pVG4s8hexnpY9BYctwHlb4RjDjaEYVCDRhy1+6BptiFo944iX5ry7Iy0zpW+Ka2N3Z02
         XAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIKwveMbSpfjvRXdXiKLrlqGX8NLzgXC7SM99fMwuYc=;
        b=RqJC299Yy48Eb9KSU+5qpaz/CGem8zUS5MLlAtbztT561FkSutduNH2hY7ay5EMjOj
         7JHJf94JPJ/xsFRlg8w8IkUvBjvyALhibisgFKSprVqG6VHV4zcaXfq+3Xa1WMnVh+ua
         /o7KFFDc/Pl9gIx0ft5quYoaT1GWxbq8/KbEL6DlwpKFvFVkkVZtR4N3JFbfhuVtCn5a
         K0Du7+nRw5Ca1UCi7IAXIqpSI2cFtrIbYU4cvwtNZ+lameZ9ww8sMOfzZXTm76HLgU18
         HGlOOFRaHcU0l2uXF/PyJ1mg/Vibvk1sd5fsrYximpY5fyYonfOrn+gyFJPFzkcwHg6o
         8q1A==
X-Gm-Message-State: AOAM532p60pQZquK3TIGyH+hfc5HmZl858Wv4OvHGwxd6JYejZ5X2Ajp
        4zO6Z70H5SZyfEpR17J0wZMdssHOcOcPmmJR2Vw=
X-Google-Smtp-Source: ABdhPJzzWRRE5dFk/6lUX1kTVjm0/WL7yBHRH1OXOTG2hysf9AHWxYnNVxXkWWy9jztL+lhypdZAstnX3+xY4Y5C8bA=
X-Received: by 2002:a2e:a36d:: with SMTP id i13mr2249173ljn.148.1614277540112;
 Thu, 25 Feb 2021 10:25:40 -0800 (PST)
MIME-Version: 1.0
References: <20210224235924.29931-1-pc@cjr.nz> <CAH2r5muMt3gmmtLOBxaOqqh-KfccSDDuta6ob218_w9WQZdmbA@mail.gmail.com>
 <87y2fdszy3.fsf@cjr.nz> <CAH2r5mt3HTJYi=TP0YF+zPfYrN0Qj56rK0grMbodsN8Xkdny+w@mail.gmail.com>
 <CAH2r5mvsGLERYD0AhwZcB5oAeRXRMSh+U=r=dOq88O3mpz+ZwA@mail.gmail.com>
In-Reply-To: <CAH2r5mvsGLERYD0AhwZcB5oAeRXRMSh+U=r=dOq88O3mpz+ZwA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Feb 2021 12:25:29 -0600
Message-ID: <CAH2r5mtQ4ENCH2koC7-YBnMrksdaJPXEc-J4_m4Yp7S2LQdfAQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: fix DFS failover
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I also added cc: stable # 5.11

On Thu, Feb 25, 2021 at 12:25 PM Steve French <smfrench@gmail.com> wrote:
>
> I pushed the 4 in your email attachment to cifs-2.6 for-next
>
> They differed only in patch 3 from the one in dfs-fixes-v2
>
> Let me know if the correct version is in for-next
>
> On Wed, Feb 24, 2021 at 9:34 PM Steve French <smfrench@gmail.com> wrote:
> >
> > git diff dfs-fixes..dfs-fixes-v2      showed no differences between
> > the two branches
> >
> > And should we cc: Stable #5.10
> >
> > On Wed, Feb 24, 2021 at 7:23 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > Steve French <smfrench@gmail.com> writes:
> > >
> > > > is this series of 4 identical with
> > > >    https://git.cjr.nz/linux.git/commit/?h=dfs-fixes-v2
> > >
> > > Nope.  Please pull from git://git.cjr.nz/linux.git dfs-fixes
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
