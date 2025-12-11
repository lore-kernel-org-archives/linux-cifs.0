Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB94E30F55F
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 12:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765455531; cv=none; b=G0ZwCyRNDSVXubbI709kQYd8zqHh7hcVdkwVt455bV2vjz+xPItUTkqNwEln17oN4xXDCdeNpgKsMq284BRD3O+MgPR2tmLN8r7Yhlw+NNfArc0T+SG446EoqT/6LQaqtg10P1n7EX3ppS81mnYEP1J8K/X5/9zzNanFRWep4tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765455531; c=relaxed/simple;
	bh=RwYUerJ4hJmzwuH1LlZyqEcdJj9Pt2Fovq5QE2M9JM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuIHJnWrlHuqH2sFKXoYcN62eEL55yUXyhY30nEDE44TCT3yKeTNgYfAXUP4g1Lgvs9wz1Runvedq1aKn1kplseZrqD9WXFku9vCPeAGO+oZbvSxvCJI/TM5JnUA3DCo0DBrDi2uOGAnDmm1Qnn602aeuf2hYi4T/Eu2HEAJkrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRGnrzW9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRGnrzW9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765455520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vfVyyD1PexB1d/N6d8HS6nBZO+yvtrhFLe6ajtg+Ako=;
	b=IRGnrzW9nWkLroeR7WAK35oCH6pTAvZhBrWrbusOJuKc0RBwLkCNs4/1SHq25sZ/c5eXL5
	g7rHROW9WU4myJwJ9+gd4T+X4AONwThg26tdbq5f+O3VTYcebMSvDaUAU+syCpqS43Mmk6
	b+AB2rDLinaXIMHlEvmJZlyFr/r7y3E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-qWgjAMYnNKi2LJjyakcflg-1; Thu,
 11 Dec 2025 07:18:36 -0500
X-MC-Unique: qWgjAMYnNKi2LJjyakcflg-1
X-Mimecast-MFC-AGG-ID: qWgjAMYnNKi2LJjyakcflg_1765455515
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8B57195FCDC;
	Thu, 11 Dec 2025 12:18:35 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0E24180035F;
	Thu, 11 Dec 2025 12:18:33 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] cifs: Scripted clean up fs/smb/client/compress.h
Date: Thu, 11 Dec 2025 12:17:07 +0000
Message-ID: <20251211121715.759074-15-dhowells@redhat.com>
In-Reply-To: <20251211121715.759074-2-dhowells@redhat.com>
References: <20251211121715.759074-2-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/compress.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
index 63aea32fbe92..2679baca129b 100644
--- a/fs/smb/client/compress.h
+++ b/fs/smb/client/compress.h
@@ -30,7 +30,8 @@
 typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *);
 
 
-int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn);
+int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq,
+		 compress_send_fn send_fn);
 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq);
 
 /*

