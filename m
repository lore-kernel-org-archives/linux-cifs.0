Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA399C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Mar 2022 17:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244512AbiC1RPO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Mar 2022 13:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244513AbiC1RPH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Mar 2022 13:15:07 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA6C25F4
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 10:13:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r22so20136405ljd.4
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 10:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2HN4GpuD8pMVmmtB/bCz1f2XAWLvYFoM8+ZwP0eeB6E=;
        b=Uh9TLOGaTfmrrRkB9lasCeTC5FXtfj/QMeTMW6/IBbSTFuFLmaHwNVtn9mnHnb1acy
         VlD2/SQl6K+RvO36EUEwzy04jfWdwFqjcFw2A3/kA5LotJLKJLJ0Wq9fu8XzSuwGpuXK
         /AL8ni41oRsmM/lDKFIl5+NHtN4U2m+88T1ZWm3gbjhR0cO0osfhXdADLTFHtIJmj8wB
         qAJy20ziIz+qoERE2DVJNmst+G/2WHR3v8Gyj+0/eWXcaaRZnhzwgmRBivHuB/Ilv/tA
         mTCbM6pa5Ci+FUanMD+LTfMpAGsvsOsnYGtsaumh3qNQK6EmzNZ0zuXm8b+/sO8dsR9y
         4UJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2HN4GpuD8pMVmmtB/bCz1f2XAWLvYFoM8+ZwP0eeB6E=;
        b=Vun1v0wX6Skhab6T7LHvKB+l4hMgewhz2S4XXtgCoBfjZontnC4UM1SDgfxGF9Vva/
         NqlWjvxGQndKjJCJZVMQKDAexJa/tHRRcMBE2dGTBWsJrMvyU9UfvVxXhiK4SPePTb7R
         Q3BaAr885wt0NVbucmcEB5D69mYDCy9YFwyeoxWcXjU869DvR53R6YVPrr1jUWv8/CjC
         DHJJcyjYFV4/hL/faui+RiE0ELflFK2YSndMHEE1uJr6Vw5j8FfgI50pLByUHoZbvzjS
         dO7m3JYAPuXDfuSaoRJXfsn1ZNdknpRI8sQOrNm2qrw4QOPeHugtsbG3R1bNcILOeYKd
         NWlQ==
X-Gm-Message-State: AOAM532POqKFcNtWqBbsIunARUATakF2k07SBO4fRzefqtmKML2Abvdk
        Lo/VyKZogiZ3/Q4iIqqXDMY8x9OlchnWbKCN5I0SLCqs
X-Google-Smtp-Source: ABdhPJwO3vU25IvnVsIhRtNNdSRNLDZzwCbejzmUacmUisRn1jGzoyk6yUCHm5P8w+pHbkiwMtnmUZsLspbZTg1593o=
X-Received: by 2002:a05:651c:1597:b0:247:f79c:5794 with SMTP id
 h23-20020a05651c159700b00247f79c5794mr20836665ljq.398.1648487601315; Mon, 28
 Mar 2022 10:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msLJ166+yuHWQnV7_10_SZ3R1RmMwgLyGMBbggcYks1hQ@mail.gmail.com>
 <CAH2r5mu7q4yUO-qgY+A=Gjv4cDWGZrhHi0Yr01Zx-W1nE36Rvg@mail.gmail.com> <CANT5p=rUKVw4L5R6QsX+pHgRR8_hg3C+K1YEM==YAvLMLZ-0qw@mail.gmail.com>
In-Reply-To: <CANT5p=rUKVw4L5R6QsX+pHgRR8_hg3C+K1YEM==YAvLMLZ-0qw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 28 Mar 2022 12:13:10 -0500
Message-ID: <CAH2r5mu5JWP4GYLTVdbwwp+b=b+u-7QHi_cLYNwYGK4zkvwqbg@mail.gmail.com>
Subject: Re: [PATCH][CIFS] cleanup and clarify status of tree connections
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Mar 28, 2022 at 11:27 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Mon, Mar 28, 2022 at 7:17 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Updated patch to fix one place I missed pointed out by the kernel test robot.
> >
> > See attached.
> >
> > On Sun, Mar 27, 2022 at 4:14 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Currently the way the tid (tree connection) status is tracked
> > > is confusing.  The same enum is used for structs cifs_tcon
> > > and cifs_ses and TCP_Server_info, but each of these three has
> > > different states that they transition among.  The current
> > > code also unnecessarily uses camelCase.
> > >
> > > Convert from use of statusEnum to a new tid_status_enum for
> > > tree connections.  The valid states for a tid are:
> > >
> > >             TID_NEW = 0,
> > >             TID_GOOD,
> > >             TID_EXITING,
> > >             TID_NEED_RECON,
> > >             TID_NEED_TCON,
> > >             TID_IN_TCON,
> > >             TID_NEED_FILES_INVALIDATE, /* unused, considering removing
> > > in future */
> > >             TID_IN_FILES_INVALIDATE
> > >
> > > It also removes CifsNeedTcon CifsInTcon CifsNeedFilesInvalidate and
> > > CifsInFilesInvalidate from the statusEnum used for session and
> > > TCP_Server_Info since they are not relevant for those.
> > >
> > > A follow on patch will fix the places where we use the
> > > tcon->need_reconnect flag to be more consistent with the tid->status
> > >
> > > See attached.
> > >
> > > Also FYI - Shyam had a work in progress patch to fix and clarify the
> > > ses->status enum
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Please try to maintain the old values in the new enum.
> Rest looks good.

They are mostly the same:
- for the statusEnum, only the ones at the end were removed, and those
don't apply to session or tcp_server (socket)
- for the tid->status the values for the first 4 didn't change

I did check carefully everwhere tidStatus was set/checked.

It shouldn't change any behavior.

The key question for next patch is whether we should check
tcon->need_reconnect which is what is used in all but one place or
check tid->status for need recon (which is done in only one place,
added by patch "cifs: check reconnects for channels of active tcons
too")

Thanks,

Steve
