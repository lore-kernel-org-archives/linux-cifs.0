Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B854B3F789C
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481659; cv=none; b=uW/3i9PaFiUb61v/1IamiZ3R+/2shZuQ1xw3FZdcq1FQ1X72BCCSXZdLjNVw8e/kwJihLbN7RflV3jy7S1QJQUgFkGW842uirh+/ayLXxmljPrKo/hpQuicH+8PzTxVJjWB9C5sCq4z/4TrSjW1ngJnqRIg9QlXgF5/4YX2qnD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481659; c=relaxed/simple;
	bh=xOd6XGG0GSuhtT3QA0Q0pb5X7+QHNMDmOY2ZXT3JGA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKxB73k/pG3OkoRPcDz0RK4SsoIrPMiKtwnXf7LQvNwNkNR4tK4J+lxh06NI5zpaDW/XXRhbFK+WSwhF/MjZJ0WpNproDfJrGNfG8vQRI1AMRH7vic7cD2OmVn15G++ypdh8IwGHyaJBiewg0menjuUtomSSuS7AUE+KsIiQzas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kDR3B0cw; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kDR3B0cw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GOXJq5ca2JtccaGFTmNf9vWsMI+n/MB4tpcE472MO7o=;
	b=kDR3B0cwUSYLWEAANg6eFsDTjG5txD71w6idq8KX0otqSEf96W9+TsuSU6s9K8N85d51Us
	7ylsPLFQedLeHsT12u3r/1xaA9yd+wJ9mm4+ME+jRLtC00oFFNiUY2J5wuoPWH932VMz8j
	t+N6Fw9a7Q8KSS3nX7V3mAjRRnAGFiY=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 0/7] smb/client: fix fallocate and allocation accounting
Date: Fri, 26 Jun 2026 21:47:12 +0800
Message-ID: <20260626134719.158270-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes in v4:

- Add new patch 1 to refresh i_blocks after successful duplicate-extents.
  This fixes stale st_blocks after reflink and avoids the generic/370
  swapon hole-check regression.

The following patches from v2 have already been merged into cifs-2.6.git for-next:
  - smb/client: do not account EOF extension as allocation
  - smb/client: preserve errors from smb2_set_sparse()
  - smb/client: name the default fallocate mode

Link to v3:
https://lore.kernel.org/linux-cifs/20260625160154.104450-1-huiwen.he@linux.dev

Link to v2:
https://lore.kernel.org/linux-cifs/20260624021550.1548952-1-huiwen.he@linux.dev

Thanks,
Huiwen

Huiwen He (7):
  smb/client: refresh allocation size after duplicate extents
  smb/client: handle smb2_set_sparse() failure in EOF-extending
    fallocate
  smb/client: handle smb2_set_sparse() failure in non-extending
    fallocate
  smb/client: handle overlapping allocated ranges in fallocate
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small mode 0 fallocate ranges at or past EOF
  smb/client: verify allocation after EOF-extending fallocate

 fs/smb/client/smb2ops.c   | 169 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c   |  19 +++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 4 files changed, 175 insertions(+), 21 deletions(-)

-- 
2.43.0

