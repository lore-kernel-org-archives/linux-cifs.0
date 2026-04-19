Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A8C33D4EC
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 11:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776596588; cv=none; b=eFien8Sv5AvwkKUOgoFJEt/XbI7Gtf1Hx72zrZr6pU+cZCaIrG3acHhrBpbRHaEYiAviCHmpboPeNQH/MphQNrrT69hHA/DVMS/M2MzsO0/a1Pm4EOl83ITGr+er1Ftw6beFcaDCduZ5QSOXlHhdXaO/IBnzq7tE2SKzfbiCJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776596588; c=relaxed/simple;
	bh=VyK4kxf1xc0HknGrvHpp7IfOxieIEAAxS73/8cca4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVDg/r1K+BkXPSEx2Jz+wRZgUH3Ap208tLr8BT3PI6/k/PrRWA6S+L8mQAi1H0i38JESoi0eqxsIPeqaf/qy1F2QlFs0nQS/Ek/Ic0US6+1FDaNxNFlVNRl2++O/wongsrgprnKndPCznOdg1X9XbdsVo+4HnoHkz7KbZDI/+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JpLeJ91x; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpLeJ91x"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-358dff8447cso375132a91.0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 04:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776596586; x=1777201386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DyStktkJgiHhlYyQA1PqDFemYtpoFBPyefLrK+uytk=;
        b=JpLeJ91xQvRPNzdxliKy0sKpi6YBzMjAUzWtL8AtBlA1ck/npt444vhx3Y/Fmp3VpO
         2J0fQiSVXGQART1V02JV6S5jZF/3eDuFW0N3jMEGLjTijq28zmpHe0efuA9I/NdTg1yv
         p0ldn2KfR53nWmWLKNx3ZI+BzTkl8rYyAe300qou7UsEtzDAC25Swj1xuuMinES72IYs
         61T2KJXXzV6KWv30o1+KFShjoYtG2nAEmBfOMv8ze5yM1c4ixwl3MtXDItAEbQkir1GQ
         65QfXPVazFYloKYotjgov4OiCDVgU3x4ZQG8Y8ZvLMy27Us52ps0TBlFrqt90Besuc6/
         Wslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776596586; x=1777201386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9DyStktkJgiHhlYyQA1PqDFemYtpoFBPyefLrK+uytk=;
        b=BMK/1kZUGQ4Bm8R+ZVFKPIlx4e0A2VJuR5gnSS/zRxsmTfBOxzuxG/anyAclhxhnAC
         W3EINKjskAbjO7tTnPMXy+vNXaHWvEc211K8kP7R7Rb/M1gFgsNpfb7wZTzGeMFg+GxI
         UOOPBuS12cYBo+KBaCZ5chMq9dwIVYIsepPQretS/xboCDLD9JiPIaxJdnIjxXzKSZ62
         pBm4oinQyZCQoNcqK6Y0Xi5ZfbRfpq4d0EE6BtoKk/TmAirL8MY28LjX3glUoWJndKi+
         wwNUWCie4mzHtOAvC21qwpxHMY+ameHGBvs/82vF7dQkgxCcZvMj6caFqAYZ4qXGdLE3
         0X5Q==
X-Forwarded-Encrypted: i=1; AFNElJ+eeEYQ4/PNREszqsPnUbPkLkqS0Iuy86OvnlXv4F+ViHTVsPEJjd4aq/PkmKDAHZrRRs+A1HHZ1Omz@vger.kernel.org
X-Gm-Message-State: AOJu0YwKptISjZ1+bwaQkT5g2mEZW426UbIy12BYKlBkPQ8Yz6PYZxiQ
	E0ciW9fybIJ9dUl+vJZBteIs3Tpwb6IB0PZnWGU6CnjTahoDw6JMI91L
X-Gm-Gg: AeBDiesF/tvZIXQi4kS3HmWWOthK9L9VIdcg4Rw/kskNxquITjqO0XksVjOzC7Z+9mB
	B5O5QRigMazxhicjtpGSQLtqfUnd4XZSO9CQKG+HLcwIfeVWYYWhVyCHNl0Hy1tR/TTsPaSeWpy
	cCFcX9TCH2tK40ft7+KpoUypoLaZgeRlqGTR2/OwiyLVcgJCmLA+eCAdGi9IB9dGwwesTeBuqpK
	qROILIzRvj9Xy+cb9v38IYczyA4znRdiKMQSxZexMYz00z4MnovSE7fpEgkq7/B8jLBMTz65j/Z
	Cbdv4JzqhUSH1vfDyqb6z+e3DQhzq7zb8ZxYWdPDsEpcOGPxS7JU32M8GX2rszHwj1V+nkL17kG
	t3yFakU9CNB7z6P6T3KhvriRAh4X3gNN+Vi9/qD3Pdeem1webcpfk48d3PS/uKm7hxWnxbSIXZR
	CCB63RTTpHFZS/v74nnlN4IeoEhzM=
X-Received: by 2002:a17:90b:4ccf:b0:35f:bd83:38c2 with SMTP id 98e67ed59e1d1-361403a686cmr5421740a91.1.1776596586452;
        Sun, 19 Apr 2026 04:03:06 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm5527972a12.24.2026.04.19.04.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 04:03:06 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 2/2] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Sun, 19 Apr 2026 20:02:55 +0900
Message-ID: <20260419110255.2477785-3-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260419110255.2477785-1-charsyam@gmail.com>
References: <20260419110255.2477785-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When per-connection async_ida was converted from a dynamically
allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
removed from the connection teardown path but no matching
ida_destroy() was added.  The connection is therefore freed with the
IDA's backing xarray still intact.

The kernel IDA API expects ida_init() and ida_destroy() to be paired
over an object's lifetime, so add the missing cleanup before the
connection is freed.

No leak has been observed in testing; this is a pairing fix to match
the IDA lifetime rules, not a response to a reproduced regression.

Fixes: d40012a83f87 ("cifsd: declare ida statically")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/connection.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index a4110c6cce37..8bbfe27387e3 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -98,6 +98,15 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
 	if (atomic_dec_and_test(&conn->refcnt)) {
+		/*
+		 * async_ida is embedded in struct ksmbd_conn, so pair
+		 * ida_destroy() with the final kfree() rather than with
+		 * the unconditional field teardown above.  This keeps
+		 * the IDA valid for the entire lifetime of the struct,
+		 * even while other refcount holders (oplock / vfs
+		 * durable handles) still reference the connection.
+		 */
+		ida_destroy(&conn->async_ida);
 		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
 	}
-- 
2.43.0

