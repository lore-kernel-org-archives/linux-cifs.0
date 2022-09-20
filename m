Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E12C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 13:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiITNVJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 09:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiITNVI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 09:21:08 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A7B4B4B4
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 06:21:06 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id f23so2345410plr.6
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 06:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1aawr18KpuWrUUAhjpSuzcNQ554sgmWs/WMiARBkcqs=;
        b=2RPOluo3HVQ/f3yHNAfNWj6nvwdGWurxAopqL8QOc5P9cNPhkGzjmF2+aBxkyyThZy
         9aTCYOX8WfLKs5EWV3Whf93c8hl8DeVNm0vdyWIwH8H3LspQBp1f5J4VMHuHtvSO1jer
         buXpkccNzI8PVNRU/OoqyIiU2RmyTykAw5EzFFed8B/kldgVELrGbOquwefZREKcHIKK
         rzqYNccky35w/LSwrK611mjBpfrZ3P+Y/cgWrWzZLyNhFkH/6BR/Ekk6x5HsbYUNurOy
         zIraxvVCVkeL/3UTvdxsNL+4OGC65a5a+XSO+O23vQmFSSUuP9x2BCtCzDaQv17x2Brw
         0U8w==
X-Gm-Message-State: ACrzQf2Jw4dGGUN5CeOonupoC0AtTTFNJZbyohkbcjRXYaCi110LTR7V
        27z4M08ZOa89lzJ32yaO114d6N7dmvY=
X-Google-Smtp-Source: AMsMyM41e/co2s79H6hGflxZuuMfhoazU+IDqoC8ir6l6E++ICM7+LSNDZl9ia6I/OZjMqLVB8/qpg==
X-Received: by 2002:a17:902:784d:b0:178:6946:3ff7 with SMTP id e13-20020a170902784d00b0017869463ff7mr4798357pln.133.1663680065582;
        Tue, 20 Sep 2022 06:21:05 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id ix18-20020a170902f81200b001767f6f04efsm1360851plb.242.2022.09.20.06.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:21:05 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
Date:   Tue, 20 Sep 2022 22:20:45 +0900
Message-Id: <20220920132045.5055-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220920132045.5055-1-linkinjeon@kernel.org>
References: <20220920132045.5055-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 5c797cc09494..9dd6033bc4de 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4717,6 +4717,9 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 {
 	struct smb311_posix_qinfo *file_info;
 	struct inode *inode = file_inode(fp->filp);
+	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
+	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
 	u64 time;
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
@@ -4734,9 +4737,15 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
 	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
 	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
+
+	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
+		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
+	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
+		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
+
 	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
-	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
+		cpu_to_le32(sizeof(struct smb311_posix_qinfo) + 32);
+	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo) + 32);
 	return 0;
 }
 
@@ -4858,7 +4867,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			rc = -EOPNOTSUPP;
 		} else {
 			rc = find_file_posix_info(rsp, fp, work->response_buf);
-			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
+			file_infoclass_size = sizeof(struct smb311_posix_qinfo) + 32;
 		}
 		break;
 	default:
-- 
2.25.1

