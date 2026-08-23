Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6723A257F
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511529; cv=none; b=glCF6ZlOdWCMDvHiCMFuhRVdpzTf8iSiRwWaP2U2lgxyPKagzbIBkKg8Mcvm+WWhok5UdsKlPT8a4L4vw50rDYhiOACmBWmD0CLa/a66+QLZ4kA55TS7dqLloWl6j5vieTB1gsLxMzkEQqUDLNTHckRfDDEhDKuQ3y0AfXRDShU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511529; c=relaxed/simple;
	bh=cIV+ZdC8TaMfF5dn2cUvf4xKuhzQ3Bv5jzj1pdF5zHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwVkkuFWVJxkabuIQgPgGnxp1whIdxcdWFfrRXgUix3tJItx+R0P9Uj6EKhuiWOi6GQDhmoscFk2coav7V0f+ITIOPu3wsi3fXCfiMFr8TBRZqGkuTlQeHHNpLrGyepkAhKUxXZgYiw1mytUqFopyuM313fzls3p3ngs/ajhirY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FN5heJ0a; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KraokQsf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FN5heJ0a";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KraokQsf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0m5kEjDkzw8sjC1Qe5HadK/QqnTlsalc1w9/+PtUYIg=;
	b=FN5heJ0azQcTHpIzvXZ4xwoEFO4W9dpzI4FgxVLeXqy5sC8zyZ2VZ/QzUsMVwthqWbfGOf
	HOMqZuLyV7Yag2dYhcNqPDjLWmHlMzGV2WaUjskfeIe/etaN634zUp2gO7SzIdXACEgQ7/
	DXRyhJk5IUeookACKiptvx/FZCSDV/U=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-h4O9PWGaPoSnOd2gcnH7_Q-1; Sun, 23 Aug 2026 14:58:45 -0400
X-MC-Unique: h4O9PWGaPoSnOd2gcnH7_Q-1
X-Mimecast-MFC-AGG-ID: h4O9PWGaPoSnOd2gcnH7_Q_1787511525
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7f1ddcd241aso6305185a34.0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511525; x=1788116325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0m5kEjDkzw8sjC1Qe5HadK/QqnTlsalc1w9/+PtUYIg=;
        b=KraokQsfMYc8Yf1hScwCM4QTO7SualPqFcJySZeBZLbUR8CpPlst/d4gVwWSWm4PZh
         RYvcenoh21DG2E/nizqqQjAUiVyXtaf7LcStpY5t0lT3xdDeF+jaBKP1uN0y+l0CoYQ8
         uIxo11HQclwKsa+z/+MgkonnL3IoKi8/pz2XnnM4TSCavyDoEkBtQs6n0E2wOKJ+72xX
         8bMLHafHScNvbecrv2Sy4JFp1LaOB335CKmHxe0ul3BQxafa/+Ur/Is++42XRiN4ukW1
         5E6ZqM/X0DldFOcC/Lyw3tBwkolLi2cH8620sOTB/Vg72l3+vhHpf6mELSdDs6hn89SJ
         ArdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511525; x=1788116325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0m5kEjDkzw8sjC1Qe5HadK/QqnTlsalc1w9/+PtUYIg=;
        b=jlR272t9tcic9fw4ItGpgroParQq6OUATKGYrZLEc7Z1lFvIv4+Jh8rX+anMEzcNrR
         G2TrOxPF+99Xk+GR7b0m9bZA2A6F4+huJrkyjQNs2RSO8e77dYK37sG/PiJqjxLBFHvt
         LHvT3/HMXG2A8il2BMvY2sLZUqxXQWOpFL++YJMVMouI+8vaa/UibniItHwCQS9SonsU
         KiNNTIfuXA94dv8Pdjz7tSGkgKGJ9guKawF9UpNgpZ8eGY8DNXK3GyDDtMJO2ekMvra3
         dqbeEcZodITfECcCX75axyVFDJTJ48xwFSuyyJLIcdAz7fShxk4XQ6UZarCcOikWScm8
         kPPw==
X-Gm-Message-State: AFuF++mJL1tirNhl1RNth8IbgRuvocESP/af9F1kN4hs/Y3D6PtI6Pz9
	375SJCqIhjz2NofwuymJ3EYMSB/ENrBv8qrrepXV8llxSG2DE19MBqzegTkxF5ds+37dQWjAl4e
	CEWYOCw8blyBZZNAkBi/XQWg4ZF5haljYt+J/7dI92T0rSkFB/eAG3+Nd8M9o20MyNAO4wkbLxJ
	fh72tgrNEO/CsO3CtniSsFfwcM1TsMiTJySe/Z20Jk7bDQwBU=
X-Gm-Gg: AR+sD10IKfyFOfrVNfAe0vvqUTanVh92svRgzdk4ZMfMZtG6Q6WvprQSYlOm87ZTPHA
	dnnYJnJiHzcHarquJRDQlqrBG1kIdGutqL14F268jSS70xRULfjVUv2UpFwkFcXefpWdAUpzFrw
	wHEmCSAo9zolv/0lE7CICSPmBwQADf+YWYYWYtBay6Ul6mlBc9+PiHYv3yl6pJGpBeg2CwtOn1L
	pZrzw6s6FCgPfExMY7nzmT92Fq/f4oRoKJUwfURisO66aQLw1FJx4mOqrbZHYVoPH/yqeDPSI5l
	oXV9k7ENkXP4n9TmS1eMRNarYxD+OfBsQc8VStgJYpyNIzCAwXSx0oeoRk4JH20JhhGBqGzsCBY
	bmizP9VZVZhlFc8UUGDh2PhRIqqZejaEGgytYPc4xydvlqws0/58/yYGWJVt+wGHP5w==
X-Received: by 2002:a05:6830:6605:b0:7df:5fc:3fd8 with SMTP id 46e09a7af769-7f4615dc9e8mr24701376a34.1.1787511525179;
        Sun, 23 Aug 2026 11:58:45 -0700 (PDT)
X-Received: by 2002:a05:6830:6605:b0:7df:5fc:3fd8 with SMTP id 46e09a7af769-7f4615dc9e8mr24701349a34.1.1787511524705;
        Sun, 23 Aug 2026 11:58:44 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:43 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 07/11] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Sun, 23 Aug 2026 13:58:03 -0500
Message-ID: <20260823185807.3115901-8-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_posix_sids() derives sidsbuf_end from the server-supplied out_len
without validating against the received iov:

    sidsbuf_end = sidsbuf + out_len - qi_len;

An inflated out_len places sidsbuf_end past the iov, defeating the
bounds guards in posix_info_sid_size() and allowing reads into adjacent
kernel memory.

Reject responses where out_len places sidsbuf_end past the received iov
or causes pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 98ea5c6c34af..c7a2dddb3959 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -77,6 +77,17 @@ static int parse_posix_sids(struct cifs_open_info_data *data,
 
 	sidsbuf = (u8 *)qi + le16_to_cpu(qi->OutputBufferOffset) + qi_len;
 	sidsbuf_end = sidsbuf + out_len - qi_len;
+	if (sidsbuf_end < sidsbuf) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u caused pointer wraparound\n",
+			 __func__, out_len);
+		return -EINVAL;
+	}
+	if (sidsbuf_end > (u8 *)rsp_iov->iov_base + rsp_iov->iov_len) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u overruns iov by %td bytes\n",
+			 __func__, out_len,
+			 sidsbuf_end - ((u8 *)rsp_iov->iov_base + rsp_iov->iov_len));
+		return -EINVAL;
+	}
 
 	owner_len = posix_info_sid_size(sidsbuf, sidsbuf_end);
 	if (owner_len == -1)
-- 
2.55.0

