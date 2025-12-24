Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CD93375CF;
	Wed, 24 Dec 2025 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766589730; cv=none; b=XfwIwom6UmnGtSLtlFuu2VC41MFIGJB1EMiVXkbf/p/XWtvf762xIXFMW9n+kg711YoWE4+io+NdPCP4mFyZVGXGlPuXIy6L3ZN5eW0DqDE0niBSy736kjsm3NccSv26X+a2K9iJ+e+bA6CcW8cmRWC0olhBnFK3lRwzqBcnR0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766589730; c=relaxed/simple;
	bh=g7w8hgqIWKLISknvyKXjyaEdHWYWykgt1OU77sKUg4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pryDaD00DQFLQQC7XbEK1NjosPAxOZ5joMUDcmhtDv07nOYFpnKxdauWf1CZJN/KOntAwa6dpg50crz8l/DTt9tN3CxJ3b8NTu16ERYuCxNF5MoFOV2zW0DZREQm0JlzeeNLUhR4FSRtimJQp16qRG1/N54Mv4cT5pKf/OsNQ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=bWmfvyjt; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="bWmfvyjt"
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2e711aa86;
	Wed, 24 Dec 2025 23:22:00 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] cifs: Fix memory and information leak in smb3_reconfigure()
Date: Wed, 24 Dec 2025 15:21:42 +0000
Message-Id: <20251224152142.289149-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b50f3e6c903a1kunm84039ed764cf
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaTBofVh1DTkNKSU0YTB0dSFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZS1VLVUtVS1kG
DKIM-Signature: a=rsa-sha256;
	b=bWmfvyjt+g94491/MSO2GDY64i0zCLR8+7HX6Cl33Kj4FBcLWblVGIe7JZ8e8ImyK++QG+QPJzoXppbbWxj7SbR0cJoVod+yZLDrAnBdLOdBOvLtFD71BRZcEzQrzSczS7fZftzHe/OQmkSMnSDVOPjscZL9kni1T0AlWCzQOEI=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=YcxD7sb3QoYmKlw0INPtct0ojh0YRT/jt43zI19f9zg=;
	h=date:mime-version:subject:message-id:from;

In smb3_reconfigure(), if smb3_sync_session_ctx_passwords() fails, the
function returns immediately without freeing and erasing the newly
allocated new_password and new_password2. This causes both a memory leak
and a potential information leak.

Fix this by calling kfree_sensitive() on both password buffers before
returning in this error case.

Fixes: 0f0e357902957 ("cifs: during remount, make sure passwords are in sync")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index c2de97e4ad59..d4291d3a9a48 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1139,6 +1139,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		kfree_sensitive(new_password);
+		kfree_sensitive(new_password2);
 		return rc;
 	}
 
-- 
2.34.1

