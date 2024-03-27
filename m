Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B192EB05
	for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2024 10:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711533669; cv=none; b=i308NT4UICqcIGrdw/vlTGbvPQpMtybi5S0+E40iRrzO0CeFZsobuqKZAdVA8f64yk+7QISXWtSadVnUrMFCshLtyZVu5wBnOibeMWk7sc65G6LB52UvDvQlP1ddEYIE7RHE7m6i1Xrob/YeQHTc/bsibVFoaPAY0SHfyKRAeXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711533669; c=relaxed/simple;
	bh=lvL0MQeeJnEeJRGN2zugYDCwcZBz23E/E05d6DsXgc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kYEnGLYEfAUWy+m+zKwyAkAQxaWr+gBYP3Xp7Nm/lv25UpbXf6Q+Uf//uU3zTeN1KVdtlXM6eqrpPsh7CDpkxl8kY00WsKXQbD6Jhfgf8G9NO7aqYeTdorIYUeroD6hxV3bxA+KCPBxHa6rbthWuaut9Bm+wLbiRjAIqt69Yngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JxTc7lJL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxTc7lJL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a4e0a65f37bso33166166b.0
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2024 03:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711533664; x=1712138464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t4lVn28+zklCKxdwkKZqHb7dBR4k9m4Gfe5Fb4lBTW4=;
        b=JxTc7lJL3Cy/fUAoTLz2yLoiOKVXrJ1FJqKcmQZi+kU/Plze3FXS8LQFPD24PT746K
         c0TW/D0cYhPYci9HM6FlEMmtNCbKEvWlVk5jVnuFAFvc31KphSt+mNAybjrvidXzlpim
         NxopbfgSlHloD/s9GI3CawZ19QuV0Pa5xa24S6AzOGM82JECj4KCSvED5ytAsuxfSeuv
         T6gJ8blvJd8ZFKdQqWbYErWWA1oZmQcNYpslIKTaIPThGs+IJXKAsAgC68Qw2OIcTLIR
         bH3mvGSGN+nyriDGbzhrw644OOXpZ0PGO9/s/pm4TZqZNbdOOzQY4dMMtvso0CdE7ZVQ
         B2Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711533664; x=1712138464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4lVn28+zklCKxdwkKZqHb7dBR4k9m4Gfe5Fb4lBTW4=;
        b=VaoneQLVf1SkjyGAhmg4SIhaxpp50ylOKdBdmXB6V9xxUZFALhM/nXnVbD7iRPIMe0
         H2kb5JoQXkuxutEGvqvMQWJF1gh3GSCRD1MmhTWje7/fnUc0uQGRjwsU1GsFh2F1AdjV
         n6LB0ePfz8Tcy8kf5w/aZ9xSCte8S2Y2L6HGUUaQ0t1vB3HWXEZUym0RfFPYZrG5cI8w
         9/ksqzcs3MmotiUwonUDjN+VAL9deoSZXfaE9tpICRWSJKEXHDg5lxu+lCe2h5DQYjti
         2T+Dszixs4qSa0ex571ayhBRwskYse7+htJq4Xltjiz7DNwlC1CcUL+8V8f3WtqALY+9
         0I9w==
X-Gm-Message-State: AOJu0YxwDRb+jjwlLqY5dasQFXNlVjM/hg8FaHiKpLflffkx5PyrM3jI
	mRRqXcf4ClCH5NdeEvfDRZnytbw4Zojt9uy1kkT+b27/ZQKVyFNNDlS0JxY=
X-Google-Smtp-Source: AGHT+IFmAcgWJyloP8645sGrAD1YTw/b8edJwSOEYdAfD3UbayXWNTkClT9B4djH7LYpdLvcI5/Cqg==
X-Received: by 2002:a17:907:7649:b0:a4d:f56a:19fc with SMTP id kj9-20020a170907764900b00a4df56a19fcmr617226ejc.13.1711533663779;
        Wed, 27 Mar 2024 03:01:03 -0700 (PDT)
Received: from torus.fritz.box ([2a02:810d:b83f:e400:16a0:2f96:e202:fd52])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090681c500b00a4a2bbee931sm3444249ejx.118.2024.03.27.03.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 03:01:03 -0700 (PDT)
From: David Voit <david.voit@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: David Voit <david.voit@gmail.com>
Subject: [PATCH v3 0/1] cifs-utils: CLDAP-Ping to find the correct site
Date: Wed, 27 Mar 2024 11:00:17 +0100
Message-ID: <20240327100018.63694-1-david.voit@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi All,

changes form v2:
  - rebased to next
  - ldap response on older AD-Servers is not case-sensitive - parse ldap
    response instead of memmem hack
  - off by one error in seperator extraction
  - socketaddr is now consructed in cldap_ping.c and no longer in
    resolve_host.c
  - IPv6 is - limited - tested. Just the cldap_ping path not the full
    integration, but this is the critical stuff anyway.

Feedback as always welcome :-)

Kind Regards
David

David Voit (1):
  Implement CLDAP Ping to find the closest site

 Makefile.am    |  15 ++-
 cldap_ping.c   | 344 +++++++++++++++++++++++++++++++++++++++++++++++++
 cldap_ping.h   |   9 ++
 mount.cifs.c   |   5 +-
 resolve_host.c | 259 ++++++++++++++++++++++++++++++++-----
 resolve_host.h |   6 +-
 6 files changed, 600 insertions(+), 38 deletions(-)
 create mode 100644 cldap_ping.c
 create mode 100644 cldap_ping.h

-- 
2.44.0

