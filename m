Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B78D3D1713
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 07:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122959; cv=none; b=c5ZzWBh3oDIuiNSthGllypxq3VYFrHniJ1C/Jk2Jlt3+4uvFJ5HAm4ayOpK1uB2m0oauGPef1xoQ0lj4YLYEGyc1LZ3yOLsaQElAT3hqcIvT+iatz5IAVTmv43S0SwF9m0Ss3VsML3rfMEnM06qsjVJSGuOaceq7Q/xXxhAxeZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122959; c=relaxed/simple;
	bh=q18WsZrx9wB3R92+DdWfcPwNR5K40Iqq0WkfrkOS7nU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GcFxb1k/3oWgMXdUU6ehYuus5aStZz4PaOd3Svg0lTDrUbiT0qXVoPJOJTDVQQH69yFxZsYLiKxqH5qBQ5oSQMGINostEIxTprstAUDRT/0OO7mSFvSJHK9mHsE2auRMwOgRAHg9IlSDhirE3cKike1H/aeRadA+0t29ZG8MeW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=jnvwoUPe; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="jnvwoUPe"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=q18WsZrx9wB3R92+DdWfcPwNR5K40Iqq0WkfrkOS7nU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787122953; v=1; x=1787727753;
 b=jnvwoUPeiEhI0GFWrWbrIb/RqSQLHvAmJ+3zBFaqnS2IZdKaD2WFlU6RSamoHmoJKaO0EhBA
 mGiY4wFFyiJG64IGnT1hVZixIc7J+asoWpcYwzml30gIJbPgPW5GjKLRa+DQ8uRnG6/s+IeBkvN
 H6pcpqd4AP9QNnt3bOR+ecr4LWHRCDxH5F9RUFP3WCEUavX6aZXbtgalaM9TsiuSLJ76PbLo4sL
 4CWHedLpk/cR4/rBtSd3q2FjIbASSGADcrPEVSsFztdpjwbByW6qxadChribKdfypHX6XjphRG0
 rmKr39MQNh6mCOfBVOIa/mZhCsBhZDs4IxMuY8NChsZoQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 7c214f627554d988;
	Wed, 19 Aug 2026 07:02:23 +0000
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] MAINTAINERS: add myself as KSMBD reviewer
Date: Wed, 19 Aug 2026 07:02:04 +0000
Message-ID: <20260819070204.526973-1-chenxiaosong@chenxiaosong.com>
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
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..0e14eb701250 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14138,6 +14138,8 @@ M:	Steve French <smfrench@gmail.com>
 M:	Steve French <sfrench@samba.org>
 R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
+R:	ChenXiaoSong <chenxiaosong@kylinos.cn>
+R:	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
 T:	git https://git.samba.org/ksmbd.git ksmbd-for-next
-- 
2.55.0

