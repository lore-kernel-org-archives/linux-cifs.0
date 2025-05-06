Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F8721ABAA;
	Tue,  6 May 2025 21:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567336; cv=none; b=bWMAurxJ/UBgN3N0BdW8/BbFc9PPp2nwIbfG8zlz+AV1dfVKxILBjsNuvyefHXJAa8jr+vSSnqMthNHGUox44as1cKe5xURcMv1fBw0MXK4jo3g/pFUwo+2inRJmymD2wdPhKihyOJ1tKXgztg3Gi3CCqMFpYj59iD4wJV4FE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567336; c=relaxed/simple;
	bh=caGUPhTkVK2ihWWMvpmtCHp0+HFfEETvT0uCnXSioJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ebaiUQXihNhaBWfE7snVC6WSxv5ZIg7gL7B8XW5hhrrVfPzctQs2oPWZUrraKl0ur4iiG5wMQBmeixBo61lbr1rleGvuwoCbM+XwacJPZt9vvef3mVWTOWhJm6P0k2GS4bqAvssruy5Xv2daD9iKDdvJkaoWGULwgUvYMMcTnKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5MH45IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5MH45IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE094C4CEF5;
	Tue,  6 May 2025 21:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567334;
	bh=caGUPhTkVK2ihWWMvpmtCHp0+HFfEETvT0uCnXSioJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5MH45IQBOkie9ydAaQIsUDhmvEQuuszCbt6FHhxPiyIn6cBfPlfblbgD6LxPelEj
	 jXQTvbGk7kyhXwXDIxE+PRXYqAE9wSoXyg+9U8VIL/0Oz8pNIoXCj0kDqBz6frAx5C
	 iwEpUN1pO03VIII54RFPMwTwuRv62CRQZLGsxU6RRQvADwltQq2HE0wrFTVKVe2uXE
	 hChUtgUzgbzoZBfAXoZUUgKQKk3O5vZWPosfpKz0bmPR5m1WMb2mwS6vLGFhgArMf4
	 Lbd4Atthu/nOCY6YhEFQLVAzQ05rUkZqo8/J5wKB3b/5/dJbUaBVyIFAl7+XU/f90O
	 arBdWsPIN1nBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Salah Triki <salah.triki@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 04/20] smb: server: smb2pdu: check return value of xa_store()
Date: Tue,  6 May 2025 17:35:07 -0400
Message-Id: <20250506213523.2982756-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit af5226abb40cae959f424f7ca614787a1c87ce48 ]

xa_store() may fail so check its return value and return error code if
error occurred.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 57839f9708bb6..372021b3f2632 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1445,7 +1445,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
-	struct channel *chann = NULL;
+	struct channel *chann = NULL, *old;
 	struct ksmbd_user *user;
 	u64 prev_id;
 	int sz, rc;
@@ -1557,7 +1557,12 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
-			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, KSMBD_DEFAULT_GFP);
+			old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
+					KSMBD_DEFAULT_GFP);
+			if (xa_is_err(old)) {
+				kfree(chann);
+				return xa_err(old);
+			}
 		}
 	}
 
-- 
2.39.5

