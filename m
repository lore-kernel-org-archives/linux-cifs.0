Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304118;
	b=dps1BhMG+UO8o+7SX+r0P9+C0qLPV+9rR0l5Iqri7f7WITOikNdICj3MpDEsei9iUFoU
	 W1lNbwVAypb3u2RkgqSGpiMGK1blsC92ro7YVzTMXH1E1kkuBYCGcNLE9sFLrM+hXBiLT
	 HMdFbstPhtpviQ0AcK8MfrsP1OEjaNunZDDlaJp/rz10RNYQlC2lvnqmj13vc2o3pSUJ2
	 beRV9UNlSaf4f/Kbp7czk47QRUPXloJIYgPapOWlEetizgX8Wxv2boo2/QUYtj6/wwm1Z
	 jitbJ6Fvukik9U7ZWDPmldgE40oXzqkKeRkXWmAaWAoPAC/2FdvfnZcVP4LGq2swcGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304118;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nhGgMcWX4lZK4FqtGtmrDK1PCNYKB2z6sCqshnlr2/Q=;
	b=3SUNMlZvkL98XM3ozP3mERfW8uml+bpj5Y3LmuWxcJ7kHxMTVvALSz7F4yJ9GbVWLu2U
	 IfZl5CctPOVnVAIRQeNgZgj3Lj2LzsavxXu/pCCqgIbeM3YQc3PfhCd/Ke1G5Ysv8ZqKZ
	 a4+qkc+1XIxbYU1ErZTqfSrcE08HW7KWVx614/LeYccP2LRoPcmJpEkh1YQ3wiuPZCNn2
	 qsmCmnM/sJWUpivMx0saRilu5fkWUR6BTa52qpBwbWkACcCXpnFEUjv/sEuT2zf71JaNg
	 81r02RR4Ks1q3oIXXxov+hglwHej73s0UOFH4IJN6502+VoWgNneUdl6hg1K8UM510Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tttwaq4g;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A4C606A9B9;
	Tue, 10 Nov 2026 09:48:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8A4C606A9B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Tttwaq4g
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794304114; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=nhGgMcWX4lZK4FqtGtmrDK1PCNYKB2z6sCqshnlr2/Q=;
	b=Tttwaq4ghVephCvhy0CkNfmshb+bku+KKIy3RaZp+/96AAQ7tTkGXXEJFgMJlBU0iwFjR9Ss8zQygkHHMTpLS7BZe3x5BiycgNqwgrDkT0XJuFDSBCmgen7hDUMCSmUJJ4Wsa2aZR0Gkp5C2e1BXN1h0GXCnidKk0RvR9SrMe4U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XEV.QXR_1794304113;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEV.QXR_1794304113 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 17:48:33 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: hold the inode across cifs_oplock_break()
Date: Tue, 10 Nov 2026 17:48:29 +0800
Message-Id: <20261110094829.2133495-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_oplock_break() drops the handle reference in the middle of the
handler and keeps using cinode afterwards, to send the break
acknowledgment and again in cifs_done_oplock_break().  The reference
cifs_queue_oplock_break() takes is the only pin: the handle holds the
dentry and the dentry is what keeps the inode alive.

When that put is the last reference, the dput() in
cifsFileInfo_put_final() kills an unhashed dentry, drops the last
i_count and evicts the inode, so the rest of the handler runs on an
object whose free is only RCU-deferred.  An unhashed dentry that a
handle still references is an ordinary state: unlinking an open file
leaves the dentry that way, and so does the dcache teardown at unmount.

Take a reference on the inode for the lifetime of the handler and drop
it once the break has been reported.  This also covers the
cifs_get_tlink() failure path, where the put is followed directly by
the out label.

Fixes: b98749cac4a6 ("CIFS: keep FileInfo handle live during oplock break")
Fixes: 23b26f4408ac ("smb: client: avoid leaking refcount when cifs_sb_tlink() fails")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/client/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0767eb5f4687a..2fb52633f57b1 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3357,6 +3357,14 @@ void cifs_oplock_break(struct work_struct *work)
 	__u64 persistent_fid, volatile_fid;
 	__u16 net_fid;
 
+	/*
+	 * Dropping the handle reference below also drops the dentry
+	 * reference that pins this inode, and cinode is still needed to
+	 * acknowledge the break and to report it as complete.  Hold the inode
+	 * until that is done.
+	 */
+	ihold(inode);
+
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
@@ -3444,6 +3452,7 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_put_tlink(tlink);
 out:
 	cifs_done_oplock_break(cinode);
+	iput(inode);
 }
 
 #ifdef CONFIG_SWAP
-- 
2.39.3

