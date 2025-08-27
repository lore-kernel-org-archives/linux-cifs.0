Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B1D1C1F12
	for <linux-cifs@vger.kernel.org>; Wed, 27 Aug 2025 01:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756258273; cv=none; b=QcAGfrUd5MsRTuKp9FGpgACFayWaei6yV3WnBTTpYjW7eJO5RFRhNelasMVmRcg5aeFsjLSf/7hU+bKFe2xFxjLt9caf5tz319k9bXF9/m44L5m+Vv6aW/K1DWWpt0qyPnWzQqBHGJWnT6J5KgeaQRmYiNgZV8W0ioIcx65KyS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756258273; c=relaxed/simple;
	bh=edVo3VRCz3KNlvJoSaUTgi2GBXRnI/qORJgwvaESnM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZbJaO/5CJrUabIqEWwVIlaGaUoJgl/JH508l/YPZSQ7u77JRgfjAeLzTs82pC/1UOBJIt+nY2u38f01XvATZlNmoLYiDIOVeUOwOWKeRt3EhIFD95uUH95QVLG87HTKXfxdv46SMn3JUOoSow7FUz3e3JXKUMx6Xpl19jF8g6c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-771f90a45easo1372995b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 18:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756258269; x=1756863069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mwXqCmDTarbliJ4pEIT2c0kIHLntDEMFSD/BwrOmRGo=;
        b=gKrDa/KycPSK4oYwhu2qiy9pjL47QdcDr/TaxCELX9MVyxoZggSTlgBNW8S4X7Mwi/
         UlIexEaE+LC2usPwYFTOGNJnldPoNeXBHTCxSdV1IlB1phN9muaDTFpDUUJeg1w7AoRq
         RcRQlukH+oz5cUjMkhx9yGz99pR1DzSSOLALxZlymm3ma8f5bfaPu5ibPwbukvWVtxhk
         5XF+Nm7h/sjIridwYShw0sEVSWDj+30WFakJKkcAecZEulMeDo0Owq0GWUhZFoDlWGDE
         +SMKdDXvzh/7GYr3om6wlcVyezCDG6D1FYLfW65e4ufM7+o2GoNcMG9IDfo2oOnBjxMU
         tWkQ==
X-Gm-Message-State: AOJu0YzPTYN1QD+3X2fifitRaPRPMizCoZ7qI9rGQU2GxRAm9UFbLnz6
	OGfeKutO5Bm4wxNHj62WGwR15NP5+Eosapfi/5etjqENlgxatm61UNMJKXmC2w==
X-Gm-Gg: ASbGnctpWnSiI0glxTFE1j//dgAnDRnk6j1AUuqV7GzIOsCEaiOAHy5ewRpG/T+XaMP
	DBPqX6O7bo4GbkwPNfuXLgMfgj5jOv33dmZ+YPHJwIYRjPm7UuAok/hNnLVNzSNO9wPt7tVLFGx
	5Rcq4AAbn2p8ZckoKWwbSCsGnKqYg4/iDx4b2ATXR6tyQccUQkIlmNPduMtnr+2R/REbVYSVm4V
	A09rWmm5+oYi7AGRHMO2yP/BYVZJ+KIRXjeIcXe/xL28DXtm4y2d/vZ0RWMO/K4V6oc+nWEvh1G
	x3PFb9iyY90i0bD0JIULxCxwnt3TWDny5tstuOaErUHL4SgjwyGrrHbn0OgFmDWEhjKmE7NHE6h
	tPPUfnYxcWZdGM+Ll1kcvQKJmvAHGr7Kji1OGlQ==
X-Google-Smtp-Source: AGHT+IENFolR3WkfUNNGuCqLx0xbgCFOHxmhrKeDispQDlwCdHRGhOKOxDPgiJHu+1aWfSQd1HTPQQ==
X-Received: by 2002:a05:6a20:4c99:b0:243:9c12:e51d with SMTP id adf61e73a8af0-2439c12f70fmr1189367637.47.1756258268808;
        Tue, 26 Aug 2025 18:31:08 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771ea45a022sm5852911b3a.95.2025.08.26.18.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 18:31:08 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: increase session and share hash table bits
Date: Wed, 27 Aug 2025 10:30:38 +0900
Message-Id: <20250827013038.12253-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250827013038.12253-1-linkinjeon@kernel.org>
References: <20250827013038.12253-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Increases the number of bits for the hash table from 3 to 12.
The thousands of sessions and shares can be connected.
So the current 3-bit size can lead to frequent hash collisions.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 2 +-
 fs/smb/server/mgmt/user_session.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index d3d5f99bdd34..c9b1108d6e96 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -19,7 +19,7 @@
 #include "../transport_ipc.h"
 #include "../misc.h"
 
-#define SHARE_HASH_BITS		3
+#define SHARE_HASH_BITS		12
 static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
 static DECLARE_RWSEM(shares_table_lock);
 
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 9dec4c2940bc..ed05c221b6e4 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -18,7 +18,7 @@
 
 static DEFINE_IDA(session_ida);
 
-#define SESSION_HASH_BITS		3
+#define SESSION_HASH_BITS		12
 static DEFINE_HASHTABLE(sessions_table, SESSION_HASH_BITS);
 static DECLARE_RWSEM(sessions_table_lock);
 
-- 
2.25.1

