Return-Path: <SRS0=6quT=36=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B879FC352A3
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 14:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2FF2080C
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 14:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCMKDggL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgBJOaO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Feb 2020 09:30:14 -0500
Received: from mail-il1-f179.google.com ([209.85.166.179]:39662 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgBJOaN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Feb 2020 09:30:13 -0500
Received: by mail-il1-f179.google.com with SMTP id f70so357182ill.6
        for <linux-cifs@vger.kernel.org>; Mon, 10 Feb 2020 06:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q2kUpca9hrlW28cm1WPnGHcMvF5YzvkiFbGVpNsDch4=;
        b=iCMKDggLHadL6hF7qKBzz1UryOGYQUk+wNL9Dks+AzxHi0s1IKSRR+YeDg4Hw4LCbz
         70o00vhaJBwRPlH19MaCLgLnbzJD18mXQqinThqolAB1e8YZ8tfC+Rsk4K3fk3XYcYyV
         qn1uD8a0V32opfNlpMN3nx94mRXIPAABE466tXXZ+7OrGPydf8LimsYTRZr+II0xtSss
         8/s1KSxn8gRAIOkWOPVmY5eysmHpkUyj4BJAGxxHJXNncRqoK+ynn9p//ACoSWhywI1k
         TqNl6n+1kpLFM2eq0kR1B8JWg2EOxegl6tPRxlWRwFAW1TliQo4SpM8iZIWWyvZ+vgSU
         QGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q2kUpca9hrlW28cm1WPnGHcMvF5YzvkiFbGVpNsDch4=;
        b=P8o1h28CFTf4iSD9HJ2bJJMT+evKwLoqL3ea8E0KF5PY7HGH3d9dOpTlvZwcLCncM6
         wLSb5yFO1PFeqn2gwILltEEyZDQlNiEAkg51743UcCtnWdySH+DtBfMEpgNhlSiuEy0g
         OW2I5wERaHGzvJLgdOVNeD3wbNKbG4N3vGW67K2FnkX6iFOkHLF3VlL3DGYM4BrzEB0o
         BjffThJ7chgSvomX2sdB+zesEizOsL/+zSzeYDkgblRCYKCI3Rk4iXJU9achk/AYC0f/
         ByjwfN0bykxWycsw/9trPQ3Oj4I9TwffH50i1aEF4wA2kLVLp+ZIq0TTbjGXDd8f4iZe
         qZnA==
X-Gm-Message-State: APjAAAUCSNvnQJxhE9lYX+XTKObHopgALGzenQQDcluZh0xyJXXWUBde
        0OhQ+3rnXJf5Bd5QVATp1XszTD6nUJe6oWeMYNl+37NX
X-Google-Smtp-Source: APXvYqwqeCAlAIa7aAdsblac0nBIHegBwLMlXJyM7CkQCxRZtyYGRuAFJfKAbE7JpfL/jp7jbuOXcYfmFulvEuZEsMQ=
X-Received: by 2002:a92:d642:: with SMTP id x2mr1649967ilp.169.1581345012931;
 Mon, 10 Feb 2020 06:30:12 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtQRVX3_-_sVjvigRSv2LpSoUBQo7YeY5v0nXm7BGaDig@mail.gmail.com>
 <5E413F22.3070101@tlinx.org>
In-Reply-To: <5E413F22.3070101@tlinx.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Feb 2020 08:30:02 -0600
Message-ID: <CAH2r5mst9FjdPrBQdjt1HGkf73VoNzDUxPSEQNZwyi=9W9XGhA@mail.gmail.com>
Subject: Re: [CIFS][PATCH] Add SMB2? Change Notify
To:     L Walsh <cifs@tlinx.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 10, 2020 at 5:31 AM L Walsh <cifs@tlinx.org> wrote:
>
> On 2020/02/06 04:29, Steve French wrote:
> > A commonly used SMB3 feature is change notification, allowing an
> > app to be notified about changes to a directory. The SMB3
> > Notify request blocks until the server detects a change to that
> > directory or its contents that matches the completion flags
> > that were passed in and the "watch_tree" flag (which indicates
> > whether subdirectories under this directory should be also
> > included).  See MS-SMB2 2.2.35 for additional detail.
> >
> ----
>     How does the SMB3 feature "change notification" differ from
> the SMB2 feature described in MS-SMB2 2.2.35?
>
>     Isn't it more typical to describe features by the spec version
> that they were first publish under -- especially since the doc
> describing the feature is under the SMB2 documents?
>
>     By calling it a SMB3 feature, does that mean you are removing
> it from SMB2?

That is a good question.  I should have made more clear that although
many servers support Change Notify prior to SMB3 dialect, we chose
to implement it in SMB3 (late 2012 and later dialect) to minimize testing
risks and since we want to encourage users to use SMB3 or later (or
at least SMB2.1 or later since security is significantly better for later
dialects than for SMB1 and even SMB2)

Change Notify is available in all dialects (SMB2, SMB2.1, SMB3, SMB3.1.1)
for many servers but for the client we just implemented it for SMB3 and later.
If you have a server that you want to support that requires
SMB2 or SMB2.1 mounts, I wouldn't mind a patch to add notify support
for those older dialects but I would like to encourage use of SMB3 or later (or
at least SMB2.1 or later) where possible.

Steve
