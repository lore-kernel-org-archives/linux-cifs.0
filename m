Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57A0329C7A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093687; cv=none; b=H5eMpbCjaLNmPyXfz0JkKtfu6zQ4QGE6yRehPmYnmaItNPsAVQSidAgtHMTnrmhhMXjW0b4GUGaTCv5/s2qoqVZDd2htLPM4/PIIeXLftgzLaxlTk+iJwofb2JwnoBqgh+ttBfxcRGWOkDy7aVwQBh8cOhM5FM1OsEmSNoXI2E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093687; c=relaxed/simple;
	bh=0mIP4Mwfk8i/Gl3rIRwxQqsf8CJXbkOL+VSxhV2MFVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0E+LrXh1OJ9nja7t2xG0geGh4g++2ypSWd/5dNf4GE7QUaTVVPUhQK65IC9qwYcM4Jt3g30RPAZGeSuzvVsSjfFCUgcV04PS235TgLn0CsSaMSfNvITinHZNZ5zAHpw5Monj38WnIcdwSpboebRbINOFlV1nhiKKNFLaPn1yPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OkG5RE+C; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OkG5RE+C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lKA6ST1MbnQPG1RhcqVft3KRJy1bpH5GZVI+G0mS6g0=; b=OkG5RE+CwzcK4n+D2ZRCYRlxiZ
	gdWHQcDgZNufNr5olHpS1C3EWNEJvRHfbUKt6kcaDVUPbV+BVhMw0zzRZ1pSjY/xXZaFTQBZmsr3d
	7iYImayxqfUYXNPtWg944+MehS2UF59yCJOrjb/Uq3Lpvl3LyfjE/Ezf1HDjVW3Zzg89pnxsOrEU2
	jUOYv6Z7GD72aPLiQCHuhYA52uNuRWwgdZc1wgG7ylhPuA4yRqoFnha++F0EXqKmMvwR9wgMY60jH
	M1t0MG9QA8sEr5VW5uKAbGnkCgtNvXtt9PG/y7y5s81r6nz/KqPtJ1nTPv7tK5kqAc1b2mnL1/b0Z
	QInth88sI30Z45mZkcY2uatf7FLo4vE4ftWIXzlMdRGvdefWfUgFhQeOqwU62fiVBiWMNgyaiYTGc
	z2tLGO4FQPgD9AsNFKf9eOTzTA75eV84Bl60CzeUDpZgA4CHkiy6Qyt2LT4TJUubx/5na6faM7yW8
	htPMhmhS/jTeRq9b0JI4pZi8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLu-00FdC3-0J;
	Tue, 25 Nov 2025 18:01:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 045/145] smb: smbdirect: introduce smbdirect_connection_send_immediate_work()
Date: Tue, 25 Nov 2025 18:54:51 +0100
Message-ID: <dbb988f75cc4bff99de7a39313d36ffdd7a4eb4a.1764091285.git.metze@samba.org>
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

This is a combination of smb_direct_send_immediate_work() in the server
as well as send_immediate_empty_message() and smbd_post_send_empty() in
the client.

smbdirect_connection_send_immediate_work() replace all of them in
client and server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 1ba83fdc1e6a..8ee3a1e28f82 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1193,6 +1193,28 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_send_immediate_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.immediate_work);
+	int ret;
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+		"send an empty message\n");
+	sc->statistics.send_empty++;
+	ret = smbdirect_connection_send_single_iter(sc, NULL, NULL, 0, 0);
+	if (ret < 0) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_send_single_iter ret=%1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		smbdirect_socket_schedule_cleanup(sc, ret);
+	}
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 {
-- 
2.43.0

