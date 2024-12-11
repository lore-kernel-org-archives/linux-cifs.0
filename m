Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668A2248F80;
	Wed, 11 Dec 2024 18:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943151; cv=none; b=UOe98KUGaOAsN07YVcj0UzgHAgwWa5+QQoKGDMnTezjbssUup+6XY981ZeCW8ExZtNPRqpSdWIPnzUQaqvuUBS4UVzk2jpShN++FuQ7bZVcOUTGwDt5M+a48MV7ejz8Ed3IQMuvGaEzp7LIheatJJb+N8tlQr8tWRCtrqN1j+OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943151; c=relaxed/simple;
	bh=5hSPMnldBgY9UKf/u0hqAzFOb+7nLofEL7LtC2t2ljY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHe+L1GLefZoBlTuVWNAFlzc8DnSsWmE9LZK7dG6ufchWfEvpJb/7gkll6JbxTxnMs5XmpBJq+K5T02QA5nnQ1CW6Msx+xqcv4PUDn9DvkAaozmOdTDellCHA2QszXAoW4U7dcCmuTr/kxmhgOdWACpGnOym1xOStsPsZcZWuLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbdROcji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbdROcji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBD5C4CEDF;
	Wed, 11 Dec 2024 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943151;
	bh=5hSPMnldBgY9UKf/u0hqAzFOb+7nLofEL7LtC2t2ljY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbdROcjia1Er0mEHYwNEqRyIhErZwbiL2vj6AuJ+AW2bE/WTZ8a8cbQgWa6+rediu
	 pUbVLYqRZJNDm2LWNyj/ezZwV19PrZh8W6jm6d+YJmV82PR6nTapw6B1FB0cL9czqa
	 A9eJgVejEA3nPrYH5jjUa1dttcTTj7pkgFwE0/v1cxWm4VivtnJK7tubE1MCXy82wY
	 xAG4uWmEKUW54hp61KLWgbt07I6IrmWqnkDV6ZtVCFb4osrI1o2qEN30ZwKMmDKtu1
	 L+ylKIbYXPLh3rb4JiiEzH3SiASUcwRMFmFeDB1dxmP+X1BWZOmr8I2UgzFZTS59Fe
	 TBM8lvtYCrRuQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 08/23] smb: server: Fix building with GCC 15
Date: Wed, 11 Dec 2024 13:51:45 -0500
Message-ID: <20241211185214.3841978-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185214.3841978-1-sashal@kernel.org>
References: <20241211185214.3841978-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.65
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
index 663b014b9d188..23537e1b34685 100644
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

