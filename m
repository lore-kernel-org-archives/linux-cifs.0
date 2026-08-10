Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDFE3DAABF
	for <linux-cifs@vger.kernel.org>; Mon, 10 Aug 2026 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366750; cv=none; b=DOr0wECCgAJO9AdZNxgrjYhYfJlM2TfLQ/M+KFglNDHHPrALu1q2k82xmw/azwwnP+34jnM6b8kvW/rGaGoW8daCNN//leIhM6/2PvjIVFMTTDRX1yJgpKCnNeEDShMJwhUmYAY3ztpxLCbpYIZddVFA3IAGUF98+l0go0Y2LwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366750; c=relaxed/simple;
	bh=fC6xi7pT+XX84ylez4IUuK7Afh66dFH7UHeTjpQqJLg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rcbuCXzG3tYPzf6YhH5TLbiedlN8P/9uqK7lYHn0TVDeMliYH8Ggcaj6Fyz05+nkB96Q+28sluUcevi2WXwUZJ0BlcjmOYyVlES3XZi8kkBW26tNzGU7q8P/rEFwpj8PkpRCCuJrEMwnsNn+m3KpZfNuxSw3SWMDuLUWYfY9WRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxGCX5md; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxGCX5md"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786366747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3KeQ7uXuHCzbb7jfLPMirKtX2jtC15Pt2Lm9RF2Ua1A=;
	b=dxGCX5md7y1wfHt0GbeNfchG7gg18TQL53jIbUOXr2nrbcFhBDTYBKjukUq/4qHjqSE9E8
	DVlh+vduNfJCXktKvWL+77Dee7xzNNdfqedDtyxOlkc8JPKPrOmSaxYpRRRjsWbWw6LUun
	8jtf8IYnnzU1gPMljHCHonIRtQUaFDw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-K-llO1tUNBS3-ARtmqHhHw-1; Mon,
 10 Aug 2026 08:59:02 -0400
X-MC-Unique: K-llO1tUNBS3-ARtmqHhHw-1
X-Mimecast-MFC-AGG-ID: K-llO1tUNBS3-ARtmqHhHw_1786366741
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3707180034F;
	Mon, 10 Aug 2026 12:59:00 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B39B4279;
	Mon, 10 Aug 2026 12:58:58 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] smb: server: Clear sensitive data before freeing it
Date: Mon, 10 Aug 2026 14:58:53 +0200
Message-ID: <20260810125857.1009618-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Sensitive data like keys that are stored in stack-local arrays could be
leaked via the stack to the calling functions, or via the heap when using
only normal kfree() functions.

It's good security practice to clear sensitive data on the stack first
with memzero_explicit() before leaving the context, and to use
kfree_sensitive() for data that is returned to the heap.

Disclaimer: The spots that need clearing have been identified with AI,
but the patches have been created manually (for double-checking whether
the findings really make sense). Anyway, I'm not very familiar with the
smb code, so please review carefully. Thanks!

Thomas Huth (4):
  smb: server: Clear sensitive stack and heap data in auth.c
  smb: server: Make sure that passkey is not leaked on the heap in
    user_config.c
  smb: server: Free session data with kfree_sensitive() to avoid leaking
    of data
  smb: server: Free sensitive connection data with kfree_sensitive()

 fs/smb/server/auth.c              | 11 +++++++++--
 fs/smb/server/connection.c        |  4 ++--
 fs/smb/server/mgmt/user_config.c  |  6 +++---
 fs/smb/server/mgmt/user_session.c |  4 ++--
 4 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.55.0

