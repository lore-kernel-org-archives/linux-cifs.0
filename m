Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A801EA84
	for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 07:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771054582; cv=none; b=G4YCZLSefW8CtN3wLhpu2Jlga6lOUTeQQxrX5bZTt+z+OhZENCoYvAktdz14mV9vczutkVeaOIldgZKarAkzNsHufsG9ZPn3zqyZFacnRcsaJwMVHS6k9peQw6YOLT/BdWWx8UZccOyWuRVyR9T/JnXwVwsr+7mpuMed9XSzi1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771054582; c=relaxed/simple;
	bh=yAyDF7041xCRkdU7A2gi3pItnVO5Nlp5whtT01z6aHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bP1UghK/aKfsa8n4CFdPGSbur/RIqbZuEIoPKuaVHv/fjE8fp5rtMd7k9oNwA2x1OyZBwA9TCvvPrA8I5yMgELAOjzoRK2sVN3/8h7CgAMEnS9LtDasABTYm10WqM12QrJWFrqQMfrEoi4A8VOHZvriQJ9oCgSF6X9tVrzLrrWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VTXQdvLQ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTXQdvLQ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-823210d1d8eso907038b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Feb 2026 23:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771054580; x=1771659380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=623MUkKdpDGzYJ0DWgvjVnUMWEgMAacUx71EgOL0fPE=;
        b=VTXQdvLQqBgNtE/+JYb8nBpx5lu/smrCF/re2l5XVA/XTtfke66dPFqzfUe9U4node
         kSoDvWDCKqyNBhbC8Gfyq+YgR3S5BmndkRVjNVBQVud32xsy/3CY1iuOvJzG1mYkFL+x
         L72KqVWv6PenNtTrdagMDQFWbFNLkQDrMsZ5C2Q8BqpxfRS2f66nclRCTvweRM3jZZBN
         dPWi8wpJlX9B441vRm5VeBmjs+8q5hD/ZOl8QDAb8b52/UJkUmafuIHSr17Eo8zACMGZ
         O43Ey26HdYZ8NrMuH46xMHveEkk2PseU9mcAzb0mhvv0W8i/eRPurWeUOYbbODDX3WOX
         2wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771054580; x=1771659380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=623MUkKdpDGzYJ0DWgvjVnUMWEgMAacUx71EgOL0fPE=;
        b=nVhWZa43hMDKg/LtByMF+y9LTqGe/f/GIbWA1T7kLH52znQ9ccRZbkrEO7vHsHVmY9
         kPcBWUrojjd8QGqNztaMQkv3mWN0mtxe350bA8jjBjXsZbHNv7ezq8e0bgq3QtUClQW+
         Hnq8Ac25fIeVpiI2ISx6F3Fpdz1UyNpyDyhdCAE5wbFdj2Nz7jxRBcjsXDoi2XGuxC/2
         9X1XZHIvgAAbSynt5sI9sd1aux2+zPbW7+TIh+CaBmiAdfRzZwafNSFBGNKSIK/RYmLz
         mKtWTcJnr4rQt+JPkgoTZmJsi2p5k+g049U7H5p2vZDTUsUhnSo8wF8vGyIUt7FASR1V
         TyvA==
X-Gm-Message-State: AOJu0YzpvODDzYZNMObEFb8FnhbHiyddig/KWxRmmlg29upXoRIqcWUR
	Ui/5VU1HNLuzNBSVmwvbbLxdRf9jBD+yY+AmU80Uag2vVdxYhatseqf7OrIcCQ==
X-Gm-Gg: AZuq6aISOCX+jfe7rZASLhPEmE/JJi6IOOR3WTSsy989SoNnmBkpcD0C3jIdnvS1MZ8
	yIEOnP85FUyreC5BPfg2q2/BkpeohO3Du/wj/zz3gP7QEcMWimgYtWq1QRwzm0uYfFDSO3aMy46
	NptFF9sOO+I9jIBcU2+1DURoGCEcJEKPRq9zqEKLgLMiYsd+9Gl8lry/uJ8CQZTtmS1QddhskNL
	BpM3LFz+N7efFJqhHO0GVNMaVeYoFf4WN0pIBMFBayi9wFOwPGzZVlVK6KVK1iTKTe+1STbAN8R
	ZkrXQErnV8mtUo0EnzIYkVDCgNmRAJerGglu577QlvpwgljqVIHtx70gvObRY0XGwlcru3bBoTV
	g+BhtSk60NXfEhApzIsb8bsQk00KBEaHWsGLQaBISmy/4gWeQyIld7qHlmdq95aJn7Qpo1dJcpg
	IhVzHXvyiflQEvv2RGY45QU/SBevs6TSLZsjPcMRGMXfdJ3nAkS/pj
X-Received: by 2002:a05:6a21:4d8d:b0:384:d0fc:f517 with SMTP id adf61e73a8af0-3948398f331mr1632017637.51.1771054580319;
        Fri, 13 Feb 2026 23:36:20 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.200])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e52fd0c81sm1234304a12.4.2026.02.13.23.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 23:36:19 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: remove unnecessary tracing after put tcon
Date: Sat, 14 Feb 2026 13:05:50 +0530
Message-ID: <20260214073604.183729-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

This code was recently changed from manually decrementing
tcon ref to using cifs_put_tcon. But even before that change
this tracing happened after decrementing the ref count, which
is wrong. With cifs_put_tcon, tracing already happens inside it.
So just removing the extra tracing here.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 2 --
 fs/smb/client/trace.h   | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 262df6d2c2c82..18177a9b2ba52 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3176,8 +3176,6 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	if (tcon && !tcon->ipc) {
 		/* ipc tcons are not refcounted */
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_dfs_refer);
-		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-				    netfs_trace_tcon_ref_dec_dfs_refer);
 	}
 	kfree(utf16_path);
 	kfree(dfs_req);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 191f02344dcdd..9228f95cae2bd 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -168,7 +168,6 @@
 	E_(cifs_trace_rw_credits_zero_in_flight,	"ZERO-IN-FLT")
 
 #define smb3_tcon_ref_traces					      \
-	EM(netfs_trace_tcon_ref_dec_dfs_refer,		"DEC DfsRef") \
 	EM(netfs_trace_tcon_ref_free,			"FRE       ") \
 	EM(netfs_trace_tcon_ref_free_fail,		"FRE Fail  ") \
 	EM(netfs_trace_tcon_ref_free_ipc,		"FRE Ipc   ") \
-- 
2.43.0

