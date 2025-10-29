Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F422F29AAEA
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744660; cv=none; b=fb/QF/oHrVImh9VMfbeYb7Q8tAlXDibJddUubVh7lU8AyZUxtID7e4vMXv6cSM6sNzw3n913xCO9reIs6iLfiZBVnICoaZdVGJ/oDT3Z6apzjZiQGsX4LDAgT8hvq0jad1Y00/fv5ppr5C6ziMeePng3Jne8F9fuZxrgSBhONxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744660; c=relaxed/simple;
	bh=XGASw8YZ3Zv7UvnGMZEae3bGwsiY6Fez4782/To/A7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knCNsZljNxAfnTmt/KV+l3UG1UpH+vOrLvFRAD/9CvepfnwiZ7BdVhoQSSWgmjwkmm3Fk5XjyEHHzsulHmsDSXheZt8cMv34CFBGyFi+GX6U6R+cHZCJtQ9U/Z4eiP9xnXIEW+hrgHnUZW0Fyw+kfTwhvnn7UFiP2K7xNERwknk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iXPMorht; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iXPMorht"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=SGEtkkFzyFUFgGsMeYvCCazxjc1vlEsRrmRb23kb1HI=; b=iXPMorhtHf3J2OAC7lWCiD5P2I
	kwdeHElFt9t2240x12KXn62cqGvoUuZR/yOsfJqAFRkEpLZXIo/b9zO/hGU/DP/eaasanwmoWPu6+
	j4iXBWNReQdG30G+cJBDJffR1+FxzbcXPC5kHay6/K8iLwss++ldaQHiHhLLcilXVgOWf4CXVvNgn
	F0eE4MZMsX0gXp96bNsaN3dY1CD9gPSBIppcK5haxXXddjd8uhbH4L4AQyjoEnNHOxdcLMATYSEpB
	6INoUc8IEhbT0vKo5wvbO54aVJP4OUkjC+xIOwgeduOoGXyQM9s8vaJYzNNAVO9iBg3qlWlEMdnFo
	fLeC8r4z5S0RPyg8ozUrhoT4nYx8Idj5me65IZ4A6qwq6EFVxFwyrpYV//g02iawd5VytRCJnWPfs
	4w+hNDJCNwAl/8Qn6SWKnakHOha608K16uJN/0o1ANAARkndMc0Q8AN770zqj1/F9kqxIA9eXQwHK
	oIb6mvWHjctzuLgCtG8Os/cO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6GK-00BcRA-1n;
	Wed, 29 Oct 2025 13:30:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 084/127] smb: client: let smbd_post_send_full_iter() get remaining_length and return data_length
Date: Wed, 29 Oct 2025 14:21:02 +0100
Message-ID: <2cc6c3d37a7103ad51bfbad7209e016134e70461.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will simplify further changes in order to share
more common code in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 34404a1d3e58..fb3cf25b78f8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -947,9 +947,9 @@ static void smbd_post_send_empty(struct smbdirect_socket *sc)
 
 static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 				    struct iov_iter *iter,
-				    int *_remaining_data_length)
+				    u32 remaining_data_length)
 {
-	int rc = 0;
+	int bytes = 0;
 
 	/*
 	 * smbd_post_send_iter() respects the
@@ -958,14 +958,16 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	 */
 
 	while (iov_iter_count(iter) > 0) {
-		rc = smbd_post_send_iter(sc, iter, *_remaining_data_length);
+		int rc;
+
+		rc = smbd_post_send_iter(sc, iter, remaining_data_length);
 		if (rc < 0)
-			break;
-		*_remaining_data_length -= rc;
-		rc = 0;
+			return rc;
+		remaining_data_length -= rc;
+		bytes += rc;
 	}
 
-	return rc;
+	return bytes;
 }
 
 /* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
@@ -1365,16 +1367,20 @@ int smbd_send(struct TCP_Server_Info *server,
 			klen += rqst->rq_iov[i].iov_len;
 		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);
 
-		rc = smbd_post_send_full_iter(sc, &iter, &remaining_data_length);
+		rc = smbd_post_send_full_iter(sc, &iter, remaining_data_length);
 		if (rc < 0)
 			break;
+		remaining_data_length -= rc;
+		rc = 0;
 
 		if (iov_iter_count(&rqst->rq_iter) > 0) {
 			/* And then the data pages if there are any */
 			rc = smbd_post_send_full_iter(sc, &rqst->rq_iter,
-						      &remaining_data_length);
+						      remaining_data_length);
 			if (rc < 0)
 				break;
+			remaining_data_length -= rc;
+			rc = 0;
 		}
 
 	} while (++rqst_idx < num_rqst);
-- 
2.43.0

