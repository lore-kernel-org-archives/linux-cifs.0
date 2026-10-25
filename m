Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792919262;
	b=nNYbEA5ivzI+ct1zJjtAqrtdBpKe1YPEWbRAmMKmx6B9xbypk+VyXBHSalZnHU05TYaf
	 sYYK/5jbM7G57mIYNV/JI2WpazERuxLJpUU2lIp5BX8iR9AteL5rZtc+LW+qkrcu0epui
	 G+SHS8EWV/dTGzeFRnCv51UQXnpmNoLXu9PG8d+P05/dDgWEkiGrFOD5QjyUtMaGZVMqK
	 VbDG7/mdU0wzxExvB+qTKIG7wNF/vNFRQkU72TPG8aSEIQyGh6IEGmhDawfjSHaXdEEjv
	 7pf5eiLpTF6pPefDUE4eEmDFilrXQ0uciI+KmJ7fNll1lveYz+FS5ia06OxpeDCWEsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792919262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/dIYdqOLAkHeO2RCiPKPFUB8jMZrrEYZH4Bk6Bmq0Tw=;
	b=pdXu2u9riTo0N+G+9OnNhK+93POhcr992UPQAU/9E9ramb4paJeQQUsdJZD3xfIDWXHc
	 /+AMWBRkJ3wE+Ey+TPyucoWyXQipA3lwWmjwCxN40/BZoq8tuY0eEDaR4pcXgMpTSmoAq
	 HkYyggb/zsBUH+klnNzekFhmwK721jl6D7R5GBbn012vHZLBMJea98C+4sM50B66TxmbE
	 Aqp/6KrzG0JrgO3b2mAn+/eS2SyGps5T90ozgg+HybHbPiunjd0rZ7MUFVdkNhKfPCUCD
	 udcMqY73sMymwnDFK8GnH8EKM3RWqSvSpVYqv2M3Lwq33MSPT1MoUJRww8rFPSONSsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=reU3kH8T;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B9606A31B
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 09:07:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 667B9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=reU3kH8T
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso4115336eec.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 02:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792919260; x=1793524060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/dIYdqOLAkHeO2RCiPKPFUB8jMZrrEYZH4Bk6Bmq0Tw=;
        b=reU3kH8Tibh8CvDEuQthjv2+W4rRV+cLOaFvn/VF1gieSmyp4esJxPUvsZhnBEpvhh
         ho/5xM8taJpiW+v7hs8vAt72EMkx/Kv/zFicXEqFAYKNUaPCUrc4mKRUOOlIzq3O8edu
         /8Jpr4WbPIbbKw0RDSGgq5TDjk/R0ExscsiaXmbg6NKw8uE8zxqig8dIXU5lMNYk6raf
         25dz+yC4eEJ6U5TyCG2wlrJGrf4Rd26erPHdGWxOT+AZMTijYMUzIx67NMgIPUqLniNG
         gUDUfnRMnPRqRhmYdEQn4vXYk06hpclzEBdbpxWbyaXirXOBHyD3VZX+zBaDjX4MkVaK
         FQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792919260; x=1793524060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/dIYdqOLAkHeO2RCiPKPFUB8jMZrrEYZH4Bk6Bmq0Tw=;
        b=yPwdeJ2gLbEqW3OPkg6/94efSqsVulUbXe5Ioy5ZpedbOMG2mzcZ1iadMQABul4Pft
         IQ1gzaGVZb4epJ0kp2lXRhHYpQFdWkgll+NVv5DneIgdbTKEilv5C8aV5nI038X3N6VX
         USKQS4AYUy2QpeSkjQZWsvwCxaoqz3851MLtv3LNY8xYtaDo75yI993a4PcNi5ZFT2wW
         d4bvdX2gxfeWnWKTgvhJbWGfQz7WsL0nNDKJw0828R3JZO5ZEaggGNTjojTQLKmKT+32
         g/968VUIIYaf7RJBTESBRFRoT7YBXMl85r1QK76LQNFuK8zLD2xw6ymb5bhoHySG09sr
         1SrQ==
X-Gm-Message-State: AFq9FYL/tMIDsOYjkoLtow/I+/FWsD4UPGd2zNgZ35byBegXL289usnL
	ZNKva01+c2SJAlXgaHhCR7MADDEH2L0uFToSvfInbmnTBUC8cHdsaWl4
X-Gm-Gg: AYBFou1AOzHNLoD01vlHG6ysbRTINw6HV0c0DI2oJLdvl4UCLfQ2rke7i9POFwH431E
	JEK7SCUNeKghbOzOSyd2TWHgwYxr7Yfs5e07qC73mKxqqfJ1WdtW4+M0mrRSv7MXjsIV08+lR9B
	GSy2uxNskVPQWzmKbXD4t4hgkh5qgQrr4hFvI5p17oxAaDR7rCriIL5SHdAgyZVS5iwe0hsj0vI
	9mZOZQENzf/tJuFnLMghlFhAAcIGbMn+8xwtEd0jjODSMu3ggEr1WURCRAe6es3ZALrJlYeZF4C
	DWyRtAaybsACXc94Z4YVVGE41DYX5Evm42Wl3abHR+6Zs+Hb1TVMsZUurKaeBtX39hzP1C4Go4n
	Qp6PoHBdidgNG3Y+43wpMxE7OUHWqCRQ6vwbyErQ76xtdgDdIwBnw4Lcwao8ZThS8nKmo4TsZe/
	lGRsPq/DQYM4hQKFw/lHF9Ht+LJ827YQDIUj7UQ0PjlcXtuPrSc6xh9vhDRokJeQuKYBxeGG1wS
	ATH2iJesLyeiGhm8jbBJFeubeSyD+dNsPzOgB2a4T5ItUx/p+8rF8kuy6K0RAfXLC5Ulr1pJJaB
	0mvfqTQaFP+0u0pRmIoipFice4U0
X-Received: by 2002:a05:693c:69d0:b0:369:f9b6:f471 with SMTP id 5a478bee46e88-369f9b70b8emr1360895eec.24.1792919260380;
        Sun, 25 Oct 2026 02:07:40 -0700 (PDT)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ec4d73sm19815122eec.22.2026.10.25.02.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 02:07:39 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Xiang Mei <xmei5@asu.edu>,
	stable@vger.kernel.org,
	co+24c7c12d69e63c6d@bugs.sh
Subject: [PATCH] smb: client: stop processing a read response after a receive error
Date: Sun, 25 Oct 2026 02:07:30 -0700
Message-ID: <20261025090730.2893106-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
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

cifs_read_iter_from_socket() may call cifs_reconnect() before returning an
error.  The reconnect path aborts pending mids and invokes their callbacks.
The callback can then release the cifs_io_subrequest containing rdata.

cifs_readv_receive() nevertheless continues after a negative return and may
dereference rdata in cifs_readv_discard().  KASAN reports the resulting
UAF:

  BUG: KASAN: slab-use-after-free in cifs_readv_receive
  Read of size 4 by task cifsd
  cifs_readv_receive (fs/smb/client/transport.c:1284)
  cifs_demultiplex_thread (fs/smb/client/connect.c:1355)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)

  Freed by task 148:
  netfs_put_subrequest (fs/netfs/objects.c:267)
  netfs_read_collection (fs/netfs/read_collect.c:460)
  netfs_wait_for_in_progress (fs/netfs/misc.c:462)

Return the socket error immediately, as this path did before the iterator
conversion.  This also avoids adding a negative length to total_read.

Cc: stable@vger.kernel.org
Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Reported-by: <co+24c7c12d69e63c6d@bugs.sh>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/smb/client/transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index e266859818a441..b7c0ec5d956551 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1272,6 +1272,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 #endif
 		length = cifs_read_iter_from_socket(server, &rdata->subreq.io_iter,
 						    data_len);
+	if (length < 0)
+		return length;
 	if (length > 0)
 		rdata->got_bytes += length;
 	server->total_read += length;
-- 
2.56.0

