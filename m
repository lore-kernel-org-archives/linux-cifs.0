Return-Path: <SRS0=klGs=DJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D98C4363D
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 05:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D43D20665
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Oct 2020 05:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLTFCE+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgJBFHo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Oct 2020 01:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgJBFHo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Oct 2020 01:07:44 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087C3C0613D0
        for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2020 22:07:44 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s19so300189ybc.5
        for <linux-cifs@vger.kernel.org>; Thu, 01 Oct 2020 22:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LA2mGzezfdOys6Dv3i0qZnvs9Joij2mdWc2EWqjxyU8=;
        b=nLTFCE+c1/lGr7KAoQsIQA4dh7rKDlYnVcA0TSp6jOfWzoqgdU6uVlJZ098NjuXqH1
         YoRa0MDcr/41TVjlMRxp3hCdsh2giAs06j+HCgxsdamD32J2U7rvZUTXzmMsx2bxpSR7
         vMYD+oP2K4rcFFdqVpTGHkMbgOrxXeZzu5WoAGcX20/WnGj8Yql+1JaSob2qgIo/A720
         xCr2kn090VZORRUn55qc4XoJ+BhrVb+9XTHCws6aNv8TyCoWtAByfYMiZ07/DG7hw0Le
         df3qTz/t9lktza9S0bHLtjH6Ns4bEdsj3TpX0TlCALSkwsf4BjxMge1sNPi3Lxjk1M4F
         ZAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LA2mGzezfdOys6Dv3i0qZnvs9Joij2mdWc2EWqjxyU8=;
        b=kV8dmSmbA9gKDNL86v34eIOYgxRuNPrhoeoI9Uh+rjF/m3opOXhXIDXhigoVAAlaR5
         eZ2bB9g5MmILkX3cTobcLGIrvHAZdkOt6odMHDlAsEMApEuYeGVjuLM07Y8xyGHZL7Vk
         V6pR/ulQ/x451LIoovwJgRLnP6AoKVcB9+Ydj+HVapT0nFc7f8HUbVdulr9M4IOzKtFd
         pbnh9Y6grtJPVuyTqdlqAzuetDxiphVve3TzlkEZMbzjaApg+IdH1OQRGXWnHPy/B5e6
         vWrq2NK7hFy38SOydO+X5bF7P2yl4U++e9J8PUKN4qM26qoBQDt53qMVqogc50XZDDz/
         F2tg==
X-Gm-Message-State: AOAM5335vq077gGauD+itZu8f7Ta5nU7q9u7h/b/asGYK0s8ZSI/waI4
        ve90qx7SXkP3tztxZbBhWrdtdVPeCYeCW9l7xz3VKrKtszs=
X-Google-Smtp-Source: ABdhPJwHkCGx5D5N3bZ76PDzQe7yJ+xKHDJpqXeU6CWhXNnYdb55p3Xmk/MI6hpJeOCuDPuS+12Giao9oknD4vfhy9E=
X-Received: by 2002:a25:ce52:: with SMTP id x79mr519459ybe.183.1601615263087;
 Thu, 01 Oct 2020 22:07:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201001205026.8808-1-lsahlber@redhat.com>
In-Reply-To: <20201001205026.8808-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 2 Oct 2020 00:07:32 -0500
Message-ID: <CAH2r5mvu0MkosfCnCp4jO1=aYVrOaigwoiV09zmTsZtqGL9nVw@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: cache directory content for shroot
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

My initial test of this was to Windows 10, doing ls of the root directory.

During mount as expected I see the initial compounded smb3.1.1
create/query(file_all_info) work and get a directory lease (read
lease) on the root directory

Then doing the ls
I see the expected ls of the root directory query dir return
successfully, but it is a compounded open/query-dir (no lease
requested) not a query dir using the already open root file handle.
We should find a way to allow it to use the root file handle if
possible although perhaps less important when the caching code is
fully working as it will only be requested once.

The next ls though does an open/query but then does stat of all the
files (which is bad, lots of compounded open/query-info/close).  Then
the next ls will do open/query-dir

So the patch set is promising but currently isn't caching the root
directory contents in a way that is recognized by the subsequent ls
commands.   I will try to look at this more this weekend - but let me
know if updated version of the patchset - it will be very, very useful
when we can get this working - very exciting.

On Thu, Oct 1, 2020 at 3:50 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve, List
>
> See initial implementation of a mechanism to cache the directory entries for
> a shared cache handle (shroot).
> We cache all the entries during the initial readdir() scan, using the context
> from the vfs layer as the key to handle if there are multiple concurrent readir() scans
> of the same directory.
> Then if/when we have successfully cached the entire direcotry we will server any
> subsequent readdir() from out of cache, avoinding making any query direcotry calls to the server.
>
> As with all of shroot, the cache is kept until the direcotry lease is broken.
>
>
> The first two patches are small and just a preparation for the third patch. They go as separate
> patches to make review easier.
> The third patch adds the actual meat of the dirent caching .
>
>
> For now this might not be too exciting because the only cache the root handle.
> I hope in the future we will expand the directory caching to handle any/many direcotries.
>


-- 
Thanks,

Steve
