Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4212F5A
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 04:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732335454; cv=none; b=fOyk2Qx5RRgofUizZKC1lMTB2xfNKYYw+xA+FRhgnCp5R6/PMpOMeGCv4fCQMRmZfr+CZqi7XPvBCvDCUVlzgCDPXpjUormBMHPt4+6g52j1qbOyiAQAbGXQSuwv/FET16ucfMISwt/LMPUlmJ1suvT5L26hom+zCHWxF/SeR6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732335454; c=relaxed/simple;
	bh=6yocvjo1r+idSb8E2R9bWHVREUuXmN46JETSQqUjeV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bdhWAZp5+0JIQNz3JdDtkpx5CqJ4R/JtJQkpQct57e7xNXFwyg3r1rh41wo5PX4RhU0ACR9Wyg14x/qsUGbuEC6Sf/K9cZ1+NI7gTE64Mm4NUo8lyU3HLr5LD8Ppp7d394MsfbE0fp7ZSoJCB/C9muAemtviR3aJeA6Hr6d39aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-72483f6e2fbso2523167b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:17:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732335452; x=1732940252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=elRqtsOhafesboR0UUM6ApYKR1KbOa9jnnWd8nAoTrA=;
        b=B58P+VJ7ANd9UJwch824y+Ck6U2O/ie1Zq2YbeAFUPM88/ATboyD7YXi36Ym4x4Iiw
         1sDXibZJHxtSiXNlpprsqqcQ9QY9IstaAg8A81SzaJidpxFcZQfZWxR72XLh3FoPTyq/
         MsWWcnwH0lKsf0IO0Vawuue51oUYdlDQ0iLKygf8vyrwEdlTQL3/6L3owyAhDg9P+iA+
         BBRWm8D7V1qK47ryBhbg0JE2o5u9V3fKGfzJhKgk1eBV/7/WVjwDhbogVMENKijeOTlw
         jol9r7YKuwoE+r2/DdckefRj90XMA79LhWvN2IP5tyd7odLICsfnJc3hd2RDZrbk8gwE
         UBnA==
X-Gm-Message-State: AOJu0YzgF5BBRd7UZ3FWFknaBDKQWw8yXuFUXVu5Ab36uJJgDQmvTU5c
	U6kWoKTzhdX0iwZu95xxNRv3cQy/1KvkLZEFrFvIuC3dFCTGUMK8v3DURA==
X-Gm-Gg: ASbGncv30ScAVirXdY+vsmS5oF9ipBLR2cK35YV0bycpksb6HXcmbXRBWswXyBNrzLI
	sPZ+7V/jUqWr10s/Qm6wSPRnQArvneUa4YIWIg+0AOLup7fCRVYc1eScWtPdSs578sRmG/fHgIx
	I7jgosjn34O/qZ3wAsOMoIhLNkcQeJSh45MQgxR6snkbO+CVhYlIBGrowq/MlQp9dJIln3eYGjE
	VcWgTzoOIjhUfv+uY8yPhNZ/GEhDziBz3N7qQf+r9D9HOWklsoQTd+3CVlRj1i2
X-Google-Smtp-Source: AGHT+IGaGTNtiUj7R0ANPzTg4mxaFxfpfK2Et3ecxQqe6HxL4kuBuzD9AhfXg3ZsZGOrht4f31QPjA==
X-Received: by 2002:a17:903:228f:b0:211:f8c8:373d with SMTP id d9443c01a7336-2129f609982mr88666205ad.31.1732335451948;
        Fri, 22 Nov 2024 20:17:31 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dba20e2sm24437805ad.94.2024.11.22.20.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 20:17:31 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/6] ksmbd: add debug print for pending request during server shutdown
Date: Sat, 23 Nov 2024 13:17:05 +0900
Message-Id: <20241123041706.4943-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241123041706.4943-1-linkinjeon@kernel.org>
References: <20241123041706.4943-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to know how many pending requests are left at the end of server
shutdown. That means we need to know how long the server will wait
to process pending requests in case of a server shutdown.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 23c5ff84c9eb..a329e6c9076e 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -404,6 +404,7 @@ int ksmbd_conn_handler_loop(void *p)
 out:
 	ksmbd_conn_set_releasing(conn);
 	/* Wait till all reference dropped to the Server object*/
+	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
 
 	if (IS_ENABLED(CONFIG_UNICODE))
-- 
2.25.1

