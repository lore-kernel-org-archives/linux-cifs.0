Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3824C184
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786588804; cv=none; b=gHIAIdjFd7O1Hlxk111Ae9ARcqOjtpVrea4R7xKgpnvdTgKhUWxHf6UI8JA+h+ryecVkLoBKJMV9a8gQ/hIFVMx05SW/w32NMSqLpA4coqiMilfw5/3YF90VtScy29NfEapUBrySwSCV+maFvCj4D+YV6S9DpMiep8GC1Xc/jCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786588804; c=relaxed/simple;
	bh=lSt0EqBpkyX+cH64uzSW61lENCGn+1Dr2Sf9vrYyv+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GKn3/eaT+xwNZKL6hH/PKb32iGxHQpTK6mWoiiSDs7O0nCzEZZFokWFi2blF8AxMtA0eUam9gdVQSPxGMskUJ6uKcMf4caS65SH1AUG9QGtHrplt6VG3k2ypG+VoRKA6UZ29e4IYROpKR224UEQTjsEcnynfu3YJnJcSNmSJaak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvZ2NPTZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPPNrnaU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvZ2NPTZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPPNrnaU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786588802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wWDIoZRUfi9awnYLusDekbM5ZGXjySJAmwmUQrS1l3w=;
	b=UvZ2NPTZ2sso8rsgVEfQg3khyMUlcGeC72RWpwuKNO11qGloRYQQRE3HXHbvEDJohlpvl0
	BvM8SIO8G8LvNJAfExQYm5fo6Tc0mrusTRw/NrKoTFpLT9NKbTLQvsruUJKE1CtpqJ7qvS
	jqJ7DKpvPde2G0LNEoScX1brxjSoPvk=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-SY_xkf16MhusibgZCO-W6A-1; Wed, 12 Aug 2026 22:39:56 -0400
X-MC-Unique: SY_xkf16MhusibgZCO-W6A-1
X-Mimecast-MFC-AGG-ID: SY_xkf16MhusibgZCO-W6A_1786588795
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a49f09233fso453643b6e.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 19:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786588795; x=1787193595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wWDIoZRUfi9awnYLusDekbM5ZGXjySJAmwmUQrS1l3w=;
        b=QPPNrnaUBGS0HLZTxDbGH30acgEtrtcLdlAc10Gt1hVjNpuGzlLF/wIIQqfoOv61NT
         4VA9Vr1VUYfLeNAJgzktN2WGnPzR+AOc5ga9W+vrS12Vo/I35s0SAAr/iNTSdyHwTonh
         7Gaev+IRKzAuE9Sjrm7r5pbct12lRG+bprezw5yQwR0WdmD86NDJW/IDRTYKiZrTxQQX
         3S0NXLwtubH0D0n+n/4a8v1cYQkHvKkAqZwtkrcpQ1GgpLdfo01pGyZfX1qNvSym6E1y
         /HE4S1PA1MmOgrr2HXwjqG56LHmzilov8W5J8IQGeGXowiEfKnudsmoCMcnKIZjrdEAZ
         A75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786588795; x=1787193595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wWDIoZRUfi9awnYLusDekbM5ZGXjySJAmwmUQrS1l3w=;
        b=BU/tQLX+tdgZV9Usiu9H0IqM/8Y8oRUxO2WSx3HiMFSJMDl+n+VB4Jjeu99hPq/KVj
         cxmqDu2/A6SWiOZBIdo9T+oT8rHQx2qj3uUKaNMJfiBatw41QSAy3eCjzaC/O6/mVKxd
         Fa08WKmFQCRmkZKvQzdsqJaVeIjaXGYGzSErArbAmIaXaVwuHTVutK8rp+0RhwPKRP1B
         S1/CTy/bx4g8GUC7TOdpDl/CFMLL7F774aeBVKAxl30Iu9UIe+Glg1Lph89O06WoJV5S
         u4z/s7Eu1RF4BM/H+5HbI+4TQ9hRRnIj6LJ5z5HApZcuEMlygtwxhefWXWHWi28CohD9
         78Nw==
X-Gm-Message-State: AOJu0Ywz2AbjX5q0fSXTt/rB3P1pHhpm3qFD/yZgT09WavXtQYOkzx5H
	fd+cXsT4Rocmnr1OD6tiUWT1hZA/+xuW7g32JDpsl6TvMPWQgyH6zEYQ2Tf3lNW8TQW1/tRTVmu
	iSWG5eeHbadoZ+mK4oQUb511jkD20Ne9ZvfIVkxX/w2yPvDrCmG3xUOi9y5KWtXWwufWmnnVSiW
	oeG4tFB9ZqfgoCiwsszOXLLx2s5nAUY/GPPTDtHzG5kT681E0=
X-Gm-Gg: AR+sD12/ZGHolGgiAXfmwkfhCYU8rjubAps/0E83B77e08uPVgaVNo7kA4XYTCn2xA+
	jaOCyjF1lzim+Z/rLD3TdvxZ+7ksu72lMTpnbiRP2jUpigpiahIj7LRu6ldXiGLmgwfcsw6L4YI
	u8hqvtRRBC+Yol4+Q9ATVMH0cYUcYfbaGDAXGo7ELJ/UOtNM5XRlmdcLlqS2Isk8Wra3V82elWs
	mRFAKgERMld36Oc+9i0ocQPFo02gqvW5jMal2WLLK3LDRYA8plAcBdbnV8AP9a5gbeXShVu35gK
	6idot5fQ9KUF2IlevnLOmeMrRNDDwaJ/9ZQ5uOXERuda0s9YSE4yPceNb6AggSm7TkwI/JlRV5m
	u2EiAHqLcHruA3ioSwU8JORqWjIqh/OVTPu/g8FX7+YDZ8QGUszcYEI5hzpmQEzxUdw==
X-Received: by 2002:a05:6808:1a03:b0:496:976:acad with SMTP id 5614622812f47-4b2286875e3mr1003765b6e.1.1786588795132;
        Wed, 12 Aug 2026 19:39:55 -0700 (PDT)
X-Received: by 2002:a05:6808:1a03:b0:496:976:acad with SMTP id 5614622812f47-4b2286875e3mr1003740b6e.1.1786588794489;
        Wed, 12 Aug 2026 19:39:54 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22cd187e2sm506473b6e.6.2026.08.12.19.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 19:39:53 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com
Cc: stable@vger.kernel.org
Subject: [PATCH] smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2
Date: Wed, 12 Aug 2026 21:39:51 -0500
Message-ID: <20260813023951.1846143-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a valid primary TRANSACT2 response has been received (mid->resp_buf
set, mid->multiRsp true) and a subsequent secondary response causes
cifs_check_trans2() to return false -- either because the SMB header is
invalid (malformed != 0) or because check2ndT2() rejects the PDU --
handle_mid() overwrites mid->resp_buf with the new buffer (leaking the
primary buffer) and, because mid->multiRsp is set, skips the
server->smallbuf/bigbuf NULL-out.  When the user thread frees
mid->resp_buf, server->smallbuf or server->bigbuf is left dangling; the
demux thread reuses it for the next packet, resulting in a use-after-free.

Combine both early-exit conditions and, when mid->multiRsp is already
set, abort the pending transaction inline: set multiEnd, call
dequeue_mid() with malformed=true, and return true so handle_mid() exits
without touching mid->resp_buf or the server buffer pointers.

Fixes: 316cf94a910f ("CIFS: Move trans2 processing to ops struct")
Cc: stable@vger.kernel.org # cifs_check_trans2() is in smb1ops.c on kernels < 7.0
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb1transport.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 966f2cf83a51..f11a4a243784 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -430,10 +430,18 @@ bool
 cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		  char *buf, int malformed)
 {
-	if (malformed)
-		return false;
-	if (check2ndT2(buf) <= 0)
+	if (malformed || check2ndT2(buf) <= 0) {
+		/* mid->multiRsp blocks the server buf detach in handle_mid();
+		 * returning false here would leak resp_buf and leave a dangling
+		 * server->smallbuf/bigbuf after the user thread frees resp_buf.
+		 */
+		if (mid->multiRsp) {
+			mid->multiEnd = true;
+			dequeue_mid(server, mid, true);
+			return true;
+		}
 		return false;
+	}
 	mid->multiRsp = true;
 	if (mid->resp_buf) {
 		/* merge response - fix up 1st*/
-- 
2.55.0

