Return-Path: <SRS0=DlwX=VZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58858C433FF
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Jul 2019 00:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258E02086D
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Jul 2019 00:08:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qb5gCFzj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfG1AIb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Jul 2019 20:08:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36615 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfG1AIb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Jul 2019 20:08:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so26443028pgm.3
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jul 2019 17:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fco8qkjlE6Puhsmc4xymJ+Kj8WlLYKV278v1h6y2g0E=;
        b=Qb5gCFzjW4kF7RjokI9FBMbXtFRepM6joD+SBnWRzlJgS6dYd6KHSA/+zjlhVqX7WN
         zkWCsYMrG+4bFjXVxTJW44ha6IJbl1CLzBNbRu3km7YntJvK685xCfkJwWdg7fuNiySy
         siSiHnHHDkDKkdEzEooxOuiepR4gWxxounyLsOGwVvRPeRriCy0G9recn7pdvighdzaA
         lWG76A/Jrjt73Xn0YFrH4/YguCX3S/qA3AZnFRfNcwXbhtNEhghsUgA1krAlF7MWTuSV
         9kRy7TJVj6YdtnhITATxBZFRgpmH5p8XHyeIRAuc0NPdtBy7rAYO1Bn3LcDMyX8VWv2x
         bozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fco8qkjlE6Puhsmc4xymJ+Kj8WlLYKV278v1h6y2g0E=;
        b=TNhx0WT18FCi0U8TTnbbmos3mdUvBKzSfzByillV8vbbpOJyZ8kNzFM05L8bnPG6d3
         4vwXUcCEbfck3Sb6HNCT9/stlH2v2GfZU6b4diC6TDM/54WmOdpTK/WD1BI7/9MUEwIk
         ThdFnj1Lhipe9svERF1YrQh+XRu6thpmZUHq5PCxBwVdw9TKzVtd21YHfNABJ6n2H79v
         nJjcsvNjK1PzSgDbjUpmTORla2sLclYzZiqa1so2A5oiOiY69sBpKYnatCel9v1JwltO
         SoL94c5yUEm6eiDUsLk6n0o7zYOPRGTJjMh8ixRSYaAHnteUr/7ccSKJP7+lAHRmYC2e
         1nWQ==
X-Gm-Message-State: APjAAAVUhZZbTjvbze1J3Py5+aBW3zt6wv9ZyDQ14M8oDY5a6cp5lpPb
        KO53YuOHP8x7Sh4GMUvy9ROGXc7v6UlVcmXhonTKh/ANy4c=
X-Google-Smtp-Source: APXvYqxdFSewoDWdnA0+5tgT5gCdhfsFllbF/RQzLoXSfvyc+f769XX/zGq/TswvA4I4RHf8y5saQtvOUE6VeoiHHOs=
X-Received: by 2002:a65:6454:: with SMTP id s20mr97822693pgv.15.1564272510313;
 Sat, 27 Jul 2019 17:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <CANidX5ScMgPfd_7N9QMTv3+nhzBxtE7tQVhrAncjrH0JG7q4vg@mail.gmail.com>
In-Reply-To: <CANidX5ScMgPfd_7N9QMTv3+nhzBxtE7tQVhrAncjrH0JG7q4vg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 27 Jul 2019 19:08:18 -0500
Message-ID: <CAH2r5msU5Qkxcr-kM5seH_2HoUz=hkO+VDCjdEFCPRZh=a3W7A@mail.gmail.com>
Subject: Re: Search for advice on testing whether a local CIFS fd closed remotely
To:     Gefei Li <gefeili.2013@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 26, 2019 at 3:22 AM Gefei Li <gefeili.2013@gmail.com> wrote:
>
> Hi,
>
> From some stack overflow result I know that on a local ext4/fat32
> system, we can test whether a file descriptor is valid through
> "fcntl(fd, F_GETFD)". But in cifs cases, a fd typically bind a local
> fd to remote handle, do we have some c function/syscall that can test
> whether the fd is remotely closed?
>
> I've tried some windows way like "ioctl", which works well, and in
> linux local file system "fcntl" works. Tried to use "fcntl" on kernel
> 5.1.15, found no server request is received.. Could you please give me
> some advice on testing whether a fd is remoted closed in CIFS client?

both F_GETFD and F_GETFL look like they check in the local VFS only
(aren't passed down to the file system, whether ext4 or cifs or even nfs)
for the value of these flags (see do_fcntl function in fs/fcntl.c)

In general an open of a file (over an SMB3 mount) will result in a open
over a file on the server.   You can see the detailed information on
the network file handle ("PersistentFileID") open on the server by (on
the Linux client) doing:

       cat /proc/fs/cifs/open_files

If you were worried about a network crash temporarily closing remote handles
(in which case you might temporarily have a local handle which is not
open on the
server) you could (in theory) do:

      /proc/fs/cifs/Stats | grep "Open files"

but I did notice a bug (in the processing of one of those counters for
that /proc file)
in which we are leaking one of those two counters (the counter is
informational only
so presumably not a serious bug) and it can go negative so looking at the count
of open files on the server may not be as useful.

-- 
Thanks,

Steve
