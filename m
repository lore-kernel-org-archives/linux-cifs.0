Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1038BF92
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175171; cv=none; b=L4niNFXk1gIVl3mCRdZhVkYenhjSB4qnNgR0pRaSL6PO58EZhTHInXU4y6AsNQ4HrTO89r3FAqpbeOd2ny11oq+ExN3EHpI8g1FBAJneKTkkPRMvRozEC6XRIdxCKe62F/EhL9HcCU2SMCiwcVRVyJ+pXNTO78LJSejPgFShO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175171; c=relaxed/simple;
	bh=i7moRks1Em5xSeDJRGmHijtRZlYJUx95CBNBVmpOReA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zch4mH9LJA82DFVCceUaCtJeWe495BRo0/IN8GfHWMHRMGQpyQkyIbfyV9PoqgGRkER58CNoWvLAlbw+9KK6bidU44XEoXZytul5KWrC5r/RK9UAr2tw760oMuKyxTp43/5iG68qg+lPoO5cYT758P3peKXLDa26v1RVeKZpOxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M2HG51rP; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M2HG51rP"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2aae4816912so37223325ad.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 06:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776175169; x=1776779969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AoTQHgaXiOjxnBKbofO+VMkVOBU/6hoNuKav6Pyb85M=;
        b=M2HG51rPy/tDYN43P64USexx+GaoGqzvjrq4ZoT9lXF+0jUiLsWtvEBXC5yeV1XDnk
         0WfwFbAfvcbDEzboxANxSyK25U1yH6REzpL6QfKW95mSPeKCtKeC5KvCbQTOfxcpm46E
         uGbdVHbXEHN3+w2gghNT90hgZ6zO5PqAO7n40fqSGpHxJmtxfcFyNCFGl3HiKw7d642o
         Z1/8vjHWWvaq+Hk/YzPd7AUNYhOTkpPApAbKIwrYV1SvU+gAIxKDk7T0xPN2ZCtebfA7
         ruHMzrw9Z6wn5UqFGBIfqblt7UUMFy2qQpwHO8uBtvrCdYXqrprsl09kX63vhmZ5MIY0
         qH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175169; x=1776779969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AoTQHgaXiOjxnBKbofO+VMkVOBU/6hoNuKav6Pyb85M=;
        b=Ts7WljMOTHg/QuEW/phGd0TGm2yo6W+cnqHKoCTr4LieXbpk/hdlFqWrPQdlhIC+JA
         CV5elM2ozeKhYhoBXvYSbEIg8xBCW8jmtrxxc+1HQtrNLBFPuQlgIbsXkSOI5QcWNgxU
         +aN6OQXlJAd0f2CxzWTyYJ1O+D/Ii2Y19kEt2Yaa24tyf5rjNYcp0Lp73nqjl0Kw4EMy
         i5IJxMcx3ejc4BBs1/f+d5YZrK3kI3WQd3EZyJYe7lMCCZF8cvu+im5e42OWfJL+d44N
         sA7OBBcxSiotsRUQW6hbog75INB+Q+eWFbC50WtK30H+dX+2IgBGOjTEM33816KT+ire
         OCyQ==
X-Gm-Message-State: AOJu0YxjXIPGI3ZwzxMZNO56dsn2Yta8Xgh9D0rqQLbVzWT29pHhzMNL
	ZOvnCikgVa8hggwWzxrDDAPyhz1YcTlsagK7V6R/5M0zW2mFTtIQqEAc3eMEChLP
X-Gm-Gg: AeBDieuVsa+z5OLE+SjwDijAAYyz70ufh7C5Bw6lWzygIDNZUNbtUy/l0u2O6CmFI0r
	XR0lKNYBZPrW+4sOHz+mLXpjeTs55tSAQiQjA5UYcIUwosZBCKHc6ttXCloyC7vXAynFbTwpxjT
	37wuhuZxgel6PZNTHNLNtK4HHLPyj6yrryzeWGrgJruoNkHEoD44T8fDmiwZbIzQ/qo0mIRPOqg
	OJjKI7VwGq2pvtcBDVD3RBxsNzjB2QmSUJeHl2SxFw/N/s1PnZ34sr2/9JIWZB2myODxY0kB6ZY
	CID4cMkJLoh6mScC+5LNpxtPzIcvbiR6/dQCjM02SaYCmqG3X5Pvd5OQuKNhXgW75vbfucJu3d4
	gMIb7Cc3eBiMGh8tuFWvUMs0dBQLrzGoaiWrud7qXmbrhcAUkZaAWZBsrBTErQnOrVqTASYqmkR
	z/9EWzw8mWMVUnu3Cl68Kh7zBZaj15EWf96b6QTXmjzXq/H9nNv2HWodl66RXDW1Q=
X-Received: by 2002:a17:903:3c30:b0:2b4:5f69:715d with SMTP id d9443c01a7336-2b45f697b4bmr82943705ad.25.1776175169402;
        Tue, 14 Apr 2026 06:59:29 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4612e60dasm59779895ad.38.2026.04.14.06.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:59:28 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/7] cifs: change_conf needs to be called for session setup
Date: Tue, 14 Apr 2026 19:29:12 +0530
Message-ID: <20260414135918.279802-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we skip calling change_conf for negotiates and session setup
requests. This can be a problem for mchan as the immediate next call
after session setup could be due to an I/O that is made on the
mount point. For single channel, this is not a problem as
there will be several calls after setting up session.

This change enforces calling change_conf for the last session setup
response, so that echoes and oplocks are not disabled before the
first request to the server. So if that first request is an open,
it does not need to disable requesting leases.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a429..3625030d1912f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -111,10 +111,19 @@ smb2_add_credits(struct TCP_Server_Info *server,
 				      cifs_trace_rw_credits_zero_in_flight);
 	}
 	server->in_flight--;
+
+	/*
+	 * Rebalance credits when an op drains in_flight. For session setup,
+	 * do this only when the server actually granted positive credits (>2) so a
+	 * newly established secondary channel can reserve echo/oplock credits.
+	 */
 	if (server->in_flight == 0 &&
 	   ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
 	   ((optype & CIFS_OP_MASK) != CIFS_SESS_OP))
 		rc = change_conf(server);
+	else if (server->in_flight == 0 &&
+		 ((optype & CIFS_OP_MASK) == CIFS_SESS_OP) && add > 2)
+		rc = change_conf(server);
 	/*
 	 * Sometimes server returns 0 credits on oplock break ack - we need to
 	 * rebalance credits in this case.
-- 
2.43.0

