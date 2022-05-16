Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC11C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 16 May 2022 07:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiEPHmO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 May 2022 03:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbiEPHmN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 May 2022 03:42:13 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DC6559C
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:08 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id k16so6547944pff.5
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 00:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eIIhuGEvPrbMxBken0zNHcT5pPnMbCmYFcnMGYfAliY=;
        b=YKvBGo29/IRogVE+2OJTScoFvvJ66aQ93WOSBTXlTQ6Ane3XecWSAhsCrxQ7rrFccp
         Vp6Tyt8db8g5foGbiLm0MpCPUQ05+hGjPnH0rq6ha6xkuj4+KK+jk4kWneEoxsSe7zFs
         ED9wVwmK11+Lgl0DADPmGluX7BNTkDtt2BvLE2YMv4GRINOoFhPwst+94H3SLPZkxksg
         QIOwewM44Z8OELG4cITwi7HPd6zTrgzEWDztjX33Yvy2aVQO2vdN8BY6F0QfDWCSqy0t
         Z/BOIGKYb9A12iad57jgCIGyEsxPnYDg0t99LYotUnikJ1NR8eZiHZ8ua82PSBgwS9sg
         l6Zw==
X-Gm-Message-State: AOAM53082dkeXvMiIx2WChLEHDXhw7VXpiHOq7MD0fT8yl4fl4OBZZD/
        90rHUImb3aRRZZz8np7XrCIkQt7U/z8ZEw==
X-Google-Smtp-Source: ABdhPJyc0g5SaU+rrc7xIZkug5XlACBRQORlsoe7qubNTCbYorryopPZg+Bh2T37XqbAD6IBgqO1fw==
X-Received: by 2002:a05:6a00:198f:b0:50e:7e6:6d5c with SMTP id d15-20020a056a00198f00b0050e07e66d5cmr16069626pfl.20.1652686927734;
        Mon, 16 May 2022 00:42:07 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id r19-20020a170903021300b0015e8d4eb26esm6321342plh.184.2022.05.16.00.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 00:42:07 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: handle smb2 query dir request for OutputBufferLength that is too small
Date:   Mon, 16 May 2022 16:41:38 +0900
Message-Id: <20220516074140.28522-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We found the issue that ksmbd return STATUS_NO_MORE_FILES response
even though there are still dentries that needs to be read while
file read/write test using framtest utils.
windows client send smb2 query dir request included
OutputBufferLength(128) that is too small to contain even one entry.
This patch make ksmbd immediately returns OutputBufferLength of response
as zero to client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 10b7052e382f..eb7ca5f24a3b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3938,6 +3938,12 @@ int smb2_query_dir(struct ksmbd_work *work)
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
 
 	rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
+	/*
+	 * req->OutputBufferLength is too small to contain even one entry.
+	 * In this case, it immediately returns OutputBufferLength 0 to client.
+	 */
+	if (!d_info.out_buf_len && !d_info.num_entry)
+		goto no_buf_len;
 	if (rc == 0)
 		restart_ctx(&dir_fp->readdir_data.ctx);
 	if (rc == -ENOSPC)
@@ -3964,10 +3970,12 @@ int smb2_query_dir(struct ksmbd_work *work)
 		rsp->Buffer[0] = 0;
 		inc_rfc1001_len(work->response_buf, 9);
 	} else {
+no_buf_len:
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
-		d_info.data_count -= d_info.last_entry_off_align;
+		if (d_info.data_count >= d_info.last_entry_off_align)
+			d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
-- 
2.25.1

