Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B8DEB64DC
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jul 2023 12:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjGCMJR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jul 2023 08:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjGCMJR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jul 2023 08:09:17 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509FF109
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jul 2023 05:09:16 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-40355e76338so13548691cf.3
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jul 2023 05:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688386155; x=1690978155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hGxWjPvCF7KbjxE8Fq+J/qIi6/rjNfr8+Jh/0Zya+R0=;
        b=nELA9igknBulFVgfc/SUAi2znNTfFzwYcQf0+opDrn62CTHXypHA/XdZNNyoNz9Gkj
         yQYnC8AjPPBSZDrac1DEqkl5lOB5naMOJO80hQAnHSWQ/yPp7ALCY3m/P8kj7GiuTHm2
         +Md39hqlfiR3Ox+WAFpzw6DCrp+iRBhyqvbsJdVxYe23+BzqK5/qL0E744ZQ5DfMqXXj
         Qshr6S8ffzfXwDWXrPlf8Ac8O1XF5oQR2WYlud7ichSH+uaJMBwv6OGgp1YfjM3bGGsU
         N4SJtVHyhF8/zNDVO2qHKaOJLPBsa4MFVE4es4wom78RchNL5OADIwj1a2KtFqcZXvIu
         NZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688386155; x=1690978155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGxWjPvCF7KbjxE8Fq+J/qIi6/rjNfr8+Jh/0Zya+R0=;
        b=X4rccbWafNylG5Hp/DMXOwhH12/zKD7bbrHXdDMsCjsTfX5zBsWxz0ojq5d7z3X6B7
         po3PzxhY4TARCM6sef87kAhdaAqu1paEE/NgeK6FCdHpzQlzDXxZ4SqpSLQRWsNRA151
         UCjvZXNZGUiEUOUeTbBGwVsMuEYpuMl2c5xTvBdQyjfbkOinRMT66kHYql7dSKh97ZM/
         EO7rr0kMosgrTssRWO8q7kah7hjxRny1DcJbBHTbfY4uYSMQZqDyrv6jyGZAe0lUuzb7
         VbqULEIQ7syQpEu8l2JllXoMimyEwPHb0VV2JthxlBu60qdhOsqFpzNBhFSbyO/QDUYR
         eJ2g==
X-Gm-Message-State: AC+VfDz/Ylg/a6xxkWohjvu9LAqBkqZpHJosjHoPm7h2RYi4MT/X1kXB
        mxqwyJpzG3K0cRSv3mEg7Dk=
X-Google-Smtp-Source: ACHHUZ56hWDmjc2uUBAZxfoFJ6yyKkMf2EFrC3D7dWwlJzIMPLyxmb/fpszT/+dzr20o+kr7SvYb/w==
X-Received: by 2002:ac8:4e55:0:b0:3f3:91bd:a459 with SMTP id e21-20020ac84e55000000b003f391bda459mr12538339qtw.34.1688386155382;
        Mon, 03 Jul 2023 05:09:15 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id r7-20020ac84247000000b00401b060b264sm9150414qtm.9.2023.07.03.05.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 05:09:15 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
Subject: [PATCH] smb: add missing create options for O_DIRECT and O_SYNC flags
Date:   Mon,  3 Jul 2023 12:07:09 +0000
Message-Id: <20230703120709.3610-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The CREATE_NO_BUFFER and CREATE_WRITE_THROUGH file create options
are correctly set in cifs_nt_open and cifs_reopen functions based
on O_DIRECT and O_SYNC flags. However flags are missing during the
file creation process in cifs_atomic_open, this was leading to
successful write operations with O_DIRECT even in case on un-aligned
size. Fixed by setting create options based on open file flags.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/dir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 30b1e1bfd204..4178a7fb2ac2 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -292,6 +292,12 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	 * ACLs
 	 */
 
+	if (oflags & O_SYNC)
+		create_options |= CREATE_WRITE_THROUGH;
+
+	if (oflags & O_DIRECT)
+		create_options |= CREATE_NO_BUFFER;
+
 	if (!server->ops->open) {
 		rc = -ENOSYS;
 		goto out;
-- 
2.34.1

