Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360802FE07B;
	Sat,  6 Dec 2025 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029780; cv=none; b=RFAIpWM7AK0UZgoCZEckysNJ2qoUTjT4WfHOW6Q45D9gHJx+x/wQmXsrgJAG2Te8/FM6q9kVQQR4K59ys176FHv466F5zvmb7LqgoqUkyVvwfcqyUkCTmmvQu0kUtjDq9GGKpktJrPV2K7f9Poii936pTsLZaPZM9+XUIewWBHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029780; c=relaxed/simple;
	bh=NzjKNhNrGPhJ1zkrIoEVkRBmKWVtXVkk4l/qmfRLAmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+R8u4QjqNJDAfexOhHTEUmK9fNDOL0ksVOiH+L9STNH3bdASwTBUmkK2dQvPiyVhVgSUycLuNlJ/6LQl0pGQgFpeQ/jTvOKZyx/ISpg7N5dEz8wYk7QRwEmXIMNnRSup3ktv8SDo1uA1eK5iIvIFAFz9R81lSgh557thnTjacU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u88EYyWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u88EYyWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8394EC4CEF5;
	Sat,  6 Dec 2025 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029779;
	bh=NzjKNhNrGPhJ1zkrIoEVkRBmKWVtXVkk4l/qmfRLAmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u88EYyWtCsIPWg47nYRY82b4ca0BIkPVYU5s6oYkahK5CdsAdc3aj5NCauiBXHNKA
	 eqLR7ZuweSF8ofWC0StMTpXXuKkGvgLdtxqQRG7ItFVUdXF5oqH2Gyl5uqiEr7zNYk
	 BG4gHuZi6Abq7lwPYjtYP9gZm8NEfk30B4wfexOTQ85nY/ri4zgP9ATiBX8JeNPFik
	 VGHARiR+PvK1J/6hvY5RjhlB7ZVKxP93b+qveRZIJNdJVhaBpnBY1aGR7nqqQ36Art
	 X3n5fgDaNh3xY1ozHck+Vaq8wzk7RwOg3+yZ44Q6pJPg1qMptXIlZTnE8xudorXPH6
	 deO/LOihDaBVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] smb/server: fix return value of smb2_ioctl()
Date: Sat,  6 Dec 2025 09:02:08 -0500
Message-ID: <20251206140252.645973-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 269df046c1e15ab34fa26fd90db9381f022a0963 ]

__process_request() will not print error messages if smb2_ioctl()
always returns 0.

Fix this by returning the correct value at the end of function.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 fs/smb/server/smb2pdu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f901ae18e68ad..a2830ec67e782 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8164,7 +8164,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		id = req->VolatileFileId;
 
 	if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
-		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
@@ -8184,8 +8184,9 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_DFS_GET_REFERRALS:
 	case FSCTL_DFS_GET_REFERRALS_EX:
 		/* Not support DFS yet */
+		ret = -EOPNOTSUPP;
 		rsp->hdr.Status = STATUS_FS_DRIVER_REQUIRED;
-		goto out;
+		goto out2;
 	case FSCTL_CREATE_OR_GET_OBJECT_ID:
 	{
 		struct file_object_buf_type1_ioctl_rsp *obj_buf;
@@ -8475,8 +8476,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
 	else if (ret < 0 || rsp->hdr.Status == 0)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+
+out2:
 	smb2_set_err_rsp(work);
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.51.0

