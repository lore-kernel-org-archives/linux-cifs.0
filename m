Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E4D4B487D;
	Mon, 21 Sep 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005813; cv=none; b=M1EREP/FUtcI9isqfblqmG7ImKPmkjYEPMl5SqlGuTaKKUzRsgoT9Z0K7sITfxNERiBNjpeLnH7+370KA7BukVlFM+y31upoMrkzsxEC3hJ4MPv56oeGt9CALAqGTwoU1zt4EI+upC89bNNPjFI6z2QgG2TJXZelWrtLjloiUdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005813; c=relaxed/simple;
	bh=PRbAzBr8GDExZ/uK3wzEWr92TsZMQPffoP2R79OrMpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBKEsSOjO/kjJmHQ5vts3LPClu4My5XiPjOEBTpZwhneZXA/eX+REe7kdTxoIpc9PCIBYoqHBSNowKBJn/LsTbXUGOwqJ6shjt9WbR2kgMDzy+1IY555waLuJVEJw75HS54sioE8vvRb0hTEUwouG1oYDI29h+5zIBHWh3IyX9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=k8Vly8NM; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="k8Vly8NM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=qQ/AAEyMjOzO/VHuplu/nzyZcEXtt7b889yubhsKacA=; b=k8Vly8NMjGzCBQRihievR/7k/V
	3Bvkkmg4o25c8wfVldguw0efy3FPq6mdRMKac8j6rdI240P0YXzT1CL1b2GQc+6YWptbHYnUHWVUF
	r6HYUD5sqFu2ZGHjsxJ2Za+IjZjoeLR82UeVbsHzJ84HA882V27Cpstbp9TyeQAtKQtJ9+AHyFXYi
	girEwL+p/MraBi9LVjFk8UkJqa8T8UsD0p9TcGDOoPiQOmHrFJc8Jfd5R/EjiBbbN3qdkx5sizcv+
	fIk4CNjkLr5yw57W6J4kzrv1mhxIvE/mEZam5rStXLUAhx/hA3Y2YZK1nBcl/BQHmL0Zt406XPyVb
	NdUaURuw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8gHH-00000001wCD-0vdI;
	Mon, 21 Sep 2026 12:49:59 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/5] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Mon, 21 Sep 2026 12:49:55 -0300
Message-ID: <20260921154957.903891-3-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921154957.903891-1-pc@manguebit.org>
References: <20260921154957.903891-1-pc@manguebit.org>
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
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3464470d3297..7282ed916470 100644
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

