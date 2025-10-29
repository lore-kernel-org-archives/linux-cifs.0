Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D762882C9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744354; cv=none; b=AXdg11Q3shmNt9nn1n2uDniXbEwLzbLXC6vvJSOzXKd/GIP3dbiV6Q7pXENMwGOWXyL5k5hcSjg9M6S9tpaN+H7kewWyhmqPxn0d8EDRBmFTx0UTANEzfIb+Fj/tnTTgNUW4OnxbivYRcS+H3Mz/JMefuNUGtd4nWVBCHwzpWm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744354; c=relaxed/simple;
	bh=i6ffh0Wo7yKk1bbzJHXTgoKWu3EMxuwDzT2Sn2CetEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDxRTLBcnxOZLPKb+SiA0PGCjJW005dqCy2FgpgqnFq6s6UyDGWNuHZ962aatFa1sqkmkbZDifvfZF8ks8M1WNCtBwpXBFtTpB3EEDQzIBcVnswoqWfA5DIIOljBiapvZJcJWwkHAwHA4AfuIwcDTyTk8FUiMCa9eqM4YXbp/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HlNnSlMK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HlNnSlMK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6ajYJYZhn54gmmGtB6NnAVMb7kn2cgOD94NG20/NY+s=; b=HlNnSlMKDhoja2FDuOpY2HxwC1
	UhQ9BAw8xncXWeA8nb0EhUhFm6T3IZAydE749Ygxc37xHnF6yD+MEho6wwnVF9T/dyAA8IvXs0Z+7
	iUU+E61Jm0yok164xQ2Lcc6WwkjawCWBjr8FTfxv9NVuqZD9C8UEjdP1TgDMgAM1dFgiX4gZLV61N
	x6JBTkWNyTA3gMp4RaTbyIRfTRfKexr1CgoWi5Vg+Bq2DYcGWbEKy5OjzGkAC5QYqP9ifQ0TT5O0a
	H9ozsiOaWduuiR3TXTyeD4ZRUTC8VCwW6cN5rlnxk7mlwVg5FkEYu7tn+p+L7culS4vmLHo6ZUkbq
	JVhHjVTGydxcNyYbuqzdWw6NfmyossaTeaqN5JFv1laDOxIK7eh5HrzI4Uo0SY1cWptpOzNLxWQvy
	nw66ZZqrwQ7MT7XV9Sdii8ruypSRXjqJPA5KR0dS2/eh3HD4RvdjI4Sn05rs2gvBOYbBE/rv3EH/N
	rz8TtapGylz83SyqG1Xp8peY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6BR-00BbfZ-1v;
	Wed, 29 Oct 2025 13:25:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 033/127] smb: smbdirect: define SMBDIRECT_MIN_{RECEIVE,FRAGMENTED}_SIZE
Date: Wed, 29 Oct 2025 14:20:11 +0100
Message-ID: <02f575b80927faafd42b40531d26818c31e6cc32.1761742839.git.metze@samba.org>
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

These are specified in MS-SMBD...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_pdu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/smbdirect/smbdirect_pdu.h
index ae9fdb05ce23..7693ba337873 100644
--- a/fs/smb/common/smbdirect/smbdirect_pdu.h
+++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
@@ -8,6 +8,10 @@
 
 #define SMBDIRECT_V1 0x0100
 
+/* SMBD minimum receive size and fragmented sized defined in [MS-SMBD] */
+#define SMBDIRECT_MIN_RECEIVE_SIZE		128
+#define SMBDIRECT_MIN_FRAGMENTED_SIZE		131072
+
 /* SMBD negotiation request packet [MS-SMBD] 2.2.1 */
 struct smbdirect_negotiate_req {
 	__le16 min_version;
-- 
2.43.0

