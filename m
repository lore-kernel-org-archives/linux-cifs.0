Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7367218F2FC
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893794; cv=none; b=ARbxKlXEsjm32KBZrmDNo6Ltc8bNjwIDdfF1pqxKn7R8FTE5U0wcVVWHqHyC1pUosqG+fdHRbJo+mM7Pe+5KXMGfsqFeWMW6ixNDmA8YV+cCzEZj2ApA7S0wCYHH8LdLZwpSfCrcZVxDQEezspPRgGTNlMQd2o0Qou1uY21FjWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893794; c=relaxed/simple;
	bh=r28iAOOAikriFtZ0oQAGbICr+jQieZfce3q2GS2nZMI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbEWWVWFpDYGLziyDZvzl/LS+sGE6UqdtMG0Erk5V8N6TQsbhZCmsVjPiIk2I3VBGCG8L4/gq2nnv9dLIhUJ3vJnKrll1d98nN6MdvTx2C3Tw3s27wE+oNlGpccBTmCEmy6zcgf9Cwwm2bV9btFQYmWIhY4nHftlOFGoNGp/W8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E2UeINuh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E2UeINuh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kcXEgajFsKLm+epm9RNZ9F83nNKrUNJz3GGb7s7oHqE=;
	b=E2UeINuh08koefxvdKZTC8sxVy64rHyEpTf3TNGKZ2/fvv5tz66kZFpSlyzpUcnyS04Iej
	ue5FwXrODwtcv4EahrbwX+RvWUuP+ElwsN0eSUW+CPc9JpeL571QOrgFFvekl3PvXvXCrj
	MJcfjp57ws53R16NQdYnIzJkHWuCHxc=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-Ig-mx6yFPCaBLMyK68MhMg-1; Sat, 10 May 2025 12:16:30 -0400
X-MC-Unique: Ig-mx6yFPCaBLMyK68MhMg-1
X-Mimecast-MFC-AGG-ID: Ig-mx6yFPCaBLMyK68MhMg_1746893790
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-72bc266dc24so3922471a34.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893789; x=1747498589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcXEgajFsKLm+epm9RNZ9F83nNKrUNJz3GGb7s7oHqE=;
        b=Nh8FFLTl3fZeRhKZ+ix2NF8KIB705xO2KkommTD/GS3klLMcQZ4H0SR50X6ZDYcGR1
         COSDDuqh44VsCCVf/T9OqLbB2agUMNiUTsKWgMGim31gto7fkG360AlaIteql9YOA9D4
         cbY8aQIR6AX/5uJlILI+7+yFskeAUGy5tWyghLXpofC/SGz6Sa5fNR0zaHUmMiHAOOuf
         EV1mf31aajipAB76ZdA6awH5fJ6zqSqqk91/lU8dL79EU75zvfS1DUr9PSV6j+6ZG5AV
         bIr+ff1jAZx5eaUkoF2U5YDEoOZoidVtB6D04n1jk7ZVWn+kyPUsvXbtUQ+v6WjG5lTg
         2DoA==
X-Gm-Message-State: AOJu0YyJ/Or0WJUnWCpIbb+ktIZXxVs+9b/yylcS0g0zWgw0IMA6oZIP
	WHRhW71Qs7v2FUn7bndqXoujJjPlnI+Yt4rfjVtbsJNvbAvVKq5GAzcKBwYUMPeaWa2sILVvx8h
	Dl5+ixZXLY3lJzA4jKhMCxAW3VEBHsMXn3Z1gDImHd7h330xDLLdqHwdhpZT62ZkpkiluOWtmH5
	4IAGhVLkGVoVFVaYArARkL3yErebgaa9SGe4tAMrF2Bk4=
X-Gm-Gg: ASbGnctEXlMFksKCWogUZ9uEu13vTw/LugNSnXVJwO8bilOHTuWfXNZUoP7pDxHV0Qa
	uCw+WTTkZKKvnnLoZz+VP6ebS87N9yEer9ut83K271R1DdlwvjQub6bpA+4WU68Edty2jkpfn4A
	3AsGFogLHFIu+MxBHIhfMUkHR7pHZk+PnQ6y+BK/CK6/6gPaIrgevtxvOGbVXF+5csW/j0Gs93t
	sWEPJP2OOWW995V2yHdoRTb+29YA/MydMnGDNr1XQf4i0+mF48S3pkLUd0/sCIniCH5CsxBNFuu
	agFl7/4+17V+TBjNFOE/zfrhkpfBkTWOBnpwYKo2bNZEivuYNCF/b17z5soRzpY7f6Mb0Ww=
X-Received: by 2002:a05:6830:6503:b0:72b:8974:e3db with SMTP id 46e09a7af769-73226b14f21mr5308784a34.25.1746893789434;
        Sat, 10 May 2025 09:16:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKYXouDAYJDvLaLUZf6NmbbzAeMKG8/ZHvJCcHHzHNrzfrE5iyTpj6BhN8/vTepeeKCNm3/Q==
X-Received: by 2002:ac8:5894:0:b0:478:f8bb:b5e with SMTP id d75a77b69052e-49452736318mr131437651cf.13.1746893778288;
        Sat, 10 May 2025 09:16:18 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.17
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:17 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 09/12] upcall-helper: replace macros in upcall argument strings
Date: Sat, 10 May 2025 11:16:06 -0500
Message-ID: <20250510161609.2615639-10-sorenson@redhat.com>
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

Replace any macros in the upcall argument strings with values
of the key variables.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 33 +++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index 18e41df..fdd0c9c 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -66,15 +66,42 @@ sub log_msg {
 		syslog($syslog_level, $msg);
 	}
 }
+sub replace_macros {
+	my %macros = (
+		'%h' => 'host',
+		'%i' => 'ip',
+		'%s' => 'sec',
+		'%U' => 'uid',
+		'%c' => 'creduid',
+		'%u' => 'user',
+	);
+	my $str = shift;
+	my $result = '';
+	my $len = length $str;
+
+	for (my $i = 0 ; $i < $len ; $i++) {
+		my $chars = substr $str, $i, 2;
+		if (defined $macros{$chars}) {
+			$result .= $key_vars{$macros{$chars}};
+			$i += 1;
+		} elsif ($chars eq '%%') {
+			$result .= '%';
+			$i += 1;
+		} else {
+			$result .= substr $chars, 0, 1;
+		}
+	}
+	return $result;
+}
 sub exec_upcall {
 	my @upcall_args = ( '/usr/sbin/cifs.upcall' );
 	foreach my $opt (keys %upcall_opts) {
 		if ($opt eq 'keytab') {
-			push @upcall_args, ('-K', $upcall_opts{$opt});
+			push @upcall_args, ('-K', replace_macros($upcall_opts{$opt}));
 		} elsif ($opt eq 'krb5conf') {
-			push @upcall_args, ('-k', $upcall_opts{$opt});
+			push @upcall_args, ('-k', replace_macros($upcall_opts{$opt}));
 		} elsif ($opt eq 'krb5_trace') {
-			$ENV{'KRB5_TRACE'} = $upcall_opts{$opt};
+			$ENV{'KRB5_TRACE'} = replace_macros($upcall_opts{$opt});
 		} elsif ($opt eq 'use_proxy') {
 			$ENV{'GSS_USE_PROXY'} = 'yes';
 		} elsif ($opt eq 'legacy_uid') {
-- 
2.49.0

