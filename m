Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D78349B07
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442678; cv=none; b=bME3L0MO/0UEiBc1jF2O2EFrESkAwt+L6Hiel902QInvGlFTQYHf8pj3djzBTpBDeZb2KMpwPENITEf8eGipUpbpjkEezjg0pB37MH4IsvGxN4NnZAJemiC2LFaGYr2NYR10mi/YgdBB0qACSv/Jpq55bsYEdvM7xrlIcDW7Fs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442678; c=relaxed/simple;
	bh=imb2YF+OUmVmE2KMegnh4Yvp1omQxmj6tAAzek2xzk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAQWWAqLoOqL/bj2CHpaxfVDxyUY/BVndUNZyFL0q4uUjvpV+a6gqnb39ulRcsD/b9A8r5yy7vrx+mZGYU4SuK0M7My1S053b/MxEz0r10S2KAGFizuv1fhAvqPH92lyoSSQybllac6vgmZSecPafTOHRa6MEsvEv9zAnIChba8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYcdRXV/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYcdRXV/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IJOPJnHZMSkotFj749V2K5gMSGhnu2n1N2tvafR4Ntc=;
	b=NYcdRXV/x6hu0J1c2j+B1Foc+wghgmd/2R6RGm0hn3O1+CpnkvJ/ozQIlmas6Am6J+GON+
	gP+20YWW1cviwFyA6cevC9UJN4mqIKOVe4y7Ziqhf828BNiZEUfCJUR9UZE4YdX3yFb5I7
	iqhfaq8DyeDfG51rxrn6IJeRKQa/OMQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-9_BPZSygOeaQqmBYx8bJ4A-1; Mon,
 22 Dec 2025 17:31:11 -0500
X-MC-Unique: 9_BPZSygOeaQqmBYx8bJ4A-1
X-Mimecast-MFC-AGG-ID: 9_BPZSygOeaQqmBYx8bJ4A_1766442670
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A16CF1956094;
	Mon, 22 Dec 2025 22:31:10 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E209B30001A2;
	Mon, 22 Dec 2025 22:31:08 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 19/37] cifs: SMB1 split: Rename cifstransport.c
Date: Mon, 22 Dec 2025 22:29:44 +0000
Message-ID: <20251222223006.1075635-20-dhowells@redhat.com>
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

Rename cifstransport.c to smb1transport.c in order to give consistent names
SMB1-specific files.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/Makefile                             | 5 ++++-
 fs/smb/client/{cifstransport.c => smb1transport.c} | 0
 2 files changed, 4 insertions(+), 1 deletion(-)
 rename fs/smb/client/{cifstransport.c => smb1transport.c} (100%)

diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 4c97b31a25c2..9754b4776df8 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -32,6 +32,9 @@ cifs-$(CONFIG_CIFS_SMB_DIRECT) += smbdirect.o
 
 cifs-$(CONFIG_CIFS_ROOT) += cifsroot.o
 
-cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += smb1ops.o cifssmb.o cifstransport.o
+cifs-$(CONFIG_CIFS_ALLOW_INSECURE_LEGACY) += \
+	cifssmb.o \
+	smb1ops.o \
+	smb1transport.o
 
 cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/smb1transport.c
similarity index 100%
rename from fs/smb/client/cifstransport.c
rename to fs/smb/client/smb1transport.c

