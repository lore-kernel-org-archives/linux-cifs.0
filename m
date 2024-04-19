Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C97D07F
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713539125; cv=pass; b=afrm3osnzrlLiONk1fnZTMX1Rxbm0tgHrWoaRbJHBxvehcQEtdBxts2FSl66/HGRLb/f9Lbmh6bd/+cjWdaDCjPpP6MJqVroUjAyjNRoiq5dET1G+cQlsToEmMbWl6lD33k4yJu5Af1cwRPxPUqfIDl2nYuyqdrDOh3sy5uB/+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713539125; c=relaxed/simple;
	bh=GSrrvTZD5U/idM8vZzxEF85JSu4qruE0tRIJIfjwVzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iyeU9jPXFeG/4wq3lYAtxt1hlXwkRvJqgw0RuNCdx/J/UD2rKbeid7oQH/lL1JyaI3Tz1/hN9CB/LGSfLCr0jlZM70bYfrH7/Y6Q3e2Ju4Hr8V2u5CKcgUhD0F1bXgZwxrBN6+tKPgl7uVKaTzug/wGYph0gVKcAeb/8ht42mlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=pscuZuPk; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="pscuZuPk"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713539115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pqu/p8dN/bGIcwkqbw6TtO1dspKaVGzSBbA9pitRdDU=;
	b=pscuZuPkaYilua5XK0sfFmzbBFy8wWoQNwHwoeIj8Yg+HiGviLnV022MuxSLYbwI1zExWo
	esIwTQvnH04yMqlgYmFlb8UF4RWv8ea+L3cb6774e3ohS6eKI7nNU62H8Q9kWyuewVJCav
	CAb/TMfrzmN1wNbDHLbOOhZbfGjVNJ12cu0Qt/ehNInOUKM23qmob2mk+LWPFIBIqKGUI1
	RiuMB/rSQicKeJtX5GVMM+4ZekSF+zTxQbjUgKPG0iwrXPbl4vdOD8JldO74xiUfl9sikx
	hfE9m+C9QKHI2+SwQ+hPSG1a6geljKstZoZcQGL3/wIUzFXCPGEjNPGp7EcTvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713539115; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pqu/p8dN/bGIcwkqbw6TtO1dspKaVGzSBbA9pitRdDU=;
	b=Wx76tpLlp7MOHBIxVWywMNoGiR5kb9YVhMgG7486KWkzPtEDsjMDomMAWYVUV+WmZC8Jqm
	dpiDZPm5BOnJiBOBTktYKjmY0yoH3K5rImdI+8KfP9jCy0kYNtPc7Wz0trk+NKnVgaSQ0L
	SyXr5ODRszVnuM5BwKrvP9KM7ndpwbZJkSJqKIylbvAhty37tzxB6fsGJSYRHOXDd76aq7
	tTE5wUSaVqV3XvfK50g3m9FrVzhmv25MdDZZ2uPRVmTSWmwlJH/bXlJJHYAsXUEtvYOe9f
	5AuVKJlAlR9lf0kewbWdcag9a0FC7bbkH24Dzya1eoXnUlDLYjx7w/kfTafD+w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1713539115; a=rsa-sha256;
	cv=none;
	b=BIntH8wY0wm2W7unM98V97cemeI+jex2ta7bYTakd7rQtNVKDy7Qb96rfWNWZVW2f3pzEC
	LtsKI8XvjtYqs33NNZPUw3P+VLib3LdZlmjFTqg7U5+oZjnZFlMMKAsoy66T3TWnahNDKc
	nvSZ+Jc5NTeDqS4QwiL+SyjEWNHJbBo4fpDWC7ojFmKOkjYT1Ew0pBh30aReUqh47di4T5
	cvuS9QpX2BnqYnUG6VruSMUOEPtwPabBO6KkYCLTqVJIcli8gwu7F2VslmXg37Yga+Ab+s
	wvyQHV5mZwgtNPs2NJ+Zfn6iQXqnVLdS33VxVsebm/6bV6sBUW21cv/CEw/Fww==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	xifeng@redhat.com,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: fix rename(2) regression against samba
Date: Fri, 19 Apr 2024 12:05:07 -0300
Message-ID: <20240419150507.554196-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 2c7d399e551c ("smb: client: reuse file lease key in
compound operations") the client started reusing lease keys for
rename, unlink and set path size operations to prevent it from
breaking its own leases and thus causing unnecessary lease breaks to
same connection.

The implementation relies on positive dentries and
cifsInodeInfo::lease_granted to decide whether reusing lease keys for
the compound requests.  cifsInodeInfo::lease_granted was introduced by
commit 0ab95c2510b6 ("Defer close only when lease is enabled.") to
indicate whether lease caching is granted for a specific file, but
that can only happen until file is open, so
cifsInodeInfo::lease_granted was left uninitialised in ->alloc_inode
and then client started sending random lease keys for files that
hadn't any leases.

This fixes the following test case against samba:

mount.cifs //srv/share /mnt/1 -o ...,nosharesock
mount.cifs //srv/share /mnt/2 -o ...,nosharesock
touch /mnt/1/foo; tail -f /mnt/1/foo & pid=$!
mv /mnt/2/foo /mnt/2/bar # fails with -EIO
kill $pid

Fixes: 0ab95c2510b6 ("Defer close only when lease is enabled.")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index d41eedbff674..8907bbcd9f96 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -389,6 +389,7 @@ cifs_alloc_inode(struct super_block *sb)
 	 * server, can not assume caching of file data or metadata.
 	 */
 	cifs_set_oplock_level(cifs_inode, 0);
+	cifs_inode->lease_granted = false;
 	cifs_inode->flags = 0;
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
-- 
2.44.0

