Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B3A3DD86F;
	Mon, 21 Sep 2026 23:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032082; cv=none; b=QQH86YWruqo3n9yWK9sxGmrj9dqvz941b7pBaYXs91Wx5UTUY1uP+HwN/XUExbjTpKVj8evipaV0baTWP977QJxebY3Jxpg7bryWqUFBTnV9NWazSS9rF4e1LJ9oH5EIHAzg1DPXAFE97YsJ7iTXtKVDNHOSMzAuA7EOTWwXE9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032082; c=relaxed/simple;
	bh=A9OlNL/mP8S/9qDVS98dE+i2JYlsyWiddspUD+cgzxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTa2ICUeSaJOxX4mBrBCOD2IhGqxM6fuK/g0jp8pHb+FZcUDn3H2/bJIS6YyQbGf0K2jjBSAC1PtZPxj8ke1OKtwV+PFC3OprbtvJAtyU9ltlfMTsTa+dwS42WgoOdPZJP1w/Ro/RVmn1NcQVJoLiln+mDv8ypxDzOxpVvcdtj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=t8VyFE3b; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="t8VyFE3b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=yuDo3q9nLaIRM9+W/Y43wNbu6tIe1nzy5j8qjSRfqCk=; b=t8VyFE3br+94T8RqePXJP4T1r9
	KwcbQn0R+hK3b+glu/H3YyrVSktcfNvpWS9yIyseWkZqcqF96TDgrhiKjuQ0dX3m28CdJrcpcHj3g
	iWSKXQs3rY6pwb5TbdXoDsgJ2dQ+1/Y0B88n7sOPUzxwqLIlJh1kdTSr8Xv2pRwYEyb2yrkwKqhsr
	UcG8P2a7BwnDzoEgBAq3e7OyiT1vwiJK5TBbguUkdmILeNWESPU7SySfpU1WYzP6oWyiZ8HgQ+8Du
	SoSfq+4t4lHc6S6af9KnjuheElG00JejWysRiL8cRvYPG5CawlxRlFHoaOZAiRvyMGhISTVsLZ1pR
	Ah/gJRFg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x8n77-00000001xpJ-38ND;
	Mon, 21 Sep 2026 20:07:57 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 5/5] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Mon, 21 Sep 2026 20:07:55 -0300
Message-ID: <20260921230755.1133425-5-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921230755.1133425-1-pc@manguebit.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_remap_file_range() discarded the pagecache only for the folios
overlapping the destination region, so when a clone extends the file the
folio straddling the old EOF - which may hold data dirtied past EOF
through an mmap - was never dropped and became visible as file content
once the file was extended.

Start the discard at the smaller of fstart and the old EOF.  i_size is
still old here, so nothing past the old EOF is flushed to the server.

Fixes: c54fc3a4f375 ("cifs: Fix flushing, invalidation and file size with FICLONE")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index f1fb4b7b7b7c..6410249f529a 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1467,9 +1467,14 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	i_size = target_inode->i_size;
 	spin_unlock(&target_inode->i_lock);
 
-	/* Discard all the folios that overlap the destination region. */
+	/*
+	 * Discard all the folios that overlap the destination region.  Start at
+	 * the old EOF when extending so the folio straddling it, which may hold
+	 * data written past EOF through an mmap, is dropped too.
+	 */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
-	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);
+	truncate_inode_pages_range(&target_inode->i_data,
+				   min(fstart, i_size), fend);
 
 	fscache_invalidate(cifs_inode_cookie(target_inode), NULL, i_size, 0);
 
-- 
2.55.0

