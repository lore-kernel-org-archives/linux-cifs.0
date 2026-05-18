Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC983644C7;
	Mon, 18 May 2026 08:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779092178; cv=none; b=VhBt1RzJ5Ujty9vnk9roYybwL6M8TYJ/+4aYyGifdkH2OSPlutwVFb3DGjmtHDfZbfsvjXzLSjFNJ/9rBUjcrrQWyNE9yoCbXvpTti+3HSI26YD7dEnCpJYExrNgk5xEZ0X4ij5i1HpNcJvNGM0vekl/xe7WSH06qdQxbB9NSrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779092178; c=relaxed/simple;
	bh=AjykVUVum+L/g4SJHBUELsKjZvyuDorNEoQ1miSVWN0=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=ErSGSZUS+jR/6CfFKgp4c6Ap/TIJqPEJ8OM5AdsQoM/BjDaeXzYpAWaecq+4Dl9/FaEw1eb5hw9rcpiXHja33FfhW8hL78VfJv00AvoSinnqP7TpXhIQQVS3n8X4yr/4cc3ErDum/rhEfW5p8imQF6tXrSbEEPztoqp5eE7NZhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=VNdawQuM; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="VNdawQuM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1779092172;
	bh=Nax7KtpG10DrfUGIZPwYV/97qy2GgKkjcNWpTwIURro=;
	h=From:To:Cc:Subject:Date;
	b=VNdawQuMg0aFnZJUHwE0MgFHE4w2Jw77c6103GkpfhgIeyWUY/kK84bnVN6RPC3eS
	 pl01cL1XNwYwnOC0qaicc7jq2uG8MUqiXKqP3ZLiAtn3Wb7RNGP+uuy4OPoJmeYsZw
	 PtXOR8dc8/nEm7oq9Z7nyfCP0KpXOO2OgHPbAZdU=
Received: from China-team ([47.95.114.252])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 4018BC9E; Mon, 18 May 2026 16:16:01 +0800
X-QQ-mid: xmsmtpt1779092161tjh48x0u3
Message-ID: <tencent_F47050611C1AC8694B6B203F9C249FADAB09@qq.com>
X-QQ-XMAILINFO: MK9ZM/6TSGijC1ronhEqx2g8BqlZ28YsdIn9VJboYDG+lvUCihSklJE4et0NGF
	 T//00IWb1uRvuzn31drk/wUS1MngJdkoFwXOff1OSW0U0/46wyMzxkQiJxaDmUKjm7RVQNOcOJL9
	 vP+2/NzGsJW0pLfPoZGB8fODIII4kUR5NL9d0Yi0/AdPyI8osxSqGBmMSCv9B6hWtG9jifGpfAwo
	 ZAjFDqNmeYpNnxJ4fuMOqOOPBcDLBKi5QoVFf1HDaTjKxUukKQ4w1RTTCxWP451NQkYZaAw4Um3u
	 GEytPFtAWtRHpFY/L7PilKRjtydg21g2jxPKyg+gEAASxyG2BGbasNOol4Grc+q0TYex+4hKe5ZM
	 QrfAyyEZeWpYN2HWSKQG0yvZE6641zoLvl6qyCT2shz2Een3gnU24/44gMN7CdtUxmiMsIsUVW+i
	 omDMWh6qPhdhigU3Jp7WpZNVF8/9UIsQo7Of0vEiCHnWuQOxUKg5dQgG0xYeQ8Sflvfp5G3FcJUv
	 NCZ1EoMhXWmHMlHF/+XvZtW3L0Nx6QoVrMsbMxfMd8D3OpV6fjqxzbniScUqE+BbHIZoV/qrvc1j
	 wcfTzPRzFtKe0OOc/GbwitpVA/KGommZ79wrDCpu6BMeKJD42ZNnU/T/mMbqxWl5SE9YcS1oGkzF
	 uvah5Rn9yVDsqN3SAgcn0JxHEhvkdJ3PAk40vEfkoJOUpqYEgvWGICw1AXaAGB/Id9PcbTZESxg9
	 2HqDAqugW2pJ1ZeoCZf/l4JUM49g1+pMLU3NxtN+mKQYLP4FxFkWzm/CT37sH6chj9X5JDg6qiqq
	 c++1ojqPiKHaF37fCLVst18KuIlJl/ba9xr/RmSnrx7mvetZlovkNeNXv4qg6FsCnW2N7TCFeY4q
	 FRBmdGyubC63hGNxuNXtqW+Q2JCs2Mq5HgDg1q4xCs69Y32eID8VqAmACpFbx4Uk2MSIg6Ethjzd
	 I/Ur1CL+GJG7fOEWdw32tv6/OpK3IvB0NgLTeUpH+8LVzfl5L1yJ8G3ry885FB8GYI75vDOZuuKj
	 dq3nTeqvX1iMRs2U7CQzwL0qTH0z7N0vDj4S4iEAojrfSlt7BtF+/Z23EFcGyhDevvRjJszcoTmh
	 KXsbjI
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Alva Lan <alvalan9@foxmail.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Liang Jie <liangjie@lixiang.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6.y 1/2] smb: client: correctly handle ErrorContextData as a flexible array
Date: Mon, 18 May 2026 16:15:53 +0800
X-OQ-MSGID: <20260518081554.21484-1-alvalan9@foxmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 215b7f9ecb8d7c14d56febdcdd246f3579c32aba ]

The `smb2_symlink_err_rsp` structure was previously defined with
`ErrorContextData` as a single `__u8` byte. However, the `ErrorContextData`
field is intended to be a variable-length array based on `ErrorDataLength`.
This mismatch leads to incorrect pointer arithmetic and potential memory
access issues when processing error contexts.

Updates the `ErrorContextData` field to be a flexible array
(`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
casts in the `symlink_data()` function to properly handle the flexible
array, ensuring correct memory calculations and data handling.

These changes improve the robustness of SMB2 symlink error processing.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
Suggested-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Remove the __counted_by_le annotation in v6.6. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
---
 fs/smb/client/smb2file.c | 4 ++--
 fs/smb/client/smb2pdu.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 4e7d5c612256..3a5b62b29806 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -42,14 +42,14 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
 		do {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
-				sym = (struct smb2_symlink_err_rsp *)&p->ErrorContextData;
+				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
 			}
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
-			p = (struct smb2_error_context_rsp *)((u8 *)&p->ErrorContextData + len);
+			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
 		} while (p < end);
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
 		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 076d9e83e1a0..3c09a58dfd07 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
 struct smb2_error_context_rsp {
 	__le32 ErrorDataLength;
 	__le32 ErrorId;
-	__u8  ErrorContextData; /* ErrorDataLength long array */
+	__u8  ErrorContextData[];
 } __packed;
 
 /* ErrorId values */
-- 
2.43.0

