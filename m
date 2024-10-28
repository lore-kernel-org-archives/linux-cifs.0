Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2D1DE2DA;
	Mon, 28 Oct 2024 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730113466; cv=none; b=Bx/lN9pjrFhBUBoH/2prM00Jbj1EHR4TtoSxJktH1xKYw2svK+RwhAuoCeN9n5EAczduwj7eY1rJmq3Zm7yhQJlBPKL6Y61N2XScrYtcLtCMpbjhltiQvpWwSEgyPK8mx+MT9FavAFCv/vKrjSnz9z1EDMUlh098Tssjw9HZ6Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730113466; c=relaxed/simple;
	bh=WHtLiJHjirtfbEslTsmtV/oBQXUhlLaEDksL+A80+5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amL0U7G3NK4f3zSP8p8bMtpHBj/Czim6SuVDiqwhNF913ZqLX+gub6nZqb72lZ9zM07DVYG+WNNxzkbJx775yiUB5YbwSH0GJ/espTy4xTe7YNRv1JTUXdP99HglURNADISq2iR36CqVjxmnxpYDyjTTXHDJGV7O+HqCG3Scdas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEol7T5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEol7T5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8653C4CEE3;
	Mon, 28 Oct 2024 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730113466;
	bh=WHtLiJHjirtfbEslTsmtV/oBQXUhlLaEDksL+A80+5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEol7T5U/A6egd5SelcyuFSXmvhJWM0P42bTsgE7L7QbJ6YQ6kv09Pto0PIpsHdiR
	 OEihNsgmdvN42ZoZE6BMlK8za7M/S6W8w1jerCk0lUOxYn1v9G+1fctRJvwQ8dBnsb
	 EBc6AGYms2cKhz4ru/DcvdP29kHJVWKeyuimOhv+k4f8iAEj/Z6plm+11OPXx2jkrz
	 sfAu1ouaOi+x4Qebr+U4c7OoQ0WUYWCNHC/3OXhXJ6heyQxLplJ62WLjaAk/Vq6ifa
	 QelNEGpaCqY4iyEFqmUUlEO0/R/O7Q9xzsKmG0xgw+ElPOUyyJG2gfSSmbHmllaMr+
	 T4UW2MKE/Q4IQ==
Received: by pali.im (Postfix)
	id 91BC0BB0; Mon, 28 Oct 2024 12:04:18 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] cifs: Add support for SMB1 Session Setup NTLMSSP Request in non-UNICODE mode
Date: Mon, 28 Oct 2024 12:03:38 +0100
Message-Id: <20241028110340.29911-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028110340.29911-1-pali@kernel.org>
References: <20241028110340.29911-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB1 Session Setup NTLMSSP Request in non-UNICODE mode is similar to
UNICODE mode, just strings are encoded in ASCII and not in UTF-16.

With this change it is possible to setup SMB1 session with NTLM
authentication in non-UNICODE mode with Windows SMB server.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/sess.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 7226f2563b99..29a1756ba0f7 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1704,22 +1704,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
 	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
 
 	capabilities = cifs_ssetup_hdr(ses, server, pSMB);
-	if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-		cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
-		return -ENOSYS;
-	}
-
 	pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	capabilities |= CAP_EXTENDED_SECURITY;
 	pSMB->req.Capabilities |= cpu_to_le32(capabilities);
 
 	bcc_ptr = sess_data->iov[2].iov_base;
-	/* unicode strings must be word aligned */
-	if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
-		*bcc_ptr = 0;
-		bcc_ptr++;
+
+	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
+		/* unicode strings must be word aligned */
+		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
+			*bcc_ptr = 0;
+			bcc_ptr++;
+		}
+		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
+	} else {
+		ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 	}
-	unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 
 	sess_data->iov[2].iov_len = (long) bcc_ptr -
 					(long) sess_data->iov[2].iov_base;
-- 
2.20.1

