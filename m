Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 983B8199FC9;
	Mon, 14 Oct 2024 11:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728905674; cv=none; b=Rc6mbuwBRQPXFs/Krmkuu8ugwQSDbkoUHfrVhHh9bUjYESLRXM+JFvhGn4F+yzedxT8WS2YIMJNqDkjeRiqCL9UQg8EiQWYg+UuxsHkzXq80JW6NIgeql0Vb4tbxyVrC324XG37ZBmVZFBa0ItPP0BTrgDi9rrkAvz7kfAyJHXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728905674; c=relaxed/simple;
	bh=ThPRdg45K9j18k7kJQg4d7R/8No7KsuZx8IRz4txea8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Ro85D6dSzmd+G0MaGTXmIDYucWlaiCkLbZf3JA152vsDScrfhaXjKx20b0+lUbFryakiZmCeyyeOJFSnaq5A7zXy0vqdvNJNwBvItN1f7vrcRj1Do4Z85frIwkX1FUpB5cn2BZLDWggt/BTEnjUnuEoN11loUiq/bX7BP200pkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id B34606019980E;
	Mon, 14 Oct 2024 19:34:23 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	stfrench@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com
Cc: Su Hui <suhui@nfschina.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] smb: client: fix possible double free in smb2_set_ea()
Date: Mon, 14 Oct 2024 19:34:17 +0800
Message-Id: <20241014113416.2280986-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Clang static checker(scan-build) warning：
fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
 1304 |         kfree(ea);
      |         ^~~~~~~~~

There is a double free in such case:
'ea is initialized to NULL' -> 'first successful memory allocation for
ea' -> 'something failed, goto sea_exit' -> 'first memory release for ea'
-> 'goto replay_again' -> 'second goto sea_exit before allocate memory
for ea' -> 'second memory release for ea resulted in double free'.

Assign NULL value to 'ea' after 'kfree(ea)', it can fix this double free
problem.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/smb/client/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6b385fce3f2a..5b42b352b703 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1302,6 +1302,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
  sea_exit:
 	kfree(ea);
+	ea = NULL;
 	SMB2_open_free(&rqst[0]);
 	SMB2_set_info_free(&rqst[1]);
 	SMB2_close_free(&rqst[2]);
-- 
2.30.2

