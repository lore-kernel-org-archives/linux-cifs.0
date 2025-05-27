Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D100E205E25;
	Tue, 27 May 2025 02:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313484; cv=none; b=SggpVcRjqW9cRW5T0k+1G1Xp+jdhtAhhe8iAD2DJTRTLfUpCxJD1VaU5dxlUY9CmM5Ne25Wu4pHa16nkTPei+te0ejtJoCCH4Fd9TB0b6MeQgzU4LQc+Vakr7k0P2CmdMc0Mf70uOrVtibIXQdT9R4EwIAeqDPKs/loCH2vpnZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313484; c=relaxed/simple;
	bh=I5y1HK2QtWIifiPzrHlsxqmsHSZxl1xxj8VOPj2saVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jcwei1ZqqAwgeZTzN6nKtxbZn+Rjx1DPoVj5DidEB7ZpM+cG3l+82nmKkIWJLdUtMIrAqiNcBQvH/ehBD/bAibWqYF+bX1uwZRMld6j6O9Il7YOrQNQbK9+MecyIaxXYtV1UAvjlSlSqnlHx0uUEkODNH7hI6T1XyAAGbgFH0Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOY9OCK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOY9OCK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CA4C4CEE7;
	Tue, 27 May 2025 02:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313484;
	bh=I5y1HK2QtWIifiPzrHlsxqmsHSZxl1xxj8VOPj2saVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOY9OCK54aTpbAYnCvoEp4pnvaCwGPmHpWAWp9SseupgYTClCvuqPR1A6ljr/FVwF
	 ZWUCHBWvySDFbb/IgEOJXDFKQChvpP25uXT+7eRQHJCTLbmPxHzb5X3PikAVWTOkfc
	 OeKHr83Rt1T2fupi5wxxL+s32h7fr0dTFktFdASba8aWF7Qy30x8kwAFTeUVfJGl9+
	 VgGWPsFVu3BM2DFslpi84snDJN/HKCHgVzEtTQtlHCbXo8WQXkSDakOJ87YMtmlcMH
	 MfrtzM1BiIYSwOgN+T3Be1J70xj1O/VmGXNTdiiRmH7adZfdAur2wQ0OCZRRTzZwV1
	 REw2n/ffzRZVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 4/4] ksmbd: use list_first_entry_or_null for opinfo_get_list()
Date: Mon, 26 May 2025 22:37:56 -0400
Message-Id: <20250527023756.1017237-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023756.1017237-1-sashal@kernel.org>
References: <20250527023756.1017237-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 10379171f346e6f61d30d9949500a8de4336444a ]

The list_first_entry() macro never returns NULL.  If the list is
empty then it returns an invalid pointer.  Use list_first_entry_or_null()
to check if the list is empty.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 72294764d4c20..e564432643ea3 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -146,12 +146,9 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 {
 	struct oplock_info *opinfo;
 
-	if (list_empty(&ci->m_op_list))
-		return NULL;
-
 	down_read(&ci->m_lock);
-	opinfo = list_first_entry(&ci->m_op_list, struct oplock_info,
-					op_entry);
+	opinfo = list_first_entry_or_null(&ci->m_op_list, struct oplock_info,
+					  op_entry);
 	if (opinfo) {
 		if (opinfo->conn == NULL ||
 		    !atomic_inc_not_zero(&opinfo->refcount))
-- 
2.39.5

