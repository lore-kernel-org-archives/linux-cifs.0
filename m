Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9322CCB9
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 04:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766117836; cv=none; b=EInpypp/UDFaWhOIbruktJA+1jFUum+QfS7VOalZSqZ3UXUmL1fW8uMesx9hjCXQeHQmEhGQOdU+Wp9UnfjQpVdfwgvD6raTJ8kpvQZsnu+OCVLuWmptbZzCsFH/rTqGzOINkslkYsAjqE0+jXou0yWHeW9Gs68Gg4pVOphE6M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766117836; c=relaxed/simple;
	bh=mEoNNTH1vM2zatG4RJH4hg3KHBpbNPwSeqe16MqFrRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r0mX5zMq9UKSkim7M4eruBdBDCdikg1Nlp2MBwyaho5DN+RXw95IyowJZW+8xC+tqIiD/KkW0/RXze2NLCOkGdJLqfGmKZdb8/sSqV+JZpg/NUdqAHQZ/qFQd00EqizGYfDgpckyTqynxX9vzjPT2UH7FgFhiv4S0vlawvkPYAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BYbDKtFO; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BYbDKtFO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766117825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QN+cgnuK3gyY/Hufi+Zg3Z2fuR5oj8MiTz9EYX0qbBc=;
	b=BYbDKtFOWlKoT6mJ4lTG07xD040XPIaPobsQ5BXhZvUvSoEq/Vo7+RYjwmDEZCxofnLCXW
	xmUKAAWByB85nQPUJxIa9mu7J/UKGgqVzeYC046MdSG5Wrc+IMOBpFrgoavJ/PjSJr/FZy
	5q3CzeqtZvQ/YoRVBo02Fk4EcZH111s=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH cifs-utils] cifs.upcall: fix calloc() argument order in main()
Date: Fri, 19 Dec 2025 12:15:52 +0800
Message-ID: <20251219041552.317198-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The function prototype of `calloc` is:
  void *calloc (size_t __nmemb, size_t __size)

Fix the argument order to eliminate the build warning.

Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 cifs.upcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 69e27a3..08ee101 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1719,7 +1719,7 @@ retry_new_hostname:
 	/* pack SecurityBlob and SessionKey into downcall packet */
 	datalen =
 	    sizeof(struct cifs_spnego_msg) + secblob.length + sess_key.length;
-	keydata = (struct cifs_spnego_msg *)calloc(sizeof(char), datalen);
+	keydata = (struct cifs_spnego_msg *)calloc(datalen, sizeof(char));
 	if (!keydata) {
 		rc = 1;
 		goto out;
-- 
2.43.0

