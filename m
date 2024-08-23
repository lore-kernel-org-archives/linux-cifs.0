Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B7318952E;
	Fri, 23 Aug 2024 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724421793; cv=none; b=nbTUeXk57RcLKM76bJ16RgU46N0NDV+dr8KPrcSgPg/s6185JvI1I+tlEgYCxQ2GlymJ3+3fze3zA0mTdEgyyPoa0tsqVEIAfzhaQb9fJ0xcJRyOoWX1VXoLXfda8A5ipkF4UOtG4NkU4I7Kw2knCedFT8aSOol1Jy1tnFNBOr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724421793; c=relaxed/simple;
	bh=v2wnjtboE4A5dStbXmvaNVO761Oyx566cwmAfXkbPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAmDzbvlib4HkgJ1U9aFn8KmMCTkaZwpiXCcBhBzCITICFqD6loBivIm4MSgy2NW61xJP+SljNXbgKR/vKE40pZ/yVf2lGwRXtZEPXhRxPLAjADYAFhzNkLVcsxYI3GGwadenf8vKVm+romyAHuD3dM9WwweUm6ECjq3kn9+uo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q43XdT8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q43XdT8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2CEC4AF09;
	Fri, 23 Aug 2024 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724421792;
	bh=v2wnjtboE4A5dStbXmvaNVO761Oyx566cwmAfXkbPBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q43XdT8tq3CTQLAJeGZlu+6twpQMW97hSKrQ6FO4trUbyhxCjPCcipljB2F7Jfbrk
	 YXEiwiDMRcbGzOMLQJuBw7+WlXSdkpI6rIEClSzKE7bMbXvMrypLiqTmQijlljCqs0
	 seL1YsPkKfRFZGccK6gRlzCpGkkwyitM7vdMmb90cT7ycwX8g7fHI+J5VlSm/eKg3T
	 RZ+1RbMhWJmdt/h8v0gT3xZcZClV3kvTi6qJtN2iRthaXps+fW6kGT4O5JmlFuxbSi
	 xgV4hcBvvnpvEXQKdAk4tQuC44BCnbJKv4iWNFuUKVavEUM2A+XU7nMIIW86Q5tfp+
	 gyl3EHPJQJUZQ==
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
Date: Fri, 23 Aug 2024 10:02:16 -0400
Message-ID: <20240823140309.1974696-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823140309.1974696-1-sashal@kernel.org>
References: <20240823140309.1974696-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.47
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

