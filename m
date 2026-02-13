Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3690B35FF49;
	Fri, 13 Feb 2026 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990755; cv=none; b=ccBVSORQdMPAFr3SIYAEBiH/IM7c3ldx7cSNR/z/zQ+H/phUuCyJUDVxouUKKkLO4uTIbQkQX5jrLy5C92RPZykoV8DBpp6foPhRW9OiORa7zZoVhZstBX4kTHy8CRUN/G1gWmkY2zS4Ih4h7s6mi0uWT1Wo6CPiH9KQLJ+JWi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990755; c=relaxed/simple;
	bh=vAFo1FTvscyKR0jw7AilSh5ai7ccOVYI40TCUOy4agI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQb0A/LrF3IINJwCl6wX6DeXxUYXBuXSq363Jw5Q9SOSlIDbiyvUcBfanvV4OKZxpmXwVovHw+5BaUoVYTxHUg9TlB3wPTnanOyhqzRTW6xKXEqjV6vPI0EYhDkFbrih3CSehLoQU48EWuLJHZgtdqDo4anJhWgBAH76aUct2CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duIXhlJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duIXhlJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6196C116C6;
	Fri, 13 Feb 2026 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990755;
	bh=vAFo1FTvscyKR0jw7AilSh5ai7ccOVYI40TCUOy4agI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duIXhlJTTcd+sTMbwFBbMdbLvKWv3fKk3XDLllst+34Eq6E7Ou6Zv2OTA83zbHsZV
	 N3mX42LHi7UwaJ9nhkKC38TbYbiMFPLCNeXC5X/0rwA0RrQ0LsVWDvxl/15t2fBY/K
	 2jxdbejoSCW8Ha9A8As1m8/SWEMoVdGTBZUgA+No=
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
Subject: [PATCH 6.18 15/49] smb: client: let recv_done() queue a refill when the peer is low on credits
Date: Fri, 13 Feb 2026 14:47:59 +0100
Message-ID: <20260213134709.446291975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit defb3c05fee94b296eebe05aaea16d2664b00252 upstream.

In captures I saw that Windows was granting 191 credits in a batch
when its peer posted a lot of messages. We are asking for a
credit target of 255 and 191 is 252*3/4.

So we also use that logic in order to fill the
recv buffers available to the peer.

Fixes: 02548c477a90 ("smb: client: queue post_recv_credits_work also if the peer raises the credit target")
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
 fs/smb/client/smbdirect.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -663,6 +663,7 @@ static void recv_done(struct ib_cq *cq,
 		container_of(wc->wr_cqe, struct smbdirect_recv_io, cqe);
 	struct smbdirect_socket *sc = response->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	int current_recv_credits;
 	u16 old_recv_credit_target;
 	u32 data_offset = 0;
 	u32 data_length = 0;
@@ -747,7 +748,8 @@ static void recv_done(struct ib_cq *cq,
 		}
 
 		atomic_dec(&sc->recv_io.posted.count);
-		atomic_dec(&sc->recv_io.credits.count);
+		current_recv_credits = atomic_dec_return(&sc->recv_io.credits.count);
+
 		old_recv_credit_target = sc->recv_io.credits.target;
 		sc->recv_io.credits.target =
 			le16_to_cpu(data_transfer->credits_requested);
@@ -783,7 +785,8 @@ static void recv_done(struct ib_cq *cq,
 		 * reassembly queue and wake up the reading thread
 		 */
 		if (data_length) {
-			if (sc->recv_io.credits.target > old_recv_credit_target)
+			if (current_recv_credits <= (sc->recv_io.credits.target / 4) ||
+			    sc->recv_io.credits.target > old_recv_credit_target)
 				queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 
 			enqueue_reassembly(sc, response, data_length);


