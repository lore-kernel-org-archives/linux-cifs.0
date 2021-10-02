Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28090C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AEB361B08
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhJBN1D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB11DC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=CS++xHYXmyIeHCPSon04GbD9+ipfeR7qC+fuTRWOWg0=; b=YshtUz9xRs/Ll0weB0jrLotP6y
        cyVS5usIMb23+AJU1NONep1lAN4AXvODxWZmy7wGEHnz5Zvfm022Ou3KiVZ8aSwwLfDDn/ruW9p0J
        Nfu4rzh++Plj/z0uyyBwp/PFyVHG3OozPFTXkS4A1do0CL4KxkMy01HEZrKo2+1NmymkXDd3q9vQC
        yIb0/Xko2PtqaustZzmf68nIVamKGhk0QKG0yBbKviSsGtXnL+Hr528wlEWKvCndi/Q/Hv6W6BZEv
        fK+qg9RkBJQx0IhJ1QgACkR15Kf1qtigRr2fJNTYbjO20E4JGenlkOLH82qiM97/ScE8bpx+WH5ZW
        R5v8w52c8f526FlCMflzzcXRslWxuTLWGUyHWhSimOIJuyQRnRblHV1SG08Ua3p74e8E/D0zyp2Fy
        HZTvxn/I5ZzGmhCyUWqby4bJlhBRZXjyJiiijUM2VpzCAYvt5h336Ue0otT7wH0B/UFzUHf4tKktU
        s06dyIJWI6PDnsNsYfnYPdwV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoP-001DcY-1R; Sat, 02 Oct 2021 13:12:21 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v6 03/14] ksmbd: check strictly data area in ksmbd_smb2_check_message()
Date:   Sat,  2 Oct 2021 15:12:01 +0200
Message-Id: <20211002131212.130629-4-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

When invalid data offset and data length in request,
ksmbd_smb2_check_message check strictly and doesn't allow to process such
requests.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2misc.c | 98 ++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 51 deletions(-)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 9aa46bb3e10d..9edd9c161b27 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -80,18 +80,21 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
 };
 
 /*
- * Returns the pointer to the beginning of the data area. Length of the data
- * area and the offset to it (from the beginning of the smb are also returned.
+ * Set length of the data area and the offset to arguments.
+ * if they are invalid, return error.
  */
-static char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
+static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
+				  struct smb2_hdr *hdr)
 {
+	int ret = 0;
+
 	*off = 0;
 	*len = 0;
 
 	/* error reqeusts do not have data area */
 	if (hdr->Status && hdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
 	    (((struct smb2_err_rsp *)hdr)->StructureSize) == SMB2_ERROR_STRUCTURE_SIZE2_LE)
-		return NULL;
+		return ret;
 
 	/*
 	 * Following commands have data areas so we have to get the location
@@ -165,69 +168,60 @@ static char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	case SMB2_IOCTL:
 		*off = le32_to_cpu(((struct smb2_ioctl_req *)hdr)->InputOffset);
 		*len = le32_to_cpu(((struct smb2_ioctl_req *)hdr)->InputCount);
-
 		break;
 	default:
 		ksmbd_debug(SMB, "no length check for command\n");
 		break;
 	}
 
-	/*
-	 * Invalid length or offset probably means data area is invalid, but
-	 * we have little choice but to ignore the data area in this case.
-	 */
 	if (*off > 4096) {
-		ksmbd_debug(SMB, "offset %d too large, data area ignored\n",
-			    *off);
-		*len = 0;
-		*off = 0;
-	} else if (*off < 0) {
-		ksmbd_debug(SMB,
-			    "negative offset %d to data invalid ignore data area\n",
-			    *off);
-		*off = 0;
-		*len = 0;
-	} else if (*len < 0) {
-		ksmbd_debug(SMB,
-			    "negative data length %d invalid, data area ignored\n",
-			    *len);
-		*len = 0;
-	} else if (*len > 128 * 1024) {
-		ksmbd_debug(SMB, "data area larger than 128K: %d\n", *len);
-		*len = 0;
+		ksmbd_debug(SMB, "offset %d too large\n", *off);
+		ret = -EINVAL;
+	} else if ((u64)*off + *len > MAX_STREAM_PROT_LEN) {
+		ksmbd_debug(SMB, "Request is larger than maximum stream protocol length(%u): %llu\n",
+			    MAX_STREAM_PROT_LEN, (u64)*off + *len);
+		ret = -EINVAL;
 	}
 
-	/* return pointer to beginning of data area, ie offset from SMB start */
-	if ((*off != 0) && (*len != 0))
-		return (char *)hdr + *off;
-	else
-		return NULL;
+	return ret;
 }
 
 /*
  * Calculate the size of the SMB message based on the fixed header
  * portion, the number of word parameters and the data portion of the message.
  */
-static unsigned int smb2_calc_size(void *buf)
+static int smb2_calc_size(void *buf, unsigned int *len)
 {
 	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
 	struct smb2_hdr *hdr = &pdu->hdr;
-	int offset; /* the offset from the beginning of SMB to data area */
-	int data_length; /* the length of the variable length data area */
+	unsigned int offset; /* the offset from the beginning of SMB to data area */
+	unsigned int data_length; /* the length of the variable length data area */
+	int ret;
+
 	/* Structure Size has already been checked to make sure it is 64 */
-	int len = le16_to_cpu(hdr->StructureSize);
+	*len = le16_to_cpu(hdr->StructureSize);
 
 	/*
 	 * StructureSize2, ie length of fixed parameter area has already
 	 * been checked to make sure it is the correct length.
 	 */
-	len += le16_to_cpu(pdu->StructureSize2);
+	*len += le16_to_cpu(pdu->StructureSize2);
+	/*
+	 * StructureSize2 of smb2_lock pdu is set to 48, indicating
+	 * the size of smb2 lock request with single smb2_lock_element
+	 * regardless of number of locks. Subtract single
+	 * smb2_lock_element for correct buffer size check.
+	 */
+	if (hdr->Command == SMB2_LOCK)
+		*len -= sizeof(struct smb2_lock_element);
 
 	if (has_smb2_data_area[le16_to_cpu(hdr->Command)] == false)
 		goto calc_size_exit;
 
-	smb2_get_data_area_len(&offset, &data_length, hdr);
-	ksmbd_debug(SMB, "SMB2 data length %d offset %d\n", data_length,
+	ret = smb2_get_data_area_len(&offset, &data_length, hdr);
+	if (ret)
+		return ret;
+	ksmbd_debug(SMB, "SMB2 data length %u offset %u\n", data_length,
 		    offset);
 
 	if (data_length > 0) {
@@ -237,16 +231,19 @@ static unsigned int smb2_calc_size(void *buf)
 		 * for some commands, typically those with odd StructureSize,
 		 * so we must add one to the calculation.
 		 */
-		if (offset + 1 < len)
+		if (offset + 1 < *len) {
 			ksmbd_debug(SMB,
-				    "data area offset %d overlaps SMB2 header %d\n",
-				    offset + 1, len);
-		else
-			len = offset + data_length;
+				    "data area offset %d overlaps SMB2 header %u\n",
+				    offset + 1, *len);
+			return -EINVAL;
+		}
+
+		*len = offset + data_length;
 	}
+
 calc_size_exit:
-	ksmbd_debug(SMB, "SMB2 len %d\n", len);
-	return len;
+	ksmbd_debug(SMB, "SMB2 len %u\n", *len);
+	return 0;
 }
 
 static inline int smb2_query_info_req_len(struct smb2_query_info_req *h)
@@ -391,9 +388,11 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
-	clc_len = smb2_calc_size(hdr);
+	if (smb2_calc_size(hdr, &clc_len))
+		return 1;
+
 	if (len != clc_len) {
-		/* server can return one byte more due to implied bcc[0] */
+		/* client can return one byte more due to implied bcc[0] */
 		if (clc_len == len + 1)
 			return 0;
 
@@ -418,9 +417,6 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 			return 0;
 		}
 
-		if (command == SMB2_LOCK_HE && len == 88)
-			return 0;
-
 		ksmbd_debug(SMB,
 			    "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
 			    len, clc_len, command,
-- 
2.31.1

