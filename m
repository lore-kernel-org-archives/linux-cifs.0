Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1968B1B4124;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=d2VP69XHeOh4+//tFeNLZgszrCAOFITEKPROMHNxIhrjOH3ZgcGSxfoYvCo0t1bFbY+CnRmKNpeML7QcvWIovl7D83rqyaQeu/nC4hjR2roDQfY+OWKoqt9W9B1pKuKK69ONscTfuwcJnBiOMbGcxgTxtTB0+A5xytJ1WUM1hIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=qeIuosm52zyCma7WnhBPMzKwH4sWBW0yo2xCyxH0MpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2CTX0oKYJpO8761zojuSxiEFejufSzHKvZ4wdx3ZN2/ZyCGC51Elr//XYnkhlAIzbRGejJ2vk7NE4N1wl278cRn4JIYq5DJIAGwmhQc/Z8MLD3iq7y0OZxmG+1MqXJUq9Hp3bHaAQUKXSHiPHAfidtUXVCuO5oFNOu3PsW88oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQs/EV76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQs/EV76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D43C4CEDE;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684629;
	bh=qeIuosm52zyCma7WnhBPMzKwH4sWBW0yo2xCyxH0MpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQs/EV76vlGzoTfAno8Y9kBSDzSQyzRpRNrxPhdQkFLVRXY0dzgigPMyp6FsuhOxF
	 PZOMDf/bKhPlfsiz1C2dZUhsAtanccn5QWMnOABxQfTiStZEaLRJMCA7G0mbHMHt5K
	 TLczRRsHvMnDeCuXIvJ93NQuWeSsbeN6NWQuDEVXoETG0guXpzvL3QM4NLnBJslFD9
	 fW1LgH/UWRmPCBlCAIs6knVvwujVekFjr2SYpNiLVuCoUy/V5GQBalsNV6BW7ziRKS
	 SQwjjt5xtWVzDJIoLSvsNFXrflQoAUGr0sjSS1gYLMfb2HE/vJ2sO+1vMTu/Qk/7dm
	 IibLmdzjWVucg==
Received: by pali.im (Postfix)
	id 7C7B898C; Tue, 31 Dec 2024 23:37:00 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] cifs: Optimize CIFSFindFirst() response when not searching
Date: Tue, 31 Dec 2024 23:36:33 +0100
Message-Id: <20241231223642.15722-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When not searching for child entries with msearch wildcard pattern then ask
server just for one output entry. There is no need to ask for more entries
as we are interested only for one search result, as we are doing query on
path.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 7c42a0651138..c0dc404e27b3 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4155,7 +4155,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->SearchAttributes =
 	    cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM |
 			ATTR_DIRECTORY);
-	pSMB->SearchCount = cpu_to_le16(CIFSMaxBufSize/sizeof(FILE_UNIX_INFO));
+	pSMB->SearchCount = cpu_to_le16(msearch ? CIFSMaxBufSize/sizeof(FILE_UNIX_INFO) : 1);
 	pSMB->SearchFlags = cpu_to_le16(search_flags);
 	pSMB->InformationLevel = cpu_to_le16(psrch_inf->info_level);
 
-- 
2.20.1

