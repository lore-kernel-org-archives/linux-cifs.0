Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1141838F9F;
	Tue,  9 Jan 2024 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Rl1Ovwlq"
Received: from localhost.ispras.ru (unknown [10.10.165.2])
	by mail.ispras.ru (Postfix) with ESMTPSA id 5CB2240737DD;
	Tue,  9 Jan 2024 13:37:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 5CB2240737DD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1704807436;
	bh=TdzphiKewiAEGb5mVeNRXY8JwRsEqxcS+5rYPinKWAY=;
	h=From:To:Cc:Subject:Date:From;
	b=Rl1OvwlqxuwvpisiP4VBWnGLxvuCidOwAPlrS6WQp+tgypcJOmosmZNGPAyUSSXKn
	 l01p+tt421gxRXq14syQ/JhWyMnZkzlmbwsDeenhMvaKkPVNsoclgqx30ksVstFfV2
	 kFLKJvkOV5udxD91wDb77P3lvTpiIURTuGsdMbtQ=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: [PATCH] ksmbd: free ppace array on error in parse_dacl
Date: Tue,  9 Jan 2024 16:34:27 +0300
Message-ID: <20240109133429.31752-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Free the ppace array if one of the init_acl_state() calls inside
parse_dacl() fails. At the moment the function may fail only due to the
memory allocation errors so it's highly unlikely in this case but
nevertheless a fix is needed.

Found by Linux Verification Center (linuxtesting.org).

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/smb/server/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 1164365533f0..e6d0537cab49 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -406,11 +406,14 @@ static void parse_dacl(struct mnt_idmap *idmap,
 		return;
 
 	ret = init_acl_state(&acl_state, num_aces);
-	if (ret)
+	if (ret) {
+		kfree(ppace);
 		return;
+	}
 	ret = init_acl_state(&default_acl_state, num_aces);
 	if (ret) {
 		free_acl_state(&acl_state);
+		kfree(ppace);
 		return;
 	}
 
-- 
2.43.0

