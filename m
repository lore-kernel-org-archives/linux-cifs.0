Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1729C222580;
	Tue,  6 May 2025 21:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567381; cv=none; b=Z6ipgdyCZVvmk/xjfWgBqrYdKkmmJGiAc/WsllCcmWWuKhWLSv4MLQ9aILMny4VDo1EYEkWvlibHO/jV8nBMzusxZZPURiUhFC4z2KjL8B4LcefMG9SFdaBxQ0OUJl1u8J/WBtaxrYfiVHAQRWMa2x+pBOyIH+d6afjugOVQyOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567381; c=relaxed/simple;
	bh=n75AxjRaIh79fMF9r3kZtrqsvJ5Y/8iHAjDLx/mYGG4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=li7iHSFpAY/fYXqZN0lWQJvLeO++xUYb763DKMlWQnjZS5NOUD8hFKuXh73xOsaJy5Nn1xC2EV4F8nfxnqGptWuWFJ2smX5eYMno3iBGM5itEIPWOPYfwlOkq4tbHmVszH6NtEcFFtPd7qesCQzIqI2O3xVZspvnymbE8yru4sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DemWjyKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DemWjyKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92559C4CEE4;
	Tue,  6 May 2025 21:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567380;
	bh=n75AxjRaIh79fMF9r3kZtrqsvJ5Y/8iHAjDLx/mYGG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DemWjyKH8FGnBNtb8lFvZ7V+lCMS2M4XmADB3V18DFBxnUoo8P98WjHBc49Fe3zY0
	 CUeB3jvpRYLDl3WSjux4HKCggherHZVbTatatrhHdy32uC3cbz9SjtFnE3hmoNdgz2
	 83GqnoEXCBK1ImXTWp+Wvb+bbTZ9vs9n3J8pEAnpBRrfH+a+3sxeH4LE2xk9mwEC1v
	 saZpNLfYbyTkcQDF2JFRyApR2nvb68JcH0RDDGsyTO8X/cUTSQjJusb8lXs+ZDp2SF
	 aMhekQz1mZCD8A5cugFD7Um8pLTDcLeXu3tJSPNL23uk6G4RkEk9+HQwcECAFzcIDo
	 /xP5dYX9kEG6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Salah Triki <salah.triki@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 04/18] smb: server: smb2pdu: check return value of xa_store()
Date: Tue,  6 May 2025 17:35:56 -0400
Message-Id: <20250506213610.2983098-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit af5226abb40cae959f424f7ca614787a1c87ce48 ]

xa_store() may fail so check its return value and return error code if
error occurred.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6b9286c963439..f52afb01175dd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1443,7 +1443,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
-	struct channel *chann = NULL;
+	struct channel *chann = NULL, *old;
 	struct ksmbd_user *user;
 	u64 prev_id;
 	int sz, rc;
@@ -1555,7 +1555,12 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
-			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, KSMBD_DEFAULT_GFP);
+			old = xa_store(&sess->ksmbd_chann_list, (long)conn, chann,
+					KSMBD_DEFAULT_GFP);
+			if (xa_is_err(old)) {
+				kfree(chann);
+				return xa_err(old);
+			}
 		}
 	}
 
-- 
2.39.5

