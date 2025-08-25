Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7A422128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155550; cv=none; b=UZZDc28AeRNpvFsAjnnDMHl8SyELXW5VoDb6nAZl3i8uQYuI/a4WOlpdpK6bfD3x0b3pRHA+cE5WCJbdSYRyTrcXjpexNswFNfgavGRh2DkyGNeDjczHGjK854mwhX4Cqn6ebS7J9/2wUptOiETB3pK9R3C6Qwzvohkog78+/SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155550; c=relaxed/simple;
	bh=cpSCJsLRN2J9vWEM1mjXGmuuRBTkdeotaB9ewMKovGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhp3oOzwUZRPRAhynr6LcolWrMobHs6JgrSU8HIHdcV03NMuFXi+p9maaBndSxV7ui5j9bQJqKb4PbfpoKM1Zd1u/CRp3dduIzO4T3LMNWbMoM7kgigCVFV0rDwFLeyRp7g3zwtlSBwvnFhTwBkToBhbUjA2ruYptEUOMeoUvQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pFzDsiP5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pFzDsiP5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hRxFCJPpGB81lvE+ezUgzu2WpU3h0/B5ZXLey/HLKog=; b=pFzDsiP5j8Y7FBvlHR0iXsPYnp
	NBSqY6fy6BWvAC25y5FlfLjgb9+5Uhk4ASGfSZO8R5dG56knHwUsNV2LQ2oQNUjqSWWUyBJUkX7hI
	NJm+XcHel6kjM+Cw/peQYYOMo3xY+ylfLuEQP+3sFsjH9bHC0UMlKkFboHnJB9gBY2jg6KMR28Iti
	tzusCfIc+aWQ2nrh3tor4zfoZrpmaCeBhkNuAYDUYAwVWXHjLP4H0YZGlQ8DIVcxqCNwlDHbz4rhw
	d8kzWQArQxFmFgN6N0pIr2gxkt5SYg7mVUp92UPXzdYkjKpeGWccuMW6b+XcgSszEOdDY3RCR6Nb8
	/EK4gXSQImdfkPqmQqSL8t/5h+25EkYjtqFv0RODsYHvwGsDQAlsZD1dtqZ/50tL/50MPP7RNeX4y
	NJH3O1oMGpSR9aS2+BCWTOgTG/z4ZBtcbEHyYav64mhwZzYQeUCWBcoZ7eSHcVbgNwx1wABOhmT5t
	f8U/i1Xl28JlQQ4tUJmzqh6V;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeHQ-000mfT-0g;
	Mon, 25 Aug 2025 20:59:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 104/142] smb: server: manage recv credits by counting posted recv_io and granted credits
Date: Mon, 25 Aug 2025 22:41:05 +0200
Message-ID: <78f83ad8cdca8588cbb8afdac38679671c278a50.1756139607.git.metze@samba.org>
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
recv_io messages and the count of granted credits is much
easier to understand.

From there we can easily calculate the number of new_credits we'll
grant to the peer in outgoing send_io messages.

This will simplify the move to common logic that can be
shared between client and server in the following patches.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 53 ++++++++++++++--------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 6046ebdc1317..2bbf18e0906d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -92,13 +92,10 @@ struct smb_direct_transport {
 
 	struct smbdirect_socket socket;
 
-	spinlock_t		receive_credit_lock;
-	int			recv_credits;
+	atomic_t		recv_credits;
 	u16			recv_credit_target;
 
-	spinlock_t		lock_new_recv_credits;
-	int			new_recv_credits;
-
+	atomic_t		recv_posted;
 	struct work_struct	post_recv_credits_work;
 	struct work_struct	send_immediate_work;
 
@@ -308,9 +305,8 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	sc->ib.dev = sc->rdma.cm_id->device;
 
-	spin_lock_init(&t->receive_credit_lock);
-
-	spin_lock_init(&t->lock_new_recv_credits);
+	atomic_set(&t->recv_posted, 0);
+	atomic_set(&t->recv_credits, 0);
 
 	INIT_WORK(&t->post_recv_credits_work,
 		  smb_direct_post_recv_credits);
@@ -541,9 +537,8 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				sc->recv_io.reassembly.full_packet_received = true;
 		}
 
-		spin_lock(&t->receive_credit_lock);
-		t->recv_credits -= 1;
-		spin_unlock(&t->receive_credit_lock);
+		atomic_dec(&t->recv_posted);
+		atomic_dec(&t->recv_credits);
 
 		old_recv_credit_target = t->recv_credit_target;
 		t->recv_credit_target =
@@ -747,14 +742,10 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 	struct smb_direct_transport *t = container_of(work,
 		struct smb_direct_transport, post_recv_credits_work);
 	struct smbdirect_recv_io *recvmsg;
-	int receive_credits, credits = 0;
+	int credits = 0;
 	int ret;
 
-	spin_lock(&t->receive_credit_lock);
-	receive_credits = t->recv_credits;
-	spin_unlock(&t->receive_credit_lock);
-
-	if (receive_credits < t->recv_credit_target) {
+	if (atomic_read(&t->recv_credits) < t->recv_credit_target) {
 		while (true) {
 			recvmsg = get_free_recvmsg(t);
 			if (!recvmsg)
@@ -769,17 +760,11 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 				break;
 			}
 			credits++;
+
+			atomic_inc(&t->recv_posted);
 		}
 	}
 
-	spin_lock(&t->receive_credit_lock);
-	t->recv_credits += credits;
-	spin_unlock(&t->receive_credit_lock);
-
-	spin_lock(&t->lock_new_recv_credits);
-	t->new_recv_credits += credits;
-	spin_unlock(&t->lock_new_recv_credits);
-
 	if (credits)
 		queue_work(smb_direct_wq, &t->send_immediate_work);
 }
@@ -826,11 +811,18 @@ static int manage_credits_prior_sending(struct smb_direct_transport *t)
 {
 	int new_credits;
 
-	spin_lock(&t->lock_new_recv_credits);
-	new_credits = t->new_recv_credits;
-	t->new_recv_credits = 0;
-	spin_unlock(&t->lock_new_recv_credits);
+	if (atomic_read(&t->recv_credits) >= t->recv_credit_target)
+		return 0;
+
+	new_credits = atomic_read(&t->recv_posted);
+	if (new_credits == 0)
+		return 0;
 
+	new_credits -= atomic_read(&t->recv_credits);
+	if (new_credits <= 0)
+		return 0;
+
+	atomic_add(new_credits, &t->recv_credits);
 	return new_credits;
 }
 
@@ -1756,11 +1748,8 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	t->recv_credits = 0;
-
 	sp->recv_credit_max = smb_direct_receive_credit_max;
 	t->recv_credit_target = 1;
-	t->new_recv_credits = 0;
 
 	sp->send_credit_target = smb_direct_send_credit_target;
 	atomic_set(&sc->rw_io.credits.count, sc->rw_io.credits.max);
-- 
2.43.0

