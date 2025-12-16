Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002E0359F8E
	for <linux-cifs@vger.kernel.org>; Tue, 16 Dec 2025 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900700; cv=none; b=YfqVQFjYMbTMsaQNwa+r7bNLg3amPA+hyGNsiKsAtoLo/+qVPfcVxomhTpMUWrnDoy68XVRiDpEm/jDVevmuOZL1CYcYpQupaMo5617jYTLpmHfHmlDz03/6Iybnhd90h8iKZ2IobxdXi5yWLQ9upVHNKJRLYEi/gDC2mJDiFlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900700; c=relaxed/simple;
	bh=mnP98O6NgTtVx6l+upsQ2lI8xWjO3l3UxvaIPeb8vJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ItrJqn6KQVSD4QJMQfLgzzSqqNC0VD4nJDFK/tqAujZm+fnxR64/tMfxX3J/AArDSgSe06yQyIPfl84hWGOBRu1BCMLlMenDxqpuOoYqBOp6U6JhDr6P7IRzTpcRq+V4+Qf9B5LVDJNkFj26hcvsLdqxAXcr/0dqx65E1Bb1rhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJ0VgSpm; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJ0VgSpm"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c565c3673so1342072a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 16 Dec 2025 07:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765900698; x=1766505498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lfyYkmOpMk4TAtcXtZsa5Uw6bxotOSekJFG992Gn7V4=;
        b=kJ0VgSpma9iQQaf0jmGLwaVGvPN095o3hkyJWaCYIgyU9pwQWZczwmHrIp06OLAHYW
         ttDzf+CvHXAUpfHr9KwYCSCV4TQb6i/DVw0f6Te+Ub1V9I3yUd2RF23/noKYn3hTL6rE
         WbtD8JXCPkruTJVEpHFh8Gtcua51aqUd91c85aX5UqQX0JoISPCigV9IqUuVhzttXWZE
         2nnXIkujmMwycfWAbrEcpKy79e/cYPnPxrUZ0Uzh4gBXcB9rwn7iFvoO63Gf4xC1qmNl
         +p/EEMYEBP3hyzEQJU/E+BwER0syWaPOsMKVxCJfu1HEAggxiYmfBNxIrpPGKBQMM0jc
         yO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765900698; x=1766505498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfyYkmOpMk4TAtcXtZsa5Uw6bxotOSekJFG992Gn7V4=;
        b=CwMmqUrzdxlo1giLwX8QHFv63ZEEAiW48I4kMT79pAjNiiN9oDE/uDH286H9et7lEW
         P0OjqwZTGZnWyBf7Q+HNVLdWbk3jxUKmoCtoFvlFiQH9bHJfgYvTI+Rq+Mmt+CinTFGr
         ulrB/gY6nEu3b6GR2eogkBMO6LR8fe2sYADE3XwsFI0fXYUxhuteeDH8wjTy1YV10OvO
         WYBwgUQokYrAIhBflXpdKu6ulT3icWWfni7OvCRWfVdi0wJvx2DVP+eIW/YOsVGEF13k
         qrR9BrOFpTFosuspC4PyYqM1pOna9iQ8wVAPlrYpTQMskWszfMbOAbNkai920/kjIHe5
         x7SQ==
X-Gm-Message-State: AOJu0Yy8ayVDylrcw93OkWEDEQfJqsXz3PCLKk15yvlsWsLfejHl9Yl6
	s4OUhNdMQ2aQ2UEWOIwLnIA7SgVMXtC2uMz/VJn8ZRnUUTN2znHRrxGrfmEnqvFc
X-Gm-Gg: AY/fxX7yBn6NtinyOmZk2iXb9B7AU0Nx0Ku7ltuqvbUF12O6c29lZn63SsBrGFej96a
	T9/5aBq0Q8pK+0H2rx6UvIBaFjGBIoh3Sp/rDGT25GkGr4Phlwi8bADj+bbeQJU+/hvB7kCpb/p
	3uDM5FhX+sLjqHwYmSRJGKWpdCjTSxWmpd96yCsjlRZtibq5HKilFF+asfAMI/JlIX7PYvef/l8
	FUxdAX5v+4kEbAOTcfYo6slTOaA/rJIwB6+zv2d9EbhiXPHXDUZpxtGVFo6jgwRBoF2tqwFwokD
	2ozu1/wCe5ZwFjxT0wMTYFz2xHUd9MsrfZdj65lGtdy0rAgfh3s1dHqHcJqlAMYTonE7DOdFL3o
	K2LlAyK8tXi7b22iNiL8+uza7bztW2G8SRZcCB1bpXAwgwPyd3jmR3yTTqfSbtykgLgBV1P/QrI
	m161xNI4j71NPil9XKTZ084h9qlNGW6YBjuMl/
X-Google-Smtp-Source: AGHT+IGKeujsM93YqOpp0aF/Co+UOU8ukDcHdIWi2g/e58wh/7NiS7Q/R1XnW2VQWFqE3bJw4QIRUg==
X-Received: by 2002:a17:90b:1dc1:b0:34a:a16d:77c3 with SMTP id 98e67ed59e1d1-34abdc4b53fmr13190984a91.2.1765900696975;
        Tue, 16 Dec 2025 07:58:16 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.5])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34abe1ffdf0sm12292314a91.4.2025.12.16.07.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 07:58:16 -0800 (PST)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	sprasad@microsoft.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] smb: align durable reconnect v2 context to 8 byte boundary
Date: Tue, 16 Dec 2025 21:26:05 +0530
Message-ID: <20251216155605.1242530-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a 4-byte Pad to create_durable_handle_reconnect_v2 so the DH2C
create context is 8 byte aligned.
This avoids malformed CREATE contexts on reconnect.
Recent change removed this Padding, adding it back.

Fixes: 81a45de432c6 ("smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h")

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/common/smb2pdu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 28460c3d4979..f5ebbe31384a 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1293,6 +1293,7 @@ struct create_durable_handle_reconnect_v2 {
 	struct create_context_hdr ccontext;
 	__u8   Name[8];
 	struct durable_reconnect_context_v2 dcontext;
+	__u8 Pad[4];
 } __packed;
 
 /* See MS-SMB2 2.2.14.2.12 */
-- 
2.48.1

