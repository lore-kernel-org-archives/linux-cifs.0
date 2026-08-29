Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AD338910;
	Sat, 29 Aug 2026 06:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787984873; cv=none; b=ZEz4k438Y7gu6UDZqt0FdkcxKlDY0o3S0sfF+4lj0Bu5yTi2N5L0QWR2Ehn1NIcDo1+SBL+asrBhmdgGaF2keN3Y4+JlvBs6WnwSx60aRhDgO/fIYFYAkl4ehIaEMX4PiKjL4XoCYKsfKm6wb58wIIB+XjbzDi/9Xrk5yHb/l2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787984873; c=relaxed/simple;
	bh=fy5e3zvfgTyGYbayg463h6BX0mVhgXD0Hv4UeqfFkw8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=c2saDM09t5CpxWx/OlH6jRFgGYYTw2jKCZ3pK0sr4GKSOaPUa3PVyjyNiAWZ9e5QnKU3UgjO55LdWJ7EwmmbBsX7X2JLGPWYOy6vayH8H0L5FJRXiyG7+aZ5NUrKubBF5vRv+ZyfKVJKuezL+cr6U9mHoAVlrlqJd7Rjx5sDOT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5HX0ruF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5HX0ruF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7787EC2BCB9;
	Sat, 29 Aug 2026 06:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787984872;
	bh=fy5e3zvfgTyGYbayg463h6BX0mVhgXD0Hv4UeqfFkw8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=H5HX0ruF6bN/fHW/M+PqgRXco3+LUQqI4IepHd2O4WzIFM/Y4Gw7OgFW6zfdgZvT1
	 TX887MiQf0w5iv9VUhVwZPJaU4NVWQrWstDqzq/FrFKf9HnEyNa5w7f9wMf7DevOc9
	 neNZPpc/O5dfB2r/wJd0HUiKjZCjkItHBFgh68+VkVDVhShiFtWooJPn8G9QgQVoUt
	 hN5UY/N4A5DRk5JEQ2nALZtTQ0ZaU6hBjkSaYvuzF2SS/1BFOJAQu+IF23diICSBnb
	 mAdHirPD2PG3eUV1cLUSEPT6yLVxt/lQLpTA53IRnyrPY1F+WI3poAJ3K0DN1o9zBj
	 2GAMXBt1n/z7Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53ABAC61DD7;
	Sat, 29 Aug 2026 06:27:52 +0000 (UTC)
From: Alon Shakevsky via B4 Relay <devnull+shakevsky.berkeley.edu@kernel.org>
Date: Sat, 29 Aug 2026 06:27:46 +0000
Subject: [PATCH] ksmbd: validate normalized name response length
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-review-ksmbd-normalized-name-v1-v1-1-4fab73835057@berkeley.edu>
X-B4-Tracking: v=1; b=H4sIAOF7kmoC/yWNQQ6CMBREr0L+2p9AjVa9inHRlql+tYW0CkTC3
 S26m5dM3pspIwkynaqZEgbJ0sUCzaYidzPxCpa2MKla7euDOvJ6wsiPHGzLsUvBPOWDMk0ADw1
 bv91Ba2+d11QsfYKX6Vc4X/6c3/YO91q1tCxfud3qpoMAAAA=
X-Change-ID: 20260829-review-ksmbd-normalized-name-v1-bf35e77fbcf7
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Alon Shakevsky <shakevsky@berkeley.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787984872; l=2527;
 i=shakevsky@berkeley.edu; s=20260829; h=from:subject:message-id;
 bh=T13DIXmeZ93mMwKTEaI6hlQtShB0Yg0MmpygPjeCVh8=;
 b=DMrJgpdTOB6PlJrFJXiartZD8o+rKseTf2hjZpjLWJXwa9loifYd6qewtwQkFRxNk8EHmYur6
 sF6eKXVMozQDY7X3pNuB46n1zZ/0RAYr4SzuoMlO7/3jCF2dEnx8O5r
X-Developer-Key: i=shakevsky@berkeley.edu; a=ed25519;
 pk=yWZAM5+fHWudgjDI2F4zjbrSoHRSkvQ4pqpdyFWJUis=
X-Endpoint-Received: by B4 Relay for shakevsky@berkeley.edu/20260829 with
 auth_id=987
X-Original-From: Alon Shakevsky <shakevsky@berkeley.edu>
Reply-To: shakevsky@berkeley.edu

From: Alon Shakevsky <shakevsky@berkeley.edu>

FILE_NORMALIZED_NAME_INFORMATION converts the open file path to UTF-16.
smb2_allocate_rsp_buf() leaves these responses in the 448-byte small
buffer, and get_file_normalized_name_info() converts the path without
checking the remaining space.

An authenticated client can query a long path and make
smbConvertToUTF16() write beyond work->response_buf.

Use the large response buffer for normalized-name queries. Before
conversion, verify that the response has room for the worst-case UTF-16
output and its terminator.

Fixes: 10aeff72ab82 ("ksmbd: support normalized name information")
Assisted-by: Antiproof:GPT-5.6-Sol
Signed-off-by: Alon Shakevsky <shakevsky@berkeley.edu>
---
 fs/smb/server/smb2pdu.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a8046f477d54..0870d03dfce3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -873,7 +873,8 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 		req = smb_get_msg(work->request_buf);
 		if ((req->InfoType == SMB2_O_INFO_FILE &&
 		     (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||
-		     req->FileInfoClass == FILE_ALL_INFORMATION)) ||
+		      req->FileInfoClass == FILE_ALL_INFORMATION ||
+		      req->FileInfoClass == FILE_NORMALIZED_NAME_INFORMATION)) ||
 		    req->InfoType == SMB2_O_INFO_SECURITY)
 			sz = large_sz;
 	}
@@ -6757,7 +6758,7 @@ static int get_file_normalized_name_info(struct ksmbd_work *work,
 {
 	struct smb2_file_alt_name_info *file_info;
 	char *filename, *normalized, *stream_name;
-	int conv_len, filename_len;
+	int buf_free_len, conv_len, filename_len;
 
 	if (work->conn->dialect < SMB311_PROT_ID) {
 		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
@@ -6781,6 +6782,14 @@ static int get_file_normalized_name_info(struct ksmbd_work *work,
 		return -ENOMEM;
 
 	filename_len = strlen(normalized);
+	buf_free_len = smb2_resp_buf_len(work, sizeof(*rsp) +
+					 sizeof(*file_info));
+	if (buf_free_len < 0 ||
+	    (size_t)buf_free_len < (filename_len + 1) * sizeof(__le16)) {
+		kfree(normalized);
+		return -EINVAL;
+	}
+
 	file_info = (struct smb2_file_alt_name_info *)rsp->Buffer;
 	conv_len = smbConvertToUTF16((__le16 *)file_info->FileName,
 				     normalized, filename_len,

---
base-commit: cf72cbb39da84b6f02f90c07f33b102fc10b16f0
change-id: 20260829-review-ksmbd-normalized-name-v1-bf35e77fbcf7

Best regards,
--  
Alon Shakevsky <shakevsky@berkeley.edu>


