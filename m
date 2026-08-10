Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8161A3DB62A
	for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2026 12:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366757; cv=none; b=n2jrhjvklKQIAZnQIdVxbvfk77E6JaRayJ+jWZP0yTqcljkvjxxnDpcOUoHH5nNdG7Aa438P9IU/B79xrXMYu0RTO3XW/XKWJ7F6fO9uRSSpNtKwWLPvMOMkIYgx/amKH2OyntVfm3jqn7bH249xrau3gqyBlj2iuXzm/99MRfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366757; c=relaxed/simple;
	bh=alkQrT/mp6qBDWwuI/IMtkXcvcIMzyUeSo16FQJCm5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlt1qD2ez8LoHFlsv2afkYRnQaT7MULJQiL6aJdL7+RIQVzlretuy/EnOnS4EwknZiFITNG1Ve9Elp7yfxh3dCof6Qtu4L1fi1mIJJ2lbIllqPQpTkHHKxmNnUCDXDZhhSgwbXwOT//+Y937+2IYJ2Sg058kEJh2IK4wHOr/0+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iKit2WWR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iKit2WWR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786366755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gh+3eC2KDdxNiPOue5nNMywvzbbZjC53wM5BXCY+I2U=;
	b=iKit2WWR4D7lcRKZd2ABzVf0OX+lyW9ATTTjvl89Wd3gSc5Rzz16QPv9wnHDUHTc02pzTb
	yVCm6JCKrebwSvO8zwsFplaDE2BVOXaqQNmLBipVfFFK7YmciJqJwF5KJk4VmRPDyL8Q1n
	s13IRwl6Q0xgknvqtpkgECdUVYMHOAk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-wrMV2EZaNEmurQace6bTnQ-1; Mon,
 10 Aug 2026 08:59:07 -0400
X-MC-Unique: wrMV2EZaNEmurQace6bTnQ-1
X-Mimecast-MFC-AGG-ID: wrMV2EZaNEmurQace6bTnQ_1786366745
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B506418001E6;
	Mon, 10 Aug 2026 12:59:05 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A09DD422;
	Mon, 10 Aug 2026 12:59:03 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] smb: server: Make sure that passkey is not leaked on the heap in user_config.c
Date: Mon, 10 Aug 2026 14:58:55 +0200
Message-ID: <20260810125857.1009618-3-thuth@redhat.com>
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

Use kfree_sensitive() to free the user->passkey (and the struct
ksmbd_login_response in ksmbd_login_user() that contains the same
information) to avoid that this information could leak somewhere
else via the heap.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/server/mgmt/user_config.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index cf45841d9d1b9..76b74d68369d8 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -27,7 +27,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 
 	user = ksmbd_alloc_user(resp, resp_ext);
 out:
-	kvfree(resp);
+	kvfree_sensitive(resp, sizeof(*resp));
 	return user;
 }
 
@@ -70,7 +70,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 
 err_free:
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 	return NULL;
 }
@@ -80,7 +80,7 @@ void ksmbd_free_user(struct ksmbd_user *user)
 	ksmbd_ipc_logout_request(user->name, user->flags);
 	kfree(user->sgid);
 	kfree(user->name);
-	kfree(user->passkey);
+	kfree_sensitive(user->passkey);
 	kfree(user);
 }
 
-- 
2.55.0

