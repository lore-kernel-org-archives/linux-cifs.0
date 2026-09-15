Received: from mta0.migadu.com (out-234.mta0.migadu.com [91.218.175.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762D374A19
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454144; cv=none; b=QNtNDe0oo9AyPcZ4fjO6CGvTx/XqJ3UHOFbrt7sZz826bmpk55VQoEJSigOAp3J4k9ZdANBLZar0Z+Z/BJKi2/xIdA4azxR94cTDr5AQTrrlnt9exjNTSaYuNaZw2/dBh5aSTauWhZd3FjbkbtmPa7QyQaz7nLH6+9LJQy2Rq9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454144; c=relaxed/simple;
	bh=a7VOIcc4lLYREXxV8xDQc/7Zm1F240KjQG2S08kt0QE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oGQBXhVTkwtanGG09PSAsWDBGlMmgLDucJ2wMfExdg3VTZ1B95jKCFKBl5/mDq+cU60QFimOXjw4Uy9u6eOdbkdTvA5eOiy2ufhOHrdAuGLaULJ1RLXHUoXayLzz0GCeQinr8P7V1lZzQavv3lCM/rjW3jhAlIpD/hoQBmUu+lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=asSMYEO8; arc=none smtp.client-ip=91.218.175.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="asSMYEO8"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=a7VOIcc4lLYREXxV8xDQc/7Zm1F240KjQG2S08kt0QE=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454137; v=1; x=1790058937;
 b=asSMYEO8a6t5fvdxPkTvS7D+c+UOtL2x0QjHxCY8T5eMHpBlRgcerAahgG8TcyeBbDJl6Qsl
 sAxhAfYemVYlbSwPCgnuDy10WguNdt2N1rIqp4jSJHDth68Bk8l58bkoK5UQailSVNoaD9wJqkL
 ftlpTgySQNOm/cXuO3qWL15l2vuN0p8PDTYIgSQeYSC7GxYTPEqHe08LTdbQ4bcdoWH3Np6kksD
 +ix/72qfsH9JuEDdU7O1JT6GyzqCwI2lImnEF0gQ+A43uKyGU+7bn4VXe4A6fMPNjJO13yON2+y
 UCO+2ZGFEn2fBYbWt8YiKjEU946rySfTGUj/U3QUdGG3Q==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f3bd77833987931f;
	Tue, 15 Sep 2026 06:35:13 +0000
X-Mizu-Trace-ID: f3bd77833987931f
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	metze@samba.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH cifs-utils 0/2] smbinfo: add alternate and normalized name queries
Date: Tue, 15 Sep 2026 06:34:27 +0000
Message-ID: <20260915063429.110017-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

ChenXiaoSong (2):
  smbinfo: add filealternatenameinfo subcommand
  smbinfo: add filenormalizednameinfo subcommand

 bash-completion/smbinfo |  7 +++++--
 smbinfo                 | 36 ++++++++++++++++++++++++++++++++++++
 smbinfo.rst             |  4 ++++
 3 files changed, 45 insertions(+), 2 deletions(-)

-- 
2.55.0

