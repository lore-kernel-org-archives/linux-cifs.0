Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3394A5C4D
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144611; cv=none; b=U1Zqd/JX3cOweYCDcwj+JV5rJyuJMSq4GNEgPlgZ/8qQF3Xr9p2Zn3cS/rSmeYMv4orxe01EJe8XgVWw8il1WxuZlxon4E/5AdJJj8rOMLWDaxXogJIp5x8jiv5OshMFTYnoFl6ozybJLajmsByPQaPWBtATp4Ym8rFRAiw84CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144611; c=relaxed/simple;
	bh=zO/11ln1jZe2oK+wBrSiuyLnNt0P/tnmBvfzK8mWA08=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k5gQWyM2ujv2wkU4Q+Mbc+Z8Fpdb9ZNBqOZhqGZeKTeLCUCFFCBhFQVOIFMdzrMzZGcfQDTox2zt1mV/WwAgHfe7WRms4nuhuXmWJwWgQlqjAgQpgexTRQcfIX95BA0iYXUfZW0BmX5lVJRSADMyQ08wkc8SnKXFjaTWNhFygoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lmqWI883; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lmqWI883"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Nm
	jbnAbXxD0hB4LLq5eZN9615aofy9ZuxvjswfuY50k=; b=lmqWI8832Xpqc6PacH
	xHtK3gjEfzy81sKNKXFcaqzCea1TY58NdAvrTJbB16Tqk+7t4XatEr9a/ecKQ9ts
	t+FKGCr4yEPNEtm3kXZwRjeezfAUE7SEMxfCyuAEXrcdA8TnPVThvKjQj29GQAj8
	pSZ4cYMwirztTYjCPcgS7RXeg=
Received: from hh.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDnmY37LaRqM4PiOg--.53919S5;
	Sat, 12 Sep 2026 00:36:14 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH v2 3/4] ksmbd: fix invalid Next offset in interface info replies
Date: Sat, 12 Sep 2026 00:35:15 +0800
Message-Id: <20260911163516.6403-4-15815827059@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911163516.6403-1-15815827059@163.com>
References: <20260911163516.6403-1-15815827059@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDnmY37LaRqM4PiOg--.53919S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4UCr45tryxCFyDJF43Wrg_yoW8Ar4rpF
	y5JFWDCrZ8Xr13tr97G3WUZa4Yqw48Wa9rCrZ3Jr1Svrs5X3WxCFs7tr9Fk3ykAFsYkFWj
	qws0vwsYva4DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jL0edUUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbCzR5O02qkLf6MVQAA3K

From: Henry Hu <huhai@kylinos.cn>

fsctl_query_iface_info_ioctl() assigns nii_rsp to the next output
slot before checking whether the interface has an in_device or
inet6_dev. If either lookup returns NULL, the loop continues without
advancing nbytes, leaving nii_rsp pointing at an uncommitted slot. If
no later entry is committed, clearing nii_rsp->Next updates that slot
instead of the last returned entry, leaving the latter with a nonzero
Next offset.

Fix this by using nbytes to locate the last committed entry and clear
its Next field, but only when the response contains at least one entry.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bbd184605237..ff3a0da7d749 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10560,9 +10560,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	}
 	rtnl_unlock();
 
-	/* zero if this is last one */
-	if (nii_rsp)
+	/*
+	 * nii_rsp may point to an entry not included in nbytes if the IPv4
+	 * or IPv6 device lookup failed. Clear Next in the last returned entry.
+	 */
+	if (nbytes > 0) {
+		nii_rsp = (struct network_interface_info_ioctl_rsp *)
+			  &rsp->Buffer[nbytes - sizeof(*nii_rsp)];
 		nii_rsp->Next = 0;
+	}
 
 	rsp->PersistentFileId = SMB2_NO_FID;
 	rsp->VolatileFileId = SMB2_NO_FID;
-- 
2.25.1

