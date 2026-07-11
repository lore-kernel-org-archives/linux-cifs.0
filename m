Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B5284690
	for <linux-cifs@vger.kernel.org>; Sat, 11 Jul 2026 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783776829; cv=none; b=SCsddmr+vdZgKJRoGhntjfvd9SWjHFn6/wkMFVolhawOhUpEZBdoNYpw0eVfl7cqDjsqMFS3+Lu8oyv/+kyd0l8CtSlH0QPA7RBnxZt1nwnvQjViUWCsiwd2/A/dppfDHSFY5VmLzORdI6JC4Qch9tAlU1CEqVArAfHrErttT3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783776829; c=relaxed/simple;
	bh=ZnX556/SgTs5R4D8I5uTvWRq0Qb0EKx6Zma/xbvdxNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IPidVgfK16Amb5MHBO/ERm2NHRr4HTk2F33gphkMIPzy/W5SVFLnaAogjeAk+sQ8FUHV2S2C1sV41wweoPaKa40yRS2fSMcYW1LI8vm6ItRdpnl7/RsUIwaQRiw8jyQWJs6xpvybijNr0/3tZKPZQCtTSVuhVlYEcCmW8waYkd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dclwXbuf; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dclwXbuf"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2caea3f742bso19917625ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 11 Jul 2026 06:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783776828; x=1784381628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KR19s9LTdwg8fzyf+W0+BdWpTP82F88oIsv5vsjL+8=;
        b=dclwXbufeOSPF4/r2U3MIOJbsVJlatFu0NI2xfyMpRoyUk1GPZoLcwcXgxkaLoJVTr
         OY2nnzJMk6xYysLf31jGPDXzFozFmJyqn+/TNfoGd4Yo151JxdYF9Bm28Ta+XYUfuFn6
         KepQRmiBwxd1EZrZVmigE9IkNEb10Vptbx4HyxyITdFQQ0W9epUVN3g5AdV9liOCvDYb
         85INCZyOAs6ZK2TfMiJMSq3R1mfq5q416HlGtRTcMT5TYnXFFcXsq6yhv/bsDVv6QLog
         HVy5V6waSsBxjpLcr9hgdYoFqBbOGitYzYI+aiIrqUSaSWV8x2bXxApuKVjop5k+HQq9
         tMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783776828; x=1784381628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KR19s9LTdwg8fzyf+W0+BdWpTP82F88oIsv5vsjL+8=;
        b=jg7+akKp7Fl4uC2kKBM1D6w2NH0C/ylcTxbzsAHbWyZEaSZjlGazyLCnawBL76Y9XM
         AwuGDnOX5LsKD/YZIC8DKXgN0QCV3oNJ0/uiKJO5tIjscWzVeFkopW9+fMFMQKC6KE3/
         uxY86mjR/Ym/fM2WeZ/DAkc49UcxtFS+bzhB//FyBJd8hVHucT+hFTGsfxN3D1khjMdW
         iN+5Xi9+YuI3uX7pOskNMkjUfhVnYVx95kh/lElPUZcEnLr+ZrRrkFltC6H2XJrmre6d
         XTbALSiEoFt63V10u4UCy3PsFBXrjePonsbxj99nduDeVvIT5rOjeDhL9Px0MyBndsde
         ryyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqa93hy85fAExxHBwFgg4e0h7vLrdO7jRXXHXCyhmD2br+kuUszckyZUs5SB4DHZW/HYHwhu+fs9EsX@vger.kernel.org
X-Gm-Message-State: AOJu0Yw37OKjejyUEt96vzp7CMOO6+JvfV5oUSBpuJqftKd3+OtdnZle
	aZ0sOo40Qz+CgIE6DKz36E123CZ1eC87K2g5Q75QvT9zG2qU7AlEEuCW
X-Gm-Gg: AfdE7ckG6FwGciZGWFiu1oRfdyxyZFRSTuy3Nh7wjkafIIN7+hvshCIldigsPetUbHb
	Zi0RXiREs/aKE+EoLGMNB//A1oxInsHg/2PZcOXv3GiKkrOnTWJWVWNs2MNfaYnp8ZS5cnktpln
	wfOj8m5usn0qVg5dU5ueowrAQjhkMv+8aG9maMtp7f6mAeqXcCYwf2hAqzANxRomSg4xYSwVzS7
	juL8LaFpvkCwRC81Ls2rFOIVDyrF6vVoLbsoM2yzq6NNkD+bbMcHq1z8zbUhFj+riXaxmv0buPF
	ytNyTbvOlL6jyLEPWmG+HDJF0qM9hZuicYmWxjvgtayPYEmB4FG7L7FwVB13tMMa6EMFOOl1knI
	yjJwuDzLBafTPTUjKHOHg+6zfcEPQERrE5pHdxHAZNYi+swSOxkeE9XSyEs1N09n3iNlm41v7zs
	ElCo0n+v7guNT2sdNE4FjCGmobcuEx1W22gvR70a3gbtTQ1oB8dF0YEx4tjPFdrFRDTqIlrKa1T
	mN17Mr69OjlPImA
X-Received: by 2002:a17:903:292:b0:2c9:97a8:8c17 with SMTP id d9443c01a7336-2ce9f28802fmr29334865ad.42.1783776827559;
        Sat, 11 Jul 2026 06:33:47 -0700 (PDT)
Received: from localhost.localdomain (116-91-131-11.east.dxpn.ucom.ne.jp. [116.91.131.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb76asm76179555ad.12.2026.07.11.06.33.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 11 Jul 2026 06:33:46 -0700 (PDT)
From: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
Subject: [PATCH] smb: client: reject overlapping data areas in SMB2 responses
Date: Sat, 11 Jul 2026 22:33:26 +0900
Message-ID: <20260711133326.94832-1-shoichiro.miyamoto@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to
responses without data area") restricted the implied bcc[0] length
exception to responses without a data area. However, the overlap
handling in __smb2_calc_size() clears data_length, which can make an
invalid response appear to have no data area and so qualify for the
exception.

Track data area overlap separately and reject such responses before
applying the length compatibility exceptions.

Fixes: 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to responses without data area")
Cc: stable@vger.kernel.org
Signed-off-by: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
---
 fs/smb/client/smb2misc.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 6270b33147d2..9068175e57cd 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -19,7 +19,8 @@
 #include "nterr.h"
 #include "cached_dir.h"
 
-static unsigned int __smb2_calc_size(void *buf, bool *have_data);
+static unsigned int __smb2_calc_size(void *buf, bool *have_data,
+				     bool *data_area_overlap);
 
 static int
 check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
@@ -148,6 +149,7 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
 	bool have_data;
+	bool data_area_overlap;
 
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
@@ -232,7 +234,12 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 	}
 
 	have_data = false;
-	calc_len = __smb2_calc_size(buf, &have_data);
+	data_area_overlap = false;
+	calc_len = __smb2_calc_size(buf, &have_data, &data_area_overlap);
+
+	/* Reject responses whose data area overlaps the fixed area. */
+	if (data_area_overlap)
+		return 1;
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -416,14 +423,15 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 }
 
 /*
- * Calculate the size of the SMB message based on the fixed header
- * portion, the number of word parameters and the data portion of the message.
- * If have_data is non-NULL, it is set to true when a non-empty data area was
- * found (data_length > 0), allowing callers to distinguish the implied bcc[0]
- * case (no data area) from an overreported data length.
+ * Calculate the size of the SMB message based on the fixed header, fixed
+ * parameter area, and variable data area.
+ *
+ * If have_data is not NULL, it is set when a non-empty data area is found.
+ * If data_area_overlap is not NULL, it is set when the data area overlaps
+ * the fixed area.
  */
 static unsigned int
-__smb2_calc_size(void *buf, bool *have_data)
+__smb2_calc_size(void *buf, bool *have_data, bool *data_area_overlap)
 {
 	struct smb2_pdu *pdu = buf;
 	struct smb2_hdr *shdr = &pdu->hdr;
@@ -432,6 +440,11 @@ __smb2_calc_size(void *buf, bool *have_data)
 	/* Structure Size has already been checked to make sure it is 64 */
 	int len = le16_to_cpu(shdr->StructureSize);
 
+	if (have_data)
+		*have_data = false;
+	if (data_area_overlap)
+		*data_area_overlap = false;
+
 	/*
 	 * StructureSize2, ie length of fixed parameter area has already
 	 * been checked to make sure it is the correct length.
@@ -454,7 +467,10 @@ __smb2_calc_size(void *buf, bool *have_data)
 		if (offset + 1 < len) {
 			cifs_dbg(VFS, "data area offset %d overlaps SMB2 header %d\n",
 				 offset + 1, len);
+			if (data_area_overlap)
+				*data_area_overlap = true;
 			data_length = 0;
+			goto calc_size_exit;
 		} else {
 			len = offset + data_length;
 		}
@@ -469,7 +485,7 @@ __smb2_calc_size(void *buf, bool *have_data)
 unsigned int
 smb2_calc_size(void *buf)
 {
-	return __smb2_calc_size(buf, NULL);
+	return __smb2_calc_size(buf, NULL, NULL);
 }
 
 /* Note: caller must free return buffer */
-- 
2.50.1 (Apple Git-155)

