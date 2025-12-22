Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBA179A3
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442643; cv=none; b=CX8Lbo3quJLNke1GNayfO5A8zFszt/ljQ8z4F0+aZsnW9/G4sgO+/zr043TtXlwYFHBP7Vj2M9zvUp58EmB+dsTyQPQ3MVhzfx7yW4ac4KQPO1V1m9MMqpXdqUFbT5REK5SG5udDBA4wxfP6AV7Oo4VJKXKbXBiFKWIvCl4ICRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442643; c=relaxed/simple;
	bh=o0MayiftDnLIdmHvfSlZ8/ZHloBTKIoCsuSPWWVhOlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2FpYd7mv0cM7YmfBAbkh2Fvzr9YYuRtgPzPigw0AeX17WEsAo5KQP8Dm3LlOkxtdH8k5khZvcK5nof+c+g2Sx1H8gQxeRjRYBKTt5urD/eJLiRuYbGUv02K6IGqorxRDoNrvs2T2ezUrVMWp4c3CNsJVbmHT1y3SrdgILSURCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aiCD+cIo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aiCD+cIo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eFJzJ1e1EZECnAmehQNetdpj4AilrLDU4YxRrL1opts=;
	b=aiCD+cIoFavnXKrQbRQp+TPdbvm7jKj65hMuYGZoET/lLOpKV2zncQO89dXbsJrnCDQISF
	mCXq2bGtbqkVxXe4kP6Tm8giijb4eYExQ3WtjktuevVLyPUKVOZem3PR0FmxV/MNPjuaii
	tbCe70siDq82TnOFSjA28cdXJXLKFoA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-ZKyaZ1XEMxShZ0qWyVjfGA-1; Mon,
 22 Dec 2025 17:30:38 -0500
X-MC-Unique: ZKyaZ1XEMxShZ0qWyVjfGA-1
X-Mimecast-MFC-AGG-ID: ZKyaZ1XEMxShZ0qWyVjfGA_1766442637
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DB4518001D7;
	Mon, 22 Dec 2025 22:30:37 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 88BA21800664;
	Mon, 22 Dec 2025 22:30:35 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/37] cifs: Scripted clean up fs/smb/client/dns_resolve.h
Date: Mon, 22 Dec 2025 22:29:33 +0000
Message-ID: <20251222223006.1075635-9-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/dns_resolve.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dns_resolve.h b/fs/smb/client/dns_resolve.h
index 36bc4a6a55bf..951fbab5e61d 100644
--- a/fs/smb/client/dns_resolve.h
+++ b/fs/smb/client/dns_resolve.h
@@ -15,8 +15,8 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 
-int dns_resolve_name(const char *dom, const char *name,
-		     size_t namelen, struct sockaddr *ip_addr);
+int dns_resolve_name(const char *dom, const char *name, size_t namelen,
+		     struct sockaddr *ip_addr);
 
 static inline int dns_resolve_unc(const char *dom, const char *unc,
 				  struct sockaddr *ip_addr)

