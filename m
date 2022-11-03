Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9C2C43219
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Nov 2022 20:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKCUrZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Nov 2022 16:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiKCUrY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Nov 2022 16:47:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0075F20998
        for <linux-cifs@vger.kernel.org>; Thu,  3 Nov 2022 13:47:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso6424718pjn.0
        for <linux-cifs@vger.kernel.org>; Thu, 03 Nov 2022 13:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MxS/4UcS9QV06TA42jz+n7cPJ0B1Da1lpvr3ubjc6GY=;
        b=cuP5UtrVPLmPkgDyIU7nXUWip6wPNwEQX83eaiYzuSaa/NwaBOHxdiCCYvHyd3mrWb
         UX4IYw78zXIF0mMu0R7qDreIqrr7PvviOTacDCidW9f3UUssGYk9RosDNLvY+hm88Tz8
         hEooCKFouHczA6F3wBjXPLYrpYIszUEwnYnlDxkOvhuNi8oE//fz5w1SOEhhUUoWt77E
         pAHn5L/ZZzWw3HkpcasZr6hnf6O/XMcGhjxvLwJ33vohngsJ1KBKVvIfn+XAYIa1YRVX
         Vkpw4CNDgLSlpQfjW7+15/HKqs/xOt8+2WdHOo1jGBPReCKhIlOzYbvvyYROh/eydkAD
         rc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxS/4UcS9QV06TA42jz+n7cPJ0B1Da1lpvr3ubjc6GY=;
        b=1lPtzIjzIjBquJ8087EU6TZZawFnhscuuJrhUzNraI4S0OmrKZWTImQPPqjKccamCA
         VEdrmZNTSn8lWLLRsQ1gg+dHkDaf3/bmu7VQV76EkrEXk6aotbnR4hLxZPDCFtYWP0Jz
         ihcUSzevFNu+MQEyGpSl1UFsZmmIl/dmCGL18+a2Fmp3TFSdPlM3fvkYwckllCpnCLI3
         jk5jrhlwIlktHw5XNL4nOFWALJezHBCRTe/akgl1VQ4bq97hVCKA+yqRcOms+R61z26y
         eCyA84fWds0s6pP9WqawoBaZu+tLMS9DiIr2IzM2anhx3zpbic2wj/niSa2UfR2XD2eD
         7CxA==
X-Gm-Message-State: ACrzQf0rLd3xx3l2UKJWFP9216grxlSTujx0urh7zgvBNA9dzK6lUvc0
        PFk2Uj8bPcnBn9ONkZF7t8rwMA==
X-Google-Smtp-Source: AMsMyM5GUtVQUrVsmSVgFmsiPB/ae+Y5AFUcecj0KBZFMpN2UeC1Le+3w3RaW8dan20LGNVVX2XxhA==
X-Received: by 2002:a17:90a:5781:b0:20a:9962:bb4a with SMTP id g1-20020a17090a578100b0020a9962bb4amr49118773pji.185.1667508442530;
        Thu, 03 Nov 2022 13:47:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id y12-20020aa78f2c000000b00561b455267fsm1205656pfr.27.2022.11.03.13.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 13:47:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqh7P-009uXX-4a; Fri, 04 Nov 2022 07:47:19 +1100
Date:   Fri, 4 Nov 2022 07:47:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Vishal Moola <vishal.moola@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, linux-nilfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 00/23] Convert to filemap_get_folios_tag()
Message-ID: <20221103204719.GY2703033@dread.disaster.area>
References: <20221102161031.5820-1-vishal.moola@gmail.com>
 <20221103070807.GX2703033@dread.disaster.area>
 <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzc2pzFMU-XiGZ9bsp40JkpYVSzQuxs2VXgfw_p9abkj4GrFw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Nov 03, 2022 at 09:38:48AM -0700, Vishal Moola wrote:
> On Thu, Nov 3, 2022 at 12:08 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Nov 02, 2022 at 09:10:08AM -0700, Vishal Moola (Oracle) wrote:
> > > This patch series replaces find_get_pages_range_tag() with
> > > filemap_get_folios_tag(). This also allows the removal of multiple
> > > calls to compound_head() throughout.
> > > It also makes a good chunk of the straightforward conversions to folios,
> > > and takes the opportunity to introduce a function that grabs a folio
> > > from the pagecache.
> > >
> > > F2fs and Ceph have quite a lot of work to be done regarding folios, so
> > > for now those patches only have the changes necessary for the removal of
> > > find_get_pages_range_tag(), and only support folios of size 1 (which is
> > > all they use right now anyways).
> > >
> > > I've run xfstests on btrfs, ext4, f2fs, and nilfs2, but more testing may be
> > > beneficial. The page-writeback and filemap changes implicitly work. Testing
> > > and review of the other changes (afs, ceph, cifs, gfs2) would be appreciated.
> >
> > Same question as last time: have you tested this with multipage
> > folios enabled? If you haven't tested XFS, then I'm guessing the
> > answer is no, and you haven't fixed the bug I pointed out in
> > the write_cache_pages() implementation....
> >
> 
> I haven't tested the series with multipage folios or XFS.
> 
> I don't seem to have gotten your earlier comments, and I
> can't seem to find them on the mailing lists. Could you
> please send them again so I can take a look?

They are in the lore -fsdevel archive - no idea why you couldn't
find them....

https://lore.kernel.org/linux-fsdevel/20221018210152.GH2703033@dread.disaster.area/
https://lore.kernel.org/linux-fsdevel/20221018214544.GI2703033@dread.disaster.area/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
