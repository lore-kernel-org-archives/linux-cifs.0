Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BDF354ADD;
	Fri, 13 Feb 2026 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990586; cv=none; b=n5jnM1jSRiqj59sw9z4o9LHuXSknc3pi1fn0va7lb9kU2J4ljMlaYzbwNKWCeBl1NaQj9sPd1DBYGf8f34J0JHKHCKoHTbQj5k3vlYyI+4EnOx59zzltAX6RSrZk0dEQGN8Y1LGRKmp6Kzj3exPgLoCSYgtOKEe/ktUzNTyAFow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990586; c=relaxed/simple;
	bh=MJO5+IwiBtcq2DjHxHmC279SvXhbvenKpI4jv34wkN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVNnYCTjZKCgATpgx5VtkGJp3Ukf4Ceh4mXKeSbM1AIr4NA0ZHco1yvi7gjCjAgDs46Z00rLbVAV+7VMkepaSzbtvaax/Ku9v83Kgc6LuWTfS8GOfSuztR52VJKrUVfvmILyzK2GseEoo5FN+/70x+9TNpeEP16LsTyoIM5FuZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqWvVDjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqWvVDjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3043FC116C6;
	Fri, 13 Feb 2026 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990586;
	bh=MJO5+IwiBtcq2DjHxHmC279SvXhbvenKpI4jv34wkN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqWvVDjKjbLFTXVxQetOkWAt/L31GdVqzkovtf5RqKiO2tC0J/13w2abePZ1u45Nm
	 ooemX8sD7SDR2NXHAhlmVEMouUJzSuB6QXGlhe/n3vqSJphpUmmUtz3iMm+yMfS71m
	 8aKD0Sobmak5iFs0jfgMaR34JAiXHLZNDFFulZX8=
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
Subject: [PATCH 6.19 15/49] smb: client: let recv_done() queue a refill when the peer is low on credits
Date: Fri, 13 Feb 2026 14:47:34 +0100
Message-ID: <20260213134709.286111587@linuxfoundation.org>
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


