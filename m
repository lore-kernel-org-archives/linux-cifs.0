Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86C8408608;
	Thu, 11 Jun 2026 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781192542; cv=none; b=lOTPwfGRdn5JIbKx7kFMf0u9ubfRDMBEUUbdNyLHVTwCJ1AXJYzR9RcXp86WyJ35TVyuFygcWtilg6XEGWkNUkeiyilKTCAGn8EudbQBd3lzokM1Y1Cwa0QGTjRh1sI+IGdDUS3JVCd35uv+kRloyXrg8RBKLIN8sMepyf/ftH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781192542; c=relaxed/simple;
	bh=3rJ2KIAt5Qekidf6ayFD/V9jH7JnMuFKFXlhNV1vehs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=IQa2K9iWreDHcoCb/VXc29gHMTlgKjTgYnhFhySVDWi7v3fygz9dWOX6hJorxBaR7qLmd1JhrfjKdmyA18KTxhcxkke/gLhq7901O4/8wHWKiyyu8ga/JhivyEXHuPm1UxTlmg0X7uI11jL8vrtZYsJZ/0bYP7WLJKBW3HtZzUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=KYkAwZd/; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="KYkAwZd/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781192530; x=1781797330; i=markus.elfring@web.de;
	bh=TC414nfr9kv7aWjwVWIk5zquDi+fNOTFUYdZW0Ad2nk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=KYkAwZd/ST2A/cLNFnBIgFDqE8tEI2PXU6e66oTOS/QNOwX4vT+JoEO19r95fTY2
	 gKubmshqY3V7pFRGW4jkrxeHDPwChcM3/ks7n55ooChv47RAc0/gyhRv8h6iFDQ+H
	 qVa4vHA641HLNS8Et9pDCbRJ9E/oNv74NBNTYyd53KUrxQLwxfM+MaeaImjFh7mKq
	 2fE5561YBXInEfS0MFH5jABz/IHdEJXVZcNFg4S44NSleoaCgRTZsGhXtb0JjlOcR
	 q8jSXhT5NY1EY/fAC12qNuMgJCNypu6KSErH/bHYKCZ4jBxrbVhhRWObsqzOYHZcv
	 5tC9tfPPex1r2xs/sA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MkElZ-1ww50t2u3V-00dPBS; Thu, 11
 Jun 2026 17:42:10 +0200
Message-ID: <328ba830-24f6-4358-b88f-9aec843ecf14@web.de>
Date: Thu, 11 Jun 2026 17:42:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Use more common error handling code in
 smb3_reconfigure()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tRHOrCTt/wJyHTqmWy1ofcnZ9YPjQfZ4DZ4tfzSnhy0yq3kvmxA
 MzVci56jtmL2wxIfJoZRDjRfeXQtIL6Txx/1y8OvamLwMGbf3nENBYRGhU4NyYGepRTQkG0
 IOitKJFSRa0vFB3erEI4Hn76JK888krGZ9sQ5FDERnCP71h4o+eO5oX877uUl5qFpIJ62zK
 3FvojQIjvdF+NHeL3W+eQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+CSzs/aTPRk=;gZAzBzAbF5hMBUPJ3j1/iZBOGpo
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 11 Jun 2026 17:33:39 +0200

Use an additional label so that a bit of exception handling can be better
reused at the end of this function implementation.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/fs_context.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index fd4b13cd654d..9addc74ce57e 100644
=2D-- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1092,10 +1092,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 		return -ENOMEM;
=20
 	rc =3D smb3_fs_context_dup(old_ctx, cifs_sb->ctx);
-	if (rc) {
-		kfree(old_ctx);
-		return rc;
-	}
+	if (rc)
+		goto free_old_ctx;
=20
 	/*
 	 * We can not change UNC/username/password/domainname/
@@ -1244,6 +1242,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	kfree_sensitive(new_password2);
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	memcpy(cifs_sb->ctx, old_ctx, sizeof(*old_ctx));
+free_old_ctx:
 	kfree(old_ctx);
=20
 	return rc;
=2D-=20
2.54.0

