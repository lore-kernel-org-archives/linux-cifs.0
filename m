Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FCC2690C0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744252; cv=none; b=FNAKFY0Q3NEjVjIscFajGcNTFRgyLxoAs88/10clm3gVNtMj/Ecb0E/hW92VmP0uZLVxIeSOuSsDhiNTNT76l+uTxvRmWB0TAFpxDOh748Oqu8WRryekTuJ2zHruJ8HLn7edLk+VxWPKbP5NHyd8SKBpo6kLP52/XUQT105NVic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744252; c=relaxed/simple;
	bh=WR5W+DYeLwFwtl17eGJCIwtwC9RUfIZ/MJUrBv69wy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzCj7+LlmGIqeWMbO7zLkt3qD/kxtR7yXVmpzgIHiGs1mHUB5gwyJYXDuKwsDkXtvh0tm2XP4W2xMP9tq3e/YdBWH76uww9D+JP44ylOKttFMIKm0GjM+BIRC4ZDXHwItiMIJ/elx3WnoB3sOjVXl6j3bo4CD5QzbcQHBoH/37M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tDB+I9SS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tDB+I9SS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=T3vjzA3huYTGlZnuztf4h2U2T+gDWn0Ta3XDGST01C0=; b=tDB+I9SS/SfiAZi81V8TzY+3yZ
	iaCHW+zdZnNebMMnnGM5j1nS9CnZxCKababMkrJucU0+iTjpfXyyfsCYJ3E3O+Grp529OM0/0gTxP
	ToSIWhSAmZs+DZ8yPvij2OXiCEds7WwFDk+s/VzfeL/KOrYUUT8EdKLj1lJvuj4gQxPCAcl4szbWs
	U9pR7wYkbhC+uMc2W8y6xRM9FniW+aVHnaIKYg1OXYHOU0D7/O153Ozk+4471aqRs5LG+UxuYXGUJ
	+AjNJ15KPMexTCFpEiHiEqQL9tnEGl3J+rJUm3+TwcRmlR6iDyRTFBSmccfT/pg/ZTQ1K3J4zSF8J
	/InPKm9IKlnw9A5hWP09JtQC6Em9Gg3f0nsRny1V1gNwNcMQNlXMJQhWvm6L5uhhg90MbPhMsyVlB
	hl3LoDI9nq+o2Sio0kJ1kTRxUN5U5q8hd5UJIbE+OfkrS65dUD2sRj4jPZPomMdxgfRAZBsQHdZor
	l1x9KTskEFmSDiwHkbY/0HVg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69m-00BbRB-2B;
	Wed, 29 Oct 2025 13:24:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 016/127] smb: smbdirect: set SMBDIRECT_KEEPALIVE_NONE before disable_delayed_work(&sc->idle.timer_work);
Date: Wed, 29 Oct 2025 14:19:54 +0100
Message-ID: <26043564f536fc7332f26e5e4dbbcd9ebaa250cc.1761742839.git.metze@samba.org>
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
 fs/smb/common/smbdirect/smbdirect_connection.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 79be89a3946e..8d00a456c513 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -160,6 +160,7 @@ static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
 	disable_delayed_work(&sc->idle.timer_work);
 
 	if (sc->first_error == 0)
@@ -235,6 +236,7 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
 	disable_work(&sc->recv_io.posted.refill_work);
 	disable_work(&sc->mr_io.recovery_work);
 	disable_work(&sc->idle.immediate_work);
+	sc->idle.keepalive = SMBDIRECT_KEEPALIVE_NONE;
 	disable_delayed_work(&sc->idle.timer_work);
 
 	if (sc->first_error == 0)
-- 
2.43.0

