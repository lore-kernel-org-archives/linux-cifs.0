Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA45424E4A8
	for <linux-cifs@vger.kernel.org>; Wed,  7 Jan 2026 04:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767760351; cv=none; b=TqeA58CteQ4aRN/bcYyRyZmhDWaBvoYghhfXrW7ALVBrVFs/EXgbqeFClQDyoa1efz5Ofj06cC+cQ81glpT04F2pjC445DPRWimb4CzMThFTKMVtAIUpH3aAh74u4p8DMVjcP+bW1McDFGoIW+lZyljff/V8VQUFKLwXIhgp7ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767760351; c=relaxed/simple;
	bh=5w5CTcVVbbaJC2yj02nN1pDvhLKNdyQFyoeknPzY7YA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uzIarbTfyYR6UWM8epL0qc78pZDenwUfDsiVkmTVAsApKQ4MaZTKwT8EYtWzVhAj4/66msmtV9yO3TBY2X9f5r2tLaqH1ClniTj0Ii/y7blyoWnPfN9MDW5TeXfnqFDcyvz6ynyITOkwh1W7hDnQNOaVeamSHJ+ZnclxBylXzO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BDCc4aFf; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BDCc4aFf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767760346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TOLWoTkhmHQy+CCMaHfhubZ2VWElU6jPGLPLhfnB1Bw=;
	b=BDCc4aFfDLxKh/pA1v6uOGDgsc5n78ECC384UFRUS4o501bi6wsACEz8odF/bqWuS/7acS
	kV9fW2SyMBIot3BjcDQn/ksrkoAU9G80gzhPj69iQz/JGNBTsvpdGgDGKQkjdNHJ0HkWqN
	UqCVsPe9I+0aTfYS9WhSr0ju/b114/o=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 0/1] smbinfo: add notify subcommand
Date: Wed,  7 Jan 2026 12:31:07 +0800
Message-ID: <20260107043109.1456095-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v2: https://lore.kernel.org/linux-cifs/20251221152216.363567-1-chenxiaosong.chenxiaosong@linux.dev/T/#m4ba6e208cdf29930d8962c806bf5a544451ecccc
v2->v3:
  - Remove parentheses around `if (pad_len >= 8)` for consistency with Python style
  - Close the file when the process exits

ChenXiaoSong (1):
  smbinfo: add notify subcommand

 smbinfo     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 80 insertions(+)

-- 
2.43.0

