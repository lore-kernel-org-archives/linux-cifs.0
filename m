Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B94E4C58;
	Mon, 28 Sep 2026 20:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626196; cv=none; b=AQDR1/IdCZGOICqbft73gsrTw4cic2BLLH0tYyp4KhEZbzcmjXAWJMZPAsFspYn2axikXS6xF7cZ0kWSZ0ALoeme0ygVRKSJL0LrFYZXP524FN1gCQWDY/XzxlB1NdhvBfiKjmERewPYx0pNbnxuvnqju+vyoQhXytEQphURtI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626196; c=relaxed/simple;
	bh=ygvVZs7ArnV208IwkNZ2AhMrOl5dWg6DvYui/P55cbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE/+65kYH9xKO2ZMP6SPJ7PWN/rtKQf0gRI0MSv9PNqrUSaIUt+ZtybOczVAz8XSXdveHwnwclvv8xg6XrwARvUL9hpGscyA7IXDGgrKKXsCkmdvySSg7Ejc83dJO5R1P8/dCPvS1DmEbAR3jFtMW5rvfLBqpbz3f/8DZqwtLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=HtlbQ5bJ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="HtlbQ5bJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=VEgN7Ojzz4BLIQJpl4CKvMJBD0yPHQz6qWkgIVwhkT4=; b=HtlbQ5bJpJJLPEjqTwow3dAez0
	YmmwCXA0YmgchIk5E4yDgOPruokVwR+gNSDacXNeNQa8131dpVaroO6DE/TgIuT5HIVskfBm3/8zs
	kLZexwu5i843xmhZFvpptPm4nT5ZfVjFKIVZKOOhc+XT7u3bmp7f8PP6rRWbJCv3bwRuu/a+qPF9p
	VPjufuuIxz3xgY01p7G/1AMikuBlt0CjPtPruvfO4AiVPsTD+qR5ZnDwS/neKOFIVBiAOkjIAcjyH
	jw2UQQ5x8mPuOLG7W2/RcWBSsLndaVvu5DH8DNb99ZZPTI9d/asM8HeLHfrPQzjp3xwlGqTwlm+Pc
	hmjHaz3Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfP-00000002ULw-32wT;
	Mon, 28 Sep 2026 17:09:39 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 15/15] smb: client: require stable pages for signed connections
Date: Mon, 28 Sep 2026 17:09:34 -0300
Message-ID: <20260928200934.1040189-16-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928200934.1040189-1-pc@manguebit.org>
References: <20260928200934.1040189-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When signing, cifs computes the SMB signature over the pagecache folios
in place and then hands those same folios to the socket.  If a buffered
write mutates a folio while a write subrequest is still in flight, the
signature no longer matches the data that follows it, the server rejects
the write with STATUS_ACCESS_DENIED (-EACCES), and the error is latched
in the mapping, so the next fsync()/fallocate() returns -EIO.

Mark the mapping for stable writes so netfs_perform_write() waits for
writeback to complete before modifying an in-flight folio.  This is only
needed for in-place signing: encryption copies the data into a transform
buffer before sending, and plaintext transfers neither sign nor checksum
the data, so gate it on the same condition cifs uses to decide whether
to sign a request.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index ebc620c166a9..30cd7c95dd3d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -88,6 +88,9 @@ static void cifs_set_ops(struct inode *inode)
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
 		mapping_set_large_folios(inode->i_mapping);
+		if (tcon->ses->server->sign &&
+		    !smb3_encryption_required(tcon))
+			mapping_set_stable_writes(inode->i_mapping);
 		break;
 	case S_IFDIR:
 		if (IS_AUTOMOUNT(inode)) {
-- 
2.55.0

