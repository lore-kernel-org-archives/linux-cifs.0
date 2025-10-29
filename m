Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24542BF007
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744387; cv=none; b=Qg0gpQfoi8Tzi1DX+HaTcIFrRDMYpfdrp3m83vOioYCD+ZPtVoffalwR62UvgCd6nsi7e+2QqL5jkpkzUa3ugEK66TKw7p6Nra+/47EXwVEc7ADCdN7xIcmyuNJyr9yWyygxGAOX6XQvVG5WP/Ictj68JlozXKYijtILwCyDPwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744387; c=relaxed/simple;
	bh=gXu3FpoPD7nh+8lC7hzPSg8i6iA5WSdE0BGKF3+usgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKMscVwsXoVyRVNvGoAEEfXD14tEQbKA5lrxZwX9PSJ3GqOmb/jIUVlf0v+mq9FIFuokb5KkwBdcI8uM6zyWzg46wkYEMZ5+qHefaDdbC2YtZS4X4O/ahZ0MnHMKV5+Qj8XazPT+LkFqeBfFNrjtUFs+wIuUkWuSreW3ncnYVpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qHiaK1mI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qHiaK1mI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=e7TfcKaWR4gsMnrLU7rOVYWG0pCaz323t4H8ikpYczE=; b=qHiaK1mI5kW/r1hSfgn5s4YKvy
	s6hyhrPWK+YP0e4AD7+muaICPeiVQkJoDuO0FbsjnLRa7ndnzpVh75KXNdKJ67RA1j8pJY53eyrrb
	xCeDb95BE6pIC4GxKhfhbuaqJyCeLpqcozWoagTaWIiX/LjHoV5ZKATrduuqQxl3/bHKCvcQD+wcp
	LK/6315WRlLM7DUvopIQPBaUxNeaWP5NHmFWFfEhgFAQwcspPzyIC6I7rpl7g9Kb6GmLleAM3zsFm
	sccqb/KMtXuDuZ6e0Z0CR7XaC935eVt2c22mNcsqBb+9qT8c8LTOPvF3bSMXbu8vz3k0M0r0hz2QK
	uBqyEXAYnDg3bduXL6uuIuWSpI5GhAZwIhtPlcGKkuGV7kPEu2SPG4uS3gDcEyCi3PPQlN397AYKH
	EMjNGFcOhXhPYCu+CSrw3PfSI7H8CdzEc/1qkaNkNs4SuAQBncEcOOLo+9kul/dHgIofwC309zLUy
	ymkXRX/z1HxgWLN2ex8tZuTa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Bz-00Bbm0-11;
	Wed, 29 Oct 2025 13:26:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 039/127] smb: smbdirect: introduce smbdirect_connection_grant_recv_credits()
Date: Wed, 29 Oct 2025 14:20:17 +0100
Message-ID: <5ad2a4ef1c3df9c69d20248ea607367705ff5651.1761742839.git.metze@samba.org>
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

This is a copy of manage_credits_prior_sending() in the server.

It is very similar to manage_credits_prior_sending() in the
client, the only difference is that
atomic_add(new_credits, &sc->recv_io.credits.count) is done
in the caller there.

It will replace both versions in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 36f82b090bc7..da2e9ecdd98d 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1037,6 +1037,26 @@ static int smbdirect_connection_wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static u16 smbdirect_connection_grant_recv_credits(struct smbdirect_socket *sc)
+{
+	u16 new_credits;
+
+	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
+		return 0;
+
+	new_credits = atomic_read(&sc->recv_io.posted.count);
+	if (new_credits == 0)
+		return 0;
+
+	new_credits -= atomic_read(&sc->recv_io.credits.count);
+	if (new_credits <= 0)
+		return 0;
+
+	atomic_add(new_credits, &sc->recv_io.credits.count);
+	return new_credits;
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-- 
2.43.0

