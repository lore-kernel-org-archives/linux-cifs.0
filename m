Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E7C20C48A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093674; cv=none; b=QuxAYRbthaLG0VtHexgzYcji5LFI478zrCMz0cqsHrUtbWlq6r0xl8tcl//bCq5u7ZigPp5Zkpc29OZQXNnkiXgwn0+pXttnWSIg5LvsREh9CF6PDdCcx5COmnMXJ+3DJsRi/4GSqNY/ecREJ/9D+korgCP9Za0QbX2daOatdr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093674; c=relaxed/simple;
	bh=z4g9bSmZdBnKny+r/YQIaveLg2nW/VvmycsSsAAssb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmUBh8W0Rrb8yIvkmQQggWNn1+brbz4CfcdtbKb6XHB3cfGv45HziVIZOH0d2UelF2jxGKoXSwIQLE+hk5TY5MYexbA5b6tBUOeh1kDjECagTt2sbwTdNFAWbNvtuEbNoaX1dyL5OzlR2qL6V++BkCuqV+pscrx1hBga6T7RsGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mMN+wwIm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mMN+wwIm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=EpoLEjPg3e9EgX+ABPGUpWDMOCb4QTXEGClbyQCtMUw=; b=mMN+wwImZHooHF7EH/UGyZjB7x
	6iArF2tHwvsGwMVVwcJjjNWgjQyhFPvk+e2xVJ8kGeVMsX5WYiLW7+ZBV10sCZRLSIywrfYw+WPgJ
	YN/rXHSvNQ2wqjObKKcYfWTIH850mQhHg+dhPjxynykmd1nkoKKFI+3KUruaeNbkJDQIXws1Y89Ea
	LVHE9zDPUWuHtu/gv4tP/c2CBszVuCAt2y61FPwMUm1k+CBA8T0iS6NnaDkF9qyJWVoB8EMqckOwT
	Ut7zPkaTQcGe2mwggY2X96JLPJLbOLYxANkd8y8ptv1BtvUofRZbekTnUBtwK3O0GUhMvkhDi2DTK
	bm0JsB7RSqPIPkRfp2jlsObw/KvyF9dc1LFLuzUs2dmamS1VzIk3Mx9fb0TQmSsM7nxNMiIFQg5qq
	8UsISK/9aj39Jk+DB9IbxWMlRQKPUdnnJSLEcI3RurwpgCHBG5/cnZkvif+ARHOGSHDESUHfbyafV
	RnozArzBOEwQp8HpcUz9zZUJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLf-00Fd8c-0v;
	Tue, 25 Nov 2025 18:01:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 043/145] smb: smbdirect: introduce smbdirect_connection_request_keep_alive()
Date: Tue, 25 Nov 2025 18:54:49 +0100
Message-ID: <647ecd059c2b5ba426da04e6c025bcc2ebad2cfa.1764091285.git.metze@samba.org>
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

This a copy of manage_keep_alive_before_sending() in client and server,
it will replace these in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 6dce0f0c126a..9901c5d01958 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -724,6 +724,25 @@ static u16 smbdirect_connection_grant_recv_credits(struct smbdirect_socket *sc)
 	return new_credits;
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static bool smbdirect_connection_request_keep_alive(struct smbdirect_socket *sc)
+{
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (sc->idle.keepalive == SMBDIRECT_KEEPALIVE_PENDING) {
+		sc->idle.keepalive = SMBDIRECT_KEEPALIVE_SENT;
+		/*
+		 * Now use the keepalive timeout (instead of keepalive interval)
+		 * in order to wait for a response
+		 */
+		mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
+				 msecs_to_jiffies(sp->keepalive_timeout_msec));
+		return true;
+	}
+
+	return false;
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-- 
2.43.0

