Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF1937DAB1
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454843; cv=none; b=SvmIcuqusm6mpB5H8Y/ZUDhPFkZTWw7VtEc59eyN+XHTz/vDdWb/tide5To4h84au6eZ7AKZ2Kj3e87+uKYHHpwLeES0NI1cBUjj+L4cHvUhlSc+VuB5VRPONJ4w7Dtor8PBQ49cBS9S9wxdY9yRffUI4kqz7Q3TYWW0HWa2BkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454843; c=relaxed/simple;
	bh=VNnMBuzCC1kTpBYYYKQWAKfkB4E2okFQErHjaTr0M48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bQGCKgeziYysrH2Jl3aN5dbixQcPtHMaRd7xpz0XMVnXo0j7+jpk0klD51BXJfttpU37NvV40MfL72rO+tjzvheZcBeDGmz8stviY3VK9WCMWi9EBjB6jcODFCZISDoUYbnfif9+Wy84NHBNe9gfnu14zCtZWtDq62fMa+HiMIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NMAoQOWa; arc=none smtp.client-ip=91.218.175.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NMAoQOWa"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VNnMBuzCC1kTpBYYYKQWAKfkB4E2okFQErHjaTr0M48=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454838; v=1; x=1790059638;
 b=NMAoQOWai7MclPlUM04MbcBpQER2Am5xi7bFQHitUyPoupqv4mQDKwT2PpOCgPz2bBksEc4o
 TkfZTGfJSgFkW765eqc+aqneJbOIsrrOqPNaSeQJVf8SbkgVcfCggnfK7GGI5vzokSr4hcgqRD6
 G3m8TVJ9CYyYPMYx42GH5wfKhXLBVgMDe4rmqh/k1g/UsC7VigMac+DPw5ojiqM1SPhhJ8VOTyv
 UvwWlkZl46qo9IHyt/nTkw3iH6kV4/X3H/etRx54AakAf1MCS7N4KssYrRmOHmWpTxFqIGwHs4w
 hKo715bxVookYPX4i4+AJvS3XqaFKR2+jaawnYkMpMUDw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5a3f29c76c78c8a3;
	Tue, 15 Sep 2026 06:47:08 +0000
X-Mizu-Trace-ID: 5a3f29c76c78c8a3
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/3] smb/server: fix some bugs in file name information handling
Date: Tue, 15 Sep 2026 06:46:54 +0000
Message-ID: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

ChenXiaoSong (3):
  smb/server: fix trailing period in generated short names
  smb/server: align partial normalized name responses to UTF-16
  smb/server: rename smb2_file_alt_name_info to smb2_file_name_info

 fs/smb/server/smb2pdu.c    | 21 +++++++++++----------
 fs/smb/server/smb2pdu.h    |  6 ++----
 fs/smb/server/smb_common.c |  4 +---
 3 files changed, 14 insertions(+), 17 deletions(-)

-- 
2.55.0

