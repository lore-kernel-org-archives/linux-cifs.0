Received: from mail-dy2-f22.google.com (mail-dy2-f22.google.com [74.125.229.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4E56B871
	for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2026 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098920; cv=none; b=MXB7McDEVdyBamMaNEMxmKTg8OPDKds4kkcDBLv30xoBIdQaD9inT5dYUNy9J6AF5hi8fY6/61WKJuV4rhG7J/dxiPVVfTcutQUK/1XNhHytj+gKB8wZZPuOV6F2gluH8Wx62+v49zQdBCdCvXizELABnrxi6zEVMQpNVx4u+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098920; c=relaxed/simple;
	bh=YbQWCoLbJ2TBrHcsvoDcg8EEVw/4pDqVEBIsrTk1cBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u9IDouFVer9RnUjg+awZNGa5GiEviR0BRTj2ggXiFLGQAETk5aXJBpE8S5x3Uho8WurkoT9KhyXWgaPBBtVksgBYClTaXsPvucOx3nUZwnnHpUThgCpv/+lsVoIScPOVYonEzd0ueMIQACXiBm8hUykU2n9NVtKMtJRnzKNOssE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KrUvrx3m; arc=none smtp.client-ip=74.125.229.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KrUvrx3m"
Received: by mail-dy2-f22.google.com with SMTP id 5a478bee46e88-33bf5a1c4d9so58916eec.3
        for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2026 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790098918; x=1790703718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KpXDs9omfosdMoHljEwPZp4DRs9tPWpEJWp4t5OaeUo=;
        b=KrUvrx3mS1t0oBKVtGl64s3X1+iAfRpO3LCWQRrQFc4X+Bi3kaHAsKBDPt55UGQ+oL
         cw+B9+OK22Tzy7U1CHVToemknfM9l+PhNfohtBcWFy2q/vGCB1a01jNLWB1Vru/AMvyM
         ZZ1KWgJw4tt07YCyBoVIneSEem7E+DJxGPjPwId69pXZzBA/S1YLRiSv4kwYwjlqYPzo
         oG1+Wqto6gvEZNf8cdj5pyrGuMApMawrioYpweEEa+eCENFJz4hwyrM6BnXgHiCdKs9S
         xslRKD8QXeos0G2IjD5d1DdEkQ9VAqtRy6w9Uaw8dLHBXTfK2mwlQAbkFxkx9L45QoLy
         i5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098918; x=1790703718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KpXDs9omfosdMoHljEwPZp4DRs9tPWpEJWp4t5OaeUo=;
        b=SHOQj1cwRRyBJPCTIFmr+ozXMw5OYNZ9caE063roRUrLE8lTEVJdMGJwDxxLBLBb00
         RhDISCci2sBFzKbz/wEz1tPJF9Iw7LjaJ/lpk5NI8riNwRPUgvey68Nuw9iQ5xUaYwam
         2JkBRyCY/tdGWtooXWJ8uwf9CnhS4zMuazN9wYslmTV0Bl9e3aYl8rsy8wTXNaywuZ3A
         rkHfZlqSjYbN+Kvx+nvpufw/q0dEUA+Rh+KjA/XNotACSJRe49PEm+Tn4s2uiQ4DSssW
         jLsGSd4BQ2/BhgHyHccpyMuYqNYLs/QBh4/0tSOBccZZRE0D8bCaSMEdWBAQAx6WiXaB
         newA==
X-Forwarded-Encrypted: i=1; AKwUvBwYjuHIAHlCzD1aE2siIQ+K7m/ETKzA+llrVh9DUzLSQLbZmdUFHulDuq4i09cJ4wogK5rBoTSc58pn@vger.kernel.org
X-Gm-Message-State: AFuF++kSi+/pV81MIAB4AbwDn4maMj7r0UqSsgZdFxQaXvTaQ7vYnw4/
	aDG72ksi7lAOOtkzthiHQ0jPHw/RK5SvmW7H+r2grSH/sz02CVQ0s3BZ
X-Gm-Gg: AYBFou2czQ4jwZD4LB8k2ysN3RIis+kFQ18OVZu4wAOYt6OkD58GEWT2DRtcWg81tmv
	Hpw/l27UcC4RroqceEo3rLtZmmhKW9Ha40qtH5rQbwssHZMbXAhVxdYOCvcjZFN6cT26/ntL6J2
	IkGkT9ypdlOAipMNAh5jOJ/XygSfN+BGhM9GNYsmecxfchnHGe8fAHr8Hqfz+CpovTw/BGOm+lL
	uLfG3SRH8Fh0ID98D29H5MRxYIzSJl+nZyv+tfeKQQ7vw/bmho6NMHYQh6ajwGnXY/mpn1ZFNrp
	z4lnjkSJnRNhl1pdDRECWwfkPKNBoIdNhE9GoLqcahSJ4YdV607ukvkCgjer/4ct6cJhOqyOazN
	CoMeuZHyEPfvpEPb4BbFLx9P1ukcOGfhnVEjl2Dsy6AQLoRB1twYZTlxDxrV0RDwqtX4d3CK2Ub
	AJSLoSrD3YSrTmorL7o2GFngNofmhxNBXh8sgv9Tl493PtIZQ+ummJdIULt5gPBLgiWDbOgz3Lb
	I71kA9P8b6huHZUN3T5aw==
X-Received: by 2002:a05:7022:29c:10b0:143:26ee:4203 with SMTP id a92af1059eb24-144f91547bamr91844c88.30.1790098917567;
        Tue, 22 Sep 2026 10:41:57 -0700 (PDT)
Received: from FredPC ([2600:382:8d06:9b8b:d94d:e185:fcc4:f1c4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f9040420sm110074c88.15.2026.09.22.10.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:41:57 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: use GFP_KERNEL in get_targets()
Date: Tue, 22 Sep 2026 10:37:59 -0700
Message-ID: <20260922173759.67445-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, get_targets() uses GFP_ATOMIC to allocate the cache target
iterator and to duplicate t->name. The callers of get_targets() are
in a sleepable context; therefore, switch to GFP_KERNEL to reduce
risk of failure and reduce pressure on emergency pools in low-memory
scenarios.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index f6c4259479c5..f727fb261331 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -798,13 +798,13 @@ static int get_targets(struct cache_entry *ce, struct dfs_cache_tgt_list *tl)
 	INIT_LIST_HEAD(head);
 
 	list_for_each_entry(t, &ce->tlist, list) {
-		it = kzalloc_obj(*it, GFP_ATOMIC);
+		it = kzalloc_obj(*it, GFP_KERNEL);
 		if (!it) {
 			rc = -ENOMEM;
 			goto err_free_it;
 		}
 
-		it->it_name = kstrdup(t->name, GFP_ATOMIC);
+		it->it_name = kstrdup(t->name, GFP_KERNEL);
 		if (!it->it_name) {
 			kfree(it);
 			rc = -ENOMEM;
-- 
2.53.0

