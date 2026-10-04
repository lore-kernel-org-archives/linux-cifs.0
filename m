Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F5C3AC0E4
	for <linux-cifs@vger.kernel.org>; Sun,  4 Oct 2026 15:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791126671; cv=none; b=OhU6DyWeaKdpSCSgIQFxcum32idYQ22qwyH3XWYln5ta4IeSX9DORWdY5mhLFIt4wRFOJXAQXa+dO4T3VY9a8pEou/SR1PI7ZpRRS2FQIyiy9RoAFd1XqwcAmmDINKj6m8XZemyrcsK6AHM5p9dFHme6cRX4WvatqtA6rNl1sNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791126671; c=relaxed/simple;
	bh=vx0BjKnpiC1scEj/tpuIdyMemtVNN+ToNuFPBQdmNHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lphja7sfRUlxdGL6f4LoyCmcCCmNcX7kSuuxvLzjH/j6Qc3EkcMVr5dCuMCGGKmnsYPxTBcBht4omIVFHAASpRXwVTDKtzGmDUoyBri05MPOB59CWutMLY6gjuW8F5AFXSFRhUFhEs00HKwWEDbXX249/NZWcEcqKlqlH0qbTls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UaNvaAie; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UaNvaAie"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4c08393b0so278356a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 04 Oct 2026 08:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791126668; x=1791731468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vx0BjKnpiC1scEj/tpuIdyMemtVNN+ToNuFPBQdmNHI=;
        b=UaNvaAiekSrTzaKiSFveFaDsk543NMnM/d6WrfAhb1bBLAFYAkk+Ix0a6RZGqnbi8o
         M0eAXjp3h66W9S7lR+bKO8YAUD6cWgIXbtUvwDEzTmozoKexJjuiJ6AWISM2LVTyyroq
         QH+xU8gcgzkQzbsq3P0nXatQPp8G1hkqxfQNcfgmp9o+G3qB8z9nbclw8NKEBk+dv0xA
         XVS+CS+xPEn7P9305WbgNTppQ5X9MZ/CkbMb5qqxX+lGe8efizu1JBZuuXvfluCc839M
         yJCRlMAR+0J0OLw0aNGTrvdF/bjtY79hPDV78WeLNLO4p9GyXgLGKG0zD6kPqtw7Dh1m
         sOTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791126668; x=1791731468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vx0BjKnpiC1scEj/tpuIdyMemtVNN+ToNuFPBQdmNHI=;
        b=BSteywe7avZCbssSxC4I3ohEYTIkHmQkbbzucuJSNdGFTIddhNYpMYlSEVkJWEnFsp
         SEZRJrIngD2ywc9Qww3HkB11I5rWNJNnD3w69zS2Do+zQYeJ31QBBSjIEVmqftO9mwF0
         WTgL5hju6IqOBFoEHYHrgJbLjXLiKDjCFIKINpLVL1H+J18qNdWe0acRQgsOJL3C9/Bv
         KF0sSQtIvC3FoEnAU7Y3fG0BdK+k5eF9xjXPovh851Zbh7aCPoy2UfYT91vCPNUQdY1V
         EfKtTDANEEV6wGSqqBBMB/SzFDVOJEroDQV0NKU4u1YbNxVq8tmkhBCPTX/U7ohe+H94
         R1DQ==
X-Gm-Message-State: AFq9FYITtm1HW5H4yjXt38stFJ/fAMiDZ05uuZtWrdKgqfsryWlNMlXT
	nNGNMRIqACuENMMTJqH0rN0eZzqO9CZ64dnMO3NPYrvKsma77APCPSq0
X-Gm-Gg: AYBFou2bbelpV+o7dyPAgaCS/ZUEG2EsywjTIm+dghIJnhmta3vw6QXWwCNxLEuRL+P
	wZbbKyItmgtyup7BGRdlLojxKFRTbR1MMNFt602xr+HH8w7QxNl0eWEhratc18M+E+DsyoiX5SK
	Lo0wMZal/7QvGY4GI0r0GdO34w1wXgED8Gy5TqhWjRLJC9gIzj67LKo6gsiSc/JutJnI1P61eHG
	sGG7OWGo3Dh7EoY5j6S1o0Thgyh5vmrFhRFdglaZWlWNiUDBmooDsO+/iWezr10LKeq0bMuVvMm
	E+pZXP+28YhSdv1VyQarMrkvHMhKen0BoktgXNa4auAcCRu6B7UbUpzX7KAxhazTd67MfE9SgqT
	FjzrITItGw35tz/6GAzy0kkk7c42yT/GpTbErUqDukDRJN6sFijmL3pbGZNc33pHgBGa5GWWU1p
	elz0o1SgmzkV8W8anv+w0gutjRGjLmhHx7FHTXizDh1nopx0TsU0UGDd/Q2OHmNmDb
X-Received: by 2002:a17:90b:39ac:b0:3a4:a7eb:1da7 with SMTP id 98e67ed59e1d1-3a6ce7f8bcbmr6285829a91.42.1791126668026;
        Sun, 04 Oct 2026 08:11:08 -0700 (PDT)
Received: from localhost ([8.219.43.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d59f1cdsm6969270a91.0.2026.10.04.08.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 08:11:07 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] ksmbd: rework ksmbd_validate_name_reconnect() to use a dentry walk
Date: Sun,  4 Oct 2026 23:11:04 +0800
Message-ID: <20261004151104.2196869-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930001605.1917523-1-zhangdairui@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Namjae,

Thanks for the patches. I went through both and they look
correct, including the failure-path refcounting. My patch was
not good - it was too complicated. Yours is simpler and just
as effective.

One corner case: if the share root is unlinked between
kern_path() and d_path() at init, real_path can end up with a
" (deleted)" suffix, and a later cross-share fp at that
literal path would pass the prefix check.
