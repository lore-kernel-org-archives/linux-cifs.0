Received: from mail.amicon.ru (mail.amicon.ru [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A13D375F82;
	Mon, 24 Aug 2026 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787567032; cv=none; b=DaLol71wVNUfl6geWruQeJT7qmtxm1xkCDefqP9zEyxHvVCA3nGrfIPiE+fAaSIjIHkMWF55RDQBLEHImKD/vepWeCgSQKYxNAWJ8Zhb+udleSoREKA0lJkeNdCDJXVoUM8NNAx+OWGV4BslHVM4EgCRtm+BBraAVrJGd7MaADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787567032; c=relaxed/simple;
	bh=GNNIcCbb8CKA2CqCDfT6NtZhJfbAbQssC+W59hK9jFc=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version; b=KGgi81+PcUH7Kw+EsS1FYIWbamN5b8XbLzyrfmWZaSAmSmw7Bb3QSVxDoJCCSrq48UPP3PmxrOGSzd04toytwanQjdgUcr+Up4fjASbw1GMYiPwQ5JWHWTISnONmZmQ+jRKLLaWNnjHKLKeX342PyihozxkScnA1HkGhuevfMT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=F403FoXN; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="F403FoXN"
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787567028; h=from:subject:to:date:message-id;
	bh=GNNIcCbb8CKA2CqCDfT6NtZhJfbAbQssC+W59hK9jFc=;
	b=F403FoXNd8OiFt7F1ctldSPMrijzQjL9helKxEm8kElQxuJ8NDWdGhzknlgNwJjGyr0QCafzXCO
	7eadVRA4VgCLt75hQfhRsnrozK1hWY9gLLX046ydpqS9Oujm7wsvXlOZeOeyYvpSAIPM3wVg8Y9LG
	QGThXyen2vQenQrAZQI8bhlRLcmGJLtX/CfqXYN8IxOrHBgklLWdvHkAeR1qF0MqPsuCmNwahJ9Ac
	5cTfsTfQ4YZIegqLF0Wv4y391q6Jl0HOOtFn5KEqoRqHRbbWoNvfjLE+fItn2MXuWlSYdQ0hpRH98
	c1qB3troVGftxx5dmV11Lao3bidH31LlkisQ==
Received: from localhost.localdomain (192.168.0.250) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Mon, 24 Aug
 2026 13:23:43 +0300
From: Aleksandr Khromov <haa@amicon.ru>
To: <linkinjeon@kernel.org>, <sfrench@samba.org>
CC: <senozhatsky@chromium.org>, <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <haa@amicon.ru>, <rrv@amicon.ru>
Subject: [PATCH v2 3/3] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Mon, 24 Aug 2026 13:22:48 +0300
Message-ID: <20260824102248.178152-4-haa@amicon.ru>
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

smb2_get_info_filesystem() reports 56 bytes for FS_POSIX_INFORMATION,
that is the whole of FILE_SYSTEM_POSIX_INFO, but never assigns
FileSysIdentifier.  Those eight bytes go to the client as they are found
in the response buffer.

The buffer is zeroed on allocation, so a standalone request leaks
nothing.  A compound request can leak: the offset of the next response
is advanced by the length pinned for the previous one, so a reply that
was written into the buffer and then dropped in favour of the short
error response of smb2_set_err_rsp() stays there, and the next reply is
laid over it with only the header cleared.

Report the file system id statfs() returned, which is what the field is
for; ksmbd already hands the same value out in FS_OBJECT_ID_INFORMATION
when the volume UUID is not available.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
---
 fs/smb/server/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5e83ad4f085e..7f200ba103ba 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6167,6 +6167,8 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			memcpy(&info->FileSysIdentifier, &stfs.f_fsid,
+			       sizeof(stfs.f_fsid));
 			rsp->OutputBufferLength = cpu_to_le32(56);
 		}
 		break;
-- 
2.48.1

