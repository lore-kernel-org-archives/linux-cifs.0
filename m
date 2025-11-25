Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB87A32C31A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093608; cv=none; b=PHYJz3LIfOCSOF99/hOeyXhKMaMWujg6TLWNEWmvEYHe3JigSTCkzChekErxlwRu2n6tkLexo/gC6Cp7JIuwZ7lGgkoTNvA1PS0yVALdjQb/3T5fhgOqC1koyMS9q+wQN5bwNLlLIKy9DBNBnVSiJ5Q7370kM3iEaIaKmNQiWzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093608; c=relaxed/simple;
	bh=EfiN1DbooIrZ841F6llEDE5WwKlrZhg+Yfmk3J5IYkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEHes3zDpfpPu9gLmG/s+D1cC5bp1zbXSGf98LFjFQ3AC70U7J+3qmdyzE/xc0wZ07YfuPl91TPpt0GgYUVe5aXOnEuxXXhtqER1niGXkf8JZKSEMQ/xhlnDBe6/Qolxp10Px6Hm+uWlC2RkHmK6tlAmNkp/oH7O1N47P82l/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BvunW+gl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BvunW+gl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xmmDMC0Amk5/s+6LR6nD0AkP0PL58sMD0MDxtu05kTk=; b=BvunW+gldsVFMRy7F0rqMcZMjV
	pe/CSKhVoysobCjqiyGo04gqJqSlPapzrLDQ40XhCEgOiCldWqu45ZZEYzFbZO9BvVdkLx5vlOPGE
	lfykEt0TzmmYBz5ccMcfHTsA17pp5wUHJLDjo+0fmLldQjDLXN6WbPnosSGxC56Xf91b+QE4bLe9a
	zqZzp/nbAEqxX8yx2gsSETEeNEqwFx2UkkBEH1cC04GygPBQ3VjIwAh0F5QRW3tO1KQk/zg7LGVj1
	Ig4RtNQq4Xuhk5N47iUy53Vxp+eEKdJNUmDKc3G/PtWzBFyNxKk4LUUQfeN4/ZcRQy5rcPhQRxq0n
	78p5mWpJo1U/qg3xDdyJNAbnPMldpUXJE6FWNaf5mzdcXUv7kvsB/U7H99FswxkQYBGrzNHCG5SmS
	ZM+z7l4Zj4AJNX2pZUylSizHRQ0v/o66BuVwO0q8SlUOT+ncE0ZEeyvgEPhHVeCUaUPK/+ZhCvcyV
	iuXT6mQzVFoRddWauUy5ku0w;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKX-00Fczp-3B;
	Tue, 25 Nov 2025 17:59:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 033/145] smb: smbdirect: introduce smbdirect_socket_wait_for_credits()
Date: Tue, 25 Nov 2025 18:54:39 +0100
Message-ID: <2c1d666374bb4020e08f2054e94865dd8cbc5d12.1764091285.git.metze@samba.org>
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

This is a copy of wait_for_credits() in the server, which
will be replaced by this soon.

This will allow us to share more common code between client
and server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_internal.h |  7 +++++
 fs/smb/common/smbdirect/smbdirect_socket.c   | 29 ++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 7465a63118bd..43ef6e39f28e 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -33,6 +33,13 @@ static void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 		__func__, __LINE__, __error, &__force_status); \
 } while (0)
 
+static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
+					     enum smbdirect_socket_status expected_status,
+					     int unexpected_errno,
+					     wait_queue_head_t *waitq,
+					     atomic_t *total_credits,
+					     int needed);
+
 static void smbdirect_connection_idle_timer_work(struct work_struct *work);
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index c064cbcb6b5c..9093352d1a57 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -279,3 +279,32 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	 */
 	smbdirect_socket_wake_up_all(sc);
 }
+
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
+					     enum smbdirect_socket_status expected_status,
+					     int unexpected_errno,
+					     wait_queue_head_t *waitq,
+					     atomic_t *total_credits,
+					     int needed)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(needed < 0))
+		return -EINVAL;
+
+	do {
+		if (atomic_sub_return(needed, total_credits) >= 0)
+			return 0;
+
+		atomic_add(needed, total_credits);
+		ret = wait_event_interruptible(*waitq,
+					       atomic_read(total_credits) >= needed ||
+					       sc->status != expected_status);
+
+		if (sc->status != expected_status)
+			return unexpected_errno;
+		else if (ret < 0)
+			return ret;
+	} while (true);
+}
-- 
2.43.0

