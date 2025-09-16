Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74611D7E26
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758029703; cv=none; b=jC0xm7+MtO9DvYKosQAK6U63k9kMnV7Oi7FOiz4ZTg7oELTz7KcrF/+95YWpCB8d5O1ao7LgB+5YW9Q4qGq5YpVKoBOLHNJEkjfF3KaBXGRIO/0G/Dnnw5d07AJGZFqk7zkfTxixFLXFJN1nB1JZaePlJSbQOjIUfZYQnV1/B60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758029703; c=relaxed/simple;
	bh=//vtf7KBLP8wNjDnuVdIzInjJkZ1AOf0yIxKyA6g7KA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H6L9w82FmLr0KrNz4YEek7tEy8nR5J7g44gY9XvKkHro2wEHb5iM1QczSolps+8HQrSIex5F7DT/ItF83IUQHxAVjfeq47apnmWf8p8mfaTp6PWEGpbBliUfd/XD571Kd1umR3G+ubRL7hdFRLkAKvm7+txttVsCbESQCXPyiQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXvozR+k; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXvozR+k"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso3353198a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 06:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758029701; x=1758634501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGdZ1U+V2NFFvFPJSzcihUR/PRa9vzcV2OweoUUeifU=;
        b=SXvozR+k6SZSCAjXjkAkC3aJnmO2Cul6ENZJvgQfAiVosEMG2umYldF5ZKDlqF4hI6
         13kdVC7sVVMKTBFbsm9eME2orDhKGatJaX2E8ajSNHvX7/HC9uQyVttNYu0UYYNNfqJx
         g9uZ21kWoG/aNMZnW0uHUPAUwxwE0tt67piPk7J8+bd9UngUj0haQwl58A3Rz40KVJUd
         n+sSvZlRfaANrPdwurCUsxcNsW6/A+QXNy8Kag75+Gu9R8rurwgz/l0DybnmiuOPNYtu
         2kqpQO1FMuBVFdcJrzTI8y6gEh9MR1GMyCe43fh8k+SEfVgv4yAMuc7H0nlhb4Mha14Q
         5MWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758029701; x=1758634501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGdZ1U+V2NFFvFPJSzcihUR/PRa9vzcV2OweoUUeifU=;
        b=YwfJTzT5gwKyLedAWGsOqktx9y2EVrkIc/fOMg1rmLxHqwzGW9AeriQmB9ug+G4guQ
         iGEs1+GYwQMHB8u4rEpBOV8Rkdwk4Pgt+qziDd6O6JWu/LhRWtm4B4mkgNw0ZS73h4zQ
         v0894On3T732EzBsPRLSc4HJServ5qGNSbXlC4E4Xc2q/RLaHyXZcEd4Ln5x46TpKF0x
         B/OsKlvHRL2av8PxIjBo3lDkfBUjN0M1DxN1BfFhYm62HJbSxcMBIuhj0aJbDw7KMwcB
         WWeLnSj4IBAF5TGb5gGeuMkeMTu+oRtet5zqtTMzDNCeMMWgtzFkUh0/MA5AlQ3vysmf
         H4Vw==
X-Gm-Message-State: AOJu0YxXKrOr58BlPhD+c80fAqd4lL8eKQut8yQKdv1ZW3TFCxdu8JWu
	AEchsH67MJyPQ//miaVadJmGUT7wTyu4Tiiy8YnzIQXTu7yYb61GgcLgXPe+cg==
X-Gm-Gg: ASbGncvM3F/EKgLwKtS8MLk7KhtifUN+7QPSy5R3vanqMe+PGOr+h48K8VrWRh3XJnN
	HBzlbohUXW3QU7gbaM/hZq4vKur6O4l5ed1+Fcsvbqjn0N887Qks/P77EBXGrn7W6xmISujRffP
	s2jPKV63xU2ZIy1J+hyWohcw5vhxAhfRDMu1nISAnn65hPGSID6t1ACHTLs2v4JX9OJeqtdZPvy
	iaov/0paElIx97WejriEk2fDOw1CyKuyTLDxqJAMqzn0B/CQtGnDGS2zwsEgJda6JQwJsGewrIC
	QrksY8r3v46OgnLZ6Jc7omJkigYIZ0sUiqDeNkapfGuufyfcAMErnj98f3C2oe3xSduJD1W5tRM
	msPfEv+mYDRg1CN2M
X-Google-Smtp-Source: AGHT+IExfIJl4eS8x/rm/LUKt8KxuwufB4hRHRQa19rZiCZ5SUruOuB1fMMGikaoXeoxyBAeEwXx/A==
X-Received: by 2002:a17:902:ce09:b0:267:ba92:4d19 with SMTP id d9443c01a7336-267ba924ff4mr53295715ad.0.1758029700940;
        Tue, 16 Sep 2025 06:35:00 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267943346f1sm51578905ad.14.2025.09.16.06.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:35:00 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [RFC PATCH 0/2] smb: client: support directory change tracking
Date: Tue, 16 Sep 2025 22:34:35 +0900
Message-ID: <20250916133437.713064-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello, Steve 

This RFC patch series implements directory change tracking logic for the
SMB2+ client using the SMB2 Change Notify protocol. When directory
monitoring is needed, we send a Change Notify request that remains
pending on the server until changes occur. When the server responds with
change events, we convert responds to fsnotify event and broadcast them.

If the connections is disrupted, we stop tracking and resume after
reconnection completes. Also, we stop tracking when unmount occurs.
Cleanup workers run periodically to free tracking structures for
directories that are no longer being watched.

This feature is related to f-section of TODO kernel docs.

Points for discussion:
 1. This feature generates additional request/response traffic between
server and client. Is the overhead is acceptable?
 2. The cleanup worker's working period is proper? Should this interval
be configurable?
 3. Should we add a mount option to control this feature at mount time
rather than only having a compile-time CONFIG option? Or maybe apply
both? 
 4. Are there any potential of user-space breaking? Or other
vulnerability.

Future improvements:
 1. More sophisticated approach to when tracking should
start/resume/stop to reduce unnecessary calls and checks.
 2. improvementse Change Notify response process with various error code
and scenarios.

Basic functionality testing was performed on Ubuntu desktop with this
patchset applied, against both Windows 10 Home Server and RPI3 Samba
server environments. Also, Edge case testing may be insufficient, and I
would appreciate any help with additional test scenarios if possible.

My approach may be incorrect or incomplete in places. Please let me know
about thest issues without blame - I'm eager to learn and apply better
methods.

Thank you for taking your valuable time to review this work.

Best Regrads,
Sang-Heon Jeon

Sang-Heon Jeon (2):
  smb: client: export SMB2_notify_init for directory change tracking
  smb: client: add directory change tracking via SMB2 Change Notify

 fs/smb/client/Kconfig     |  17 ++
 fs/smb/client/Makefile    |   2 +
 fs/smb/client/connect.c   |   6 +
 fs/smb/client/notify.c    | 528 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/notify.h    |  19 ++
 fs/smb/client/readdir.c   |   9 +
 fs/smb/client/smb2pdu.c   |   8 +-
 fs/smb/client/smb2proto.h |   4 +
 8 files changed, 592 insertions(+), 1 deletion(-)
 create mode 100644 fs/smb/client/notify.c
 create mode 100644 fs/smb/client/notify.h

-- 
2.43.0

