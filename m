Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7691A08AF
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 22:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777586782; cv=none; b=R02+63QEToYhwfHFC5e805Pvmvp8Dxc3FTC5CTIvwPIwo3evw1rJU0pSBmArkn+1wuiyVExiUiqzjy6J7SH16exIkMeroi4BhS6Ae/Lw132lPV6PN4ffrrWimPMYqE6hZCV42DtQggRc4MvsjoXjGbJHawcGhkCU2blJK0Y1EmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777586782; c=relaxed/simple;
	bh=eT6EIBZi9rcXmuu3voYecfDsErBQjfP+qHIsnasVWgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CaVHU6hEJQ7gaV+EQdcMgZ1YWmx4NS/Y3/LmscahP1U59Y013VG8rpQ2VRnVnilFnU9uG4pWNvG5wwgzxVmIwgyUiM4GZHFyXPks2KtL5nY0jVoZoeCSPfs7NXdsPh+9UzXKd9OJVYm4CQLf/bQU+OkmX6O2nDS1R56q1Y+yY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqSD8WzE; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqSD8WzE"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-834da62e52dso724797b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 15:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777586780; x=1778191580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/dA6RZLZIEwYVmfS2bByylL2+V02+Ice5FzEDwkLVw8=;
        b=VqSD8WzEbezPfkcbesmmwRzb+yvLA4sRjt9hC6CIC5YFeCg3dG5+LuQi3a8RD8A+Yl
         l6EYRnqer/7LQXSzqzTMeOTxuj3ESDFnPtaVRQNNmsgJq1tCIwORdKKZDGSEYHcdvC3l
         ZsKFxo5E0Lu4yQZIc0fJy2DppikQLSGzfjtQTh+8kR9GmMvJLWFA3B34ZdPLYb+jNgLp
         T49jfxZ8UCddMdwm5d3zh1J7dqv5DA++Yi1a4+BSR+HM2vvew02uf3lR7GEXQw1CPyEu
         rJoKOsGoR1bZ1tbChH41jATOb2KzdETurjskorC0OpS6DEH75Qi9WEmT3fVhblfGoQ6a
         zzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777586780; x=1778191580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dA6RZLZIEwYVmfS2bByylL2+V02+Ice5FzEDwkLVw8=;
        b=Ln2HwV7fo69LThX7cigk2DWAbqOPtY6cLPG/vwOwu+ozWJwS4xIKEbST6MMgUgvf4i
         Zdym2e9aE/TFzF3wVRurPnP9utxeUX7C2tZ2sp/7pf9tA9H+ZoGleDHXhLWRf0EFXB2d
         D33N35sM/zXxd2hH9l/ngpSRR5za1QKQeMeMLZIeX9sB/nN4TWBHW2EV1X739l8V2pbR
         5vUPSnE+TESY3+1qmDC1Zlj70CjEylY8l98dowxJyKVO+UpRh0dTuNU86kg7pPoPEjck
         XJOd29Cg1PK5aRYkNE/MkiqpkNSLcTze2b2+HSSDSip0POOOEb6UKvUOo92NireiFCD/
         5A7Q==
X-Gm-Message-State: AOJu0Yz96Xqoq/506Q/iKPu7ZBKoqkLSZ9t4P9l9hjTCuFh6cRh6VXMI
	1aqJM0/92X3PiTB0bV6G49JU00VMxEqVtUDWcx29K66kdeAJQMCjFOsN0m9DToSi
X-Gm-Gg: AeBDietwF6/2lAqtF63tqpZhMBa43QiB1RGfJuiDeXGVyPt0ik9+xyZ+xjP+6Qx24l6
	W/39ESMEmIFgGKkwgLEY0T8PG9hzyX6TGLh7pUBIh9LOiwTboJud+aZWxjTeLOTl+hsDrA+xXSn
	iR93aQ/GAenJyZTvu2PaarC1DMMIDb8vsjK5oXGSVfCFbB1fb926KGRVdjTpdNqO6qkf+tbfHXt
	e6AxmPFFysr+LOzTAlAyGSakP2G7zZSQ5DR14FFQ5Sel5YfcBnuz4KKtFK8oyzhCGS4tb0pxGT7
	1KDBaewQS0FFGrGjcCJv5GRWW04u2QGUrhka8KrvDkovk6pDqkPocCCT9l7AjUd23VK+BAYgHcG
	wTt1UYf8IIr7RBiwk23F5kohkumVoS8+yU/lWLg5BuO6+1NkOEfc+rLtjE315v3msWZK5+pqtF6
	AlUDAaD3ngslCJwNe5GGAeMtc1kzObqnWrGpEIvdYaxt/ZmWmwAv9GWebKj3mX0OC2reTBm0E96
	y982pZ6axiG3Bb5ZStIUJBg7I3c2Ol+Iyc5SZPJi8yxWw==
X-Received: by 2002:a05:6a00:a586:b0:81f:4a36:1c7c with SMTP id d2e1a72fcca58-834fdbd1642mr5647846b3a.23.1777586779877;
        Thu, 30 Apr 2026 15:06:19 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b5b921sm697669b3a.54.2026.04.30.15.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 15:06:19 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org (moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] cifssmb: use struct_offset in memcpy calculations
Date: Thu, 30 Apr 2026 15:06:01 -0700
Message-ID: <20260430220601.76266-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It seems W=1/FORTIFY_SOURCE is getting confused about the math here.

Use struct_offset to point FORTIFY_SOURCE to the correct place.

Remove response_data variables and directly apply to memcpy. Simpler
and avoids excess casting.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 fs/smb/client/cifssmb.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3990a9012264..8598cec5ebbd 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4090,9 +4090,9 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 				      get_bcc(&pSMBr->hdr), 40);
 		else if (pFindData) {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			memcpy((char *) pFindData,
-			       (char *) &pSMBr->hdr.Protocol +
-			       data_offset, sizeof(FILE_ALL_INFO));
+			memcpy(pFindData,
+			       (char *)pSMBr + struct_offset(pSMBr, hdr.Protocol) + data_offset,
+			       sizeof(FILE_ALL_INFO));
 		} else
 		    rc = -ENOMEM;
 	}
@@ -4264,9 +4264,8 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 				      get_bcc(&pSMBr->hdr), sizeof(FILE_UNIX_BASIC_INFO));
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			memcpy((char *) pFindData,
-			       (char *) &pSMBr->hdr.Protocol +
-			       data_offset,
+			memcpy(pFindData,
+			       (char *)pSMBr + struct_offset(pSMBr, hdr.Protocol) + data_offset,
 			       sizeof(FILE_UNIX_BASIC_INFO));
 		}
 	}
@@ -4349,9 +4348,8 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 				      get_bcc(&pSMBr->hdr), sizeof(FILE_UNIX_BASIC_INFO));
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			memcpy((char *) pFindData,
-			       (char *) &pSMBr->hdr.Protocol +
-			       data_offset,
+			memcpy(pFindData,
+			       (char *)pSMBr + struct_offset(pSMBr, hdr.Protocol) + data_offset,
 			       sizeof(FILE_UNIX_BASIC_INFO));
 		}
 	}
@@ -5079,7 +5077,6 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
 /* level 0x105  SMB_QUERY_FILE_SYSTEM_INFO */
 	TRANSACTION2_QFSI_REQ *pSMB = NULL;
 	TRANSACTION2_QFSI_RSP *pSMBr = NULL;
-	FILE_SYSTEM_ATTRIBUTE_INFO *response_data;
 	unsigned int in_len;
 	int rc = 0;
 	int bytes_returned = 0;
@@ -5130,11 +5127,8 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
 				      get_bcc(&pSMBr->hdr), 13);
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			response_data =
-			    (FILE_SYSTEM_ATTRIBUTE_INFO
-			     *) (((char *) &pSMBr->hdr.Protocol) +
-				 data_offset);
-			memcpy(&tcon->fsAttrInfo, response_data,
+			memcpy(&tcon->fsAttrInfo,
+			       (char *)pSMBr + struct_offset(pSMBr, hdr.Protocol) + data_offset,
 			       sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
 		}
 	}
@@ -5152,7 +5146,6 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
 /* level 0x104 SMB_QUERY_FILE_SYSTEM_INFO */
 	TRANSACTION2_QFSI_REQ *pSMB = NULL;
 	TRANSACTION2_QFSI_RSP *pSMBr = NULL;
-	FILE_SYSTEM_DEVICE_INFO *response_data;
 	unsigned int in_len;
 	int rc = 0;
 	int bytes_returned = 0;
@@ -5205,11 +5198,8 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
 				      sizeof(FILE_SYSTEM_DEVICE_INFO));
 		else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			response_data =
-			    (FILE_SYSTEM_DEVICE_INFO *)
-				(((char *) &pSMBr->hdr.Protocol) +
-				 data_offset);
-			memcpy(&tcon->fsDevInfo, response_data,
+			memcpy(&tcon->fsDevInfo,
+			       (char *)pSMBr + struct_offset(pSMBr, hdr.Protocol) + data_offset,
 			       sizeof(FILE_SYSTEM_DEVICE_INFO));
 		}
 	}
@@ -5227,7 +5217,6 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
 /* level 0x200  SMB_QUERY_CIFS_UNIX_INFO */
 	TRANSACTION2_QFSI_REQ *pSMB = NULL;
 	TRANSACTION2_QFSI_RSP *pSMBr = NULL;
-	FILE_SYSTEM_UNIX_INFO *response_data;
 	unsigned int in_len;
 	int rc = 0;
 	int bytes_returned = 0;
@@ -5277,11 +5266,8 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
 				      get_bcc(&pSMBr->hdr), 13);
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			response_data =
-			    (FILE_SYSTEM_UNIX_INFO
-			     *) (((char *) &pSMBr->hdr.Protocol) +
-				 data_offset);
-			memcpy(&tcon->fsUnixInfo, response_data,
+			memcpy(&tcon->fsUnixInfo,
+			       (char *)pSMBr + struct_offset(pSMBr, hdr.Protocol) + data_offset,
 			       sizeof(FILE_SYSTEM_UNIX_INFO));
 		}
 	}
-- 
2.54.0

