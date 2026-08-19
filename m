Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E46B3D3D14
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787123590; cv=none; b=jImlp5EUPHWFIKiBJNv5WumduGX09PtkuUdwsaV0/4n/sGoa1e0KJcO8LT1o6XxnUjAVW6TuIzl5+SU7p9RQa+k4LeZux8HHPtURjUCJwdoG2up5a6h4PtsBGlHzyT9ucBixqxW2RYeGuJEHdbaH5MuUXG9Vq0MgW5KR3xfzYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787123590; c=relaxed/simple;
	bh=MLAXzTyxmELzhwb+BZr1Uup7+FP9q7zwz/MhN+HMLeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sMK4SnuZ6gF/cL+4boDbUmttGZaBkBOmEpyJnNN47pCcmrf6tEEuWE+yn4ZMdT/Ldx1lIbzWdyv7/qR/Z+fV8Slp58ZEJ3oUale1JWqc1USRABa8xd6X1LdlX7YRGK9hR75K7O8+m4+kjLpBWAoH/FlYZ5UR8FVLRqPL9JX1LJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=t3+JMJEq; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="t3+JMJEq"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MLAXzTyxmELzhwb+BZr1Uup7+FP9q7zwz/MhN+HMLeU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787123582; v=1; x=1787728382;
 b=t3+JMJEqwqPSm1Z/6V9JrxsIWaQFTNNaimveqpMk6wG9asIL9cENwTjQTdRveg09xvgscGtt
 cXcXiO7k9I28jqS8n3uzXfLkjX3zWfQ27VpT4rN1z7bRZDtDkFFrOafQeDzDA5ZRDuATThbtdtl
 56Hu9UO8LuhtSP2a6cb5a3YuZ2i312Uzn/O3wkrGQpGCBl5rc/Lv/0X6ot4yduRX8MC2CjZRseD
 aC7C8czfCNBgEZ/OHHOcZcwXxXGJS1Rn4EboSPzxsfJOlCDV2NmzN9dduajIniO822uA/Bw4cBM
 y5Hvg4O05k1+Tvvtk6r0/rvZNBVLI7Xwku95AKpSErdtQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 51ec0d3638fe3cc9;
	Wed, 19 Aug 2026 07:12:52 +0000
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2] MAINTAINERS: add myself as KSMBD reviewer
Date: Wed, 19 Aug 2026 07:12:24 +0000
Message-ID: <20260819071224.527479-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I and my team have been working on KSMBD development, and I am also
interested in helping maintain this code.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
v1->v2:
Put `@chenxiaosong.com` first so that `get_maintainer.pl` can pick it up with higher priority.

 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..a0e04c0ba453 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14138,6 +14138,8 @@ M:	Steve French <smfrench@gmail.com>
 M:	Steve French <sfrench@samba.org>
 R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
+R:	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
+R:	ChenXiaoSong <chenxiaosong@kylinos.cn>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
 T:	git https://git.samba.org/ksmbd.git ksmbd-for-next
-- 
2.55.0

