Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE669645
	for <linux-cifs@vger.kernel.org>; Wed,  3 Apr 2024 05:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121930; cv=none; b=WBV+MPks7xV1Ddx4FIuGsBA0UlSMGVqf5gkFNYQas3F+x2DAYVb6r7sDA1CO1KW5o4yIBCDlBjZW7vkZEhVx708jnSHbZU18zDAWzf1b/w4ZCh6iddmbBg7ZIYEq9QHbBEPoXw6W+3MraiS4RjC6E0tdP/W0qg2AZSML2pkalpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121930; c=relaxed/simple;
	bh=EvqFbwHanVhyAKSGvaStLakOuJrOjnBonM/BY5vhB80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U0hPReoTqn6y8hGhHiW2EUu5p9ztEn/qTmBd6dQB1DcUsxio8HaiUsuxlrzOh/tOJNI9aA60dy0DdffPN04FCNzpYJksfnn+l/aju8n1jwSHIwcmVj4GVafkGbWOf0SaLMtTOUsy01G+TQ7Xf/5kgl2KWIfQ+qpBZF/Qtp189+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWg7YfLs; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWg7YfLs"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4156201223bso2950795e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 22:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712121927; x=1712726727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6mA55kMPq7kkKfXP+AVchf/fHFtCq2niS0zNAdoDgtA=;
        b=OWg7YfLsRKHxyrGAGMIU7uAS3r9yPIIOP/8ks1A+xatLen5SR5zCPiuKaj9l1/4qJR
         b6poL4Z+7kh1Am6Qjsa4fULisdV8+ngYgXktLSiMvFj5LbEHDZH1g8KlAiEFL/ALcJpA
         irOW+Dx0NreXT4Tb6ucHrxoGH+KWwqxP108H8EBefoEyTKSeB0BIqoDriqwtbraLmNrJ
         pWrP7gONR8bcgF3wscHbmS1dwQ1UVKLjALahznNPQdWpINNT26rW14SbuS6C+oyTyAke
         reDmKeJA9vGaLW4h6ug/pUYcVrSNvcQskU+y+PfzuJBqMqiAFSjNao1y2igvwRjspzvL
         poqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712121927; x=1712726727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6mA55kMPq7kkKfXP+AVchf/fHFtCq2niS0zNAdoDgtA=;
        b=AixIzDCyIMz3CqMXcDCw5srNqkZrkEIjU/+ayLVV+qsyqS0/uAuIeWawVVWyM9nh/A
         PXerkSI9dQsLfxC4rqwr7NW9+rUOryJ7jUa1gDbmmILdUo+7+0iCVe/FOG2EkljKcoHX
         exi+0MmkM7OsVTEFi+njR+CIC60nc6lb+tijEq/HCQTiRbaONvyP6kncMvJntJVr5k1s
         wZi/YpiksqPM2Ht4/aA9oWzcuZz23qrhFkcMsZdAyOwiruEU2lW3vDEyQLyq0nexpCdb
         eDv1X94texBuQ4tGg9n/SzqJwQKgj1s2NRWs4WJU7Ss72zJOEd0CycXhwKxAm1ajJB2g
         vKgw==
X-Gm-Message-State: AOJu0Yw7cYIrxfn55xgMgcUPFIuBD+jVD/xb5W9Gj1Sa3qV9J5inaMkr
	b3au9Zn9f61RxQGiu5mkKGTcnvhv89fFMvy5QHHyl+Q+nrU4BQpNCJ95Ffk=
X-Google-Smtp-Source: AGHT+IHsg7Kdf+lRj1DsYiUkDlW8tsnUpfFrj59wx30kg8U5gtMchZgJFTDSfxiRk6n9q10V1Y4M1Q==
X-Received: by 2002:a05:600c:35cc:b0:415:5162:3052 with SMTP id r12-20020a05600c35cc00b0041551623052mr1202628wmq.11.1712121926662;
        Tue, 02 Apr 2024 22:25:26 -0700 (PDT)
Received: from torus.fritz.box ([2a02:810d:b83f:e400:16a0:2f96:e202:fd52])
        by smtp.gmail.com with ESMTPSA id j5-20020a05600c1c0500b004156e3c0149sm5734359wms.0.2024.04.02.22.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 22:25:26 -0700 (PDT)
From: David Voit <david.voit@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: David Voit <david.voit@gmail.com>
Subject: [PATCH v4 0/1] cifs-utils: CLDAP-Ping to find the correct site
Date: Wed,  3 Apr 2024 07:24:47 +0200
Message-ID: <20240403052448.4290-1-david.voit@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

after some off-list discussing and debugging the code now also
handles out-of-sync dc nodes. Other changes are minor style changes.
Also the error codes are now named and should show in which section the
error occured.

You can see a diff between the versions on my github repo:
https://github.com/davidvoit/cifs-utils/compare/linux-cifs-v3..linux-cifs-v4

Kind Regards,
David

David Voit (1):
  Implement CLDAP Ping to find the closest site

 Makefile.am    |  15 ++-
 cldap_ping.c   | 346 +++++++++++++++++++++++++++++++++++++++++++++++++
 cldap_ping.h   |  14 ++
 mount.cifs.c   |   5 +-
 resolve_host.c | 258 +++++++++++++++++++++++++++++++-----
 resolve_host.h |   6 +-
 6 files changed, 606 insertions(+), 38 deletions(-)
 create mode 100644 cldap_ping.c
 create mode 100644 cldap_ping.h

-- 
2.44.0

