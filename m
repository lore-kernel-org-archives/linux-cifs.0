Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616E9314A6E
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769782336; cv=none; b=J5r5Lgl6LaSR7Idzfi6MrySfiqUpBGERqV7TIHEJixWs8k00bA8rc07WVSVmo7yVzyhV+W0AsvZDrN+biBJFyE1LSMg0yLHRpHdxYNh8a5hFpQi09db8KC+AQK6CmsaN9dc75W0R+aWGsWsWSyb+wo6jynHda0Qe+9gDShuQJoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769782336; c=relaxed/simple;
	bh=HqYjLwaAI/iGBseTYEXrp6jexytS20THKAL8cejau1Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snWu+fcaltLaH1A+BW+TGbCkWxHkljhbUvgphfqaQPVEiWy478uLEQHEJrU5yLBpTUg+zCBpBKee6FF6MeQfYq8gm00gznKZJcWWaeIzGHqWQ4SY66fLmxXnXYCs6eTuuu4bZqFeA/5CN4Dj4NGrUb+/5ChjqFMqa/kl3AAju4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0NYpM64; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0NYpM64"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769782334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eiuYWfM2zNECHWLTRNkYYPDmOwyx/2dTtMdbQDibjaQ=;
	b=i0NYpM64NyLDGVvwhbiyiKZFyq53M8jEtPloVb5dF/banzNekR0MO3p5TEDS/zcOaH3Cpi
	aB2+SYwvXyUNvG8kQe+f3h/r1m7EFrnK9LFe8hKE0iHWuigjq3Hc1NMTCWpoprxWXSS82E
	HudqcFCo/CMhlzUF+6C3Aoid5hDd7fY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-N48T1V3oPoqDGx3lrVlbHQ-1; Fri,
 30 Jan 2026 09:12:13 -0500
X-MC-Unique: N48T1V3oPoqDGx3lrVlbHQ-1
X-Mimecast-MFC-AGG-ID: N48T1V3oPoqDGx3lrVlbHQ_1769782332
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55E38180057E
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 14:12:12 +0000 (UTC)
Received: from plambri-thinkpadp16vgen1.rmtgb.csb (unknown [10.44.32.231])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C33118004D8
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 14:12:11 +0000 (UTC)
From: Pierguido Lambri <plambri@redhat.com>
To: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Subject: [PATCH v3 3/3] cifs.upcall: Adjust log level
Date: Fri, 30 Jan 2026 14:11:28 +0000
Message-ID: <20260130141207.831439-3-plambri@redhat.com>
In-Reply-To: <20260130141207.831439-1-plambri@redhat.com>
References: <20260130141207.831439-1-plambri@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Because now only error message are logged, let's switch some messages
from DEBUG to ERROR level.
This will help see when an error occurred with cifs.upcall and
eventually turn on the debug mode.

Signed-off-by: Pierguido Lambri <plambri@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 cifs.upcall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index b57a48c..9d0eecf 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1618,7 +1618,7 @@ int main(const int argc, char *const argv[])
 					 __func__);
 		} else {
 			 if (!get_tgt_time(ccache)) {
-				syslog(LOG_DEBUG, "%s: valid TGT is not present in credential cache",
+				syslog(LOG_ERR, "%s: valid TGT is not present in credential cache",
 						__func__);
 				krb5_cc_close(context, ccache);
 				ccache = NULL;
@@ -1721,7 +1721,7 @@ retry_new_hostname:
 	}
 
 	if (rc) {
-		syslog(LOG_DEBUG, "Unable to obtain service ticket");
+		syslog(LOG_ERR, "Unable to obtain service ticket");
 		goto out;
 	}
 
-- 
2.52.0

