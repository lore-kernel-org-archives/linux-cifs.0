Return-Path: <SRS0=LGzZ=YH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF460C47404
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 07:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A487820854
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 07:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRzdaIn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbfJNHP7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Oct 2019 03:15:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33281 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730109AbfJNHP7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Oct 2019 03:15:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so7623842pls.0;
        Mon, 14 Oct 2019 00:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EcHPy7pjRRYKhGqR1ifh85tAKii20mZHUVwEAWWq4vA=;
        b=DRzdaIn0lZu/lCPx8qOsHxv2FJ25hNx8czlGr6HpoGiM7THWTHGbh7eyXp8vnBrVJ3
         NyoZL/MfiHqr+EZHKDMFdwIS+XHXZGKEnj/z8aZjSrghZuzBE892zmGPjshGRwIbu8qM
         nc6rZB9RC+jcm6nAc3P2b7mee/bwX/THceu9SEHWUTGtwqGRsC9sdktMIRK2oyWapAyC
         8zqkdyfB6pjTkmTdGPqXZ9L9QajddMUn9RdnHFlizPpbxuqS26FdgmmsYhHVvK28Vqd7
         IPGiuwmWRg0PvFksgLR+OttjXm/JRAvCXRWz2hRPgvYSf9c7Fcj3SHgt7HbtaKOZ8kOM
         R/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EcHPy7pjRRYKhGqR1ifh85tAKii20mZHUVwEAWWq4vA=;
        b=W+oeVdwDCpqJfCHwR9Ukr5jQAHcyTRSPM0cEbuqhcREiEAgByjGPo7r+vqI2BtgELf
         GRYRdVU7yQw52vUP71sqfg5XFuNaxL3UJ7tqa1VxrtZIWmVnOdQSxU3qAA3OfGzqnImW
         l/HcNhMIzOPrDy6FGOQ969YW/xiFEqf0nqzVMA14aJicX23TxBZlqVwR7yE+LBDRld+5
         Tl0b7PhuS9iwnS7R4XTJaQxueKuNQ0FneBE3btSNHJ36axj9mSwZDZFGvWy6P3W82e/i
         rbhm8Oc2EZyLq+KCyf/m/Wp/FT+/z9JgSa1JcUV2S61oQ9ic0voJLd/7zzqDkV9aWjQJ
         mzvw==
X-Gm-Message-State: APjAAAU7JMo3E8RSawZ7L84dIvptfDZPcruMXf5vaX7sPtNpNaacturo
        182k+UCjvHCdnHt9NGz6RTI=
X-Google-Smtp-Source: APXvYqxZDui+wwiRJFEgneVvFNMTtPtqLfAE14NpycsMUGeDjokpW4ERCFlIctwnl1RdNiCL8daVgQ==
X-Received: by 2002:a17:902:d90e:: with SMTP id c14mr28542085plz.91.1571037358463;
        Mon, 14 Oct 2019 00:15:58 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id p88sm14971345pjp.22.2019.10.14.00.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 00:15:57 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] cifs: Fix missed free operations
Date:   Mon, 14 Oct 2019 15:15:31 +0800
Message-Id: <20191014071531.12790-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs_setattr_nounix has two paths which miss free operations
for xid and fullpath.
Use goto cifs_setattr_exit like other paths to fix them.

Fixes: aa081859b10c ("cifs: flush before set-info if we have writeable handles")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 fs/cifs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5dcc95b38310..df9377828e2f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2475,9 +2475,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			rc = tcon->ses->server->ops->flush(xid, tcon, &wfile->fid);
 			cifsFileInfo_put(wfile);
 			if (rc)
-				return rc;
+				goto cifs_setattr_exit;
 		} else if (rc != -EBADF)
-			return rc;
+			goto cifs_setattr_exit;
 		else
 			rc = 0;
 	}
-- 
2.20.1

