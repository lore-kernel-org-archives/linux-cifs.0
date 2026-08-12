Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D01D2F7EFC
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539725; cv=none; b=qfoSbWuMYiDg2T9UeKxM/bENL1ltEDi+8QCsJa8BxDw1GnRL9JDElwzPxMFScOXX60sMizAXBNYv5+VecQmd0XJMvZrdKi1yYJfvk/SD1A9ad2pM9Qx7Ptik5eYuzzdD6QcgtWeS+7xmArHx69QVHBtiu6ZHELDEeqE7tE9iVZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539725; c=relaxed/simple;
	bh=1ruvPAnx5KbV/+wwJs2p/x34seHDJCzT3A5WoLh7T64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ir8CoDaaK9EBjSf640hjYsNVbsVMbSyCr5YZJBmkoMjvfbZj1j8c+7tvXNxiVCmUrWLr19qxslGDxho1WN9LAn1Kp+W31fEbvQeywlhoAbOES4tkcxPIhmhcobq/uYut0idwM6PSiiU857v+ZarjCIsLxLKSe8TfNMhZiEMfHf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iGYgt71x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGYgt71x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PPM37YnK3EKqivaHe73jCVmBaOR6lzLdZlVHqHSfQng=;
	b=iGYgt71xCnE2rzgfL0yZTwmHI12zMi/QVZCVy508jSe3dFEWiIbaFSfD5j0XbqGzTtDqnq
	h9QSZvSLnJSJDq/CmeRONAxug2NegQt4Bf/YvSYrRwpJYxVvjSFQXyKAjpzioxnOOGVw5U
	0RxQgv1OvpcZFncYN2+lqDg2WrX5IU0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-204-9-IZQTH9NdKE-_d2vGzxDg-1; Wed,
 12 Aug 2026 09:01:58 -0400
X-MC-Unique: 9-IZQTH9NdKE-_d2vGzxDg-1
X-Mimecast-MFC-AGG-ID: 9-IZQTH9NdKE-_d2vGzxDg_1786539717
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F3961956071;
	Wed, 12 Aug 2026 13:01:57 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A53E195DF91;
	Wed, 12 Aug 2026 13:01:53 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] smb: client: Avoid leaking of sensitive data to the stack or heap
Date: Wed, 12 Aug 2026 15:01:47 +0200
Message-ID: <20260812130152.2861834-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Similar to the patch series that I sent for the server code recently,
here's a clean-up series for the client part:

Sensitive data like keys that are stored in stack-local arrays could be
leaked via the stack to the calling functions, or via the heap when using
only normal kfree() functions.

It's good security practice to clear sensitive data on the stack first
with memzero_explicit() before leaving the context, and to use
kfree_sensitive() for data that is returned to the heap.

Thomas Huth (5):
  smb: client: Clear sensitive stack data in smb2transport.c
  smb: client: Clear sensitive stack and heap data in smb2ops.c
  smb: client: Clear sensitive stack data in cifsencrypt.c
  smb: client: Clear sensitive stack data in smb1encrypt.c
  smb: client: Avoid leaking sensitive data to the heap in connect.c

 fs/smb/client/cifsencrypt.c   | 12 +++++++++---
 fs/smb/client/connect.c       |  2 +-
 fs/smb/client/smb1encrypt.c   | 19 +++++++++----------
 fs/smb/client/smb2ops.c       |  4 ++--
 fs/smb/client/smb2transport.c |  4 ++++
 5 files changed, 25 insertions(+), 16 deletions(-)

-- 
2.55.0

