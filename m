Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697370;
	b=PQe3YS8dqFN6W0ytxsOTd/WHz/72x3VppDVwYxEIoJ92ePsf+u+H+A3Gng1lzOnR4AsN
	 WH95g7rm8/Oz4BI67p9cLAndO4jDpBXlmkRFQhDBUZ+ZHTx4Po8LsfKj3gg4umQwtN5EG
	 EHITmf+VwQ9s881XXUguVvPNUWMCtGjQ9nnHeK8LJJQ0sr4pEJAjo6Ag6UwSqJ+3yL3Gn
	 ecPpnty4xOvLlqcAJkp4ITPnjS2nmLX+W0guxB/SVG6V9bGETNHgFih42KTU17uDx6nBm
	 IZ1OGJ2HshT8hdv2KYvImKgBSnKTyq3wDV5MHqEUNecfjaWjv8gnytqMDYKmrOs9IKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697370;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uUsU7swoASs4qpVgMmxfbyL3WUNpRYGzgg7QYLya2UY=;
	b=Sf3jQYXZE7UPhr2TEBn04saa4wpQtJ2/BIoe7H4xy7YcEypLQc/wHkQiNg6cQpLg+6Ok
	 o7NrBO99vej1DUd5xS2tRLPBZrj/dnguEUs35Lw/qTKFpb+ONts4cnhLaQq8/iO6zuSGW
	 EDGHpyM8LIAaJuu8PwddLTSJ5V0XsOVppQsrpE03Yn8nDGG3o8cdxf8BaFTTx0WXIVeJ/
	 xDQlQVIItv9Q817IRbM/OYlqaxrupo0/NX+wkXJ28jT6GMNKjEMFOqQdvkO4xkccce+aH
	 s/2PGW26QbjfqFfiDdV1o1933MTXIAv5XHrW2XmCjjX3aIBOF5c4ZjTstiuuCrpAfWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dhZAImKV;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FDD606A335;
	Tue,  3 Nov 2026 09:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9FDD606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dhZAImKV
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793697360; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uUsU7swoASs4qpVgMmxfbyL3WUNpRYGzgg7QYLya2UY=;
	b=dhZAImKVsxZH/iFeiGP8oh3cEpXkJ+edZHSp8MSeXNFim18XRh4zzSes09YTCOlNN7P7g+Orahcd2nqL7NLTDv200JmLQOv2uEp0Tir+6s97cORI1PpRAeZq6cgpibdkUoEw9cjwqhDGIeX2aACindHX6aczPvnUNt0cyDU1lQE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XE2MA62_1793697359;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE2MA62_1793697359 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 17:15:59 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] smb: client: skip NULL channel in __cifs_put_smb_ses()
Date: Tue,  3 Nov 2026 17:15:58 +0800
Message-Id: <20261103091558.2342761-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
References: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
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

cifs_chan_skip_or_disable() clears a secondary channel's slot in the
session (ses->chans[chan_index].server = NULL) without lowering
chan_count when the server stops supporting multichannel.  When the
session is later released, __cifs_put_smb_ses() walks every slot up to
chan_count and calls cifs_put_tcp_session() on it, which dereferences
the server pointer immediately, so a slot left NULL by the skip path
makes the release crash with a NULL pointer dereference.

Clearing a slot without lowering chan_count is older than
cifs_chan_skip_or_disable(): cifs_chan_update_iface() could already
do the same since b54034a73baf9 ("cifs: during reconnect, update
interface if necessary"), and the release loop has been unguarded
since then.  12d1e301bdfd1 ("cifs: do not let cifs_chan_update_iface
deallocate channels") later removed that trigger, but the crash is
reachable through it on older kernels.

cifs_decrease_secondary_channels() already guards the same put with
if (server).  Add the same guard to the release loop so a skipped
channel slot is left alone.

Fixes: b54034a73baf9 ("cifs: during reconnect, update interface if necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/client/connect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e68fffb2ab2ea..6497b0d54fea7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2200,7 +2200,8 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 			kref_put(&ses->chans[i].iface->refcount, release_iface);
 			ses->chans[i].iface = NULL;
 		}
-		cifs_put_tcp_session(ses->chans[i].server, 0);
+		if (ses->chans[i].server)
+			cifs_put_tcp_session(ses->chans[i].server, 0);
 		ses->chans[i].server = NULL;
 	}
 
-- 
2.39.3

