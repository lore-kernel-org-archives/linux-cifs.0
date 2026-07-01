Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D53B6C1C
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903436; cv=none; b=bkGl7FgF46LwBv8++iQXwXl/RvKpwFCD1SQclWJsOGwoOPPg9lgxy2ASppWC/uA03c/BiJVEK0PjtLeu7YmeG3pJy3qMnGkQRr18lscqB8m5xenZkLMRgoact3lK2jhtWEZYzqw5ApV36/zBV53w2DCm0UcZBvC68dYqorjiSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903436; c=relaxed/simple;
	bh=7OxAlAJSBrZ1ebtYLPaQKfeLIpZ1t3s9v/GGQmeujbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0Jxg7EfbDjJCcN1zzyb2fgwY1AnWk2Sf2wQdl3RKx27Wm/4vvdS8yM4B56k+WSX9YShQhdxbYUQwenTdDNRHxlMc5zYjeMxkBKv6ObxoMd9qW0w29tGGGs97lYRpzmi47GrTuPcnRefTgud6Z+TaVp5bNcYlU8d7i2lBUfrPPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=lkSsyuD8; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="lkSsyuD8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782903429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnQAt41C4G/UYQn/FGj2iJ/GhYYjDQYfEeRAZ76OSeQ=;
	b=lkSsyuD8YVSCr2cE3Qv08umfTBUPFyzLQWlb2A7XsMALzTOy86oTAB+6x1bIa63sfp8UfK
	Jg0Fdk0TswMn1lM9+AIAIHbgBr41oTkL7rMSw8KSg7sc/4YcHqq+hWWmBBpNZPybpLHFE3
	7DLAkNmWuqRwbpgSXzeMyNyA3MzJxL0nbnM7lfnQQ5BHGH4/3D9GbQykFACRAqUMlab97m
	G/hBUI7kQp4MFWBQTBxIa/3G/iRvbTYiC3of5yv1WRr6HsB/ZjTERTeg4Ugqir9H7rq+xM
	PMhX29XYRcf/iwkxaESj5MZLCb4U23PQLTRtNNXlRzPKwFCeHAayGcb86n5FBA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 1/1] smb/client: fix incorrect nlink returned by fstat()
Date: Wed,  1 Jul 2026 10:56:35 +0000
Message-ID: <20260701105635.794615-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701105635.794615-1-chenxiaosong@chenxiaosong.com>
References: <20260701105635.794615-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. mount -t cifs //${server_ip}/export /mnt
  2. touch /mnt/file1; ln /mnt/file1 /mnt/file2; ln /mnt/file1 /mnt/file3
  3. C program: int fd = open("/mnt/file1", O_RDONLY);
  4. C program: struct stat stbuf; fstat(fd, &stbuf);
                stbuf.st_nlink is always 1, should be 3

`cifs_atomic_open()` already obtains the correct nlink.
Setting `NumberOfLinks` to 0 in `SMB2_open()` triggers the
`CIFS_FATTR_UNKNOWN_NLINK` flag in `cifs_open_info_to_fattr()`,
which safely preserves the existing i_nlink in
`cifs_nlink_fattr_to_inode()`.

Refer to the detailed procedure below:

  path_openat
    open_last_lookups
      lookup_open
        atomic_open
          cifs_atomic_open // dir->i_op->atomic_open
            cifs_lookup
              cifs_get_inode_info
                cifs_get_fattr
                  smb2_query_path_info // server->ops->query_path_info
                    smb2_compound_op
                      SMB2_open_init
                      case SMB2_OP_QUERY_INFO
                      SMB2_query_info_init(FILE_ALL_INFORMATION,)
                  cifs_open_info_to_fattr
                    fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks)
                update_inode_info
                  cifs_iget
                    cifs_fattr_to_inode
                      cifs_nlink_fattr_to_inode
                        set_nlink(inode, fattr->cf_nlink)
    do_open
      vfs_open
        do_dentry_open
          cifs_open
            cifs_nt_open
              smb2_open_file // server->ops->open
                SMB2_open
                  buf->NumberOfLinks = 0
              cifs_get_inode_info
                cifs_get_fattr
                  cifs_open_info_to_fattr
                    if (fattr->cf_nlink < 1) // true
                    fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK
                update_inode_info
                  cifs_fattr_to_inode
                    cifs_nlink_fattr_to_inode
                      if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) // true
                      return // do not modify nlink

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 56caf8cbdb0b..0801674f49c6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3378,7 +3378,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		buf->AllocationSize = rsp->AllocationSize;
 		buf->EndOfFile = rsp->EndofFile;
 		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
+		buf->NumberOfLinks = cpu_to_le32(0); /* invalid nlink */
 		buf->DeletePending = 0; /* successful open = not delete pending */
 	}
 
-- 
2.54.0

