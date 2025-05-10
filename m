Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EF5230BE3
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893782; cv=none; b=LWyBCOrBh2uE21z2BBWBHRd0qmzeDscSmiUQ9EofVg7rXOCJmSbhvxZa8YIz4XPHbLlBAKpGk5LakbT0FUWuoS8Kl7Gp9VOKIkLfOGrMKWNaazZQsKjZd08A0HidWCZ9nbwAIAoOC79nrber84bzEAVdPa2tMkytKri+mhg8Zr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893782; c=relaxed/simple;
	bh=/ICGYQicLG2lJTjjt8kK/l+Xwl1M2eXZ4MDPxLB4IP8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hm52pVplVexVmSS0tQTrMcs5cZE2qnBt/f5rqwkaRSb1w0MNx0OMd1suZ6jl0UdqlaB/fWlPDgr+Y6LL7aQOUu8jTGH7QQvSGrmaLaBf1TjI4UZB+bIilzKu45a/6DSSVAZ24bYmfjrP/v9AQZE81YV4Qqswtb1W4YjB62lRGDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRqtT3Ah; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRqtT3Ah"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iezeWm6ehjRp5BGjmzknz+pwUdZ2C0Ybu5SWptE/Wmo=;
	b=dRqtT3AhPGNJOs+OtQ34jbEPJVwcemvjQWKCAy2iI0EuwjElszojNdeRBX9XTYGoLtBskO
	YvbOSQUwlCnKpkhv1vbKNXETXUrvw3GBCL/bxGpT7NQWC2QPSceCrQzNLrY6ZDr2kcanOx
	i3Hk0RNFKGyq0qLbsteXfmCerIqWzrI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-AWaFnTEONtSZhtuFPaaCaw-1; Sat, 10 May 2025 12:16:18 -0400
X-MC-Unique: AWaFnTEONtSZhtuFPaaCaw-1
X-Mimecast-MFC-AGG-ID: AWaFnTEONtSZhtuFPaaCaw_1746893777
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-476753132a8so27181601cf.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893777; x=1747498577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iezeWm6ehjRp5BGjmzknz+pwUdZ2C0Ybu5SWptE/Wmo=;
        b=XypHB8XhN7vo52IVIbWZGI0K2IMEjwArAk2jJeZTfvTcELqWYZCLCpsMlFxTzOi+IT
         /SzF1x83w6AU6swd/zdpzFe5d2tVr6xsia2zLQKaRQQugNzB5wXbFShaf2KMl67sUxFd
         yRvqH1Wd/RWWl2hsGqUtpcK5cRb+YOWUUIj/c2X4pnOVuoD8u1Ml1WWz3Hz6qhJwqCVD
         ApSL8ldLlvcwCyNqI3RvX8VWxR07WmVpEO8LGykylHHDlSwFq5RAhcgReb9pLj+fyRW6
         sRbTFOhpOIhZAV5o1alpKtzc/DmcOnfWhtGnS/q808dDNisTOC0nTVsoCLUpXzepeWfK
         eF6g==
X-Gm-Message-State: AOJu0YyyLSO6KrHdkhhlJ6aV8DIVFv39ZQesE1+em+A7FuQuo2SFlws8
	cPb+IBdM/kdBShBauj0kbAlhCC/8mn0NOtapoBUiA38jKdDLURHiyweLFmezkJ3NWQUDD1+XtJt
	A9OONNnrnuoAcs73Nu2LITgflHHIZGzWvIcS2qjSLcELwVDtlrFcsq59f0v7SOVTSPVNZaYxd4r
	g7guaggZ4k5V1tnpxFkyzBRrD9mdM0nUUA1w0ssczbA98=
X-Gm-Gg: ASbGnct140azoh+u2ZBjc7O5/9TEmTL/1b5eiJF6GuSLys9zpGzYG69Q9MxVr0PW3Dt
	HKjwvwNGBBJyj0Wynuf6VNniQV+YpsknPVLSrQ98pdCCRV+9E+2s4Qngu33NLPPg1jPefxvgozm
	gIaujIA7GdMfzP6q/O3S7pEqNsdS6i1GbparvAx6/82a4pEwEoymBe8zgQLRoZ0cCV6hvPsZ3xr
	dsZjyGd9UxOmODfFwRfDRhoWurbcjqW4WoatclRIzLH9dw+Wf/znYFu0SH92BGfBYxh4zRS4byV
	CCpAry38X3RPIz/J20nRnNWBX2tok23bkIuqIhaGBWpG3sGjUZ8o/NqgPKrXn5nbrhkQKgM=
X-Received: by 2002:a05:622a:49:b0:48e:ef59:db50 with SMTP id d75a77b69052e-494527624b3mr101230451cf.31.1746893777376;
        Sat, 10 May 2025 09:16:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8K31SK8FHdoZq10lb22Z+qsh+PW+kABJlZ0Lw/sWD9c30wokk55dAcrzXMJW6E7Y5mGCbPw==
X-Received: by 2002:a05:622a:49:b0:48e:ef59:db50 with SMTP id d75a77b69052e-494527624b3mr101230171cf.31.1746893776967;
        Sat, 10 May 2025 09:16:16 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.16
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:16 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 07/12] upcall-helper: set log level from config file
Date: Sat, 10 May 2025 11:16:04 -0500
Message-ID: <20250510161609.2615639-8-sorenson@redhat.com>
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

If 'log_level' is specified in the conf file, adjust the log
level as specified.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index 8929bd6..083ede5 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -150,6 +150,19 @@ sub match_criteria {
 	}
 	return 1;
 }
+sub set_log_level {
+	my $new_level_str = shift;
+
+	if ($new_level_str eq 'errors' or $new_level_str eq '0') {
+		$log_level = 0;
+	} elsif ($new_level_str eq 'info' or $new_level_str eq '1') {
+		$log_level = 1;
+	} elsif ($new_level_str eq 'debug' or $new_level_str eq '2') {
+		$log_level = 2;
+	} else { # don't change log level
+		log_msg 0, "unrecognized log level: $new_level_str";
+	}
+}
 sub parse_conf_line {
 	my $line = shift;
 
@@ -159,6 +172,11 @@ sub parse_conf_line {
 	}
 	my ($criteria_str, $opts_str) = $line =~ $conf_split_re;
 
+	if ($criteria_str eq 'log_level') {
+		log_msg 1, "setting log level '$opts_str'";
+		set_log_level $opts_str;
+		return;
+	}
 	if ($criteria_str eq 'default' or $criteria_str eq 'defaults') {
 		%upcall_opts = (); # clear defaults
 		log_msg 1, "setting default options '$opts_str'";
-- 
2.49.0

