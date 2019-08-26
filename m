Return-Path: <SRS0=RY9s=WW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87353C3A59F
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Aug 2019 14:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B4AC20679
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Aug 2019 14:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQtT9FB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbfHZOz4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Aug 2019 10:55:56 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46808 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731617AbfHZOz4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Aug 2019 10:55:56 -0400
Received: by mail-io1-f67.google.com with SMTP id x4so37833736iog.13
        for <linux-cifs@vger.kernel.org>; Mon, 26 Aug 2019 07:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fJMjRqfE6xl6N8fDlKv6iKb7xT5HXvz9BDOjyOZH+Eg=;
        b=kQtT9FB5kswQKE43up/GMApCUscsyXPbjNxevRDV6hSa4lGVRywZpvJTZ9m1Hc4okN
         QmUIwchyKzp8ZbyrXmsKacy39YeUevfvBcl/LaU3/Mih+mobVws00bM7B7C4rAD02Iif
         Q2I2mpqQetzgdePVpZSBk66lU1+dxvCRbrN1iyepSTTy8Gapp74VSDiKxOrrn+ty7X1X
         KKgYVXcCyH60a5JjAYAUCMDUCyDKeblhhDlrLCgsGJc0oMciFbhXN0mPPE2T3Vkgw2YR
         Ochq/vs5OCnW5jlNDL7vJ7iFZNr3G7X9duPD+Fm6Q9MxoSSaEtBMgw9hJVqCU+FjWGO8
         dyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fJMjRqfE6xl6N8fDlKv6iKb7xT5HXvz9BDOjyOZH+Eg=;
        b=mi3Mc4LUDRSrsSDVh2j1VaKNFpW3LlRspV0jNNL2DIyVZtzNi5bwlAbIrDZmL10mT4
         Q9aXWs7yQj6YFAcNUppadh8AfkoH+dmbBbLVpBtvAO8JOS/pWAL6rbRWPAJLL7/7xk6p
         duOtH3bTyVHRq9u1mtK0h5K+s9rMa7+sU0nB5gZRERfoX193h2Q2YzVS+FBU/6vYzjam
         iNMMK5+pFZSDNesthckkUnbFJf9PBTp5we+Kw7r/M6fyb54teWFuM2bi9m+LRuPman7y
         73ujKOHEuMBjcbitaQtaZYjdI7tyoQjF9ibxA7BXRGa/FJZGGbrF9mVCQBOD0ZpgYjif
         wt8A==
X-Gm-Message-State: APjAAAWlBCISdlukn8+pJhIxQYYfv99GVibicsgq5mStCD7PTM/0erwQ
        NtRleSIJoYeQQtHBibOvvNGvkdMCnoDNdC2B/t/fNPLJAWo=
X-Google-Smtp-Source: APXvYqzHBLHqVGIGKrsr/UvGi4olJ1v9OvwFwbHRQ7vZ6VYdBvPwpXHFWXH4zwIuU2+t87ejQviQlVTMttTz72J+9Gs=
X-Received: by 2002:a02:b156:: with SMTP id s22mr4734670jah.132.1566831355573;
 Mon, 26 Aug 2019 07:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
In-Reply-To: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Aug 2019 09:55:44 -0500
Message-ID: <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     James Wettenhall <james.wettenhall@monash.edu>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If you think that the disconnects are due to timeouts accessing files
on offline storage you can also try mounting with the "hard" mount
option.  The mount parm "echo_interval" can be also increased to make
it less likely that we give up on an unresponsive server (it defaults
to 60 seconds and can set to maximum of "echo_interval=600" ie 600
seconds).

There were many fixes relating to crediting and reconnection that went
in almost a year ago, but would not be in an older kernel like 4.15
unless Ubuntu backported them.   Fortunately, Ubuntu makes it very
easy to test if the fix is in a newer kernel by installing (as a test)
a newer kernel on your client for doing an experiment like this (see
https://wiki.ubuntu.com/Kernel/MainlineBuilds).

If after installing a more recent mainline kernel as a quick test, if
you don't see the reconnect problem, this would make it easier to ask
Ubuntu to backport the various reconnect fixes marked for stable that
went in late last year (or you could continue to use the more recent
kernel).

Also note that it is possible with dynamic tracing now in cifs.ko to
do easier tracing of reconnect events (or all cifs events "trace-cmd
record -e cifs") which can sometimes help narrow down the cause.
Reconnect statistics are also updated in /proc/fs/cifs/Stats

On Mon, Aug 26, 2019 at 1:57 AM James Wettenhall
<james.wettenhall@monash.edu> wrote:
>
> Hi,
>
> We run a Django / Celery application which makes heavy use of CIFS
> mounts.  We are experiencing frequent reconnections / session startups
> and would like to understand how to avoid hammering the CIFS server
> and/or the authentication server.  We've had multiple reports of
> DoS-like hammering from server admins, causing frequent
> re-authentication attempts and in one case causing core dumps on the
> CIFS server.
>
> Our CIFS client VMs have the following:
>
> OS: Ubuntu 18.04.3
> Kernel: 4.15.0-58-generic
> mount.cifs: 6.8
>
> Current mount options:
> rw,relatime,vers=3.0,sec=ntlmssp,cache=strict,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1
>
> We don't run the CIFS server, but we can request any information
> required to diagnose the issue.
>
> Over the past 10 hours, one of our virtual machine's kernel log has accumulated:
>
> 8453 kern.log messages including "CIFS"
>
> To break that down, we have:
>
> 8305 "Free previous auth_key.response" messages
> 111 "validate protocol negotiate failed: -11" messages
> 26 "Close unmatched open" messages
> 7 "has not responded in 120 seconds" messages
> 4  "cifs_mount failed w/return code = -11" messages
>
> The server is an HSM (Hierarchical Storage Management) system, so it
> can be slow to respond if our application requests a file which is
> only available on tape, not on disk.
>
> The most common operation our application is performing on the
> CIFS-mounted files is calculating MD5 checksums - with many Celery
> worker processes running concurrently.
>
> We would appreciate any advice on how to investigate further.
>
> Thanks,
> James



-- 
Thanks,

Steve
