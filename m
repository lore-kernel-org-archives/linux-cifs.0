Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A69C433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B1F6141C
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243004AbhDUR4m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbhDUR4j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Apr 2021 13:56:39 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC71CC06174A
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 10:56:05 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id h36so13954237lfv.7
        for <linux-cifs@vger.kernel.org>; Wed, 21 Apr 2021 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MxSPkgg8m73R/sWJ8rkQZmCny91aWH9cfqkmD4lVJh4=;
        b=gmWxrrvii3U3YPtyE/u7nYAn1TOQCUOLllUbU4VuR9VqkaCDU2oGeRLJoNjEktvQq/
         UVv3tJ5aHlWKMVa1lXG4WwT8xnmAhfBclY+5knrM+CE7GH29FyqdBCSXAG/xus0BYOgn
         QvPMVStuUWhWpcuuLw+ivzalk4XXJn4zUCpEARzGnjAgBsCm+HL0ke0HNXP9mjSdX6ab
         8Lw62IEu/R0RdZzIyPVEe2t3NSS4SHb38bYI89doGk2ey/RZDk1tFgEct0MgxJ4TjRYU
         F1krhVAE4CCdGGLprre9M938hZQ9dhWdKHnS5NS9u3uNaafTSdcZO0Z+OJap/2XqZpl1
         smAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MxSPkgg8m73R/sWJ8rkQZmCny91aWH9cfqkmD4lVJh4=;
        b=ORmwYN+vKGCGHyuQHEqcYoNcmiFw2xAE+p7YdtjiVJHVDAV7ZmjN34l3sD4D0Cy1yt
         Dof2rkeNWFx2bsu5JJbjatmtj+DzWR4LkHvmgs39phW6Vg2RGtcbu/X6jTXtxdC5CDrE
         KiDVsAw0r8rqR79yZOAgvqn00rOK2Y/w6w+n2btEVgzn3F0UoxUe/9NqEBta901pWZMW
         md18iR18lwNdNbMnj6INMB33RYNAuKBR9EZMzfNIXpiVUNUfHmJPSUbW8MymfUbVHKn+
         mgPzvKjvmiv0HuHIJFtrTtRIeeHVPsTaI1r+pJEfOvotqG5B80uUGFdaZtEGZqgyDhL0
         9hgQ==
X-Gm-Message-State: AOAM530nT9y3ZMQaKFC5ZGI/oYtw7sB98U9Xi3AylJT4HZjcakRoJ1PN
        MNWWxSLbrHEOdWoFK4vVlZt8c3vCzno1RpW8E3U=
X-Google-Smtp-Source: ABdhPJxDExtP2crSG13NMueJJkcw2gmGqdmZaM/wLLaDsiAfu8z6/tdK6ALOpPOnTdQtPj7womrRqmFfWL8SXp03aCw=
X-Received: by 2002:a05:6512:1322:: with SMTP id x34mr20106625lfu.133.1619027764294;
 Wed, 21 Apr 2021 10:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
 <1157a5af41b38f8826a08e9684ea2b124a0cc21f.camel@freebox.fr>
In-Reply-To: <1157a5af41b38f8826a08e9684ea2b124a0cc21f.camel@freebox.fr>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Apr 2021 12:55:53 -0500
Message-ID: <CAH2r5msA3cdaRuvxWzEtKxS5TfHhq6zQofL-zrss3x9mgp4=bA@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] ksmbd testing progress - buildbot run passed
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Apr 21, 2021 at 12:42 PM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> On Wed, 2021-04-21 at 12:18 -0500, Steve French wrote:
> > Current Linux client (minus the deferred close patches) to current
> > ksmbd on 5.12-rc8 as a test target passed all tests:
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/32
> >
>
> It doesn't look like any test was actually run though.

The run times look plausible.  Let me know if you see anything
suspicious.  I can ssh in to make sure - but probably fine.  I only
typically worry about tests that take less than 3 or 4 seconds (to
doublecheck that they aren't skipped)

> I looked at some of the tests output and they all had umount errors:
>
>   umount: /mnt/test: not mounted.
>   umount: /mnt/test: not mounted.

That is normal, the tests unmount at the end of the previous one
(unless it times out) and tries to unmount again before the next one
starts.

>
> The warmup smb3 generic/001 hints at cifs.ko not being loaded:
>
> rmmod: ERROR: Module cifs is not currently loaded
> mount error(113): could not connect to 192.168.122.13Unable to find
> suitable address.

That was because the test client VM had some out of memory issues and
so I shut down the windows server test target
(which is not relevant for these tests)
-- 
Thanks,

Steve
