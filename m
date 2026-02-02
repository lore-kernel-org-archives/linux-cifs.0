Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E0352C47
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 08:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770020725; cv=none; b=osSltDAQ80YU52i9hFgE2cDms4w7kjue6cXqwnnBBVlYDdttpSRsRgPQFoQuEIO3V7fMZMraxejzfX34sXUcEcp8dMAMqMqpq16r27rBDYo7rhNjYRSp8+pToVdhEkn9FgAoCcFPriP7iX0M0jhnFZt6Sx3qvanz9Q6VSuHWTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770020725; c=relaxed/simple;
	bh=ku5zIy5FfRzpuYmrQz0OxGITa0GYukAk7nHxps6VNbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgXMxQMhyw53tO3LDnY2NHVTMGRNrz4siTOlLC+N/OsBBiCS8UVaW3FrjJX4tnv073BxM+LNEZuxCexOHpQMP32HSg1hxXYRbwKsqSBpije6IaQpSyB8c5b0SuvMb4Loczg4UMPZbhqm5V0WZmxz9+GCzg9YDSx4E6QnZ6mJa1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X+/Gbn9K; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X+/Gbn9K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770020716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x4daUtwqbYpw4TPkvtB1Hm57I5pX9J6vezjdzMfLc9E=;
	b=X+/Gbn9K+jqj449C594ofF0G+uExuCvJ/ygt6NcAWFdm+ZCgV5rkM/sRb+oV9VGiKmJKuA
	T3inaxgihhJujlH8G2OZ4AWZFBZdfJJHy/vzgvKGgVmzohibPtKDhoBbeQGg7il3IVTwL7
	Sy1OePSoa4lBKB7C3tlYGxkrm8c3wF0=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	nspmangalore@gmail.com,
	henrique.carvalho@suse.com,
	meetakshisetiyaoss@gmail.com,
	ematsumiya@suse.de,
	pali@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/2] smb/client: fix memory leak in smb2_open_file()
Date: Mon,  2 Feb 2026 08:24:07 +0000
Message-ID: <20260202082407.1881618-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260202082407.1881618-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260202082407.1881618-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: directories are exported read-only
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: dd if=/dev/zero of=/mnt/file bs=512 count=1000 oflag=direct
  4. client: umount /mnt
  5. client: sleep 1
  6. client: modprobe -r cifs

The error message is as follows:

  =============================================================================
  BUG cifs_small_rq (Not tainted): Objects remaining on __kmem_cache_shutdown()
  -----------------------------------------------------------------------------

  Object 0x00000000d47521be @offset=14336
  ...
  WARNING: mm/slub.c:1251 at __kmem_cache_shutdown+0x34e/0x440, CPU#0: modprobe/1577
  ...
  Call Trace:
   <TASK>
   kmem_cache_destroy+0x94/0x190
   cifs_destroy_request_bufs+0x3e/0x50 [cifs]
   cleanup_module+0x4e/0x540 [cifs]
   __se_sys_delete_module+0x278/0x400
   __x64_sys_delete_module+0x5f/0x70
   x64_sys_call+0x2299/0x2ff0
   do_syscall_64+0x89/0x350
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  ...
  kmem_cache_destroy cifs_small_rq: Slab cache still has objects when called from cifs_destroy_request_bufs+0x3e/0x50 [cifs]
  WARNING: mm/slab_common.c:532 at kmem_cache_destroy+0x16b/0x190, CPU#0: modprobe/1577

Link: https://lore.kernel.org/linux-cifs/9751f02d-d1df-4265-a7d6-b19761b21834@linux.dev/T/#mf14808c144448b715f711ce5f0477a071f08eaf6
Fixes: e255612b5ed9 ("cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES")
Reported-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 0f0514be29cd..9ab0df01b774 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -178,6 +178,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
+		free_rsp_buf(err_buftype, err_iov.iov_base);
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 			       &err_buftype);
-- 
2.52.0

