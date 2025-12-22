Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DE2338595
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442663; cv=none; b=pUhBatji4idEpwND+VTfs/tkd6KuFJ7tMtCRldNpwHOCMiNpiUodjFIOVytWN8HXDcruEvMWoSamtL3qBN3kB5l+ei5/2fkWeWx+y7MTduk1fEkqnhhSh3Lenqv+dByPvcvtmK+kE1TsEEiAFPNNLAXTt4tBIbMOFhpJWeuyD1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442663; c=relaxed/simple;
	bh=+Wo+l71IAU0AqaO6ZoV2OG/pvIDGGYqR2GhGhU27Y68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6cLF6CE9ca3XN2MvPrjQEZzHXhwKQZaki5lMXbN5TUwErE4/AjKNL2eYIVK3iQGycS8GLDHzzmI5EzPbtGmGY00dUkEhMfw2Cw04+ka/4QusGb6v59jMOJwSXfivm/OXaCT4UiW8Qh+BpWdx8JSi/qzHukcfgKVy4UKi5uJFC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JAJWI68v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JAJWI68v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+sZRfUhZLYVTFCknqCPjwaISkbiMEC9lHaFs7CeHiY=;
	b=JAJWI68vwJxpfqRCexst5Z99HV5dcfgDprSNyC+2SuSzpTpGzbCuOo9eIfBds34lYEF1vZ
	EG2YQiZrIGbwPQWhXZdRKMsWLq+vGoQz8JwIkyBvqjmRHCktvgADnZFpXwZaPqF5OzE5UR
	jYD3GImGkyS80eVqbFQKRQza1N/OJ0Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-8l_MDOCeP1uPcFSvSd8H2g-1; Mon,
 22 Dec 2025 17:30:56 -0500
X-MC-Unique: 8l_MDOCeP1uPcFSvSd8H2g-1
X-Mimecast-MFC-AGG-ID: 8l_MDOCeP1uPcFSvSd8H2g_1766442655
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 664BA19560B2;
	Mon, 22 Dec 2025 22:30:55 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8F6DC30001A2;
	Mon, 22 Dec 2025 22:30:53 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/37] cifs: Scripted clean up fs/smb/client/cifs_swn.h
Date: Mon, 22 Dec 2025 22:29:39 +0000
Message-ID: <20251222223006.1075635-15-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifs_swn.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_swn.h b/fs/smb/client/cifs_swn.h
index 8a9d2a5c9077..955d07b69450 100644
--- a/fs/smb/client/cifs_swn.h
+++ b/fs/smb/client/cifs_swn.h
@@ -14,15 +14,15 @@ struct sk_buff;
 struct genl_info;
 
 #ifdef CONFIG_CIFS_SWN_UPCALL
-extern int cifs_swn_register(struct cifs_tcon *tcon);
+int cifs_swn_register(struct cifs_tcon *tcon);
 
-extern int cifs_swn_unregister(struct cifs_tcon *tcon);
+int cifs_swn_unregister(struct cifs_tcon *tcon);
 
-extern int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
+int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
 
-extern void cifs_swn_dump(struct seq_file *m);
+void cifs_swn_dump(struct seq_file *m);
 
-extern void cifs_swn_check(void);
+void cifs_swn_check(void);
 
 static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *server)
 {

