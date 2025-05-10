Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F168E2405E8
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893785; cv=none; b=n/Kmrq62+0Ki6O8MggUgmbAOQw+RQCGb/+H0K7HlVEw+0d7tHoKxuL5JjnRYnM3U2rpZ7IhUqVioOTUaZLTGEMyXNLkHYrgcFEfA1zENFRJBAaXMtF0JrstoycYbXj7/zWdM4crvmXzEI/KnxEEbzEg/fHWXiBoDzCXLwI7c4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893785; c=relaxed/simple;
	bh=XwFOmzIfEzxC54C+WvK0vFMiEmspPWSkCQQ2bP2Bi3g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEtFhtEIV/VARo6efyi2nO2MaVVu76NlITU3RI8GlLQ60xsdfG8OP6fIoDKbDAtuaybsGEJPjzFHXPAdgCXABEPWyCITewIwwjCN1mJETo+ezVmJEBGgjkgiYK4vy6jhLSefM0c10yM59VArYtYDD/vMfRuf9ivqTtw/50m9KtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBBh7NVU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBBh7NVU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kyghqtQvyqmRDSnXARSQ4gcaRBJZ2IDYa/8SeTh2h9Y=;
	b=SBBh7NVU9eRjO8x3/Wv/zRWbxt/TdTIeywXUBipFk84HZ/y6OZU/ILJYHDXVn6mFYVEwDL
	E1puFJTsf02+FqePaXdAAaiVBf2ZtgLkCMUcKmK2D11rRCOwpaZNHL56QaFZ0/XV01TS9/
	o8gnncdbKoXapfAiWIcYBd8R0tsoMWw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-PgaQ9mEENx-PNW_cFdE81w-1; Sat, 10 May 2025 12:16:21 -0400
X-MC-Unique: PgaQ9mEENx-PNW_cFdE81w-1
X-Mimecast-MFC-AGG-ID: PgaQ9mEENx-PNW_cFdE81w_1746893781
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4768f9fea35so77325481cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893781; x=1747498581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kyghqtQvyqmRDSnXARSQ4gcaRBJZ2IDYa/8SeTh2h9Y=;
        b=ZZrLe0uIgGrIHcc0dAMW42fUXCTpWCfstDB0J9FMIzrWDUhjId3YHm05WKnfd5luU6
         VRhOcEP9SYCyTGXC1sfvB0eGvtARioquEAbpOEAutQu9TcyiFaPtchpYerDTY2KaA+iA
         ZIn//O2aWfmaSeijEB1+BFN/SeXjBbepGl2kYaJF2MfzWrjob92GdKT1mHgx2y+wcbDU
         sWyl5qyDBxjZ1sw0hh6ItqdvHOd0Ck1fw7jBiP6pnF0VaYCr0RCfo1TyQXXHzaEJIGLd
         KIoaDVtlgoKNeoYwl/oj9RscPlswixbx6FOhR+Ifu0Es5FC6ApK7hVs60xg92BJAiDlR
         x2RA==
X-Gm-Message-State: AOJu0YytG1pcnTw4dioAitX62IWzCxdoFSTDTApcHnv4Rs1KxE76L+Ag
	+lp+gfSV7JwEipJDEHPTALAl+Y0zbrkCtbftcXgXnVbxslVawTk6tRihkFWKAXzCOJilFKDIg7s
	fmp+sKFLtla3vgb/S1jVATi/GBVKKwbaGveIbvzVnX6Rz7e/Ap1TO12v1MQQO/hJzat4kYqdOC5
	+hmSBSZRCP1eb0YZzvipH6mwAHC+qkDYi3zdR6YMOxKC8=
X-Gm-Gg: ASbGnctonphyYTCgpCAXmoLwuCgTJKMyhEM/Q/04TT8ejqRSONV8ueFpIm0wVqe/kyy
	ygSJEdcOSHKFTFNnXD+X1KQOONx/dzjP8gFYpUUOTjvAUIehykh/wVAJVZp+BJJfoozZRfovUHm
	4l8RL8SFIIbuzyJtbPIE55k0o9qRM2fz2N7+ziqh1QyR69rk7P1lQBRPrvsFEIB0kuMUrWzj5oe
	14slXiQTvatQcSOx1B9X/blXPXlYNy8R1v8jy5F7x1BtmeLFZS5HsOOJncEpIxY8Gf9OTrtEDmj
	TXay48krPf47d8BP3hxytZxiLI1PwEWBJWdUrAJpEyCtulweGLKfXGJzEfxTfEpZDpi/8DQ=
X-Received: by 2002:a05:622a:6206:b0:476:95dd:521c with SMTP id d75a77b69052e-494527dde3dmr125155711cf.45.1746893781138;
        Sat, 10 May 2025 09:16:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHryV7+kC1B3OqcpWTzqXpUWSrvRcNH2nx3T3Dp7YhxNNmQjDFXz6PkH77VtTdp1cR0TdCdkA==
X-Received: by 2002:a05:622a:6206:b0:476:95dd:521c with SMTP id d75a77b69052e-494527dde3dmr125155291cf.45.1746893780609;
        Sat, 10 May 2025 09:16:20 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.19
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:20 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 12/12] upcall-helper: add IP address comparisons
Date: Sat, 10 May 2025 11:16:09 -0500
Message-ID: <20250510161609.2615639-13-sorenson@redhat.com>
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

Add IPv4 comparisons for matching IP addresses, IP ranges,
network/netmask, etc.:
    <ip_address>
    <ip_address>-<ip_address>
    <network_address>/<netmask>
    <network_address>/<prefix>

For IPv6, use string matching; TODO: enhance ip6 matching.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 84 ++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index 2379914..90b416f 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -52,6 +52,14 @@ my $split_char = '[,;]'; # separator for match and options fields
 my $string_comparison_re = qr/^(host|user|sec|upcall_target)(=|==|!=|~|!~)(.+)/;
 my $uid_comparison_re = qr/^(uid|creduid)(<|<=|=|==|>=|>|!=)(0x[0-9a-f]+|[0-9]+)$/;
 
+my $octet_re = qr/\d{1,2}|[01]\d{2}|2[0-4]\d|25[0-5]/;
+my $ip4_re = qr/(?:$octet_re\.){3}$octet_re/;
+my $ip4_range_re = qr/($ip4_re)-($ip4_re)/;
+my $ip4_nm_re = qr/($ip4_re)\/($ip4_re)/;
+my $ip4_cidr_re = qr/($ip4_re)\/(\d+)/;
+my $ip4_comparison_re = qr/^ip4(=|==|!=)(\*|$ip4_re|$ip4_range_re|$ip4_nm_re|$ip4_cidr_re)$/;
+my $ip6_comparison_re = qr/^ip6(=|==|!=|~|!~)(.+)/; # TODO: enhance ip6 comparator
+
 sub log_msg {
 	my $msg_level = shift;
 
@@ -210,6 +218,78 @@ sub check_uid_match {
 	return 1 if (eval $comparison_string);
 	return 0;
 }
+sub ip4_to_decimal {
+	my $ip4 = shift;
+
+	my @bytes = split /\./, $ip4;
+	return $bytes[0] * 2**24 + $bytes[1] * 2**16 + $bytes[2] * 2**8 + $bytes[3];
+}
+sub check_ip4_match {
+	my $key_ip4 = shift;
+	my $comparator = shift;
+	my $match_str = shift;
+
+	log_msg 2, sprintf("check_ip4_match(key_ip: %s, comparator: %s, match_str: %s)", $key_ip4, $comparator, $match_str);
+
+	my $negate = ($comparator eq '!=') ? 1 : 0;
+	log_msg 2, "negating match in check_ip4_match" if $negate;
+
+	my ($ip4_net_addr, $ret);
+
+	if ($match_str eq '*') {
+	log_msg 2, "ip4 match is '*' (always true)%s",
+		($negate ? " but negated" : "");
+		return $negate ? 0 : 1;
+	} elsif ((my $ip4_addr) = $match_str =~ "^($ip4_re)\$") {
+		log_msg 2, "ip4 match is a simple ip";
+
+		$ret = ($key_ip4 eq $ip4_addr) ? 1 : 0;
+		return $ret ^ $negate;
+	} elsif ((my $ip4_range_low, my $ip4_range_high) = $match_str =~ "^($ip4_range_re)\$") {
+		log_msg 2, "ip4 match is an ip range";
+
+		$ip4_range_low = ip4_to_decimal $ip4_range_low;
+		$ip4_range_high = ip4_to_decimal $ip4_range_high;
+		$key_ip4 = ip4_to_decimal $key_ip4;
+
+		$ret = ($key_ip4 >= $ip4_range_low and $key_ip4 <= $ip4_range_high) ? 1 : 0;
+		return $ret ^ $negate;
+	} elsif (($ip4_net_addr, my $ip4_netmask) = $match_str =~ "^($ip4_nm_re)\$") {
+		log_msg 2, "ip4 match is an ip/netmask";
+
+		# validate that netmask is valid: bits of 1s, followed by bits of zeros
+		$ip4_netmask = ip4_to_decimal $ip4_netmask;
+		my $ip4_netmask_str = sprintf("%032b", $ip4_netmask);
+
+		# invalid netmask results in 'not a match', regardless of comparator
+		log_msg 0, "invalid netmask in ip4 match: '$ip4_netmask_str'" if ($ip4_netmask_str !~ /^1*0*$/);
+		return 0 if ($ip4_netmask_str !~ /^1*0*$/);
+
+		$key_ip4 = ip4_to_decimal $key_ip4;
+		my $ip4_range_low = ip4_to_decimal($ip4_net_addr) & $ip4_netmask;
+		my $ip4_range_high = $ip4_range_low | ($ip4_netmask ^ 0xffffffff);
+
+		$ret = ($key_ip4 >= $ip4_range_low and $key_ip4 <= $ip4_range_high) ? 1 : 0;
+		return $ret ^ $negate;
+	} elsif (($ip4_net_addr, my $prefix) = $match_str =~ "^($ip4_cidr_re)\$") {
+		log_msg 2, "ip4 match is ip/prefix (cidr)";
+
+		# invalid prefix results in 'not a match', regardless of comparator
+		log_msg 0, "invalid prefix in ip4 match: $prefix" if $prefix > 32;
+		return 0 if $prefix > 32;
+
+		$key_ip4 = ip4_to_decimal $key_ip4;
+		my $ip4_range_low = ip4_to_decimal $ip4_net_addr;
+		my $bits_remaining = 32 - $prefix;
+		my $ip4_range_high = $ip4_range_low + 2**$bits_remaining - 1;
+
+		$ret = ($key_ip4 >= $ip4_range_low and $key_ip4 <= $ip4_range_high) ? 1 : 0;
+		return $ret ^ $negate;
+	}
+	log_msg 0, "ip4 match didn't match any known format";
+
+	return 0;
+}
 sub match_criterion {
 	my $criterion = shift;
 
@@ -220,6 +300,10 @@ sub match_criterion {
 		return 0 if (! check_string_match($key_vars{$field}, $comparator, $match_pattern));
 	} elsif (($field, $comparator, $match_pattern) = $criterion =~ $uid_comparison_re) {
 		return 0 if (! check_uid_match($key_vars{$field}, $comparator, $match_pattern));
+	} elsif (($comparator, $match_pattern) = $criterion =~ $ip4_comparison_re) {
+		return 0 if (! check_ip4_match($key_vars{'ip'}, $comparator, $match_pattern));
+	} elsif (($field, $comparator, $match_pattern) = $criterion =~ $ip6_comparison_re) { #
+		return 0 if (! check_string_match($key_vars{'ip'}, $comparator, $match_pattern));
 	} else {
 		log_msg 0, "unrecognized match string: $criterion";
 		return 0;
-- 
2.49.0

