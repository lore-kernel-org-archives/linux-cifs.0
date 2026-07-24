Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DC137A82F
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 21:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784929560; cv=none; b=mQaHcisoCiZYpt1zKm5b9Y7QjGoKIIvhkUK1TQRB0X/HHhfqxmX/sAJzEsqo843HNb84/LKHxnOxpoXQY311AOvnxh8tvc+QVrwscQwgopL8ns6HxE4zj8YG5CY//6RhCTH9VfQPdvApe2GXevSNEOqyyvbhLzP1uYVLgn3v6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784929560; c=relaxed/simple;
	bh=ZXk+HuCY5w+DAW1FYgxPpSpIpLUPZtdbPLMTL0airXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2x3Na9MPSMECD1xQNIR7V2X+X/NkRNgcfi6nMEpRSZ3ydrsbjNlBTUg+FQeoKcWpdP50GbRekNNGeavMgP3/FZ46Ssx/WZZp05eoVt9EU/Q0bRhOFqII5izFsHNaQt/h7jByUxzI4sQANIUsDnVuPk+IaDvbBMROaDGN9Z7c0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ggxBPmRz; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ggxBPmRz"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c0c45c580so7587261cf.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 14:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784929557; x=1785534357; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AjWAHH/RHmu7hi5Xd8oBrcstcdTviTfVMDpzgxKLx7g=;
        b=ggxBPmRzJsxtuw7JwDqq4mQNGKiZR7RaasF6OsY8xbxSKeKfwpFAKjha8wB1hsw7Jm
         8FOa473xcvB8em7skpjSHLe7bHq1Pshy67oovxpAn+l+chcCAzRRtHO9cdKXihtH4tjA
         tPw5X8iLXBaTfj4N+j8KzmhO3mV1aLqicleQIM+ZbAwylDQ7BpF6F2F9mrjOb0OYQD8m
         yEb4PS73LD33zL7FrxyBV98VWACIlsm5xhJNEETi+p1cWTxsAXnfNWcM0euU9Kczw2qR
         cNDlQxRP8uiGwHEF/NvG/hRSUDuw7KRuzM44v9qtydpwTbAGeApVkgthPCk5LNT10VJ/
         39Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784929557; x=1785534357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AjWAHH/RHmu7hi5Xd8oBrcstcdTviTfVMDpzgxKLx7g=;
        b=YdpmLWReqxSIWIFUV6vqxKQR3bkf+uZguRHxfS/US5Zf687oEylfTSJd6o+vhXXFNu
         dhcDSS7f2fX03rCA9Fj1Tdtru+npkL+uHBjYJKPT54N6R1EzQycLkK4WbFNwjYBlnYfz
         stXdR2JWg2+snTLq+yVRTEzsifz+YnxvmKIP0/Ixh+kHJiq4YnuR4GtLZLFDQxosqSQ0
         dYY/qaQRosdWW17XXdtuBNTOCQ1XNdFaiE5HFsF4f31HCARCR//NlrqBPwsG80WR4NVm
         LHlFR4XLeVdpefNZGTiOmQ4Zr0S6Gq/0OCZx5AXAfwXz6qHdsGwIYZ0cIUAbXzkfswcF
         nW6g==
X-Forwarded-Encrypted: i=1; AHgh+RoW+bkbpFc9P9iApBmvhr26MsHo80gvhxnrJeQv050UYmvk3e8/0rH7SUbti6Cs8Vvi2cVlXf8Sy3dF@vger.kernel.org
X-Gm-Message-State: AOJu0YwtfUB8B7OYraHI2GMB2XFnpK7dz2u+mi9sVfYlv01jSPlaQxn+
	LAB+jJaBt2q0K3ZHONY4OHlF6cD37TJ6M4MgCgSmVKXwID2p/XgXQVen
X-Gm-Gg: AR+sD11NKM64zEVaDDf3EQgCEl6qWgzjcqrNDnxyRZdVGrC3rCoNHuS2O0uTAdHZ8F8
	fAff4Gx90NaHbt0Mv+lJXU50Zfw6ntoQeuTVL93HrJ1FB+WY4xDoupFYM84TjWIHHx0mkhk2Mzn
	TPkCJAqj6qHB8txqK0pdU0+sK5kRROLoLNlmZpOJ2nDAw4aQ8P1LpG6FD8t75zLSXsUrM0JbsDm
	W+NmRC9rT6qsiDZ+sAmsXg1YOuByDo3T+wLpp4tWoP7YcxDT9u1IfX24wZak9uKRIq/S63SZRS5
	hAMHWMPwWwQFxHU3v0MbkTc1rBNhyNYeYKfKU0LIje8+CXw5JZAZ6vpBWOMtVWYxN12Pyoozy8+
	P3MO+ZiIdqRNyHhyPY/Pyy1r9nBOZ35W7Botk6wx7UTR4gcWiBp5+cjCpnOKee6VPwER+oyudte
	yCp/UnMRr8yUQYBCk=
X-Received: by 2002:a05:622a:1311:b0:51c:1cbd:5fdc with SMTP id d75a77b69052e-529a836ff49mr1421661cf.10.1784929556870;
        Fri, 24 Jul 2026 14:45:56 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:c204:8bd0:9563:8b5f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a29cf785sm7916771cf.21.2026.07.24.14.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 14:45:56 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH v2 0/2] smb: client: fix dangling pointer in DFS target hints
Date: Fri, 24 Jul 2026 14:44:33 -0700
Message-ID: <20260724214435.1850384-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series addresses a Use-After-Free bug where ce->tgthint was left
pointing to freed memory after free_tgts() was called.

To fix this, Patch 1 hardens the DFS cache readers against ce->tgthint
being NULL. Also, Patch 1 hardens callers of get_tgt_name(), which
returns an error pointer when ce->tgthint is NULL.

Patch 2 clears ce->tgthint in free_tgts(), eliminating the dangling
pointer.

v1 -> v2:
 - Addressed automated review by Sashiko:
   https://sashiko.dev/#/patchset/20260724023539.1596955-1-fredric.cover.lkernel%40gmail.com
   Split into a 2-patch series to harden readers against NULL and
   ERR_PTR target hints so that clearing ce->tgthint does not cause
   NULL pointer dereferences.

Fredric Cover (2):
  smb: client: harden DFS cache against invalid target hints
  smb: client: clear ce->tgthint in free_tgts()

 fs/smb/client/dfs_cache.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

-- 
2.53.0

