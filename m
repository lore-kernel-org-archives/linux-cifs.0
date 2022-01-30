Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA10C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jan 2022 09:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346067AbiA3JfE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 04:35:04 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:41694 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiA3JfD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Jan 2022 04:35:03 -0500
Received: by mail-pj1-f52.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so10812511pjp.0
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 01:35:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SnhexiQVmmAONSx5nCO1R/NLidon3M/7mu7IvRTFeCM=;
        b=caWBzphCz2mmB0wAl5Y11p7BWOCFZ68NtWmRDVCEO/RbTlRwNQkaeJP28CeyDc992g
         6m4MexToavhM5r4TUsyywLkwm7MQcd6YuRhwn7t0Ue3KJgahtXKmtB10Ee5UmrkxpjVN
         6dBTuaG+bP30EP+PD/X0ORJEUViJJ0J4tIVTdj9pCvdAifca/JPHRBN6P9ggRES2I9B2
         1qso6Se6eRw6lctUKWQjOJjRLzYGOVjdchRTg/FfrW/kZWuqbnuIqhXLW/xQGGzUu8fy
         MMq8iVJCxGLCnB9OglNxbahU2rZsjE8IvXzWLyAxFrGl3wxeSU8RSI/uew/73rNVhYJX
         WKCQ==
X-Gm-Message-State: AOAM5302YwO1IllPVWj6eesYIzBw31duXsGa6Px3YIP4Sa8XSzfhwGw5
        4m6HvlTfUxJd1UB7KOueHy9FPK/UiNQ=
X-Google-Smtp-Source: ABdhPJyETm+/TgFKBi1YqwekJbWOCONrmIj4M7CnAhaoKGV+QsrQglmRr6nX6f5ez/I7UoZEpbwMOw==
X-Received: by 2002:a17:902:e844:: with SMTP id t4mr16057298plg.104.1643535303100;
        Sun, 30 Jan 2022 01:35:03 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id l22sm14991798pfc.191.2022.01.30.01.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 01:35:02 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: fix same UniqueId for dot and dotdot entries
Date:   Sun, 30 Jan 2022 18:34:32 +0900
Message-Id: <20220130093433.8319-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220130093433.8319-1-linkinjeon@kernel.org>
References: <20220130093433.8319-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd sets the inode number to UniqueId. However, the same UniqueId for
dot and dotdot entry is set to the inode number of the parent inode.
This patch set them using the current inode and parent inode.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index ef7f42b0290a..9a7e211dbf4f 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -308,14 +308,17 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 	for (i = 0; i < 2; i++) {
 		struct kstat kstat;
 		struct ksmbd_kstat ksmbd_kstat;
+		struct dentry *dentry;
 
 		if (!dir->dot_dotdot[i]) { /* fill dot entry info */
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
+				dentry = dir->filp->f_path.dentry;
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
+				dentry = dir->filp->f_path.dentry->d_parent;
 			}
 
 			if (!match_pattern(d_info->name, d_info->name_len,
@@ -327,7 +330,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 			ksmbd_kstat.kstat = &kstat;
 			ksmbd_vfs_fill_dentry_attrs(work,
 						    user_ns,
-						    dir->filp->f_path.dentry->d_parent,
+						    dentry,
 						    &ksmbd_kstat);
 			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
-- 
2.25.1

