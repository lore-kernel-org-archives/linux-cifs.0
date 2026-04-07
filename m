Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB830E0E9
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573252; cv=none; b=DwydpGub/5YFL+CN46CQKsx9gunX0+6m7kaz6zXcIMujkzNvr1C39X5VygVLJsr3ZDA6/S68P5Op7Q2puY7TQsIWfZcASgqoItysmhcHM+Fihz7hz4tq49u82whUWKQenLxn9Giiqs4Ut25d9D3jam2a+27Ph8fjFmXUtFMlXMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573252; c=relaxed/simple;
	bh=RqbYLS4KOn7QuJLVKU4yhmX2b15QHwqk/UEVRn0ixnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef9Klw+Y18ZYgRMfyekOp93nLz5PuMTBGvlAO55i1oospAJjwu1EUc0ckHNeAInwD6Nl76jr/Vio+f0YRdicP0MrzyzIOgDJwCewYKB7nStzdXrtuTFJk2XHWeMMI9CdELYtceOJRiX5avhrM0bj8EgUMBM9mNolv9VUW4pcm3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zHRNS6FW; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zHRNS6FW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=l0krKi8UISL6Klaznu4skUTTUG5mv1iJjgjo7qzhgiM=; b=zHRNS6FWZ1/0BgJN9F88xzff2a
	tFvON5ZfgkP9zJSK5nEVQwaDkSjGgPu5HzAduZ8TxsZ7Wuj9J0A5Vos6X2AUXgw48k/fnp8wJ+a9H
	tHRX3jL1YNHIHTJQy5mrbI9koR43ui8L/KraL0c6sa8+AnVWdBzqKldFg89/FsxCZwkkEJf+sNkx5
	pEgZHMpxbS7HYJrvqEurzou/do0f7sOhVhdnc1gcpXyluwxSomXasdxrSRR1tmE38KVeDivy3uGtX
	Sz8PxwyGR+HKFoWyoa7fyss7s+nGTe+0wCfys0bHG7ThUI+08qEM3toDMEieY02AZeS1Y4tLbW+w7
	nI1wq5Jm8tT3pM0Sa7hBml24yfkmvJf8bke4govf/ISNnVcuJRP8d0inx0ZF+a0+ck8vl3tPrln9K
	DgPJ7zwipa1eQQaMnjK5a+dyRarLOV0GMDCnzfTDnbMvVPk3e7dr7QsSH7AJe/4wnvRLzuSCOmocm
	tbOTtlnoWqCCkG9uBKHPlCL0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wA7iC-00000007WPi-0pkD;
	Tue, 07 Apr 2026 14:47:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 4/8] smb: smbdirect: let smbdirect_connection_deregister_mr_io unlock while waiting
Date: Tue,  7 Apr 2026 16:46:30 +0200
Message-ID: <e562d099bb486b293b4fe4cf9f61b2a5a058fbb7.1775571957.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775571957.git.metze@samba.org>
References: <cover.1775571957.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should not hold a mutex locked during wait_for_completion()
holding a reference is enough.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_mr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_mr.c b/fs/smb/common/smbdirect/smbdirect_mr.c
index 4873a2c1066f..fa9be8089925 100644
--- a/fs/smb/common/smbdirect/smbdirect_mr.c
+++ b/fs/smb/common/smbdirect/smbdirect_mr.c
@@ -410,6 +410,7 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 	struct smbdirect_socket *sc = mr->socket;
 	int ret = 0;
 
+lock_again:
 	mutex_lock(&mr->mutex);
 	if (mr->state == SMBDIRECT_MR_DISABLED)
 		goto put_kref;
@@ -440,8 +441,15 @@ void smbdirect_connection_deregister_mr_io(struct smbdirect_mr_io *mr)
 			smbdirect_socket_schedule_cleanup(sc, ret);
 			goto done;
 		}
+
+		/*
+		 * We still hold the reference to mr
+		 * so we can unlock while waiting.
+		 */
+		mutex_unlock(&mr->mutex);
 		wait_for_completion(&mr->invalidate_done);
 		mr->need_invalidate = false;
+		goto lock_again;
 	} else
 		/*
 		 * For remote invalidation, just set it to SMBDIRECT_MR_INVALIDATED
-- 
2.43.0

