Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F418413D9C
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902380; cv=none; b=D01cQc77PUiJT3qAAeQfQ6KQnrC0wkkbXc5Qlk5HOBnmJxTjHf8cBOtVg/4OP57eqgplSoFUQ/PNSp7mbmxgteCl5WcvBxh0zYu0f7K6AeVZjJ1ma2jmLw4wgKnboRVVv/DxXDLmH828Hi/hitDEt0fNiXh8M0QPXpu2PsYyb9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902380; c=relaxed/simple;
	bh=WWZWGcc7zhK06W1EMi+2ZSySoZtzMFyr+4A6nNy63WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBUDUw0evIr9xw7erEvF7WB6wuRiCSmi1i6R0Ke0XNnhLD6vFC0pLFbeXfedAflKAv7pP2a8kNnw7R6JEg8IWf5zt5+7zgmYSA+yANqlOvprmGw4yO3IZdWPlXQ/ehuvBOPR9veV4elFojonb/8T8AyFSrh+6p+CoECqmycGO7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=SmkqZ48x; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="SmkqZ48x"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782902374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XS1BUVxu0q/9mMfmFFQmEN0nCwTBsqXZ9EbmlyayHV0=;
	b=SmkqZ48xesMli6l1R/VhAfgnqcFT2qELlc9UxDgQYLt9A0v7rvm1w7uEQi3i5l+NCzc3eW
	RyOkxkxwVJqoYMFFK6Nx7qku/o574HxAhU6hIgoloAfPA2NKfpF+mvHRBmQFkugAZQVPN9
	udORpxzzTnz/jM0b+EROs5kW15Fw9ZPAwrBWc8fKQSLlWISeCTjWiK05Cv/pieCgyLjqFc
	KpZZXS869JAWWtAgPhZRr2F/qgeCrhnHWjgP6Eegw4eDrW+KvcgQC73BQWd0GDtbH/oGG8
	Ez7o4iUhi+ZT1U1t7Wu6cgoX1GScLrUIrvBTcgeF+4gMe7kcUbeVjuYaeNd95w==
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
Subject: [PATCH v2 1/1] smb/client: fix incorrect nlink returned by fstat()
Date: Wed,  1 Jul 2026 10:39:07 +0000
Message-ID: <20260701103907.794299-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701103907.794299-1-chenxiaosong@chenxiaosong.com>
References: <20260701103907.794299-1-chenxiaosong@chenxiaosong.com>
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
`CIFS_FATTR_UNKNOWN_NLINK` flag in `cifs_nlink_fattr_to_inode()`,
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

