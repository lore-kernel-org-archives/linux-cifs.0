Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7263A963C
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186170; cv=none; b=qE47Ni7n+yA0BfjHYIh/qhj/XLGQQzT7IVro/YrljOI7PlgPsse/i8Ah2uT35MVRZp83rg28L/n91MlIdg/VWzDmDX5HBTJVYFUcpxK7wbMh9q6SlXn4iJZb3dUecAXo10+ZvgrHB33KIZ7MVlcxN8kqljKYp3LfIFGQM3gho5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186170; c=relaxed/simple;
	bh=UhHkba6ecwxOKwjX0G3243fhk9qA4cbp+p5Gvm4VN4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/nIaN0MJIRVQ0oGNlFl3p1cmpsNCZREYofB+LCKDajRnLF1BALAO5ki7emN2+aqoj/xcfXRquRdz+3gJWL6iqWAlBQ0xqpba4uU4pdDa6MPQLfMwXeAto6uzJ5nvYLZhuAxgzoIgwrZAQxwDIJkwB3cg7Ns9v6O23yvyx8vnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5CoHkdh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5CoHkdh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlQl2PQTwkn/zTd/X22L2cgRiCIJcRnEi+XfHWK1JC8=;
	b=K5CoHkdhQzkSmwZMPy79VROfk/TjyZ5Dmu3TLW2JVnQXLWMYQ05/I3cOkkgLyYUACmrSoH
	rWmAmVZuDEb/BU/WD6l6xZH6NV+qXWyvGN5Iv8mdh82sd1+MuRjLuvK7AFo51gOy9fLItG
	vQTlZG33Frq7ZAAVpGO5qzh+54IKUHw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-iHxlfIn_MeeJGF2jiqmVmw-1; Tue,
 19 May 2026 06:22:46 -0400
X-MC-Unique: iHxlfIn_MeeJGF2jiqmVmw-1
X-Mimecast-MFC-AGG-ID: iHxlfIn_MeeJGF2jiqmVmw_1779186165
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 135AB195605C;
	Tue, 19 May 2026 10:22:45 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 55F7E19560A2;
	Tue, 19 May 2026 10:22:42 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/36] cifs: Add an enum to hold a trace value for the command/subcommand
Date: Tue, 19 May 2026 11:21:26 +0100
Message-ID: <20260519102158.592165-9-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

---
 fs/smb/client/trace.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index b99ec5a417fa..ede61d8a192c 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -20,6 +20,9 @@
 /*
  * Specify enums for tracing information.
  */
+#define smb_command_traces \
+	E_(smb_unknown_command,				"unknown-command")
+
 #define smb_eio_traces \
 	EM(smb_eio_trace_compress_copy,			"compress_copy") \
 	EM(smb_eio_trace_copychunk_inv_rsp,		"copychunk_inv_rsp") \
@@ -211,6 +214,7 @@
 #define EM(a, b) a,
 #define E_(a, b) a
 
+enum smb_command_trace		{ smb_command_traces } __mode(byte);
 enum smb_eio_trace		{ smb_eio_traces } __mode(byte);
 enum smb3_rw_credits_trace	{ smb3_rw_credits_traces } __mode(byte);
 enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
@@ -225,6 +229,7 @@ enum smb3_tcon_ref_trace	{ smb3_tcon_ref_traces } __mode(byte);
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
+smb_command_traces;
 smb_eio_traces;
 smb3_rw_credits_traces;
 smb3_tcon_ref_traces;

