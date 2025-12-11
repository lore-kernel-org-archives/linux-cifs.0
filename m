Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA0A28312F
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463630; cv=none; b=qB1IMoaeT5o/FCDliJlE1qpmEECfw9z+fV62UoiMqomOrSeL8+XFTEaktRzA1HJEZ9pin1bfDng5UwRLaHtCMCdOAU4l9zOnPeWjsZz25v1rD1L0kYpg0fTmM3SyzJe6xQwrzJfGiJPagtzWSRN/eSo5ITW7ByIqfSyWwVQlZd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463630; c=relaxed/simple;
	bh=tSTu7uUu3xdc98j97FV+7fQhyMMjbMTXy/paskabVJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmPs8UqEut0xm48F+zg4fwS4ia2LjMHolNOuixZEASMUcYyc+HBgme5EYL+2Wtt+zmp2BXtq33SHT5DC33IuG+Uvo1qXpXWVZ7T2N6CzqH0YbKXOTSIxgG6/rANGb9wQFOwHijK/4VcMJXksnBfVhgNLZe/r06Q2I6oWeuENkLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BVT16hut; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BVT16hut"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ulb3PE2e2xkAf2hF5H7JITgN051/NEYe6gvskt2GbfA=;
	b=BVT16hut6Zljczl6wxJkRboYlGT+VPnW2K8p6HFobQjwTzwFeNulQBH5Uc7XASYXAeTCRL
	Du972YX/zH8L6350Q9OdFDD21Vl1Y2aUbgQNhJ13NkEpL59Q+jvkPRdX18/eRrBgun8bmV
	AD21M3IAkiL9M0UE3LDgNmwS8AGsjWU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 2/7] smb: update struct duplicate_extents_to_file_ex
Date: Thu, 11 Dec 2025 22:32:23 +0800
Message-ID: <20251211143228.172470-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smb2pdu.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 5372a820118e..3c8d8a4e7439 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1510,9 +1510,10 @@ struct duplicate_extents_to_file {
 	__le64 ByteCount;  /* Bytes to be copied */
 } __packed;
 
-/* See MS-FSCC 2.3.8 */
+/* See MS-FSCC 2.3.9 */
 #define DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC	0x00000001
 struct duplicate_extents_to_file_ex {
+	__le64 StructureSize; /* MUST be set to 0x30 */
 	__u64 PersistentFileHandle; /* source file handle, opaque endianness */
 	__u64 VolatileFileHandle;
 	__le64 SourceFileOffset;
-- 
2.43.0

