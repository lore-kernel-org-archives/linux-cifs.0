Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD49A3803DA
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695798; cv=none; b=qRKK8MC8OvDKXQ8wfA+17rzYtqzkakc5G7ZcoeDaLLXgla7YbohL+yCtigqWZDn6Qaj34ymk2dyGC6QmEtjyCPxzPzXeprBhb8CmTeSmncql6e6soLftJIRiRF4WIrZbye6mkagCNwXTc6+kW2p3UllPVD/7fm9hP8ROBRrR0wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695798; c=relaxed/simple;
	bh=I3+GSiRQDZNS5V4Qe/SMpNchOOdZq2lBidKaYtEdqJE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dF3jmTvpOS19XRHTxCXvc7FLA2gp3UvYOVNuRaUzkdv1pW1L84TapfuyfGi9sUlYFTeR3P4xFXfEMbzsBLfjmOGDL0DL6LT9N36vVC446bWqC661vSnss6ybeeR79zhArQ86dURxMzv6XsEO8wEnSuTXWnA+Q0f+6jM3dYLXkfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QjTf4BDu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QjTf4BDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769695795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26dYZKw2N4ptUIGx5YThN3ie6V9WTha31re7jO02qI0=;
	b=QjTf4BDuVmujQ3AQ7XUqsCuGMyP9u/6tVXFfZnzjQGEcLRF6kMHY0nkmWmRqHfanOhe3sd
	rFmBf2Px1yUFGzkxTIYQHaSeJF345WAtX/EJLxyvljsaKw5DYrD0wC6bdg9RRYQaAh5Tah
	5Om7fY0AaCYQThpdXY8ejUqLUhbnVrI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-C7ojKcu0M9OXdvJ_VPdC6A-1; Thu,
 29 Jan 2026 09:09:53 -0500
X-MC-Unique: C7ojKcu0M9OXdvJ_VPdC6A-1
X-Mimecast-MFC-AGG-ID: C7ojKcu0M9OXdvJ_VPdC6A_1769695792
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E101C19560AF
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:51 +0000 (UTC)
Received: from plambri-thinkpadp16vgen1.rmtgb.csb (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 092E51800870
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:50 +0000 (UTC)
From: Pierguido Lambri <plambri@redhat.com>
To: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Subject: [PATCH v2 2/3] docs: Enable debug logs
Date: Thu, 29 Jan 2026 14:08:47 +0000
Message-ID: <20260129140948.621754-2-plambri@redhat.com>
In-Reply-To: <20260129140948.621754-1-plambri@redhat.com>
References: <20260129140948.621754-1-plambri@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Document a new option '-d' to enable debug logs.
By default only error logs are enabled, with this new option
debug logs can be enabled when needed.

Signed-off-by: Pierguido Lambri <plambri@redhat.com>
---
 cifs.upcall.rst.in | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/cifs.upcall.rst.in b/cifs.upcall.rst.in
index 09d0503..73934ef 100644
--- a/cifs.upcall.rst.in
+++ b/cifs.upcall.rst.in
@@ -11,7 +11,7 @@ Userspace upcall helper for Common Internet File System (CIFS)
 SYNOPSIS
 ********
 
-  cifs.upcall [--trust-dns|-t] [--version|-v] [--legacy-uid|-l]
+  cifs.upcall [--trust-dns|-t] [--version|-v] [--legacy-uid|-l] [-d]
               [--krb5conf=/path/to/krb5.conf|-k /path/to/krb5.conf]
               [--keytab=/path/to/keytab|-K /path/to/keytab] [--expire|-e nsecs] {keyid}
 
@@ -38,6 +38,9 @@ OPTIONS
 -c
   This option is deprecated and is currently ignored.
 
+-d
+  Enable debug logs. By default no debug messages are logged, only errors.
+
 --no-env-probe|-E
   Normally, ``cifs.upcall`` will probe the environment variable space of
   the process that initiated the upcall in order to fetch the value of
-- 
2.52.0

