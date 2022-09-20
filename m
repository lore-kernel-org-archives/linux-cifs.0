Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC265ECAAD8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 13:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiITNVG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 09:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiITNVE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 09:21:04 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8502E4B4B4
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 06:21:03 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so10780429pjm.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 06:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=t28g4ekicImW7p17MGbK+iOfJKtaRZ9e/vNICYRq/UY=;
        b=59j0YyegmhoKDyKX2ddotIedafFSjNLqN0sHUDOnrlMq63lrSOahCufTJ79zaXyKnM
         /6ARW/0OwEE+04z7/dMykk1OlUyEoszaYp6RZlmgXlcQoQFa6np2tjPDLCRhxN8c2OP7
         0ttvyXwIqpE/JPVErl6pveZrYFHY+ErHRqeOpQPyL1CbFEdGhCihMS86m3TpnU+M+cBp
         cD04Q0MvLgcZIl+5xJftQHQMb1FG5FaX51ChMqFL7n5c/H9dsQ89J3E3RR48LzPCNjy/
         KNfaltSDWgEleE+a+bg7YpPKJQ/CqXLF6JqVvV65/ejAVAr0n1iBfpNUK7f8+y2s8TGV
         fJCg==
X-Gm-Message-State: ACrzQf0fmtx6UJ/4vsuSifHVZkrMOnjrWRAZQlNS8jN/mxsvChX69p+g
        E62ZAiuNiM4soZsPrxQPkmasWZ7eFD4=
X-Google-Smtp-Source: AMsMyM4e8BHXh38dCsj6a5mkamK0dwioota/S9M+DJq6Ngv6lSO+ttwgi9wFv2KZ5IxzVXJgHS+47Q==
X-Received: by 2002:a17:902:c104:b0:176:e2fa:2154 with SMTP id 4-20020a170902c10400b00176e2fa2154mr4882624pli.98.1663680062700;
        Tue, 20 Sep 2022 06:21:02 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id ix18-20020a170902f81200b001767f6f04efsm1360851plb.242.2022.09.20.06.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:21:02 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: set only file permisson to mode for posix extension
Date:   Tue, 20 Sep 2022 22:20:44 +0900
Message-Id: <20220920132045.5055-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220920132045.5055-1-linkinjeon@kernel.org>
References: <20220920132045.5055-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set only file permisson to mode for posix extension like samba.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/oplock.c  | 2 +-
 fs/ksmbd/smb2pdu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index c26f02086783..9bfd1ef6debd 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1640,7 +1640,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
-	buf->mode = cpu_to_le32(inode->i_mode);
+	buf->mode = cpu_to_le32(inode->i_mode & 0777);
 	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
 		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
 	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index bc6c7ce17ea8..5c797cc09494 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3565,7 +3565,7 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		posix_info->AllocationSize = cpu_to_le64(ksmbd_kstat->kstat->blocks << 9);
 		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
 		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
-		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode);
+		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
 		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		posix_info->DosAttributes =
 			S_ISDIR(ksmbd_kstat->kstat->mode) ?
@@ -4732,7 +4732,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->EndOfFile = cpu_to_le64(inode->i_size);
 	file_info->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
 	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
-	file_info->Mode = cpu_to_le32(inode->i_mode);
+	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
 	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
-- 
2.25.1

