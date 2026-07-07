Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFED53DA7F5
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418482; cv=none; b=LSlM7czyvPmfp2dY0tUG6EfS3qpFNuvAKzpvmPQbgVz7c/07LHFok646j2Cwt4pjAyk5k45hLm6qbUo9VRIKFRsRIedR9a65J280+5ZE+MO9GgnLE47+6AAgruIju9GeaJ0/pElG3T9MeQ0jhDbWM9UNX9ZuJy3YyuhM7U6ESEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418482; c=relaxed/simple;
	bh=+bgCSMZGWGzbmIXXF96xKLL3+sUUv8YdqQCLIlTPPC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJyY0l4QCtC8MIWivXbKQDGcyKnddRozd5iShrTRSYtbYrdRuxoZc3zEmKFHHeNXZpNMP+wU19q0ig70jN5cKfPagGETBOmaTpah/AXFlWES5mjkg7ZPeslEZa1ZrSyxnojO8vQ/NyycVrlZhBNCEspz0tDxxvQApZOV8N/XeLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pslYBkgr; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pslYBkgr"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so4142333f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418479; x=1784023279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BVyrbpqy88C1bSi9d2yTbk60lQ3mt3im/Lr9ElVHnPc=;
        b=pslYBkgrLus3YB4kpBDDZC/C1N/ZSG1+uZ0c9STj+wZs8C9yhVHF9zaRXu1fQjipOh
         cpw3TKBC6/le2IIxikPEiL6DHG8CpMO9eOwwVyoUCq+gqonf+EncD/8w6bruEZO0huTQ
         3FczliDAuJ+HFdrgf45npN9MRqTCPDaT/9oev+jOCI6x0AV5wdEoIegTJQkZLyZF0GAL
         iRJqn3DDyvuczI8YqBvrOARI1rZdJeV7aZ8jrWwNr2O5Yaq+7Q9SX5I18pdkkpm7SNz7
         B9NbukbIZ915aQ/m/Fc1eMfkuZrQb/2/DFg3O6zCgYHt81O7ckdMYD6H3CgCevHx7rZK
         fROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418479; x=1784023279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BVyrbpqy88C1bSi9d2yTbk60lQ3mt3im/Lr9ElVHnPc=;
        b=iuPVpBjVs/x5HAOK5Y1/fHhaZeA0v9ReLBzOK3MItAr86QmJtbJxB0E4RlBcoXAiyJ
         zWixFWdybce2F4kOPqVP7JPbR3J+xTE1N6yuqIcbpJNjHEIexgGePWzsaHyHHrye+cJn
         EvheUvBdTAnAFY8hPm8fYKU52vjDI1bhJC1opnsqQzaNxdti9We5Zvc8Ib5DLKULMNF/
         fppdQEy8/LdCTv8yO0Ba+F9oHQJr9nUEmEWt/7tj8rOESDmFvF7EOgizdWa2NsJYb9OY
         x/QHEHlwswC/2NSpgq++FAGmJrSgNo6JQCrFyzqIhtKa2ao8RfIKOk/xAWvVQVK6/dkz
         6vgw==
X-Forwarded-Encrypted: i=1; AHgh+RqX2VVfZsWDvvSkEwe6RLhZInbFIUfcJkNSc/kXQ3WWZ8eKZu3bNSAvc/229nLoax+k7dnpjOpEguNY@vger.kernel.org
X-Gm-Message-State: AOJu0YwQAagaSFkOiMI74tM3XSY11M9ulbh4smdI0YBpjE2wL+JpMASG
	qkrFh2qOvV0+rMvT5kBHxzcS+IjFL0y5Slf4ckyeG0waGeXGonOcNmfN
X-Gm-Gg: AfdE7cnzgcfjvf20WQDK+6WVj8L4JQ0oj1V3LDhrBDN+WWqC/THNWHKfFhvWzlPBqZY
	AOY+GafIWzkO4r8CntXS8rBI1SfcByv51uydNIh3Wi+EtP7dSO39GMbJZu6mjxIY+7otO4M0X38
	EsQP2QCswX5xHjVWtICqftm3oEam3RBoc+gVoW0+tJMrzXZSm9dRjjDLSPxmu4L6gYKu6Ru5QAQ
	T78vQH3JmSawGWKYcqMq7HMKHpoNZDzD7UzzsN0qRTM8GLLzupdYrHXCzL3qbWFGGHOdUu+2ZLx
	oF5bx5DWrCEQ72xN9193i79smyYB1e+sdQ4ps+dIlxQMuwcB54cDuCsbEACe/o3XYHzB1hI8QWV
	1ja0Pg1SDrknL7e90GjxOnK63dCpnyllOdjoWz4aPr7rD98v+e6GNBPjXfJb3wpfoEP9M0w0AX0
	miRhf9niZRFrFPMPaaWTFPtwQaMw8ipHprUoE=
X-Received: by 2002:adf:fc4d:0:b0:475:2171:add with SMTP id ffacd0b85a97d-47de66b1f97mr3565297f8f.22.1783418478571;
        Tue, 07 Jul 2026 03:01:18 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:17 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 4/7] ksmbd: return STATUS_OBJECT_NAME_NOT_FOUND for unknown IPC pipe names
Date: Tue,  7 Jul 2026 11:55:04 +0200
Message-ID: <20260707100033.47512-5-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
References: <20260707100033.47512-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

create_smb2_pipe() maps ksmbd_session_rpc_open() failing with -EINVAL
(pipe name not recognized/supported) to STATUS_INVALID_PARAMETER.
macOS Time Machine's backupd treats STATUS_INVALID_PARAMETER on a
pipe open as a fatal error and aborts the backup immediately, whereas
STATUS_OBJECT_NAME_NOT_FOUND is handled gracefully -- the client just
treats that particular pipe as unavailable and continues.

Link: https://github.com/namjaejeon/ksmbd/issues/502

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 735c3eb72..af957d013 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2646,7 +2646,13 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 out:
 	switch (err) {
 	case -EINVAL:
-		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+		/*
+		 * Unknown pipe name: return STATUS_OBJECT_NAME_NOT_FOUND so
+		 * macOS clients skip it gracefully. STATUS_INVALID_PARAMETER
+		 * causes macOS Time Machine to abort the backup immediately
+		 * (confirmed in ksmbd issue #502 / namjaejeon/ksmbd).
+		 */
+		rsp->hdr.Status = STATUS_OBJECT_NAME_NOT_FOUND;
 		break;
 	case -ENOSPC:
 	case -ENOMEM:
-- 
2.43.0

