Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F92C35242
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 04:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D08132168B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 04:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n0jaawlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgBNEfW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Feb 2020 23:35:22 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34996 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgBNEfW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Feb 2020 23:35:22 -0500
Received: by mail-pg1-f193.google.com with SMTP id v23so899294pgk.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2020 20:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=0JcW5iKglT5in1H/IpofWtmIeNuK0pf55tEOvpF1Jzg=;
        b=n0jaawlxx9pRLzmt8E5rN+hByNBUfcTG8CYOFWzrlZMG5+3wIwZNwJkH9R4f71AKMh
         cXisRiIFQOp1SuqlsenNyUc9CPtdq31FyQFMOWuqsT7ZkQc8csElFoKs+6oXIHJ7ZdCk
         vOKtJFjgDANaInQZeBogoK+AnjwlzqwLlTdIdjETUho3hME0hXvLJny4gsvrbG5L8SqX
         UVwyOlQax0ICgCEg/2WTPxYOpILSxOOKUcg3sb/Nd9zdmXS/B/FwBGwbbnGeNhqnkVa8
         gxXKGxiw74rxFH/NUcFCk5+9BifQCKkwDKNOP4vnQBLykOeJaxv3CAk1ePcyjAgoNr1g
         xxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=0JcW5iKglT5in1H/IpofWtmIeNuK0pf55tEOvpF1Jzg=;
        b=MsX/dAfreVLFz06ADvkYtc061R3P/LY6xBT3SVSFNN1gqyQ5Ef4FazmTdhqehLmxqu
         u772CPdLQpJkGkdSsZSIPZGWUoUgiaucOFLrFXHfutYQ6TY/pqLVLCtrHwjIwrLbXMh2
         Og1EN3r0qBZCe/BqJ4Xws25hxr5feiLTCiyO2JQkZYUFffub7OIob2hoyH6Q0PzNs9Vt
         ZUqVoekGnz1JynlZsiNMQB6OCHOeioa+b5d+7b/3DSV/gajKcBRmDt6HvwRr8bbWg0GZ
         dETZbY/QhvOtqkgodcpYrm9fjN83+efk77sewAi1wsOIrimmMBWb0zowrRuKj+NaBdm3
         ZhuQ==
X-Gm-Message-State: APjAAAVkXIrhGw7TufakR4hdm0x7Ptr/6WJQ6/nUPfUX5hHrGI5VWkUR
        NhTsz1OjlXP4K6Vck+X4IkTcGP38
X-Google-Smtp-Source: APXvYqxNy0fjdO5t33BUH8WBHZgIIiVc41Pnw5q3zweVjizVDW+bv7UJFz4cCsNxgVeEMOGnmBe2Ww==
X-Received: by 2002:a63:34e:: with SMTP id 75mr1499881pgd.286.1581654921150;
        Thu, 13 Feb 2020 20:35:21 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c10sm4824190pgj.49.2020.02.13.20.35.20
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 20:35:20 -0800 (PST)
Date:   Fri, 14 Feb 2020 12:35:13 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH] CIFS: unlock file across process
Message-ID: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Now child can't unlock the same file that has been locked by
parent. Fix this by not skipping unlock if requesting from
different process.

Patch tested by LTP and xfstests using samba server.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/cifs/smb2file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index afe1f03aabe3..b5bca0e13d51 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -151,8 +151,6 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		    (flock->fl_start + length) <
 		    (li->offset + li->length))
 			continue;
-		if (current->tgid != li->pid)
-			continue;
 		if (cinode->can_cache_brlcks) {
 			/*
 			 * We can cache brlock requests - simply remove a lock
-- 
2.20.1

