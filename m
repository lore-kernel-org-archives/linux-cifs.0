Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282B4C6FD1C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 05:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCWFR6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 01:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjCWFRv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 01:17:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A7020568
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 22:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6767DB81F1A
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 05:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F499C433A1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 05:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548668;
        bh=ln204IZ5ryKtmOUfO+Ke4rKI9qBJEHYXjxyD93/4m6Y=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=QOUPhrX3ICX3MombIvfp/zOhT6d4WxnwrUUzunoHee5QsJofaLJXOIn0vWkfImqT2
         8lC0rv4BKxC2ApO5sDfWLNEay+1VpvzgRe/3R/k6vC6MEgqQPyalL56EVX9WKQSV+e
         XDxxQuh21ddk0BZnTibOn/ggXPRVhz+rT3DN4xFsVScdOidRQm/HuihlU1sBwCDNkp
         GhD5d2F5HRXO/P28l0CQZeeL2HuDVKJJVix/gtrelaKLGOA55i/Hz3PmC2vGtbpxZX
         GPAWDdTiwGKgJXt26PKqQFztrXoWkO8yKmW3gpDxs/D7CfGDIPO35kif42J4FDSXhw
         MMsOTeAQJS2xQ==
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-17ac5ee3f9cso21560064fac.12
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 22:17:48 -0700 (PDT)
X-Gm-Message-State: AO0yUKVYqpR+aJALSqVA6wlJKHa7gZOIYjqse2fSmn4gfF9QQ/RvwilF
        YCJguyuvruDZo4PifzlixU6kl4W96OfIEIlm7w8=
X-Google-Smtp-Source: AK7set+8MSbjFbl7aannoCrva4aDEzeU/0DjRftRFn5kzBX2BunPSYHHWwofIAGMScpmt1TgevRIW+K7PfP0TtzJ+Pg=
X-Received: by 2002:a05:6871:4909:b0:17e:8a64:3da2 with SMTP id
 tw9-20020a056871490900b0017e8a643da2mr602740oab.1.1679548667184; Wed, 22 Mar
 2023 22:17:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:774e:0:b0:4c8:b94d:7a80 with HTTP; Wed, 22 Mar 2023
 22:17:46 -0700 (PDT)
In-Reply-To: <CAKYAXd_GK_Tpk8cP-L-BjxenMFpBjGwrZ3E_6xHMVoLUfYNnjg@mail.gmail.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230321133312.103789-3-linkinjeon@kernel.org> <20230323025319.GA3271889@google.com>
 <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com>
 <20230323050006.GB3271889@google.com> <CAKYAXd_GK_Tpk8cP-L-BjxenMFpBjGwrZ3E_6xHMVoLUfYNnjg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Mar 2023 14:17:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-r_r3fmd=Xv92bpO4fz3T8aSC9YAsrYpF=NoXV+56k_A@mail.gmail.com>
Message-ID: <CAKYAXd-r_r3fmd=Xv92bpO4fz3T8aSC9YAsrYpF=NoXV+56k_A@mail.gmail.com>
Subject: [PATCH v2] ksmbd: return unsupported error on smb1 mount
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd disconnect connection when mounting with vers=smb1.
ksmbd should send smb1 negotiate response to client for correct
unsupported error return. This patch add needed SMB1 macros and fill
NegProt part of the response for smb1 negotiate response.

Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - remove 1byte wc in the comment.

 fs/ksmbd/connection.c |  7 ++-----
 fs/ksmbd/smb_common.c | 23 ++++++++++++++++++++---
 fs/ksmbd/smb_common.h | 30 ++++++++----------------------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 5d914715605f..115a67d2cf78 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -319,13 +319,10 @@ int ksmbd_conn_handler_loop(void *p)
 		}

 		/*
-		 * Check if pdu size is valid (min : smb header size,
-		 * max : 0x00FFFFFF).
+		 * Check maximum pdu size(0x00FFFFFF).
 		 */
-		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
-		    pdu_size > MAX_STREAM_PROT_LEN) {
+		if (pdu_size > MAX_STREAM_PROT_LEN)
 			break;
-		}

 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 079c9e76818d..87fa578b141e 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -442,9 +442,26 @@ static int smb_handle_negotiate(struct ksmbd_work *work)
 {
 	struct smb_negotiate_rsp *neg_rsp = work->response_buf;

-	ksmbd_debug(SMB, "Unsupported SMB protocol\n");
-	neg_rsp->hdr.Status.CifsError = STATUS_INVALID_LOGON_TYPE;
-	return -EINVAL;
+	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
+
+	/*
+	 * Remove 4 byte direct TCP header, add 2 byte bcc and
+	 * 2 byte DialectIndex.
+	 */
+	*(__be32 *)work->response_buf =
+		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
+	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
+
+	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
+	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
+	neg_rsp->hdr.Flags = SMBFLG_RESPONSE;
+	neg_rsp->hdr.Flags2 = SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS |
+		SMBFLG2_EXT_SEC | SMBFLG2_IS_LONG_NAME;
+
+	neg_rsp->hdr.WordCount = 1;
+	neg_rsp->DialectIndex = cpu_to_le16(work->conn->dialect);
+	neg_rsp->ByteCount = 0;
+	return 0;
 }

 int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index e663ab9ea759..d30ce4c1a151 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -158,8 +158,15 @@

 #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
 #define SMB_COM_NEGOTIATE		0x72
-
 #define SMB1_CLIENT_GUID_SIZE		(16)
+
+#define SMBFLG_RESPONSE 0x80	/* this PDU is a response from server */
+
+#define SMBFLG2_IS_LONG_NAME	cpu_to_le16(0x40)
+#define SMBFLG2_EXT_SEC		cpu_to_le16(0x800)
+#define SMBFLG2_ERR_STATUS	cpu_to_le16(0x4000)
+#define SMBFLG2_UNICODE		cpu_to_le16(0x8000)
+
 struct smb_hdr {
 	__be32 smb_buf_length;
 	__u8 Protocol[4];
@@ -199,28 +206,7 @@ struct smb_negotiate_req {
 struct smb_negotiate_rsp {
 	struct smb_hdr hdr;     /* wct = 17 */
 	__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
-	__u8 SecurityMode;
-	__le16 MaxMpxCount;
-	__le16 MaxNumberVcs;
-	__le32 MaxBufferSize;
-	__le32 MaxRawSize;
-	__le32 SessionKey;
-	__le32 Capabilities;    /* see below */
-	__le32 SystemTimeLow;
-	__le32 SystemTimeHigh;
-	__le16 ServerTimeZone;
-	__u8 EncryptionKeyLength;
 	__le16 ByteCount;
-	union {
-		unsigned char EncryptionKey[8]; /* cap extended security off */
-		/* followed by Domain name - if extended security is off */
-		/* followed by 16 bytes of server GUID */
-		/* then security blob if cap_extended_security negotiated */
-		struct {
-			unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
-			unsigned char SecurityBlob[1];
-		} __packed extended_response;
-	} __packed u;
 } __packed;

 struct filesystem_attribute_info {
-- 
2.34.1
