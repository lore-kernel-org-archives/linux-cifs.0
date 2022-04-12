Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FDBC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Apr 2022 23:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiDLXV6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiDLXVj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Apr 2022 19:21:39 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E43629CB7
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 15:58:25 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id bg24so163608pjb.1
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 15:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=THod0Czgnjk9ipDQhXswUowKCRhMUwvBlfyirjGjZ/Y=;
        b=qEyG6R//Ixw99v1dfI3gr9KQnjNxSRL5EE1kwssSnIfVszbvz8tflaDuIBd0jTDuuD
         eUyjj5afpS69LbdwSFj1ZoYqt/+WQxz0ntpk5lt7WYKj6yZUHYKWQfc8IvuyOGV/pW1K
         fVG4x6Bo00F2wHFhF2yWV7t2/yuFcR/d/qNY/AaLYeBQw2FzM8OKz+UhEDPKqraMWhbs
         B6NvfhuiuD865F7uqb3G7yg45Uzhew6Ve3/H96/Lua9HOe9YZqLKA9YXEvE+ALKjPH+6
         gaT5f9ca3bdMSCNlsVtH7Mich0ZJ2b7XOinEVNOtl008X69r6D6XTyzVagzbYhMc8Bid
         QhnA==
X-Gm-Message-State: AOAM533HQhrTK1ELleuLfPqbJQnucHrZ+01H1hnJGKB/B3/U5/v9KbJC
        //637nNYRkL7yR1FqLcNADJ+m8UV6aQdoA==
X-Google-Smtp-Source: ABdhPJy9x7Gu5peG7zi/ObDOF4lRG3AKZoAMuI50dy7AS4wQzNgS+CUPcbv5ZsB/fo/gBus6DTUwjw==
X-Received: by 2002:a17:902:d2d0:b0:158:761e:c165 with SMTP id n16-20020a170902d2d000b00158761ec165mr9231687plc.59.1649804304279;
        Tue, 12 Apr 2022 15:58:24 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id i5-20020aa787c5000000b00505b322a952sm9731920pfo.114.2022.04.12.15.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:58:23 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION
Date:   Wed, 13 Apr 2022 07:58:06 +0900
Message-Id: <20220412225806.5647-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently ksmbd is using ->f_bsize from vfs_statfs() as sector size.
If fat/exfat is a local share, ->f_bsize is a cluster size that is too
large to be used as a sector size. Sector sizes larger than 4K cause
problem occurs when mounting an iso file through windows client.

The error message can be obtained using Mount-DiskImage command,
 the error is:
"Mount-DiskImage : The sector size of the physical disk on which the
virtual disk resides is not supported."

This patch reports fixed sector size as 512B logical/4K physical to
windows client to avoid poking into the block device.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 62cc0f95ab87..28ff7c058bc4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4998,12 +4998,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
 
-		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
-		info->PhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
-		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
+		info->LogicalBytesPerSector = cpu_to_le32(512);
+		info->PhysicalBytesPerSectorForAtomicity = cpu_to_le32(4096);
+		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(4096);
 		info->FSEffPhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(4096);
 		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
 				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
 		info->ByteOffsetForSectorAlignment = 0;
-- 
2.25.1

