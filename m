Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4E0C4360F
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 06:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D58532086C
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 06:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYy5k2W0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbfCZGiZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 02:38:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44958 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732530AbfCZGiY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 02:38:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id y5so6926386qkc.11
        for <linux-cifs@vger.kernel.org>; Mon, 25 Mar 2019 23:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kdHRjt4/IPz5AXiZ9FVSm11IQOiL71ZyR6agwOlqb08=;
        b=QYy5k2W0Sx5SDYps9/d4AoQSm/OOGeu47YYfyq0Jw+QJ3e80E6QfRowZAvR4961130
         LG6QaTE0+1DvifyIPmDgBBBTlchLugbXyIxVpp9Av0/LRcMcJ6YLGA10tcXjV4yZQ3sS
         xh6B9uHlVzS0Uq7AzU3KghlZbTIEyCj4KED96Yt0PlOc8Xb1nrbJOGzus20vnLzDlpog
         tzNf1cTYl9nxpCJ8LdIGP7AdB89nDNEEAq6DNUmONdxNBtWVQLaQHyNzPS1qIgPjvWae
         eXxxkNXWuxqa/qe8tmeBvrvTZzVPjrrFu9RJDDu2pQW9oncGVsXyD10mPcptZBy0xzRs
         qFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kdHRjt4/IPz5AXiZ9FVSm11IQOiL71ZyR6agwOlqb08=;
        b=E3SmonygBd2XKSY6yuSb0BqqomyMlxW0auNbtaDE6Po/Pq/w14KVGl7gfrzlX4b14v
         hdy4ZnXx30NHtVEqjUhbd8KzTJn+Wz0k0KCEcrMvMILMhMS3Ls1sv6nTDd2lajPK32rX
         dKxyKKSjhdaGyel4gQScBMnCiIksVriwbWJiu6XF8g/xbDyl/rhQvaID4KIbLL0NhotW
         x1XQfvbN+IrbiLkdTu1+PdaVnrxL4BZ2kMiqRE54YiPkjRx2zQe9Aw1SKsM+YuaTC4g8
         9JQw4dwF05nB1wxuFa2kNDsfla89qE3ACOpc9vjtVL57enTzdjuh/v5XsL0iIAqvAEYd
         jroQ==
X-Gm-Message-State: APjAAAUuCVX2FGV0w0UVXMIJ4t7021lu0vXQW6sOnDWyQDWmYtf3A+n8
        XR+JRl8zoB5nKYPFQDQ2Z9rI2hpe9BZ7lur4QIY=
X-Google-Smtp-Source: APXvYqwenzizD34kwxeI7EDzI50d11H03ayS49hL3CPWtqWZ/CGNfHg0HiGlwk2MDVaSNr4qMo/KewK36N4P/SEuEwQ=
X-Received: by 2002:a37:9fc6:: with SMTP id i189mr23183085qke.246.1553582304034;
 Mon, 25 Mar 2019 23:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+oJ8PpAbsmTmRDqoS4C=dcNV=xYv3tMWnoigA5JqFsA@mail.gmail.com>
In-Reply-To: <CAH2r5ms+oJ8PpAbsmTmRDqoS4C=dcNV=xYv3tMWnoigA5JqFsA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 26 Mar 2019 16:38:13 +1000
Message-ID: <CAN05THRYrWBi9cSB5-gbV_y9cAf+0KTPn-2ogPc7SU2t9ob6UQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] Track time spent in each command
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Very nice.
But maybe min and max to each command as well.
I have all three of min/max/avg is very useful.

At least avg and max will tell you if there are any abnormal outliers.

On Tue, Mar 26, 2019 at 3:39 PM Steve French <smfrench@gmail.com> wrote:
>
> I created a small experimental patch (leveraging the existing code for
> the slow command check we already have in mid processing) to track the
> total time per SMB2/SMB3 command.   Seems like it could be useful -
> here is sample output (see below) from running seven xfstests to
> generate the stats (these stats require CONFIG_CIFS_STATS2 to be
> compiled as do the slow command counters).   I wanted to keep the
> patch small and low risk so this seemed like the best place to capture
> it.    This could be helpful in calculating average time per command
> (and perhaps help isolate performance problems, and isolate what is
> really causing slowdowns).   As with other counters: "echo 0 >
> /proc/fs/cifs/Stats" resets them.   The new stats counters start at
> the line "Total time spent processing each command"
>
> Thoughts?
>
> $ cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 3
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 2 Pool size: 30
> Total Large 60864 Small 1165977 Allocations
> Operations (MIDs): 1
>
> 0 session 0 share reconnects
> Total vfs operations: 280236 maximum at one time: 3
> Total time spent processing each command
> cmd: 0 jiffies: 0 seconds 0
> cmd: 1 jiffies: 2 seconds 0
> cmd: 2 jiffies: 0 seconds 0
> cmd: 3 jiffies: 1 seconds 0
> cmd: 4 jiffies: 1 seconds 0
> cmd: 5 jiffies: 6212 seconds 24
> cmd: 6 jiffies: 3993 seconds 15
> cmd: 7 jiffies: 135 seconds 0
> cmd: 8 jiffies: 83 seconds 0
> cmd: 9 jiffies: 44 seconds 0
> cmd: 10 jiffies: 0 seconds 0
> cmd: 11 jiffies: 1 seconds 0
> cmd: 12 jiffies: 0 seconds 0
> cmd: 13 jiffies: 0 seconds 0
> cmd: 14 jiffies: 47 seconds 0
> cmd: 15 jiffies: 0 seconds 0
> cmd: 16 jiffies: 1890 seconds 7
> cmd: 17 jiffies: 1368 seconds 5
> cmd: 18 jiffies: 0 seconds 0
>
> 1) \\localhost\btrfs-scratch
> SMBs: 42255
> Bytes read: 25379425  Bytes written: 53689661
> Open files: 1 total (local), 1 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 14012 total 0 failed
> Closes: 14009 total 0 failed
> Flushes: 27 total 0 failed
> Reads: 41 total 0 failed
> Writes: 112 total 0 failed
> Locks: 0 total 0 failed
> IOCTLs: 2 total 1 failed
> QueryDirectories: 28 total 0 failed
> ChangeNotifies: 0 total 0 failed
> QueryInfos: 11312 total 0 failed
> SetInfos: 2711 total 0 failed
> OplockBreaks: 0 sent 0 failed
> 2) \\localhost\btrfs
> SMBs: 77
> Bytes read: 282  Bytes written: 94
> Open files: 0 total (local), 0 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 23 total 0 failed
> Closes: 21 total 0 failed
> Flushes: 0 total 0 failed
> Reads: 3 total 0 failed
> Writes: 1 total 0 failed
> Locks: 0 total 0 failed
>
> --
> Thanks,
>
> Steve
