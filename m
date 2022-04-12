Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4985BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Apr 2022 23:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiDLXqH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiDLXpw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Apr 2022 19:45:52 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E03DA45
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 16:33:18 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id a21so412582pfv.10
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 16:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X/GNjU5DEuXGs0pAA9Stv3SIW9+84njuFc4jTQBpGlE=;
        b=MUsqfs6lh4hoqMO5FBVH1J/K7yAf7KQrdLrEAaMh6jw9ImILWdTn2ltZ0ff54kUzmq
         v11zzcA/ZpdOJJiitMDSty/s/+pOdrfMGUsSPCAaJmSsN/v+wOudgVawRoeru6yXOrb2
         LFedupVQlDQtjDYdWUm1YNFaM8mFEe9iyPt0MhlDgqAiNUd80U7KJyuzTW6iAVNShAgl
         WudpbneA1XFZNbGSBor6QRDOYZEMXFZEB+Bu0Zl+wS93LtomAkPBBENjyLXYR5+Yc1/F
         UA88NIO0yLm/rVD+ieow68vWuxLDvVVlkvhrT1spmYRM8wA5X3Bm+Abep76frCqk6xlD
         cWQw==
X-Gm-Message-State: AOAM531HsHMlAzRQ5vlU4F4+ppKw9Qy+MeQwFxmLobIrUs1EqcLC7iwQ
        8FZZXA3TlCOFPezlCmiEh1G93Nw6SfPfUA==
X-Google-Smtp-Source: ABdhPJwDY4jlUW3vl66v4w4FFEMb3ig5nilNPxrFVDE26opFtfVACyZKHf8mdYkZoOLFSE/iasQZCA==
X-Received: by 2002:a63:df4a:0:b0:399:460d:2da with SMTP id h10-20020a63df4a000000b00399460d02damr31976743pgj.315.1649806397272;
        Tue, 12 Apr 2022 16:33:17 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f7728a4346sm41824165pfj.79.2022.04.12.16.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 16:33:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION
Date:   Wed, 13 Apr 2022 08:32:28 +0900
Message-Id: <20220412233228.13146-1-linkinjeon@kernel.org>
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

This patch reports fixed 4KB sector size if ->s_blocksize is bigger
than 4KB.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
  - set fixed 4KB sector size if ->s_blocksize is bigger than 4KB.

 fs/ksmbd/smb2pdu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 62cc0f95ab87..fe303c8ed87c 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4995,15 +4995,17 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	case FS_SECTOR_SIZE_INFORMATION:
 	{
 		struct smb3_fs_ss_info *info;
+		unsigned int sector_size =
+			min_t(unsigned int, path.mnt->mnt_sb->s_blocksize, 4096);
 
 		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
 
-		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
+		info->LogicalBytesPerSector = cpu_to_le32(sector_size);
 		info->PhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
-		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(sector_size);
+		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(sector_size);
 		info->FSEffPhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(sector_size);
 		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
 				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
 		info->ByteOffsetForSectorAlignment = 0;
-- 
2.25.1

