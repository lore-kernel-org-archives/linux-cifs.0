Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39FE34188;
	Mon,  4 Dec 2023 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZejgbE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755A3C433CA;
	Mon,  4 Dec 2023 20:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722021;
	bh=X1klMmWdf1dNqRM/ewLPdf27HcjpBybRBVQtAuh6UXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZejgbE4vcAkhEmZFqS5njVCbKsQMPqwGjtuzaBIWlI+aQg6Hs3oogpdJ49yvKPs/
	 lcRKUmSD3QVJX/SHedpUIPTGZ1/b3eijLdeIqda0ME2BAXS9bJHBKA3pU8jmCnPZ26
	 PRqUuJT4CIXY0tLUqsr2nstqC1iB7a2/IQQExhK/UADrPJIsbCpFnCBx8iLo99QapH
	 cGSLz50wViDcs8uSI040hs4oCd8c9mhDqVWFUSl6A2uSg/PGbfuup3LyvqtbiDVSTZ
	 ob+wHUQd+nY8SGtjgvYDgXFWlrzCFu+JR6RilhSEmdigu0mHntp64ctU4MoMw2aqWQ
	 ITGvYqQ0jO1+A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 09/32] ksmbd: don't update ->op_state as OPLOCK_STATE_NONE on error
Date: Mon,  4 Dec 2023 15:32:29 -0500
Message-ID: <20231204203317.2092321-9-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231204203317.2092321-1-sashal@kernel.org>
References: <20231204203317.2092321-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.4
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
index 7eaac1098f637..78517e3b53104 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8228,7 +8228,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		return;
 
 err_out:
-	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
-- 
2.42.0

