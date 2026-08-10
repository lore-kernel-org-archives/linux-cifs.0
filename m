Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5CB3DD52B
	for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2026 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366755; cv=none; b=iTNVDQPb3Mn5peF5roD5vplg+lKSW5rOusL9Gfj05DlWJf2wQ9tPNzgGY7vumDCv52L9Og4b7ISdpWT2MCoJKRH6UQFGRcT2q1oM1GCFpcD6PpMRq6C53owh4DEDYYcxA0pqeZjmDosTKDW5FQHlHyzr1Cfc1i7kxHAOcQLwewE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366755; c=relaxed/simple;
	bh=bqx3BjBbvTbeuGV0qkFsGaKkfysKhy/kb4On0buQoio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dh6I4xp1Fw7ZYO/QXd+kUcY7wXy62wwClw1lS5DXE2qlWcO1dAWzEeA/hXE0WrkgXDK5G95pIiEF9QjVKCUclnCaKiA8gXHH3QPeNDg883m291KRCncpyOxmeTAJ3bw0ibPF4eNFJXulcSVF0Zkx8xDBfDnwjjuawgPAUUv8b9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3jdO2Uh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3jdO2Uh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786366753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xk7zF9B337l+v+zmWz075wTvLr5aI1bS+oxgsAu+NpU=;
	b=D3jdO2UhUWNydHDzkdl/yC/eL4to3t/5rnxUj1bnkYWiJoo4tUtzvk1b655ZxT20elJl9H
	JCHjnYV77wx+TxSMd7QMNxIbl3v+RZOcqivQZQJ/ncfv1cA2kQs8gRHcOscl74oPG5WfNz
	0pxeWybCwTJQ6I+qAKJdjYG4dKOyGYY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-pwBw5zG-Po-qs9i7yQvDmA-1; Mon,
 10 Aug 2026 08:59:09 -0400
X-MC-Unique: pwBw5zG-Po-qs9i7yQvDmA-1
X-Mimecast-MFC-AGG-ID: pwBw5zG-Po-qs9i7yQvDmA_1786366748
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C1C11956053;
	Mon, 10 Aug 2026 12:59:08 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4094B426;
	Mon, 10 Aug 2026 12:59:05 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] smb: server: Free session data with kfree_sensitive() to avoid leaking of data
Date: Mon, 10 Aug 2026 14:58:56 +0200
Message-ID: <20260810125857.1009618-4-thuth@redhat.com>
In-Reply-To: <20260810125857.1009618-1-thuth@redhat.com>
References: <20260810125857.1009618-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

From: Thomas Huth <thuth@redhat.com>

struct ksmbd_session contains some arrays with sensitive information, like
sess_key, smb3encryptionkey, smb3decryptionkey and smb3signingkey. Thus
let's make sure that this information cannot leak via the heap and use
kfree_sensitive() to free it.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/server/mgmt/user_session.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index f99c86284ba3d..9cb990a22fd56 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -389,10 +389,10 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	ksmbd_launch_ksmbd_durable_scavenger();
 	ksmbd_session_rpc_clear_list(sess);
 	free_channel_list(sess);
-	kfree(sess->Preauth_HashValue);
+	kfree_sensitive(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
 	ida_destroy(&sess->tree_conn_ida);
-	kfree(sess);
+	kfree_sensitive(sess);
 }
 
 struct ksmbd_session *__session_lookup(unsigned long long id)
-- 
2.55.0

