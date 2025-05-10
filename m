Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC70A78C91
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893778; cv=none; b=T+HTfyVlIXH1ROzK9V0D4La9zZrYcibekonHyAwCpFefREpYhr+dqQS6uUiivnsTbIoO2pUgM5odF+YYVHw3v+lx9RZY/6dUDzvbkhKxymuQfoB2hBT5ItKtTpHynvvCXOyHbPCypu6hEPuS0iURsMdHNIJfbsM89D9WEDJCFCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893778; c=relaxed/simple;
	bh=io77X5Q6toU3NJLkBDE8Gmgtk19/7ZjkDXFUeIYbfU8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+jelIIUb90EP8wYmcGD94i2ED2HvXE7z2T+gZsgH+IIs7ZQXR+sfAk2sTs5AdORHDhTA26mLM/IxD/YekrrG0Cpjto7xcCFX0UiCLhd9vFUltxJn8qH75GM0TNIfd2Ux2Fl7t6f+EcXY7+4nHkO7DViNKa0M6rDdZi7vOteKAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BcMpjDsl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcMpjDsl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ICKI7YygzctP0Pm/eYAckxEun5kfOpmj6l7npsc89Eg=;
	b=BcMpjDslKG4RqxdTE1l2gCULX9o/+I/w497OP6YdlHStT1LHl6qK7GSyWlDCqM7hNlBDk0
	vgH7W5y2UTBbaqRqpL+ZK4PTIgovBIEzYcilfE2rDfiVIzkzhXlgRaSVoGvGSmOd+zZQqB
	u1kzhaA7ZGyf3Sx9MAS4GYVegDYDTJ8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684--_quoaDIN_WGvR8UwarSjg-1; Sat, 10 May 2025 12:16:14 -0400
X-MC-Unique: -_quoaDIN_WGvR8UwarSjg-1
X-Mimecast-MFC-AGG-ID: -_quoaDIN_WGvR8UwarSjg_1746893774
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4767bab171dso34916441cf.1
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893773; x=1747498573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICKI7YygzctP0Pm/eYAckxEun5kfOpmj6l7npsc89Eg=;
        b=nab9jzssVlJXmq4pxZa1hxjKyCYZDF8yufUyKo9+wM+ZPyBpum9OmpdWNTrZRSDbRx
         GCEI7iDdv+4HwZ1vH3tHaBgVJDNeYBZhJe4jE3NC5ekMDcapfXS7g8q1u+ariFZQuNvw
         QPjlfJ6tVFQ3WFZjrO6qdHAeYZds2ukCAt8Av7MmzuTdQRSxfI597Vj007zJeK18NzeJ
         KBqq0VY95O2gMGP+8X5MKkVNRtUruc4trXuWtmnV20IogZ2BKHpm1YX0HsBAuz49vsVB
         MWO/h0xoEeFmtRfUzGm+B4rc0PJqRCsRwt4e3o0OxjU/Kga3k1fk9W68ct0BaZGRIZaQ
         zk3A==
X-Gm-Message-State: AOJu0YzPmT6zgWpCFb2ihbiDUmvoxjyFjPy0MuMFw5UD2n8tBtvNiEdV
	v0crVUfjvtmbHUjyyJJ8Z1gVNBfPIfXUo41IBZavTuakLZ3W0AHi8ZwEC834a22Ez5Aa+skTRnR
	xRZp1/Vh8o/V6viEKSEZXDd07gr/t74tLiuoIBqB5YieWQfBnU+sUtXI9abwsfrqNMC6Rm+nqGD
	0YMwsvEouv3EJ8SidDN/q+clStgLSM81qdROlgeF9aN5U=
X-Gm-Gg: ASbGncsw1YLQmkDIb9cANPPUJZnTuNZohOwNK/Xqy3QBcne40t52K/7pNdoQkgp1/VA
	jsrnoLZsyodSqp6TP/WVkfy6+32gbghELTEDrjNLVn8acn+JLIhm8CjGYy1t4OenvTqvLaW/6uf
	zKIAEF6Thg4k38B0gwmBhHPihRTNRYEP0NozSOmKQz2fVpsHWunE1SEXzyOHobWBFMdUJH6kkKu
	zPgmevvyQJuVBhDdJjnVLQ5yJj4G+XOxbRHPidfhtAZY5cJ/yqvPumjrvhuA4wWY2k7N+j+xBFr
	pgu4Tb8t1zBWKm51+e5NzHPYK7E90fK45YdCX5wil6v5ofTV/8QUJAgGHcN+gr9Le9YaymM=
X-Received: by 2002:ac8:574f:0:b0:476:701b:d7f9 with SMTP id d75a77b69052e-4945273a3d4mr121262201cf.14.1746893773684;
        Sat, 10 May 2025 09:16:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWo1CbjdA8AQ/jtbqrbKVpnIFY8qgbZVRtE56jHinvaPG2CXAK4+P9sG3tHYA3A+dHF9tdaA==
X-Received: by 2002:ac8:574f:0:b0:476:701b:d7f9 with SMTP id d75a77b69052e-4945273a3d4mr121261831cf.14.1746893773269;
        Sat, 10 May 2025 09:16:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.12
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 02/12] upcall-helper: add a sample config file
Date: Sat, 10 May 2025 11:15:59 -0500
Message-ID: <20250510161609.2615639-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250510161609.2615639-1-sorenson@redhat.com>
References: <20250510161609.2615639-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a file containing example config lines, demonstrating various
ways to match hostname, user, IP, etc., and options to apply
when executing cifs.upcall.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 .../cifs-upcall-helper.conf.examples          | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 contrib/upcall-helper/cifs-upcall-helper.conf.examples

diff --git a/contrib/upcall-helper/cifs-upcall-helper.conf.examples b/contrib/upcall-helper/cifs-upcall-helper.conf.examples
new file mode 100644
index 0000000..f963f78
--- /dev/null
+++ b/contrib/upcall-helper/cifs-upcall-helper.conf.examples
@@ -0,0 +1,66 @@
+# example cifs-upcall-helper.conf lines:
+
+# set a default option to be applied on any future matches
+default                    use_proxy
+
+# set the log level to 1/info:
+log_level                  info
+
+# match usernames; add the keytab option (to already configured default of
+#   'use_proxy')
+user=cifsclientvm23        keytab=/etc/cifsclientvm23.keytab
+user=user2                 keytab=/etc/cifsuser2.keytab
+
+# clear current default options; don't set any default options
+default                    -
+
+# match usernames with regex; add the keytab options using % macro for username
+user~cifsuser[1-5]         keytab=/etc/cifs_keytabs/%u.keytab
+
+# match a cifs server hostname; no additional options applied
+host=server1               -
+
+# all hostnames containing 'chicago', and use a single keytab for all hosts
+host=*chicago*             keytab=/etc/cifs-chicago.keytab
+
+# all hostnames containing 'london', and use a separate keytab for
+#   each host (%h macro for hostname):
+host=*london*              keytab=/etc/cifs-%h.keytab
+
+# match cifs server hostnames using regex; add keytab option
+host~svr(chicago|london)[0-9]+  keytab=/etc/cifs_keytabs/chi_ldn.keytab
+
+# match cifs server hostnames using regex to select some, then exclude a specific
+#   hostname; add keytab
+host~svrchicago[1-5],host!=svrchicago3  keytab=/etc/cifs_keytabs/chi_not3.keytab
+
+# for 'user1' (regardless of hostname, etc.), enable gssproxy and
+#   specify a krb5.conf file to use:
+user=user1          krb5conf=/etc/krb5-cifs-user1.conf,use_proxy
+
+# match specified uid; add keytab
+uid=501                    keytab=/etc/cifsuser5.keytab
+
+# match uid greater than 500; add keytab
+uid>500                    keytab=/etc/cifsusers.keytab
+
+# all uids from 1000-2000, executing cifs.upcall with current default arguments
+uid>=1000,uid<=2000        -
+
+# several ip4 formats; no additional options
+ip4=192.168.122.73                 -
+ip4=192.168.122.70-192.168.122.80  -
+ip4=192.168.123.0/255.255.255.0    -
+ip4=192.168.123.0/24               -
+
+# any IP except this one; create/append to kerberos trace log
+ip4!=192.168.122.73        krb5_trace=/tmp/krb5_trace.out
+
+# match both an ip AND a user (all criteria must be met to match); add keytab
+ip4=10.2.3.4,user=user1    keytab=/etc/cifsuser1.keytab
+
+
+# always match, don't add any more options; equivalent to reaching
+#   the end of the file without matching any lines; '*' can be used
+#   to bypass the remainder of the file
+*                          -
-- 
2.49.0

