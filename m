Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2F1D133
	for <linux-cifs@vger.kernel.org>; Tue, 19 Dec 2023 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="bicXm2Id"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1703002239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eTteXyPwfhHoZHhwrIkU5+hL3HLY0Qf/cTrIh6hLVc=;
	b=bicXm2IdSOKn0pcTeReKN0TZEcmPjivc+qRmTDUCUZEtzeIBS0DULM4iHOE4LBDwPlJOSu
	CP7xZOmCPbxdz6dMLIXE23dxxnYlHntaAXTo8IkSkvuCH1plGDJKnT2cpwpaS/BUIP8DX9
	h8DIY9KBrRfMhNCa9f/Lzc5pTWKta2Nv0cyPwntvfp3r1eZmvcHqzaFbW4B1uPZLL2yc1N
	ke6mXzrRaM1vt8pnXA8/kV/P4XZICYPSyTH79vBTKoMG2CLibozy8cjaxaVS31XM7VlJKO
	IwDkD9gDQbJA55G3KIfCD0JMr7LSPzWsiLAJbrsAYQVek3Bno20fJ+gIpzLufw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1703002239; a=rsa-sha256;
	cv=none;
	b=MvhBIdmjr15DfbVj+/RwT7JyznZeiPbHMtn/3lpPMnqPZPNz/TZ0+OJc6QJks4W1WCfhJ+
	IL3mor9kK8VBcpj5iPk6SoWjPrrI795jwXRkApN25o3SUnETjFYK4VUb/Nzj/c1fO7FsSS
	1uqa4Dp5FCAUC1RPgOVNizXfCxTZRhjYr+DTV4Etw1Y1Hr6IaA0o0gVTMQJ4/XxEPSaxTL
	0MC90OMrpIQ1sv0d6vkDKSNZIpvUWmKQxonR/CFch5zEodsOTI3abE6Xlg+Upd97ZCm94L
	qWw8jk8m3ktd23NYUL91I8EnBUMA7wuE6b0tmUKy78KZIpIrgGAqAy6L0lBsxQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1703002239; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eTteXyPwfhHoZHhwrIkU5+hL3HLY0Qf/cTrIh6hLVc=;
	b=N904ssHIgklJ5sOZAhC8sPBxqOEthBuYXA2PHfil/c7JujiksNm6J+xUGgf8UICqDhsfT7
	rmsifxyYoIK+Idliic77ora0pCBLOfcFnD6tZEleRXbv2bhyDBffFSfo7CQCnu/MuFUFRt
	rraOPkHqsTfKDryWNgV2WXArmDZnVGrqg+rOrjh1OdfTHmyq+yW2wrZ+CuFKMc6kNGSZM3
	PaZhGF8OZ0/WbcLIXVTVMIXMOR/cc2HU1AGUsGQNqP3jQlIZF8mnDB+S5GuSZ/cG/wd15X
	vRCy618KgMnHZFcZF3vm3GQdisfNKaAh26Oo0JVNwsluGDyR9RXiQszjqeR/jw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	j51569436@gmail.com
Subject: [PATCH v2] smb: client: fix potential OOB in smb2_dump_detail()
Date: Tue, 19 Dec 2023 13:10:31 -0300
Message-ID: <20231219161031.27068-1-pc@manguebit.com>
In-Reply-To: <20231216041005.7948-2-pc@manguebit.com>
References: <20231216041005.7948-2-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate SMB message with ->check_message() before calling
->calc_smb_size().

This fixes CVE-2023-6610.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218219
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
---
Steve, I tried to make as little changes as possible for v1 to make
backporting easier, but unfortunately we still need to handle "@len <
@pdu_size" case in smb2_check_message() otherwise we could call
smb2_calc_size() with an invalid command, too.

 fs/smb/client/smb2misc.c | 30 +++++++++++++++---------------
 fs/smb/client/smb2ops.c  |  6 ++++--
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index e20b4354e703..82b84a4941dd 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -173,6 +173,21 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 	}
 
 	mid = le64_to_cpu(shdr->MessageId);
+	if (check_smb2_hdr(shdr, mid))
+		return 1;
+
+	if (shdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
+		cifs_dbg(VFS, "Invalid structure size %u\n",
+			 le16_to_cpu(shdr->StructureSize));
+		return 1;
+	}
+
+	command = le16_to_cpu(shdr->Command);
+	if (command >= NUMBER_OF_SMB2_COMMANDS) {
+		cifs_dbg(VFS, "Invalid SMB2 command %d\n", command);
+		return 1;
+	}
+
 	if (len < pdu_size) {
 		if ((len >= hdr_size)
 		    && (shdr->Status != 0)) {
@@ -193,21 +208,6 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		return 1;
 	}
 
-	if (check_smb2_hdr(shdr, mid))
-		return 1;
-
-	if (shdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
-		cifs_dbg(VFS, "Invalid structure size %u\n",
-			 le16_to_cpu(shdr->StructureSize));
-		return 1;
-	}
-
-	command = le16_to_cpu(shdr->Command);
-	if (command >= NUMBER_OF_SMB2_COMMANDS) {
-		cifs_dbg(VFS, "Invalid SMB2 command %d\n", command);
-		return 1;
-	}
-
 	if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
 		if (command != SMB2_OPLOCK_BREAK_HE && (shdr->Status == 0 ||
 		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE)) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 62b0a8df867b..66b310208545 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -403,8 +403,10 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
 		 shdr->Id.SyncId.ProcessId);
-	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
-		 server->ops->calc_smb_size(buf));
+	if (!server->ops->check_message(buf, server->total_read, server)) {
+		cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
+				server->ops->calc_smb_size(buf));
+	}
 #endif
 }
 
-- 
2.43.0

