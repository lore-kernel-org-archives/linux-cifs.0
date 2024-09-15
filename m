Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC231C9EA0;
	Sun, 15 Sep 2024 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726429556; cv=none; b=WfcMVDJyor8f34s1YOSScWVMT6ZkMyT6jZRhI8x8a1IUNVa7F6dsnf9Fz8AL+czJJe+37tB59hPlN8XX4rmRlkznhutDr4FvXFLMoe+wVQrR51WbIlpza3mfIjmCJz6nnQYiUqkACa/xZY65AbV3CyRw4YWA28QDDqiY+JtWslo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726429556; c=relaxed/simple;
	bh=Xk4iAldMeXrsBRjhfpmL+ofisAHqsPO1bT9HypUneR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VymC58eMRyb8Dr671byDowcM4Ac1XEl/PpM6GC4jfmbgqaekiHErk2+MNxXLx/NxFmwRNy233TQ8yBi3kGGPZtdSr6YTBRWjvAYPhg1dNrar8Eb2g9MR5R7BErXPJa5/ovah2GEKI41/DYT9M2XNQbGH0oQgM6uQ+s33XeihX/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8O8uxMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8O8uxMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C724CC4CECE;
	Sun, 15 Sep 2024 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726429555;
	bh=Xk4iAldMeXrsBRjhfpmL+ofisAHqsPO1bT9HypUneR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8O8uxMO5LzitVzM2QOD6zGTfdPNeaF3dbzvdyb9qaJ34Nw2Ao237SzAMA3FDQ2g2
	 +buruNCYfBtLbZE77m7ZS5YDCIOVSxebSMGe7nXyo6cpqaX+U2FYraESTeo5NVHMxY
	 ltIoxg9qDUTVRwXN4QMkgaTrclm77TK49s3WF9XNW2E8b0A2/4vjmPuSPWlxgXvIGa
	 Kvw55aUeaNzsDUfTEIgm2sEB7WG3dBk7ekXwKIG6xOpOoU/OS6XortbjeJdgGXllFA
	 LDoHicuFqdtv6y2cUNfwnuYBujXH/xHgBLpEICocb/xie772bMie9SzliOUcGlVVuq
	 ofBpt0aS1UOBA==
Received: by pali.im (Postfix)
	id 784BEB45; Sun, 15 Sep 2024 21:45:50 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] cifs: Fix creating of SFU socket special files
Date: Sun, 15 Sep 2024 21:45:43 +0200
Message-Id: <20240915194545.14779-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240915194545.14779-1-pali@kernel.org>
References: <20240912120548.15877-7-pali@kernel.org>
 <20240915194545.14779-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU-style socket is file which has system attribute set and file content is
one zero byte. This format was introduced in Interix 3.0 subsystem, as part
of the Microsoft SFU 3.0 and is used also by all later versions. Previous
versions had no UNIX domain socket support.

This format of SFU-style sockets is recognized also by Windows NFS server
included in the latest version on Windows Server 2022.

Currently when sfu mount option is specified then CIFS creates new socket
files with content LnxSOCK. This was introduced in commit 518549c120e6
("cifs: fix creating sockets when using sfu mount options") as nobody
figured out what is the correct SFU format of sockets and tag LnxSOCK was
chosen to allow creating socket files. LnxSOCK looks similar to IntxCHR and
IntxBLK tags which are the proper SFU tags for char and block devices.

It is important to note that LnxSOCK is not SFU-compatible and neither
Interix, SFU, SUA or Windows NFS server recognize file with content of
LnxSOCK as special socket file.

Now when the proper format of SFU-style sockets is known and it was
verified that works with both old Interix 3.x subsystem and also with
Windows NFS server, change implementation of creating new SFU socket files
by CIFS client to be compatible with SFU.

518549c120e6 ("cifs: fix creating sockets when using sfu mount options")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2c251e9a3a30..dc56f7ba1a06 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5110,10 +5110,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		data = (u8 *)symname_utf16;
 		break;
 	case S_IFSOCK:
-		type_len = 8;
-		strscpy(type, "LnxSOCK");
-		data = (u8 *)&pdev;
-		data_len = sizeof(pdev);
+		/* SFU socket is system file with one zero byte */
+		type_len = 1;
+		type[0] = '\0';
 		break;
 	case S_IFIFO:
 		type_len = 8;
-- 
2.20.1

