Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE241C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 16:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9411222DF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 16:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SL0LfAk7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404957AbfBNQaq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:30:46 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38279 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfBNQaq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 11:30:46 -0500
Received: by mail-pl1-f193.google.com with SMTP id e5so3409951plb.5
        for <linux-cifs@vger.kernel.org>; Thu, 14 Feb 2019 08:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YYIYYSuDTstfhobvRZDMoZVqM2Fp/n00Bca5MIY5Hm8=;
        b=SL0LfAk7ToF1qsxJlL2R/U/WFZlJCuQHvv0+qRRmBDKfagymx2urnikvc1JQlG3fPl
         zmczleyrxJQ2HRpWTuRUMxOssqo7DJxgP+0L27NEe4/Z7D44jUkFG3I6/k9xhWKGWKTF
         hnoxVWGpC552q0Af92tJxWW9Iyw7FE/bgdkNnfXueBnLhnnm7HJlmpgRSXwLfYqwaTWg
         cqANp7/jbapcfEuDM7VXgYCKTdQC95jgaecuIzLCUF9Ec+bGQrtw1TiwkjQFvoMWmhnD
         grUiapNOpGYUKzk8ZQQuusWsEp6tYU1Z7/AXLmJmbxcWvmG03E6Doz+fj760cnqsL8eJ
         hoTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YYIYYSuDTstfhobvRZDMoZVqM2Fp/n00Bca5MIY5Hm8=;
        b=j5AdYzzYkIJtza9S8KoMM23cLTzeEFZxpALePK5Z5oNVdemQJqjOC4E2S+lHiVGAiY
         OVaOBzvCVqABI4p8+NVS3AXGwgWQpBw1t7tf+F3llHTYoKF4ciBoiOaIOhsxGar2V9wE
         sDfAJ/jWVC6y/TUg2VHRVDA9wIygbkxbLQDrjXmMU6+9jeRYXBpi5oPr6mTPP1hoC/Cj
         hKnfUbnACtDifS3MiY6krbYGQ7ByBY3xlndoax5EjZneTY6CAKcQ4Rl6dBsTJkLNQ4WK
         32vcWOQuvAjrtD/3LAfURWkKMT7tlukmyunkoW48WvjKIf0naz9x+nxOMlmR+6cCmHtb
         bBvA==
X-Gm-Message-State: AHQUAuZMjnBLnRCmbjvexVpNJQieYi+EKQcqxNEQ85Q8PuqXGutprhdp
        yJRjlNk8L2+5tWvNkV8UbvLM/UvuY70bk+URzPvw0A==
X-Google-Smtp-Source: AHgI3IaKwRFi0atB0vryDKhdnuvc5CfdIPwmJncU9jhnxC7om93WxBQCq5ELEeYHZOqojzXvarYJSk+asqg4svtnydI=
X-Received: by 2002:a17:902:468:: with SMTP id 95mr4847148ple.73.1550161845368;
 Thu, 14 Feb 2019 08:30:45 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muwi0BSpU7jujroojVNM6qO8pRO_mXTBA4TpSsp2Cd=5A@mail.gmail.com>
 <1715745087.982638.1550131552920.JavaMail.zimbra@redhat.com>
In-Reply-To: <1715745087.982638.1550131552920.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Feb 2019 10:30:34 -0600
Message-ID: <CAH2r5msLRW7tR1VyU3qAy-rZbP0uZ8UFuxNESNzOk06f0Q2hKQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] request more credits during session setup
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

smbclient requests even more for every request - although server will
give out a much, much smaller number in reponse.  If there were
another safe request to add more to (perhaps validate negotiate) we
should be up to a reasonable number of credits even for parallel i/o
right after mount - in any case it will increase over time (the number
of credits) but perhaps we should more aggressively ask for credits on
each request and go from asking for 2 for all non read/write requests
to asking for 64 or 128

On Thu, Feb 14, 2019 at 2:05 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> In libsmb2 I am very aggressive about requesting credits during early session establish without problems
> so I am confident we could even dial this up to say 1000 credits.
>
> Though  105 might be more than sufficient.
>
> ----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Thursday, 14 February, 2019 5:27:41 PM
> Subject: [SMB3][PATCH] request more credits during session setup
>
> We only request significantly more credits (during mount) on first
> session setup so we typically end up with from 43-49 credits available
> when mount completes - which is not enough for a large I/O to complete
> (if started soon after mount).  We need > 64 credits.   Solve this by
> requesting more than 2 credits on tree connect.
>
> After mount (before this patch):
> 43 credits (not enough for a 4MB I/O)
>
> After mount (with this patch)
> 105 credits (which is good, enough for two large I/Os to be issued
> immediately after mount)
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
