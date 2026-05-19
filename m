Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E244CA260
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186244; cv=none; b=ClWTQ7IIKtpgst37W4Jbb40YDsDRuLlkwjmqk7/oBrHxHMmUj6A/SulHCXxG0938lOcA8Jo8++pq2Ttkt3lXWy5d3IPiLZq8eAtrYZes40ATSWMhqRpJ3QTV9ebSkEvDHTFn1DfOr/tNVJpATRlAhoCY0ctJUuZv4n3FiicXoew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186244; c=relaxed/simple;
	bh=/kKkibd7I4UJ09vAtMQS+No+nXWxHYtsFqDZ55RCPY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTYlp22EddbdkRVeyyZR2h89Q8Vmc8maROgVE/yv4djjSZ90TBLTREjslENFuFW95gxnYN0sGfbj/3IetEoMhMZpXorSG9L3c8Y9eewDGoPJ//NgvDfcPYZzvmJR/lHgLAipEamioWo/6bNQRCbg/ghuZE6YUre7ZhVUIAggWvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A5ZTqLxK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5ZTqLxK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rsISW/5Ynsi9gefanojoMknHhkwuwBucOgMcvE2JXxc=;
	b=A5ZTqLxKAprL5CKaWni3PfWin8kg5LGblC9+eOAF8+e/MuSB1IfroDeLW6t0wmtZsVEaQZ
	z2pORRv8TWFkLRdM0XIA969izE4lsamZHbvbLD+eTBhNvSfrvUazIf3cIzDa3y+aCNHfvX
	yC7ld9YWYgrWJH9vTb+EtZZh8xZ4zvU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-I8skbF-WM5mTJBuWOjOFaA-1; Tue,
 19 May 2026 06:23:56 -0400
X-MC-Unique: I8skbF-WM5mTJBuWOjOFaA-1
X-Mimecast-MFC-AGG-ID: I8skbF-WM5mTJBuWOjOFaA_1779186234
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E4C519560A7;
	Tue, 19 May 2026 10:23:54 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 55FAB1956053;
	Tue, 19 May 2026 10:23:51 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 22/36] cifs: Trace smb1/2_copy_to_prepped_buffers()
Date: Tue, 19 May 2026 11:21:40 +0100
Message-ID: <20260519102158.592165-23-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add a tracepoint to smb1/2_copy_to_prepped_buffers() so that bulk data
read (such as a Read op) can be checked.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb1transport.c |  1 +
 fs/smb/client/smb2transport.c |  1 +
 fs/smb/client/trace.h         | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index ba887284fadd..598579b564ae 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -829,6 +829,7 @@ static void smb1_copy_to_prepped_buffers(struct TCP_Server_Info *server,
 		return;
 	}
 
+	trace_smb3_copy_to_buf(smb, &dest, skip, to_copy);
 	if (!rxq->refillable) {
 		size_t got;
 
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 404bb8b1b3c3..73db90ab8a52 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -1236,6 +1236,7 @@ static void smb2_copy_to_prepped_buffers(struct TCP_Server_Info *server,
 		return;
 	}
 
+	trace_smb3_copy_to_buf(smb, &dest, skip, to_copy);
 	if (!rxq->refillable) {
 		size_t got;
 
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 2cdbd8249af0..e9abcc5cf83a 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -2117,6 +2117,27 @@ TRACE_EVENT(smb3_message,
 		      __entry->ref)
 	    );
 
+TRACE_EVENT(smb3_copy_to_buf,
+	    TP_PROTO(const struct smb_message *smb, const struct iov_iter *dest,
+		     unsigned int msg_offset, unsigned int len),
+	    TP_ARGS(smb, dest, msg_offset, len),
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	smb_message)
+		    __field(unsigned int,	dest_len)
+		    __field(unsigned int,	msg_offset)
+		    __field(unsigned int,	len)
+			     ),
+	    TP_fast_assign(
+		    __entry->smb_message = smb->debug_id;
+		    __entry->dest_len	= iov_iter_count(dest);
+		    __entry->msg_offset	= msg_offset;
+		    __entry->len	= len;
+			   ),
+	    TP_printk("MSG=%08x m=%x sl=%x dl=%x",
+		      __entry->smb_message,
+		      __entry->msg_offset, __entry->len, __entry->dest_len)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _CIFS_TRACE_H */

