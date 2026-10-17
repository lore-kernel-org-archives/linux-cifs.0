Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711FD2C87F
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199092; cv=none; b=W1CCGNQqICl4OfKLAn6Iigl4C0TV9DcfV0Gu8ObpmkcKGt1oSrNM3u/I1iDsvn74Gljp7/ET5dMD04Ecw0HRJyGTeiQGQUZ1JHSwV30+A0LyBAd5+Emg/qD0vpKW1C4ccSbNsaT9H3pPTp7efBZsW6Crai4uag0ezblrjv92Agg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199092; c=relaxed/simple;
	bh=6VZHdOR9nWfBj8iDD9tH6eBcfnRuMkZ4Mk1m/YiQml4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=An2tSHkB4POKZsCb1S0F1Fo6T1iWwjeaFH1SWVDJP/69llDHHFV6f6BsjXQjwrPHeKH7+4H0t7c6Xbr1RPm+JLu5QLu6LOMYiqBCmqbCU4m3hCqhOX+pkUS+GVylEOBW5iH0s+HvmJ9A64qAi20l62Tk9odS5qidtc66aKnRBuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NpkWQ7jO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NpkWQ7jO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5E41F000C4;
	Sat, 17 Oct 2026 01:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199091;
	bh=Fm/s4VSZABFb+fSqeDw0kyRvddYPpK3KwCfa8P2KeOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NpkWQ7jO+LyJ0EqeHs9QJKr3k/wCjWtGywoSnsXPfyx/XYI4W4Mq32WhDEOJYTLsi
	 Ci5S/9e++vcgcmi7bKYFlLxTUMQXX40VmbrbLz2hGMWS+01r7VYHL67QFC8EDVuZ63
	 DUpEfcOD9VuJwjk6/FHqo2om0xfhfA4QpfrjgOTazMs28r1H5gofMj5h4Ie1Y3Drd9
	 clsLFFfXU3hc0FKTjvXQKgfFhgW12o+RSYIEkrqPGeiAciS64I2L7KBHUGKQV5fwnw
	 QMUx9CphlzR6IpAJTd1Jio0Xv7qa5kwVVXNothEDzvU9dmAuBsRd01LG2EaBooem07
	 Zo6cm7CNiTADA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 22/22] ksmbd: correct POSIX filesystem block size and response length
Date: Sat, 17 Oct 2026 10:03:44 +0900
Message-Id: <20261017010344.11478-22-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

POSIX filesystem information uses f_bsize for BlockSize even when the
filesystem reports a distinct fragment size for its block counts.

Use f_frsize when available, falling back to f_bsize. Keep f_bsize as
the optimal transfer size and derive the response length from the
information structure instead of a hard-coded value.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6dfeb6078600..19ff569c001b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8002,7 +8002,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
 		info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
-		info->BlockSize = cpu_to_le32(stfs.f_bsize);
+		info->BlockSize = cpu_to_le32(stfs.f_frsize ?: stfs.f_bsize);
 		info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
 		info->BlocksAvail = cpu_to_le64(stfs.f_bfree);
 		info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
@@ -8011,8 +8011,8 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->FileSysIdentifier =
 			cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
 				    (u32)stfs.f_fsid.val[0]);
-		rsp->OutputBufferLength = cpu_to_le32(56);
-		fixed_len = 56;
+		rsp->OutputBufferLength = cpu_to_le32(sizeof(*info));
+		fixed_len = sizeof(*info);
 		break;
 	}
 	default:
-- 
2.25.1

