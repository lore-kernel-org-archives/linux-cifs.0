Received: from mail.amicon.ru (unknown [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60108375F82;
	Mon, 24 Aug 2026 10:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787566995; cv=none; b=k5CsqkC5lj57Y1HG0rPTW7QCKI7mpWNDNeeVI7w7072zO9mRDhnosa0hH2GPXHxgsvDQ+XEOBZ9Y3POT43BSeQnkr8R8tJ323V371E+YcQqkitX7YAYYRtxHYomIsNtL+s0ab6ncfR34ihKFFi1CkuqQWjRmMlZXLLig2pvgSRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787566995; c=relaxed/simple;
	bh=IcMqAquUYIjmqqC5ZhMeop2YaOzLFYBW8X3+dvdhgKs=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version; b=npeuAwjM21uv5xNw9S11DN6A1adhZyznM5zvhcqLdVka/qiQJgiZ1SIY0j78KxsSbS38IgSxCONatSK90+dEG40SgP04bYcAuf2OvrR8KbIV+o2Zl6Htvjb5uwOV21xfWb/ACcvxD27TDMzY3PRCAh470fOsvSoNVQPz8CDG4Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=HPME+MJe; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="HPME+MJe"
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787566990; h=from:subject:to:date:message-id;
	bh=IcMqAquUYIjmqqC5ZhMeop2YaOzLFYBW8X3+dvdhgKs=;
	b=HPME+MJe+sz6cMwEGSpMFKysCDcKWRI/GrCdYtKbgpQGCHWvGl2HU0ldS5Ij+kWwJifojOUUaeA
	8+ESDhuHmU2yI8hL7badonMyYsQiryzjyYm7Dmt7UzGyP8kCTD72UDWmIgtKOakETJYePj8KNqanc
	htmdktpfmnWrfy2fnHa/N8VMUNgHEt96j1cviHkzwYCQYZro+fRH6lRaKaiae6NK6RCpSdZtn3f1A
	fmhYZpE8/bjxw392nNy3mhxL82PN7Oklo3RwIwwTHWQgsAhLg3gRL+qQTvuvbTa9MqDGmLrC21v9Z
	n81JFqVGNm9TWaIngxe0u6edSMjax6paCJpA==
Received: from localhost.localdomain (192.168.0.250) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Mon, 24 Aug
 2026 13:23:07 +0300
From: Aleksandr Khromov <haa@amicon.ru>
To: <linkinjeon@kernel.org>, <sfrench@samba.org>
CC: <senozhatsky@chromium.org>, <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <haa@amicon.ru>, <rrv@amicon.ru>
Subject: [PATCH v2 1/3] ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in
Date: Mon, 24 Aug 2026 13:22:46 +0300
Message-ID: <20260824102248.178152-2-haa@amicon.ru>
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

smb2_get_info_filesystem() reports 64 bytes for FS_OBJECT_ID_INFORMATION,
that is the whole of struct object_id_info, but writes only 46 of them:

 - objid[] is 16 bytes, and when the volume UUID is not available only
   sizeof(stfs.f_fsid) (8) bytes are copied into it;
 - extended_info.version_string[] is STRING_LENGTH (28) bytes, and only
   strlen("1.1.0") (5) bytes are copied into it.

The response buffer is zeroed on allocation (kvzalloc() in
smb2_allocate_rsp_buf()), so for a standalone request the remaining 31
bytes are zero.  In a compound request they need not be.  The offset of
the next response is advanced by the length pinned for the previous one,
so if a preceding command wrote its reply into the buffer and then
failed, smb2_set_err_rsp() pins only the short error response and the
next reply lands inside the area that has already been written.  Only
the header is cleared there:

	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);

The client then receives up to 31 bytes of a response it was not meant
to see, including one that failed with an access denied error.

Clear the structure before filling it in.  As a side effect
version_string is now NUL terminated.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Suggested-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 76f63f9adc72..a66a7a12477b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6092,6 +6092,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		struct object_id_info *info;
 
 		info = (struct object_id_info *)(rsp->Buffer);
+		memset(info, 0, sizeof(*info));
 
 		if (path.mnt->mnt_sb->s_uuid_len == 16)
 			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,
-- 
2.48.1

