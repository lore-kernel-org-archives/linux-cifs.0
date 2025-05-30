Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD9A192B75
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748619165; cv=none; b=OWeIGCL7tBuZ0+cf1sCiJoE/3K7PuKX9LDJYIrFMX4LR4ePbuI2xD4ZEfFptp6VZCFD6tVsfHf+2Xlv2jlJR4sgbDq0EmSLXsCuE6UX8eR7+SpSvq4xyplo+40w6Ntg4OZYh+PHRi5sKk8kNkY5m4TABZhK2yLaQ1IH4MBOMijY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748619165; c=relaxed/simple;
	bh=GK7P+vZyz30KNzf11hGejyYW+FLQL75DVuglhuIK4AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ej9nAj3WW7F1mKtTiL0AovdoysMs1djoIi1m+o5enrlDoPa3nMR9MyZeaVuihhUeIltIlciJjeO8wvCR0U1scIN5WcBtJEkiKlBtSHOaxchsWxCsIhGl6cdkGSuDdP9uh+fMLv7jsjlrku2BGTBhgFziIo8E2Oo784zR1vXPqM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RohiUF6F; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RohiUF6F"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-450cfb790f7so14650615e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 08:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1748619161; x=1749223961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8zCsjB5LAd21BdKq6uyGhcO7X8vr/cT92bwbPnsgauA=;
        b=RohiUF6F4OLat1xVt2dDRxYak6dDUKyCX/I4Kn1KkJiFFIdtJ10Dq4Y5RDFJClFHB1
         pi39NYA/x3/aEvrP1362nOPDizij3qI5AFxD8aJUJpWgWltz3Pzv/rmnLSPL3zxe1ZX+
         nIfM5EbElwLPc8jNwa14GJMWXU6peGdJJUZwJ020IWHT3SBcYZ1z6/lBF05Rol6MnCer
         CoJS0Eq6QZ+E05kmXsTzj0RZ/QQaEsPo0qM+51QzSU2cbICW3lvxr+rTrUS996re1QfM
         dcF5giJ79FRfBf0nEtTK3nc7xAjql56xd9NdSKpQILswEvfxHMz5GXcAAD4E9pwNJl6V
         RXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748619161; x=1749223961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zCsjB5LAd21BdKq6uyGhcO7X8vr/cT92bwbPnsgauA=;
        b=cWmejIxiIsVtlqmAKvMRR2uDZYud8ynzwV2DNzU03h0sBGdajO2rhqIlNOn/ZMzsBW
         ssYozd00VEoIQ3JmPDogNm++Mck9yLdB9JJAudGRHyBCr+2PqL04vpFdRzG/vgTxdv4U
         GziIolPJy9BhqWH1Sqv/UH+KjT6N4sICIC0Kmoq9s/8fB5zjkUqd4sAHEBr1Mya0SuUJ
         njEDWyLJ3pzVEzb5YfjqdOH8CivlcmbIq94EPQT1ZvqWQ3Xvi4HPOcxQg3xsHGWzC/Cp
         otliM1DWvFkP8KWct/QZquNovBVInZBJ7J04HO/5fkRhk5AderUPvfc2hjfqgs9nj83r
         2cVQ==
X-Gm-Message-State: AOJu0Yw3bdyCXjtUXq3myTEDG/OnMuIsnL12bh9REoTAGZSAnN0pt+cK
	eWnyLnInNggRp+B+y30MymU/+ZZ1EyspiCi/hFKMd9PdIQRvGpcQzU+VMCzMmuosktc0d/eJ8St
	buIgtu9E=
X-Gm-Gg: ASbGnctlhivkO06l2ldFwdwflYlc5/N3AYEvSqQN2VvkbtSyugQ4eXeI4Y5cpQfiyt4
	ym2EuJ+w/jXBpcv6bGKFQrpoW0lbkl6clxhgXaphqg960VVPg4yR9TVI9Ab5Z9mJFaARZb6/cmZ
	cGJP7nzlIv+7RVOZyotd35edv6iJp4HxxlVcsMnkqyITJZR9SSTThwRksb2uOejv1EyeuWp7dxN
	NCKk0E9ytTl/BJjHpK234jVH35VIgXQXGtkywdnAC3r3aswH4DvgpkerQzqREKbvY1uBlmFnb8b
	l2kumd9SW+/43D4YLQkLrdOO8tKSJkjqTC5lmuMPuRZll9KnjcX4rws6EPh9saNcecyjoVjBdMA
	U
X-Google-Smtp-Source: AGHT+IHrUgb/gGi0Fk+42kigWUxjTGw3rD5y9P7B445mEYqaPm2tiAkhEc+w37pCEXk3paaHtilgXg==
X-Received: by 2002:a5d:5f52:0:b0:3a4:ea9a:1656 with SMTP id ffacd0b85a97d-3a4f7a3e4ecmr3300258f8f.10.1748619160579;
        Fri, 30 May 2025 08:32:40 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc01:c875:de1c:c3e7:18dc:eefb])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-87e2a38f77dsm2818398241.22.2025.05.30.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 08:32:40 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] cifs.upcall: correctly treat UPTARGET_UNSPECIFIED as UPTARGET_APP
Date: Fri, 30 May 2025 12:28:14 -0300
Message-ID: <20250530152814.1592508-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Kernels lacking commit db363b0a1d9e ("CIFS: New mount option for
cifs.upcall namespace resolution") omit the field upcall_target from the
key description sent to cifs.upcall, leaving args->upcall_target as
UPTARGET_UNSPECIFIED. That makes get_cachename_from_process_env() search
root's environment instead of the applications's environment (default
behavior), breaking some mounts.

Explicitly set arg->upcall_target to UPTARGET_APP.

Fixes: 89b679228cc1 ("CIFS.upcall to accommodate new namespace mount opt")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 cifs.upcall.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 678b140..dbffb0f 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1515,6 +1515,7 @@ int main(const int argc, char *const argv[])
 	 */
 	if (arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED) {
 		syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
+		arg->upcall_target = UPTARGET_APP;
 		rc = switch_to_process_ns(arg->pid);
 		if (rc == -1) {
 			syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
-- 
2.47.0

