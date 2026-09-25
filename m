Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2FF4BC029;
	Fri, 25 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347063; cv=none; b=uVuWxDgCICzMiGfG/3EhRybhuHp+f2gFQ9Y318IinXmBtgHHOoV+RXHKvLT0AOGuCpOjzrRsb39KrtfxHY6TrNRkDZ6cm47NIB9ORbI98/PiMlgQ/BrHfrLCmahubfvylb4txSWPsI+jrX7apt06h6IAGBef9iZZFaQTvX7VXjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347063; c=relaxed/simple;
	bh=T/25NIEPS4IuTTsbhBm2lhHdtLqb9QzxeFq0ILdk41k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3mla5l3xztFoY6kGew+CDSHHtLtV/gWx7YHaB2QTHFnEdyE4cSpFT0d3bCfEutQKe9QTLj9m9I75MNPVkmwvD82JLjwNQzPGcpco3vWp+9sVpnOkvvk8CF/xgCv3JDPbGBDIvc2lb1FRKsmtX2jbwUIRHcsd2QW3JJ0reeMC20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GsAYF4J1; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GsAYF4J1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=4p7wnCBaYEeh029O+ut8T3Lr0HC63yyFYrL6Ld6TcmY=; b=GsAYF4J1SKeStwyGw8BcQIPAyS
	8SXRtMPpb4PmbAlp60m0+A0kQRkLzA8Lo1r5OrIRtO58aaUdHQoyVSLZ9Ro3NO+Kyh1S969l6Lbj9
	zPcjdFZyxkmPpWZuvK4g1byT6rTEg8MA/4Jqm15EWJ94MQ+Sf+HImbMwuE70bi+YVQeMxuZCFKSrk
	o86L8t7wZuclBcb4UAc1dRShhsHBaOFPy5Orzy7RTFWCVPIZXgwJY0OmjKd3vMuBDKncVhb/KkDwp
	1sDFK8yj1KaELWss5fIZh25ieNh6IzP2mAX0Gz0rVifVgFQLESHNmCXczQd+kksy2KExe82DDCraR
	2RsnVOkQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xA73A-00000002GxQ-1CMK;
	Fri, 25 Sep 2026 11:37:20 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 3/5] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Fri, 25 Sep 2026 11:37:17 -0300
Message-ID: <20260925143719.2889518-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925143719.2889518-1-pc@manguebit.org>
References: <20260925143719.2889518-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_zero_range() removed the pagecache only for the range being zeroed,
so when it extends the file the folio straddling the old EOF - which may
hold data dirtied past EOF through an mmap - was never dropped and became
visible as file content once the file was extended.

Lower the discard boundary to the smaller of the zero-range offset and the
old EOF.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---

v1 -> v2: no changes
v2 -> v3: no changes

 fs/smb/client/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index aa142420dae2..e55e081e47b9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3558,8 +3558,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	truncate_pagecache_range(inode, offset, offset + len - 1);
+	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 	netfs_wait_for_outstanding_io(inode);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
-- 
2.55.0

