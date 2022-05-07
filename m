Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34058C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  7 May 2022 02:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356890AbiEGCXA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 May 2022 22:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245684AbiEGCW7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 May 2022 22:22:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF86B69700
        for <linux-cifs@vger.kernel.org>; Fri,  6 May 2022 19:19:13 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k27so10534218edk.4
        for <linux-cifs@vger.kernel.org>; Fri, 06 May 2022 19:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0rc1iRJ23vuI+LNL7tsvrCNLhd/F2RTpsTz08f1Oknc=;
        b=Yo3QDvgLdw9z/ZnHxY2VPJ/19wSuEvsvjHSgns4LgsRSY/Wrhnbv2s9OHBYwEY2wnj
         dcQZCGz0h9QJlXeLrTKFfXX3r5CPlgYLJ8+DLOESSfOHA1KTKf70BulHo9Orz1wrGbVG
         BHIs/cNFB9OIys9OUGro4MYalWrNirviJSJSZVukxlF7X2H6DkrVw2FGiZVJEvpgeuVp
         r5S0zn4++ztuW28fXbQx9QqQgV6f8+9EkZmivG6rcIKkjsm/q3OUGALvJ66BBW0b60FB
         4Awg8oJ7dTX0SrkKf2ZsmZw7pKavH/gY3UxAHMZiiNoE6xxCH7Xg+ROKQ+rphRCIlTBB
         wD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0rc1iRJ23vuI+LNL7tsvrCNLhd/F2RTpsTz08f1Oknc=;
        b=AxEwU+5ZHkq9wkTP/GiPJewrSH8N1IX1JmDAWtaV8iXesSSP3Ug+483l/09Z2vyT+E
         rt0jT7lDJWokjXNyrosuVw24pQSKlWmxkpqlG8uBrJX8GWBLveJH1QrBEpK3Z6M4+0VH
         1JtcGhcxN/c5KRwtEL28r0ihdty2gKTXZ++E59gjGEGFm5P5Vd3lBGs6ESVrznuWCzoH
         Moc+lWLKBRmU75QeE4EANJoCrJETxS3idUwewh8Oq7MoybH3xvVQU3CUeDk1eb/btY/l
         Z8KrubDW64vi1jffHebiN0Lr9bL9Yd/0CPiib0I8Xly0kdxpg1iCmiHxcwNZreJuxP8l
         KlZQ==
X-Gm-Message-State: AOAM533c4VimHLUeJTun+tGlJwF7FOxzW/gtFacpHN0vvKAJFgxACZP6
        dljrk+sMZVjPhrGFy20BBj+WdUyd4N8j6JdZUfs=
X-Google-Smtp-Source: ABdhPJzfEM05KIzYsdAyF67mUA8Pd0EP4ufEIrv8G70whGUK+BZY7bnBUY6E7KRDK+U5q6DWWyCKsJuUuiODIv+QpBQ=
X-Received: by 2002:a05:6402:4249:b0:427:cfac:fd43 with SMTP id
 g9-20020a056402424900b00427cfacfd43mr6575117edb.92.1651889952181; Fri, 06 May
 2022 19:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rgt8bcy4PrEP8r-KXFwu2msTk2pRNFSbHrpVSFrAYkaQ@mail.gmail.com>
 <efb4251a-d203-2783-7590-afc25580e9ce@talpey.com>
In-Reply-To: <efb4251a-d203-2783-7590-afc25580e9ce@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 7 May 2022 07:49:00 +0530
Message-ID: <CANT5p=p=oatzKNdo8DwxXnBDNxZQRjh7k5rPws9UCVRwvecHAA@mail.gmail.com>
Subject: Re: Improving perf for async i/o path
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, May 6, 2022 at 5:44 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 5/6/2022 7:28 AM, Shyam Prasad N wrote:
> > Hi,
> >
> > This is a question for anyone who understands the async I/O codepath
> > better than I do:
> >
> > Today, we have the esize mount option, which delegates the task of
> > decryption to worker threads. But the task of encryption still happens
> > in the context of the i/o thread.
> >
> > If the i/o process does synchronous read/write, it isn't such a big
> > deal. But if it's an async i/o, there is a potentially significant
> > perf gain that we can make if we can offload the heavy lifting to
> > worker threads, and let the main thread move on to the next request.
>
> How do you measure "perf gain"? Won't the extra context switching
> increase the client CPU load? Generally speaking, an application
> doing async i/o is already carefully managing parallelism. Are you
> certain that adding more will always be a win? Will the application
> performance overall actually improve?
>

Hi Tom,

I'm actually profiling cifs.ko performance for a customer who's
running a set of benchmark tests which tries to capture their actual
workloads.
One such workload is the one with a single application process that is
pumping random async writes to a handful of files on the system.
So the app expects that the request is queued asap before being
unblocked, so that it can move on to the next request. Seems like a
fair ask.

On profiling cifs.ko, I found that all the other CPUs are fairly idle,
when one cpu is kept busy in queuing up requests.
And because it does encryption and tcp send as a part of queuing up
requests, I feel that it is not as fast as it should be.
I feel that if this task is spread out across the other CPUs (by the
way of delegation), the I/Os can unblock much more quickly, thereby
keeping many more requests in-flight quickly,

Note that this is only theoretical so far. I will try it out and see
if that is actually what happens, but I wanted to collect opinions on
whether there are any down-sides to this approach.

> > What do you all feel about moving the server->ops->async_writev (and
> > async_readv) to a worker thread? Do you see any potential challenges
> > if we go that route?
>
> Need more data.
>
> Tom.



-- 
Regards,
Shyam
