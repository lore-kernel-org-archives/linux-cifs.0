Return-Path: <SRS0=cOZT=UP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C271DC31E49
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Jun 2019 04:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81AAA216C8
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Jun 2019 04:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pt6kDmt5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbfFPES5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Jun 2019 00:18:57 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36200 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfFPES5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Jun 2019 00:18:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id f21so3878607pgi.3
        for <linux-cifs@vger.kernel.org>; Sat, 15 Jun 2019 21:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oXBwVztjAj88fXMXyJXoMrO0OxhqbdJmzdfqog0uSSE=;
        b=Pt6kDmt5IrfWPgAx+wNy2N6HN8ArpCuDlocDfs3TAbejcYeTVht9QoCUcPyV57NUam
         N5i1uTXYCede/nPFfI5e03di2At0yKMB/LIXB3wn5e9ZogHXyzH/bQzjUaB8BYcaBi80
         uPjsU3435fRxySRPyyQwSYzJeXwE2vhZ7eyUjTf9rxA1VzJKcJxsQihkPsMhIZVbBk9n
         QAGjApSgIXmyKWNAE3iWjd6QF5Bsb17+fausBZeuU+CU4guVUZKNHl3khLYm5p4Tgaa9
         teIczMAHe21GXZ4kZ5+Eog8t9enZHi9W39KSDBhAdUt+fKwID6gRYC5ktrzMRn+im3oe
         97Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oXBwVztjAj88fXMXyJXoMrO0OxhqbdJmzdfqog0uSSE=;
        b=EfzTkGbYx0Rl3Ay1P3+9/c2hak5jMcyxCro75WYqns4GF5h+sWYIDdyiL0suSAOIZM
         Z19FP3tnWdNy8/nbg6tumQ/pkqlbjTGy3Cgj8uJZjZcXu43oxyyHSqauY6LmyZNuWfb5
         FIwTrkLKEyCu3YZnbzzwgl06o/wK95hKa35+Kd8cF1Uara3tR8FFXaeL9eV7BWAXy1k+
         hNYAzX+3KgRLMYPORYNjhF3xo10yGhh3eckF2GaIabFDzYMvd5ahsDz7bZmPqQvxvG60
         CMEz+fJ/45FYyFGEZK6Twp0lb7+FpsMoHvh9Xo7QMoC1X7SHHLcsG9sGCSuDrJNfS9UT
         yVnw==
X-Gm-Message-State: APjAAAUHjLTjDkOxgRfD2ZPzctP86NcUrcWPXzPAin5g7W3ICr3F1EGU
        QxK4F+FoFY5uXvzumlvp/ha3ZcRjzkSiCqS+qes4fEVv
X-Google-Smtp-Source: APXvYqxzlSZtZDSVHGB8zqWrd5hLzgGuHsxnuQfoor5TBaxgLdYtM/187Dkkw64kfK8OjTRdfOt1P+9SupB7K0CtIbc=
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr19764693pje.12.1560658736328;
 Sat, 15 Jun 2019 21:18:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 15 Jun 2019 23:18:45 -0500
Message-ID: <CAH2r5mvo9sWf8VoPb8puCDh4HM6WnrMgjs+HyhUzqEZXtuQwtA@mail.gmail.com>
Subject: NT_STATUS_INSUFFICIENT_RESOURCES and retrying writes to Windows 10 servers
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

By default large file copy to Windows 10 can return MANY potentially
retryable errors on write (which we don't retry from the Linux cifs
client) which can cause cp to fail.

It did look like my patch for the problem worked (see below).  Windows
10 returns *A LOT* (about 1/3 of writes in some cases I tried) of
NT_STATUS_INSUFFICIENT_RESOURCES errors (presumably due to the
'blocking operation credit' max of 64 in Windows 10 - see note 203 of
MS-SMB2).

"<203> Section 3.3.4.2: Windows-based servers enforce a configurable
blocking operation credit,
which defaults to 64 on Windows Vista SP1, Windows 7, Windows 8,
Windows 8.1, and, Windows 10,
and defaults to 512 on Windows Server 2008, Windows Server 2008 R2,
Windows Server 2012 ..."

This patch did seem to work around the problem, but perhaps we should
use far fewer credits when mounting to Windows 10 even though they are
giving us enough credits for more? Or change how we do writes to not
do synchronous writes? I haven't seen this problem to Windows 2016 or
2019 but perhaps the explanation on note 203  is all we need to know
... ie that clients can enforce a lower limit than 512

~/cifs-2.6/fs/cifs$ git diff -a
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index e32c264e3adb..82ade16c9501 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -457,7 +457,7 @@ static const struct status_to_posix_error
smb2_error_map_table[] = {
        {STATUS_FILE_INVALID, -EIO, "STATUS_FILE_INVALID"},
        {STATUS_ALLOTTED_SPACE_EXCEEDED, -EIO,
        "STATUS_ALLOTTED_SPACE_EXCEEDED"},
-       {STATUS_INSUFFICIENT_RESOURCES, -EREMOTEIO,
+       {STATUS_INSUFFICIENT_RESOURCES, -EAGAIN,
                                "STATUS_INSUFFICIENT_RESOURCES"},
        {STATUS_DFS_EXIT_PATH_FOUND, -EIO, "STATUS_DFS_EXIT_PATH_FOUND"},
        {STATUS_DEVICE_DATA_ERROR, -EIO, "STATUS_DEVICE_DATA_ERROR"},


e.g. see the number of write errors in my 8GB copy in my test below

# cat /proc/fs/cifs/Stats
Resources in use
CIFS Session: 1
Share (unique mount targets): 2
SMB Request/Response Buffer: 1 Pool size: 5
SMB Small Req/Resp Buffer: 1 Pool size: 30
Operations (MIDs): 0

0 session 0 share reconnects
Total vfs operations: 363 maximum at one time: 2

1) \\10.0.3.4\public-share
SMBs: 14879
Bytes read: 0  Bytes written: 8589934592
Open files: 2 total (local), 0 open on server
TreeConnects: 3 total 0 failed
TreeDisconnects: 0 total 0 failed
Creates: 12 total 0 failed
Closes: 10 total 0 failed
Flushes: 0 total 0 failed
Reads: 0 total 0 failed
Writes: 14838 total 5624 failed
...

Any thoughts?

Any risk that we could run into places where EAGAIN would not be
handled (there are SMB3 commands other than read and write where
NT_STATUS_INSUFFICIENT_RESOURCES could be returned in theory)

-- 
Thanks,

Steve
