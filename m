Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCE63AF65B;
	Tue, 18 Aug 2026 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046521; cv=none; b=HDrnrlfm6vYYMI6MEQ3RvOUr4x2l/mnMPLmscP1687yjIHf/Te9bZfZNjtkLlgZDZC4Pg5oiDi4+4yzxVqtEYHTEw4jC7OiRWjBYbyQRRrPbbyoi5jY+XwE+Er5dEUZJEXOWFZ0bQjAYQrDbcyoN7/VnKPTLWcGjJX83ganeD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046521; c=relaxed/simple;
	bh=js6sTLjWzsMX3aVo0mAyz8XGuzJALPb0jNZtlPwSyww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PQZMBPTtrwVM/4JGa3PPO77IbY3r1KcKQ34Otc3Bp4MQ5faC8ZTxToFWv1apMW51TygxbJ19G1Dqg4ojHQaH9/DaJR3qWEVyvwf1ui7sjoTloBfd3wtGTveq7TF2liAUCizuGlgSAZlFkvARYuAJUyVsdutInfSowu5BK2nLHE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfB8JJpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfB8JJpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6DF1F000E9;
	Tue, 18 Aug 2026 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787046519;
	bh=93p3xfG6s4r7WF5FN4fv0CM4eTJc+8uQ2G9E9WD2ie0=;
	h=From:To:Cc:Subject:Date;
	b=YfB8JJpl+/PmtfbcQK5989bMoX/IhrchlE4LBlBZT6bfWFh1mJr9FjHLryzS86VUb
	 M2NyyDz7p/nNsqCuquEYdADfRDSTqGf/wACzeaZCx3WgnDcZcAy/a3b5+3eyCvQVug
	 03avNwBLjwMah4Dus3d4W811HYlb75kxdfVXLPqfgyDTg1rtcVsvfhl/rjgtJUCfth
	 rhKaA79pL/7AzcP9BEQF9lUWIg5yAXQkDZsRkAW2nHJtW5sQSBG8ukJ7OwR1bIW6my
	 lMZ4u9TG4XiOGeAGh7Amg57mgY3HoU16Gv/v9BL6tTMsQfXB0QQxByizEAaeqBpJf1
	 ruzyXl4hzQURw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	chenxiaosong@chenxiaosong.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] MAINTAINERS: add myself as CIFS co-maintainer
Date: Tue, 18 Aug 2026 18:48:30 +0900
Message-Id: <20260818094830.9508-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Steve is currently away due to health issues. Until he returns, I will
take over maintenance of cifs(smb3 client) in addition to ksmbd.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..257204fe8320 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6460,6 +6460,8 @@ X:	drivers/clk/clkdev.c
 COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)
 M:	Steve French <sfrench@samba.org>
 M:	Steve French <smfrench@gmail.com>
+M:	Namjae Jeon <linkinjeon@kernel.org>
+M:	Namjae Jeon <linkinjeon@samba.org>
 R:	Paulo Alcantara <pc@manguebit.org> (DFS, global name space)
 R:	Ronnie Sahlberg <ronniesahlberg@gmail.com> (directory leases, sparse files)
 R:	Shyam Prasad N <sprasad@microsoft.com> (multichannel)
@@ -6469,7 +6471,7 @@
 L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 S:	Supported
 W:	https://wiki.samba.org/index.php/LinuxCIFS
-T:	git https://git.samba.org/sfrench/cifs-2.6.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git for-next
 F:	Documentation/admin-guide/cifs/
 F:	fs/smb/client/
 F:	fs/smb/common/
-- 
2.25.1
