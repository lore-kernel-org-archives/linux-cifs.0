Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B22926A0C6;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=oGzrqqDX3eY1lcinddvHL5imGIY9BhUQajfbWnQxO53URBQByPR5RDkxbCVGAQA56ef3geCnQrhbHgZoNQP03iCeZL+3eG7Dbrzhz/Fi2WRY3HidLtyVVbipfZCVECnGtT+mAhRuELjebq4bfmrhxQ/g5wXLRJ1u9wBFYna4dPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=L+Fz/PQmKe5w+IjKQjmONfWxzNRhm8SNMsCPELs3dkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnZ2xTv4zXEwxm+F6ET+wOGhKqT43RIBnI+IdvZxgN6ejFCFDNByzlkKe1qG39RGn2y3kd5BJXYzVUI8YjO49Qc7fuUeMKngytuMM4uM0YMFzJmhGVQlOy9JFnsDHTMK0wUxuWzDpyQMD4Gt96vZ7wOaq8T9KPP2LYjJjHMIy94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtcIanKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtcIanKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D795C4CEFA;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=L+Fz/PQmKe5w+IjKQjmONfWxzNRhm8SNMsCPELs3dkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtcIanKNV2Tkhpo2R9yNTlXb90wPMtXajJjYFUG74uhB+I6k/sr0tFKfU+CTSlUkK
	 p2iHq5jw39GqUpKUoNqEtZw78+6RjaA8lujuQk3o5G70Q6IyaNsBHu9w1KiETxhwof
	 wGyRpQB6HBbwh3Osxa8ckkcuj2VswcK0ZFDTLwvRCgAIToLRXf0Vwkpwf8Ci1fcnIP
	 flapPzddpa8zm+luNfx/oT8Lnx4/9HObyAcUh7pQjYxwvFfAJwRtfupxmRmj/OIdtm
	 EyVtkLK4leerpyWqI4jBrb3sWq/JYjl0rpsGfKWHoL0kSUs+M4VAojogwcvdp1rIu+
	 VxMJO0g3cMjzg==
Received: by pali.im (Postfix)
	id E8A3112DE; Sun, 31 Aug 2025 14:36:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 30/35] cifs: Simplify SMB2_OP_DELETE API usage
Date: Sun, 31 Aug 2025 14:35:57 +0200
Message-Id: <20250831123602.14037-31-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently the caller of SMB2_OP_DELETE operation has to specify also the
CREATE_DELETE_ON_CLOSE flag. Simplify API usage and let the callee
smb2_compound_op() to automatically set this flag when issuing the
SMB2_OP_DELETE operation.

No functional change.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 59d73e01ccd2..a3b1ed53a860 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -255,6 +255,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	vars->oparms = *oparms;
 	vars->oparms.fid = &fid;
 
+	for (i = 0; i < num_cmds; i++) {
+		if (cmds[i] == SMB2_OP_DELETE) {
+			vars->oparms.create_options |= CREATE_DELETE_ON_CLOSE;
+			break;
+		}
+	}
+
 	rqst[num_rqst].rq_iov = &vars->open_iov[0];
 	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;
 	rc = SMB2_open_init(tcon, server,
@@ -1348,7 +1355,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name,
 			     DELETE, FILE_OPEN,
-			     CREATE_DELETE_ON_CLOSE | CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+			     CREATE_NOT_DIR | OPEN_REPARSE_POINT,
 			     ACL_NO_MODE);
 	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
 				  NULL, &(int){SMB2_OP_DELETE}, 1,
-- 
2.20.1

