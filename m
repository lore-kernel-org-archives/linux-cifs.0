Received: from mail.amicon.ru (unknown [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C0F374A1F;
	Mon, 24 Aug 2026 10:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787567001; cv=none; b=RfpqSNHOuM2cUT9VvQe+hYW/2Mtn4dN74Y/5sCXYfSlZ0lpru+zosRR6/bIQaPehhFAP1YHI8jPjKOvlF/77/ogj4g2tkrjScnzeUfmE8VzSFOczDcz87MGxQDch5/GgIrNvgw8fDKO/ldEtiXXXI23TTSbSRRK3HzeZ2IekBI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787567001; c=relaxed/simple;
	bh=PT5i94gEJTHx8AkejakDwe70KVxq5oziFyZS3Bd0d2g=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version; b=Hk5T5bFy2ze9fsK7zOV2C2cdzIgKcAISUbU4nWsLSaLaqc3Y22pExg0Rd+egWRbgtesP9MUald2RVEO/lKdIThtf2ShlkHlM8KZnQVwak2xr3FS+GQXBAUv2dQYP5aLLIQmdC8L6+HhFLwRDz+6y7e10gwAjZxYDhYFecvv1pxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=MGmB7AHJ; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="MGmB7AHJ"
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787566997; h=from:subject:to:date:message-id;
	bh=PT5i94gEJTHx8AkejakDwe70KVxq5oziFyZS3Bd0d2g=;
	b=MGmB7AHJ0iws7wnWwp2nK2cdmz937CNJqD5wuXyQNWA0yd50ihSfFOkacuqQcUf6xgVhcpWVWgg
	y55j7Fl+WGTzk7unt366w3TDDZ0pjSizr7KJ0zFT4Wge2GzbZoTcbJwsEKIYO45XLtohRKwOjvnyD
	RBdu0Zkr8C6xSRySQbU58BShDzti2bKbuCQridZvqgm9md4csRDIaCNimRVyxUNyD1kqxpxIU4YRO
	VRrlwAs08fBVd3H7UJBqLnx+aNOgVZNBZQJjIdPmmjzG54+Ak5xBrBoUnZBK3+Ey7z1t1VuDg40ku
	M0KbPfLhhEdD/5Z12SXPCFbSl1pKMo/LVEBw==
Received: from localhost.localdomain (192.168.0.250) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Mon, 24 Aug
 2026 13:23:14 +0300
From: Aleksandr Khromov <haa@amicon.ru>
To: <linkinjeon@kernel.org>, <sfrench@samba.org>
CC: <senozhatsky@chromium.org>, <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <haa@amicon.ru>, <rrv@amicon.ru>
Subject: [PATCH v2 2/3] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Mon, 24 Aug 2026 13:22:47 +0300
Message-ID: <20260824102248.178152-3-haa@amicon.ru>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260824102248.178152-1-haa@amicon.ru>
References: <20260821135801.3790290-1-haa@amicon.ru>
 <20260824102248.178152-1-haa@amicon.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: mail.amicon.lan (192.168.0.59) To mail.amicon.lan
 (192.168.0.59)

smb2_get_info_filesystem() reports 48 bytes for FS_CONTROL_INFORMATION,
that is the whole of struct smb2_fs_control_info, but never assigns
FileSystemControlFlags.  Those four bytes go to the client as they are
found in the response buffer.

The buffer is zeroed on allocation, so a standalone request leaks
nothing.  A compound request can leak: the offset of the next response
is advanced by the length pinned for the previous one, so a reply that
was written into the buffer and then dropped in favour of the short
error response of smb2_set_err_rsp() stays there, and the next reply is
laid over it with only the header cleared.

ksmbd does not implement quota tracking, so report no control flags.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a66a7a12477b..5e83ad4f085e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6145,6 +6145,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		break;
-- 
2.48.1

