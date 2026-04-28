Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ADB35A384
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391761; cv=none; b=HlX3nPAaYHENAandpeK6ZD5AqO6sNH/nBqxo/6YgHTjUmduyKrukyYKtTa1sWGs1ALvXwmYhwx4mgbO3oKdyCFVdL41LugojZgOfgdcuf+Vc9VuJyT78iOZz9vJaXxhsFw2xFU7C4211BiMYTF8q9Nl3Qx8mv3W+kbOEc9OVNuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391761; c=relaxed/simple;
	bh=o9AxzB6iTIxvV3zczxNnobMq6mUvwYWWzYA0xI/jRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ck2C3m8w6NCw2S+qhmpOkHB9/Jh6MuV66e0m1k0M8X3hAOv9kMMCcE09HUUlZeTCbKagNNcruvmvfVVjqsz6NJcEN3NwdXmlXpl7b/YjldDnfykAXhoOT6AQnjgmvG/Jbq6TgpUGbToNSSB0T4Hi/Yi1bBWl9rHRNbeA+CTf4oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y3kmdTXR; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y3kmdTXR"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso107646305e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391758; x=1777996558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HaDqba+Z9YUDbJcQeyPUHQc2cEFoh6ewPsWR4yOwgNI=;
        b=Y3kmdTXRWvhZo/uEnjuw9CS1lYvLVxiXO336zVicZBJIsYpzaWqCfAW2WhMeEd/y3J
         RqE9rOCzpV3xpxmpZiG0zX14m0VVk/MAfWHu1O2YH/27p9e8ls3lFwi4GABfYPSJhIB4
         Wjd40u/PPw2cXTwzTDcIfVLcmdiWMv/gXpoGlwdTNukXi0CaRbL45+as/5ApYM9S7x38
         Szl/5W47kdXupxZYpXNsdrj4/1chfy9qBMaMidzbtmiebml2HnGbcAsnqjKgILwB6LVH
         FmmEemy8bjCct9ed1ElcRuj5wweOmeqyWACymaOxSHiSVup1GW8BgDdpj1/C5TIetGNZ
         FXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391758; x=1777996558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HaDqba+Z9YUDbJcQeyPUHQc2cEFoh6ewPsWR4yOwgNI=;
        b=nGto9tQIae7HdVUpZTmwr7w+FZK0aoQA16Xl0SO8OR2T4/5uf+3YESbUl1r0K7UxIy
         V2vM4/XFETL5WQOyFu+DPqIIuwlwvvje8AHoGWSL8jfJgSI77qVg77xZegrae0DrCfvU
         0F7rqV5eJQq7LW/HFYN8G1Tp2wTEmTuboS9e2Nv1jwIQpGeQ31hmwKIMaKpyBbcfSn9P
         HNZICafW59jIfv0ziVX85Jj4KgKBslXyZf3+D2qkFhwAZSczWuXXqej6gIA9IwmZNC9A
         +MLYLEGkj/wgnQuQlpWAKDDBKAOWw/zkRqc107IlOAwRxe8yEHRLa5PcsotKunjZrEDe
         POIQ==
X-Gm-Message-State: AOJu0Yymy5XZbAWUhDaCwWM36HghlPtDSngDovx7gPDUCpfjygePRJSB
	LQLnJAW2wultUw4nXnydOUuppy/XkDPdA+Gh3nww30BeGDxJBJQ3Fyldgi+Ux8TyjOOAC9W82ez
	8pgLGVvwP6w==
X-Gm-Gg: AeBDiesWhtzQCcKLgN3Prgyx05PdXo69wsjilxxLukD9+lje3MSbcMwSN7WElu2ysGk
	bG7Ws1EQuxpYvCHtp0xoFwk236lR+MzGtcHxyhElu0W1LGjDEYRsphFMsitU0eKSYm6ZZa1kdq7
	iZ49QNo9k/Zwb0fD5vvlONpbeCZZtBQ+o/gK3/q7sjff3we66hxNwTeRqysLMxPo9YPVcEFk8y+
	ERXTrjE4Z1I/lQ704H9pUS5BzyhMHQE9PaXz8A6WEzk77EjrSKfJOsfD/UYkic218Ktvw3kIMR5
	Grg4pkYE3GXazwyLeTM11SK3jNfmVCMUECSUGjJP2PiAnH5yh2kQSCuRvECl2FftO1010ceYrDh
	0LZr5HFxXTrDYxz29xxusGcBkbPfTXDPka5uIpp4F/O8dsmczJ+HCn+XvjFJh4K8/lfkLNcBcqR
	zGyRJsS5WwpZpdBgn7qwZ4SAC4gl2dYc+JQ1hD5zwH/CKx
X-Received: by 2002:a05:600c:c091:b0:48a:58ae:9938 with SMTP id 5b1f17b1804b1-48a77b19957mr42724765e9.19.1777391757646;
        Tue, 28 Apr 2026 08:55:57 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775f56fcsm23475685e9.25.2026.04.28.08.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:55:57 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 01/11] smb: common: add smb_tls struct shared by client and server
Date: Tue, 28 Apr 2026 12:55:39 -0300
Message-ID: <20260428155542.226234-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155542.226234-1-henrique.carvalho@suse.com>
References: <20260428155542.226234-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both the SMB client (mount path) and ksmbd server (accept path) need
to drive a TLS handshake over their accepted/connected QUIC socket
via the kernel handshake API.

Pull the small bit of state shared between the two callers - the
completion, status and peerid populated by the handshake callback,
and the tls_handshake_args structure passed to
tls_{client,server}_hello_x509() - into one common header in
fs/smb/common/smbglob.h.

Define SMB_TLS_TIMEOUT_MS (3000) here as well so client and server
agree on the handshake timeout.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/common/smbglob.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
index 4e33d91cdc9d..a08d804af0ed 100644
--- a/fs/smb/common/smbglob.h
+++ b/fs/smb/common/smbglob.h
@@ -11,6 +11,9 @@
 #ifndef _COMMON_SMB_GLOB_H
 #define _COMMON_SMB_GLOB_H
 
+#include <net/sock.h>
+#include <net/handshake.h>
+
 struct smb_version_values {
 	char		*version_string;
 	__u16		protocol_id;
@@ -66,4 +69,13 @@ static inline void inc_rfc1001_len(void *buf, int count)
 
 #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
 
+struct smb_tls {
+	struct completion handshake_done;
+	int status;
+	key_serial_t peerid;
+	struct tls_handshake_args args;
+};
+
+#define SMB_TLS_TIMEOUT_MS 3000
+
 #endif	/* _COMMON_SMB_GLOB_H */
-- 
2.53.0

