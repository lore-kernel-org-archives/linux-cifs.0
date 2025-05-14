Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05881433A8
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 04:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198492; cv=none; b=KmYebsPTB0RbY7kIkFhpNeL3BhcSE6Et8CO4ghciLiDjtjgHN9756Q/XMKCAaKG0n2XdTi6rqhgKVFBgO05znjtyC3Pb1mxXpVWHVkijjG28th2z+qtnw42nzwPm5EOhMIhOEF7RVyN0iIc6C/iaAbngzbGmrskbyvAB2Jln9DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198492; c=relaxed/simple;
	bh=/aZ8H5Bd7PuESiWlAaXV/Jbv9mZ0Cey3472IQtZfzkE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bQ4KFRiDCh1pOiedn5iDi/JZ5CxoEa8g6BqEY/krgyMfuGa7uNXP9F6Nm71M8S8WMtLHDwSblXH/yhK7Iw9WHltjqQVoyoWFfcgO00opRDHph/UpRcOXHmkIKaCXd/xYwr/07wQdK3hJqtFj2StkHdU4PpP6J8ReaCRsGSjFkhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hudt/KnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hudt/KnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8C5C4CEED;
	Wed, 14 May 2025 04:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747198491;
	bh=/aZ8H5Bd7PuESiWlAaXV/Jbv9mZ0Cey3472IQtZfzkE=;
	h=From:To:Subject:Date:From;
	b=hudt/KnCWeJLLnWj0IYi/9ZVX31wSoDeIDLnRXnX++68MlrsdZEtrMNhG92kI+W40
	 mdYw+Z+KVku4ai1Eyq4rHBUBY71DLvW2yQT0uwTwqE0OpI3qwczL1TVOE5AjpFlAzG
	 2xCJ7lFrys8VmpcDlEP9UGcBkpopW0+KeDIM6TQobCF2gPf5vEA2xGbLUu0qDj/4Tl
	 GshAI5sp804DOyDC8iTQFJ7tSgTAsWpTvqRJFfOYIjR6wgMQtIULuI7RtNKMwEN/Yl
	 fVMFqGauN0JKnpg33A8/ExN8x5tp0EkKsZxmFZ12UrSdbWJBGO5TSw35qMlTzB0sHu
	 dtJZBn3WzJcmw==
From: Eric Biggers <ebiggers@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: remove unnecessary softdep on crc32
Date: Tue, 13 May 2025 21:54:07 -0700
Message-ID: <20250514045407.118970-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

ksmbd accesses crc32 using normal function calls (as opposed to e.g.
the generic crypto infrastructure's name-based algorithm resolution), so
there is no need to declare a module softdep.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/smb/server/server.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index ab533c6029879..8c9c49c3a0a47 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -629,8 +629,7 @@ MODULE_SOFTDEP("pre: cmac");
 MODULE_SOFTDEP("pre: sha256");
 MODULE_SOFTDEP("pre: sha512");
 MODULE_SOFTDEP("pre: aead2");
 MODULE_SOFTDEP("pre: ccm");
 MODULE_SOFTDEP("pre: gcm");
-MODULE_SOFTDEP("pre: crc32");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)

base-commit: aa94665adc28f3fdc3de2979ac1e98bae961d6ca
-- 
2.49.0

