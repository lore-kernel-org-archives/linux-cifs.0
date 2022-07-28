Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1500C04A68
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Jul 2022 13:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiG1Ndb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiG1Nda (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Jul 2022 09:33:30 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D74D5C34F
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:28 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so5211057pjh.0
        for <linux-cifs@vger.kernel.org>; Thu, 28 Jul 2022 06:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9KEDV9PXE/NMjLMHOZlUy2f7/0QT8HzaDNT157sTmg=;
        b=TUIHjIxatZtJvUYzdpP3XSKs3n3sgVe97r740+kvC7fx5eqvLaH97iX4rMAJ8tX0Ge
         zxj31aIJbIE9mnGlsHXuOncQyg9uygbE3lVIMlJ8tYW5fnzwcDRSXqBjmX2OSD7B7fWz
         tihQUABEFFwWcc5UpJD/cs1sHvWj0YhNgcYTJ+risHgH4QAbx6m7YI3j1X2yD2uF3cWH
         r+MQjqYCICyiezgpyMt3sub4Banuy8SVjJ+YhSLB4jzxVRnaHY570nV5qjgzVTmYEQOO
         6MMrxayngNxFS5yOkeumVtmKO2xfwYtoWswnjNxErdiHHqBOxxMs+FZ4FEZ9HZeFv21Y
         PCuw==
X-Gm-Message-State: AJIora98wxvwTs0f3ct9FE5iY8dH1BsmrEopcQzuOJTBhAyCuD/QwiiU
        HKSeebV/D3tU/DcDaf8tchQdg7yj9LA=
X-Google-Smtp-Source: AGRyM1utwJXnNndMOy9T2f8mJJsZbXtb6ifrGYWn5jBytNurzXg2bryJ49+4QQYDkqzBZuuOYLNOnw==
X-Received: by 2002:a17:90a:2c44:b0:1f3:ad8:6359 with SMTP id p4-20020a17090a2c4400b001f30ad86359mr9004663pjm.181.1659015206920;
        Thu, 28 Jul 2022 06:33:26 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id m14-20020a63710e000000b0041b667a1b69sm960078pgc.36.2022.07.28.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:33:26 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        gregkh@linuxfoundation.org, Namjae Jeon <linkinjeon@kernel.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 3/5] ksmbd: prevent out of bound read for SMB2_WRITE
Date:   Thu, 28 Jul 2022 22:28:20 +0900
Message-Id: <20220728132822.6311-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220728132822.6311-1-linkinjeon@kernel.org>
References: <20220728132822.6311-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

OOB read memory can be written to a file,
if DataOffset is 0 and Length is too large
in SMB2_WRITE request of compound request.

To prevent this, when checking the length of
the data area of SMB2_WRITE in smb2_get_data_area_len(),
let the minimum of DataOffset be the size of
SMB2 header + the size of SMB2_WRITE header.

This bug can lead an oops looking something like:

[  798.008715] BUG: KASAN: slab-out-of-bounds in copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008724] Read of size 252 at addr ffff88800f863e90 by task kworker/0:2/2859
...
[  798.008754] Call Trace:
[  798.008756]  <TASK>
[  798.008759]  dump_stack_lvl+0x49/0x5f
[  798.008764]  print_report.cold+0x5e/0x5cf
[  798.008768]  ? __filemap_get_folio+0x285/0x6d0
[  798.008774]  ? copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008777]  kasan_report+0xaa/0x120
[  798.008781]  ? copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008784]  kasan_check_range+0x100/0x1e0
[  798.008788]  memcpy+0x24/0x60
[  798.008792]  copy_page_from_iter_atomic+0xd3d/0x14b0
[  798.008795]  ? pagecache_get_page+0x53/0x160
[  798.008799]  ? iov_iter_get_pages_alloc+0x1590/0x1590
[  798.008803]  ? ext4_write_begin+0xfc0/0xfc0
[  798.008807]  ? current_time+0x72/0x210
[  798.008811]  generic_perform_write+0x2c8/0x530
[  798.008816]  ? filemap_fdatawrite_wbc+0x180/0x180
[  798.008820]  ? down_write+0xb4/0x120
[  798.008824]  ? down_write_killable+0x130/0x130
[  798.008829]  ext4_buffered_write_iter+0x137/0x2c0
[  798.008833]  ext4_file_write_iter+0x40b/0x1490
[  798.008837]  ? __fsnotify_parent+0x275/0xb20
[  798.008842]  ? __fsnotify_update_child_dentry_flags+0x2c0/0x2c0
[  798.008846]  ? ext4_buffered_write_iter+0x2c0/0x2c0
[  798.008851]  __kernel_write+0x3a1/0xa70
[  798.008855]  ? __x64_sys_preadv2+0x160/0x160
[  798.008860]  ? security_file_permission+0x4a/0xa0
[  798.008865]  kernel_write+0xbb/0x360
[  798.008869]  ksmbd_vfs_write+0x27e/0xb90 [ksmbd]
[  798.008881]  ? ksmbd_vfs_read+0x830/0x830 [ksmbd]
[  798.008892]  ? _raw_read_unlock+0x2a/0x50
[  798.008896]  smb2_write+0xb45/0x14e0 [ksmbd]
[  798.008909]  ? __kasan_check_write+0x14/0x20
[  798.008912]  ? _raw_spin_lock_bh+0xd0/0xe0
[  798.008916]  ? smb2_read+0x15e0/0x15e0 [ksmbd]
[  798.008927]  ? memcpy+0x4e/0x60
[  798.008931]  ? _raw_spin_unlock+0x19/0x30
[  798.008934]  ? ksmbd_smb2_check_message+0x16af/0x2350 [ksmbd]
[  798.008946]  ? _raw_spin_lock_bh+0xe0/0xe0
[  798.008950]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[  798.008962]  process_one_work+0x778/0x11c0
[  798.008966]  ? _raw_spin_lock_irq+0x8e/0xe0
[  798.008970]  worker_thread+0x544/0x1180
[  798.008973]  ? __cpuidle_text_end+0x4/0x4
[  798.008977]  kthread+0x282/0x320
[  798.008982]  ? process_one_work+0x11c0/0x11c0
[  798.008985]  ? kthread_complete_and_exit+0x30/0x30
[  798.008989]  ret_from_fork+0x1f/0x30
[  798.008995]  </TASK>

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17817
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 7 +++++--
 fs/ksmbd/smb2pdu.c  | 7 ++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index f8f456377a51..aa1e663d9deb 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -136,8 +136,11 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 		*len = le16_to_cpu(((struct smb2_read_req *)hdr)->ReadChannelInfoLength);
 		break;
 	case SMB2_WRITE:
-		if (((struct smb2_write_req *)hdr)->DataOffset) {
-			*off = le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset);
+		if (((struct smb2_write_req *)hdr)->DataOffset ||
+		    ((struct smb2_write_req *)hdr)->Length) {
+			*off = max_t(unsigned int,
+				     le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset),
+				     offsetof(struct smb2_write_req, Buffer));
 			*len = le32_to_cpu(((struct smb2_write_req *)hdr)->Length);
 			break;
 		}
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7ecb6d87ae3e..1bad4f729160 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6514,14 +6514,11 @@ int smb2_write(struct ksmbd_work *work)
 		writethrough = true;
 
 	if (is_rdma_channel == false) {
-		if ((u64)le16_to_cpu(req->DataOffset) + length >
-		    get_rfc1002_len(work->request_buf)) {
-			pr_err("invalid write data offset %u, smb_len %u\n",
-			       le16_to_cpu(req->DataOffset),
-			       get_rfc1002_len(work->request_buf));
+		if (req->DataOffset < offsetof(struct smb2_write_req, Buffer)) {
 			err = -EINVAL;
 			goto out;
 		}
+
 		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 				    le16_to_cpu(req->DataOffset));
 
-- 
2.25.1

