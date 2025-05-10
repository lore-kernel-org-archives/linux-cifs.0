Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC1419D8AC
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893784; cv=none; b=UYR2KlLkgKVaK2xT0/aY6KlpySkQwOBBYtbH0DAHw91D6P+PitasGVlgzjdxg96wciIeyYiEWSBWXMHoT3D0A0xtuaR75nyu1QbiyKivd6LQECl66Kt6bfm+sX+J31geLXXdgqmOz/1n+OdRxkjBtvSInPEHWDma3PRNPptYwjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893784; c=relaxed/simple;
	bh=3hL7be6sZBvbi8t1ht5M7tvrSAYxxeD0T51b9LbBCag=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNzsdbIRzWaJ0020jh9IMwxlrlI42CxHPo4Vuxu+v1J85u7pnHdsfwEvNsSWDim0Ope5QUyRGQoaiyo7UOM2eAD6HyAI6LDMWR6uag229dcMtBtEJnhwjrHYdmfjaWCVwkYlTH+AaTEbvHQVOePAABHgD0AJyniw9OWWqGQCy3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NtXV3NSq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtXV3NSq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YU/si/qD05mGGJiHDTa0/4yChYzQznU7F6QGCAt3XTk=;
	b=NtXV3NSqLFDSz624oMxH0LOOaX9BWyepCzD7KIFepFGtCYHVx27fhcjVKZnuJU0GXYHPqS
	NDm5MjuczVAlCgEtLizftbRkHAbb2e2mVu4c/f5ZFThmgfqzISWyBbWBzmDlF5uniBVJfN
	GjN+DtqbETB403M9dUNQOY7wEf9y8mY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-MV4nmKcoPfmY8fSgRbMvtQ-1; Sat, 10 May 2025 12:16:20 -0400
X-MC-Unique: MV4nmKcoPfmY8fSgRbMvtQ-1
X-Mimecast-MFC-AGG-ID: MV4nmKcoPfmY8fSgRbMvtQ_1746893780
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-476a44cec4cso50516051cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893780; x=1747498580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YU/si/qD05mGGJiHDTa0/4yChYzQznU7F6QGCAt3XTk=;
        b=vZ/pL7dEOwzVoHj6U1fIAbwams2OfgGVmQNGBNqxWimrXASUqjcY2OS5sV56117jnO
         Ib1gEX7Vn+Co/2eKGOcwMQysXlpklOS1fhW1RWWDdxClHbRVSpHlsatf2L3PlBmzHfwf
         EQls//YNBWRw6ZxUjd5ZOUx+4Eh6XTWxP57H+EkRoQvA8ytz6cx8MFC4hsEdGPEpQUrY
         V5+Mbt/9GbJ3WmfLQzIaNH4tKx/LZdRyejjjN2vfc1NSNtBs1XKC49D3QuQSQYtyjyU6
         m/WccWfSMgEkqcHK+rGM6GI0FkRKKZmGZETm92I2Jw70QtaZCGVjL8iSDzBwbZ1Jr3Ds
         xXFg==
X-Gm-Message-State: AOJu0Yy/Ky4cvdSB8jv0Pl8Ef9LzluTSOFkkYZ2jtl68pxHNoIzXkCzp
	TKX6IUarC0jUG1hSv6GMTCb7wGaEXLZjHDsQ7BnDH9MFdHP73LIJ8/rTREtOavfTbuDELRzDShy
	+av2B2WKrV2Vm3JdlmxfFoeGsm6nH5c7HOgNRaKV/2RGe5KBrhUhH0/XjAyVUyQf2n5IAcOYXki
	jgQl+cA8ssIG3Ff1lZxG+EZhP8Xz08COMdmJnj0qFbDWk=
X-Gm-Gg: ASbGncu9V7Ck/Q5DCfdItN6yquJSD06BpBi3MXQNMR5Qu0CenYIcIcr8Wwf5j2BTscs
	rKDZhnwDEu3jN+85zk17HO3bo7AA8jXO7gfMT5rXl71K5ACBU4HTHoA9Mf6q+ovTOzDw2yhkcZN
	4T3EAQ4x5f3SjXS9MqJv8BjH/7J+H7fUa6y5YtgVG3/HWrntpkMPOSNHCYFt2WsowLm97B+PlMj
	F2j44zw1A0QJkWOCKijVhmDT+3cRR7F7vL/8UwOAk23RfUUgZoIEw9g7JeEI/K7eRGM2ca0Qdj+
	a9YwjKBVGzl32mtz5NQGIbihmsZ6+8AfIf1MfufR473n9cpu512wzQCcTFMwmx0nhgAK8wk=
X-Received: by 2002:a05:622a:248c:b0:476:8917:5efe with SMTP id d75a77b69052e-494527d4957mr140815581cf.42.1746893780203;
        Sat, 10 May 2025 09:16:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWUSbBpgF3Wf6Yci3PvwPDdPJiElelaKZvFGEn6eYEr11swCnKRTG1UxuIxzRgiGrVbgsaBQ==
X-Received: by 2002:a05:622a:248c:b0:476:8917:5efe with SMTP id d75a77b69052e-494527d4957mr140815231cf.42.1746893779843;
        Sat, 10 May 2025 09:16:19 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.19
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:19 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 11/12] upcall-helper: add uid comparison
Date: Sat, 10 May 2025 11:16:08 -0500
Message-ID: <20250510161609.2615639-12-sorenson@redhat.com>
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

Use numeric comparisons for 'uid' and 'creduid' matching.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index 91243bd..2379914 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -50,6 +50,7 @@ my $conf_split_re = qr/^([^\s]+)\s+(.+)/; # splitting each line of the conf file
 my $split_char = '[,;]'; # separator for match and options fields
 
 my $string_comparison_re = qr/^(host|user|sec|upcall_target)(=|==|!=|~|!~)(.+)/;
+my $uid_comparison_re = qr/^(uid|creduid)(<|<=|=|==|>=|>|!=)(0x[0-9a-f]+|[0-9]+)$/;
 
 sub log_msg {
 	my $msg_level = shift;
@@ -198,6 +199,17 @@ sub check_string_match {
 
 	return $result;
 }
+sub check_uid_match {
+	my $key_uid = shift;
+	my $comparison = shift;
+	my $comparison_uid = shift;
+
+	$comparison_uid = scalar POSIX::strtol($comparison_uid, 16) if (substr($comparison_uid, 0, 2) eq '0x');
+
+	my $comparison_string = sprintf("%d %s %d", $key_uid, $comparison, $comparison_uid);
+	return 1 if (eval $comparison_string);
+	return 0;
+}
 sub match_criterion {
 	my $criterion = shift;
 
@@ -206,6 +218,8 @@ sub match_criterion {
 	return 1 if ($criterion eq '*');  # '*' is always true
 	if (($field, $comparator, $match_pattern) = $criterion =~ $string_comparison_re) {
 		return 0 if (! check_string_match($key_vars{$field}, $comparator, $match_pattern));
+	} elsif (($field, $comparator, $match_pattern) = $criterion =~ $uid_comparison_re) {
+		return 0 if (! check_uid_match($key_vars{$field}, $comparator, $match_pattern));
 	} else {
 		log_msg 0, "unrecognized match string: $criterion";
 		return 0;
-- 
2.49.0

