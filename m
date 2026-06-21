Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029BF72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046161; cv=none; b=cU+oT1zkxTwlSBzMaOW89IE6tBybqyvUMb9yH/KxM40nYhXsAhL4+VKJpkX64vuWOPpM0M/csgrQUuWSNrCZmGFlJ46T1IDtTkw3j99APE3ITNEEguXGh+gM5mQqqLZ5TzJzMmDHOiYDPqgLFJ/oAR5U3cacV3tVdr65sBlWj/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046161; c=relaxed/simple;
	bh=tIK666SCBO24RO9q4D4RpyrNvIy92fuoIK75Qg5ayHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LLfUTf/l7QR8RYs9yefBLLZBY/zkX91wxqe3/XLIL9aoFRg+Jzp0v/Y2LD04Kq/pzGGVlbSOHDmJy4nY5hGHJZcFnv3g3nBU97QFedTfrmy1P4gL4eyDyJTRmyDw9rkJ3X7u+fC+1qbDI2C0f9DNOaaXUcRQlmv8nI6/u1fWfN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UObBxg6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UObBxg6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BE71F00A3A;
	Sun, 21 Jun 2026 12:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046160;
	bh=405nSUOnBdz31ZAjEuXjIS9D2ffdkuixsINEubhd/3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UObBxg6FkaWxRFadxkbxc2Cg8Sk12oOvnG7QHE8xUteie+rZFXQ69lgjv3J0mkc9A
	 o9a6EylKkc4/fcX2aEOmLZdRzWNfwz1PukiDWjI3+7cPkADRhx0Kqm/P3oJLU05UDP
	 c8+lpzHHoes3JuAKh0/p6yCEKotEr7r8UaieP74g8lD0xFqyhHRkvY9XaNfaM74nT1
	 ax5bXcI4mRpMDHXPXKdgylp8vkexYEqa5hQdx9Y6LkfCfMGPvDh+itgj37S4hEGfbU
	 iT7kHxUmmE0Lg1KPwqvfK4wGjPuj7FGvUsNHgaCF056NpBVS+yCrvK+MMzWXCch4Pu
	 77Zs1ZSnKjpkg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 15/29] ksmbd: reject empty-attribute synchronize-only create
Date: Sun, 21 Jun 2026 21:48:30 +0900
Message-Id: <20260621124844.6235-15-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2.create.gentest checks each desired access bit independently and
expects an open that requests only SYNCHRONIZE with CreateDisposition
OPEN_IF and FileAttributes 0 to fail with STATUS_ACCESS_DENIED.

Rejecting all SYNCHRONIZE-only opens is too broad: SYNCHRONIZE does not
imply read, write, or delete data access, and
smb2.sharemode.sharemode-access expects a SYNCHRONIZE-only open to succeed
when it does not conflict with the existing share mode.

Limit the rejection to the gentest create shape: SYNCHRONIZE-only access,
OPEN_IF disposition, and no file attributes. Other synchronize-only opens
are handled by the normal permission and share-mode checks.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a3ae37e8b24d..9a1308f32f45 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3332,6 +3332,13 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out2;
 	}
 
+	if (req->DesiredAccess == FILE_SYNCHRONIZE_LE &&
+	    req->CreateDisposition == FILE_OPEN_IF_LE &&
+	    !req->FileAttributes) {
+		rc = -EACCES;
+		goto err_out2;
+	}
+
 	if (req->FileAttributes && !(req->FileAttributes & FILE_ATTRIBUTE_MASK_LE)) {
 		pr_err("Invalid file attribute : 0x%x\n",
 		       le32_to_cpu(req->FileAttributes));
-- 
2.25.1

