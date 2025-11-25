Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F4A32ABFB
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093517; cv=none; b=laFrCz5x538H9pg3shlgAW42fqbbpzZke/Cs6kqn4tg+thUpO2ttNnrtY2PwKN5fj5RcdVosas5cYxcx49ATfti6p58yYJqhrPhpu0vG+1QOpemoojgcDJeoIx4BEFuzfMOjVDW+SPdbMePennVgVGuTYCNcRzlw9RGFbAVkYT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093517; c=relaxed/simple;
	bh=b+ZMgYKa4Xw0KV+nU20IVXTpeQBh5r0DpCpjfaDZa7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlQJ3jK1mGLlCC9P6RpotZX6AAlAoeRaLZB6czRh/FL9koQI+3LywbN9OTE42gRxyADMxh8qmI1sw5vwprDznbMKlPiqyg//quqqr4X5EkK2MVcFy8TaXajvbBT6MUivcw0myTDLRvRqQFeHgUBtZSw3g2VnFhlgN/dF35+aOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BQgk0gM/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BQgk0gM/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=MV47yqJjczDICxGmwqAcKHKQQ8LAkQswBHeMLwVNCn8=; b=BQgk0gM/dAvbotZ/W5oXpHIghU
	OClA/Dmvryqe/2BHlh1G9yVideYk9g3kCpLxYpoDQOVTrGWQgfA7NOTgpfRZHQwvoyUKW4fvcj8QR
	zHzqdpEe1h5VthM1CR3rImf0jmc2n4+3kii7iJk1dDTSwZDsQOX3tcfXBH2i6UEYrccJcd7D3kheO
	vrUJavfy8G0XrY64A+VkmIkH1oZ/b3yJJjL8fWykYQ0I6AIgHRVZUjz5RhRrNEFKuYhOI7Sq0ixY2
	4Yz5YjTiAUbaE/5Qi+SRnmVOY3S+vaBFjBN677uWg94ShDHscqBNm10+bsx+SRI8VSClRjxYS/GE2
	DWdCNjFRi0PjsJ1DxIJj6v0vE4bgkPy2fkxGuL7bLxieaqf6NwTPycDxLpGKN0gOQHClJHF0ZUxlK
	yvmDRQT9Yhh0Lb6GMxJbaw9tFr+usNtQmU3CXw9nHnvk1Y1vJNSpWzBp/0Ta2h6Tp2OIh3FHGisAP
	FB6C+RrY9y6AEfbSMxTP1Ftp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJB-00FcmH-2P;
	Tue, 25 Nov 2025 17:58:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 019/145] smb: smbdirect: set SMBDIRECT_KEEPALIVE_NONE before disable_delayed_work(&sc->idle.timer_work);
Date: Tue, 25 Nov 2025 18:54:25 +0100
Message-ID: <20871ac6c73e9a0eaad43f6ebe6bbe99d7e3d57e.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This avoids a potential confusing log message from
smbdirect_connection_idle_timer_work() if it's already running.

This is a very small race windows and not really needed, but it feels
better when reading the code.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 37b483d8203b..cd7192584820 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -106,6 +106,7 @@ static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
 	disable_delayed_work(&sc->idle.timer_work);
 
 	/*
@@ -206,6 +207,7 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
 	disable_delayed_work(&sc->idle.timer_work);
 
 	/*
-- 
2.43.0

