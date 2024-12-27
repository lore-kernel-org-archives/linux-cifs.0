Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25F1FB3;
	Fri, 27 Dec 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321065; cv=none; b=WV8GjmWVqu00UtE8aXtAdK/MwYg2NWf3qAXj3RWNpnN4kn8zXsK4vZLcagOjFPS7asm+3dm+EyCbKnD67hhY4GeYvjfudchOEjIZnQu8SM04zDJxrkhwCcpdDlRKy6rw3TOUC3qw+dD3JxnqX0k666wnrwwARPLXOigKX4hwdIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321065; c=relaxed/simple;
	bh=uDqFInCGOc8e1/aXu//sY4ymzJGOuMhBil//vuai3PE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=R0Z6N8eTF9BEj9/zcPHmrPumhWYD9zdnKhtPlflZBT51rx4y3xNhuf8vOy/lwEQOm7e1asevlbGxo6lsy5KpDtbiSM02Dk+x2oR7vsPJgaWYhBW0LpBU2O+PHfaBmZ5EY0DrhjTRkNbBBUP3G/0US2RbLaA805mN3gJE/VkdAmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzDOZBmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzDOZBmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1F7C4CED0;
	Fri, 27 Dec 2024 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321064;
	bh=uDqFInCGOc8e1/aXu//sY4ymzJGOuMhBil//vuai3PE=;
	h=From:To:Cc:Subject:Date:From;
	b=UzDOZBmOE8y1OqRABTPznEnEPe5kKOlV7QccNeej6YFjMHwpWDyl+vjksWIIzMZuZ
	 u97fyEAWoAPWZO6WxbiZofS8dFZx7UgU40PuMSoOZxLe4Oy3qTkfzS38awq5Hij7LL
	 gf1z3xtIAE53+VyA8gr7RuYIGKUS7tKS6MQ5YtExpQPfVfOZrvayQjgwZYmkNSWdPA
	 haskhnVzihy55wHtpG1yJHPYDx7irFT1qMzFEcNwDDa1aUja7hHuSPB24hgaFJqBvJ
	 bNEN6UwQLdkUGJB1p0p6EvkjyMUpD9t+Vu74zH2bkSVnUIx394LAq/rK/nc3Mh+iX6
	 csfv+3PhvtaNA==
Received: by pali.im (Postfix)
	id 94676787; Fri, 27 Dec 2024 18:37:35 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cifs: Add missing NT_STATUS_* codes from nterr.h to nterr.c
Date: Fri, 27 Dec 2024 18:37:08 +0100
Message-Id: <20241227173709.22892-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This allows cifs_print_status() to show string representation also for
these error codes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/nterr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 777431912e64..8f0bc441295e 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -13,6 +13,13 @@
 
 const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_OK", NT_STATUS_OK},
+	{"NT_STATUS_MEDIA_CHANGED", NT_STATUS_MEDIA_CHANGED},
+	{"NT_STATUS_END_OF_MEDIA", NT_STATUS_END_OF_MEDIA},
+	{"NT_STATUS_MEDIA_CHECK", NT_STATUS_MEDIA_CHECK},
+	{"NT_STATUS_NO_DATA_DETECTED", NT_STATUS_NO_DATA_DETECTED},
+	{"NT_STATUS_STOPPED_ON_SYMLINK", NT_STATUS_STOPPED_ON_SYMLINK},
+	{"NT_STATUS_DEVICE_REQUIRES_CLEANING", NT_STATUS_DEVICE_REQUIRES_CLEANING},
+	{"NT_STATUS_DEVICE_DOOR_OPEN", NT_STATUS_DEVICE_DOOR_OPEN},
 	{"NT_STATUS_UNSUCCESSFUL", NT_STATUS_UNSUCCESSFUL},
 	{"NT_STATUS_NOT_IMPLEMENTED", NT_STATUS_NOT_IMPLEMENTED},
 	{"NT_STATUS_INVALID_INFO_CLASS", NT_STATUS_INVALID_INFO_CLASS},
@@ -671,5 +678,6 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
 	{"NT_STATUS_SOME_UNMAPPED", NT_STATUS_SOME_UNMAPPED},
+	{"NT_STATUS_NO_SUCH_JOB", NT_STATUS_NO_SUCH_JOB},
 	{NULL, 0}
 };
-- 
2.20.1

