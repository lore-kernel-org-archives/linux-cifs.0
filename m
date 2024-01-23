Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91F612FF
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970760; cv=none; b=QReVxTiZYq8mByNNt5EX24QDXBgtPLYUIiJxCJO6nYYwg98n6shAKTMk4qD5WEgtsNYeodDr458Y9bdzO5Tbddbv47Agi2Nt0flMyN6bIXQaK8t8Gl5kTztuk0Qws0YSqhUC5+2RdQx9GU92KuiXY+8eZtNz+aTf3L6UmbLmTow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970760; c=relaxed/simple;
	bh=pqahPWCtiilVxi2Cwewikz7N45reJkQJ7UJUXEGvxo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n/OaiV+Us5RfskhcdpbF7iTmvNdRiK8tBxZ+IXNdHq1iqNlIFr2XN6uuLp8iPmnzw7rGfR5Nb5AW5+kKo4fRa0fRQRU75FtoxUd/PFiWcPPNTfgym9ynNbdeWzKHZS9w4EWR+8gHoeuwleFTWjk79LR3O8r/jroy/hkAn+oaWTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=QsDkKLfB; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QsDkKLfB"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2907748497dso1579348a91.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 16:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705970757; x=1706575557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRtEgA24maRm+G5gcEke23eL30Vj6MIdNe5RQrjo/8E=;
        b=QsDkKLfBWO7BdvpXfam5uZ0BIQsXQUO1qqd6M4QpYpsO6sd9MIZZXJRrNzTO65Y+hQ
         VoqSbft5M1Ckz5+NXB7r1zvru8OJj2GpsyfbuQVY0xcJkP/hmvGl+woNudrUVbPI+/EG
         fK1awRwMQqC+OwibXTaOtxGj+3ZYu6pnwWa9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705970757; x=1706575557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRtEgA24maRm+G5gcEke23eL30Vj6MIdNe5RQrjo/8E=;
        b=LesUNv4eRE9Cuv5S+rF1jjTEhwfQqIVZtLYvj6xJ4NsIxBgDnsw/+mL1JZpyvagIuT
         l3YX53bOFMCrAZVqTzx42Usx5ApIl4L21VHeHWMP390gKqDhdaDh13/y/O48SbQ/35bU
         nKwRZ52y1m/lQnCpC2oz/B5zwAYq67I2po1+1vU2k2ZD2UUPoedp5Rg5QOtKg9tRH5Z7
         aTnV9HyMdUTXHVH3O3NKrTO0xzXYRFtciMbALfuwSt/RQGfSpE84SxmGFmuXptRq95Qg
         HkWYHrgKW3CCcQ2feU5snIAQL2S6hexz0wCCLMooYywQHZtcoZFSM1LWmeXoUtmC98ag
         BRJw==
X-Gm-Message-State: AOJu0YwJB3qdrPUYKNNgoNg7nZ9czzty45jA0DxtAZzFf7c5qSwcVTlb
	DxBOnxtLmzEQFZzEvzllYij4cZxFVVMeA4AHDYK2TUO+hdrDnDQbLQ3RPp5TIA==
X-Google-Smtp-Source: AGHT+IFciWHO78/a7euH6rqJvtMdI+gSwn5MfNBM1NW2JHf/Lhr+OJ/TN/dJXuWD57I9PPPQxJ44Rw==
X-Received: by 2002:a17:90a:3941:b0:290:caf7:7a16 with SMTP id n1-20020a17090a394100b00290caf77a16mr435126pjf.0.1705970757093;
        Mon, 22 Jan 2024 16:45:57 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id so18-20020a17090b1f9200b002909c6bf228sm3237373pjb.51.2024.01.22.16.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 16:45:55 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/82] smb: client: Refactor intentional wrap-around calculation
Date: Mon, 22 Jan 2024 16:26:49 -0800
Message-Id: <20240123002814.1396804-14-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122235208.work.748-kees@kernel.org>
References: <20240122235208.work.748-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2356; i=keescook@chromium.org;
 h=from:subject; bh=pqahPWCtiilVxi2Cwewikz7N45reJkQJ7UJUXEGvxo0=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlrwgF+RrezY1R+vJeoB3MoQno65kcsaFJYE8T7
 TFT3XWlULSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZa8IBQAKCRCJcvTf3G3A
 JghND/9sxXRpGBChydX6oXKHlWt5zCT0j1qCewzIX5EZfL6bLAAMMvbrryh0Kxi9Sj4hqZGsIHg
 LtEJVktXPEirje72RefP1RpOxo01UzeUOLmDOWUHMoB4B0z+XubPvEaAaQ93LFS0A5Cf2GSblOc
 Hx+I37mBMNSY3YGAsN9F86amVO0lc8gZY8oppvXg0goQD2o031eriElKHB3uK26o2m9SokcDyZW
 Q4di9IdRGvGZ4IPTbQ0R5Uc/QqdPqSBZ/tJyncI0bhVLAYKfqLdKCWvKzpFkbsxSnLFey7WJTtL
 N6JxOZoVgb+cu14E6OubQIRM4a2MF6lWjK/TSXxKa741TuGCCZWHVWy8HfQg/nEehtsBojQR5Ke
 n4ZK0eZDc+TVrnTYX09u87bgIwCCnlVBad9RNxR6MYfbB5PCTvmdApJodAX+eamo/22YvttIlV2
 lHj7KOeoKn1Ybl67n+iX3eJgQ4EssmZnEZG7XmODkiw6AR1iDdWqIvIfoThRxBNs46UjYdzaIa/
 KZn9l3Z/958uJ9DYefApgztvC4i06O+FIGSIYVn45yV+CgRlLA9VZjRlrzzgLoEgZrklYDey13J
 IlbCxjn/tjXnvRrqNAWm/i7hglaOoYH5il7sEsia1iH8bIkOkbWmiSISrRcH/ojibVnpKp/vaxx ikviov4jRF0L/Hg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In an effort to separate intentional arithmetic wrap-around from
unexpected wrap-around, we need to refactor places that depend on this
kind of math. One of the most common code patterns of this is:

	VAR + value < VAR

Notably, this is considered "undefined behavior" for signed and pointer
types, which the kernel works around by using the -fno-strict-overflow
option in the build[1] (which used to just be -fwrapv). Regardless, we
want to get the kernel source to the position where we can meaningfully
instrument arithmetic wrap-around conditions and catch them when they
are unexpected, regardless of whether they are signed[2], unsigned[3],
or pointer[4] types.

Refactor open-coded pointer wrap-around addition test to use
check_add_overflow(), retaining the result for later usage (which removes
the redundant open-coded addition). This paves the way to enabling the
wrap-around sanitizer in the future.

Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
Link: https://github.com/KSPP/linux/issues/26 [2]
Link: https://github.com/KSPP/linux/issues/27 [3]
Link: https://github.com/KSPP/linux/issues/344 [4]
Cc: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/smb/client/readdir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 94255401b38d..7715297359ab 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -467,12 +467,13 @@ static char *nxt_dir_entry(char *old_entry, char *end_of_smb, int level)
 				pfData->FileNameLength;
 	} else {
 		u32 next_offset = le32_to_cpu(pDirInfo->NextEntryOffset);
+		char *sum;
 
-		if (old_entry + next_offset < old_entry) {
+		if (check_add_overflow(old_entry, next_offset, &sum)) {
 			cifs_dbg(VFS, "Invalid offset %u\n", next_offset);
 			return NULL;
 		}
-		new_entry = old_entry + next_offset;
+		new_entry = sum;
 	}
 	cifs_dbg(FYI, "new entry %p old entry %p\n", new_entry, old_entry);
 	/* validate that new_entry is not past end of SMB */
-- 
2.34.1

