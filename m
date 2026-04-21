Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202F382367
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776753614; cv=none; b=r6hKvZ/eQRIyGy7S3h0YsmNOf6CpQyZFca43YW9+kkye1nRNxLVmsAdKBAT7ippBRY1eECC52qDo2CEi7O1uU4k36zbeEsP2+nyeFR5xoFjMjfEd3g/M3yQKOn560JLw8HDQ7WV2jyFnNEjCYGGEWMxEMX6d4mz0v+Zusp/AUBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776753614; c=relaxed/simple;
	bh=0HL5ZEFnxyEbq7XV4UUOrpynXy9ORh0SIFW4oCxfPLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr2C7NL/yaLy/VmaJC1yp33ZsK6fIhhE7TxjN2hvEEHGzqHbSR1n3hSMmkICriHJ3rsskUatYj0bGtVpM2rZi7tSzyKvhxwIqy1cE++QK7bkU8E5yfAqCTbJa1v1le9cPjgO/RM0JPHt3uHrdx+qhRfS5RVF1fPtgeZ0p3og8a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p9d6zTN2; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p9d6zTN2"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c70ea5e9e9dso1535534a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 23:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776753612; x=1777358412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPwOpTfrLZUEPYuYw9st6aLdCBfwnzGfzeTwyPnHP84=;
        b=p9d6zTN2cmZ61B+dHkJ+SU7TtXA+TY2rqhJcaZgWSkHg86fsOi+t/epsGobe8Xgx+a
         2gSvsDU9PxBeqt0C20NK9k+8T074HGvCnK56vNtTtpUGVaKbtE20t9NHZN9HvS4wiH/v
         dIodymf1eEJQrVCJQTcFtSk+F6GRQHe6BrlJBHuld+eaOuMY3ILE2NgsOaQbhkhQfEXz
         XxvJdIMa/glauZQsScMCg2kQQki410FqjXENY0+dfwrr6iYJT1q4smyC469AqpFeMupb
         BBAUU85ndJOA1evliRLzdJ8CKbIJplVdK6UIXaX8QN29GjxbbAZWOJMY5LpW2JmB/YDA
         f8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776753612; x=1777358412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KPwOpTfrLZUEPYuYw9st6aLdCBfwnzGfzeTwyPnHP84=;
        b=N5h6JGRvHq9i6OiQD60wuUHFjR+jm/SIuMeJoCIcWUEpd7AZf8ISv23eIzZDL6/xEP
         72kGXaJNvSzDOwEPAfLI/JOoCVlaTPG1xx3KVwx1v+WwA4fj60Vu3bnWjjAOWvRVqlTU
         SutmQuWp52KVetfdN7fBm1Lp4H18HRZRX2bXU0MVkKErT7+hDbPlZxsRXJr0/1pvt7Jh
         WB39SOyKwWwJUxz+9F3tMo9XNS7sCKg0p3WxiwfJsyTwqXUKQFeGUmq1t5+HO0bGd0vE
         Ltg+csN0ibOal4rsG8PP/jYmu8NwWAl6hVCUvinj9aEEU1brotL6g9YLgtEsU4OSvCnc
         eItQ==
X-Gm-Message-State: AOJu0YwIBdF+0kyPNFsrfF0pAm3x76vGUKn91ANUbvt8Km/saW+jqOai
	F4HQypwKfMx9rGKFXKQUoGeXfnfDEJmtghP3uvhSYMrCUGtr1GKesyvZmrs1Jr4P
X-Gm-Gg: AeBDiesGqDzUv1S7eA948Hb0KeyG/Wh2p6ty6QKz0XATnn+3vj642ZPCykmx+pmbf1V
	cFEd6yUCmYG8NsyLrzF9FdcrhO4kc8Srg86IlSOJuFv6q4VSv++Gxpomqei3+kNE4mwHH5SolEb
	qc8a932BZ7vl1afJWheXufsfVFdlqGbefLCx8T1xf+65Uxcff3Rop58avKF2Vj/qA+zaZeVhkyl
	iIZJJS4DTOssxsIejFuhOzWNKLVAx66i9s09Wi+080UmgLlWSG3q+utqidOK9gNsQZKT9Ff11MT
	uyHSNqqu9A+Rfpxm2eUnETvMDkynBbAv14ubM8rZN/nO7864DIv1/HyQ4VR6USt8Iw+YtxSNr0z
	7iPkiWeIibmOeIR69M7GqzMX7ME3f2tk/jyinNQ2S26z0HGknof3iNr1MmR5u4ub+3RgAXGjC24
	q0IQvJzwYCWcEtlOo6peHVLCVK901FLqOsCY1d9VsNMJSrnVqC88KAxz5SNLid55cLzdQeqquFg
	hg=
X-Received: by 2002:a05:6a21:9995:b0:39f:24a5:3065 with SMTP id adf61e73a8af0-3a08d68e9eamr19103464637.7.1776753612396;
        Mon, 20 Apr 2026 23:40:12 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7977031729sm10032811a12.25.2026.04.20.23.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 23:40:11 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/7] cifs: abort open_cached_dir if we don't request leases
Date: Tue, 21 Apr 2026 12:09:50 +0530
Message-ID: <20260421063955.99164-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260421063955.99164-1-sprasad@microsoft.com>
References: <20260421063955.99164-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

It is possible that SMB2_open_init may not set lease context based
on the requested oplock level. This can happen when leases have been
temporarily or permanently disabled. When this happens, we will have
open_cached_dir making an open without lease context and the response
will anyway be rejected by open_cached_dir (thereby forcing a close to
discard this open). That's unnecessary two round-trips to the server.

This change adds a check before making the open request to the server
to make sure that SMB2_open_init did add the expected lease context
to the open in open_cached_dir.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 04bb95091f498..e9917e5204b00 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -286,6 +286,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
+
+	if (oplock != SMB2_OPLOCK_LEVEL_II) {
+		rc = -EINVAL;
+		cifs_dbg(FYI, "unexpected oplock level %d for cached directory\n", oplock);
+		goto oshr_free;
+	}
+
 	smb2_set_next_command(tcon, &rqst[0]);
 
 	memset(&qi_iov, 0, sizeof(qi_iov));
-- 
2.43.0

