Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA343C433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 01:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB029610FB
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 01:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhDJBUX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 21:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhDJBUX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 21:20:23 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9552DC061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 18:20:09 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id z8so8493965ljm.12
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 18:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IA67hmjLpkn9GkvvAgWi7bY5KDIWoJCG7fhQVVG1Q4Q=;
        b=UATaJOKJ9B1/jhk+yjZNsrYgtChoS/r6V2hF6JO0RfdGUduLQIKHmpCRWwrGP1Ealg
         9J4r3D3N35I8kSFkVGrigLzAN1ED7Vy0mv8IkYgLn2v36Twbm8vOQuQ8tuYRAHerF59J
         fKIso3oVTaTe63N8CjAE6+7dv4IBM8Y0kASkGFZ/sd9dTSCLHNpnYJV5POHwmRcyr+mD
         C/0aU75Wc4uzYabcHkiOADGAoA9AcF9Pe+bdXxHdLF7I16b/cDtZnGAl2wcDBCz9upjN
         s4unjzkAOmx/G6YY9j7Bi64mGeeaqgSemUcjgUwFN4ksPOIPkI9zFAldDFm/fj0uPvpD
         /FOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IA67hmjLpkn9GkvvAgWi7bY5KDIWoJCG7fhQVVG1Q4Q=;
        b=VIcbqhWTyiGIIdYEJ8+eJDedVzvAG4O9DOvaqxNtrOM6N9Mq5zm8aXY2BtWRnD0IBd
         7jxBp9XZhzq9e16l/8q/l7TpnCHMQeR5eJGcsO5pTHPDNMLIGlPg7wvaI8cALNszb/Sn
         O32GlSx1tczRdvOR739+yKYQSVF8lf8UfYd0gqMoVkco4liZMJ8Jgym3Fy0dEnsJK+mK
         XuAnNSnqfDpf7wjqqtSIwBi10wpqFuWYo1wQpzrUa6Oq6NMxYd8k/nckwSKXaQtRrw3y
         syRVW3qUYHRyO1LoAw1/FGA5JYYSnxZRMfaXUAprjLKDREkuZCZo81EqaRJdgIdayuO+
         JyAw==
X-Gm-Message-State: AOAM531rgkecI583Qq+d8Tj2U4qoBrCJzOQ+PEyKBSIb4fVxbSjO2TuT
        0RU9pevK01B2TPw34pPN85Vs+W6P7RhBDSzt0vmpfMYgufiTrg==
X-Google-Smtp-Source: ABdhPJz5B0XLKcMHS29jbU42RqHpeK+xFIelhf2UNu/JWQtebHAAptI3nl3WwRGxZ0do+19bohBHflb7+A/TMWp+tOc=
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr10822933ljj.148.1618017607930;
 Fri, 09 Apr 2021 18:20:07 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 20:19:57 -0500
Message-ID: <CAH2r5mtouKTBH2wce04Es11qNg1JiKw25C=xuEBtEKr5MJc1PA@mail.gmail.com>
Subject: [PATCH] SMB3: update structures for new compression protocol definitions
To:     CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Protocol has been extended for additional compression headers.
See MS-SMB2 section 2.2.42

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2pdu.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index d6cd6e6ff14d..6442dc1c292b 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -144,7 +144,7 @@ struct smb2_transform_hdr {
 } __packed;

 /* See MS-SMB2 2.2.42 */
-struct smb2_compression_transform_hdr {
+struct smb2_compression_transform_hdr_unchained {
  __le32 ProtocolId; /* 0xFC 'S' 'M' 'B' */
  __le32 OriginalCompressedSegmentSize;
  __le16 CompressionAlgorithm;
@@ -160,10 +160,17 @@ struct compression_payload_header {
  __le16 CompressionAlgorithm;
  __le16 Flags;
  __le32 Length; /* length of compressed playload including field
below if present */
- /* __le32 OriginalPayloadSize; */ /* optional */
+ /* __le32 OriginalPayloadSize; */ /* optional, present when LZNT1,
LZ77, LZ77+Huffman */
 } __packed;

 /* See MS-SMB2 2.2.42.2 */
+struct smb2_compression_transform_hdr_chained {
+ __le32 ProtocolId; /* 0xFC 'S' 'M' 'B' */
+ __le32 OriginalCompressedSegmentSize;
+ /* struct compression_payload_header[] */
+} __packed;
+
+/* See MS-SMB2 2.2.42.2.2 */
 struct compression_pattern_payload_v1 {
  __le16 Pattern;
  __le16 Reserved1;

-- 
Thanks,

Steve
