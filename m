Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8560E33B6F6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744217; cv=none; b=lYVzZtQVBInaxNLgEE5iugIvODH7WuHdiA7adFDH3x9loeSEHAEOpSfH2/zAof0m0VBRh6AB4i5Puez6q8De8lagUE+DHgVGLm//9gNV8EaQwXUwZ4j6I0nkfKnvLqz4aEwZ7NB+fGzdwSDOxcx12WBvd6MOOZSi6JEZJaIIKAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744217; c=relaxed/simple;
	bh=8/snDohSArbP3A1SO5O7J5cDBfGfzqEQgOWdOhJ2jFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDr+uP5yLx4U2ftuqPF5NvnxdxtGjzEE2SizbZaIAmpRj+fyWnnfEjNS8MoRVg/uty5HQkE0mvSp5q6QkUyQ0qoAvnKAme3saWzM2jhalrWoDNnYecwy3MaExwjdDXyU7iAbDLusDSTYEZEUh+7XhkIxlNYDi/3O3vtJIGW15ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=v5dGOf07; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="v5dGOf07"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WDnG4dTUK/0i2YUk9L5cV7ZWopeYOVDlFDWoOhQgtG8=; b=v5dGOf07DOdeSm45Qqc23+AvEC
	ft5RW6h87AGigoCW53/LVjjsdRFshAcbg6ZWNjJjdYVp2EoTR23SAD3P99tOAOcydJkbaoXwAQZFX
	nrIkwDSQHwrT9yPF3UBIKB0w6KD5OFnk0WGRxyWxxeKht4mFFVAAKr9TuaSt+NQZXekWh5nEfrS5i
	wPxQnjuY3K3PZGLjo6AKQ2KGlIer8yzzb12/QVpouQfHNCz/F3rAeYYzBX49SKcpl6BI+Kqs0Ot4G
	c7YinPV093wDXq2H43EnGXcWZ2xZB3ikJd+/LKh1e2OhhFiASgVcQzuCUl6Rq0aNVTl8MRpLWbmYy
	4yRJEedyrqtIVh5RparszsexRyeZf+mqrFscvHKSDqYjYncPlR6yeZw9+5+hNIKneOfrcdogjBBrK
	975R/Rbu14YQkX84mN0clU7JPPbF/FCtnoogo/+ybA0JWcvatae+YcVIkkZzQhLyf8rmY7Tzh8QfQ
	YBKnLrzDsBypmkWRxu9xrefV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69E-00BbJi-0c;
	Wed, 29 Oct 2025 13:23:32 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 010/127] smb: smbdirect: introduce smbd_disconnect_wake_up_all()
Date: Wed, 29 Oct 2025 14:19:48 +0100
Message-ID: <93242f5b9813a13e411183685ee0f32ccdc19b15.1761742839.git.metze@samba.org>
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

This is a superset of smbd_disconnect_wake_up_all() in the client
and smb_direct_disconnect_wake_up_all() in the server and will
replace them.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_connection.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index f7fc4b1732c4..654719f4388a 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -44,3 +44,21 @@ static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
 	sc->logging.needed = needed;
 	sc->logging.vaprintf = vaprintf;
 }
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
+{
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.lcredits.wait_queue);
+	wake_up_all(&sc->send_io.credits.wait_queue);
+	wake_up_all(&sc->send_io.pending.dec_wait_queue);
+	wake_up_all(&sc->send_io.pending.zero_wait_queue);
+	wake_up_all(&sc->recv_io.reassembly.wait_queue);
+	wake_up_all(&sc->rw_io.credits.wait_queue);
+	wake_up_all(&sc->mr_io.ready.wait_queue);
+	wake_up_all(&sc->mr_io.cleanup.wait_queue);
+}
-- 
2.43.0

