Return-Path: <SRS0=0u7K=V2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F1DC7618F
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jul 2019 03:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BA232070D
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jul 2019 03:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SDaOoepU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbfG2DDR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Jul 2019 23:03:17 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35925 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfG2DDR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 Jul 2019 23:03:17 -0400
Received: by mail-ed1-f68.google.com with SMTP id k21so57970950edq.3
        for <linux-cifs@vger.kernel.org>; Sun, 28 Jul 2019 20:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6PBvz6eEVLZ61i5PtyEreC4CNb6zOf6fPIxJMuL8+HM=;
        b=SDaOoepUHj9Y5g2Jfnb0QdFChghGavPwTEk8zFQ4FDUoJZloVZoRlOinhzifOE/cus
         GgXIXseGHZlFxOzPDLFput/e7em6r4+HSiSzZe13syW1Gs3oUYhPmwtTlxEP0I/tLtgt
         /3K+redUF3UXAJpaOhWuO3TTOGxHh+8gTz1jFK/Ij0oAPE5BgrwqJ1ttChPDcwr7MGUf
         7lHCNLYM7fRD0SBMVm/BObw1cR2r9QKFKnour8Z2X/iiVMJsLNZojKfq4DVc1hGcXZpg
         oRbW6P5oxfWH8txn0YP9LPRKoofVYjqADuEcZaSR6I88SfVwLf7UUpQOSYoI7c45GBcG
         /hKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6PBvz6eEVLZ61i5PtyEreC4CNb6zOf6fPIxJMuL8+HM=;
        b=A5ma8S5JbBSxytGGjMDFjjQSwiL6sx2rAspCVCWGv3j25R44AFMAAyOb2RK8TWW9HU
         6kuuLVuwruXfyUlhQVy8fi6uroir9yTtZGtRZ20zOqPtYKDVfcicfLcbfKMbGBBD/RE7
         MhX9s5EHmmpXAzmwmZvrgyXFOyCuT8olqe/UgrfZFl8QDWUnpyxC9nlDn6F6Tvh2M+8C
         GGmLLV6FoTNO3Ki+neMvFAlzhhqZGFA09IeMVoveqZ1wvMffPo33Ijmb7LSLnMrqviTo
         seXyCuFugkoiDCyHaP7KdBEWo3nMSkrjX4OM4aLFt9gjFkmPpRNHQU9AtICEQhReRr4F
         CX4w==
X-Gm-Message-State: APjAAAU3ynH0l+l+AhxQcgDWbacY00t81537tv/DjHrTdFMIkHdQhCIS
        hIOFR+Fu+xJa/ezcoGMjqFa4qE8zqLK0v+3Lb54=
X-Google-Smtp-Source: APXvYqwnEJhTiNgWcyoBLiFQmIrPqKBv6P0RWVUyIQ3oZK2i2qJL+sEjVQbz5QaylAlE7CGL98clNzfB7tlqOMq+wMw=
X-Received: by 2002:a50:f4dd:: with SMTP id v29mr93413957edm.246.1564369395322;
 Sun, 28 Jul 2019 20:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <CANidX5ScMgPfd_7N9QMTv3+nhzBxtE7tQVhrAncjrH0JG7q4vg@mail.gmail.com>
 <CAH2r5msU5Qkxcr-kM5seH_2HoUz=hkO+VDCjdEFCPRZh=a3W7A@mail.gmail.com>
In-Reply-To: <CAH2r5msU5Qkxcr-kM5seH_2HoUz=hkO+VDCjdEFCPRZh=a3W7A@mail.gmail.com>
From:   Gefei Li <gefeili.2013@gmail.com>
Date:   Mon, 29 Jul 2019 11:03:04 +0800
Message-ID: <CANidX5SRoxMHtm042arPxMUXP1SCoYOkg1SMxYL7RMvzW6mnGA@mail.gmail.com>
Subject: Re: Search for advice on testing whether a local CIFS fd closed remotely
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks a lot for the '/proc/fs/cifs/Stats | grep "Open files"' tip,
Steve. But it seems not working in my case(not crashing case).

I have an SMB server that is able to close handles from server side,
and if closed remotely I want to check from client side. I've done
several experiments:
1. CIFS client open, server side close
  -  both "/proc/fs/cifs/Stats" and "cat /proc/fs/cifs/open_files"
remain unchanged
2. CIFS client open, server side close, client side call "close"
function to check fd
  - "Closes" in "/proc/fs/cifs/Stats" changes "4 total 1 failed"    <-
1 failed due to server side closed?
3. CIFS client open, server side close, client side call "read"
function to check fd
  - EBADF returned while trying to "read", this is what I expect.  But
for dir handle and WR-only handles, which function should I use?

Regards,
Gefei

On Sun, Jul 28, 2019 at 8:08 AM Steve French <smfrench@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 3:22 AM Gefei Li <gefeili.2013@gmail.com> wrote:
> >
> > Hi,
> >
> > From some stack overflow result I know that on a local ext4/fat32
> > system, we can test whether a file descriptor is valid through
> > "fcntl(fd, F_GETFD)". But in cifs cases, a fd typically bind a local
> > fd to remote handle, do we have some c function/syscall that can test
> > whether the fd is remotely closed?
> >
> > I've tried some windows way like "ioctl", which works well, and in
> > linux local file system "fcntl" works. Tried to use "fcntl" on kernel
> > 5.1.15, found no server request is received.. Could you please give me
> > some advice on testing whether a fd is remoted closed in CIFS client?
>
> both F_GETFD and F_GETFL look like they check in the local VFS only
> (aren't passed down to the file system, whether ext4 or cifs or even nfs)
> for the value of these flags (see do_fcntl function in fs/fcntl.c)
>
> In general an open of a file (over an SMB3 mount) will result in a open
> over a file on the server.   You can see the detailed information on
> the network file handle ("PersistentFileID") open on the server by (on
> the Linux client) doing:
>
>        cat /proc/fs/cifs/open_files
>
> If you were worried about a network crash temporarily closing remote handles
> (in which case you might temporarily have a local handle which is not
> open on the
> server) you could (in theory) do:
>
>       /proc/fs/cifs/Stats | grep "Open files"
>
> but I did notice a bug (in the processing of one of those counters for
> that /proc file)
> in which we are leaking one of those two counters (the counter is
> informational only
> so presumably not a serious bug) and it can go negative so looking at the count
> of open files on the server may not be as useful.
>
> --
> Thanks,
>
> Steve
