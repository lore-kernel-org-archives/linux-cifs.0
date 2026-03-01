Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BA72631;
	Sun,  1 Mar 2026 01:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328438; cv=none; b=VWhLmSRk2s+gGL2T0MLoEaLA23j/wz4++Wa2y+8tN7P2izh5gLbImnUZjPFHOiGYLa0UCk1fbuuS7xcETuLH1DH/pB6nFwWimqTkp39drq0DbApCwuB4c3RVuSFq9ldxyiHjITi4B0IS76WI0COOcER0ecCKRMoSpi0EnpQhdok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328438; c=relaxed/simple;
	bh=7J0YQcHD0R4VBi8FjeoHE/Ciq27EXrWrJo0tT1YxN44=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iBFXEYPmh45OfnZ668Cu2DsnpWBsilEWBZCqvZmQ6AQIDEDUYhZA8jfxiUVM/yipwc/wfVYFHAjwu+R9GMOStHYOYY+WD/VrbeouXYp7xfKnE6fZPXxEAY4RIW/POfA8ei42a2GiA1Es4eASxrzljpe+MJx5tcX2uu6ayR3XNtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RS21fPyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RS21fPyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015FFC19421;
	Sun,  1 Mar 2026 01:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328437;
	bh=7J0YQcHD0R4VBi8FjeoHE/Ciq27EXrWrJo0tT1YxN44=;
	h=From:To:Cc:Subject:Date:From;
	b=RS21fPycXTMghQR6ob55Z1+4x1tQVoI7SsXQs+Bgml9SSQegZsod6doT26ISi8GLX
	 CiJPTGyJW3AefQ0a/TxsY4Cf3prZApEiqFI02i3d2WTFDNHLiBcZ6d/51nuO/jZXGX
	 Q3Q/IsagT8d3snI1oNDLcJbha/0UHWoYFSWhfHP3WeWQFTXobGhJ/4cXacE8lNwHzO
	 ves2zSPwBRcUfzeRSye3xx1h25f6mLYxJ+K9PJB6qjIrrV0ulPUavU9lomfHbRHX/L
	 G8k7r4Y28dxI/6LqZb+WmX7ieJ1m6Iaf28MfjeEGyTIWYrNr9O6aMNPb51f8ca51tP
	 o+f9A4g+p6EJw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:27:15 -0500
Message-ID: <20260301012715.1684735-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5b1c6149657af840a02885135c700ab42e6aa322 Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:59 +0100
Subject: [PATCH] smb: client: let smbd_post_send_negotiate_req() use
 smbd_post_send()

The server has similar logic and it makes sure that
request->wr is used instead of a stack struct ib_send_wr send_wr.

This makes sure send_done can see request->wr.send_flags
as the next commit will check for IB_SEND_SIGNALED

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 20faa6d7f514d..88fefb901c27f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -35,6 +35,10 @@ static void enqueue_reassembly(
 static struct smbdirect_recv_io *_get_first_reassembly(
 		struct smbdirect_socket *sc);
 
+static int smbd_post_send(struct smbdirect_socket *sc,
+			  struct smbdirect_send_batch *batch,
+			  struct smbdirect_send_io *request);
+
 static int smbd_post_recv(
 		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
@@ -1021,7 +1025,6 @@ static int smbd_ia_open(
 static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_send_wr send_wr;
 	int rc;
 	struct smbdirect_send_io *request;
 	struct smbdirect_negotiate_req *packet;
@@ -1052,33 +1055,12 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	request->sge[0].length = sizeof(*packet);
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
-	ib_dma_sync_single_for_device(
-		sc->ib.dev, request->sge[0].addr,
-		request->sge[0].length, DMA_TO_DEVICE);
-
-	request->cqe.done = send_done;
-
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
-
-	log_rdma_send(INFO, "sge addr=0x%llx length=%u lkey=0x%x\n",
-		request->sge[0].addr,
-		request->sge[0].length, request->sge[0].lkey);
-
-	atomic_inc(&sc->send_io.pending.count);
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
+	rc = smbd_post_send(sc, NULL, request);
 	if (!rc)
 		return 0;
 
-	/* if we reach here, post send failed */
-	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-	atomic_dec(&sc->send_io.pending.count);
-
-	smbd_disconnect_rdma_connection(sc);
+	if (rc == -EAGAIN)
+		rc = -EIO;
 
 dma_mapping_failed:
 	smbd_free_send_io(request);
-- 
2.51.0




