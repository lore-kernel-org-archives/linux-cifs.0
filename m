Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1E54B8278;
	Fri, 25 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347062; cv=none; b=uB5FdeWhM68CHHPl0yyYBMOgCMqqJMtGVoL16SwkPkagwLJsgbwSQPZ//HXLL5lVLZiQu8F+wUNpg70dtXcS8QtFb1ggYzdpFpuvUGC9bA20zoUh2OgX+S5rNyboBfFtwT4IuS/1Tk8WCJgXd7gV+XRwnxNRA0kFo4PLS27sPWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347062; c=relaxed/simple;
	bh=sbwEr3XKOC9C8D70fy3UJ/R9aHpSbmfswqBO3dgI8rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWVxcJ4zizPvbpNFfx5Af5nGBtlYpG2nVCyCKj1NwkbF88PuYju0nPVL+WvCCrX6Q9klXkq6mKl7CKcrCRlgZkG3ilGA5X3UpLbStY7xxVWf3QG4xZE5B9p+Nz9bKrECk/RThy7HSc3iNC9OAdh5yjCYzR8hTgoEgQjrFjDkRQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=8nuW6EdT; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="8nuW6EdT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=pcWcAlZ9E4EFhlUfnMAyRKjXoxwDs6duAlO6EdTG+m0=; b=8nuW6EdTHjVf3S9cECTQ1LkPqu
	26z34Ub1m/HW9HiyMvWjIOW3vhobJAASxB30GreXdv87O83pKwKNAk/0+NSr3Rf1SRfiZxRJazynA
	LHZQ6CI+Qgpjs/mTTebj64dWyCreasWQetK+bGMfiE32E76JkK8pp0U5xa1aXkUFjnnEkfiriSQyw
	9jWk4KHJqPJTM0uoVbXKvHnsSZLMH2+yMLDoYtIAz4suAVsgZWOng65sBaq0ad91Ugerfq+ttkDNf
	AdF6pMm7UGtp9scYSxZpP1O39Ygfp+LFLsxoHYStXt15SCiCaue7ptviXTX2nHVrNQZL3rdJaCQ6P
	iQSVwSTg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xA73A-00000002Gxa-47q7;
	Fri, 25 Sep 2026 11:37:20 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 5/5] smb: client: discard post-EOF pagecache when extending a file via clone range
Date: Fri, 25 Sep 2026 11:37:19 -0300
Message-ID: <20260925143719.2889518-5-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925143719.2889518-1-pc@manguebit.org>
References: <20260925143719.2889518-1-pc@manguebit.org>
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
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---

v1 -> v2: no changes
v2 -> v3: no changes

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

