Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311D6368D71
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 22:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930526; cv=none; b=SAI0b4GrLmIR+aMm/MtGE3VkK+Ef5OEdHKIAjY9XlhCDQwYZ1aVFNa2zTl/LHIRXOWR5ulsLBjEEEbMW0ahhijVGlbGEiqN2KbpnNSEeOA3rdTCWzhaUGJEAa8Bir0SHojo47WGpoeX8BEHBYveAaEgPIeP/enqQxeGlrpKICeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930526; c=relaxed/simple;
	bh=JWiHWP21ujH9+ON1tGuFZqs4+aZFO2Q03q1vst2ZXLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn0qsVxcZ1hVZr5+AL1JZJ5rrUPTkTPiEQDOTk5WDBzesWXUFpMpmUq4Gr41jEI81+u+ZC88hKlOcSL4LZY9XZzMNeIdAbmL5A0aXCCXR6BfJBR2C3CUpd4TKRSmwpn6mU0gNE1LNhGtDh06Eqs53NUPv8IanoRf5HO6caatuEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3y01cRb; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3y01cRb"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c0cea8883so9448121cf.1
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 15:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930524; x=1785535324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEUPPeynSykYqPjVdat7ZTHHzGO7Ihdz2GJ9ryCEnoI=;
        b=Z3y01cRbKNIIdWfjqvP2dsOCmieubkX+5eWwKJdH4lZvI4A4T/XrwayLnymENHMSOZ
         3xcrNL2Hk+nGQ8qyjUqKaeEqr+8ESSl6SJb4DU2f0o89QmjT50S8BI9QXzGZRCJdG6Jm
         YKkXDrwR6iVYn16VFdKwHIhs2P+omu/oopCMRzQ+5EJmsESWEfxfYJqqtUZLmQqO13Ul
         AOJIzUHrct64yhOlN7SmG2BIUXOkZhtM23ZxYHBBoL3eAU5snRVOyz8pz/y2xGRnyvB6
         U552fl4avere0fuGsiLOsWyhFgqLRd5RvN7gu2J2j8r2aKeyXrRbrPjV8hsDZKNhjpXV
         1ZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930524; x=1785535324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VEUPPeynSykYqPjVdat7ZTHHzGO7Ihdz2GJ9ryCEnoI=;
        b=atbqQzSRYTGt5JyD+huUXkrq8nSQRK9QohWBN0Pd4r+d3pVvbTWZFQ7Wus4DX5MaU2
         +T1Y8x+SqsIWIAtNgEGhwzo2X3/4GVNy8fU6YjIwjbYV9TlFJuzIaGXrAu5222pHAq3p
         qcshUEaPDV/I1ahLHKrmVR8uAK6OKT+39ZyvrL+XPtA0rSwZbSFLrWDXcVz3cr9cPmoz
         94i/RgOZjClAUGNzX3dDEwlC2kjihc4mj5muQLiBQBwAxv4YDsKFOTiAtjFSNK3Ojioa
         U5puoduFCOFW9ioF/aW7cKlk/bJxpPg0Qvy5GS9nj/HFRMW8KGDQAVjCEZxs0Xxi1mBN
         genA==
X-Forwarded-Encrypted: i=1; AHgh+RqMpQEMtQS+yQbNBABjAedLWPPkoG3maaK9GAC3QJBwKvP3NZgxyWeI3KxItEcakLFKAQZyAtRkk630@vger.kernel.org
X-Gm-Message-State: AOJu0YxvUXCkDmhG8u9bPqzwHgqgGRldd4R468bQP5zf7WymHL9/YOSk
	ip/mo1P8d95jEWbt3KFkrusd/U/kO/mimgkguBFHkU2e7UYKjPy9YduCj4SI5w==
X-Gm-Gg: AR+sD118u7CZUb317EFpRpJWrme8YR5f0aRTCXzlorC3nzsKFXCXw+vyoLZtkgLUhFt
	5uIJWtNw/ovoqMrj5+vVs7orFQStenGZPJSDTm293KUQmSohNH9SPIQlar4L5zFyU3mFzNBZQQb
	O/ktuYvLsnZkLLD4aTzd/AopisW4NeI3fDQfas1I+ag1hfdyeNMgwJ8I/PhOLn5YJLAt5Q6P56m
	ADP7Dz/denHWCLEThHmAAebLfULVmfanpwZ5EjoYo4h/j08futkiV0t3+ov19vWZPMUyZ9TAdks
	w+uwQGUeHgPeSLUsg2GXd04BD9J7J6e/S8p631mixhiAItF5D+yzG40riGIaA0gNyuVmYpu1oeZ
	bhcoImg1jRz0VkqGbCkjZwsC8+jH+0KDZ1u9xt5rs9QWF1i/C8d+GK/CVnldqvUqQO49PY0qWdQ
	xHsBLTjmJl4wtmBzU=
X-Received: by 2002:ac8:5d0e:0:b0:51a:8c86:bd2f with SMTP id d75a77b69052e-529a8fe3c0amr197691cf.36.1784930524068;
        Fri, 24 Jul 2026 15:02:04 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:c204:8bd0:9563:8b5f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a27f68f3sm8668631cf.9.2026.07.24.15.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:03 -0700 (PDT)
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
Subject: [PATCH v3 0/2] smb: client: fix dangling pointer in DFS target hints
Date: Fri, 24 Jul 2026 15:01:44 -0700
Message-ID: <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
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

v2 -> v3:
 - Resent series with proper thread structure and subject headers.

v1 -> v2:
 - Addressed automated review by Sashiko:
   https://sashiko.dev/#/patchset/20260724023539.1596955-1-fredric.cover.lkernel%40gmail.com
 - Split into a 2-patch series to harden readers against NULL and
   ERR_PTR target hints.

Fredric Cover (2):
  smb: client: harden DFS cache against invalid target hints
  smb: client: clear ce->tgthint in free_tgts()

 fs/smb/client/dfs_cache.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

-- 
2.53.0

