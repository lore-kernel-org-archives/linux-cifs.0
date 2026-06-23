Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC730DEA6
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232179; cv=none; b=Wp95KQvAFwLbSdp36tqa4x2dW4ag/AwfQ5uU9Z2xn7LFAyoHPEcUs1fIKk/2OcysqrTUv1GWDfkswSk40hnh1iztJHUMj/vJ3ukJ5LT9YKk+KQeECNk+XrCHYT9AYWa1dbJlLeuCq8++GtGyBcFkZlTmj7WrxTfHFE1RY3V7tII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232179; c=relaxed/simple;
	bh=tam+rGOeYyC/BL7WRWlBgHCH8garmlh7gDowJR1q+WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvQwLmVk/pY8xKJhPu1fslqs6JVfEksEoUqU7x7GQCYQB3tqySfWhqOYWN4vpytij+t21jbKqgOq6nHi3OH+w4hlUQBk8Wn1ZVpH7bb9Tgx11PptCVDhlBfksJMzkjsU+7j5+ipFSm4OV/DaNepNndZFkYlX36Z999rriDwVaqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RZjUVAKX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RZjUVAKX"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bf3781ca51so411615ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232178; x=1782836978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMuegTGYxuOJZUlNFBiVyLDULB9kqY5DAvTB6HygF0s=;
        b=RZjUVAKXwpWsOwM3BO0KAH68A3MpV2mIydjctiAnLHvi3/HvAhqYeDHLu37AgPXp0+
         fPBEVI8zq87flDWLg7Cc5DXAYnpAInTPsWhVIgkQjNumWHTuWgsniE8rjQIlO7lo0EqQ
         W4GX8IZ8LsZs75Q28EZaRC4LH92rRogrrAO2ooGHNMrQ3mI+4GgIyldNbdpmdx1aQCiM
         UJqsZf9MDpH7KGF/DxN8gnpJ+n0OYJsLD9wSi7K1FWxqsJ7fe3uYs9tnaiYWWuc2eDCo
         Qkxnmtao7z71Z+yTqLJXrSbkF2imGqSf+uVv5IvvKzEksAccr+LikjJ1RMb4ZprfNVYr
         nlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232178; x=1782836978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QMuegTGYxuOJZUlNFBiVyLDULB9kqY5DAvTB6HygF0s=;
        b=dvhvY+Bt4YgBTE1wHOE2wFm6jtyex3FHvA92fOZ5sJ4V+cHIiQSkvfeS3KCvQ7jee1
         gQj64vl1w5yzOp9KwoROp5J9nNwWKZPfhQR6ojW3XOACXZiQKK37xk9UmP/iWeuCoior
         7qxfM7qCxmdljoiRCvw9/9qIsNJ93WMdJMt+w+6SJqU4stw+bHtnybcYARymXe4ZU1Uz
         a5ehHJKaOpofzDPxOkctWEwz/TAKN/M/IpAzO2M/077nfROqRQeaLTZ483gA7lBw4sm8
         HmR7AS9/dVNcrpK9Hlf1qDp5CZbnGTUxW+9akgQLwGSBm6+6p7XQws3XB048SZAH+Uv1
         1BFw==
X-Gm-Message-State: AOJu0YxvfyXJ2t1plK8dFtE5R0qJDe4ynG3y+fuaRBWiYfsWzFx0Cuus
	V5l2u/JdD8fjHB0mB1X3q7Bn/hhsiuQvBe9aApXyQujikUE+5ml/pJuOM3eaPmIoXUU=
X-Gm-Gg: AfdE7ck1TrAn1WjjH7qhI/Vuz0LtT9ofNNM/a0B/0Aw8ncvjkD9G3q1B8jCv3kJUf0l
	6JmkrMFWrj3RH0DGDxkfIt+qY86FbROXHxO5VDIAvKq+KSZUdxnS/vJntGZeGdDBwqv9wuEvw9P
	/ClEE81SH8Cb0lDk5XxzUWH6g06QpgW8cyKZ3pqRXWUNMLqDQM6nv17r0wsT7dRrpnXJhx4cBtG
	ezLMMp4Vn74Aio7AEiK5g69K7xhYyt7OVdHeNIK9dAyOjnFECzB2+uC9lxTpqrAtAWxmQFBdNMS
	ATOmUGM2mm+Tts2LBiT5yLrGsjieXgHDOi763xR5DlZAyu1W0NRgkkXZTNC7MzsQAxdHrmnYcja
	RO1qcZwfayg2kx5w0bi/8zaZvPJSHZxCguocpvF07WG7Rqm1nljBiohXUuwlPWTxEdPBB/TM/zi
	wheCE0FyD+OhWHkCDYH5F8SP3XNqDo1rTAbOYKuqky4X7DZX8onUEnOg==
X-Received: by 2002:a17:902:f541:b0:2c0:db23:4c1 with SMTP id d9443c01a7336-2c7c9928dc8mr33426245ad.5.1782232177983;
        Tue, 23 Jun 2026 09:29:37 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:37 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v6 15/17] cifs: discard functions to ensure that mid callbacks get called
Date: Tue, 23 Jun 2026 21:59:08 +0530
Message-ID: <20260623162910.343930-15-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623162910.343930-1-sprasad@microsoft.com>
References: <20260623162910.343930-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

If discard functions for readv and query_dir return error, the
callback functions can be skipped. This can end up with hung
syscalls due to the completion functions not getting called.

This change ensures that both these discard functions call
the callback function when discard from socket returned error.
This ensures that at least after the mid for the response is found,
the callback doesn't get skipped, and we do not leave syscalls
waiting.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 99cb189dd567b..b30e2388a1c55 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1143,6 +1143,11 @@ __cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_q_entry *m
 	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
+
+	/* Once the mid is dequeued, the callback must run to terminate the subreq */
+	if (length < 0)
+		mid_execute_callback(server, mid);
+
 	return length;
 }
 
-- 
2.43.0

