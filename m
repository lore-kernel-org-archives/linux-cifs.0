Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B9C199EAD
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893794; cv=none; b=YDzLmzIiiA95HApgao1xoWub15xZy/kBN9I8Wr4hbxdgQk4oILO9ddbAMk7HXr1x/nVEenI3QNYBElylraEzzJuTw1tWboPb6lnDgYwJ0KJ0bIGgmoz3xbVe5QJHPLeMjjjWLvvfYB7hAz4IUqK2yUqc49AuOi9zWrUz1ZuYwlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893794; c=relaxed/simple;
	bh=Hrg8y/FysTql2Otoi/Yf+U831skLEXDgvDyz2xJMJao=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0anXGCl77pDFl69TiAN3XCwhiuWEqmCBbEKDAIJDnixytKH0ozZ8A1TnlRNELrACYcnXJcQcLRu/pyNrcp9L6L51M4t9DjFFJblk21CgvSlxZBaYqf+t2FPeHf4mIsWf+yHKMtATrdWoBDQSC+0cZHaooFhLDo7q/XzqArykGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZHp0jG+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZHp0jG+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b+ScboFhp2jhGobm2E2hA4e166zTv9miXHMyrpOsqBU=;
	b=MZHp0jG+LYQYumzJVcIImMxdtzk0OAvu7gQu3QLNvvaXhHRR+CEHBVMTfriw50X23cyUg0
	Sc3+4MZ5ZpybdcZJV7Z3wdMRnDaxEKLCQyD8E+TtIB+JUqA0RnzqfbnKMQIAyVHkHGC6nk
	L1wu4LricS2OSJS3fEPRKJmZ0r8l0jc=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-DmQDxH16PZeJCSFi101Yng-1; Sat, 10 May 2025 12:16:29 -0400
X-MC-Unique: DmQDxH16PZeJCSFi101Yng-1
X-Mimecast-MFC-AGG-ID: DmQDxH16PZeJCSFi101Yng_1746893789
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-72bc266dc24so3922466a34.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893789; x=1747498589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+ScboFhp2jhGobm2E2hA4e166zTv9miXHMyrpOsqBU=;
        b=e8/ekX+RoB0rAlnwVMpPPcPpj5PsYfQFLVZ3+ZwpcErt2oc6ckh2SEFZ8b7NysNqxQ
         KA88Mjq9fTxtDh6/kv9d9uu+EYTgUK3Kf1GCwamcsELJqvVZ+aGIdu+vqm5GqD6A3SNN
         IZtfpu0+vRwD+nADDinYorZOMTk2sqGOOGyT6u8AF3RlSiMYhhKEyEpwAh1rJJ/JbUBa
         d6nI+iuU6ZTzATrjNlOhUgZby5U//KP9Kk0lfkC+iHodIuvvgGSLdT7cCPEo/YNr3Csl
         zhCBlFN0DnXRxZXprq9K/WjYK24bOEtX2k1X1TjzWVOBrRENchCyRZm8vdp9swIqBZ7a
         47tA==
X-Gm-Message-State: AOJu0Yx3mvi9QzMHBn9VXywSBNVvW1Z2IljeF7huvWrJIRBI/5U3AiZB
	U9/cx9SsXb7+MNBlTpEh/eMhZz3VX+FaVZnW7HhFIZMJw8ngnyV4cGAtK19t8LSDI0GIfceeYkd
	DiChBZc0M7Vvwm16Vss85HILEEhX/ZlYveTcuONDBZaEm1QL5GGVmzrIHG6X21svVBKy8QRt6Ht
	irLAyABHDjQhnxXXNXnatq10T9E89KCr58/iJiS2jfH3Y=
X-Gm-Gg: ASbGnctdqHFSLyjC8hD02OcPKXIsbjMlN8KesLgYvCTKt4z0fnwQ5iyaEO8XQtvgaqX
	MzTgbPJHmVCmy9ibQOrT+GYeEzkwGiaJR6zUSgoXslTMmPuvXZCaTXJjGZReKIU3rSvJIQXzIOO
	TU7qA8PjnJkgLW1yGWVNw5ORdTpc27GzXcVbjB1EBh0v7UO96QlwKVc3XN70DSMkzliye6ZDC/u
	//+XwMhZaVrEIj6/IgGMjNSXrtXoAK6h34dwf5ubpbDk9P1SlIFKlfecrKyb9s1S8WCUTjCiP1p
	Y4Etr77KFnExwkzpRvytw970lcKriWMYkOh/xXpNk/WaOicSVu3CqcPkJs+2icuN+46wtUc=
X-Received: by 2002:a05:6830:f82:b0:72b:a064:fab0 with SMTP id 46e09a7af769-732269a1356mr5582817a34.3.1746893788860;
        Sat, 10 May 2025 09:16:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoV8Oh3XzHxA4CcWbqIMrJ77r3/WswzotZ/ULkbON1xozfhNomiGsr6vNRZ3mCR9XsWuJzNQ==
X-Received: by 2002:a05:622a:5812:b0:478:de14:135a with SMTP id d75a77b69052e-49452739bb2mr126392141cf.20.1746893777665;
        Sat, 10 May 2025 09:16:17 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.17
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:17 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 08/12] upcall-helper: build command-line and set environment variables for cifs.upcall
Date: Sat, 10 May 2025 11:16:05 -0500
Message-ID: <20250510161609.2615639-9-sorenson@redhat.com>
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

When executing cifs.upcall, use the values of upcall_opts to
determine the command-line arguments, and set environment
variables if specified.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/cifs-upcall-helper | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/contrib/upcall-helper/cifs-upcall-helper b/contrib/upcall-helper/cifs-upcall-helper
index 083ede5..18e41df 100755
--- a/contrib/upcall-helper/cifs-upcall-helper
+++ b/contrib/upcall-helper/cifs-upcall-helper
@@ -68,6 +68,23 @@ sub log_msg {
 }
 sub exec_upcall {
 	my @upcall_args = ( '/usr/sbin/cifs.upcall' );
+	foreach my $opt (keys %upcall_opts) {
+		if ($opt eq 'keytab') {
+			push @upcall_args, ('-K', $upcall_opts{$opt});
+		} elsif ($opt eq 'krb5conf') {
+			push @upcall_args, ('-k', $upcall_opts{$opt});
+		} elsif ($opt eq 'krb5_trace') {
+			$ENV{'KRB5_TRACE'} = $upcall_opts{$opt};
+		} elsif ($opt eq 'use_proxy') {
+			$ENV{'GSS_USE_PROXY'} = 'yes';
+		} elsif ($opt eq 'legacy_uid') {
+			push @upcall_args, '-l';
+		} elsif ($opt eq 'trust_dns') {
+			push @upcall_args, '-t';
+		} elsif ($opt eq 'no_env_probe') {
+			push @upcall_args, '-E';
+		}
+	}
 	push @upcall_args, $keyid;
 
 	log_msg 1, sprintf("executing cifs.upcall: %s", join(' ', @upcall_args));
-- 
2.49.0

