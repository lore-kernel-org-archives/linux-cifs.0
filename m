Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678223DB303
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498981; cv=none; b=YK7HKb+nFpGPEkpbbvhoGm87PrqKkBUze1/ht+6YOsqZyPjTrJPLnh9T+ekNppnEhMUaN/FzaZR1m+ud8dY/37OF0/MO7NTBLFF1H92aIDCzksAfIS0VjQC9n3+l4L13VDta1sUA4+kLuN202KCrkIwx7mtoza+HtGv68NHmHNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498981; c=relaxed/simple;
	bh=rNWcHqMcRzNmqyo9tUfltcMhleg5Zia7Vrwzx9sm8+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UTnUc5uKq/rlSNqaX2zWOWVzKmjGMhzruIlgBUBxXgS2zumbDMaHg4arvPe7pCc0qB+UaFQWA+wRwtV/WsZXtUSFyrcXdfA6CVFWF+WURx2rgxzaNErRtHfT6Vh8d11A3sp9Ut6jzXnqkrJWNMkxZ6njGxJKaGCr9HJLnvmJD/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iogJWHOK; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iogJWHOK"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f96c5b722so549452f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 04:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785498978; x=1786103778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/zwaoatfIKYXR5omCyN8BRE5UizMFWZ9Rk+iSOdpHD8=;
        b=iogJWHOK2jwHh2ii0VwR0zjvEGw/3qZz5kgW5Pf6mhCUjbZrkMCpo9d+FK32BhxYty
         +f8bZC6hrPLyn7QbD9omUuaxz+ksS7jvlJo0iyNnglYikow3kL4/W5AfhgcvRacuL+pu
         GRdoUvo/qYOsA7yCrKD2cG0oeQiXt50YDXvSvHI8iZiMJxCvuhIbXVkoGg8qRA6jl8J4
         tp4lvJABcKn9ghjsLYXY/l9GSouivE+MmuwlvFjsyC53gg3owa9OjHW2hGlYDxoM35ki
         y4jsIqJ+l2BpHrTBTYfG4Lv1P8yHfCZYHE00J0ZzaI1Nk9bsqTQYB39rItadSxSVksiG
         lWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785498978; x=1786103778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/zwaoatfIKYXR5omCyN8BRE5UizMFWZ9Rk+iSOdpHD8=;
        b=GDM9GiBjinYRSH2FUiahZNhIUovOzIJVf+KscBA5MR6Gc/U8RaKokzHYw1CEbJeE8R
         x41HEr94nxA4aOWajLb8c6ZuSyObmJIFKOYcNNAp5DL7i98eA5yuOz6w/YR+aW6P5uxp
         ao9XctZvv69HnzZ7vaToVfuw6eVNlNcjaJukVYmJ26ra1ZpRTUDkqmoA8ptgOLhW0iSe
         IPySRrNvpecdyAJnHwJUN5o5IgJqV+vcq6IRlEbM3uDa7sC+xleDLKmesQtYZDq8LkpT
         IzuOD7C3ypjLyliNnmu68aJhe8qLDesxqe2rnUmf4cgtwMAMBfh5t9+JdNT4pRGCoZB8
         LQvQ==
X-Forwarded-Encrypted: i=1; AHgh+RpwhmCMJPDBDfKU8wspgqUGN0YTrwGB3cnHYEkpndaAzKZ6uQAwNk0FNgQICTxngrZRiI3/HyHFWWtm@vger.kernel.org
X-Gm-Message-State: AOJu0YwC0r0PyLlsMKh4zyC4h14iDzWJqDTutA4tSAbAU7T1GHl22IGm
	sHZtm5d5FKkm/VGp9BIvkizWuq4nFAoNLOcy/P4CvtekxulKx6XfplE0
X-Gm-Gg: AR+sD11Aj3jFkxMFVAS0cU7AYPhDBhzjkUwgnzv386IcGpQtnocayD21OCJodOk5TIB
	37tvSPC9bZ2vj+FbnEXfuUGe/5y/NNkTmgvNYdCg0ghjqs6t9iBxnxBBBjkxax9daD83LqhFnwl
	tsGdIwEPnzKp745xOuXwNLCHgtrMsMeyMlAdQzat8BkjYrX7txrfa6cxTdkTqToWNumE3yD0pA/
	u5YGBcQP/sreiVN3YvubDT6/c6HLFMxHdlbKA5U4CE7GycdmaEaoQY4hZny+07681YZzejOVfep
	4MAsLI8uKVZXck7C2dCAWz0981Mr29Oms9IEf3KV9NcWyN2nzGOmFggMFyNAcAJSakmQdSubJlq
	WSv+xCgew2kA8Uij83AOqLw/QsDXT0YL+ib1+kl14RDCTLTDpNJMrNqANlJ45oupRWxwHa846a/
	nSwYy9unbXPFo897kdmHU5+LJphPbL0mjZ3pXgD2FFhG7OupccBKyHRtTei4GueanzTlnYiUdVA
	5XX314Y
X-Received: by 2002:a05:6000:3111:b0:47f:9c6f:8844 with SMTP id ffacd0b85a97d-47fd2abac47mr4166786f8f.9.1785498978266;
        Fri, 31 Jul 2026 04:56:18 -0700 (PDT)
Received: from localhost.localdomain ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfdc6sm4104885f8f.8.2026.07.31.04.56.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Jul 2026 04:56:17 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: linkinjeon@kernel.org
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup
Date: Fri, 31 Jul 2026 13:54:20 +0200
Message-ID: <20260731115424.9892-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_ioctl() rejects FSCTL_PIPE_TRANSCEIVE with
STATUS_OBJECT_NAME_NOT_FOUND before fsctl_pipe_transceive() runs. RPC
pipe IDs live in sess->rpc_handle_list, a separate namespace from the
ksmbd_file table the generic ksmbd_lookup_fd_slow() gate searches, so
the lookup always misses.

Found while testing generic SMB browsing (Finder's "Connect to
Server"): every DCE/RPC bind over a named pipe (SRVSVC, WKSSVC, SAMR,
LSARPC) failed right after CREATE. Adding FSCTL_PIPE_TRANSCEIVE to the
same no_fileid_ioctl exemption as FSCTL_PIPE_WAIT fixes it, confirmed
by testing a build with and without the change.

Fixes: 0726814421c2 ("ksmbd: add SMB3 request replay support")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4bde5ab..8d6f42b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10133,6 +10133,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
 	case FSCTL_PIPE_WAIT:
+	case FSCTL_PIPE_TRANSCEIVE:
 		no_fileid_ioctl = true;
 		break;
 	default:
-- 
2.43.0

