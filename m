Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732001C8603
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410332; cv=none; b=VxX2hdWOUOuKRvH/giFWHb/F1fIuqdRXMYzL17mynD9kqH5/XSwn62Vw15y+GPBW+xzmxdz6HzviPkbjB+gH5FQohLo2msIonuBUFE4pJkIl472Mr2TFySnMeRbB55472ErPMgSNWs11YiMiixVNn02j42CEEb6pxBRroul2BcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410332; c=relaxed/simple;
	bh=js6H3R9HYU4XFjjdP9mq5Np5hlPC32Ek8hNkJdm0NaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c45smgPdDFucxHpNJm5jIwPq8hat1Bwc8akNreZfS1KJ/ul/MuhBeQylG9JjwoNDZpM4iG8xMJ8guEGet/spSnDj6ywJIfqg1JfYuBxL9uVt7ZfAkWdlIAPVfRW1jIL5kAX0RyvJNRPkSvZYN1d2AyEHzVILwoA3pAmXwzZtx38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jbSi/rzn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jbSi/rzn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vy09TOG3qbf7lpqnhHn+8cyvz/O/SxV+WGnY8OySDC8=; b=jbSi/rznSwn0qdXUm9mE/iITaX
	bJXQS8xVq/npgkzhf5REWd/Hcodvx5BYGQxZb7nPG21NMJonrnDlS3vgW9S8lInLoL3ptsllEruRY
	U5XxAlLg89+Fdpw+qPJMYvIqljRNLhfZdfmewGS1SU88GUzmwamXgOB4dhctXCPoPdjB7XllV7iK1
	+waJ0bKfBhp33GJRhxgNoxrR0p56iTRnha2TeyJXj6zzMptUOGe0ELahqpf1WcUeZWcu8BuK/4McC
	SJ6Fg/8uMCSHVb+Dy1dcVm35XaAzFPI2Tg8tL1w3CWOKQSZDAOUxlVLdh6mi3/iLiesOW56qGbBvz
	wLozAV/pM6UtOZTRr922x+gh7TZ/WzQTYbHCC6JwYbECHGehWU/H/G0vjks0hKAYfK2k0GGxmhVem
	/NOwfAFxIrb1I2dpBJxFOo8HttOk6/hJ0VdzAwXr24FOty9fagyHDp/c1ttHTJM0wM8t7UVg4p/e5
	AMMz/A032zSp+nutT2zn2MoI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKGl-0019ZH-2M;
	Tue, 05 Aug 2025 16:12:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 02/17] smb: smbdirect: introduce smbdirect_socket.recv_io.expected
Date: Tue,  5 Aug 2025 18:11:30 +0200
Message-ID: <48e2dbdfe70f4d65d29de2dff9b2c209e0efb066.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expected message type can be global as they never change
during the after negotiation process.

This will replace smbd_response->type and smb_direct_recvmsg->type
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index e5b15cc44a7b..5db7815b614f 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -38,6 +38,20 @@ struct smbdirect_socket {
 	} ib;
 
 	struct smbdirect_socket_parameters parameters;
+
+	/*
+	 * The state for posted receive buffers
+	 */
+	struct {
+		/*
+		 * The type of PDU we are expecting
+		 */
+		enum {
+			SMBDIRECT_EXPECT_NEGOTIATE_REQ = 1,
+			SMBDIRECT_EXPECT_NEGOTIATE_REP = 2,
+			SMBDIRECT_EXPECT_DATA_TRANSFER = 3,
+		} expected;
+	} recv_io;
 };
 
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.43.0

