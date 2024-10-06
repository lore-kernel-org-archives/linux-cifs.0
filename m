Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798B176252;
	Sun,  6 Oct 2024 10:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208872; cv=none; b=LMrOBPR8muCTmqWx/wRyckIzSAOtOMJ6uIk0jgsQxTW6h6PSv6wofA1gIv+ECwTP+2xs0C6X4Y9M+LJvd70GzQbGNzOomWlgEj3hPSxWsmvb98/1gdY/hf3WowfUNTmRLYZQhCClyjXQSvR2JNGi32h92Hhj3DN2Nh10ahGVBxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208872; c=relaxed/simple;
	bh=PIF7Qur/PKKm4DYKUr+wEds9pKd7tP/IVUfLASXkER8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPWw8g/N4VH9M+wH5XKdzTwfZChpXPqEhByeyaQU34LSIoGLgJ2vNpDd1WJx0NyeD/M9jxWmo+FYXoT2zT5el8bHRFCBr/jtaO07+swZ02kNuQHCamKMDQYujVRZJ/WySYWahPRfF1AP6Cqrm9PVtOxRZ62ikqzE6iJLPtpzHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RI0WFRem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RI0WFRem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E04C4CEC5;
	Sun,  6 Oct 2024 10:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208871;
	bh=PIF7Qur/PKKm4DYKUr+wEds9pKd7tP/IVUfLASXkER8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI0WFRem1EE08HV/1Ez5hRPtdS6SoTzM3ACcespjztSYwh+BJop/JgwZ4ntF7RJ5u
	 hA5qV7i2dP4vysQ3JMOojrB35G6JDTJWSF5EqdAVh6g3Y9KtrqY3nvfAwRz/YXCUp2
	 ML5TatWk2pJQi5V6ZZKG1+ZscXhkdwjYlqYRt1duXz3gS9ll0WW9yhGYvmcKerqsnf
	 o8BThlokuw5OG3aaStENxHL1VhWavwItFd9t3n2RXRanx5ABoWX0FWxUxG7CEVUDVP
	 C3aLgUAYT0O9wCpRSqqTXkpFgGzAUKbyj/INMNPsaNjiJa6m/BaPxXCYCLJeGp/ZHA
	 T57MntVfRVJiQ==
Received: by pali.im (Postfix)
	id 9FBA5DE8; Sun,  6 Oct 2024 12:01:03 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] cifs: Validate content of WSL reparse point buffers
Date: Sun,  6 Oct 2024 12:00:46 +0200
Message-Id: <20241006100046.30772-8-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241006100046.30772-1-pali@kernel.org>
References: <20241006100046.30772-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

WSL socket, fifo, char and block devices have empty reparse buffer.
Validate the length of the reparse buffer.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 6606c40487ae..c0d9ba14a60d 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1093,6 +1093,11 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
+		if (le16_to_cpu(buf->ReparseDataLength) != 0) {
+			cifs_dbg(VFS, "srv returned malformed buffer for reparse point: 0x%08x\n",
+				 le32_to_cpu(buf->ReparseTag));
+			return -EIO;
+		}
 		break;
 	default:
 		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-- 
2.20.1

