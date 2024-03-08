Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEC61DDFA
	for <linux-cifs@vger.kernel.org>; Fri,  8 Mar 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709910409; cv=pass; b=GPQWUo7sFmXqB/pjff81qWxnG4sC3NoetoZnhlmZyKQ1F7v7BXe5HpzPTJzBbwnfdjD0wwH4JOooLmi+lu63yFWqdOPqSl+qyN7jKHcS1kfGwTKRw+2zf8Z4gz9H2OKAsSGtDVatfcnG05XVAi6r3FzjKAm6IXVHLI0pvpoiObs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709910409; c=relaxed/simple;
	bh=jpjM2BY08+eXAlMyZytKT6UyVQT48Ap0QywUAIbtciI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RoTPoRchXRQHTAeXVrmfwXW5GuXPB40R/P/8d+isniLZao/l6zBhJfwj4uXbWacOy5LTG6TWEXjKcfDreosv1Quepb80OE5WF2BzZqjrLRrknv27GXAkslMIIRFVmzWvq8cXDeuLdV5APLAZfTJWL7J6Vf2XnUTCj0+SIzOZy30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=pv70c0it; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="pv70c0it"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709910399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=drUBuRpBrYjImBRIjowgNCrUttKS3pWI4B5MFqZprN4=;
	b=pv70c0iteBAxZbkmE8ehyOpE9ZQUu2uOs3OvzXqVFTq453coE7cQtKh6k8FWfk9QjtlI0+
	dp1QPWBuXYumB3I3TA9HKF8OPoxlXToVZddjOoe28bhaVYcWeP9dXMZ/93Sr6H6LxbYpTq
	JEIdSVX4erejo7ZNC5k+UcW2hSpZif8oZ+e4JI7LlNzikN9dnl3ZVgaYzJy+EKCGUu5Pj1
	lajoe+BXsNT0SEvYeDeoJX+JoYwaHBId3Cku2t4wuXuC5oKqvoxvL/7y+tj34wJplvA4Np
	S4Wu35GcBrcC+qFuuLJN5YrTTDDV/B8+bBOWScZ2mqW5Gzjv1SqDgbpaUvpngw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709910399; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=drUBuRpBrYjImBRIjowgNCrUttKS3pWI4B5MFqZprN4=;
	b=C1cwhiHIVRSN1gVersQCZWZqW5GbMwkVBBl20QuTeNictd3PJBvN9K92ZhvapH75YIVkje
	F6GlM++4Nr6IhViDdue+mxbrVC3a7zB67mpOi0doXMXmrOYCHKUotPCF0DSs09TA4JwzYp
	zkTN8w6EuntyALOcZkxg7ZOsO86AXtuRL9hkpVRpiwX2GaKlPfYhrsiol1xIxz3wGbBs9g
	+qen15Thp4JEczAH6ScaSx7vwWVs3uxGTDLv55F9MlwI9XyVGosbYiGP/E7AE1pakTyuzg
	pEnlmApewJ95x3Ob1Wto0fwr9UF/9jmsw85WbQm9gZHm2kwluSQ5yh651jupcA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1709910399; a=rsa-sha256;
	cv=none;
	b=mq4oqwukXBRAkaIqwIY64y1Ephpefu4s9K0McpoBqXkFMJCG4YEdPbNziiRR3V/6ksTHKC
	WqX42Y5AzrPucjkZeOeZ0lNS4/2giCx24XtjwWUtumPPGmKJNH1N59ZMnhqaXywwh2jN55
	SH/h347rnoovHMaF76KURPGgpnMoHtL3rGE9qEbu6w565Tyxm664FO4S+zBmR4db3aUx8f
	VvPNQKoAJ8SYGWqlYQYjkebU5/69BgWaEBLCYUh9ENzNmcGrtI9oXEbkIX8jXpHHOOZaLJ
	Mg6W4zlAwi4XhfNxmZuu7FBEW59PRJq2qvV9N9OKNnKMsPIc9DdIbifGuEnbLQ==
To: piastryyy@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] cifs.upcall: fix UAF in get_cachename_from_process_env()
Date: Fri,  8 Mar 2024 12:06:15 -0300
Message-ID: <20240308150615.339103-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Whether lseek(2) fails or @bufsize * 2 > ENV_BUF_MAX, then @buf would
end up being freed twice.  For instance:

  cifs-utils-7.0/cifs.upcall.c:501: freed_arg: "free" frees "buf".
  cifs-utils-7.0/cifs.upcall.c:524: double_free: Calling "free" frees
  pointer "buf" which has already been freed.
    522|           }
    523|   out_close:
    524|->         free(buf);
    525|           close(fd);
    526|           return cachename;

Fix this by setting @buf to NULL after freeing it to prevent UAF.

Fixes: ed97e4ecab4e ("cifs.upcall: allow scraping of KRB5CCNAME out of initiating task's /proc/<pid>/environ file")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 cifs.upcall.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 52c03280dbe0..ff6f2bd271bc 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -498,10 +498,11 @@ retry:
 		/* We read to the end of the buffer. Double and try again */
 		syslog(LOG_DEBUG, "%s: read to end of buffer (%zu bytes)\n",
 					__func__, bufsize);
-		free(buf);
-		bufsize *= 2;
 		if (lseek(fd, 0, SEEK_SET) < 0)
 			goto out_close;
+		free(buf);
+		buf = NULL;
+		bufsize *= 2;
 		goto retry;
 	}
 
-- 
2.44.0

