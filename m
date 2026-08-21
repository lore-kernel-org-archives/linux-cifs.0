Received: from mail.amicon.ru (unknown [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA566495052;
	Fri, 21 Aug 2026 13:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787320703; cv=none; b=LUPUgN5RgYCFyeyViqiWGLmxsikYNCK3flESGPlGaSe0D8GpQT3+ksRTT4moj4LmIRlAjnkc0zHgweDIVhPW0du12aZaDpLVWDWd8qshRVNiigIejDsdXvawN08WXAc6/P++uj3Le7XknLje/S5CTdP9DpHQQQv3/GqJbTO601o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787320703; c=relaxed/simple;
	bh=4NRiuqHjhLyQpQOlmog02/Mc6oiOKU1lqvYBdfl74ys=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:MIME-Version; b=qRNrTcM2ch7/cvlohHHicEm2YXiHaTzTDRJksKRG11peYrcxHyXZS7vXRPOv7bMXrTMlcJJ1uKMk9KqeaEr927iW8IozaFUIj//6OPLw5R8XqKy/uWsSNCdETSfOo8Vib5yMkmsLN8NTlunkJX7HR826jWD1QtBZwLFLZ0huRfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=D42MY1kN; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="D42MY1kN"
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787320689; h=from:subject:to:date:message-id;
	bh=4NRiuqHjhLyQpQOlmog02/Mc6oiOKU1lqvYBdfl74ys=;
	b=D42MY1kNxwUxP1I2zz1IkZxy92yOI75hhXW6JX9ZBsFGmN1kax1LEjVArB/dZJq3OVoj/xOAWoH
	hlnchfN5dWapdjamaGWAd3djOrQ8QkSgec13er6tTgKl+ARXkX1DtyITE/jjWFaamOrzi/4KBvXM+
	cLJDbumngkbvp1ExavbaKUMuCAPuBDTTo8BVI0g/eGEnQ5LzYRbqt5McjxfXu/uvRneVPCDMivOK2
	yGu3CiLipn3Xi00tzHRbI0uaFuh836IB6MZbJ3aJhzOQ4tw6jY1+mHTSYS8+BuLjAF/1+PbVhv8Ll
	kFTKPZ0Y3cClaMegIRMLWc5dHMmv4zqtOzqw==
Received: from localhost.localdomain (192.168.0.250) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Fri, 21 Aug
 2026 16:58:09 +0300
From: Aleksandr Khromov <haa@amicon.ru>
To: <linkinjeon@kernel.org>, <sfrench@samba.org>
CC: <senozhatsky@chromium.org>, <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <haa@amicon.ru>, <rrv@amicon.ru>
Subject: [PATCH] ksmbd: zero the object ID before filling FS_OBJECT_ID_INFORMATION
Date: Fri, 21 Aug 2026 16:58:01 +0300
Message-ID: <20260821135801.3790290-1-haa@amicon.ru>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: mail.amicon.lan (192.168.0.59) To mail.amicon.lan
 (192.168.0.59)

FS_OBJECT_ID_INFORMATION reports 64 bytes to the client, so all 16 bytes
of object_id_info::objid are sent.  When the volume UUID is not available
only sizeof(stfs.f_fsid) (8 bytes) is copied, and the remaining 8 bytes
are whatever the response buffer holds.

The response buffer is zeroed on allocation (kzalloc()/kvzalloc()), so
for a standalone request the tail is zero.  In a compound request it need
not be: the offset of the next response is advanced by the length pinned
for the previous one, so if a preceding command wrote its reply into the
buffer and then failed, smb2_set_err_rsp() pins only the short error
response and the next reply lands inside the area already written.  Only
the header is cleared there:

	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);

Clear the field before filling it in.

Fixes: 3a64125730ca ("ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 76f63f9adc72..6f5f4a399bde 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6093,6 +6093,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info = (struct object_id_info *)(rsp->Buffer);
 
+		memset(info->objid, 0, sizeof(info->objid));
 		if (path.mnt->mnt_sb->s_uuid_len == 16)
 			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,
 					path.mnt->mnt_sb->s_uuid_len);
-- 
2.48.1

