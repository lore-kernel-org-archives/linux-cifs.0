Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795507179;
	b=LeJgHrkW/g2uBA+7ZKXmP+skoHKqwZ2YNoBMzBWky9KL0dgJDwYewlA5TUPlVmi3O+9w
	 cqLnRrboKKpE1ugwvuS0nH2xAkVZIjjrBqlGSlmXdyb1E24+uWaULIw5yjo+fz8fHlEV8
	 Sw1NTbahR546GwOmFJCUfmk9iHlwpB3fPFYbBa9duZqSYKTyYNaiyyXsuBkWRdQLQlXQq
	 YmgGpIYu/vq5iu4HJUV+2WC0uQefp7oxu0Pjp7MLfT5Wjyn0YW5NdBZyzSs+2jAnPXQlw
	 Xy7VlNXelg8xxNiL8gWIuygfVKeqEZKLqgKjpAwC0dpcWomrWp0kiguUEFlL6GxkvDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795507179;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=IRPjuTtVTaict1Y9QSgd0o6Pml3CQHOV3SqjbcaTkw4=;
	b=uLn7UvxVIEwdEX+FpHDI4PmoYnXz2Zd41ExYkw6t2bHAcFn7A5fKqKlnxbiY8VR3GGCW
	 gfQs+nz1/L0DSi4zbp/10wCq+u0URaftsXprDF8VR8sb+vrYNp6bksPHBpJ4TAcG0krgy
	 rdbEpOTVTx1gpmoBFds5yv6dm8T9skuHTHxrlCCxpAg4mjzMRL0VujW8NK66RUU6VfP44
	 AHURwMAjDMptQg/hY6Aoc7H6hH2jY7lrxm/fHwP7edMHpF9gLUUhIzYNM+FVkWYIKZ7u2
	 1ozi3SfJ/C6B5+bCbEh6JDw8xBfKd8Kt8wuoGIo3BFaVuGhGABB3LyRI+bKvn5Ivc9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sKA+yxj1;
	arc=none smtp.remote-ip=91.218.175.72
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CAB606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 07:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7CAB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sKA+yxj1
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hmoM+Bf9e40nQuIgPFA5Z/DC2rZNjJ9Er5pQ2HUJYp4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795507176; v=1; x=1796111976;
 b=sKA+yxj1ejI3XCdx0WLkvHpkEK8+0wsfZNlgt6huPJlR3EAXmU20npa6sM+OKrLG3bTyPxUm
 8NryD/Wry2dVq/HRmpsLcrR2CADVuNpLeNoXv2k5lO2ZCI34njS6GGjuJjSXd1Z6arywksHzrUI
 SflC2RRdPbzu3bvr+VAjpiQ0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d5ad99790e34285e;
	Tue, 24 Nov 2026 07:59:36 +0000
X-Mizu-Trace-ID: d5ad99790e34285e
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: [PATCH 0/2] smb/client: fix byte order issues on big-endian systems
Date: Tue, 24 Nov 2026 15:59:25 +0800
Message-ID: <20261124075927.469470-1-zhang.guodong@linux.dev>
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
  smb/client: fix little-endian values in diagnostic messages
  smb/client: fix file name conversion on big-endian systems

 fs/smb/client/cifs_unicode.c  | 6 +++---
 fs/smb/client/cifsacl.c       | 3 ++-
 fs/smb/client/sess.c          | 2 +-
 fs/smb/client/smb1debug.c     | 5 +++--
 fs/smb/client/smb1misc.c      | 4 ++--
 fs/smb/client/smb2ops.c       | 5 +++--
 fs/smb/client/smb2pdu.c       | 4 ++--
 fs/smb/client/smb2transport.c | 6 +++---
 fs/smb/client/transport.c     | 2 +-
 9 files changed, 20 insertions(+), 17 deletions(-)

-- 
2.55.0

