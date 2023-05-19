Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5284C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 19 May 2023 14:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjESOPk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 May 2023 10:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjESOPe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 May 2023 10:15:34 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6905E10D1
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 07:15:27 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ae54b623c2so29877355ad.3
        for <linux-cifs@vger.kernel.org>; Fri, 19 May 2023 07:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684505726; x=1687097726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5RSa2sHNFGhHFkCUqFEtwHrXCYjeq7GkI6Wy3n2s3s=;
        b=OLcqtJBv216E1JqQUe5hGrH4ZSm+Xxe90TU+9bmju6gPiAiisJzgzMYKQrOlS2ep/j
         srPZHKeWw6igm6lTXfDfZ4VeZOh+oSxU8TIamR3EEoYMfXPizfqRG4/sOhgbjDg/EIpp
         opp1ZISQeuzw+6t2ot3q8e94OOmfX9sbwktwn6bFaQJ22T7Ce+gmeksgHYnI+j7MiQkc
         boHAs8CErreykrJn9cHaG8O+0oiPudxqGkSOY6kOBfvPw4/rlqxyln181mosxl98Y9r2
         0xd3LoJNHc5aptvdEF4UI3+FczG9tmAe2Opbh/Qn+f+EbDzf3oRHQI/+BLjafWk+9QcC
         icCQ==
X-Gm-Message-State: AC+VfDxLEsSbYD0XXCndYkzOY8xRaHDTWwumtcr3WVM1b1XgI45OZbZD
        cmZMCK2vq4hSMv/jQ+3hz3cu/DrBEGI=
X-Google-Smtp-Source: ACHHUZ5ibxXRLW/fxDAgvzWUn3I+aX3+l2mpHYbPCg7z6JR+Lw4rXDL99M+mSi2Mt6tQPJyMITGdjA==
X-Received: by 2002:a17:902:b616:b0:1a9:4fa1:2747 with SMTP id b22-20020a170902b61600b001a94fa12747mr2353692pls.47.1684505726487;
        Fri, 19 May 2023 07:15:26 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id ba9-20020a170902720900b001ac7af58b66sm3489409plb.224.2023.05.19.07.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 07:15:26 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix incorrect AllocationSize set in smb2_get_info
Date:   Fri, 19 May 2023 23:15:08 +0900
Message-Id: <20230519141508.12694-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230519141508.12694-1-linkinjeon@kernel.org>
References: <20230519141508.12694-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If filesystem support sparse file, ksmbd should return allocated size
using ->i_blocks instead of stat->size. This fix generic/694 xfstests.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a1939ff7c742..7a81541de602 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4369,21 +4369,6 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	return 0;
 }
 
-static unsigned long long get_allocation_size(struct inode *inode,
-					      struct kstat *stat)
-{
-	unsigned long long alloc_size = 0;
-
-	if (!S_ISDIR(stat->mode)) {
-		if ((inode->i_blocks << 9) <= stat->size)
-			alloc_size = stat->size;
-		else
-			alloc_size = inode->i_blocks << 9;
-	}
-
-	return alloc_size;
-}
-
 static void get_file_standard_info(struct smb2_query_info_rsp *rsp,
 				   struct ksmbd_file *fp, void *rsp_org)
 {
@@ -4398,7 +4383,7 @@ static void get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	sinfo = (struct smb2_file_standard_info *)rsp->Buffer;
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
-	sinfo->AllocationSize = cpu_to_le64(get_allocation_size(inode, &stat));
+	sinfo->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
 	sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	sinfo->NumberOfLinks = cpu_to_le32(get_nlink(&stat) - delete_pending);
 	sinfo->DeletePending = delete_pending;
@@ -4463,7 +4448,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	file_info->AllocationSize =
-		cpu_to_le64(get_allocation_size(inode, &stat));
+		cpu_to_le64(inode->i_blocks << 9);
 	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	file_info->NumberOfLinks =
 			cpu_to_le32(get_nlink(&stat) - delete_pending);
@@ -4652,7 +4637,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->AllocationSize =
-		cpu_to_le64(get_allocation_size(inode, &stat));
+		cpu_to_le64(inode->i_blocks << 9);
 	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
-- 
2.25.1

