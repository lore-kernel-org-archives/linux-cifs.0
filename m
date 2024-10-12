Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BEA15575F;
	Sat, 12 Oct 2024 11:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728732439; cv=none; b=VCuoGtRE/SP5lQj2+2InrKFg+RUa5YzammmQKGg/qa94XGAPxXOYBtyoKv2bL2fCQzKNfrqsuDfcmRr56bno7vtywMqStFnVrgSw/FJX/3h+sw6F9/QyM1jHchWVDumtcYZkkWs/FuJdWOMbWtedGLZsawzRaNguhlgPdXR7GgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728732439; c=relaxed/simple;
	bh=v2wnjtboE4A5dStbXmvaNVO761Oyx566cwmAfXkbPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtO0wd97T+Sz24i3OICDCyFUyxk0F8K3Z/x8wlII99NqXNfQKLhoTxttxFrULh69qy7VLntIIvUpwGAdNgRAZ9JE4IFOEQY39XCJi/oT0OClKOYqoHVXpijsBBgpIoKd5MorkM2mf27J9RECVlJRflG8XjYz3yi3aVR+243NlPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWmGiMG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWmGiMG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B5FC4CECE;
	Sat, 12 Oct 2024 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728732439;
	bh=v2wnjtboE4A5dStbXmvaNVO761Oyx566cwmAfXkbPBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWmGiMG48m1/gk+1XPfL49nOn8tQtJBxT3mHt92rzpWsRN2cLxOF8KYmNPe4D5VOu
	 kItLzdjhaQ0yUlE9QEZE66Fijubl6vNqVCjL7JAHTWadwi2HbFeKHZqriCyT1Di13x
	 IXpsLnx2CwrJ3V0k22OYnOcY5rkXJzLjqIeugf3qn7A0hoMXWFmxnYeiHxun/H7W9G
	 NqcT4iflwT7bAuCMaVDo7lXJ8xt1ISWIDF0TU39KpUxYAfgQOOYi88KCwLFrdoNO79
	 6uB3r92niaZBAB2FDgNyWJK15YLaiHYjbd4HpZsGaBXlwIUg4yyeCqY3oQdYy5Bbsg
	 PfsTlYI+KYZkw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 02/20] ksmbd: override fsids for smb2_query_info()
Date: Sat, 12 Oct 2024 07:26:34 -0400
Message-ID: <20241012112715.1763241-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241012112715.1763241-1-sashal@kernel.org>
References: <20241012112715.1763241-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.56
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f6bd41280a44dcc2e0a25ed72617d25f586974a7 ]

Sangsoo reported that a DAC denial error occurred when accessing
files through the ksmbd thread. This patch override fsids for
smb2_query_info().

Reported-by: Sangsoo Lee <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 646c874d151a8..cfc5c6dd880f8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5596,6 +5596,11 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "GOT query info request\n");
 
+	if (ksmbd_override_fsids(work)) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5614,6 +5619,7 @@ int smb2_query_info(struct ksmbd_work *work)
 			    req->InfoType);
 		rc = -EOPNOTSUPP;
 	}
+	ksmbd_revert_fsids(work);
 
 	if (!rc) {
 		rsp->StructureSize = cpu_to_le16(9);
@@ -5623,6 +5629,7 @@ int smb2_query_info(struct ksmbd_work *work)
 					le32_to_cpu(rsp->OutputBufferLength));
 	}
 
+err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-- 
2.43.0

