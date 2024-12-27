Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6301F193D;
	Fri, 27 Dec 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321065; cv=none; b=TDu43o+HkE9Oe22T4C6sbqCDNorwGRWYcD8yMF5ua3+WoW1upJysRRf7/RBxkjMPswloxenvD/N55r9d1BtWMqNkWCfOGV87i/fjkEhJBdqF648DJjN2nGBuAdGf86W4LHcG6ELpZ206AAiVHZpyRM8JtJ4fkl9wMMB54LtQfuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321065; c=relaxed/simple;
	bh=zsciCc+G3yWkPmO1bpAYGsf+PqHWqocZf5EgXLpfcuE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bd9q1pPJOMUKgAVJwJxv6cP2188zuBSyHKUyhcdksY9rLQ3d+jSb0e+r9a5WJjO14jOsL0tmJmz9Q7q7GcYxml7yT4M2/dOE3RZs6MWU8wG8OUmnx62D0GAE71GMUu/KrWDrKs7XQ1aWO/6eT1GffDteM6GpF+UGC+VRPdQBCZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uJrkFgnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJrkFgnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF49C4CED6;
	Fri, 27 Dec 2024 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321065;
	bh=zsciCc+G3yWkPmO1bpAYGsf+PqHWqocZf5EgXLpfcuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJrkFgntIMo/b0vpPWlGFj3W2aQTgDyO0XWiZq/s+zZ7Soprbblt8T2NK6wGsSpBI
	 uApmKV1ueN+arRwWcAxrCAWuZ5GATuB2MVRtqzkpf1saTnBmRIz999Q9KfoTwmb+XS
	 OfZtp9FLNZPuI0m7gd3nfpCqfvp5Xs3yHx+CWosSMYzJ7CGMXc882avoZSfn4kYg9A
	 WvQlqsANpWaYiqFRVTP/atWPD9aQbtw70ngS8iP9ooCJgPRoGOSAeq5SuMRgYknsZy
	 HeT84xyxe2NPBxGZBbK8NzoUOBKy4gG/7UECokhxAiGL8lDA+GJVBS+rzrcJbAlUat
	 DpsunHoZEp7sg==
Received: by pali.im (Postfix)
	id B37F6A7C; Fri, 27 Dec 2024 18:37:35 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cifs: Fix printing Status code into dmesg
Date: Fri, 27 Dec 2024 18:37:09 +0100
Message-Id: <20241227173709.22892-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241227173709.22892-1-pali@kernel.org>
References: <20241227173709.22892-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

NT Status code is 32-bit number, so for comparing two NT Status codes is
needed to check all 32 bits, and not just low 24 bits.

Before this change kernel printed message:
"Status code returned 0x8000002d NT_STATUS_NOT_COMMITTED"

It was incorrect as because NT_STATUS_NOT_COMMITTED is defined as
0xC000002d and 0x8000002d has defined name NT_STATUS_STOPPED_ON_SYMLINK.

With this change kernel prints message:
"Status code returned 0x8000002d NT_STATUS_STOPPED_ON_SYMLINK"

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/netmisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 0ff3ccc7a356..4832bc9da598 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -775,10 +775,10 @@ cifs_print_status(__u32 status_code)
 	int idx = 0;
 
 	while (nt_errs[idx].nt_errstr != NULL) {
-		if (((nt_errs[idx].nt_errcode) & 0xFFFFFF) ==
-		    (status_code & 0xFFFFFF)) {
+		if (nt_errs[idx].nt_errcode == status_code) {
 			pr_notice("Status code returned 0x%08x %s\n",
 				  status_code, nt_errs[idx].nt_errstr);
+			return;
 		}
 		idx++;
 	}
-- 
2.20.1

