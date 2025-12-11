Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C230F807
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 12:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765455533; cv=none; b=PuseNS5GdOM+AP13DCG1efR2n9t+6EWXhiWWUvfnq/ULMVS9Dx9shsNkAo8+5zkhnxGHvdhdAmUmYymOgxkVnjkHwb37Cj2y8UCTMZBOIWeZXCnjxD9agF2ipO7e4iOxsOghiNdo0qF4WvxSCs7WMDnuuCYv7rycKiUtCmgknC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765455533; c=relaxed/simple;
	bh=kHsDSsBbEJjgzmCquEl2lb6YJgpKoKwc0ROqUXOGtwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPNlfqK7Cu4e6MSGaxsQaGdSSaBMXBuU2TvpdcSbMiSYn6Yc9OGxn+WN3rnwMPHZT4DTsTnBMH7UfJBVuX5fvrf+6mwc2wwKLCFvUs6fwR60bqL+HhbOSAVztbZxE9STaAzRGNi8j0/6uuyrkmoV+zUpeFTVids1vml2jokZJrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OaHaHRLF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OaHaHRLF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765455526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uzr6N7b5JybtHCAVwGJNHrVs+Vz79HR5PooQE+V9Huo=;
	b=OaHaHRLFJp2O6c3nY1Sbrz+9gPIB7620aHtlw+IAEoi2TG5W8oeIQsihnkGEVa0sLlA58z
	LAJCIeEGOp81m9QqpPl8mEPWw6/oiDMKTzqfTI1YREoE/KBpkn1DJSDo8m7t4rq/uvn9rg
	4kRoTtpM1E0R9JNfcxwtU55L3amV8d8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-256-V4OYB4LeOZyTvdbitEz3wQ-1; Thu,
 11 Dec 2025 07:18:42 -0500
X-MC-Unique: V4OYB4LeOZyTvdbitEz3wQ-1
X-Mimecast-MFC-AGG-ID: V4OYB4LeOZyTvdbitEz3wQ_1765455521
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F6511800592;
	Thu, 11 Dec 2025 12:18:41 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9F861956056;
	Thu, 11 Dec 2025 12:18:39 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] cifs: Scripted clean up fs/smb/client/cifs_debug.h
Date: Thu, 11 Dec 2025 12:17:09 +0000
Message-ID: <20251211121715.759074-17-dhowells@redhat.com>
In-Reply-To: <20251211121715.759074-2-dhowells@redhat.com>
References: <20251211121715.759074-2-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/cifs_debug.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_debug.h b/fs/smb/client/cifs_debug.h
index e0035ff42dba..35bd5c8e1d71 100644
--- a/fs/smb/client/cifs_debug.h
+++ b/fs/smb/client/cifs_debug.h
@@ -15,7 +15,8 @@
 #define pr_fmt(fmt) "CIFS: " fmt
 
 void cifs_dump_mem(char *label, void *data, int length);
-void cifs_dump_detail(void *buf, size_t buf_len, struct TCP_Server_Info *server);
+void cifs_dump_detail(void *buf, size_t buf_len,
+		      struct TCP_Server_Info *server);
 void cifs_dump_mids(struct TCP_Server_Info *server);
 extern bool traceSMB;		/* flag which enables the function below */
 void dump_smb(void *buf, int smb_buf_length);

