Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E78715A4BF
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086490; cv=pass; b=SWvaiFJPUjZaUr/c6BSzsBNxH5SXiEnMd8Uzb1r6gQplInl5GBopriSe7YHLAkO4c/oFsVt7mjVuoYNP+tbTg3H+pNNbiZPXzNg3+Q+ND3qxUgLcJv6YovUiSYioa9Shf6Uj9xRVeuJERdEgo+i36YUgsRJIsc+zpr/OGW9BZKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086490; c=relaxed/simple;
	bh=OUoPlpwojIn1vNQdVRW1revNkh+kceML9MeP7IpgZQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdWtfRFNZ3f8Z7gXfRYxXNRC1apexTIjyljobCT34SbYTyV+d2QJcryOr47dU2a/tp6zIhxmYpcBVwLm/1JTtwjLXRkWGrSdYhkVODzsYuti9oB61yATrR/y7UudJA9gcPrBTVf1B4u5OLSJYR5A0ovScLBdcE515uTpOyWoXtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=THHMKVTz; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="THHMKVTz"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8LhCD9Y6XSW1yomWSIcKAk3XFngRWAzYK41UbGFhT0=;
	b=THHMKVTzFHUf4MTaoqMm02ocKakwq9geIf89siGXupBJHRI7KwIyYavdmovYfnzP0LkeYz
	Cz2tCv1CaxXU4dH7QgvSxW479ydY7hIBPEjzMPIu0SolXVpLok5tcABNe1BzL35QWM7aAj
	pscasjJ/Ax8UcnN9woXWO7kbPQ3vCZNgF93V0G/foTAStmXlNJsg08JL4Fcd4ogb7pq1Fj
	nw3f36klDVqKFZ2RRbdu4+iB9PnJEyDpdSTl0fYqXxvG7PThqy36FmyrT38/IUG7zp5Ili
	TxubnujtBzlq6l1DstcMjsQhw0gT9VUAy7bGUoQInvkz8oN5HQtXBjGxTDbgwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086487; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G8LhCD9Y6XSW1yomWSIcKAk3XFngRWAzYK41UbGFhT0=;
	b=WaUinTACKt0fdQfrmEQeYPzdyl5WUsLeWG8xH8s3mcJ/+ERDmn+3ClF1Psqrk5ezq5HJwJ
	fjwHvRtmvSvNAJRxn/Y+z4BbukmyUYayIOy3Kkz+FMDwpDkWGsS3WFzK/qBlP6fpYbhcF/
	X95+PvK565THmaEDvD4OOdh/WUwSrjV6HhUGBjT73Pb43DdxkqmScVdK4mGx5YItGViBM9
	f9JtL6jnRXVwR21w9/SHSRS7kEMFrAutsVBp0n1UmpqihaHYfA6ISaRHu6/Bz1puhkajef
	c/5JBcX6BEZg/XViUnlJtbZ2zyrk6MjSYWYWIns5DBJcAG1AXXOfwHvTv7ZBUg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086487; a=rsa-sha256;
	cv=none;
	b=HuJZ8zgrT+/AIQM59ISxG/QPFPWCag/q3eRNUSvcrnJUZlmpRVpT2hpVYrPKerfHrbUbj7
	LUJv94CSANpNl4SoWpkrdMtmg2jtUIeEhfC9ZhqaazAgB8OH2y+4p2x6GxgZ2358co2VpY
	FCj1H37kbmtMyrPTfvIrZ3jsaG4jaaJ8eHpHMx0+W5sNIXtAbYPYkiyYKJfcIsMhiAFmlX
	8KtBZnH9vNDIMzykMkI7dsMl0pyZf0nDKVJnhyG3lKekYABDzD/V9jWZdlWDKBNSQxLXDQ
	MmNPVSlN/AxbEmFuwF/HZsuvf+zYY+g+l3WspkYnOajXjHHQ/svesfZm7bhC7A==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 05/12] smb: client: fix potential UAF in smb2_check_message()
Date: Tue,  2 Apr 2024 16:33:57 -0300
Message-ID: <20240402193404.236159-5-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 82b84a4941dd..14d74ef70cc8 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -160,7 +160,8 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(iter, &pserver->smb_ses_list, smb_ses_list) {
-			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
+			if (!cifs_ses_exiting(iter) &&
+			    iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
 			}
-- 
2.44.0

