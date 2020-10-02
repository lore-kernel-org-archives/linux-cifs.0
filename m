Return-Path: <SRS0=klGs=DJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0177C4363D
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 14:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70202206DD
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 14:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKJUldMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgJBONc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387908AbgJBONb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Oct 2020 10:13:31 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356D0C0613D0
        for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2020 07:13:30 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a2so1277854ybj.2
        for <linux-cifs@vger.kernel.org>; Fri, 02 Oct 2020 07:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQFJfBYRWWE6gvRV2VQEDB3MthtDPgekQ5csz9LPSHk=;
        b=bKJUldMKoVeJh7N8YU5nbh00y9hmvlxxXU24ZJvHn/nFOAPYThkUMp3QIN1xMbTrIs
         zycnAOrfdD8ZFpIkPGMF0Vn9BgSoVm4CWCTso3oVZjJiNv18OF4vY364Rtyn9Jm/u4Sj
         /ElOHYFb1cIElLsbuqjgtOQPPw3hr+/cCUQ/Kx+91ZnORz6Pv4a7/CyNC8cDZb6akp1K
         95DmotUKQMfXUsTsLYhAYjey5csEJtccf5wHISni5O3eHb/XmoWnZYrZ2I3zEhHmOkdK
         BWjol1VVJ2u80wVwnf4daWt63uxMUXdxNfUbNLsd0uorg3zrRIbeS+VTPnRtUKf3QlVY
         jcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQFJfBYRWWE6gvRV2VQEDB3MthtDPgekQ5csz9LPSHk=;
        b=kp3euWAqUUfVjBflbZ+yDtZvx48jg1lHiIVmEvjNO6pXf03aiIupoAeAQ2swnwnBfD
         bxAdV5sqTOl1qxqdcyxy7BQWmUI07LepaMhNQhwv+Isdd5HBretgilAZXv14yvSRlj7Z
         elhcW8POt9zfJnDoB+UT5Hg0jdz65yanASmFoET+4fRnUXn9wDdAkGt0nKRmdAnAB2RD
         haBXs5qAKAAYdC1yJmanCwSJFWpRb6swSyO6WA45Uj73cykoLzTJeXYRZQ6HQ2L5vUKS
         S8l13GK6nP6PmWZwtJD/Oh3deoCfqdAHOSdby15rXs63vOlbKPkvEoArgdPlY8vDzG/3
         Yw2A==
X-Gm-Message-State: AOAM532MjW4HUafWzV4j8BzyQmjKGbuLiDBXcAaH3pti4UPps4Td2nWw
        Pkw4ugatNgAQKURH6maGeyDflqikA6vv6MfVbLc=
X-Google-Smtp-Source: ABdhPJyYhnbeCz+za60pveoNs50HlzSWI5+6+qK5MvKivrI5Dir+en2U6Lkp288p5QavcdDoUjPq7mXS/4rj7CWTV3Y=
X-Received: by 2002:a25:9c82:: with SMTP id y2mr2842581ybo.364.1601648009246;
 Fri, 02 Oct 2020 07:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201001205026.8808-1-lsahlber@redhat.com> <CAH2r5mvu0MkosfCnCp4jO1=aYVrOaigwoiV09zmTsZtqGL9nVw@mail.gmail.com>
 <CAN05THROtDP98i7UGKgYqHmQQd5RF0+0OdD8q4xhR41QLa3+wA@mail.gmail.com> <CAN05THQHSRr37D3v+LTZcdhbOsvq4WG1DuDKzbSrJDPgTipPGg@mail.gmail.com>
In-Reply-To: <CAN05THQHSRr37D3v+LTZcdhbOsvq4WG1DuDKzbSrJDPgTipPGg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 2 Oct 2020 09:13:18 -0500
Message-ID: <CAH2r5mvE8tSeBb5RJEd_71_dVMYyQmfznbJxN+rPrM2z0WmK6Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: cache directory content for shroot
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

query dir is doing a FIND_ID_FULL_DIRECTORY_INFO and stat is doing a
FILE_ALL_INFO?  What are we missing from the query dir response that
we would get from FILE_ALL_INFO in the query info one by one?

On Fri, Oct 2, 2020 at 3:07 AM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Fri, Oct 2, 2020 at 6:04 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >
> > On Fri, Oct 2, 2020 at 3:08 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > My initial test of this was to Windows 10, doing ls of the root directory.
> > >
> > > During mount as expected I see the initial compounded smb3.1.1
> > > create/query(file_all_info) work and get a directory lease (read
> > > lease) on the root directory
> > >
> > > Then doing the ls
> > > I see the expected ls of the root directory query dir return
> > > successfully, but it is a compounded open/query-dir (no lease
> > > requested) not a query dir using the already open root file handle.
> > > We should find a way to allow it to use the root file handle if
> > > possible although perhaps less important when the caching code is
> > > fully working as it will only be requested once.
> >
> > That is something we can improve as aesthetics. Yes, we should try to
> > use already open directory handles if ones are available.
> > Right now this is probably low priority as we only cache the root directory.
> > When we expand this to other directories as well,   maybe cashe with a
> > lease the last n directories? and not just ""
> > we can do this and likely see improvements.
> >
> > >
> > > The next ls though does an open/query but then does stat of all the
> > > files (which is bad, lots of compounded open/query-info/close).  Then
> > > the next ls will do open/query-dir
> >
> > I don't think we can avoid this. The directory lease AFAIK only
> > triggers and breaks on when the directory itself is modified,
> > i.e. dirents are added/deleted/renamed   but not is pre-existing
> > direntries have changes to their inodes.
> >
> > I.e. does a directory lease break just because an existing file in it
> > was extended? Does the lease break if an immediate subdirectory have
> > files added/removed, i.e. st_nlink changes, not for the directory we
> > have a lease on but a subdirectory where we do not  have a lease?
>
> I mean, even with directory caching ls -l would still need to stat()
> each dirent ?
>
> > >
> > > So the patch set is promising but currently isn't caching the root
> > > directory contents in a way that is recognized by the subsequent ls
> > > commands.   I will try to look at this more this weekend - but let me
> > > know if updated version of the patchset - it will be very, very useful
> > > when we can get this working - very exciting.
> > >
> > > On Thu, Oct 1, 2020 at 3:50 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > > >
> > > > Steve, List
> > > >
> > > > See initial implementation of a mechanism to cache the directory entries for
> > > > a shared cache handle (shroot).
> > > > We cache all the entries during the initial readdir() scan, using the context
> > > > from the vfs layer as the key to handle if there are multiple concurrent readir() scans
> > > > of the same directory.
> > > > Then if/when we have successfully cached the entire direcotry we will server any
> > > > subsequent readdir() from out of cache, avoinding making any query direcotry calls to the server.
> > > >
> > > > As with all of shroot, the cache is kept until the direcotry lease is broken.
> > > >
> > > >
> > > > The first two patches are small and just a preparation for the third patch. They go as separate
> > > > patches to make review easier.
> > > > The third patch adds the actual meat of the dirent caching .
> > > >
> > > >
> > > > For now this might not be too exciting because the only cache the root handle.
> > > > I hope in the future we will expand the directory caching to handle any/many direcotries.
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve



-- 
Thanks,

Steve
