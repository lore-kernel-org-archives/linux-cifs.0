Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A32727EA
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242722; cv=none; b=hUSwrefeXzXGcOHdArKDdFPiv6pix0Sv0pi2xZVFFDeRBKtaiDDrC0es5TpVsB5pEH39TJjki2lDCi57ILxK0sbkEktV/fp44C1rNJ4/IMl7MtwlJiyqXMug6r2S1AcTf651XGIVK4uD9RuR7ynQM85TD0iUyEo08e9ki9cxr0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242722; c=relaxed/simple;
	bh=cF12PNbUSLyD63AHjCJrMJVzeVpqx/iyCHOBJ/p1WKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYFyZPpxkR+QQnDVDV3kqo+DQPi+MoQxQiUv2qgivohtnfhZVjZRxbF222sfFxRn5oDN1culZGit7t0Z5Mh3F8f2hB+QxAT0zRFZkbiNoGOWjgulEmGfdP4WfIcaAKIBQPkbR8D4OXeiN9lNou1ca9Mm+aGRbEjO8xYKYhE4wM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hl1K98ib; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hl1K98ib"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzIaJrMzvYS60mKR3yU8O6WH7z/4PRko2tZU5GVznyY=;
	b=Hl1K98ib/E2TYTxm2qSodkdCdFKQTFJO6b7zxpp35yXFLYuXDQTnH7V9em/BhNmZ8HWCsQ
	Bj1bg10S/NnuZn584keAtur+/51qppg9O/VPmx5+qLFiyvgsPzWPqUx2cuLrHjnSeCwK4J
	KwtVoETQNoE9E2/whZQAyNFGFkJQn6U=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 06/13] smb: update struct duplicate_extents_to_file_ex
Date: Tue,  9 Dec 2025 09:10:12 +0800
Message-ID: <20251209011020.3270989-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add the missing field to the structure (see MS-FSCC 2.3.9.2), and correct
the section number in the documentation reference.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smb2pdu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 87a92cd00282..5d6ca221d4b6 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1510,9 +1510,10 @@ struct duplicate_extents_to_file {
 	__le64 ByteCount;  /* Bytes to be copied */
 } __packed;
 
-/* See MS-FSCC 2.3.8 */
+/* See MS-FSCC 2.3.9 */
 #define DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC	0x00000001
 struct duplicate_extents_to_file_ex {
+	__u64 StructureSize; /* MUST be set to 0x30 */
 	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
 	__u64 VolatileFileHandle;
 	__le64 SourceFileOffset;
-- 
2.43.0

