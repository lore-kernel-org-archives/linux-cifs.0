Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B7D199EAD
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893779; cv=none; b=XSLIHEMzp4VWTksksNXDNJwHTr9ybJCrczmS19YP+3hmB5OA9FKg29mcCnioroMW+n/pMUVJGxxWLZuj6AGCFf/9XE9iyZwhESLZLIrYg2hlsAHw6eWKq7hfWjObTvpTYLvwVxcTaFDBIa2w4apbuZC4JNSJEGEk3N1w6FcyqOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893779; c=relaxed/simple;
	bh=8nfcOTDDwRakGeupothD+PXPNK9DMjG0ea6c/i0OEsY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqYHwvJk7HAJw0VaH3hxfk6/DOao4+WRR9mDjpKw7aBHnYgYw0c3xpOvzL7wQVfflyV8G9BR/t2NfpC91tfNm4dpiVY1inaPPaYp1RELlh09aCB7FwkDWMOwSZnbIdmxhEjimVC1k8w0fvlTDFgyiYNyY7gtTPbTWWJz2pttcsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXofvTtn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXofvTtn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R2Oml/2ipOnYloz0FWPeLu07tgTfL5aL7hMzTJwIguk=;
	b=YXofvTtnAiMK9AhK03njMf8s5SWsRYb37JeeMhspkwdWDPN8yjYlrxheGeHm7Wog7J4rEk
	x7UolKIblku3ANZoXeHYSkl2hKCjwDw0Ah8sZKpfmxGl0SeNKpoU4SvuCwIrlA0i8b4aM1
	BUpcBiTiufUQAAIn5MRBad+kTUz3Q48=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-aJmXxwdrPEuAXk_hYyXXkA-1; Sat, 10 May 2025 12:16:15 -0400
X-MC-Unique: aJmXxwdrPEuAXk_hYyXXkA-1
X-Mimecast-MFC-AGG-ID: aJmXxwdrPEuAXk_hYyXXkA_1746893775
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c3c8f8ab79so517349185a.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893774; x=1747498574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2Oml/2ipOnYloz0FWPeLu07tgTfL5aL7hMzTJwIguk=;
        b=rLwszjO6+tJv6kDrpLPMI9g0zaVDtlmv8M9s1FA48j1AlBp5i0CVCl9VJdICDhy2p0
         YXlXXZJ0qkXmg5JmjuvhjICnVOyVo1gV74s2UjjYvIPZ8r/OJCX+pN6RNSNwS7aZ+zW+
         c3DKVLVpkt8MtLTcAZW8ItN7zQFDss1d9NZs0cazx5JB7dVdPwx8yIMwRt1ZNzu3rFCo
         s1fgtrTyvVdRWPLEL6OGftUpAjF8Btujqma3wwyySxCl5T11cWrZDaUF/TnoyqSH+jjr
         G+q/QsTQaA9pKCnMdwOZOkixLzWFAbewSiYmUbnXXftBfenZycTcTbDxoCd0KUIlGwOJ
         giGg==
X-Gm-Message-State: AOJu0Ywn5Nd++nZ/FNd2l4+7LM2Q4Hm/GPnoU19/EMTNmVpBdOAoLcNQ
	QWmj5AcDHxoRSrStKzBfUwLoYXs/FrzWBMLoasV2q4g30dlz1eJy4P/eDa/udpCkunx8/XNtvnK
	LxXRRYgJf2CKDHG0+cg9Y95GKayi6efnG07pxLgbfRlIiE3DrS4Jc50JIgoBb1pdf/avpgsgO3O
	9nkGrlzmTI5JsoHHEDQoc0ipINZ5JdgMkN7iAqs/VK9V8=
X-Gm-Gg: ASbGncs6OtDND2RQxUFEbC9bT8BQjbmzEMoHp7ANb81rjUWF2I5UttqIbC1+XSPS8wC
	iTCH1JHqxcrUS/pm9rzFDCRVsZsZDty+P+oSUqPXt0Ns/qrmrDZ3/j+eIKEojZX0mtsZKcD/vvF
	GTtUMBhxoAwnnEJ7BvgMz8PwFJElYFsFnZrO0Ji0DSL1bjwHdvD7jKYD8fytGxdze1KIjd8CyqZ
	lUs25rW5IiXFA8l6X7lOsLG3uwISx3K+GyRGMQlVH9v+18GQnwxmVWj9dCK3ik8cYTng4FMDE43
	JOqGeSBlm87wCtVLlw1Pa8ANjBiLPISWUNXU+AlQat8fAiboky2x/456rgsq6XpCnAKf1ZQ=
X-Received: by 2002:a05:622a:410b:b0:48a:1594:6207 with SMTP id d75a77b69052e-4945273ed86mr101753031cf.15.1746893774570;
        Sat, 10 May 2025 09:16:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhrUX+HrVev2qoou3jkQ/u/1OOKnynsprDbxBQS/Wm2fM68KKxJrPSYMM2IEUs0jpfNkkOMw==
X-Received: by 2002:a05:622a:410b:b0:48a:1594:6207 with SMTP id d75a77b69052e-4945273ed86mr101752691cf.15.1746893774133;
        Sat, 10 May 2025 09:16:14 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.13
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:13 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 03/12] contrib: add cifs-upcall-helper script
Date: Sat, 10 May 2025 11:16:00 -0500
Message-ID: <20250510161609.2615639-4-sorenson@redhat.com>
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

Add a helper script for cifs.upcall, enabling complex matching
of the key's description, and execution of cifs.upcall with
specified options.

At this stage, the script does little more than call cifs.upcall.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 74 ++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100755 contrib/upcall-helper/cifs-upcall-helper

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
new file mode 100755
index 0000000..eead9c7
--- /dev/null
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -0,0 +1,74 @@
+#!/usr/bin/perl -w
+
+# Copyright (C) Frank Sorenson (sorenson@redhat.com) 2025
+
+# helper script to replace cifs.upcall in /etc/request-key.d/cifs.spnego
+#   to enable complex matching of fields in the description field
+#   of the key when using krb5 for cifs mounts; cifs.upcall is then
+#   executed with specified arguments.
+
+
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 3 of the License, or
+# (at your option) any later version.
+
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+use strict;
+use warnings;
+use Sys::Syslog;
+
+my $log_ident = 'cifs-upcall-helper';
+my $log_open = 0;
+my $log_level = 0;
+# 0 - only errors (LOG_ERR)
+# 1 - relevant messages (LOG_INFO)
+# 2 - verbose debugging (LOG_INFO)
+
+my $keyid;
+
+sub log_msg {
+	my $msg_level = shift;
+
+	if ($log_level >= $msg_level) {
+		my $msg = shift;
+		my $syslog_level = 'info';
+
+		if (! $log_open) {
+			$log_open = 1 if openlog($log_ident, 'ndelay,pid', 'daemon');
+		}
+		return if ! $log_open;
+
+		$syslog_level = 'err' if $msg_level < 1;
+
+		syslog($syslog_level, $msg);
+	}
+}
+sub exec_upcall {
+	my @upcall_args = ( '/usr/sbin/cifs.upcall' );
+	push @upcall_args, $keyid;
+
+	log_msg 1, sprintf("executing cifs.upcall: %s", join(' ', @upcall_args));
+	exec { $upcall_args[0] } @upcall_args;
+}
+
+if ($#ARGV ne 0) {
+	if (-t STDOUT) {
+		printf "usage: $0 <keyid>\n";
+	} else {
+		log_msg 0, "usage $0 <keyid>";
+	}
+	exit -1;
+}
+$keyid = $ARGV[0];
+
+log_msg 1, "$log_ident - keyid: $keyid";
+
+exec_upcall;
-- 
2.49.0

