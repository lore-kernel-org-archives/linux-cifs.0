Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBB423C505
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893784; cv=none; b=TleNpE8YPqztxr9xsiJIH+cKimc152MAOWGQT5SMXFmZf5t++ShOC/mNoxFDepzhZ4f7n0KZRL+iBxIFYb/+ZvDAVCKWEFBfJc/pSB6zX8rzvvbWHUMILBjdkWBvmBeKZoAgUp3AI0LA7Y7Uj5BHMn9PtEXEu3skdfsOkhtKT8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893784; c=relaxed/simple;
	bh=j6u2Y60lDuV7eyKRxEK24qF9PWj39Kh2oBlCEMDWBqQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh+w/0bOTwIyOymgo3A1t+Ka1nSW/t9Sqm28OpYTjT6wDUf93ffZx2nOPM7Z+XC+RB1kAFmA7KD8MsN86v6wJ9L5oDJyx0mFNQp3UZGa7Oub5vcciNK+44iFT8r7FABcqYt+GYQuvM2odHVFzbvozVziIc32cQVm/+6QMkYFl0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iz0uQSwP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iz0uQSwP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWMzhCuELiuZo8qSfstPKzqK/th9KKgagJQUif+wcvc=;
	b=iz0uQSwPUgZ0kqafQTPVPMriYbasoIP4VxvSmm5BQm9FBVNHhCrmXwaJsMmPrVKperTKa2
	hGJmUs44CObG9AgwN6+AydN/6l8peGAnI8vl6arUKNZbuAQAx9pbThc7AzOZkvy3h5KX12
	sw7RPuiFOrKe9PM1Oxvu744yLsaNaGQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-pDhMUMrbOd6-zOy1300E_Q-1; Sat, 10 May 2025 12:16:20 -0400
X-MC-Unique: pDhMUMrbOd6-zOy1300E_Q-1
X-Mimecast-MFC-AGG-ID: pDhMUMrbOd6-zOy1300E_Q_1746893780
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-476a44cec4cso50515971cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893779; x=1747498579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWMzhCuELiuZo8qSfstPKzqK/th9KKgagJQUif+wcvc=;
        b=sVHhJ+dj7z6UQ8Bgs+Cm/JCTwSzaRrsAHIVEyncUKmL6F5NShQjRyp1M3NSNAi6Gfu
         Wc0EvT5+Qy35ATcuJsmTD/5mZmJrgK1sAGdPLFJMipVlXBX65yV3PuvSNFppTv3h+1vK
         YDwRdEWDjMMz2xm1g23Dlr3lFXmBGM9XCToVOgJDBhcjPN3/EOzZ2P9qeDrriVuwCw+1
         LXc3scxQSFUUK86kn9hiHP7QhoA803PaABFJaexinFDNBFZOka/AHFmXRWvUD1o5seiU
         vfHPpiMIj7OaUmExwX8i9wTzQHKFVHnxBf03/60QeW7tc+i62kmsH0KUKI1gIJj42FSm
         AdOA==
X-Gm-Message-State: AOJu0YxrlcU7+7Qv6l7VLj91m81ST8u3lwk/ErDJs+XFXytSBbpx+mB8
	LwT1oEg4nykLUBIBkWbTnI/5PaLcmg+G0u5vLvaEnTqi0Rd5ZTO2oH6fNrXvV39kMaYNS1jexTY
	FIt4Z7yBob8nVGdsK6PT/Iahrpuy2RujRUfw3ilfwfIfM9Ce7Wt8rDFuiyzLy2J9JtH+pKBkxD6
	Yi2z01n859xNuT4FqB0SGjOPVpSXO3McNnGqFQzd7DBjQ=
X-Gm-Gg: ASbGncvZqh+42gboJpA85mpf7HbQRbEEoEdqofH/tXXJ5Z1BfZcqg/NwDXGtPGLu8iM
	6kYGX4gFlIqIexOYXyr32RFkSNPgfhsRADvdydW8L5em1ISMtLoKnkJ8JfowxZt1SyKUg+RufP5
	VMWap/KUuWnq/4zVNUxm1v6QlRsmy0+U5mLQyVg35UYx0OLYGghfYjA0uWY43SjULOEKf2plROP
	siGbD/mLKZn7+O21pb69ZsEMHorNLAhoKmbuOY1YWvQwfYqW1JLBMBsRfP1QyvslkKFMIm9o5v7
	f97WeNlGU3hqbOwuagK+qN042q+nOc8TgMR1woZ+KDiIELQircBdcKETowuU7zS/RqlN5G0=
X-Received: by 2002:ac8:5846:0:b0:476:b783:c94d with SMTP id d75a77b69052e-494527d3d04mr116000801cf.35.1746893779508;
        Sat, 10 May 2025 09:16:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkXVkOJ4f6rFik8EcgVkGHVKv1pqWsyDoXoadMIy92c2CsB6WktrA5djaQSVUsLMmnjjwC0w==
X-Received: by 2002:ac8:5846:0:b0:476:b783:c94d with SMTP id d75a77b69052e-494527d3d04mr116000371cf.35.1746893779030;
        Sat, 10 May 2025 09:16:19 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.18
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:18 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 10/12] upcall-helper: add string comparison
Date: Sat, 10 May 2025 11:16:07 -0500
Message-ID: <20250510161609.2615639-11-sorenson@redhat.com>
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

Use string comparison (as glob or regex) for 'host', 'user',
'sec', and 'upcall_target' matching.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 29 +++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index fdd0c9c..91243bd 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -49,6 +49,8 @@ my @descriptionv2_keys = ('keyuid', 'keygid', 'perms', 'host', 'ipv', 'ip', 'sec
 my $conf_split_re = qr/^([^\s]+)\s+(.+)/; # splitting each line of the conf file
 my $split_char = '[,;]'; # separator for match and options fields
 
+my $string_comparison_re = qr/^(host|user|sec|upcall_target)(=|==|!=|~|!~)(.+)/;
+
 sub log_msg {
 	my $msg_level = shift;
 
@@ -180,10 +182,35 @@ sub set_upcall_opts {
 	}
 }
 
+# matching logic
+sub check_string_match {
+	my $key_field_val = shift;
+	my $comparator = shift;
+	my $match_str = shift;
+
+	if ($comparator eq '=' or $comparator eq '==' or $comparator eq '!=') { # glob
+		$match_str =~ s/\./\\./g; # replace . with \.
+		$match_str =~ s/\*/\.\*/g; # replace * with .*
+	}
+
+	my $result = 1 if ($key_field_val =~ $match_str);
+	$result = $result ^ 1 if (substr($comparator, 0, 1) eq '!');
+
+	return $result;
+}
 sub match_criterion {
 	my $criterion = shift;
 
-	return 0;
+	my ($field, $comparator, $match_pattern);
+
+	return 1 if ($criterion eq '*');  # '*' is always true
+	if (($field, $comparator, $match_pattern) = $criterion =~ $string_comparison_re) {
+		return 0 if (! check_string_match($key_vars{$field}, $comparator, $match_pattern));
+	} else {
+		log_msg 0, "unrecognized match string: $criterion";
+		return 0;
+	}
+	return 1;
 }
 sub match_criteria {
 	my $criteria_str = shift;
-- 
2.49.0

