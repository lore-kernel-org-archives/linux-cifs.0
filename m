Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90E63905EC;
	Tue,  7 Jul 2026 09:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415032; cv=none; b=cSxH9MSbfCtpYJArLlTDXyMrr24/9ZBvzs9QNzC0G/6IZVshsrR6Ps1WVAXqO4vkKJFPcS6UHz5RW6/OwFb/Kir8+OLpstmY/AEDGQtpioZVfY7tbUschR1v8O8CW+2y77DzQHSfj2EpenbaiUbLJYFShefoxt/+onDDhSPaJqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415032; c=relaxed/simple;
	bh=wWHZPAyY3+AwFSX6n7W/UK66Ikp/9C3S+2sgImyPkCQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=n7h5aH+DDR6fzkgESIKD+RLdLaJNPUlcP8uzpOLsse6HivQyE4vqay2nzFJQaUc20uARAL5k/Hw8ElzjhkOTIAlcFzmcfHzR4IGhJab0WaakRIk/gQa45NCBX4gkIzWZBFzQSha8JvICs+f95a4E2BnH9hRV91NzH++VIAM9bHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8CGZ9ah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8CGZ9ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5434A1F000E9;
	Tue,  7 Jul 2026 09:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783415031;
	bh=0Yw5f2+gRxiI5vnn/9pnZOj56EeqQvolLn1Zn2QBVhM=;
	h=From:To:Cc:Subject:Date;
	b=J8CGZ9ahuc2aFdOsI7Wcb8vImNwX0t7Omhg6pk2GL79HVH3kJGBVDw+uFSnlm8gi4
	 gBdqI/EZzu1SAIcHL9SjZ4EdU2d71aBZo6GEwa87jy6bw4/DpPktm+1nz9UYR+/JFW
	 ouws2oUl0XHxggs6lU2l5jDEl00ry84jF1ZPjzplTmDHR7t1CaYU5abrIcb/tMH3Cb
	 RQFduuQvthijLNII2qtUzy8f8kY5OEJfTNWeq/0vSEtwgGkXIkuvqnc9g6lqxQIEln
	 OT1Oa6y9EKN+kW1zmxRDLmgljmGRRckFpSBr2b/iSGyESGmqcZv8gYBvwHYoNc8XjG
	 ZNtUTLBzQDmoA==
Received: by pali.im (Postfix)
	id 737EA71B; Tue,  7 Jul 2026 11:03:48 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix support for creating SFU socket
Date: Tue,  7 Jul 2026 11:03:18 +0200
Message-Id: <20260707090318.26130-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU sockets are natively supported by Interix 3.0 subsystem and also by
later versions. It is part of Microsoft SFU (Windows Services for UNIX) and
Microsoft SUA (Subsystem for UNIX-based Applications). They can be created
and existing (stored on local disk or remote SMB share) can be recognized.

SFU sockets are recognized also by NFS server included in Windows Server.
Windows NFS server versions since Windows Server 2012 uses new reparse
point format for storing new sockets, but still can recognize this old
format (also in the latest Windows Server 2022 version).

SFU-style socket is a regular file which has system attribute set and
content of the file is one zero byte.

These SFU-style sockets are already recognized by Linux SMB client.

But Linux SMB client is currently creating new SFU socket in different
format which is not compatible with all those SFU applications. Fix this by
creating new sockets in correct SFU format which would be recognized by all
SFU, SUA, NFS and existing Linux SMB clients.

This change affects only creating new sockets when mount option -o sfu is used.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4f7eefa7a683..e59fda1b2230 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5288,10 +5288,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
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

