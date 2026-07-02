Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67992BEC2B;
	Thu,  2 Jul 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007697; cv=none; b=OCMeT6vKupjMDU1Tm2figIqmm1ZmCyhZpVO/WMQOzPinf4OWpZznMePzW0o6vks3uvehCdg1oyR3ZYr03EVIzD3rsIL1qwNDaETp960paCkz6MLSv7s3lwkyFOj9SHcGOaBW0akX58HK/0XNyJRExIdy7bXDOPH9tiQcFRDgqoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007697; c=relaxed/simple;
	bh=cmwFWdIMyxI6lDEfiRQcFFlaEYgTBil4SusP2BvEsOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZ2LjxJ+D1loNA+i4ltZpFxaMl8Q75978YJsHA76Rg6xMEvO1xYmD4SAQ5vZfumdRAVfWWTtS/ZCsFDtKog8neBBRf4T8DO2XobCmfVTy6DGwQ7DpfACUxEK9kTbawHph1pvawZ8Y2urOx7jSPJ6gfccTtU8epQNsXk0psyi1Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=A2+Asl2Y; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="A2+Asl2Y"
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id DFB65842E5;
	Thu, 02 Jul 2026 17:54:52 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id wDVd5znCqEJH; Thu,  2 Jul 2026 17:54:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1783007692; bh=cmwFWdIMyxI6lDEfiRQcFFlaEYgTBil4SusP2BvEsOI=;
	h=From:To:Cc:Subject:Date;
	b=A2+Asl2YrSEPdiSk+v00g9FdmOrlQl3WuCk7MLIgxMeNaZRUpK1xA4zs81V6n8MtL
	 1zYDZt+Oril2gKWx8ihyHrhSFaGaOGaiB2QDJLHz7CoNQPb1Ez9htehdj6kTXVMWeS
	 gOrN00SmPSC5X/42SoBhsNqVdzcXQ/BPZE7YgCltZ1qOnbumV3z6OGB06gIJwAzmcL
	 m7rphyDIVjWS0NIzoiOkVjyUSskPzy/bF/Km6J0chbNX+xH2oovBXMa5ItE2DjR6l1
	 yQzRWGU7QiYZnn6uksXgonsmuEfehDGL6JdIP6MmVBxU5HVebYrZYRkZyCZeGg4lnJ
	 QY46oLsFzrmTg==
From: James Montgomery <james_montgomery@disroot.org>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-kernel@vger.kernel.org,
	James Montgomery <james_montgomery@disroot.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: defer destroy_previous_session() until after NTLM authentication
Date: Thu,  2 Jul 2026 11:54:49 -0400
Message-ID: <20260702155449.3639773-1-james_montgomery@disroot.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ntlm_authenticate(), destroy_previous_session() is called using a
user pointer resolved from the client-supplied NTLM blob username field
before the NTLMv2 response is validated. An authenticated attacker can
set the NTLM blob username to match a victim account and set
PreviousSessionId to the victim's session ID; destroy_previous_session()
destroys the victim's session while ksmbd_decode_ntlmssp_auth_blob()
subsequently rejects the request with -EPERM.

Move destroy_previous_session() to after ksmbd_decode_ntlmssp_auth_blob()
returns success and use sess->user rather than the pre-authentication
lookup result. This matches the ordering already used by
krb5_authenticate(), where destroy_previous_session() is called only
after ksmbd_krb5_authenticate() returns success.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: James Montgomery <james_montgomery@disroot.org>
---
Note: portions of this patch were suggested by an AI coding assistant
(Claude Code / Anthropic). The ordering issue was identified via static
analysis of ntlm_authenticate() and validated empirically using a PoC
against ksmbd running Linux 7.1.0 in QEMU. The fix was verified by:
checkpatch.pl --strict (0 errors, 0 warnings), sparse (HEAD, 0 warnings),
and build test (make fs/smb/server/, clean). The assistant was prompted
to identify and fix the destroy_previous_session() ordering issue relative
to NTLMv2 validation, matching the pattern already used in krb5_authenticate().

 fs/smb/server/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5859fa68bb84..1ce13b23cf6c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1670,10 +1670,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		return -EPERM;
 	}
 
-	/* Check for previous session */
 	prev_id = le64_to_cpu(req->PreviousSessionId);
-	if (prev_id && prev_id != sess->id)
-		destroy_previous_session(conn, user, prev_id);
 
 	if (sess->state == SMB2_SESSION_VALID) {
 		/*
@@ -1712,6 +1709,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		}
 	}
 
+	if (prev_id && prev_id != sess->id)
+		destroy_previous_session(conn, sess->user, prev_id);
+
 	/*
 	 * If session state is SMB2_SESSION_VALID, We can assume
 	 * that it is reauthentication. And the user/password
-- 
2.47.3

