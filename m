Received: from mta1.migadu.com (out-67.mta1.migadu.com [95.215.58.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D171D3BE163
	for <linux-cifs@vger.kernel.org>; Sun, 16 Aug 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786894800; cv=none; b=G/ByO6xQJUaC5ZsuRZQ2Boo844Jbm5IpvRG2+0Nb/FfLroSqA4wUsjpBFETjiEBuJ9yhAs24N6xmRREJi7AIcdfgPpwY1VOgIxC4yUMY+6s21AZATbJIVkIkeB6WGXCzaNFe8Ex5n4ebNLAxekW/LvROm4FXag8Amcy9McASamY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786894800; c=relaxed/simple;
	bh=fLWxS8pXfu4ahRXI3MpQZE+JUzQzA2SjwT+ytyNx6Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TvD+Qu3fg7t6kCSjofhEPvkP08HlUhO8F247nRHz/QeB2daooFvGoQiKpj+F4KBqng408FLkyBeojTPAq1CyXVx8TBxFK6LQPsC9w+GvFhR0WbxQdvwhhBqn/h+8tHd5gQqaNu9jqi1XK7VxxBXbgzOIGQZAHtKIJfXCyZfu0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N/YPqXoJ; arc=none smtp.client-ip=95.215.58.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N/YPqXoJ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fLWxS8pXfu4ahRXI3MpQZE+JUzQzA2SjwT+ytyNx6Eg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786894795; v=1; x=1787499595;
 b=N/YPqXoJrvepdRmcJJDz7exJ3xBfniG0O+DHaKO0ckFxJcRuaobFqUQnfU16ZkB9a7lBpmrV
 a0BLBYdiQKo7wRki5sOgdJBnbdSy1VhS6NTVkqjEoNFrXHbtvCV3ru1KR/4RzHOZrl8nF7cH7yD
 XDi5G2NmNa1VPuoaKJT/itvQ=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:9d9:e513:b3b2:52ae:9d43)
	by smtp.migadu.com with ESMTPS id 942b990b2b247f32;
	Sun, 16 Aug 2026 15:39:45 +0000
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	lkp@intel.com
Subject: [PATCH] smb/client: remove redundant NULL check before kfree()
Date: Sun, 16 Aug 2026 23:39:22 +0800
Message-ID: <20260816153922.484091-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

kfree() accepts NULL pointers, so checking tmp_cfile before freeing it
is unnecessary and triggers a Coccinelle warning.

Remove the redundant check. This does not change runtime behavior.

Fixes: 5693347de107 ("smb/client: use writable handle for FS_IOC_SETFLAGS compression")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608160402.0ffQDoCg-lkp@intel.com/
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 fs/smb/client/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 9fa743be3652..2f152d76be7d 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -133,8 +133,7 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 
 close:
 	server->ops->close(xid, tcon, &fid);
-	if (tmp_cfile)
-		kfree(tmp_cfile);
+	kfree(tmp_cfile);
 	cifs_free_open_info(&data);
 out:
 	free_dentry_path(page);
-- 
2.43.0

