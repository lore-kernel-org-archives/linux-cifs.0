Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6028B186F
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 04:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705637860; cv=pass; b=MlRG/coco3EurBTWAc6+d3AgXnNeoj6AgsGKrqHEdcsIe+TYECnZyb8sTszQAyRxIdbUT4UV6fcx032L8UlliEQRIhaxm9H3RFfGcrLc8pfHSXaCA/RoW/GBKoW4yEeqlTdmBF6UI6L+O3HGEp0jSHFICLaWEY/6LP4VJvbttyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705637860; c=relaxed/simple;
	bh=8DH+rSihr7hssjNPF7HAH8EZiD34frowXjjKIzvqvT8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TOtvUAJD9eaC9fd2xF8VKhcflevS/MGtv+DFiM8wmC8eepysZOZPEqRDUquutWBeg5eg7tEEtPLt2QOV1BpIpu+3WOpAvGzKe/bLo5JMjaJQymKKp20eobMCEjC/f93OeGRBxBhe9DsMkCBNh26owMI9d+Fuz+o6KkU+YvHrVzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=f/LGLYQy; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="f/LGLYQy"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1705637317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lQwfKdKQdo93cpIYUjuG4n8+lJ/pRJtObm9TULEi0YQ=;
	b=f/LGLYQyzmMc5U6o5tQaWcW7Lf/mHsjHAyeCzk8U/9uy4SajgKFZwvPKxsdILR+0hm64QG
	ENnFlZPc/NO2n8yw96RW6dsfiXmKDCvbopyhBievg8pdWFvHo+XvSFafbiuZZ2upf+G5Mq
	GKiO10Ob5V/LgqL3ny2pCyo9BY/vREgnkxZ7LhwDromslYfPlb3/ni70zsWZVfRcLo36vb
	tqm15arVxrXuvvZQQ3DL0HURhS9DBh2iDXj5E9rdC/0DB8zIdW7R6i9GY2YYZXINCBXsgT
	qfJrAocs3bDuvW3pi6POMu0pku1+4cIFyqn+VXZ+/K5RzQdEIFbvintRs6aWuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1705637317; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=lQwfKdKQdo93cpIYUjuG4n8+lJ/pRJtObm9TULEi0YQ=;
	b=qMJaXx6t6b5vf6iFlylf62SuZrAxenCVcZq98hmrCaihFfUBVtlL4WWKN8MtynDRUcd9m6
	WA+YQsGO7J34yKjxzf+5wsXzw+sDclSD38hs7lk162N9a5GCy6xXLoC1YLjwTMtnsIG3GC
	k0kEigm78CUqyzQ0IFl3uF8/cC86zmMvUX67zkXkqpSl1mPGIFitSD8nTLx5GtlJcvaG5B
	sECv6k9GkLYmnEuw0tfvvzmjFoAoO3+bRrHp2f5MJapyBrO+zavcus9csykK7rq04CMZS1
	KJ9PgqG3byjOQbRg2fPaFWT2S/PDJg0nrTY1MDdVImQXsPlTh/EMvWzaKyWBmA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1705637317; a=rsa-sha256;
	cv=none;
	b=G2MorgTKf1AeIzfnB/5ZN5bkTEQ5QJL6eIisfLUIx3e+nPT4SdLhysnl/kWuJBaXb8q1MW
	hDkqMyLhQly2+wdv10yH61//Z0DNdvc0IZ/4Q2ipbNC3focTQnbbf/CEwgbbKALKZUWgZt
	++06Ukw4u2MgvJTZAf7LZwdI7NE8YEkfOeWeoYpgAhenHmib0suUZBGsRRQDbawL1oJ0xN
	J4YLICb0QaWy+XEGa0CMg93VAB0rF62ew6Fx5pQTnxrFBfzbrNlExauBQm+SDgF069OydA
	1aL2hSRJiGExq1emXtDmnEOnpTrqEk5qReSuvMuKnbEemopoZdTnxGG62tLskg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 1/4] smb: client: fix parsing of SMB3.1.1 POSIX create context
Date: Fri, 19 Jan 2024 01:08:26 -0300
Message-ID: <20240119040829.18428-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The data offset for the SMB3.1.1 POSIX create context will always be
8-byte aligned so having the check 'noff + nlen >= doff' in
smb2_parse_contexts() is wrong as it will lead to -EINVAL because noff
+ nlen == doff.

Fix the sanity check to correctly handle aligned create context data.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 44abd4deb9eb..288199f0b987 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2308,7 +2308,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen >= doff)
+		if (noff + nlen > doff)
 			return -EINVAL;
 
 		name = (char *)cc + noff;
-- 
2.43.0

