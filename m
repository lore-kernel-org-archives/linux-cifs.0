Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD8A32B981
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787234114; cv=none; b=aSrvycbhtjnS7ZtQY6IEcgDm2Zh89oavLhVR/uoby/3023ggMcXJ4NUzSpNoQdbGbqZFPrnRL7UZf5Ui0k2yttf4v9hDE2Uurw5VmPbKlM/OlEMSCU6jfUY5Jerci1OCCokJ9laT3SC4yclJsEcC60Vuo3C8IB+DOoumguWWB74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787234114; c=relaxed/simple;
	bh=knc+yUqQ6q91a8MDf9q1w5nrNj2dhHEfGAq2Kh0pDe8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=npIQJkTPcYZWwvx0//JbDxYFKTIbxQSFeM8nTifNFAQ8THDUJ1/QS5wmwhoVcHZ1TKFMW0V50skFoFfsncOI3ZeZ/lLIN7o7gl6QYe3eChDOROoaA0CPSo4b188uq4AskUpOgjaN+Lg7J11o1nrUe4bAot6HlKiuZEC4ooyiT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MycBZCww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MycBZCww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2E11F000E9;
	Thu, 20 Aug 2026 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787234113;
	bh=3tEnmj4b6QqGDK5ZshJtAy6fxTQDrvYMNWCJyM/pyrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MycBZCww3k8teFQUeYaumjlb6hu6SzeXxNL2fhr+qL+6hh/b9r2SFc2lJ954fX5Si
	 r2CfNGCWj92DcmclyWmM0IvyKTb11rGcRfPetFi/3/Q7nLhzBoZTMAUZSQL0uaIsJr
	 R6OljTWWRi/aQlZM3ki5OR9Rn1TKxvNCGoGLiX2ofZkn7Uq0glu9EWhtFkCjEaxm0h
	 1ifS3vmkMqbLN52VgXcU+J25FH6dyNf3R2lXiVbS1eojNqCKITg4of2jm4H8Z2DKI9
	 FXKtHkipcBgX1WhChnYbBGPYLhcCEjA6oZ1sVtFEphr6sQcsJ2X7Ru9eIFbDms1+pU
	 H68sAsSMEFMXQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/6] smb: server: remove unused DES crypto header
Date: Thu, 20 Aug 2026 22:54:20 +0900
Message-Id: <20260820135420.5634-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820135420.5634-1-linkinjeon@kernel.org>
References: <20260820135420.5634-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DES crypto header is no longer used after the removal of NTLMv1
authentication. Remove it now that the server no longer selects
CRYPTO_LIB_DES.

Fixes: ce812992f239 ("ksmbd: remove NTLMv1 authentication")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/auth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 9f3151a9f379..5ec43e32de3e 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -24,7 +24,6 @@
 
 #include <linux/fips.h>
 #include <crypto/arc4.h>
-#include <crypto/des.h>
 
 #include "server.h"
 #include "smb_common.h"
-- 
2.25.1

