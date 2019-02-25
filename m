Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF8DC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 17:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A70820684
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 17:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHSnQhYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfBYRRq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 12:17:46 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:43106 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfBYRRp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 12:17:45 -0500
Received: by mail-pf1-f170.google.com with SMTP id q17so4783302pfh.10
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 09:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=5vJpn/gY//jtq3eKl28MfTzhgsz3E2e5wOsRsHKdusc=;
        b=JHSnQhYRpAVy7P9JxOhSzEzMxYRr7QlLLjuW0etAeWWh2ztUvF1PQlU7fsw0kVkFwn
         AaH5RT0Xb06tO3uKngyHjhV0rgiKjhLJRlzzr87mnyecpIwf/saaFUn74ZR318j/9Xan
         wK7C+GB8DKgkQfl9wtxowZKGzHjCtY+1SjoFN883YVqrSedb9ebfzqwkSN/9NLN6yyZI
         poiCdBVa0kqq56j8Mqpn11LNVatbnVJ9NmRNKCQrdhdzYSuoCNkd6LLh4hCpkZxrjL1f
         N8q/HCA5wyzwO/GXTHYbH0j6c2pzXpYgRh+9h2c1LSt4imp4+o8OHEXopVIle+bCQqjC
         rZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5vJpn/gY//jtq3eKl28MfTzhgsz3E2e5wOsRsHKdusc=;
        b=plrLOSa928161agFfJkHEWP1n5Hzr7TB7jmKBMWr0G2J8yhZpfpYIPx3OdQh84vGWa
         SSPc1Np9azQLif+S7a1VajxaLrWyHszfwnurpkBno/AZMuim8VoJcdPJuoFdUiZ0/y4I
         aznI4cEGlmBZl/aCTrt2rgwJeuOFrNfWBMVdiJhCfNMnhNj2Lo01UCFqfwQKKOr8izZc
         XrQyFbceyH+aXh+xwvuuaMQsEFea/B5cAnWkvGGUmf8O6e/LeyMEf01VSGdmPISegEVi
         D0FRk2Ta/pcdJGbZ1K9iEnsmkgIrwMOJWQKS7ze3WzYz3l09BZ0wRQ45AskWfnXtvCqe
         FCVg==
X-Gm-Message-State: AHQUAuZS8LIcabxlLQC+/+NJJIBnVFGMUqhq91mtAPr4y6B4paG+Pk29
        C0712OzwHF05NNi3GgbmmRUvjwNqNp/LRci+vUA=
X-Google-Smtp-Source: AHgI3Ibmp6AZBWe/DYi3lQKApOif5jWAshbW1jcwaKTOmQNlDbgSD1orVD/3raAgdtfaRTPcF77iGzzaBEVQ5fm1/S8=
X-Received: by 2002:a63:2c8a:: with SMTP id s132mr20059555pgs.440.1551115064662;
 Mon, 25 Feb 2019 09:17:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 11:17:33 -0600
Message-ID: <CAH2r5mvD+NS8YV4-kQG9XK05Dfxp3HrvUZ+c23Lwkegh5EOb+w@mail.gmail.com>
Subject: New tracepoints for read/write enter
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like these could be useful -

    "trace-cmd record -e smb3_write* -e smb3_read*"

root@smf-Thinkpad-P51:~/cifs-2.6# echo 0 > /proc/fs/cifs/Stats
root@smf-Thinkpad-P51:~/cifs-2.6# dd if=/dev/urandom of=/mnt1/8M
count=8000 bs=1024
8000+0 records in
8000+0 records out
8192000 bytes (8.2 MB, 7.8 MiB) copied, 0.0694953 s, 118 MB/s
root@smf-Thinkpad-P51:~/cifs-2.6# trace-cmd show
# tracer: nop
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              dd-21812 [006] .... 85789.843915: smb3_write_enter:
xid=0 sid=0x158347 tid=0x6c217504 fid=0x4e73e0d5 offset=0x0
len=0x400000
              dd-21812 [006] .... 85789.845676: smb3_write_enter:
xid=0 sid=0x158347 tid=0x6c217504 fid=0x4e73e0d5 offset=0x400000
len=0x3d0000
           cifsd-16822 [001] .... 85789.848381: smb3_write_done: xid=0
sid=0x158347 tid=0x6c217504 fid=0x4e73e0d5 offset=0x0 len=0x400000
           cifsd-16822 [003] .... 85789.850297: smb3_write_done: xid=0
sid=0x158347 tid=0x6c217504 fid=0x4e73e0d5 offset=0x400000
len=0x3d0000
root@smf-Thinkpad-P51:~/cifs-2.6# cat /proc/fs/cifs/Stats
Resources in use
CIFS Session: 1
Share (unique mount targets): 2
SMB Request/Response Buffer: 1 Pool size: 5
SMB Small Req/Resp Buffer: 1 Pool size: 30
Operations (MIDs): 0

0 session 0 share reconnects
Total vfs operations: 6 maximum at one time: 1

1) \\localhost\scratch
SMBs: 12
Bytes read: 0  Bytes written: 8192000
Open files: 0 total (local), 1 open on server
TreeConnects: 0 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 3 total 0 failed
Closes: 3 total 0 failed
Flushes: 0 total 0 failed
Reads: 0 total 0 failed
Writes: 2 total 0 failed

-- 
Thanks,

Steve
