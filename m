Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9DD22FF37
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154862; cv=none; b=ty6Flj18/6gMfRpp78oA83zzh7cN30lJYVSTW6v7DTNxzIiePYFw42nxhdBYAu+FpBd7PHh7CT8AKKNQjxfhwvBq8dpKAZN1zgdTCRdqCRcFh+TTq2Jt53YnjMVlNkZ/i31HdJkD2nG1nieoJRu8Q5Y/pYT7SLQor5N2H4J88DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154862; c=relaxed/simple;
	bh=emu9TbS3AnIQiQPOib5UvOayGPCRiUa5RNO8XnFMS78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D11UxcmvaFvNCqpdaFEQYwWSLppuhSzJUYLqvhPwC941CpH/duYOU0gbONtuAcSzqn2Z0VdVCu63uxNsWrkd/b1RHlnEwG667/NUY56PCefD6aHniKjO3Lc3jFAfEQB0D33KOchhbDvhBvdQ6DNG4yLKQu8n0DdpeOZDKsWhZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=awGpvwUs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="awGpvwUs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=HWy1icnb0qPGeGU2AdITnFC8gqAaesYL3/AP3Uovbvs=; b=awGpvwUs71xQ5CPgxAb0TEtEET
	KuHQZU2ooxDoKjHxiNJLxKgyV6xAMM+jHEywKKYary2C6qAJ9BU/IM/rG4sYuoO4mRwMtlouzYsht
	JNsnrDBkO1LTCW5GJQYIScuKNG1Y5F+aRFi7OPEy1pAFlZ5I5yRQSa3deHMTYdcL5DZ3k+1pq896e
	oGgnAkTLagfL5HmpTQm5O6Fb8YGc/6CWkP4Pt01IbPhnRHvnCWMAz+xo337rj93WYODuCzcDVte62
	sDygIdCHXjFOVns8UvAqdOBP84cYLjR26+2XICqF9CdFehDlfShviGuc8ne5gTi6EPY14/Oe3eVia
	TD88MozpNoNzesSXReVRengZxTuvCNyZU8XL9KmwpbNpUrJmywkxWtvxIhabI+sFeZIEzmj9xF/Yh
	WjlTuZ7pn3rrYXDRQFyBdcPEAzX/YzIcx5wuH1k88W+rMztqHz8GYL68WnYvqE9RpT2yaphC+Xu0M
	v3kkknkzbPQ0plPLPSh86FrQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe6L-000kMc-2q;
	Mon, 25 Aug 2025 20:47:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 035/142] smb: client: count the number of posted recv_io messages in order to calculated credits
Date: Mon, 25 Aug 2025 22:39:56 +0200
Message-ID: <3ed035f8387b1ff63ec960b39421b422412aac02.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(At least for me) the logic maintaining the count of posted
recv_io messages and the count of granted credits is much easier
to understand.

From there we can easily calculate the number of new_credits we'll
grant to the peer in outgoing send_io messages.

This will simplify the move to common logic that can be
shared between client and server in the following patches.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 30 ++++++++++++++----------------
 fs/smb/client/smbdirect.h |  4 +---
 2 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e567fdc6e223..d68d95d1ef37 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -465,6 +465,7 @@ static bool process_negotiation_response(
 	atomic_set(&sc->send_io.credits.count, le16_to_cpu(packet->credits_granted));
 
 	atomic_set(&info->receive_credits, 0);
+	atomic_set(&info->receive_posted, 0);
 
 	if (le32_to_cpu(packet->preferred_send_size) > sp->max_recv_size) {
 		log_rdma_event(ERR, "error: preferred_send_size=%d\n",
@@ -506,7 +507,6 @@ static bool process_negotiation_response(
 
 static void smbd_post_send_credits(struct work_struct *work)
 {
-	int ret = 0;
 	int rc;
 	struct smbdirect_recv_io *response;
 	struct smbd_connection *info =
@@ -534,14 +534,10 @@ static void smbd_post_send_credits(struct work_struct *work)
 				break;
 			}
 
-			ret++;
+			atomic_inc(&info->receive_posted);
 		}
 	}
 
-	spin_lock(&info->lock_new_credits_offered);
-	info->new_credits_offered += ret;
-	spin_unlock(&info->lock_new_credits_offered);
-
 	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
 	info->send_immediate = true;
 	if (atomic_read(&info->receive_credits) <
@@ -621,6 +617,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				sc->recv_io.reassembly.full_packet_received = true;
 		}
 
+		atomic_dec(&info->receive_posted);
 		atomic_dec(&info->receive_credits);
 		old_recv_credit_target = info->receive_credit_target;
 		info->receive_credit_target =
@@ -921,10 +918,16 @@ static int manage_credits_prior_sending(struct smbd_connection *info)
 {
 	int new_credits;
 
-	spin_lock(&info->lock_new_credits_offered);
-	new_credits = info->new_credits_offered;
-	info->new_credits_offered = 0;
-	spin_unlock(&info->lock_new_credits_offered);
+	if (atomic_read(&info->receive_credits) >= info->receive_credit_target)
+		return 0;
+
+	new_credits = atomic_read(&info->receive_posted);
+	if (new_credits == 0)
+		return 0;
+
+	new_credits -= atomic_read(&info->receive_credits);
+	if (new_credits <= 0)
+		return 0;
 
 	return new_credits;
 }
@@ -1133,10 +1136,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 					    DMA_TO_DEVICE);
 	mempool_free(request, sc->send_io.mem.pool);
 
-	/* roll back receive credits and credits to be offered */
-	spin_lock(&info->lock_new_credits_offered);
-	info->new_credits_offered += new_credits;
-	spin_unlock(&info->lock_new_credits_offered);
+	/* roll back the granted receive credits */
 	atomic_sub(new_credits, &info->receive_credits);
 
 err_alloc:
@@ -1822,8 +1822,6 @@ static struct smbd_connection *_smbd_get_connection(
 	init_waitqueue_head(&info->wait_post_send);
 
 	INIT_WORK(&info->post_send_credits_work, smbd_post_send_credits);
-	info->new_credits_offered = 0;
-	spin_lock_init(&info->lock_new_credits_offered);
 
 	rc = smbd_negotiate(info);
 	if (rc) {
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 6f18e4742502..b5eeea4ddcf1 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -46,9 +46,7 @@ struct smbd_connection {
 	struct smbdirect_socket socket;
 
 	struct work_struct post_send_credits_work;
-
-	spinlock_t lock_new_credits_offered;
-	int new_credits_offered;
+	atomic_t receive_posted;
 
 	/* dynamic connection parameters defined in [MS-SMBD] 3.1.1.1 */
 	enum keep_alive_status keep_alive_requested;
-- 
2.43.0

