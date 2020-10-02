Return-Path: <SRS0=klGs=DJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FAF6C4363D
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 08:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5995420719
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 08:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fP5CRCGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJBIFK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Oct 2020 04:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBIFK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Oct 2020 04:05:10 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C03C0613D0
        for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2020 01:05:10 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so621088iol.10
        for <linux-cifs@vger.kernel.org>; Fri, 02 Oct 2020 01:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MHgdjFsZXAAzoI+L/5rtm5WlGnfc8w/Uir0yIdDT+ow=;
        b=fP5CRCGRu91X8VvaCKBTYtoGQN/8V0uGug4BKCq2lLaFWfc/svYd95CmX1aHnwvsx9
         k8HvjImb3+pLuAVqe3oHHrDUMv57Q+gwI7LdeH4XdxiSHseh4Kr8NNRK2816JsEG85g3
         YpmG5AdO+JJ0sAaot5kEqHy4fJuRHEv9XCXYbTKCADRbZ1edBYisDV+WdCIu1H2nTVaO
         hjj2Q4d4/rkq1sjlcPS1HNgNLxV0JhAzpvybo7jkYLEfQhsKONZ8DC9JahfHmP48ui1r
         MBGNp7tBj03pjXz8tTMX1aDE4MwmbXKDy98TwBBrYZTIEZHhm1XukUT5sW2jCIMdHSPF
         VbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MHgdjFsZXAAzoI+L/5rtm5WlGnfc8w/Uir0yIdDT+ow=;
        b=QUYXIj6qrV3cG38t+J/PJMJrS4hmRmS+iX1bh1etCfopcKFY59gXotH/jfroGu59+b
         VsGyJPSx2mH82D+13+hhC+XqvHjNpcO/U3QNVyThg4QhmcZRBMzryKT+t7oxJMHmjG8/
         LakJ7obbHmEOpmzysYj9eoMfOm7QpeYdM3k3bupwzJrRZmrksCGaZdKENkpsUKW5+721
         a/q8I9XyUjAPJpM0GqEtNnVtDnw+kW38AFS7XvXCZ3SaK2wUumPlOy3MmAYzSuuE+6F8
         GPK+awA6+3o5/VGPS/z0RpTXZX4UbpS/cQWS2JOawVtVhDR90aA0AAzf3f6LGj4uXER2
         z0Rg==
X-Gm-Message-State: AOAM531KIvPbL7SaG2x8KjbALd9mffDK3lq9jMGQRIKE2/iYrp8ZFqPU
        71lqKGmBW1Ek9nsecNR4ZYPw0itRfxUPIZ8icTWq7NIY
X-Google-Smtp-Source: ABdhPJzEb/DzQ6mai8lO977vLZ8Xksf/z5jFlpqkIHFZeSnMJkadHQmNYOiCxV5pO0VUZQGg5MMPCGm36Wi3ZzCWVOE=
X-Received: by 2002:a6b:e017:: with SMTP id z23mr1093434iog.101.1601625909726;
 Fri, 02 Oct 2020 01:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201001205026.8808-1-lsahlber@redhat.com> <CAH2r5mvu0MkosfCnCp4jO1=aYVrOaigwoiV09zmTsZtqGL9nVw@mail.gmail.com>
In-Reply-To: <CAH2r5mvu0MkosfCnCp4jO1=aYVrOaigwoiV09zmTsZtqGL9nVw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 2 Oct 2020 18:04:58 +1000
Message-ID: <CAN05THROtDP98i7UGKgYqHmQQd5RF0+0OdD8q4xhR41QLa3+wA@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: cache directory content for shroot
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 2, 2020 at 3:08 PM Steve French <smfrench@gmail.com> wrote:
>
> My initial test of this was to Windows 10, doing ls of the root directory.
>
> During mount as expected I see the initial compounded smb3.1.1
> create/query(file_all_info) work and get a directory lease (read
> lease) on the root directory
>
> Then doing the ls
> I see the expected ls of the root directory query dir return
> successfully, but it is a compounded open/query-dir (no lease
> requested) not a query dir using the already open root file handle.
> We should find a way to allow it to use the root file handle if
> possible although perhaps less important when the caching code is
> fully working as it will only be requested once.

That is something we can improve as aesthetics. Yes, we should try to
use already open directory handles if ones are available.
Right now this is probably low priority as we only cache the root directory.
When we expand this to other directories as well,   maybe cashe with a
lease the last n directories? and not just ""
we can do this and likely see improvements.

>
> The next ls though does an open/query but then does stat of all the
> files (which is bad, lots of compounded open/query-info/close).  Then
> the next ls will do open/query-dir

I don't think we can avoid this. The directory lease AFAIK only
triggers and breaks on when the directory itself is modified,
i.e. dirents are added/deleted/renamed   but not is pre-existing
direntries have changes to their inodes.

I.e. does a directory lease break just because an existing file in it
was extended? Does the lease break if an immediate subdirectory have
files added/removed, i.e. st_nlink changes, not for the directory we
have a lease on but a subdirectory where we do not  have a lease?
>
> So the patch set is promising but currently isn't caching the root
> directory contents in a way that is recognized by the subsequent ls
> commands.   I will try to look at this more this weekend - but let me
> know if updated version of the patchset - it will be very, very useful
> when we can get this working - very exciting.
>
> On Thu, Oct 1, 2020 at 3:50 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Steve, List
> >
> > See initial implementation of a mechanism to cache the directory entries for
> > a shared cache handle (shroot).
> > We cache all the entries during the initial readdir() scan, using the context
> > from the vfs layer as the key to handle if there are multiple concurrent readir() scans
> > of the same directory.
> > Then if/when we have successfully cached the entire direcotry we will server any
> > subsequent readdir() from out of cache, avoinding making any query direcotry calls to the server.
> >
> > As with all of shroot, the cache is kept until the direcotry lease is broken.
> >
> >
> > The first two patches are small and just a preparation for the third patch. They go as separate
> > patches to make review easier.
> > The third patch adds the actual meat of the dirent caching .
> >
> >
> > For now this might not be too exciting because the only cache the root handle.
> > I hope in the future we will expand the directory caching to handle any/many direcotries.
> >
>
>
> --
> Thanks,
>
> Steve
