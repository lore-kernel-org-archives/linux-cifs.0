Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7623E78C91
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893781; cv=none; b=IQZilCz+xLwbA603Q8si4cZVzSzne+m3dKJH3YTERgUUX2ObB6/U0aKioCj3woGXN1NNJTVgAoeOvi+0i47UIU410tcCr8bHVuiY84GD9N+TCkEbpuWA4muyDUJ5vRIzIVuLAoexAq85f06z2stW130sejRBGzBZkktMmWC60Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893781; c=relaxed/simple;
	bh=q4OcXrSLV1T5AsuxffoA+jFy6W2pDLYqRDADwENzd4g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdidZhbxov/iyj2f8XCY0g+mECUn/aiYD/Q3rjIQRje1CDAUMr+Nq/n1bWzYUmVdhvf7XRIxTTCCLv9oaOPdG+YZ7y803mSO6s4+nDpw1Mk7F6ilNxlauCPGJ3YwGcLrQ/CEsDwipzqRqpVmAykfY7MnWYSnPYs6E6gNFp/JCRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBqieW6f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBqieW6f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nhQvZI8dBVvt7Nsl2TYu2MLtVGlcpCPpGYk/4I0aSyI=;
	b=bBqieW6fd1MxibxdcpKgN51HoXwAhTdKdK0Y7643OSpe9pub8q3R4J/mm17lCPNaD9l9or
	9PKBE60gfOmfNQn2k4yey+J/mAi8X+Rb1Jo3ZORhCNLwnB4hPq9/xsI98zvQyuBk8yRaYS
	uEHu6FrviZ1QKMiWxebQssiZ9z9KW2E=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-1OC9LrLYOuKJWTCyoeraSg-1; Sat, 10 May 2025 12:16:16 -0400
X-MC-Unique: 1OC9LrLYOuKJWTCyoeraSg-1
X-Mimecast-MFC-AGG-ID: 1OC9LrLYOuKJWTCyoeraSg_1746893776
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-476753132a8so27181541cf.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893776; x=1747498576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nhQvZI8dBVvt7Nsl2TYu2MLtVGlcpCPpGYk/4I0aSyI=;
        b=HV3FK0pcggqUOWgViVIxAhzxeOu44O1rtEClNsdhtGqLCx4W5kFDCggukPpw3eFG8/
         /rpJekXVzl8rRYpYBlkyIqbzsiPm/BuLQPgXtDHomDm6u5k4uFE79YWJiBMGlipxbXQ/
         XuaFI+pHB+LPw/91boAUY86R5nPKAsw+/ApuPUMZEIgKWUKgzt9tTTX7hKEMN4qvEYKt
         J7Ij44z9umBjZs+pRJVPnKOiUQguL89lwn6CXMpclGBy+/aWYw1FghSVP0sPHc93OLxt
         ZmltfHcWI587A7p5MD/eComldwa1iD0kW/OqFraKZ4j6D5GWLDoEy24OJFbUm0PVTkSV
         CeYA==
X-Gm-Message-State: AOJu0YxqBTRVvZeWHlgGYr+FsNfUZr3YIm76bdNQb7eo7xT3yxLPjAbY
	nlkL0sKbm4EWk1SXPKutixI6JqFBUhdn8AmwXGhZeuu+8N6rmct1OGQlQpSjm92FZ2fDoGuNLc0
	rwKhf351cMp/EIQ88xsJqR9EJbOyGN4SS4FPtg0rdYuc0QCxkVZrdVR1R8fokW+0/aGEP3VhT87
	42U7sQ6mu1/ELFoM/flOqCcM1PpHkKmmg4xTLR539EvSI=
X-Gm-Gg: ASbGnct/SFa+cOlhltegeuTKbyHxJZywd75kIscAzsOE/4dijrgdOY1UMeqFebm0Ze2
	3CtJAsCzuyJc7S/VQdtVtFvzkXssJoa5hG7AQHdF2LATC9tB5HC50iuoEQjm7kOQhxgJF8O/TzC
	pzl2QR8qenx7QhtoeLRzmkUDX4jLyyGKneE2f7J0zI5bAX5I99du3gOOOUkbjQY/vTtO3uKUaxJ
	BB19ia3AuWcoZtrto+voNEZlX3D4qavKiICAN35p4mkKP0pLAM9mQagWd/n6hutl861C/WIEIv6
	bsSws4T0dDwFdgvjcDZx4LM6qbFHKyKAwQs0ORRE2CJDZfyw4tIi/x7pP50O7zu6zGNpEFQ=
X-Received: by 2002:ac8:7e95:0:b0:477:64b0:6a26 with SMTP id d75a77b69052e-4945273c329mr113730701cf.22.1746893775970;
        Sat, 10 May 2025 09:16:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPgdY4K9uOoeMyg6HlapjBZTdr3rtKYr7xyokqWGE0gVbPPqPwfZVy3cFFSbR08g+mRwmpYg==
X-Received: by 2002:ac8:7e95:0:b0:477:64b0:6a26 with SMTP id d75a77b69052e-4945273c329mr113730421cf.22.1746893775544;
        Sat, 10 May 2025 09:16:15 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:15 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 05/12] upcall-helper: open and read each line of the helper's config file
Date: Sat, 10 May 2025 11:16:02 -0500
Message-ID: <20250510161609.2615639-6-sorenson@redhat.com>
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

Open the /etc/cifs-upcall-helper.conf file, read and split each
line, and attempt to match each criterion on the line.

Matching logic not in place yet, so no line matches.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 56 ++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index ee62aff..d1d7436 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -33,6 +33,7 @@ my $log_level = 0;
 # 1 - relevant messages (LOG_INFO)
 # 2 - verbose debugging (LOG_INFO)
 
+my $helper_conf = '/etc/cifs-upcall-helper.conf';
 my $keyid;
 my %key_vars;
 
@@ -44,6 +45,9 @@ my %key_vars;
 my $key_descriptionv2_re = qr/^cifs.spnego;([0-9]+);([0-9]+);([0-9a-f]+);ver=0x2;host=([^;]+);(ip4|ip6)=([^;]+);sec=(krb5|mskrb5|iakerb);uid=(0x[0-9a-f]+);creduid=(0x[0-9a-f]+)(?:;user=([^;]+))?;pid=(0x[0-9a-f]+)(?:;upcall_target=(mount|app))?$/;
 my @descriptionv2_keys = ('keyuid', 'keygid', 'perms', 'host', 'ipv', 'ip', 'sec', 'uid', 'creduid', 'user', 'pid', 'upcall_target');
 
+my $conf_split_re = qr/^([^\s]+)\s+(.+)/; # splitting each line of the conf file
+my $split_char = '[,;]'; # separator for match and options fields
+
 sub log_msg {
 	my $msg_level = shift;
 
@@ -105,6 +109,51 @@ sub parse_key_description {
 		$key_vars{'sec'}, $key_vars{'uid'}, $key_vars{'creduid'},
 		$key_vars{'user'}, $key_vars{'upcall_target'});
 }
+sub match_criterion {
+	my $criterion = shift;
+
+	return 0;
+}
+sub match_criteria {
+	my $criteria_str = shift;
+
+	my @criterion_ary = split /$split_char/, $criteria_str;
+	foreach my $criterion (@criterion_ary) {
+		return 0 if (! match_criterion($criterion));
+	}
+	return 1;
+}
+sub parse_conf_line {
+	my $line = shift;
+
+	if ($line !~ $conf_split_re) {
+		log_msg 0, "unparseable line in $helper_conf: $line";
+		return;
+	}
+	my ($criteria_str, $opts_str) = $line =~ $conf_split_re;
+
+	if (match_criteria($criteria_str)) {
+		log_msg 1, "matched '$criteria_str'; options '$opts_str'";
+		exec_upcall;
+	}
+}
+sub parse_conf_file {
+	if (! open CONF, '<', $helper_conf) {
+		log_msg 0, "could not open $helper_conf: $1";
+		log_msg 1, "executing upcall with default parameters";
+		exec_upcall;
+	}
+	while (<CONF>) {
+		my $line = $_;
+		$line =~ s/#.+//;
+		chomp $line;
+
+		next if ($line eq '');
+
+		parse_conf_line $line;
+	}
+	close CONF;
+}
 
 if ($#ARGV ne 0) {
 	if (-t STDOUT) {
@@ -118,6 +167,13 @@ $keyid = $ARGV[0];
 
 log_msg 1, "$log_ident - keyid: $keyid";
 
+# no config file?  just execute with default options
+exec_upcall if (! -e $helper_conf);
+
 my $key_description_str = get_key_description $keyid;
 parse_key_description $key_description_str;
+
+parse_conf_file;
+
+log_msg 1, "no key description matched; executing upcall with default parameters";
 exec_upcall;
-- 
2.49.0

