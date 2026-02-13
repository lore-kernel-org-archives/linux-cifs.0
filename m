Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4F954723;
	Fri, 13 Feb 2026 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990752; cv=none; b=X7CoR52ExtnmQY9WtK+7NdxDnb3zO0VeuiMJLhXB4tt7hHv0lIsPh2PRxJCxBNnvrVrA4xbEH+Z/6sTosWaAljN66ZpZA1yR595Dxc/58OMjanS8NiLDPDznRk97BGiQ9GY8ke3UrUH3qDxF3SZCxKosVnA72yZRzvP7iWhFXlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990752; c=relaxed/simple;
	bh=+iAArarCr0PM3ohnUBZLoSEORrTah6jKrA9zLdMtSuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgtgYa0glHpAalWRbOl0gC8FSyvXwwPbjByj5ZuJMfyWqfmgXB22LvD0Pn+3G1mLROJYYF2nZrmUbpH1z1oAsvvJ9+7x255YTPY/8GZz7N8m8YviB1twS/0Yo8sZ0CZCFlHtopAzzdy1azYvqZF4EIycOPJQd1mr2Vzw2X8C3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0EoFCpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0EoFCpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50943C116C6;
	Fri, 13 Feb 2026 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990751;
	bh=+iAArarCr0PM3ohnUBZLoSEORrTah6jKrA9zLdMtSuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0EoFCpwwO1eq5MZzw9BgMVSv9sROc+vfECS9D97uGBIyF1MAIz6XlfkhAtXQ8t5K
	 4dKFQKwE0v7guf5+zt11jQx76fC5oCxgFj7ufJp1azqwndzqj8uEuEo4eu7NPCnc+T
	 H6C1Jdq+bOUiKG5TKfrja2g/Az64r8PoRWGHjTqg=
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
Subject: [PATCH 6.18 14/49] smb: client: make use of smbdirect_socket.recv_io.credits.available
Date: Fri, 13 Feb 2026 14:47:58 +0100
Message-ID: <20260213134709.409827711@linuxfoundation.org>
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

commit 9911b1ed187a770a43950bf51f340ad4b7beecba upstream.

The logic off managing recv credits by counting posted recv_io and
granted credits is racy.

That's because the peer might already consumed a credit,
but between receiving the incoming recv at the hardware
and processing the completion in the 'recv_done' functions
we likely have a window where we grant credits, which
don't really exist.

So we better have a decicated counter for the
available credits, which will be incremented
when we posted new recv buffers and drained when
we grant the credits to the peer.

Fixes: 5fb9b459b368 ("smb: client: count the number of posted recv_io messages in order to calculated credits")
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
 fs/smb/client/smbdirect.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -618,6 +618,7 @@ static void smbd_post_send_credits(struc
 	struct smbdirect_recv_io *response;
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
+	int posted = 0;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		return;
@@ -640,9 +641,12 @@ static void smbd_post_send_credits(struc
 			}
 
 			atomic_inc(&sc->recv_io.posted.count);
+			posted += 1;
 		}
 	}
 
+	atomic_add(posted, &sc->recv_io.credits.available);
+
 	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
 	if (atomic_read(&sc->recv_io.credits.count) <
 		sc->recv_io.credits.target - 1) {
@@ -1033,19 +1037,38 @@ dma_mapping_failed:
  */
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
+	int missing;
+	int available;
 	int new_credits;
 
 	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
 		return 0;
 
-	new_credits = atomic_read(&sc->recv_io.posted.count);
-	if (new_credits == 0)
+	missing = (int)sc->recv_io.credits.target - atomic_read(&sc->recv_io.credits.count);
+	available = atomic_xchg(&sc->recv_io.credits.available, 0);
+	new_credits = (u16)min3(U16_MAX, missing, available);
+	if (new_credits <= 0) {
+		/*
+		 * If credits are available, but not granted
+		 * we need to re-add them again.
+		 */
+		if (available)
+			atomic_add(available, &sc->recv_io.credits.available);
 		return 0;
+	}
 
-	new_credits -= atomic_read(&sc->recv_io.credits.count);
-	if (new_credits <= 0)
-		return 0;
+	if (new_credits < available) {
+		/*
+		 * Readd the remaining available again.
+		 */
+		available -= new_credits;
+		atomic_add(available, &sc->recv_io.credits.available);
+	}
 
+	/*
+	 * Remember we granted the credits
+	 */
+	atomic_add(new_credits, &sc->recv_io.credits.count);
 	return new_credits;
 }
 
@@ -1217,7 +1240,6 @@ wait_credit:
 	packet->credits_requested = cpu_to_le16(sp->send_credit_target);
 
 	new_credits = manage_credits_prior_sending(sc);
-	atomic_add(new_credits, &sc->recv_io.credits.count);
 	packet->credits_granted = cpu_to_le16(new_credits);
 
 	packet->flags = 0;


