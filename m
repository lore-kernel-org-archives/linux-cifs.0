Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAD6191F94;
	Wed, 11 Feb 2026 04:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770785784; cv=none; b=KHILnF2SISNlkXTlj/XPUA/eV6BkO0CY/LPw6cAgihTjM1EzISB7THS+XW2Rjuuxmvs9Zob3cDIOGvKFU36RzTAHvOD7g2qXhOL4pO/S2KEv3I5h8VnzpAK13I0lEENSR4HuCKZ1bTMc0Ky4VVYu57/yV7D3wJv4M45Z8+FS9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770785784; c=relaxed/simple;
	bh=Cw3fRHCHWp5gOXkdT+awUbBs3/UGFmPQz4uWhu0HFDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QyPk8pAFK9NaaYDKQ9VF0npzllZDpEDkKeVF58U/6JYUI+dUf8d2iFvpXy+13yOcOk7RBxpQRa28knljiPXIGpjZSMU4v9wtizTSd7SETVRoXMlXXbl+67JMjmyjO8y2NPf0OarMk0aQ06xFgdBHJF62cNrbVqupvFO2x2Uu1yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAAXpgnwC4xp4twJCA--.47430S2;
	Wed, 11 Feb 2026 12:56:16 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] smb: server: Remove duplicate include of misc.h
Date: Wed, 11 Feb 2026 12:55:33 +0800
Message-Id: <20260211045533.2936005-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXpgnwC4xp4twJCA--.47430S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY67AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	c2xSY4AK67AK6r45MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r126r1DMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxV
	W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjQtxDUUUUU==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove duplicate inclusion of misc.h in server.c to clean up
redundant code.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/smb/server/server.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index c2c074346da1..f7db120c92e1 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -21,7 +21,6 @@
 #include "mgmt/user_session.h"
 #include "crypto_ctx.h"
 #include "auth.h"
-#include "misc.h"
 #include "stats.h"
 
 int ksmbd_debug_types;
-- 
2.25.1

