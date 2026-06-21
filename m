Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8F372621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046163; cv=none; b=iYom/04HjE/3Y5g1F3fVkx19NZlDwq5UPPjZ7IDYMhlhBBQ6oeSo41RVnjd3QaleQfXJQa4S2U9lxEH2v8zQfKu9z6P1oT3RfhxFYWavIgcieNHNV6C4q/OHMPORQ/3fBUqloQGyklero/jtLW5F2JRdVux2dRk3ArSbdqHTXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046163; c=relaxed/simple;
	bh=+TiCXa68IJqt+tQIR2EWETYigY27ueYqFfGp/LBY2qg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HLAKKzpWv7AGY+eRvkSr/+9IcwAOhS0ktzF0//ECtTj1av8a9XhcspG2hYKJiHu3wcR3fSQ2qiHRN970JSdUd4r0ySQfR1zmwBkJcoFAHOssW6fJS4QL/3iJO7AI6bp7ET3+1/3R9ve2V7VPXugfx/tAp38NrhDK9PEJp7gcRv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AP/TG5oj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AP/TG5oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3851F000E9;
	Sun, 21 Jun 2026 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046162;
	bh=NRs1diJkVsyeLPVGSF6cKy09nxWtw3NJPRtJtYbeo/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AP/TG5ojk+VWdlQKzbPl+J3WjpxMqD48PbbOVmrl1hPIvvFzFMvQEEpboCJCbQkTI
	 DyNebUEvRTKczZB3YKLTes3ugAv3Gfxw62CelRuMhLMGb7sb8nwKh/xBVXl13f/Lt1
	 e9Pl71GI5Y6x794EctqqkJ9KS7/rudn5GLnHK30Hicph5bEd5fsec8xYbW1sosxOwA
	 XRDL048QIOYt/83VH/fXo+mmy8G1MOUglERrULYNm+9uzflLa6UkdV6taLUPp+zbqb
	 xl610xRIBjJ4+SGt2yWv9ssqJI4xI6Wm/BTo555EWNDuTgNraBq4LQJfUqbGGjoTFl
	 duwMs81CoFIbA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 16/29] ksmbd: tighten create file attribute validation
Date: Sun, 21 Jun 2026 21:48:31 +0900
Message-Id: <20260621124844.6235-16-linkinjeon@kernel.org>
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

smb2.create.gentest checks each create FileAttributes bit independently and
expects FILE_ATTRIBUTE_INTEGRITY_STREAM and FILE_ATTRIBUTE_NO_SCRUB_DATA to
be rejected with STATUS_INVALID_PARAMETER.

ksmbd validates create FileAttributes against FILE_ATTRIBUTE_MASK, which
includes those bits. It also rejects only requests that have no known
attribute bit at all, so a request containing both known and unknown bits
can pass validation.

Use a create-specific attribute mask that excludes INTEGRITY_STREAM and
NO_SCRUB_DATA, and reject any bit outside that mask.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9a1308f32f45..d6001cdce085 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -57,6 +57,10 @@ static void __wbuf(struct ksmbd_work *work, void **req, void **rsp)
 
 #define WORK_BUFFERS(w, rq, rs)	__wbuf((w), (void **)&(rq), (void **)&(rs))
 
+#define SMB2_CREATE_FILE_ATTRIBUTE_MASK \
+	(FILE_ATTRIBUTE_MASK & ~(FILE_ATTRIBUTE_INTEGRITY_STREAM | \
+				 FILE_ATTRIBUTE_NO_SCRUB_DATA))
+
 /**
  * check_session_id() - check for valid session id in smb header
  * @conn:	connection instance
@@ -3339,7 +3343,8 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out2;
 	}
 
-	if (req->FileAttributes && !(req->FileAttributes & FILE_ATTRIBUTE_MASK_LE)) {
+	if (req->FileAttributes &&
+	    (req->FileAttributes & ~cpu_to_le32(SMB2_CREATE_FILE_ATTRIBUTE_MASK))) {
 		pr_err("Invalid file attribute : 0x%x\n",
 		       le32_to_cpu(req->FileAttributes));
 		rc = -EINVAL;
-- 
2.25.1

