Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6494337AA70
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695797; cv=none; b=K/8qQezxb/1QP1Dvxnci+eo1XKbxv2NNQ5Wfou6+xz7RP+slKZsz1pIt5OcXt52HyeLyAFhc9tkU7pXhpxXS1e/RZll4WsW8FQVXYuRl5yMXDIVTzrBWztJbDIhrEauawX5q1WpG1ZcatyAhc1oZ8v0wDBtsih4TQApQK00WIbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695797; c=relaxed/simple;
	bh=NCawKLWJELJzHx9az5904ouL4pnWr8NhPIMgIl6jkMY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp3aTC/0Dj5FZvsNPCNfy55GLiZ8UzOuacD12JhPhJEzuCQxputIic/EU04A6sn6JUfQSpjzAiMw9MWkU9NlWY+5hN3sQD47jn4e3eA1kg3zVJ/QvKCDzWBJcm6s8xcpVFCziX7YtmFvOnYQ7fsGIgCQs6FK6QeUIUvocmodaEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PsAVkFuQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PsAVkFuQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769695795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XkOwrv2MTXhfP9FPRpLporsQUSwXvKGEi4dTfeQNv24=;
	b=PsAVkFuQ4zZSKcWr1HsR3lJ7Qd+AFO2Iz5YHTOR2ZyA0sarz55jd5u55FEZm1PTP3MYAvM
	1u1I9DKPec1SEYNx3Ek753J5S0IiXbuZ+jv3ECoLxSzzXU+WgxUM6G/mJY0c1e8MCKV2KP
	R0L03G+Yzo6rJcRBC2U5tSwH1MG3Xio=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-r_EHlZ_rPySJxBfEWJP7qQ-1; Thu,
 29 Jan 2026 09:09:54 -0500
X-MC-Unique: r_EHlZ_rPySJxBfEWJP7qQ-1
X-Mimecast-MFC-AGG-ID: r_EHlZ_rPySJxBfEWJP7qQ_1769695793
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4108D195605B
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:53 +0000 (UTC)
Received: from plambri-thinkpadp16vgen1.rmtgb.csb (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 66164180086E
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:52 +0000 (UTC)
From: Pierguido Lambri <plambri@redhat.com>
To: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Subject: [PATCH v2 3/3] cifs.upcall: Adjust log level
Date: Thu, 29 Jan 2026 14:08:48 +0000
Message-ID: <20260129140948.621754-3-plambri@redhat.com>
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

Because now only error message are logged, let's switch some messages
from DEBUG to ERROR level.
This will help see when an error occurred with cifs.upcall and
eventually turn on the debug mode.

Signed-off-by: Pierguido Lambri <plambri@redhat.com>
---
 cifs.upcall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 9c2843d..9da5289 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1617,7 +1617,7 @@ int main(const int argc, char *const argv[])
 					 __func__);
 		} else {
 			 if (!get_tgt_time(ccache)) {
-				syslog(LOG_DEBUG, "%s: valid TGT is not present in credential cache",
+				syslog(LOG_ERR, "%s: valid TGT is not present in credential cache",
 						__func__);
 				krb5_cc_close(context, ccache);
 				ccache = NULL;
@@ -1720,7 +1720,7 @@ retry_new_hostname:
 	}
 
 	if (rc) {
-		syslog(LOG_DEBUG, "Unable to obtain service ticket");
+		syslog(LOG_ERR, "Unable to obtain service ticket");
 		goto out;
 	}
 
-- 
2.52.0

