Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14694137923
	for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785056498; cv=none; b=POUiPbf5TZa+EBGOw1KTuCaTDoOTb/XtuNDGuTys9OZvr2e9FDoEEjzibVronWGoXrv4BpGQmvFSHKgtRZ+sZ03WhNodG3R5rqX0LTTgTgjTWcTTRQ708WwtKj+P+dvxtkiesTp08KkfydLRBJlrriKManJMHJM29fmUVNaQ820=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785056498; c=relaxed/simple;
	bh=Aievdx0w/SM9Zsf/b1KeCX9g/dKM/kRkh+z8h+qZdRc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VhKl57puGoXdffSKL99jgbMyOBw+5GljO9OlMJM5IrFPaTdjY2d8NRsS37Sr207KQhx9Nn3+cRhdVmOr1KAJUJACQ0TGi+5AiCW7GnEqtvYqg5ABfvqfUPzcOsfNd/cNjwAvYjuYr9nOPCIaOzv4I9KWYQFYtw4/ftBnvhZGB/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=trYEgDpG; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="trYEgDpG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785056491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xctQN7KipYIb66H7YvezATVXOsQlaYbXyTZtfDQISwc=;
	b=trYEgDpGHvfQjRYVq3NMQqK/GBxhQkf6VCE3OqHaVJZ3c1GegBnQ+XsMmVGzh5s5uelACt
	dgQEgHz3HfXNTVRbm7NsjuimGXWlkyhkLVF2fJqrLI0gbtGmSsi0bVJavBPmqJUBbn3HQE
	N763nUxytscEU9uMiW683fQ0x28GeGGGFVJuWOBOYHUrzxPM1KIjx03Qj2KD97ELw4LjA9
	oT/29U7utRY4aEat6GZbx6qbdaT6ZLnB7vmuyBbUHK47MgDHP0b7tkdzsxIRSUxRw+PTgy
	Sco12jz+ABh0SWFwSxZmK3zt5b82h9s05/SgveRQepj5bbujU9XyK+euPI4lAA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: fix unbuffered file position alignment check
Date: Sun, 26 Jul 2026 09:01:08 +0000
Message-ID: <20260726090108.20938-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

FILE_NO_INTERMEDIATE_BUFFERING is a CreateOptions flag and can be
combined with other flags, such as FILE_NON_DIRECTORY_FILE.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8e5dfb079f5b..7e0be7602625 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7915,7 +7915,7 @@ static int set_file_position_info(struct ksmbd_file *fp,
 	sector_size = inode->i_sb->s_blocksize;
 
 	if (current_byte_offset < 0 ||
-	    (fp->coption == FILE_NO_INTERMEDIATE_BUFFERING_LE &&
+	    (fp->coption & FILE_NO_INTERMEDIATE_BUFFERING_LE &&
 	     current_byte_offset & (sector_size - 1))) {
 		pr_err("CurrentByteOffset is not valid : %llu\n",
 		       current_byte_offset);
-- 
2.54.0

