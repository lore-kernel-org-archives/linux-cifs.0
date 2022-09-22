Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DDEC6FA82
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 14:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiIVOeg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiIVOeM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 10:34:12 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DEFFCA68
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:34:05 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id f193so9358951pgc.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=v9bv1SXj6cHk/r5ywAviJzJwr71LjJAa7iTYL7eOl8A=;
        b=ioZ9Q6HmSRjNj/Z5Bp4GN+XKDTd96UC+EXEST86/UNYs/t/I6aXSx5DHPlisyOUu+O
         XffhCfo/ziAM2xct4y89pmKwLeB8T6+d1btSkVmlAB6dun+151XcVfjjFRkVHMXPoJuH
         tUnAUvXh5qba6+MW2rRWow+IXjKsn/1FztsITATebpcY2OkKjZV1eyqW/WjBBToc6VmD
         0nnfU0crd90/DF0R8+ZoFw2vkfjamzbEfJTrAscvFtcNlkl/zl51NxMGOBbfZVqCEWph
         rjQlgR9dTwKmJutGpLlJJBHVENyvhf5vGA1nKUtz67NaDSKIZUxoHe1W1C9fweCkAVAA
         EOOQ==
X-Gm-Message-State: ACrzQf2M56UwfB4o4AP39Bv6UPRHMwjuYMGK3M4pYNVaz+bVjTwXDaLp
        aQGpnMd/zW228jZozdSb+HwgAF+U+QU=
X-Google-Smtp-Source: AMsMyM6mrDh8DUWjjcDOAPsZvzdM4agIqAM4fa8HpRx9fgtoQqcWtnt+D1G9iuJv1e1CpJXOovZ7yA==
X-Received: by 2002:a63:4a21:0:b0:434:7838:ae46 with SMTP id x33-20020a634a21000000b004347838ae46mr3355270pga.559.1663857244261;
        Thu, 22 Sep 2022 07:34:04 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id iw20-20020a170903045400b00177324a7862sm4132808plb.45.2022.09.22.07.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:34:03 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 2/3] ksmbd: set file permission mode to match Samba server posix extension behavior
Date:   Thu, 22 Sep 2022 23:33:37 +0900
Message-Id: <20220922143338.10368-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922143338.10368-1-linkinjeon@kernel.org>
References: <20220922143338.10368-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set file permission mode to match Samba server posix extension behavior.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - update patch description with the one Tom suggested.

 fs/ksmbd/oplock.c  | 2 +-
 fs/ksmbd/smb2pdu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 7c890daec2ba..d7d47b82451d 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1644,7 +1644,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
-	buf->mode = cpu_to_le32(inode->i_mode);
+	buf->mode = cpu_to_le32(inode->i_mode & 0777);
 	/*
 	 * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
 	 * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index bb19c9d1de78..0605e18bd998 100644
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
@@ -4737,7 +4737,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
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

