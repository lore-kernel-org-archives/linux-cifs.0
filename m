Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21921C6FA86
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 14:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiIVOel (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiIVOeQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 10:34:16 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD431F8591
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:34:08 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id b75so9496533pfb.7
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:34:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RP8wpP2tiY8mCPi0wiOomya5fP2TpXSFaew45OqQAxI=;
        b=K3KWcLAhvuHpNBZpcZZLexYozhMN5jFaoAWbpIHhEeJKGoXeLYzz4Xak0iJX54m20q
         FlXMVdVUQ8odXEcqjzRZkCuyBXvY1mLzombtbS/1ueBILZrz2JJK8emFC4KoRshHOLFo
         HeJy7qJVUs9ko1zgFME+pSngz1WR1K4rd8UYIgbB82utpYPu3Is+L1iedlMetimldMe2
         yfsEgtqHaylMqjUauS69jhdgEzClYpCtadWzNQ9toSVBCAuUZS7fPj4Ika99qMfRWZHh
         jU/tiP07VkXPrE9+j8YAq4VS0l0VBSyAak6C+938Laqs5+Pf1lhHdHw4AnhhxZioL7z6
         /1QQ==
X-Gm-Message-State: ACrzQf21mGb0ZldpcnHHzib+0Kb3gf/Li3geXIS8edOreWORgsY7AQC8
        uM6syS997IPiwl1Y95oLmZlt3sScKEM=
X-Google-Smtp-Source: AMsMyM7VMpGgvGDyFph30auR0BfgSbwpr8aAHqoKfN5A2DDcpxdnu4c2mV2vdE9qd1qOW8M65DayWw==
X-Received: by 2002:a05:6a00:9a7:b0:54c:27c4:3ad6 with SMTP id u39-20020a056a0009a700b0054c27c43ad6mr4072690pfg.9.1663857247409;
        Thu, 22 Sep 2022 07:34:07 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id iw20-20020a170903045400b00177324a7862sm4132808plb.45.2022.09.22.07.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:34:06 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 3/3] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
Date:   Thu, 22 Sep 2022 23:33:38 +0900
Message-Id: <20220922143338.10368-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922143338.10368-1-linkinjeon@kernel.org>
References: <20220922143338.10368-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - add the comment for Sids.

 fs/ksmbd/smb2pdu.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0605e18bd998..6f48b6331bfc 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4722,7 +4722,11 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 {
 	struct smb311_posix_qinfo *file_info;
 	struct inode *inode = file_inode(fp->filp);
+	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
+	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
+	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
 	u64 time;
+	int out_buf_len = sizeof(struct smb311_posix_qinfo) + 32;
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
@@ -4739,10 +4743,20 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
 	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
 	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
-	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
-	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
-	return 0;
+
+	/*
+	 * Sids(32) contain two sids(Domain sid(16), UNIX group sid(16)).
+	 * UNIX sid(16) = revision(1) + num_subauth(1) + authority(6) +
+	 *		  sub_auth(4 * 1(num_subauth)) + RID(4).
+	 */
+	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
+		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
+	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
+		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
+
+	rsp->OutputBufferLength = cpu_to_le32(out_buf_len);
+	inc_rfc1001_len(rsp_org, out_buf_len);
+	return out_buf_len;
 }
 
 static int smb2_get_info_file(struct ksmbd_work *work,
@@ -4862,8 +4876,8 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			rc = -EOPNOTSUPP;
 		} else {
-			rc = find_file_posix_info(rsp, fp, work->response_buf);
-			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
+			file_infoclass_size = find_file_posix_info(rsp, fp,
+					work->response_buf);
 		}
 		break;
 	default:
-- 
2.25.1

