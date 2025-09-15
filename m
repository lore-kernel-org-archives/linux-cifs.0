Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB362C3244;
	Mon, 15 Sep 2025 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757949607; cv=none; b=F4FPx+pEKutLr8atwXz8AgLXJZsMUxdOmU7mnmBgW1HZWqfXKeinw5Uc6wdwk0lKalRc4m0/2e6i5svrd4xdwFxwPdI3RpXHwydICw/DosV9H37cuo5BBqtlGUzt1g5fhjCFpR2X6lbtJEfODFVpDxQPK+9Uj/oZf2eyqsqNr38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757949607; c=relaxed/simple;
	bh=NXuP5K9byF+0SV2cRgyBBWxmcgD6qytN28Kfpsj6cIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEQZANMygiefm5gTS+fV1/JRgEvhBPysP/j+mwVeLSYrgqwnnzGhqUSHB0rC8NS3qc5e/Ky6pjNeJ/y9WEDE0fPuidx1ISG62Twtxdt1a84HlMuy0Tb4yDIjIZmEmekCc9eiGO9/jG4SvnC0NYXksmWEMkskYOiKAw6uc99Y2A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id EB1C64BCAA;
	Mon, 15 Sep 2025 17:19:56 +0200 (CEST)
From: Fiona Ebner <f.ebner@proxmox.com>
To: linux-kernel@vger.kernel.org
Cc: samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org,
	bharathsm@microsoft.com,
	tom@talpey.com,
	sprasad@microsoft.com,
	ronniesahlberg@gmail.com,
	pc@manguebit.org,
	sfrench@samba.org
Subject: [PATCH 2/2] smb: client: transport: minor indentation style fix
Date: Mon, 15 Sep 2025 17:19:40 +0200
Message-ID: <20250915151950.1017597-3-f.ebner@proxmox.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915151950.1017597-1-f.ebner@proxmox.com>
References: <20250915151950.1017597-1-f.ebner@proxmox.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1757949589741

Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
---
 fs/smb/client/transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 940e90107134..051cd9dbba13 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -331,8 +331,7 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 				break;
 			total_len += sent;
 		}
-
-}
+	}
 
 unmask:
 	sigprocmask(SIG_SETMASK, &oldmask, NULL);
-- 
2.47.2


