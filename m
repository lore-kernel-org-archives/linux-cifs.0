Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029A230BE3
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893780; cv=none; b=fsNj4PXW5eytK5pkOOY+Lh+Pre78aD3Ma+QCVx2L1wHxdwVWeJTU267ZV5MUX3tFZJ5zIBPu+bYNOCEE1L8Qf1rbs2xvV7SZsxZfKd80pOIM2nh4ZyNNBYfmuSuAGDBRG9wC4ETs6eZV2dFh0g4AIgXqAYgHawWdQdVAwLeq7zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893780; c=relaxed/simple;
	bh=wEfziWzcGhfo+rliYhR+9tiGCLkxJ4gyB1InN4yqnrQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDjTjBIh16BHUYgH7BPPTu0GusF+okN2JY5PH1GxZZv+pRObeSzf4et1VZoc2Z2NNlGVeDBNE2Rf+dX4Nd4MZU51ntE0vXoSZDA0EIHYehvgkDoIsDTCmaXk5PEswRjoJiqZmv68XxQTSj5UgYb42X33Bw+rsSbHAqCGcQwmogM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JqwvFRWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JqwvFRWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tChZqJNEO/nv2aN/oor5Lvd+Sh7epJ2Dngpppuw3xqk=;
	b=JqwvFRWsXeozZ21j3Zmf7j9FJghVVHyx8naL46ZEVYbA5KGXp9q1mBpDuUeF1u8bLg+B2+
	BQnfE7YOyrOy0JKJg8yU/Z9723re0Vshc35AVP8x+7AGuxzSIJJoo9l2LxISzOKcPWLYSD
	CbLvwFz7gwGANDSA/KJkIGbXQq7lqx4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-DHpQs983NyCSnmv7hqlUyQ-1; Sat, 10 May 2025 12:16:16 -0400
X-MC-Unique: DHpQs983NyCSnmv7hqlUyQ-1
X-Mimecast-MFC-AGG-ID: DHpQs983NyCSnmv7hqlUyQ_1746893775
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4768a1420b6so55973731cf.1
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893775; x=1747498575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tChZqJNEO/nv2aN/oor5Lvd+Sh7epJ2Dngpppuw3xqk=;
        b=qN97+/r/7d/1JK1YkZJtQaJUQ+RKl8cZQAH3np0zY/XHjYk2MAyA/Rxqr5t3+ouQUO
         XfsOFhGi6ey+Yxn0sYMn+Lj/b4+4BFuRQwTTXVeW6olmKB0KLq80gA6dBJ9YfNaFP0h0
         OgaFvhCRFEhXVXME63yYIlZInfLAW7cUPnEjVOj5BAeEWX8Pc15PhecnYmBG57mkgxCY
         863YbRjG7fghEF9OV3maPsRg/U7CmG9vTmDK8WsGRMKf4F4r3Cjk687lhOdjYDwb6+Sr
         nWekH+7MZyWsSRyYqZfF8o/hkzWiPuoQV42DKXs3IneXeMzfLF3QlVe77P2dphyJ6bH9
         NIaA==
X-Gm-Message-State: AOJu0YwIiNiVlIHm3SuzdoAHrU9qdynNTOVqAqm6K2kMK5XI00XN2InU
	DYFePLutDepSy5/7PjBW7jXiBfBRxRDaOVwwLX6hMZ8ljE4fTB78wlA8aoMYgtQiUhpW8jlwl/E
	h36H5OvinzFaX/AGtxq1ZhLkvN8HDKdWsbmcdY/7015HZ6xdTSv2Nf2qy4SLV12W6Rjv6Rh38I8
	QlDhjNGLmUjxmcmRwWGiot/E7LfwljmcQy+8Vt6nump6Y=
X-Gm-Gg: ASbGncti/m7yKZQtQiDt7ccEqYZQ6DlvdtP4TR16Yb4Epad8H4ZqBo4EJpOIs8V85Rp
	KmsbQo7dPmvpVUVXZmkEpTxx/Oi9Vc9loGvWI6fUn7iQd7sFv09wR3xIJHzgmD+SoiMGoJMp10H
	A+dIu8XrC71gLlyCPA2OgLa/T/UlyvDNr96n4m+/PvKIb7PP6zyGM0MWVzJWqqEskt0zaHkFSG0
	EsE6rJhBdPg7vsmGGqt4Exo/Bz0wcu7TMLZGvjs1zPG9FIZpF3tSuLOtdkOn3Uxjp6nXD6Ii85O
	bcrGMSKciEliIwvlB/V2yaF68rBe4yVwF+DbOAqiB9wvUBOUYsQ5qKyLUFyK9C93Yy+hFvs=
X-Received: by 2002:ac8:7e93:0:b0:476:ac03:3c2a with SMTP id d75a77b69052e-494527eafb7mr104279571cf.43.1746893775358;
        Sat, 10 May 2025 09:16:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBP7XTadPZCT3uVRhNmNhzQ8vflL4KfDa3deQRnhos6zhgaOww3mPz3OO5l0KqNYtiADr3vg==
X-Received: by 2002:ac8:7e93:0:b0:476:ac03:3c2a with SMTP id d75a77b69052e-494527eafb7mr104279141cf.43.1746893774786;
        Sat, 10 May 2025 09:16:14 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:14 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 04/12] upcall-helper: obtain and parse key description, assigning fields to key_vars
Date: Sat, 10 May 2025 11:16:01 -0500
Message-ID: <20250510161609.2615639-5-sorenson@redhat.com>
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

Execute keyctl to get the key's description, and parse the
description fields, assigning to key_vars for use during matching.

Still just executing the upcall with keyid.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index eead9c7..ee62aff 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -23,6 +23,7 @@
 
 use strict;
 use warnings;
+use POSIX;
 use Sys::Syslog;
 
 my $log_ident = 'cifs-upcall-helper';
@@ -33,6 +34,15 @@ my $log_level = 0;
 # 2 - verbose debugging (LOG_INFO)
 
 my $keyid;
+my %key_vars;
+
+# keyctl rdescribe output format:
+#  cifs.spnego;0;0;39010000;ver=0x2;host=vm1;ip4=192.168.122.73;sec=krb5;uid=0x0;creduid=0x0;user=user1;pid=0xbaf7d;upcall_target=mount
+#
+#  user=<username> is optional
+#  upcall_target=(mount|app) is optional
+my $key_descriptionv2_re = qr/^cifs.spnego;([0-9]+);([0-9]+);([0-9a-f]+);ver=0x2;host=([^;]+);(ip4|ip6)=([^;]+);sec=(krb5|mskrb5|iakerb);uid=(0x[0-9a-f]+);creduid=(0x[0-9a-f]+)(?:;user=([^;]+))?;pid=(0x[0-9a-f]+)(?:;upcall_target=(mount|app))?$/;
+my @descriptionv2_keys = ('keyuid', 'keygid', 'perms', 'host', 'ipv', 'ip', 'sec', 'uid', 'creduid', 'user', 'pid', 'upcall_target');
 
 sub log_msg {
 	my $msg_level = shift;
@@ -58,6 +68,43 @@ sub exec_upcall {
 	log_msg 1, sprintf("executing cifs.upcall: %s", join(' ', @upcall_args));
 	exec { $upcall_args[0] } @upcall_args;
 }
+sub get_key_description {
+	my $keyid = shift;
+
+	if (! open KEYCTL, "/usr/bin/keyctl rdescribe $keyid 2>&1 |") {
+		log_msg 0, "Error executing keyctl: $!";
+		exec_upcall;
+	}
+	my $rdescribe = <KEYCTL>;
+	chomp $rdescribe;
+	close KEYCTL;
+	if ($?) {
+		log_msg 0, "Error executing keyctl: $rdescribe";
+		exec_upcall;
+	}
+
+	log_msg 2, "description for key $keyid: $rdescribe";
+	return $rdescribe;
+}
+sub parse_key_description {
+	my $key_description_str = shift;
+	if ($key_description_str !~ $key_descriptionv2_re) {
+		log_msg 0, "could not match key description to known format: $key_description_str";
+		log_msg 1, "executing upcall with default parameters";
+		exec_upcall;
+	}
+	@key_vars{@descriptionv2_keys} = $key_description_str =~ $key_descriptionv2_re;
+
+	$key_vars{'uid'} = scalar POSIX::strtol($key_vars{'uid'}, 16);
+	$key_vars{'creduid'} = scalar POSIX::strtol($key_vars{'creduid'}, 16);
+	$key_vars{'user'} = '' if !defined $key_vars{'user'};
+	$key_vars{'upcall_target'} = '' if !defined $key_vars{'upcall_target'};
+	log_msg 1, sprintf("description for key %d  keyuid: %d, keygid: %d, perms: %d, host %s, ipv: %s, ip: %s, sec: %s, uid: %d, creduid: %d, user %s, upcall_target: %s",
+		$keyid, $key_vars{'keyuid'}, $key_vars{'keygid'}, $key_vars{'perms'},
+		$key_vars{'host'}, $key_vars{'ipv'}, $key_vars{'ip'},
+		$key_vars{'sec'}, $key_vars{'uid'}, $key_vars{'creduid'},
+		$key_vars{'user'}, $key_vars{'upcall_target'});
+}
 
 if ($#ARGV ne 0) {
 	if (-t STDOUT) {
@@ -71,4 +118,6 @@ $keyid = $ARGV[0];
 
 log_msg 1, "$log_ident - keyid: $keyid";
 
+my $key_description_str = get_key_description $keyid;
+parse_key_description $key_description_str;
 exec_upcall;
-- 
2.49.0

