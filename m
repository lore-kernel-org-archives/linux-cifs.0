Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5C840911E;
	Wed,  2 Sep 2026 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788339975; cv=none; b=V4xZv5rD+mofJmtPDJKSP3Uh37QICDA6GstgxOWWnWhTsjASP4yQkrVV8Pe6DVCa27LQuOAc8G52oC+Z9PggBczN2Iljh5db9C91KOz5yGxwqgDAwaevdQrT6amwcIESa3tP6PvxWwN/nK8wdgAtjF9h/qn0mV8rS1SqFpg1F3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788339975; c=relaxed/simple;
	bh=OL8pezibu1sZKgmBbb/KKGocBjXbEF/upSuefYiWRXE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XUQ5iH3Un1hAUZqcgIjfsJQT/fvqI/goSn9YwndqJbOjJzcWTnYVJZCDgsbVbssu9WSoT2/p1ewfU3iqiLK88K3OUaHfxlhVfU9QJm8iyg556S1bf/v5QX33KpE8QK7+QLI4IciHwYGx3LqpTeUAaQbmH+Y5VaDRZPOeEPJagyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGEpyxDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGEpyxDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBF71F000E9;
	Wed,  2 Sep 2026 09:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788339974;
	bh=6CYp1/HI+BbqHD4xZRKqNmiIOhiKS8zhCxcWbdPCjHk=;
	h=From:To:Cc:Subject:Date;
	b=mGEpyxDdqua2Paa7umR+y7n8n28h1Te9JEehflXsyMJQ8qaZvhSrTSqA36+J1TBeL
	 ORQPL6JcXKrvA7lzXwIOFWa9MENRSRAK7eVGW9Qd1DTgjm2IHYO+CQzefAGrcYJaMr
	 8oj37LtaTOm2CIEafFXykbGnvk/5CGdzujsPNw+oetZ+fxofbwIDi2TJowmxZLP3L7
	 +Yg/l8Bjm9BkchZirwcRYnTVtbZrE9EplvXlvHZgxxhwgjcS6lGbjMnHedIyOTDZst
	 aQOVr2zBE9+LQENfZrYc6UTpjTLU1Mqh6Ej9ee/R5/99vNSAzckxBpVgpzU6XgmOsr
	 TodsOmeF1sm6g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	linux-kernel@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] ksmbd: fix sparc build with atomic work state
Date: Wed,  2 Sep 2026 18:05:41 +0900
Message-Id: <20260902090541.8060-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use an unsigned int for the work state so xchg() uses a supported
4-byte operation on sparc.

Fixes: d12168084c8c ("ksmbd: safely drain sessions during logoff")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609021157.8f7Wx34I-lkp@intel.com/
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/ksmbd_work.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 5f1d3ebab4fb..0844aa929f55 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -82,7 +82,7 @@ struct ksmbd_work {
 	/* Contiguous SMB2 compression transform owned by this work item. */
 	void				*compress_buf;
 
-	unsigned char			state;
+	unsigned int			state;
 	/* No response for cancelled request */
 	bool                            send_no_response:1;
 	/* Request is encrypted */
-- 
2.25.1

