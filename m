Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA2C35EE9;
	Mon,  4 Dec 2023 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Et3UT5Ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFACC433C8;
	Mon,  4 Dec 2023 20:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722126;
	bh=U8lKSXm6oWYfv9aGWHQQ2wtvUQVQ/g7PATqFBLi70tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et3UT5EjpVliNlsLq5wi8oXgR6Bu0GpzuX8s7QthNCjZnzYgygAJjybcgodonqomU
	 C0jKHAOO7qSn7ruIbWxmV+p4aR//T2tKkUptOWzcC8CWq2oweG/2eX73ooOfl9H/R7
	 RJtuiOEGn1Y0hLClTnLpneKsh+ENiRvggaDhZduW1nOfekc0IQyYvBkHOInAWLnnvY
	 cqMLy+cI4KLXg8so/KjAYI0NzlF+wNwNKLDNe21diA0zGyaLRbuGQMMAcLeAKtZZFx
	 bA6xAf7NOfFx3sUcL/fYDOBNvn7yqiySrCuIJkN4dt3yf1XWPHF/V7PhyPSpT6xCwM
	 PfGzegmSNihgQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/17] ksmbd: don't update ->op_state as OPLOCK_STATE_NONE on error
Date: Mon,  4 Dec 2023 15:34:48 -0500
Message-ID: <20231204203514.2093855-3-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231204203514.2093855-1-sashal@kernel.org>
References: <20231204203514.2093855-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.65
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cd80ce7e68f1624ac29cd0a6b057789d1236641e ]

ksmbd set ->op_state as OPLOCK_STATE_NONE on lease break ack error.
op_state of lease should not be updated because client can send lease
break ack again. This patch fix smb2.lease.breaking2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 683152007566c..603d9170d28a7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8294,7 +8294,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	return;
 
 err_out:
-	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
-- 
2.42.0

