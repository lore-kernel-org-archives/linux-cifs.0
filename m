Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A899725753
	for <linux-cifs@vger.kernel.org>; Fri,  8 Mar 2024 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709915149; cv=pass; b=Ubq2hJ8UIcZ4fhJ5IUjpWZsKUyP8yXOmMRnQg1oJeMpeFQvqTxyou6+U4oxlR/Fbzss4+LXIWSW6vvUiJNSIv6mY8ovWzVj933BF9aYmr2gzzMCLV4nsa7UtuZK6oT8pE/qkAh6wROLqFrNqjgfpRLoO+XQFUJ5f3CXQcCDxoU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709915149; c=relaxed/simple;
	bh=NdD8Sldjf/wrcRHXk1zM/BKwbNu+AtmqC6HhGRQd9Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M5njph8whZAgyRkNuNuHKHAHh0J8MozKOhuzIh8MjPOFGuyESHXL0hiPeLFg17aKKE/44YgRa0vD1Gu9rzzmOkvvjVoTg4sSnsokC9Cy7bvN63gj3JA2CwS79+G0oiVgtxqUa+H2zfSnG31wxjD/tT/apUjE4STBjtGJG3FxUqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=eBDn3RqN; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="eBDn3RqN"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709915145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GgRVwqxoIVjmfKvKl5b0rxA4U45tQwd4xP661YktRx0=;
	b=eBDn3RqNdE3Vqyf4nfblUEOajYw216FxeAdGYZPKm9VL1Bh9uJk9RKqKiHFlyWb9ty4rD7
	TqK9LPbkDVzBMBlu9xRXH7dNbrbUx8r5Ua1Jojmsdj8qduhn1EXAxqhKWyw/nGGCmnXSxD
	F7CPMAT6FTALHDrTqYfZumCrs+iUGDc0uDcByXP/i+0a3YCaWjSAx0LezM9aqX/MYD40sF
	nQU9WSgvwjpoeq2sT+6xJM2Ke5wJNk1+uIhIauhe7lLa16tYQ81jf3lr3keOsGRlj4xdQy
	lt2soa/Me3JLHbiImYbVQsosyaUfX2BwwrcWYf+DKiG2kecSVrfmusK7vlsw5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709915145; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=GgRVwqxoIVjmfKvKl5b0rxA4U45tQwd4xP661YktRx0=;
	b=bDmdJintkWBMEeDF3GauDExYjdZ6B55k7QuqFrU+JFKvA6XKO4ExOEM3oOo4LoELi6XTfx
	EZXPWeHa/ytcraSP0oRAhlSggQoCI2WmuUJ7ArKYARhqUL6m5d8aw8VDwHA0UETTFIF5pp
	zxKoC28WPZLeoGeQjnlXK48ib/Ny13ZMM83o9sDAT352FKSphZjqO2nRt/Q936bH8rzFNj
	HW8GA5p4pWa05+Y4HzkxSwO3n6k7FM3Pfi0cOwUXMUuYDMbPXhXo8b7tJdka0aIdanlbs6
	8QZnV2Nl6Fd9wHaPENoJJiDc/DhmMGRSnada6f671gwS66D9C8Ep6yQ70SJjMw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1709915145; a=rsa-sha256;
	cv=none;
	b=gUb+JyHaoyTE3M6Ry5RJ4vqzrnyJ18fRC95s8A+b000Dm4ziqj9rdgevMZlLeE8GPbpXSS
	LraVEQKo15PRcyT8ZTMP0LsWf+FQndrlXbvtEgbiSsz5dTcBPNkhr4wrQPrZ1RdUUb1Ly/
	XrThR8O+7GJgaCc81zwD2dRs7d5OWm9MGWAu7GaLjaOf0I5Y/5fVUgJcQkTi8Swawa85P7
	gEogpPshk10d2OZ1rfFVJCHqE9DabYUktToSPaRtBdu8Z5H6fePD2HOfpLM+eomitsnkMm
	lEbiaTZZkDU085w4n+Z43JkWRLoVfVjmfsfOp8Z1g/ZGSe4hSMeU01Drb5eg9A==
To: piastryyy@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] pam_cifscreds: fix warning on NULL arg passed to %s in pam_syslog()
Date: Fri,  8 Mar 2024 13:25:22 -0300
Message-ID: <20240308162522.345566-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix the following compiler warning with -Wformat-overflow in
cifscreds_pam_update():

  pam_cifscreds.c: In function ‘cifscreds_pam_update’:
  pam_cifscreds.c:340:83: warning: ‘%s’ directive argument is null
  [-Wformat-overflow=]
    340 | pam_syslog(ph, LOG_ERR, "error: Update credential key for %s: %s",
        |                                                           ^~

Fixes: cbbcd6e71c0a ("cifscreds: create PAM module to insert credentials at login")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 pam_cifscreds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/pam_cifscreds.c b/pam_cifscreds.c
index 5d99c2db3038..eb9851d52a7d 100644
--- a/pam_cifscreds.c
+++ b/pam_cifscreds.c
@@ -338,7 +338,7 @@ static int cifscreds_pam_update(pam_handle_t *ph, const char *user, const char *
 		key_serial_t key = key_add(currentaddress, user, password, keytype);
 		if (key <= 0) {
 			pam_syslog(ph, LOG_ERR, "error: Update credential key for %s: %s",
-				currentaddress, strerror(errno));
+				   (currentaddress ?: "(null)"), strerror(errno));
 		}
 	}
 
-- 
2.44.0

