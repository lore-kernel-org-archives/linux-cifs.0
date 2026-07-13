Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B4C3644C3
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979718; cv=none; b=ZOZ/Hu0XjXzgS2jqbh4C4iJz2ZC1Z/j/LukuruBC1HcovM81pb/KjWhQzrEhDyVvzP64hJCQTXucGTZSrDH43KGRzjeIkWamOHk9Pv917h8MKQo+qaRzwyAAyDLjy5ogA7INxDIYyEVY2aRqimwPpYMr3V8xlnW7jYonmJoGO1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979718; c=relaxed/simple;
	bh=iZfYErounIL9gHykFDebdn//bMBHfpNIHjU5jurLOQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r/piAv/vB+22pl5vPYkHqsTRKmcYx4XcDZZjl7gUdHIzEJHCHtw16IkNDAr0OdWP2SLhASkqSjudnb+2sg8k/MDUDHscJ6XPPwSyIgWpmESBfB7KBJJFHQs7sAHX0XuTrYrPFbkCekjLS8wT2jq3/Ty+QO1x+TWkC2gFD4kHzfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=YKNlqOSa; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="YKNlqOSa"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7c61b5292so3823275ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 14:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783979715; x=1784584515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MD7Y6DMFrR7r/Z/j6JTbjRcV0lB38kr6b6Wdu1GS1g8=;
        b=YKNlqOSapmfq1QdMcoCDyjEAGnHFnMvH7fe9z+LNomCxnBkdtaqmo5zK0T7O10sFy4
         BUquJm5IXRQJ5yW0a3uMUCBCyxuDVXyp1/V4cULNgaiCgQpw/DDYpA/ZMwnXvS+fEbAQ
         LyRtRDGNGyVijY90YNPVJRK8qDpvxyvqZddnQObbrWD6dyuTClfObgl64EH67FzZ1xhE
         dIwo5cIuzNX6JKodQisFHc9hW8lBssjHC0tlPQQ7dRL89rDxwis+eqD+A+ZIwL3L13Cr
         EehZDzamWFhc2RjtiHRy+GebPafGeZ2Qrb0mBqGle6F0UPSVXEi2Q15qsvrlkiX72LlK
         8xrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783979715; x=1784584515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MD7Y6DMFrR7r/Z/j6JTbjRcV0lB38kr6b6Wdu1GS1g8=;
        b=Tzbv/yv64P+sKFTFtpxgG6uhOqzy3btNJ0ARbZSMJhwKiR8u9FSm2HCihOATPZVdvZ
         AeF5LzPiKhyWKkRxUSpx0B6M9Q8AP3hcmsL9ixpciXq06GI0100Z54HvivmzW18A4tlQ
         vfzEnaGdZ9wLEyzaHVrmiM+WBh2YVBh4ZeMUuRYSs5E7XLIWxIjAKSDU2+edKYE6V4Xl
         ibxlNLfSYrAqHltijhqJ5KgAUxaDWH65v38Mh22FBWC7rBNbiQfEPZS/6WMFxWo3m7NQ
         He9T8wdxl8S0/WefVluWbhoE19TUTGIx4gomAKbSyiC4PWqM+18W2wfLSYm1qKVwpBIx
         SnQg==
X-Forwarded-Encrypted: i=1; AHgh+RoWA5I53Va3t8KkXcMkzfA6SZtSM3EBmBVlqjiQw/cmXbkee3hzd+9JZmkNuAjTjPuaWFTH4Jjc/nA3@vger.kernel.org
X-Gm-Message-State: AOJu0YxmFwJbU7yIF8uTDFyIQ2eRbcq9IeFW9iZ4lWR7MwQ0LZ5VhGM8
	DaZrdc3EyPggnJkLzYo0fWXbScMz8zjv0OXaA8M+tti7RoogAQ+DXUD3iqudzcf9dg==
X-Gm-Gg: AfdE7clYcYjGAwvYEP2S1Y/CApyNPTgZA14I4zbzNr2yVHKEDvDzVuuzbhbY+Pp/W0E
	RpcTXA4L5hSLc/MP3dqFnKSdedFFffA5zwrnX6nL2OV+k14lZi/zJViSW5wbpX1Pcjcy/e1GPN4
	NOIx3bKlJdxHgnLWJ+1fzQwLfBPdmqOWdJ6Et8Du/NlKiimCmdboqWj4yhG9p7i0f7QCV5Rii8i
	erGD+MvmzIqRFw/rHvOJNRcGRLaqIEdyHAvgjGmm9vsSoGR8sN07vAszyRtc5uI1TPt9AmBOEeE
	zUob4zt2mdNK5kztPqBIepZUMAlSZbL6nPHHrkETMVgRmjN0yWirjIjUeIrScJXIBVYWaa3Lc+D
	ErBBakPJ4m5/jXU1fEjvHIt73xJxmzzt3hn+MRFDA1e3rN0c6I3TcHWsfHUs1iiXdg5nMCI6DS8
	+iDMzlc0YK5kzdyLWy/w==
X-Received: by 2002:a05:6a20:734a:b0:3bf:b9de:8570 with SMTP id adf61e73a8af0-3c110160a19mr10763040637.19.1783979715415;
        Mon, 13 Jul 2026 14:55:15 -0700 (PDT)
Received: from xiang.tailc0aff1.ts.net ([20.171.14.70])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b9a67c217sm15480309c88.8.2026.07.13.14.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 14:55:15 -0700 (PDT)
From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>
Subject: [PATCH] ksmbd: validate compound request size before reading StructureSize2
Date: Mon, 13 Jul 2026 21:55:10 +0000
Message-ID: <20260713215510.3288580-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ksmbd validates a compound (chained) SMB2 request,
ksmbd_smb2_check_message() reads pdu->StructureSize2 without first
checking that the compound element is large enough to contain it.
StructureSize2 is a 2-byte field at offset 64
(__SMB2_HEADER_STRUCTURE_SIZE) from the start of each element.

The compound-walking logic only guarantees that a full 64-byte SMB2
header is present for the trailing element: when NextCommand is 0, len is
reduced to the number of bytes remaining after next_smb2_rcv_hdr_off. A
remote client can craft a compound request whose last element has exactly
64 bytes, so the 2-byte StructureSize2 read at offset 64 extends one byte
past the receive buffer, producing a slab-out-of-bounds read.

  BUG: KASAN: slab-out-of-bounds in ksmbd_smb2_check_message (fs/smb/server/smb2misc.c:402)
  Read of size 2 at addr ffff888012ae31ac by task kworker/0:1/14
  The buggy address is located 172 bytes inside of allocated 173-byte region
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   ksmbd_smb2_check_message (fs/smb/server/smb2misc.c:402)
   handle_ksmbd_work (fs/smb/server/server.c:119)
   process_one_work (kernel/workqueue.c:3314)
   worker_thread (kernel/workqueue.c:3397)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

Reject any compound element that is too small to hold StructureSize2
before dereferencing it.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
---
 fs/smb/server/smb2misc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index c0c4edd092c2..9f3629c86291 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -407,6 +407,11 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
+	if (len < __SMB2_HEADER_STRUCTURE_SIZE + sizeof(__le16)) {
+		ksmbd_debug(SMB, "Message is too small for StructureSize2\n");
+		return 1;
+	}
+
 	if (smb2_req_struct_sizes[command] != pdu->StructureSize2) {
 		if (!(command == SMB2_OPLOCK_BREAK_HE &&
 		    (le16_to_cpu(pdu->StructureSize2) == OP_BREAK_STRUCT_SIZE_20 ||
-- 
2.43.0

