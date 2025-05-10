Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73DE23C8D5
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893782; cv=none; b=ioKrEKoukFTS+V9SQDMdyAlt5o7INL99aXBfg7cAkMhmEmWwV4gqo7psKFmt4DdOUIjW+k9mTv/C5/5voOKF0kE5WFAn/rspAOb5KLtfQ3zKkvJ8ks9ngk5PTaJ2Kyb0nFvwf5uMBZUsjPL0J8haQSjyulCADZ70nLdDwwyNDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893782; c=relaxed/simple;
	bh=Z730r1IgUrHkS2fypX4ZexXdRx5nmqiic8NxSkJiQBk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZWUPnKZC6Mftug3pLLUydjOnvAi6WXeHpJVCMD6rfJKGWSCCTZQpcDIuPeWr1hYExYpqxD8nAeR+5J3IT/OblF1tlzgVNSvKUJpgn5Qttt0Za0IXgaPBXyjsUpmmb9uBrTPr6l8+/XD08BMI7bNKFLGUerEHCuXJHck9i4VMDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TFa8kJLn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFa8kJLn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svXYiLeb8CFTlJdrq8N9c+Fs7EZYmleS5UR6qMVi/S8=;
	b=TFa8kJLngoOn0Kbjq2lmnQwlaD/wGNYRD3ENo3QqGRr6vrLb7YhqRlHL8u1Z0Fcbw1wK5S
	e+bMosCXsvaUMvq3iEibHAG2Id+Lk/1zO+jFlwbn2+du4Ru+p760jlB6TWr8IptEKjsvxk
	MFiJ6x5B8zT5WqCYjNWUnAoS39MtNbA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-TyiTN5OZNi2HMM-zJ_MVlg-1; Sat, 10 May 2025 12:16:17 -0400
X-MC-Unique: TyiTN5OZNi2HMM-zJ_MVlg-1
X-Mimecast-MFC-AGG-ID: TyiTN5OZNi2HMM-zJ_MVlg_1746893777
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-47ae8b206a4so64255871cf.0
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893776; x=1747498576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=svXYiLeb8CFTlJdrq8N9c+Fs7EZYmleS5UR6qMVi/S8=;
        b=KRPOIPwgKsfBfIQ6H0uMcs3LmyG2WMIC4RYphe8ryr46bGgK6ZcuZR3vL6shpYbvX9
         1OuFZnQ/zdyRWsmrJtKV6Iv7/XjlECdBi2CTB/21a2KWL8RnMzasKYjn7Y6obHO21sDy
         ktTBPZCFrke9pkjJjXq+b5vdSeLcx63Bj4xe2Et68Z/Pw9K6rTbU+a365M8mdf+RIxPR
         uPcRw/HifD4qcRm710U9mHJqthAew4hpGGjJ+FgJm5SyP3liAZDtg5BlvTaRaP6FL70t
         7nY+fWdV84LfWc1kmcCUTWGse5RQMwXJIiJODPJnGe3Md51E3aKvIaL06ISBC0edHylH
         9sgA==
X-Gm-Message-State: AOJu0Yz8JYZs3DMVL/lc2mB9VTiPlE+8Ueo2ZT9aXSrV+uWBmbrBvsUy
	JfonBmGM0InPkpvXXq45PZF40hHH664PwuHplPkgVBkSYckjETmJFdOBdJ/xLsuCZYWaHcn1Wmo
	kNbNHitRWijuyfLvWmlNp2M+rLWw/yswTF20dZ2jqjzZbOqu7MrBSEiQNCBNi5dV0sYn8jKpOAR
	w8LIRCQsCJXB8PpdYMHZ2PIyT5p8OVvZiiEeUSBsJYBY4=
X-Gm-Gg: ASbGnctNnY3lxBGMPiARgOOPWoOglf4eHJykOx131VJtamUXerG5EIsa2Ysutr5RJ0x
	8nuvSnZMFjHB3ZZ6tBg0YyhXVHkwF8tgxOAs2IXeCFN1qJ9pmtAQ//8D0io9eCBKKHjzXdbccI7
	z0ZasCLCu/V7Jb5nIdm225VdnxWZKD2KsWTbHjs9hsGfvapVXDyZ7lIOmoe7g6pvi5cpyakq1WG
	tp4uHmurX/EmAht4rQ6AEOMm1rLmt0Kvxa1WTWY0l7/IJxY/GwNtr+ZQm6t2VNLnNNyl+KHcGK7
	6UxnYXG8O/FuteOk2/W7L66AZQQ2du0yOX18arILXWIjzOfD/PV+0ojPQVuXq229OBIXfNE=
X-Received: by 2002:a05:622a:90d:b0:48d:4887:982f with SMTP id d75a77b69052e-4945271d9f4mr125309891cf.8.1746893776653;
        Sat, 10 May 2025 09:16:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiRB+naIgMaJLbIjXwcUzNxbZzwRqO3sr2rNn3MI8HmEGfTzYDvAi1E8EfJy3b0ZhOGwqFbw==
X-Received: by 2002:a05:622a:90d:b0:48d:4887:982f with SMTP id d75a77b69052e-4945271d9f4mr125309491cf.8.1746893776251;
        Sat, 10 May 2025 09:16:16 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.15
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:15 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 06/12] upcall-helper: set upcall_opts on a match, or if 'default' is given
Date: Sat, 10 May 2025 11:16:03 -0500
Message-ID: <20250510161609.2615639-7-sorenson@redhat.com>
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

When all criteria match, or if 'default' is specified, set
upcall_opts using the options field of the conf file line.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 34 ++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index d1d7436..8929bd6 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -34,6 +34,7 @@ my $log_level = 0;
 # 2 - verbose debugging (LOG_INFO)
 
 my $helper_conf = '/etc/cifs-upcall-helper.conf';
+my %upcall_opts = ();
 my $keyid;
 my %key_vars;
 
@@ -109,6 +110,32 @@ sub parse_key_description {
 		$key_vars{'sec'}, $key_vars{'uid'}, $key_vars{'creduid'},
 		$key_vars{'user'}, $key_vars{'upcall_target'});
 }
+sub set_upcall_opts {
+	my $opts_str = shift;
+
+	my @opts = split /$split_char/, $opts_str;
+	foreach my $opt (@opts) {
+		if ((my $field, my $val) = $opt =~ /^([^=]+)=(.+)$/) {
+			if ($field eq 'keytab' or $field eq 'krb5conf' or $field eq 'krb5_trace') {
+				$upcall_opts{$field} = $val;
+			} else {
+				log_msg 0, "unrecognized upcall option: $opt";
+			}
+		} elsif ($opt eq 'use_proxy' or $opt eq 'use-proxy') {
+			$upcall_opts{'use_proxy'} = 1;
+		} elsif ($opt eq 'legacy_uid' or $opt eq 'legacy-uid') {
+			$upcall_opts{'legacy_uid'} = 1;
+		} elsif ($opt eq 'trust_dns' or $opt eq 'trust-dns') {
+			$upcall_opts{'trust_dns'} = 1;
+		} elsif ($opt eq 'no_env_probe' or $opt eq 'no-env-probe') {
+			$upcall_opts{'no_env_probe'} = 1;
+		} elsif ($opt eq '*' or $opt eq '-') {
+		} else {
+			log_msg 0, "unrecognized upcall option: $opt";
+		}
+	}
+}
+
 sub match_criterion {
 	my $criterion = shift;
 
@@ -132,8 +159,15 @@ sub parse_conf_line {
 	}
 	my ($criteria_str, $opts_str) = $line =~ $conf_split_re;
 
+	if ($criteria_str eq 'default' or $criteria_str eq 'defaults') {
+		%upcall_opts = (); # clear defaults
+		log_msg 1, "setting default options '$opts_str'";
+		set_upcall_opts $opts_str;
+		return;
+	}
 	if (match_criteria($criteria_str)) {
 		log_msg 1, "matched '$criteria_str'; options '$opts_str'";
+		set_upcall_opts $opts_str; # similar to defaults, but don't clear first
 		exec_upcall;
 	}
 }
-- 
2.49.0

