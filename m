Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083303655D8;
	Sun, 27 Sep 2026 10:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790505760; cv=none; b=IoOYHvLoVlF/0SN15tDFGK1qP4qd/fVrUYD5SOn2s6SX0uJ79HHT+qStjyrS3VZuKYgozbCU/oYpA49TzrfaV4HDqjlPJWaxA6JLRwmtkk4HL/cIql+Cz00aFYWdnmBglgSpaZ1niyJnvmLTC7Oszojrr2L5f6zJ3Shjm0wg+XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790505760; c=relaxed/simple;
	bh=Polj1hAIyDCJxM/+oKfo90E5EkYhJtocbG3PlXy6d9U=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=gWjIYEv7Ta7GdKhXpH39sC0p7J6CaC7M8HvhtiUSyrMNumtRP6SdMVwTkGANrlOXnCSG+N/9/QvBrfGfKB5UfXrNWwXUneFbNvwnHOuXtaKL0oqPLdp8AZYgQGcOsAeQzrZDe+XNaAkWEPW8vGQJI3bqpLAcWUX8K8C2XHbpZSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn; spf=pass smtp.mailfrom=stu.pku.edu.cn; dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b=Cui5ChUP; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.b="Cui5ChUP"
Received: from smtpclient.apple (unknown [123.119.146.210])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f3c08e7c;
	Sun, 27 Sep 2026 18:42:31 +0800 (GMT+08:00)
From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: [PATCH] smb: client: reject query directory replies with no usable
 entries
Message-Id: <0D67468B-AE41-4469-90EF-94B6FAC25992@stu.pku.edu.cn>
Date: Sun, 27 Sep 2026 18:42:20 +0800
Cc: linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
To: Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-HM-Tid: 0aa0e275937203a1kunm8c83e6481b27f3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQhhPVh5PGk1LHh9OGBlKSFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKSUhVSkpCVUpPTVVJSktZV1kWGg8SFR0UWUFZT0tIVUpLSU
	JDQ0xVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=Cui5ChUP64Ub2K8Zd1yxrbdbHC9D9vVbPHtyQUht7N9XQcgcxMag9xykjMuPYHPjTPRoYyihOElVU/WrQD3XutqmVyLHFSxdu7vQjEuVx103wyWtlF2mg+ajujspu+3w7K4KCidaITgHcBnkjiMxzrZ+23Lpy/FXaKCbc2dmCZY=; c=relaxed/relaxed; s=default; d=stu.pku.edu.cn; v=1;
	bh=AW2GFqZ7vW/+kKnwFA6PZc01ooLAdSOQ8kwXUq/vozg=;
	h=date:mime-version:subject:message-id:from;

A server can answer every SMB2 QUERY_DIRECTORY with SUCCESS and a
first entry whose FileNameLength extends past the end of the PDU.
num_entries() counts zero entries, but smb2_parse_query_directory()
still reports success, so the index of the last entry and endOfSearch
stay unchanged.  find_cifs_entry() issues another QUERY_DIRECTORY.
Responses keep arriving, so the echo timeout and reconnect do not run,
and getdents() on that directory never returns.

The loop stops if a later reply is a well-formed page or
STATUS_NO_MORE_FILES.  An empty directory ends on that status before
this parse.  The hang requires the server to keep sending the
zero-entry SUCCESS.

smb2_validate_iov() only checks that the output buffer can hold the
fixed header of the requested info level.  A count of zero means the
first entry could not be parsed: its name does not fit in the PDU
after that header.

Reject that reply before the response buffer is adopted.  The
unpatched client logs the overflow warning thousands of times per
second and getdents() never returns.  With this change the same
replies fail the search once, with the new message, and getdents()
returns an error.  Ordinary directory listings on the patched kernel
still complete.

Fixes: d324f08d6a871 ("CIFS: Add readdir support for SMB2")
Cc: stable@vger.kernel.org
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
---
 fs/smb/client/smb2pdu.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3d7ead36d1a0e..84d6d5ccacf06 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5679,6 +5679,9 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 	struct smb2_query_directory_rsp *rsp;
 	size_t info_buf_size;
 	char *end_of_smb;
+	char *entries_start;
+	char *last_entry;
+	unsigned int entries;
 	int rc;
 
 	rsp = (struct smb2_query_directory_rsp *)rsp_iov->iov_base;
@@ -5713,6 +5716,23 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 
 	srch_inf->unicode = true;
 
+	entries_start = (char *)rsp + le16_to_cpu(rsp->OutputBufferOffset);
+	end_of_smb = rsp_iov->iov_len + (char *)rsp;
+	last_entry = entries_start;
+
+	entries = num_entries(srch_inf->info_level, entries_start, end_of_smb,
+			      &last_entry, info_buf_size);
+	if (!entries) {
+		/*
+		 * The fixed header fit, but no directory entry could
+		 * be parsed.  For these info levels the first name
+		 * does not fit in the PDU after that header.  Fail
+		 * the search so find_cifs_entry() does not issue
+		 * another QUERY_DIRECTORY.  The server has to keep
+		 * sending this reply for the hang to continue.
+		 */
+		cifs_tcon_dbg(VFS, "no usable entries in query directory reply\n");
+		return -EIO;
+	}
+
 	if (srch_inf->ntwrk_buf_start) {
 		if (srch_inf->smallBuf)
 			cifs_small_buf_release(srch_inf->ntwrk_buf_start);
@@ -5722,18 +5744,10 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 			cifs_buf_release(srch_inf->ntwrk_buf_start);
 	}
 	srch_inf->ntwrk_buf_start = (char *)rsp;
-	srch_inf->srch_entries_start = srch_inf->last_entry =
-		(char *)rsp + le16_to_cpu(rsp->OutputBufferOffset);
-	end_of_smb = rsp_iov->iov_len + (char *)rsp;
-
-	srch_inf->entries_in_buffer = num_entries(
-		srch_inf->info_level,
-		srch_inf->srch_entries_start,
-		end_of_smb,
-		&srch_inf->last_entry,
-		info_buf_size);
-
-	srch_inf->index_of_last_entry += srch_inf->entries_in_buffer;
+	srch_inf->srch_entries_start = entries_start;
+	srch_inf->last_entry = last_entry;
+	srch_inf->entries_in_buffer = entries;
+	srch_inf->index_of_last_entry += entries;
 	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
 		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
 		 srch_inf->srch_entries_start, srch_inf->last_entry);
-- 
2.43.0
