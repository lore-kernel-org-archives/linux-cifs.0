Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BB5239BC5;
	Wed, 11 Dec 2024 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943061; cv=none; b=cV1Pj6wQdAVDfCFqP97+PUXyokGWC8qb9DB2jj0c5XgFt+InNOMgQHmdZ01PP6W7WdnlRfy4TRdoBjumVmHOerSpFfgzNqLtIIOXKEDsC+a0PqcGF7oKaZ+tkspW1gUwYvYJ402TohIc9ingDKz85bsw5CKXBukGfwty+DeFDwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943061; c=relaxed/simple;
	bh=7Qy4ZhAFYEJeE2aHC5sTXAZwDOO6QBrXQCavMtu5fuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOxuPD9+vndRMILU7UYlLikIYWa8eO0htRvxk+tvySLbyQ7tuiObow/Jv3QheIs3EKiowUexcUWBFNQT4bPDoYC3n0QFhKWks6TZ72jYqtGps6AOtyMk3CRQSNkr1R6BH1qP6pqcpnZP2+6kZ6aucGZVCiQDo0ewAgvRCnziSh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjgDrnKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjgDrnKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D58C4CEDF;
	Wed, 11 Dec 2024 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943060;
	bh=7Qy4ZhAFYEJeE2aHC5sTXAZwDOO6QBrXQCavMtu5fuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjgDrnKWBCjZpUS1s8FtHoLRnbFSOTvlgs/is12L9L7Py/wSJrdhhowjH5lTngmJ/
	 p8TRG4W+pKDM6eTlA81s1wFkIQiBvIcvebU1v95hfLpQWjH9OuWhqgBiaWFZys8dCl
	 KJwrIbyrUgtBzIR52P14CDc+rn8crTTZKz23rm1yIQtG0g6HBh4HYTvJeh6b1rcIb8
	 qnFBSCrc6DxbX7mrdKxJG4/mxspFAUI0HBqCKcJ20gDPA8K/cXUCaDocwIUlaqYwQD
	 Cn/jyvWqHdd3wTLOAzc4La91n3H+EcwUpOaToHIb8K9+YJdqdMU9fNtZQN+Xjy62dv
	 bXGDl9aIvNGzA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 15/36] smb: server: Fix building with GCC 15
Date: Wed, 11 Dec 2024 13:49:31 -0500
Message-ID: <20241211185028.3841047-15-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185028.3841047-1-sashal@kernel.org>
References: <20241211185028.3841047-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.4
Content-Transfer-Encoding: 8bit

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit e18655cf35a5958fbf4ae9ca3ebf28871a3a1801 ]

GCC 15 introduces -Werror=unterminated-string-initialization by default,
this results in the following build error

fs/smb/server/smb_common.c:21:35: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-ini
tialization]
   21 | static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

To this we are replacing char basechars[43] with a character pointer
and then using strlen to get the length.

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 75b4eb856d32f..af8e24163bf26 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -18,8 +18,8 @@
 #include "mgmt/share_config.h"
 
 /*for shortname implementation */
-static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
-#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
+static const char *basechars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
+#define MANGLE_BASE (strlen(basechars) - 1)
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-- 
2.43.0

