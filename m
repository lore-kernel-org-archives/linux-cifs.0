Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E790518BC08;
	Fri, 23 Aug 2024 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724421870; cv=none; b=pQzHGd33jGx4rdCq7blIh72lTQ3XJ0oYy7NbVrEPtyVjG6lRUVBg7afG/xjV31EnN4PP6Q+4/ikkDoZylEjYuILhqAqzYJAWVllKygHjjwi3GMOTcMzfbPuI1UzYbqkGIsDlVV+Mjt4JxDdVfIkGQ6BUn6zhk6+N1SzQtzJiDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724421870; c=relaxed/simple;
	bh=eIkWCsCR3NMdmMgKN/NA1unm/enojmFve45QFyCY8tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddpmDNF/dfMPJTOx1SaM05ZnQVecHuvx/tFqoS/BWVvt8LZEp0AVSZNU8l8Kh6Us4PVxoEc/yhKU8FODmvGbeCc74PjITmd3wF3PaIulJEC6kiBBO0XFlrmea2Z5Z5MLnm7dhdT4b3TIEvoBu0W7PGA3ss7KfRp0lrcyw9VsVrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vL8LnrPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vL8LnrPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9499EC32786;
	Fri, 23 Aug 2024 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724421869;
	bh=eIkWCsCR3NMdmMgKN/NA1unm/enojmFve45QFyCY8tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL8LnrPf9+yJKv0cUrZXECrcN119pR6T9J3zvPHLSXi2Fur508i/YXUgJw60AY5Op
	 MnL8QW/sKcq7qqpJLhoZV+U3M7DmUuwEg8dXMG5/M0EP/GCJO3IO5OsHHIdt2GLFIp
	 5YqNHnP/ab4jDNCKQnOqirg3geGFyHqqcpX18B660sO0Fo7kl6iS2bFOfvjEZrKjz6
	 y03OorWzdRDbLr+KdZCZ2u2t7YWwyBP08ZMQm7AJr/Zc0rtwYeFTVoxMo0ESxeL6tF
	 USPeS17pJsSPITyQMkTPvW/ql2a6DRKPdbUGmapx8zaLJdGut78RWq2Qp+DpfXbryH
	 XBb9o9qPKRi6Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/13] ksmbd: override fsids for smb2_query_info()
Date: Fri, 23 Aug 2024 10:03:51 -0400
Message-ID: <20240823140425.1975208-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823140425.1975208-1-sashal@kernel.org>
References: <20240823140425.1975208-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.106
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
index d97c7982bb3ee..d018148913615 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5321,6 +5321,11 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "GOT query info request\n");
 
+	if (ksmbd_override_fsids(work)) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5339,6 +5344,7 @@ int smb2_query_info(struct ksmbd_work *work)
 			    req->InfoType);
 		rc = -EOPNOTSUPP;
 	}
+	ksmbd_revert_fsids(work);
 
 	if (!rc) {
 		rsp->StructureSize = cpu_to_le16(9);
@@ -5348,6 +5354,7 @@ int smb2_query_info(struct ksmbd_work *work)
 					le32_to_cpu(rsp->OutputBufferLength));
 	}
 
+err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-- 
2.43.0

