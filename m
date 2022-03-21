Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7DDC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 10:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiCUKVM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 06:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244001AbiCUKVK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 06:21:10 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68609AE7E
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 03:19:41 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id m84so7672770vke.1
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 03:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d3gs4hBmddF9atsCWVGXlkqz4wj0cb+BLNhdWDiU7tw=;
        b=atCcgFMCDdXrtdVscpMW6uxalqW1k/X1SiUWxf5WRT9TWOmKLM9U5yZsHfewB7qejv
         L6CG1kHtZC+AO7Q0B6umng+jBPiFg53OOXJ/lq2IF35hCaAq6yDSoc+b2XsubWfvdvKK
         MSfUVvFB/UQPs68Hx/xi3vFkthPMYlrYJnansPjTO2JjX99EXTkMoBhSaTq90Hx5tFTm
         fOrpZPqWrNUaL3ibwKU6Wnf6hKHcNVSWDnaiscyo855ixCb98gueYgVnxSaxf6xmQuYJ
         pbZyHw6Kla9sQFF6sZWetJ2Ucllekam9edSHS2lgzypvmW3OmpU5dKNR7n3KDQITzJa+
         OoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d3gs4hBmddF9atsCWVGXlkqz4wj0cb+BLNhdWDiU7tw=;
        b=tcK+w1UuxOABIAMJnu6o0QRUYl/GEvrX2fTmganTqvExZM63nIIyG2p7mR0eTgq65f
         lYt0aG6/o0dMZGOHx0OF/5pnFyMVWmqVWrHvSklkEknrAdmVHqjJsTBf4qcslIgsM1pC
         jisD+OR8plRapGPvQxsWPm90bqpshUVqHFSd5zUWp8vjYLGQeS566nUtycZwyXT+W3Tr
         XfU+FuC5asBaG2fyQc4ftoeEcHtVQPJM6/dv/X6B9xgDT7BWkWcqxsEuB5mCmAFwdUri
         sn52NcgXH5aOvH91WXuQEfxPUm8nyVzKDOvDOAyRbg1bgaeGK5RV1gDpIppfFMDvxfLZ
         TOrA==
X-Gm-Message-State: AOAM532IT+CrxtE9tPKMLOX6pks9fnbH0jiDM7WnpEDB3xfp+UMY5gRx
        dOTARRHGRhdOZ1c79bnaKrYPUWsh2BKQ6etk85Q=
X-Google-Smtp-Source: ABdhPJyFdAzxNzu/MzRL0y4jfV4pvNLviJM7E3QUyTg4kuSdzsGSUvpkQGCkzH58QbMIi3eK3EBQQIpjF9peOT42EzQ=
X-Received: by 2002:a05:6122:d07:b0:337:b939:e386 with SMTP id
 az7-20020a0561220d0700b00337b939e386mr7697837vkb.41.1647857980815; Mon, 21
 Mar 2022 03:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YuO+t46wQf9pKu9-U-=vguvwpEu6VXrkXV3JDocFM2qg@mail.gmail.com>
 <2314914.1646986773@warthog.procyon.org.uk> <2315193.1646987135@warthog.procyon.org.uk>
 <CACdtm0Y_F7JjoqvC63+3CU0brETf+iEQ_UjMyx+WzhtwE1HGSw@mail.gmail.com>
 <4085703.1647475640@warthog.procyon.org.uk> <230153.1647562888@warthog.procyon.org.uk>
 <CAH2r5mv_V5j_kr=NwCuj1GZesaBVasgZZsHajiCk2Q5UpZ4Lsw@mail.gmail.com>
In-Reply-To: <CAH2r5mv_V5j_kr=NwCuj1GZesaBVasgZZsHajiCk2Q5UpZ4Lsw@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 21 Mar 2022 15:49:29 +0530
Message-ID: <CACdtm0acOifDsToq3-ocxV2pfXkBX2CoJ64_B_vxMu6mJvN7bA@mail.gmail.com>
Subject: Re: cifs conversion to netfslib
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, Jeff Layton <jlayton@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, natomar@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Dave,

As I mentioned earlier some tests are skipped with reason(O_DIRECT is
not supported) with netfs changes. This is because "ctx->len" is
getting updated to 0 in the code below for the DIRECT IO case.

Snippet from cifs_writev:
        rc = extract_iter_to_iter(from, ctx->len, &ctx->iter, &ctx->bv);
        if (rc < 0) {
                kref_put(&ctx->refcount, cifs_aio_ctx_release);
                return rc;
        }
        ctx->npages = rc;
        ctx->len = iov_iter_count(&ctx->iter);


lxsmbadmin@netfsvm:~/xfstests-dev$ sudo ./check generic/091
SECTION       -- smb3
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 netfsvm 5.17.0-rc6+ #1 SMP PREEMPT Fri
Mar 18 05:55:29 UTC 2022
MKFS_OPTIONS  -- //127.0.0.1/sambashare_scratch
MOUNT_OPTIONS --
-ousername=lxsmbadmin,password=RedBagBesideALake!,noperm,vers=3.0,actimeo=0
//127.0.0.1/sambashare_scratch /mnt/xfstests_scratch

generic/091     [not run] O_DIRECT is not supported
Ran: generic/091
Not run: generic/091
Passed all 1 tests

SECTION       -- smb3
=========================
Ran: generic/091
Not run: generic/091
Passed all 1 tests

Regards,
Rohith

On Fri, Mar 18, 2022 at 8:22 AM Steve French <smfrench@gmail.com> wrote:
>
> On Thu, Mar 17, 2022 at 7:21 PM David Howells <dhowells@redhat.com> wrote:
> >
> > Hi Rohith, Steve,
> >
> > I've updated my cifs-experimental branch.  What I have there seems to work
> > much the same as without the patches.
> >
> > I've managed to run some xfstests on it.  I note that various xfstests fail,
> > even without my patches, and some of them seem quite slow, again even without
> > my patches.
> >
> > Note that I'm comparing the speed to afs which does a lot of directory
> > management locally compared to other network filesystems, so I might be
> > comparing apples and oranges.  For example, I can run generic/013 on afs in
> > 4-7s, whereas it's 3m-7m on cifs.  However, since /013 does a bunch of
> > directory ops, afs probably has an advantage by caching the entire dir
> > contents locally, thereby satisfying lookup and readdir from local cache and
> > using a bulk status fetch to stat files from a dir in batches of 50 or so.
> > This is probably worth further investigation at some point.
>
> Yes - this is a point that Nagendra also made recently that we could
> benefit from
> some of the tricks that NFS uses for caching directory contents not just the
> stat and revalidate_dentry info (e.g. affected by actimeo).
>
> Since the protocol supports directory leases it would be relatively
> safe compared
> to some other protocols to cache directory contents much more aggressively,
> and even without directory leases, other tricks (like directory change
> notification
> or even simply the mtime on the directory) can be used to cache directory
> contents reasonably safely.
>
>
> --
> Thanks,
>
> Steve
