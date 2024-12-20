Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C2722D4FA;
	Fri, 20 Dec 2024 17:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734714789; cv=none; b=i3nuNsqVCLTuExZ4nq8qw3iaVWU3iKM2ZXODOb+SVCeK1sTpdnKqwy6Wgbk/xtkOUoVVqgQMbLFuklcfkMpo/xPcjjRCI7+RrVyf8jIEbJuVzISZN5PqhbRIrsPMdqaux9byPY1skfRvtLzkYek3YXXM7AfYocwWkwf5W3JtCjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734714789; c=relaxed/simple;
	bh=EqPQ4cEPLTgDiPSzJhPqpPG2y+jVSgFiisHwzVWFWH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WRhTEZXCmO+pCBbIZVW918twKsdvDq1g2MnkvXiu5lUYlcVrrG4fZhhhejUE0HtBgoW2wTTOBQVn3BwolxgMdT7v5MVaAEzt3IbihvjZE3IumtwNu6ysvinOXUK05dFQUWLDJZYjFmxYec76KVuHFU0uDdhymTQdcqJcs3i8IbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBPUzfjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBPUzfjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE4AC4CED7;
	Fri, 20 Dec 2024 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734714788;
	bh=EqPQ4cEPLTgDiPSzJhPqpPG2y+jVSgFiisHwzVWFWH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBPUzfjyGQat4NEt7AYFKpsp2976oXGAGwLsg36Le9MBSpAAZXSYcl3iVmHW/UfGN
	 kx0e9LVkJcKUH8ydGMgLooIxw09Z7Rz/MQelfQmZua0R5MS+Sdxq95rsadodo6HuU8
	 dPGGqTF6YeGPhh+WjMsM8KIJbsos+1/xursb4KcH/7CNi4HW4X0X1adjhIf/en9+2U
	 7yPwXbjQU2hk2zV87l1Kb5/S58StOUsNwvQrLHW0vBbjvXTzlg0UjKNOgds+bI9ZeR
	 RtVYFb4V0/pDSjlXlptfY6g+RCQSk/24aDd1oSOok5bejPWm8d5ziMi56Hcw9hL8fQ
	 8VvmWE7wfWtiQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 12/16] smb: client: destroy cfid_put_wq on module exit
Date: Fri, 20 Dec 2024 12:12:36 -0500
Message-Id: <20241220171240.511904-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241220171240.511904-1-sashal@kernel.org>
References: <20241220171240.511904-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.67
Content-Transfer-Encoding: 8bit

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 633609c48a358134d3f8ef8241dff24841577f58 ]

Fix potential problem in rmmod

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6ed0f2548232..bbb0ef18d7b8 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2015,6 +2015,7 @@ exit_cifs(void)
 	destroy_workqueue(decrypt_wq);
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
+	destroy_workqueue(cfid_put_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
-- 
2.39.5

