Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0D438034;
	Wed, 26 Aug 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787756530; cv=none; b=c19qoo8eCAAuPOp41P1Hmtml4pwdE5/8m5Xufha6+3TY+Yen4v4N0Ep6JCuOQylP4oZ6iq+LtpuzcFf4AkcJAMpbHic29UKsXFmY2jZ1efRWen1H9X5k98aFFzldOcTVdakFFA8mn10r+hKcTA/zeCwv7C0HCwq6M1UqUi8XWQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787756530; c=relaxed/simple;
	bh=rvGocql+kmzXD8Ly1mab0YXmEnG2Ew/GvfG0OFCzYzc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZJaITS0penQ1YbTE6KrOVXQ/P8OrE/GkDXUn744DszyGrb0TtUwUANkW4+GDFwNh/kFFzCqzu+hSLl5iaKYYwJIJs+v890XlCEf8QoKb3h08E33gJ18zV0PILjlCCPPUPF9KKQY0dk99AOLP9VJCQAIwrAzJqrdeMGxpytGwF/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axfe6CAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axfe6CAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5751F000E9;
	Wed, 26 Aug 2026 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787756529;
	bh=uUOiyLJwv81xsj8gaUchVZEo9LZ2IJAod5LbF/RC+Wg=;
	h=From:To:Cc:Subject:Date;
	b=axfe6CANPqJLG5Hq3hCOlZUp4AOImUcjbkUsXo+xYOqZJEBmS/aJGRNqODfKWpXJX
	 cD2XbiTkjPjBY01Pr/p+e3N5xpmt0GRCSvPGelNrfX5cwVEvIlYr15I30s57l6P8Re
	 PO6TjrOGPjxBF59uAr7mdVhlvcxfTfBdOqTL0c20qytU/P12t4iRzjGMLkGc5vXQIP
	 OPXlg32rh1qqYUIJipMH9Pk9ZfO5RMzLJDC7gVRcezQjzP2hypdlgw+o1PYhCSEFcd
	 BwiWHnAGiJ7ER1uiJDweOlSpDST5HLcrhP0U2QgvCD3R8ICczXHgiYfRUYvMy6STdq
	 24wj1yj1Udfuw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] MAINTAINERS: Update the KSMBD entry
Date: Thu, 27 Aug 2026 00:01:59 +0900
Message-Id: <20260826150159.15412-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Steve French passed away recently. He was a long-time maintainer
of Linux's SMB support and will be greatly missed.

Update the KSMBD entry to no longer list Steve French as a
maintainer.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e1d14406619..2a81760e697b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14194,8 +14194,6 @@ F:	tools/testing/selftests/
 KERNEL SMB3 SERVER (KSMBD)
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Namjae Jeon <linkinjeon@samba.org>
-M:	Steve French <smfrench@gmail.com>
-M:	Steve French <sfrench@samba.org>
 R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
 R:	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
-- 
2.25.1

