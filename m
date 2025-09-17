Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16101F09B3;
	Wed, 17 Sep 2025 12:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112756; cv=none; b=OzwVzjW6x98o9lX70Kp3wEcRI/4Utc7RVjdQ06aOwh8yHLKdwelO6PgTCq60zrKM9Nhwr8Lj4fbvwMGUP2hhqT8TLa9Uu1EpNFF0Uj+9QNHWJhbh4h38SOMOIHneSKwKhjzgpzoWZYb1st8OsLCkAiH0ey8+xK1WuPCFLDZ/TU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112756; c=relaxed/simple;
	bh=ohuSOpnM2j+d2FNqk5FTLBkEOroUP8+4bfj5UFwstFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdQ5uRYA3Eu4UvJlXJ3ZuP2LrkO2qR6vlk/8/MrxzyDZ0npvSib14O5HYFTN/8Z/Rd+mrK12P5gPzSaYoI4EcL+zvmsyPJXadWU+Hbx2oN011YXgiMLPSS0wFy8MjBSTh7n/4fkAHPNsBpRuyI8/szVdifusC8Fj8F32D/JzgGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vniRVBFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vniRVBFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC84C4CEF0;
	Wed, 17 Sep 2025 12:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112755;
	bh=ohuSOpnM2j+d2FNqk5FTLBkEOroUP8+4bfj5UFwstFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vniRVBFSnw79F6O/5WxuzmZHeKI2y89WVorFaA3lunqvrx9MyGA9ahmGWSVK9Ug0B
	 Pz9p78k/+pDBEZdyb3x3mGEdTsyhwTx1zWzLVuWBZgzRKy0wt8XOn4EfUj0ybizgHR
	 Xb0/dDPKJDZUxf0Dc15bPUGa9joYD2HER3pLraRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 068/189] smb: client: fix compound alignment with encryption
Date: Wed, 17 Sep 2025 14:32:58 +0200
Message-ID: <20250917123353.533910966@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 90f7c100d2dd99d5cd5be950d553edd2647e6cc8 upstream.

The encryption layer can't handle the padding iovs, so flatten the
compound request into a single buffer with required padding to prevent
the server from dropping the connection when finding unaligned
compound requests.

Fixes: bc925c1216f0 ("smb: client: improve compound padding in encryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2640,13 +2640,35 @@ smb2_set_next_command(struct cifs_tcon *
 	}
 
 	/* SMB headers in a compound are 8 byte aligned. */
-	if (!IS_ALIGNED(len, 8)) {
-		num_padding = 8 - (len & 7);
+	if (IS_ALIGNED(len, 8))
+		goto out;
+
+	num_padding = 8 - (len & 7);
+	if (smb3_encryption_required(tcon)) {
+		int i;
+
+		/*
+		 * Flatten request into a single buffer with required padding as
+		 * the encryption layer can't handle the padding iovs.
+		 */
+		for (i = 1; i < rqst->rq_nvec; i++) {
+			memcpy(rqst->rq_iov[0].iov_base +
+			       rqst->rq_iov[0].iov_len,
+			       rqst->rq_iov[i].iov_base,
+			       rqst->rq_iov[i].iov_len);
+			rqst->rq_iov[0].iov_len += rqst->rq_iov[i].iov_len;
+		}
+		memset(rqst->rq_iov[0].iov_base + rqst->rq_iov[0].iov_len,
+		       0, num_padding);
+		rqst->rq_iov[0].iov_len += num_padding;
+		rqst->rq_nvec = 1;
+	} else {
 		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
 		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
 		rqst->rq_nvec++;
-		len += num_padding;
 	}
+	len += num_padding;
+out:
 	shdr->NextCommand = cpu_to_le32(len);
 }
 


