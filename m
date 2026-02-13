Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB423645D;
	Fri, 13 Feb 2026 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990623; cv=none; b=fu/A03wh7C6QDNr7TBV9Wa0+jumhWbHzYhgTMBhtWWBB66zaFo1fP3yRFNupHQhLd70nTVmb/2OXUJc5tRTWvGQi6Xmt/7MhDk/1NkPm8s1qsO+jRkVHo2I9moVpKSVJ1DzlD1pizQHQmdK2l1OxH7ec5H/RSyK6Codm1+j7bp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990623; c=relaxed/simple;
	bh=5zRP6uxcwC9qai8yZ+fD2VVtYcp39VdOXk4w8tS25zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3PFz1VLvUAmVm5yzFrguM0gpDHk8F7aEu8at206eDP16AB/h+eEpvk9qRlUJ8jz5k/XI5oCctPy1iz96YsyTMukMgHcNHaYEM/GvHI5Z3ZiHL1kirinQZdlQwRRotkUEZq6ImnnZiXNqIubEmkChTslucjiaTqjbkxt9wGYbec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q78XU1G5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q78XU1G5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE306C116C6;
	Fri, 13 Feb 2026 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990623;
	bh=5zRP6uxcwC9qai8yZ+fD2VVtYcp39VdOXk4w8tS25zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q78XU1G5sF2W5UdDH2LCUkDl6hZupF3Px9zpHrVXQzvrZCrr/DesFz0/MO1aOK1Sw
	 VXr7tGtC68wY1ZyKVF+KsH2Hzeh1mo6VE58Tee/yrd/+c3FWFA4+VWTo5RDU9MwKy/
	 oTWKShpjmUAGpAC4YHSev9qFAHjrURpx1dYSru7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 25/49] smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
Date: Fri, 13 Feb 2026 14:47:44 +0100
Message-ID: <20260213134709.655229484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 5b1c6149657af840a02885135c700ab42e6aa322 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

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
@@ -1021,7 +1025,6 @@ out1:
 static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_send_wr send_wr;
 	int rc;
 	struct smbdirect_send_io *request;
 	struct smbdirect_negotiate_req *packet;
@@ -1052,33 +1055,12 @@ static int smbd_post_send_negotiate_req(
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


