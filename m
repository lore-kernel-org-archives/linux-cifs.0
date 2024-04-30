Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D478199E8A
	for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2024 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714486209; cv=none; b=H31cH82fKh5v6vOy54VKdc2JACbkvtDfcn0jl1Ug5DtsOzEeVPFb7iAOB2TlLKgVQaBbnGvizRSiTL1MO5U4HkFuZUboRACG7z8uy73ZdQm+4YutCPKg/vchDCFRSWn9si/OzL244v0dEFsLm2nzbcG8X23eLqLLiPhoxbEDiQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714486209; c=relaxed/simple;
	bh=wK/mkDwnXcFoN6Kk8jF+KKpRm6Qw7OPNAXKO72bPoec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm35AowZwr6KKYD700K2mWm4bA3+CyVsgo95Ehg07/WkzjuPHLU4DdjtrBCcpsf0LsE9NZYd4PfyCgoUDcMIFRrvmdqXfqjoTzVpzrOciCI1qpSQNOmONoWdiuTn86JyhATl0Bxiq4xtbHRHJ1ZGnwkj6CjuUW36MsFX7oIQLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BjxEfp2X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BjxEfp2X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714486207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rx29y3wht5apPqGuZYnZRRxzhBh5LDn/UDQzoEUVDzQ=;
	b=BjxEfp2XavbmOmEx4NoUhJCwy1tEKyN5pvvSiA8QEE9HowAmtdC+zCClEgIsdBXd0Sm9a2
	7zsv09momukty7NNRPjLe6MrlTMPu/0bCsA5TQ54/TvJsbogs+bwDho8QhHLnroGmPjo97
	qa72wS5x3VANGcFiz38B2sS+nVJxY+w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-0ZBkhGgIPE2HLkFmUPugHQ-1; Tue,
 30 Apr 2024 10:10:01 -0400
X-MC-Unique: 0ZBkhGgIPE2HLkFmUPugHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D3851C03152;
	Tue, 30 Apr 2024 14:10:00 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.22])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C7831C0666B;
	Tue, 30 Apr 2024 14:09:58 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Christian Brauner <christian@brauner.io>,
	netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>
Subject: [PATCH v7 10/16] cifs: Make add_credits_and_wake_if() clear deducted credits
Date: Tue, 30 Apr 2024 15:09:22 +0100
Message-ID: <20240430140930.262762-11-dhowells@redhat.com>
In-Reply-To: <20240430140930.262762-1-dhowells@redhat.com>
References: <20240430140930.262762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Make add_credits_and_wake_if() clear the amount of credits in the
cifs_credits struct after it has returned them to the overall counter.
This allows add_credits_and_wake_if() to be called multiple times during
the error handling and cleanup without accidentally returning the credits
again and again.

Note that the wake_up() in add_credits_and_wake_if() may also be
superfluous as ->add_credits() also does a wake on the request_q.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsglob.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 29c9ee2dd304..611f59c6d2c0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -881,11 +881,12 @@ add_credits(struct TCP_Server_Info *server, const struct cifs_credits *credits,
 
 static inline void
 add_credits_and_wake_if(struct TCP_Server_Info *server,
-			const struct cifs_credits *credits, const int optype)
+			struct cifs_credits *credits, const int optype)
 {
 	if (credits->value) {
 		server->ops->add_credits(server, credits, optype);
 		wake_up(&server->request_q);
+		credits->value = 0;
 	}
 }
 

