Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAA9C04AB4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 05:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7752120879
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 05:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dob32DPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfENFxh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 May 2019 01:53:37 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38642 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfENFxg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 May 2019 01:53:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id 14so13121305ljj.5;
        Mon, 13 May 2019 22:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bM8hX4jppxiiULCsRqeT+54oxj9AT3t2fWeo8Qg5H18=;
        b=Dob32DPoL28AKLt8YMC5ibe91NtjpjbzGPVHHk8989EBn9rOV27UBxAiE9y5p9T1nE
         fLc3Sk2ckq+3v/VDhuZq67lIbfDE/2xLNa1ul3s+hN0SwcrsPQHePrwWRU5SmASrF2wB
         Kceqql6z0YU/4HAP2PxGQWot0rJDixIGSMhwGOPWTew8N/0DB7dLXkUmXEqbtYvRgaz2
         v8ZTqlPv+do87EQ162FcrGCOXmTMDMEs8abJno+7PblkZCcjMpNCVO/ctt8bg2R6/alF
         1sjQxbH36CWqJj3CGd7c3FX7clQxVFQl6IeQBFqff3zmwClmL65/2YePRBj8FfXLrmyF
         DtEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bM8hX4jppxiiULCsRqeT+54oxj9AT3t2fWeo8Qg5H18=;
        b=s4pV+oDnGi5BlFcgpiKPxTQg+G2Fds/j2wGKSlUYbEYGLBn3hgtyBwpIJKC8Ws5TBN
         3J7pFTj4t+6jpxKNimwP1nWzAdfiTkDaMiyA+1xizdIbfGq+ZndRqemYBCpS8PBC2r9f
         Pu07Au6CZ8hU155puyZwq7G/VNntQSqcRkNxdd6PbhRO+TwgESKwWk7q2OfOjimmzxOs
         WOitFjHyboSNtfHBR2vG7vqVktLHogpuXE/6OTfvkuN1oRvz5eMaq+1yGBRWIrPVLFMo
         IL6IowLADixISfqRIponMNpi/KON2bHMAARwJUUgYfmG2TrNJaLrCblabImz8gYQ8dlJ
         9wQA==
X-Gm-Message-State: APjAAAX5lIdTZmpbdPiVMrfthGPh1gxqqyC5yGa0M92Q6icXhAydvL88
        m8L+6mVc8HnyV35YMZNKEfQ=
X-Google-Smtp-Source: APXvYqzuGAt6PH1pi+yzKaxNkn0AG7TBFPHbW5+hx5CYlVXf4WXfqqLPsFmrqnUUKbHAmIvFhV4ftQ==
X-Received: by 2002:a2e:89cc:: with SMTP id c12mr11613738ljk.90.1557813214576;
        Mon, 13 May 2019 22:53:34 -0700 (PDT)
Received: from k8s-master.localdomain (kovt.soborka.net. [94.158.152.75])
        by smtp.googlemail.com with ESMTPSA id y7sm3465555ljj.34.2019.05.13.22.53.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 22:53:33 -0700 (PDT)
From:   Kovtunenko Oleksandr <alexander198961@gmail.com>
To:     sfrench@samba.org
Cc:     linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        linux-cifs@vger.kernel.org,
        Kovtunenko Oleksandr <alexander198961@gmail.com>
Subject: [PATCH] Fixed  https://bugzilla.kernel.org/show_bug.cgi?id=202935 allow write on the same file
Date:   Tue, 14 May 2019 05:52:34 +0000
Message-Id: <1557813154-6663-1-git-send-email-alexander198961@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Kovtunenko Oleksandr <alexander198961@gmail.com>
---
 fs/cifs/cifsfs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a05bf1d..2964438 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1073,11 +1073,6 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 
 	cifs_dbg(FYI, "copychunk range\n");
 
-	if (src_inode == target_inode) {
-		rc = -EINVAL;
-		goto out;
-	}
-
 	if (!src_file->private_data || !dst_file->private_data) {
 		rc = -EBADF;
 		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
-- 
1.8.3.1

