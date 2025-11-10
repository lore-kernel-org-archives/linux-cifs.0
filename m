Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110501DDC1B;
	Mon, 10 Nov 2025 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775345; cv=none; b=deftgmgRHlCPmaTQbc5o0E+Rud4dOThRO/f67Dburbb7IYKZPxdjK8NkX3avdTl3kmqQgHWrVxA0WBtGPRxGpZWYAKxP7yvLhPrZ4xV+dspWdFtqiPhga0QNLjPmGvv8mbh4EPgBRjPWLBdrUK3iamYtitOcTtdCF/HuA3ZWLh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775345; c=relaxed/simple;
	bh=rcVZnLgKUKjpRxx9J23FRkbwzvrxQ5r/s7h0k22IgVg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JivrXBEN+dTFvq7ARkkEVkgZWz5ErnuRrxv6W5yVV+fXgmrbc8XLDHjua6SvyBHcaSth16TkIfoFwQo/S2xYNXrcpEXB/AAYJBmeOSVKBxjmG2RhIFRQmsndSxvCkUIOK+FFKfSOmvQeKtzdSTMvJqIIXbkJ7bHqo477ZhXlJ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAj+BmGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAj+BmGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337BAC16AAE;
	Mon, 10 Nov 2025 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762775342;
	bh=rcVZnLgKUKjpRxx9J23FRkbwzvrxQ5r/s7h0k22IgVg=;
	h=Date:From:To:Cc:Subject:From;
	b=EAj+BmGUpgFBiqHdfEcxtFIzlBxEj4Cl1m9t/kCqoqsuknrAjo2SmTV5Y4zENYRQF
	 joxSwP9IfxSMWRYqfnBzWdCW2C22NsDoX+KeLKtu/hFV0xaixmGsp79+RoMoT5gq0A
	 bl7bXslMNcNFH9mxFHRkuHpiu15oT1rAKK/4fNrrYROF2ZUEsYRfOMJpA+H8P9aUa8
	 dxbP1/AOG9i1IdVXUQ4+2AFZ/p8doqyu52HIDRJ7P6s6hR4NpR/NocYPgHDtcOaMrr
	 vlYLK7LZojz8E1PhuoARO3CHzImcwU/VZ07TF013w2UWwbSwlmrl25oey7EV/B7gcL
	 /QwMmTFHvD0gg==
Date: Mon, 10 Nov 2025 20:48:55 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] smb: client: Avoid a dozen
 -Wflex-array-member-not-at-end warnings
Message-ID: <aRHRJ4y39-tUWkIU@kspp>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Move the conflicting declaration to the end of the corresponding
structure. Notice that struct smb2_file_all_info is a flexible
structure, this is a structure that contains a flexible-array
member.

Fix the following warnings:

12 fs/smb/client/cached_dir.h:51:35: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/smb/client/cached_dir.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1e383db7c337..bc70197bbfbd 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -48,8 +48,10 @@ struct cached_fid {
 	struct dentry *dentry;
 	struct work_struct put_work;
 	struct work_struct close_work;
-	struct smb2_file_all_info file_all_info;
 	struct cached_dirents dirents;
+
+	/* Must be last as it ends in a flexible-array member. */
+	struct smb2_file_all_info file_all_info;
 };
 
 /* default MAX_CACHED_FIDS is 16 */
-- 
2.43.0

