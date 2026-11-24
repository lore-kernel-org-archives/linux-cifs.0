Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506985;
	b=PDtT1LHMRM3Boy3ux5d552Tk5OXtQkzyfpPZG/sidLWzJMJWibCQQ2pYLZngxrTIFu0F
	 z7QGx5yEFnokQWESDjlGepa+aScprW3sGYZoglvnrSe3WZ0BmS825zvtb0JxlbT+MSLJD
	 6808KYDroWGAOJdRrva4mpJKORu59tigO1dpM0ipxruSmKEFLxqTUpEzbgScKRLhM08mT
	 JxRyCssSLOdyDF85TQv3Uvu5uYyDH85xgjcZVStGwj37pFRch7U7wJi/2gazKlKTFgHgR
	 XIGCU+JiwtiSeTetbrKBnDnKjOsvG2Y5c3cntGhnFpzFlQyotGpmhh1PtWc+tSPaH5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506985;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=5jVfXHFI4uN42/XPVHbtGA1xJlWrRuag2TMAC5YzsKk=;
	b=gm01iake2HmdNYymm3mZn8YnpgHUL+HUVRviVU52HEpiwcLI17mKSv4Ofm6j0AVkjiOS
	 Hs/JtpoxdgbMEjCLCS70T0i4pt8g4vT1W6OtpQeYYOd0jN9BP31EkSjcEvazEZ1y+4koN
	 RO8YuZHCTR0R1CRqIAEOrigGS3ChWRwOut+VR+rhnFwcuudPy3VqaXczC1whXeiLEqj5a
	 A52X81pt0FVIylFIdIggB/hqGx6iwOGEvLEIkfEoO9U/GSusIQSaM8FrlvLjMVUcl4VHd
	 GFp7IC8b4WA8i8LilFHPVM1y/JSaBDqWRjbaTXhkqakHZCxIjm3hhMy1G1vZqF58/mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FfO+e3mZ;
	arc=none smtp.remote-ip=91.218.175.251
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5869F606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 07:56:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5869F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FfO+e3mZ
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MtjExfpFb4ueF8qQKqRvwqe4xqFdDPXux5cPG18fPHI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795506981; v=1; x=1796111781;
 b=FfO+e3mZji3u47yvehSdyZVD4bYw9JCSnGhAu6zik6clp17cLNwOiapPS0j4FOUgIKf3P2Wj
 +mWnA6Qsum0z0PsdUoc0cCNSrjbv+DXut7YE+M5mN2TlA2Tv4nq3JxL7fXfOgmMNeGFUqaO/JXC
 iDqZf550Xdb7ggVrgNoe1ZKI=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 35acbd65970d4ab9;
	Tue, 24 Nov 2026 07:56:20 +0000
X-Mizu-Trace-ID: 35acbd65970d4ab9
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: [PATCH 0/2] smb/server: fix byte order issues on big-endian systems
Date: Tue, 24 Nov 2026 15:56:10 +0800
Message-ID: <20261124075613.469257-1-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

ZhangGuoDong (2):
  smb/server: fix little-endian values in diagnostic messages
  smb/server: fix file name conversion on big-endian systems

 fs/smb/server/auth.c       |  2 +-
 fs/smb/server/oplock.c     | 12 ++++++----
 fs/smb/server/smb2pdu.c    | 47 ++++++++++++++++++++------------------
 fs/smb/server/smb_common.c |  2 +-
 fs/smb/server/smbacl.c     |  4 ++--
 fs/smb/server/unicode.c    |  4 ++--
 6 files changed, 38 insertions(+), 33 deletions(-)

-- 
2.55.0

