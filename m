Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF3F2FFF89;
	Sun, 12 Jul 2026 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783887698; cv=none; b=jknRAqSnpY5N8wbt/Phzpay6wAOZWPfptDAD/IEOZklQ/wIIJoHvt8Tf9fAWIvHUMeM7lFDtS6KbTlKmzqXo+Qgty5PYFR3jB7EGREmakXwL2X6fyf5bPIjKOKeK/22ySMEQpQJFfwj98DzIiSEjbP5RZ7qq3rlKcxOP76Mp0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783887698; c=relaxed/simple;
	bh=zyO+TlXxuR1qmU7MlCTCgrfZLQJx4FkFKO/IO4vdkxQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JvhZFpQaU405e+rvorBwaZXrS2i6vU7CcK7NkS6vUCkUD67gajYwKKY1iyrQ37ItAcUlRPFonzFRnuDrE7UMnCuIKa+CY2BcDvoMvk2yZiaJh1DNw8JfqJwrNjuIsrsGV+ocqqUq6fWyn1S8tfbZdNQ5Hciq87CH1CU8V+jaTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njqZuvkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njqZuvkb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D177C2BCC7;
	Sun, 12 Jul 2026 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783887697;
	bh=zyO+TlXxuR1qmU7MlCTCgrfZLQJx4FkFKO/IO4vdkxQ=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=njqZuvkbpU+eM8w5KtSG26BQTcckBZTFvE8UHb8fTQKqYRHahqu/bHtuh+IRGfuuK
	 5kjD58l9YqC16wVc2a5IDyR/LbDZ+TSZzi2Ze0bAPniPCrJQzzP8QnNB2dC1dt4yNO
	 NbNsMxyMi4O2FLy0kvkCy5DY9mMS3Q6c+z1VJdDMjQMbJPR2jbQ8A20symlgtqH4/k
	 PKu/xyo3vTxr9Au/A5g0j3DFEIStFpMaU1Nz0qbJ/NRoIGb6Q4mN8B2oeOLNrrTl1C
	 LDwOru4Y+cDAc4rDyfm7CLmjBlqvzmfthHO013gu3SGkKH2+6w+t5sZFDc422fTV71
	 lU84WyfvHMnow==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B0FC43458;
	Sun, 12 Jul 2026 20:21:37 +0000 (UTC)
From: Junye Ji via B4 Relay <devnull+jijunye1.outlook.com@kernel.org>
Date: Sun, 12 Jul 2026 13:21:34 -0700
Subject: [PATCH] ksmbd: fix channel_key buffer overflow in multichannel
 binding
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-ksmbd-channel-key-size-v1-1-84818ee5cdc6@outlook.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MwQqDMBAFf0X27EISQaG/Ih5i8mwX2yhZEFvx3
 409DsPMQYosUHpUB2VsorKkArauKLx8eoIlFiZnXGs663jWzxj5dglvnvFllR+48T7YEW1noqc
 SrxmT7P9xP5znBfS6lIloAAAA
X-Change-ID: 20260712-ksmbd-channel-key-size-3aac1be670da
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Junye Ji <jijunye1@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783887697; l=2135;
 i=jijunye1@outlook.com; s=junyeji-20260712; h=from:subject:message-id;
 bh=EOdOm1GfTA2/I0Ll/QriqK8l0t3oPN69zpkBPVqhF8I=;
 b=wtFz03WG85r4FIne2u8SIsrrW43TFhTL9y+0rfOeujS/+Ygn6w1NGzglIuKdP0S/QDydL2ZnA
 e1BmL2L3ou1C82isleatKwsC98nn7sfNgC+SbaNkE1SE8R4ZSFiLeZ2
X-Developer-Key: i=jijunye1@outlook.com; a=ed25519;
 pk=aKIN8hT1V9oSVC83K2q1NNzawUnDaybDxbYJltmwvGE=
X-Endpoint-Received: by B4 Relay for jijunye1@outlook.com/junyeji-20260712
 with auth_id=865
X-Original-From: Junye Ji <jijunye1@outlook.com>
Reply-To: jijunye1@outlook.com

From: Junye Ji <jijunye1@outlook.com>

ksmbd_decode_ntlmssp_auth_blob() and ksmbd_krb5_authenticate() can write
keys up to CIFS_KEY_SIZE. During SMB3 multichannel binding, their
destination is the 16-byte channel_key stack buffer, so longer keys
overwrite the stack.

Size the temporary buffers for the accepted maximum.
register_session_channel() still stores a 16-byte channel key.

I reproduced the stack write with 17- and 40-byte NTLM keys and a
32-byte Kerberos subkey. On the fixed KASAN kernel, 16-, 17-, and 40-byte
NTLM keys and 16- and 32-byte Kerberos subkeys completed 10 bindings each
without a report. The existing length check still rejected a 41-byte
NTLM key.

Fixes: 4b706360ffb7 ("ksmbd: fix multichannel binding and enforce channel limit")
Assisted-by: Codex-Security:unspecified
Signed-off-by: Junye Ji <jijunye1@outlook.com>
---
I can send the reproducers and full KASAN logs privately if needed.
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b73167785e87..d8a7db655043 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1689,7 +1689,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_user *user;
-	char channel_key[SMB2_NTLMV2_SESSKEY_SIZE] = {};
+	char channel_key[CIFS_KEY_SIZE] = {};
 	char *auth_key = conn->binding ? channel_key : sess->sess_key;
 	u64 prev_id;
 	bool binding = conn->binding;
@@ -1826,7 +1826,7 @@ static int krb5_authenticate(struct ksmbd_work *work,
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	char *in_blob, *out_blob;
-	char channel_key[SMB2_NTLMV2_SESSKEY_SIZE] = {};
+	char channel_key[CIFS_KEY_SIZE] = {};
 	char *auth_key = conn->binding ? channel_key : sess->sess_key;
 	u64 prev_sess_id;
 	bool binding = conn->binding;

---
base-commit: 44696aa3a489d2baf58efa61b37833f100072bee
change-id: 20260712-ksmbd-channel-key-size-3aac1be670da

Best regards,
-- 
Junye Ji <jijunye1@outlook.com>


