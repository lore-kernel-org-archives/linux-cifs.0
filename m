Return-Path: <SRS0=wwpQ=7K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9010CC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 28 May 2020 21:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 696E820723
	for <linux-cifs@archiver.kernel.org>; Thu, 28 May 2020 21:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q41Pt4/Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436550AbgE1Vba (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 May 2020 17:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436505AbgE1Vb3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 May 2020 17:31:29 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F26C08C5C6
        for <linux-cifs@vger.kernel.org>; Thu, 28 May 2020 14:31:28 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id b131so81032ybg.13
        for <linux-cifs@vger.kernel.org>; Thu, 28 May 2020 14:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jajgl6yCVCvKV0Lns7uXcCV4P4KKr7pgluUQHRdIcYg=;
        b=Q41Pt4/YzSaqByuMZRxUZLIEN1RYnsL4Pd4zfT5LCM6E9px8tLBEcWQ5AGDiiT5M+h
         NZQx2GsQhfrzS2SumElZvEbIargtu0MB7dkcIBqtEUG+kJ/gwhBULI1v7hZcyUKDnQqJ
         xZGZGBxtSQK+/UWgHSrlx4qeksrol0uj5FfyZ+GlVgjEgXH5CG/T1/XyFWDVJItAq4uY
         6P4KWeLCU8pUSnVQdIAxedflE+MLEl42ghy83OTWf85TlAakB6J4QYtebWi9Tox7rIvY
         OhfPhBHLhl/CEmuN0QAqruapx/sSPN2vHhb35UAIYHSyXqc9S30FSNBL2smyqz8HXYI8
         RNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jajgl6yCVCvKV0Lns7uXcCV4P4KKr7pgluUQHRdIcYg=;
        b=SjF8+IfpMTyRLTKdtknXUQuOpOfAM03r4jXufVAQcLS7+bP6DWI69vBNUV4bN+xh7z
         DuGyxMNgkdcUaWlhgXGeFMNIXkVGLnBUP0R6wqecwIMSZ88KyoLPJKbspz21XY2BrXmQ
         A5nChHuloh6iK+7b9siDrRgGF84KwFyuDTu/SfS2HZszSh/CJSaDCG+CUJr3nagrD0Nz
         kFXm6rpJmRkmvN1C3vzNWEuzvzL9QLBiPx7AwnHOIxGcTN4LU1Pdeg5C6hmcRdJVgYof
         J2tfWPx3LXfigImNLwD7utWM4ueWiZk2vk9/8PyAERWPhtvlOtsmqc1RHOYznetb2qtG
         5ebA==
X-Gm-Message-State: AOAM530ZdmRCcdmVV8Id95ceWf/kNWu3TjE94FrUzPRWqlbAseJ/3vOJ
        SJVA5rxX+tlS8woPRR/cbvp4OvnTFJw/K7SF5cRycnOhQBw=
X-Google-Smtp-Source: ABdhPJz5ujRnIRseAFJd3uVQR92TMQXindLHjT0SYskhqex5UAWCaUC/AkpyrZL3XBhQmFb5JNt7XO4LSUynz8M40Co=
X-Received: by 2002:a25:f309:: with SMTP id c9mr7805649ybs.364.1590701488049;
 Thu, 28 May 2020 14:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <c9a53d2c-98ab-84a3-b395-aff537b9c882@meduniwien.ac.at>
In-Reply-To: <c9a53d2c-98ab-84a3-b395-aff537b9c882@meduniwien.ac.at>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 May 2020 16:31:17 -0500
Message-ID: <CAH2r5msOOQ3BY+4L4MNDEJU1Lrer1gt0ZwdjE2K0zdurabthsQ@mail.gmail.com>
Subject: Re: almost no CIFS stats?
To:     Matthias Leopold <matthias.leopold@meduniwien.ac.at>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stats should show counters for most rows.   See example below:

# cat /proc/fs/cifs/Stats
Resources in use
CIFS Session: 1
Share (unique mount targets): 2
SMB Request/Response Buffer: 1 Pool size: 5
SMB Small Req/Resp Buffer: 1 Pool size: 30
Operations (MIDs): 0

0 session 0 share reconnects
Total vfs operations: 36 maximum at one time: 2

Max requests in flight: 3
1) \\localhost\test
SMBs: 67
Bytes read: 90177536  Bytes written: 2
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 12 total 0 failed
Closes: 13 total 1 failed
Flushes: 1 total 0 failed
Reads: 22 total 0 failed
Writes: 1 total 0 failed
Locks: 0 total 0 failed
IOCTLs: 1 total 1 failed
QueryDirectories: 2 total 0 failed
ChangeNotifies: 0 total 0 failed
QueryInfos: 12 total 0 failed
SetInfos: 2 total 0 failed
OplockBreaks: 0 sent 0 failed


Are you running an old kernel (pre-5.0 e.g.)?

On Thu, May 28, 2020 at 3:39 PM Matthias Leopold
<matthias.leopold@meduniwien.ac.at> wrote:
>
> Hi,
>
> I'm trying to debug the performance of rsync reading from a Windows 2012
> R2 share mounted readonly in CentOS 7. I tried to use cifsiostat, which
> doesn't print any stats. I looked into /proc/fs/cifs/Stats and saw that
> it contains mostly "0" for counters (I would expect to see some numbers
> for eg "Reads"). What am I doing wrong?
>
> options from /proc/mounts are
> ro,relatime,vers=3.0,cache=strict,username=foo,domain=xxx,uid=1706,forceuid,gid=1676,forcegid,addr=10.110.81.122,file_mode=0660,dir_mode=0770,soft,nounix,serverino,mapposix,rsize=61440,wsize=1048576,echo_interval=60,actimeo=1
>
> thx
> Matthias



-- 
Thanks,

Steve
