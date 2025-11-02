Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5662821883F
	for <linux-cifs@vger.kernel.org>; Sun,  2 Nov 2025 07:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762068743; cv=none; b=MYKZ3UHJSj+j9Rmy6ZLYWIWNHuRUoBUu6MW/O3XTotZNT5JnNPBJlemgmBKQYoEG7WEM56sFU5bcu2NxIrs1qQPXYC+2Hjn85kmyhs1O+GCNlg6VUjqbgHdDCYIfUMS7d6CYUMq06jbLcqTryIX43xTnXnlLwc4wKVDGaxiTAtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762068743; c=relaxed/simple;
	bh=lv0j/YcQFKnUdk2DHk6VDntmzv28QzwppahtJd7spvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1JdToBEvJPFn8IadvQuAIbPo2WQts6/Y6RFr2mrcyBbQY8rpRIMjZpVekWi7FmI88iS1ZZA7CyoS+4Zp8blenzQ4f4L960CWAesv8d0vc+2+s05DeKkTN2XyGBeeDsBtt0NR/qShMhtIC/Zbk87M4HRr2QZW2iRJaKHqIbxFCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vSCcAmoF; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vSCcAmoF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762068738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRMYMmekqqB7pIlz/+ak7bgcPvJClWJupmxwrOImkfI=;
	b=vSCcAmoF1xy82lMvssN4AVU0mW/KDxleHuk8icuFO3M2ij8CWnKbkdGpUxgIUnCu8hBBi0
	jjTvQMRWsUGKmNvu1oGcVO+rNojoRKOl+Iu5Mz7rYocr3BzQ1/V2CqLa9a7WerzJiAWxpb
	QLAe9LoGU/nHC7Y8fvHPFILTCONCTE0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 01/14] smb/client: fix CAP_BULK_TRANSFER value
Date: Sun,  2 Nov 2025 15:30:46 +0800
Message-ID: <20251102073059.3681026-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See MS-CIFS 2.2.4.52.2.

Keep it consistent with the value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index c86a329e5822..aba9caee8302 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -711,7 +711,12 @@ struct ntlmv2_resp {
 
 #define CIFS_NETWORK_OPSYS "CIFS VFS Client for Linux"
 
-/* Capabilities bits (for NTLM SessSetup request) */
+
+/*
+ * Capabilities bits (for NTLM SessSetup request)
+ * See MS-CIFS 2.2.4.52.2
+ *     MS-SMB 2.2.4.5.2.1
+ */
 #define CAP_UNICODE            0x00000004
 #define CAP_LARGE_FILES        0x00000008
 #define CAP_NT_SMBS            0x00000010
@@ -719,7 +724,7 @@ struct ntlmv2_resp {
 #define CAP_LEVEL_II_OPLOCKS   0x00000080
 #define CAP_NT_FIND            0x00000200	/* reserved should be zero
 				(because NT_SMBs implies the same thing?) */
-#define CAP_BULK_TRANSFER      0x20000000
+#define CAP_BULK_TRANSFER      0x00000400
 #define CAP_EXTENDED_SECURITY  0x80000000
 
 /* Action bits */
-- 
2.43.0

