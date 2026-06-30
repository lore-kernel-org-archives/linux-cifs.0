Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152EC3F4DEA
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 10:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816091; cv=none; b=RTCoDLlZKd4agvNQG4er0wYz26cxnDWt3uDlLhvaj93EGNB50dlUJXo+t9Bpl7MzrNLyuX8c6J02+ZU5dwRi3BcKge7j57/glIcUve6g0Vh9atb21eWx1pMZNvjEI5GmWpp1VXB89+4UPy41ciAXzKvT2Ad5GMjsUZ+sARYaZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816091; c=relaxed/simple;
	bh=10DN6ojITGasRWM7hkJb7ewW+faAUtQSNoLDqTJ9WXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ngt3R4uTxnRl3kAZ1TCISIe5prvDeGqt2BKBCRq58K8GcubDB8nBseqzqh1y/W6BcYYwXK/dE41OqgzlqdNyyIK2roF9nZWgUAqTQzi2zYSDgllT9iIlMMYeC+6pF0/xWrQSV4dBhzWINSEHvKghtCDSbAdsW1p454aseFq24Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SkPR21Fx; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SkPR21Fx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782816086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WYTThkQSuWz7Mn+qF1gPwNH7Y9lkzoDirOSgOvgnPoc=;
	b=SkPR21Fx5bivTCDDgwMZiNEAjYhOZz8Pnob1uuaNn82BmfQDLszctBdqAFl2kDFD4uzPRn
	i5kt9d128DlqKS0VREkew3sqs4jrwBSaUC7jK3r9EIZ6f7Vc5r92MhcsCnGyVPPmXX1aqN
	4H7SMk0ucTlvKs+jm2YtQbRK2+WfTCw=
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
Subject: [PATCH v5 0/4] smb/client: fix fallocate and allocation accounting
Date: Tue, 30 Jun 2026 18:40:06 +0800
Message-ID: <20260630104010.571140-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes in v5:

- Update patch 1 commit message to mention the generic/370 regression fix.
- Update patch 3 commit message to clarify the small EOF-extending mode 0
  fallocate case.
- Rework patch 4 to refresh AllocationSize after SetEOF instead of failing
  when AllocationSize does not grow, preserving compatibility with Samba
  "strict allocate = no" for requests such as "falloc 0 5M". This makes
  generic/496 and generic/701 pass on ksmbd.

- Drop the overlapping allocated ranges patch. It was a Sashiko review
  cleanup suggestion, not a fix for a reproducible Samba or ksmbd failure.

The following patches from v4 are dropped in v5:
  - smb/client: handle smb2_set_sparse() failure in EOF-extending fallocate
  - smb/client: handle smb2_set_sparse() failure in non-extending fallocate
  - smb/client: handle overlapping allocated ranges in fallocate

The following patches are already in upstream and are not resent:
  - smb/client: name the default fallocate mode
  - smb/client: preserve errors from smb2_set_sparse()
  - smb/client: do not account EOF extension as allocation

Link to v4:
https://lore.kernel.org/linux-cifs/20260626134719.158270-1-huiwen.he@linux.dev

Thanks,
Huiwen

Huiwen He (4):
  smb/client: refresh allocation size after duplicate extents
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small EOF-extending mode 0 fallocate ranges
  smb/client: refresh allocation after EOF-extending fallocate

 fs/smb/client/smb2ops.c   | 128 +++++++++++++++++++++++++++++++++++---
 fs/smb/client/smb2pdu.c   |  19 ++++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 fs/smb/server/smb2pdu.h   |   4 --
 5 files changed, 146 insertions(+), 13 deletions(-)

-- 
2.43.0

