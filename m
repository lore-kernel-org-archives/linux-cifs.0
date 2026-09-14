Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B3543BDA9
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 11:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789384549; cv=none; b=piB95awZcbGAjkO2r+jnneqSYdeCZ9kt2/aVR89yg3jwOMvdqa2ztdOvXGawMKdd+gGu78PSVsVoyHHM2tH2L7bwt65EH7DNVY1tADwKfzkZwqTtScY9S1eu/y+izzmhRQxAv9F0JwU5jrSHc3UrzQiIvY7NkVyghDqeUgu6pYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789384549; c=relaxed/simple;
	bh=9HD7V/aTocvKjYlWsJ0s0MGV+n+si1eE7DaK1FLGH3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ihBvXX8c39NFvwvobPyDsWI5Ua1MXZsdZHlm2uLfyRJjoN+AQEvhcqVV6C1DeVCE5S6WXbPwGOF5NQ4KADlbYuaNzYSuzkBjRyQUu56t0j6hsdLmnedNq3RvvbHu1VBAlwD/jFj2/VRWQPNqoqgNDCaISqiPfK2CmOFh/P1hvfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmzJkBJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmzJkBJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BDB1F000FF;
	Mon, 14 Sep 2026 11:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789384547;
	bh=93mRRiGjHMn2w27wUb5qor7v2PFBGQJpUdLsU9DchWw=;
	h=From:To:Cc:Subject:Date;
	b=SmzJkBJV6liHmQJ3aUNgQBZDHoQfotUqH+Jg/g3U6wZGtNNp9fWMVanILmoNTmw82
	 YdEBWYgvjkxanhK7qnNEOWh9uLXMF7qkL7yIxUHIX2+hoi7hVJ2XLLLlfay9wyQJn8
	 vY16K3A+NFYEdKF064UjjSGV5zC3/8tf03xURhWG9gb2oR2ohtMwphLHhRB/jiQq5S
	 36/Nj4nYCm8A+FapkBDDcFdNvAs4kwToeLzj8Tl2YPT4hzjbbYUM+LxQO/QZzOpuL3
	 rrLh94ZM8lY2v/tioDmNDB3rjd7gk9W24VXhMeqTzR/EGCvo2x3QkPEvZJgKxLZKXG
	 JRXwPTz4reilQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Mobin Aydinfar <mobin@mobintestserver.ir>
Subject: [PATCH v2] ksmbd: fix partial normalized name responses
Date: Mon, 14 Sep 2026 20:15:42 +0900
Message-Id: <20260914111543.12381-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows may request FILE_NORMALIZED_NAME_INFORMATION with an output
buffer that only fits the fixed portion of the variable-length response.
Treat the fixed portion as FILE_NORMALIZED_NAME_INFORMATION_SIZE so ksmbd
returns STATUS_BUFFER_OVERFLOW instead of STATUS_INFO_LENGTH_MISMATCH.

This avoids rejecting valid partial normalized-name responses.

Fixes: 6b8b79226bc3 ("ksmbd: fix partial file information responses")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 +++
 fs/smb/server/smb2pdu.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8acc5174530b..0436b7c898b1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7312,6 +7312,9 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		case FILE_ALTERNATE_NAME_INFORMATION:
 			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
 			break;
+		case FILE_NORMALIZED_NAME_INFORMATION:
+			fixed_len = FILE_NORMALIZED_NAME_INFORMATION_SIZE;
+			break;
 		case FILE_STREAM_INFORMATION:
 			fixed_len = FILE_STREAM_INFORMATION_SIZE;
 			break;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index a6200d8630e2..ca8e27f7b712 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -212,6 +212,7 @@ struct file_sparse {
 #define FILE_ALLOCATION_INFORMATION_SIZE      19
 #define FILE_END_OF_FILE_INFORMATION_SIZE     20
 #define FILE_ALTERNATE_NAME_INFORMATION_SIZE  8
+#define FILE_NORMALIZED_NAME_INFORMATION_SIZE 8
 #define FILE_STREAM_INFORMATION_SIZE          32
 #define FILE_PIPE_INFORMATION_SIZE            23
 #define FILE_PIPE_LOCAL_INFORMATION_SIZE      24
-- 
2.25.1

