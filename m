Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F8035893;
	Mon,  6 Apr 2026 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483218; cv=none; b=Psnaj/DXoVg5lT6j0EYPWKmw3z0iworPo9FREepkSo3suFWcup4sLzv4sOeTAE5w2Va9m+4Ypjcqmm1+C67e+z7E+MmtavcQBIKsM+UcfcYPtdaqO3eVc5BHVHRgJjAcQLv/nxBQA0sSv+iJYVJ0uFpJZ5cemH3RoSBj6uaxjyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483218; c=relaxed/simple;
	bh=3aTYSApV0Q+/AB73UF0VuMJRhyBvMMPWQbyZsbikUzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPpMDT/14L/vYNbYVqcVHngJClKZOCgd+CLm8AYLiLCBiGbfDsDmfSkMzZVhwUjelqbNC2AvNmkurXjF6o8Vn2qv/byz3uTb20LBvRtR1YvJbjTVZVQlhl+8JJeVwTpf1GXUztdpBI/efg8SHzke4k3oEJWquRsgfH4l7Sg6SD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRFdxqj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRFdxqj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F090C4CEF7;
	Mon,  6 Apr 2026 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775483217;
	bh=3aTYSApV0Q+/AB73UF0VuMJRhyBvMMPWQbyZsbikUzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRFdxqj1jsl4oMpIbGzwJXEa82SyXNtzPHLXhQ5ms9bE72fW66xJBYXcuHVqEUPN+
	 H7Rz0Oe9n7tBigLBWUNykYHVN1V3NkflHPGP5ofSEsBWNV8NLFMYDH7EzVMe9NBCBB
	 ugYjeaFcKS4MB9ovtvAOjlhLRuOl/dlO8keCptuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable <stable@kernel.org>
Subject: [PATCH 1/3] ksmbd: validate EaNameLength in smb2_get_ea()
Date: Mon,  6 Apr 2026 15:46:46 +0200
Message-ID: <2026040646-backlit-overlord-2d46@gregkh>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026040644-brussels-dab-6f99@gregkh>
References: <2026040644-brussels-dab-6f99@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1594; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=3aTYSApV0Q+/AB73UF0VuMJRhyBvMMPWQbyZsbikUzE=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmXd7odeK/KvMc7v+LY2r/NG3mu/U/xqtC9pVnwe+fMX ma5rvspHbEsDIJMDLJiiixftvEc3V9xSNHL0PY0zBxWJpAhDFycAjCR7j6GeTrf1oo8s76+37ns W7SFx1pX1qnGcxgWzNiblFL4eJVpjDxrbVaBjOS549GbAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

smb2_get_ea() reads ea_req->EaNameLength from the client request and
passes it directly to strncmp() as the comparison length without
verifying that the length of the name really is the size of the input
buffer recieved.

Fix this up by properly checking the size of the name based on the value
recieved and the overall size of the request, to prevent a later
strncmp() call to use the length as a "trusted" size of the buffer.
Without this check, uninitialized heap values might be slowly leaked to
the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8e4cfdc0ba02..6f658dc20758 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4716,6 +4716,11 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 		ea_req = (struct smb2_ea_info_req *)((char *)req +
 						     le16_to_cpu(req->InputBufferOffset));
+
+		if (le32_to_cpu(req->InputBufferLength) <
+		    offsetof(struct smb2_ea_info_req, name) +
+		    ea_req->EaNameLength)
+			return -EINVAL;
 	} else {
 		/* need to send all EAs, if no specific EA is requested*/
 		if (le32_to_cpu(req->Flags) & SL_RETURN_SINGLE_ENTRY)
-- 
2.53.0

