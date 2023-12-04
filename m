Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59A35EE8;
	Mon,  4 Dec 2023 20:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Of1NZNJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335BCC433C7;
	Mon,  4 Dec 2023 20:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701722018;
	bh=bffrGFa8sgnt1DTbLwM5YY9x7dbSrSlgtHaSRIwECUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Of1NZNJSqpUYbt1eLx+oZSL/XWdAX9+/KtrLIEeJs4WfUA81/9RQW7/LVmVAyz69X
	 Dq2OzukGsx2BDYsswaiH9WTMbdzvgQ0+6zLG0+uXK2GdN1VZVN0VSH5HinmZevezsk
	 seWTh5dsqh4Z8P09gLzKIojlUr9kjGTsCIvCkSDEpinrn7kMj0+X7a6ugpLpEfXAJn
	 Th64C4Lfn7tupMJMCN5c01NaYeozcSFFOTxovlZhPSy7a5tDA+PJQ/t6DHtRZhWYr8
	 FhXtD36/XHOcGQTMFAnpGKFUYEBhsBmlP7j8R19Q0Wm8yjClga/ryRrBiuBBwuxmz8
	 7duUD/qr8IX3A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 07/32] ksmbd: release interim response after sending status pending response
Date: Mon,  4 Dec 2023 15:32:27 -0500
Message-ID: <20231204203317.2092321-7-sashal@kernel.org>
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

[ Upstream commit 2a3f7857ec742e212d6cee7fbbf7b0e2ae7f5161 ]

Add missing release async id and delete interim response entry after
sending status pending response. This only cause when smb2 lease is enable.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 3 +++
 fs/smb/server/oplock.c     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 51def3ca74c01..42db5efa353f1 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -56,6 +56,9 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	kfree(work->tr_buf);
 	kvfree(work->request_buf);
 	kfree(work->iov);
+	if (!list_empty(&work->interim_entry))
+		list_del(&work->interim_entry);
+
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
 	kmem_cache_free(work_cache, work);
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 9bc0103720f57..50c68beb71d6c 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -833,7 +833,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 					     interim_entry);
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
-			list_del(&in_work->interim_entry);
+			list_del_init(&in_work->interim_entry);
+			release_async_work(in_work);
 		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
-- 
2.42.0

