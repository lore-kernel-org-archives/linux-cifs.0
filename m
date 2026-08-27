Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3666137B02A
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 01:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787795865; cv=none; b=VEQa4J3oaf1SmwGwMeq07Wx7bsTLyu5OLsw+ozq+XdjUtfMHMSt6INlel3G7y08SQ0KQE97sC4ovsJnC44YLS8sSQwi+QcIC7YVs64RAFl9Kfvd7VS7KBiMBok5PNXlzxG/VNOW0ZkkMVChv8HKHPhkBfj57MR2InmRYZqcnBeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787795865; c=relaxed/simple;
	bh=jhENR7oMROtVLiOxg0U+CVD+L+2JPr5RtX6xHqYhPz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq/WCGwInlbeHVx6nttrLAvAMPee6MMTuGsJ8sUdxPUv4YCfKPoQct325eCsruVwFcYOXR69U5WhEIMeQrHvPguharvr7ZXwLfhMxTKyDQcDtr+71r2+VRUm6W5qPYKwvE0m6pNHjusm+VBkDVeX9ssv3adZgOhpM+bPkiY4Ozg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YDJHp0DS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXTch8+z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDJHp0DS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXTch8+z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787795863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djdjWCEotBxmszXLMf1uKi2y2pajf3EcVhrRc+8hkLY=;
	b=YDJHp0DSa58DmWoXOlSwduRaTxV2NT9EMsl+bGU5RrAZsZfWjZQ9jLkbofL1sfmXlgnos+
	Sb/HpFnIkp7m4Qmy0YWjMtBsgMfkMXaXrHCPL3TjYxx32xCUo5FGHpfrQio9EXVJ2N14kb
	s0JcIS4VX7VOd4J0bTwqfuZzLMy6FW4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-RnJruR4HMWaoR-zmeE51uQ-1; Wed, 26 Aug 2026 21:57:41 -0400
X-MC-Unique: RnJruR4HMWaoR-zmeE51uQ-1
X-Mimecast-MFC-AGG-ID: RnJruR4HMWaoR-zmeE51uQ_1787795861
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-930a098ea19so160194785a.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 18:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787795861; x=1788400661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=djdjWCEotBxmszXLMf1uKi2y2pajf3EcVhrRc+8hkLY=;
        b=CXTch8+zZIvvr6BeJIjvnY70kovmGMThfo4IxZdvn6OLYAAeI0lKKDt446itszZTak
         /mPn1E7D2kX9mL9vXXH2jXRBuO2EFQcRyDOtrTwiWJKwej5ejSoPk23lP4hYP10oFMBV
         iska0Lk6sGupX8qs0le/kf928LTq3uImM4DtZPIi08QKBoPRKpdLP2+bl5c7Bh7TF4WK
         AU1G8aO3FxC8cXXtKRHh/CSjrUT9qIrUe/zz7lYoIkj4aOT3ySsvpQWDj8VGJExCb67l
         MJBVOEMEmPfKY4TnSUBXjBi+1qyAL/X61HUbX7yrpMHd+7GHIk8zYJgb3xGrDX5O1Ehq
         PRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787795861; x=1788400661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=djdjWCEotBxmszXLMf1uKi2y2pajf3EcVhrRc+8hkLY=;
        b=geHJABcg37Qs9ce7LsAw1ui+F7bCs+Rik1xCbrOPGQJhYTCFY35wlw1lb5iWbJnwHD
         o6SvYN++WiZbNtL14XuB7t16+8Icxt4/jXx6vMKWnA1V5qHFvBIrodsyqYEDytsFimUd
         eKee09i722FhjHdfudhjP8+5rFkqd4YbC8kK7XbMgRxTqsVyii9FtDPCD4iNMQ+ntRgZ
         6BC6wnQarT3ObjZM6AZJXueYYD48ZjQOyo0vnhCqNiKp9mWkCau1zb9GvJL0fQKE5nFc
         KgPIlIf/wHfifv0ucI+pDKmI5kxOOSmiQvKfDH2WkwJ4kRfNC0/v5FifKODY0haJBBIl
         O5oQ==
X-Gm-Message-State: AFuF++lPhQCig33eaow+MXjx0mtIwX2pdaXDxxdNBXdnWxfJPYvw+zWr
	ZoU3ScE5sRt/ZxVXDNhWzje/6040kP1lXu+NY4NID6nK3AKgtReeGynAa0mfTB4N+sbEN8IvXaY
	daWjVwixGZCyRwn872/cal9MnuCs+CUq/sE9PcWR+1bbtIMc64SOTdfw0v+ZdNav77+H5x4AE8w
	0rWMweqpKyOfnKIiOBpCgUdfqDR6CBzhfJyqYtVKtTSWQ/tlQ=
X-Gm-Gg: AR+sD10HYsQTabTFCOKqHRXtelYWOkLi7b5SzWKhRkEQ74FolIC20Vp7K0u2Y60KpYk
	0JdSjsQRx6S5AmZ8y3pd1X+tyd2Dz75uHRw79PZ+bJeQ05tFlofXTkTpdRHf/4UM7sTB8daMfxk
	fB2nb3v4dCHfeI0LALbwMGRXt9XW/4LxZicpVHI+MZTHQGO1LlvPTo91CYcI8uhHhm7oqhf1lwx
	dDEZg7/qlXSFIDTzjppz5rbQelJhuHx8ZA1n8RAMcuAdZp2x2EyyJBRFgcGrdzN1cqnwQzkl3JB
	yAMSdE5xyQ6gCkkxv+QiWmjUeoWfoST6p+x1etN7uT2FktmDxH0LSfwYdZlo12Lyd1wADF/7TUn
	I+9gWPbMJAgmG2hX5Vh0KxkrGB7+1ga7dVyoBC6pa7rTcLb9P18FUEtSsHm2Y
X-Received: by 2002:a05:620a:36c4:b0:92e:7cc9:a888 with SMTP id af79cd13be357-937800dde60mr1010325485a.2.1787795861312;
        Wed, 26 Aug 2026 18:57:41 -0700 (PDT)
X-Received: by 2002:a05:620a:36c4:b0:92e:7cc9:a888 with SMTP id af79cd13be357-937800dde60mr1010322585a.2.1787795860727;
        Wed, 26 Aug 2026 18:57:40 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e30adcesm341042385a.4.2026.08.26.18.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 18:57:40 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5] cifs: don't update i_size in cifs_do_truncate without a cached handle
Date: Wed, 26 Aug 2026 20:57:38 -0500
Message-ID: <20260827015738.79123-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c5ae6c999664ec603d3ca6aa8a226439d89eed48@manguebit.org>
References: <c5ae6c999664ec603d3ca6aa8a226439d89eed48@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If find_writable_file() returns null, cifs_file_flush will return
0 without issuing set_file_size, and the outer 'if (!rc)' block
will set i_size to 0 before telling the server to truncate.  If
the cifs_open() then fails, the inode will have size 0, while
the server file is unchanged.

Move the netfs_resize_file() and cifs_setsize() into the 'if
(cfile)', so they only run after a successful set_file_size.

In the no-handle else branch, evict stale pages with
truncate_inode_pages before the O_TRUNC open to dispose of old
cache pages, and let the open response set the i_size.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
v5 changes:
 - take inode_lock/filemap_invalidate_lock as required

 fs/smb/client/file.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 389083f9ce00..100acc76e9be 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,10 +1012,26 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 			server = tcon->ses->server;
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
-		}
-		if (!rc) {
-			netfs_resize_file(&cinode->netfs, 0, true);
-			cifs_setsize(inode, 0);
+			if (!rc) {
+				inode_lock(inode);
+				filemap_invalidate_lock(inode->i_mapping);
+				netfs_resize_file(&cinode->netfs, 0, true);
+				cifs_setsize(inode, 0);
+				filemap_invalidate_unlock(inode->i_mapping);
+				inode_unlock(inode);
+				cifs_invalidate_cache(inode, 0);
+			}
+		} else {
+			/*
+			 * No cached handle; evict stale pages so they can't
+			 * be served after the file is later extended; let
+			 * the server's O_TRUNC open response set the i_size
+			 */
+			inode_lock(inode);
+			filemap_invalidate_lock(inode->i_mapping);
+			truncate_inode_pages(inode->i_mapping, 0);
+			filemap_invalidate_unlock(inode->i_mapping);
+			inode_unlock(inode);
 			cifs_invalidate_cache(inode, 0);
 		}
 	}
-- 
2.55.0

