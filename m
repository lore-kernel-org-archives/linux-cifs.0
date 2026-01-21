Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559483559C0;
	Wed, 21 Jan 2026 19:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025099; cv=none; b=oR+hmcuLAjvpzCaRkCeVDKsG6w+cLQeotU6Dlc27Kioxjx1xrYNmjsH579ecoYQaxKI4pAnyRkMCMXZHB9i7Yh9n8zUBpk7ZgqsXE4pLZp/1UYy+qqjtZo1aFi5/b5sciUx8ts4LjtTdUHC7DLA+ZRY9rmSH3vPbJRtJqMI3eug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025099; c=relaxed/simple;
	bh=RWRnY+JXM5hHAHQ5p79HU+WYD5c1l5YTQJfLiDRFyZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwX63Q/iup6Y7HMO1zRowZqJTl7nWLH8cdJMSx+4HwWbPMAD7qNz6OzL6yN9UNUrRsPOo9NxKtoqE4dBwsQla0CloxK7csjJwxfibqhZIcalRtJ+Y05ef2IUPkPgCWY/t7nvcl63TZnlhIAu4Y/wYCCYzUqV/Sighs9wJSvA+OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zknGOleK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zknGOleK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WSi2/gBepakiiWLY235b06t5y1YAqf6bIL7yh21lHSA=; b=zknGOleKHEaAqW+A9q8rfokr7W
	bRMX0gLWYZhZ1A3NRjARs4+MRP0MatSfT48Ys4WFPkGH1ex0AjdG2x9JEg4blpohuj7hUX0G+OQxJ
	rn8DM2abRFq1Rbxh8b6758JMTsCWcMOnTRiOT/YCcNNp+7pI9sXsO3XJwg8EwkW3uHypZjrbBrrny
	zmbQLFO18QTfJxBeQP6ch+ek5kgruRulRG/dA/NGBzl0ZKb/iZKXDy6HHNGN8KgaIucuu3RXvOPR6
	vA+fkVeY1bqZbHc/74KJ+nPQ5MeTZIr39igLYoIH4S7zW79m6wuk5KQcGZAkvdVV/vfAoTgVR4S2t
	b29bBlF42lV8kYAHzs+hWlHiO62K9jnvdWEkCS97Tk/eO8yNfcVmLB/Z6LYXSEpM3CaSkLg0QUJk3
	S7hXziqoCT9YYQlfBTSmNjpIJjgeNR0sfLDEB2PHghi6/AgsDI7B8CFysNLFXhe6V6ks2KPZQVlUE
	bmHbbdFQGggojxSUHy+zqA3x;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEn-00000001e1T-2mL5;
	Wed, 21 Jan 2026 19:51:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 08/19] smb: client: make use of smbdirect_socket.recv_io.credits.available
Date: Wed, 21 Jan 2026 20:50:18 +0100
Message-ID: <1172be6e0dbefae7211b68ec57cfc9ac25b8044e.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/client/smbdirect.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 788a0670c4a8..797dcf6e29bc 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -618,6 +618,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 	struct smbdirect_recv_io *response;
 	struct smbdirect_socket *sc =
 		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
+	int posted = 0;
 
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		return;
@@ -640,9 +641,12 @@ static void smbd_post_send_credits(struct work_struct *work)
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
@@ -1033,19 +1037,38 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
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
 
-- 
2.43.0

