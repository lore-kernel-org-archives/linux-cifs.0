Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE5F468C0C
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 10:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345753; cv=none; b=MMrHIU4NBaCRyJ+hb/SQPrfJgvCvS2dhJyPy13lH0xpthzvOlp48I4eMNROF/58ntqZMFPGbh2AkASZjcYzJIdyZXI/athiXq/OcwZ/veGka7lq27EP4KYm45S4ZspRn5TTPeerVyeIPcOkgLlnH2qfz3CME/TO/Bu75AnLehLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345753; c=relaxed/simple;
	bh=w4j3YVOqQ0sbvpZmpBwHZ1MjIB5w1xBXD6/408k8atU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cIS2zgodm7RT5kQieLm2iqjryKcKehoxbtlm8ThNdwD+7xcV0Pt/Zvrv4j7Zp833+jbc7D03S1sYK+wSX6cYy97VRtxUqm6gJh8ugE3Xe2uoX1z/36m3RCiQ2nnXGChWGfxLyXQbbJQfPcGO2xPIxDecjLT1GONVVAVsAk9riW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=FCFMbbYy; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="FCFMbbYy"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-482f2ee53e7so573427f8f.1
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 03:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1788345746; x=1788950546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kAoyOMd0a10m0Je9ACcvSw2EV5eeuxpNLlrsDe1MN+k=;
        b=FCFMbbYyoee8PKKckeL2Lo+07HxNep/T+XJHJNYp7CMyOxImPtg7cL1lKpwI+QgIzC
         FipkJiX4FC1ro/JOsODSl/jUrzg7CVwiG1tfSXUswg0kxfRDytFU/UHBMCFk4r/IZN8D
         JegreORvdDVvWB4X18DNY+zAlPu2UuEgSSQcRvQeaWl71tLUV4Imz7p3MkyEBEzJzV+b
         kygprJ1b8fnNG5hPdTHkhm4c+GKsZHX6P6g/HkwdXM5sBZnPc6Qo2pp0A1ef+L/mM0ZR
         6I9TRLZohfzimNW8uj6PdbpksqGRa/WMlS7oWU+wsC2cozC9C1UJpY7wW2yo79aYiuJ6
         ylBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345746; x=1788950546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kAoyOMd0a10m0Je9ACcvSw2EV5eeuxpNLlrsDe1MN+k=;
        b=H0GHUTWxlPXUJ/UyBCrJeLY9NCacTP0226bmiIJ1IgD5tQGe2G1HAra9PWwYfD38ta
         +86vjP72KsZkI7oapbvk79DqFo0EZOyOOQNURQmoYmi1bLeq9AIcnprCydVb3gUeFvXa
         MfxVxYMzj/dxFwfZAHQ0UFobibZWY8s3cKS2vinE3zCoA8+iGn/2ExvwS5MSaPWIMFs1
         f38M57l99obA0Oec5AvIY61CfV0esS+n5GNezRlVj62y7u34HXYzxCT/Iq3Q52QbURrT
         /G95bEOovuLvDhME/zBzt+ObZgs/pmCP1LiIcEYTeZygOHCe1Na6OLv4twBrHA97jx72
         8JDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQ5CtS+4o3AQc1dBdRGaF0V3BJdCpOY77XUCzialZSc9hH5dqAwrI6YYCFPqybZo9v3HazhRbTna0U@vger.kernel.org
X-Gm-Message-State: AFuF++kzFbfxFD5di5Eiy0feH7tdHt9c+aJKXzMS0wHbYKIjLgpLBh1r
	qYAAhxrb42EKG4/nX/Bvnhz++ZxldeOkibQq/ixuBEJ0eVf5JKiINEIPeWC+z3d+Txi/
X-Gm-Gg: AYBFou0Jlzs/n94Ggr3zhl8ksCBFLIEBWai41y3qlt18Py/Z+fNYx61WIIS9h/HoXO/
	vtQwlTjgFTxH5JXS525GacHqTIMN02KH9A1wu4D7osnQKPjrmq7QCYvTkUoJbYdT60nDgHUdk5a
	aFV54nnpEZCMDi336M0Yvak4Ky8NNJ7U+B1TSI0vJ9ui06XRzF/hen+wIwP6G8Fip+Z1A6GihRi
	Jux1f/gMxJKTMa4+oXw2iHw6Vr/96Mum+b5z+u3UlZlvWiDU7sfjrMlRC1ds97lUFvlJRzRdefy
	3NBAgMGIhR1KJwG0niGC6MPZhsH/1BFsKSGfIut9nqQfqdnycZb53DE2qKa2hv1S+gWIJdQAJsL
	CJ8roxjI8FsE3nkW0YAfMHKg3TKye8nMc5Vw1iYsOmJIjSM76zMgPBQOSO47/7KLC8KOmtaH4ei
	wooxzEDQ7O79q0WUMR/M9SLlTQ5FvjSbSJq/5W09hqttHMB8PrKv7w9a+1XaQMrzn3n/9EHv2+q
	gsN74nhvwn2Yn4MiQ==
X-Received: by 2002:a05:6000:4901:b0:484:479f:4152 with SMTP id ffacd0b85a97d-484914bf9a2mr7891661f8f.23.1788345745792;
        Wed, 02 Sep 2026 03:42:25 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-484492ce5e5sm5197521f8f.36.2026.09.02.03.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 03:42:25 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] smb: client: fix out-of-bounds reads in CIFSSMBRead()
Date: Wed,  2 Sep 2026 11:42:05 +0100
Message-Id: <20260902104207.1820332-1-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CIFSSMBRead() parses the server's READ_RSP without validating either
the length of the response or the DataOffset it carries. A malicious
or compromised SMB1 server can exploit either to read past the end of
the receive buffer, leaking adjacent kernel heap into the caller's
read buffer or oopsing on unmapped memory. SMB1 is not negotiated by
default; reaching this code requires an explicit vers=1.0 mount.

Patch 1 rejects responses too short to contain a whole READ_RSP, so
the header fields can be dereferenced safely. Patch 2 ejects a
DataOffset/DataLength pair that falls outside the received response.

Both patches use smb_EIO2(), introduced in v6.19, so they do not apply
to older stable trees as-is. Anyone who wants them in an older tree
only needs to return plain -EIO in place of smb_EIO2().

v3:
 - split into two patches; validate the minimum response size before
   dereferencing the READ_RSP header fields (Paulo Alcantara)
 - print data_length with %u and add __func__ to cifs_dbg() calls
   (Paulo Alcantara)
 - rebased on current upstream
 - v2: https://lore.kernel.org/linux-cifs/20260831125045.479576-1-diego@bynar.io/

v2:
 - make data_length unsigned, as suggested by Namjae Jeon
 - v1: https://lore.kernel.org/linux-cifs/20260828150203.1419003-1-diego@bynar.io/

Diego Oliva (2):
  smb: client: reject short READ responses in CIFSSMBRead()
  smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()

 fs/smb/client/cifssmb.c | 25 ++++++++++++++++++++-----
 fs/smb/client/trace.h   |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)


base-commit: 89a312991dc6e638a36adc43ccb91dbc25504c04
-- 
2.39.5

