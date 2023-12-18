Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC995BF9A;
	Mon, 18 Dec 2023 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9GQ1qKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E06C433CD;
	Mon, 18 Dec 2023 12:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702903529;
	bh=6eKzjKDBC78dUmxhoC0jdQqyt2Xp6+zTCPS2GcKBzdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9GQ1qKFqWT/HA5YTStZ3NKMn24bggIkYO+rxq0fszbGsHmL/7cTo6Ps0lbYGHXaT
	 Idj5EcnobnioOGh6w0Ru1CQPXm3B2OuG4XZExS4xw2kpzoxD1HZqcI+gl8J6Fk4ecM
	 J4vTNiZYyqIrZfxNw4Z4veZ4GobTvkMJGmxksqgiaDD65RxaKRIZaa9Er3o3rHcWSi
	 hIA4GGOd0Hfle5LzXc9kXkIG3q0tgloa+jd+7EOPC0V0h6J2orBgTgKYpRE/1apiIb
	 Ru91yN8XoSkA2JNSEFVwcp0P8gZ95J2bN+NfkgsWyVXQ4Rl5/qWQewd55F7fZRNLrx
	 yFOrM/LpVprMg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/15] ksmbd: avoid duplicate opinfo_put() call on error of smb21_lease_break_ack()
Date: Mon, 18 Dec 2023 07:44:55 -0500
Message-ID: <20231218124513.1380056-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218124513.1380056-1-sashal@kernel.org>
References: <20231218124513.1380056-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.68
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 658609d9a618d8881bf549b5893c0ba8fcff4526 ]

opinfo_put() could be called twice on error of smb21_lease_break_ack().
It will cause UAF issue if opinfo is referenced on other places.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 683152007566c..f81e19e92c207 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8272,6 +8272,11 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 			    le32_to_cpu(req->LeaseState));
 	}
 
+	if (ret < 0) {
+		rsp->hdr.Status = err;
+		goto err_out;
+	}
+
 	lease_state = lease->state;
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
@@ -8279,11 +8284,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
 
-	if (ret < 0) {
-		rsp->hdr.Status = err;
-		goto err_out;
-	}
-
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
 	rsp->Flags = 0;
-- 
2.43.0

