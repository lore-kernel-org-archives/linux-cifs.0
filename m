Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC6CC7EE23
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 02:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbjEXC0i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 May 2023 22:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjEXC0h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 May 2023 22:26:37 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04C41A8
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 19:26:29 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2af189d323fso67547991fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 May 2023 19:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684895187; x=1687487187;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RECNaUh/nKqVFPcbCgavk+v688GOwa63uXMue1K0zos=;
        b=VZ366sLwbjL45qAKg9Yf2Y5tGMc8nRZcOfZcX+p9lIMUg3lp6VixKGGfSjKQ3ulfVO
         uIYY4SALEQjXlKzraLAePIGnKJJ/TCf/nelHDzkiwKIwodqcCXW8NIm9bSlRfywBc6mt
         M3TdZmtaId0mdV3eDg/qsmIpYIA5Qixx2cidYo0lJ8Oi4xWbfUI+KuVlDMJEdtMwmrjI
         slKUMPVJ+IMQwesn+lISNFhMAG+9XrOchP4tBwNysQGZIPITAZKogSYVYqKGzEnZoEyL
         KgANT7QOEUIkm+DowdZ+qPIE40AhROHn7ffwYIf/YtJ/13NTmCMZGr35LGXzPu/aPoT0
         LsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684895187; x=1687487187;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RECNaUh/nKqVFPcbCgavk+v688GOwa63uXMue1K0zos=;
        b=Y/X5cbZw+XBmNxDbSEthc74kJToJWgTzXN2P1R9s041LO1jyBozcG83b0Ebigj1bFv
         vHSSWUdDTYtkEnYbTGCdCpnRQYzsLmIC5y2uqBiOiJuUKSsB3FRFwBqgLgqBj0G/HJ5K
         Sd28oW79NLVoWMKHFsbnop1I+uN9bBndJKm2LsmJOSzVPEhG8Qj1gqcSu/dMA+3KFNDY
         +C1LOGcHl/gIc6fQyAoPBpr51AUhKF+nXDsHwqKt4tPdGKdV8fBIqWgT8o5xDxFv0aQS
         1XHjXA4oJk3BSfKD23N/Tr9VfBwGr9Z6c9v0wCq0aYcqRz1PGyS4n3lPZsLiGfXpkYsp
         w2VA==
X-Gm-Message-State: AC+VfDziihfIa+/Kld1qzTP+NI1S67yMppCA7ryGTShycocYvZDqQqDp
        rBP2myv+W+OV0JWSK0LNq+BacbsVgtxV7xQjj+lG+Q/5EOdARzYD
X-Google-Smtp-Source: ACHHUZ51kSnyav9fi7LiPtQQG6RSv6xfGyvzfjL0WVrqwWkxRqibPIptcEMl8cg2cSCZDKs0xKPkjMqbyLeV4vpFC3A=
X-Received: by 2002:a2e:9251:0:b0:2af:2fb0:9238 with SMTP id
 v17-20020a2e9251000000b002af2fb09238mr4032178ljg.16.1684895187207; Tue, 23
 May 2023 19:26:27 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 May 2023 21:26:16 -0500
Message-ID: <CAH2r5muuft165Znwz888LC4qFhn16x44bp3UYKia_vetyy9tDw@mail.gmail.com>
Subject: SMB1 mount fix from Paulo
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="0000000000001e251105fc673bfc"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001e251105fc673bfc
Content-Type: text/plain; charset="UTF-8"

Fix from Paulo attached for SMB1 mount error (and merged into
cifs-2.6.git for-next).  See attached.

cifs.ko maps NT_STATUS_NOT_FOUND to -EIO when SMB1 servers couldn't
resolve referral paths.  Proceed to tree connect when we get -EIO from
dfs_get_referral() as well.


-- 
Thanks,

Steve

--0000000000001e251105fc673bfc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-fix-smb1-mount-regression.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-fix-smb1-mount-regression.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_li132bz60>
X-Attachment-Id: f_li132bz60

RnJvbSA1MjA2N2YwY2UzOGNmMTFkYWU1MWEzZjk5ZGU5OWUxYTNlYmU5NGM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5jb20+CkRh
dGU6IFR1ZSwgMjMgTWF5IDIwMjMgMTc6Mzg6MzggLTAzMDAKU3ViamVjdDogW1BBVENIIDIvNl0g
Y2lmczogZml4IHNtYjEgbW91bnQgcmVncmVzc2lvbgoKY2lmcy5rbyBtYXBzIE5UX1NUQVRVU19O
T1RfRk9VTkQgdG8gLUVJTyB3aGVuIFNNQjEgc2VydmVycyBjb3VsZG4ndApyZXNvbHZlIHJlZmVy
cmFsIHBhdGhzLiAgUHJvY2VlZCB0byB0cmVlIGNvbm5lY3Qgd2hlbiB3ZSBnZXQgLUVJTyBmcm9t
CmRmc19nZXRfcmVmZXJyYWwoKSBhcyB3ZWxsLgoKUmVwb3J0ZWQtYnk6IEtyaXMgS2FyYXMgKEJ1
ZyBSZXBvcnRpbmcpIDxidWdzLWEyMUBtb29ubGl0LXJhaWwuY29tPgpGaXhlczogOGUzNTU0MTUw
ZDZjICgiY2lmczogZml4IHNoYXJpbmcgb2YgREZTIGNvbm5lY3Rpb25zIikKQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcgIyB2Ni4yKwpTaWduZWQtb2ZmLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNV
U0UpIDxwY0BtYW5ndWViaXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9kZnMuYyB8IDIgKy0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
ZGZzLmMgYi9mcy9jaWZzL2Rmcy5jCmluZGV4IGE5M2RiY2ExNDExYi4uMmY5M2JmOGMzMzI1IDEw
MDY0NAotLS0gYS9mcy9jaWZzL2Rmcy5jCisrKyBiL2ZzL2NpZnMvZGZzLmMKQEAgLTMwMyw3ICsz
MDMsNyBAQCBpbnQgZGZzX21vdW50X3NoYXJlKHN0cnVjdCBjaWZzX21vdW50X2N0eCAqbW50X2N0
eCwgYm9vbCAqaXNkZnMpCiAJaWYgKCFub2RmcykgewogCQlyYyA9IGRmc19nZXRfcmVmZXJyYWwo
bW50X2N0eCwgY3R4LT5VTkMgKyAxLCBOVUxMLCBOVUxMKTsKIAkJaWYgKHJjKSB7Ci0JCQlpZiAo
cmMgIT0gLUVOT0VOVCAmJiByYyAhPSAtRU9QTk9UU1VQUCkKKwkJCWlmIChyYyAhPSAtRU5PRU5U
ICYmIHJjICE9IC1FT1BOT1RTVVBQICYmIHJjICE9IC1FSU8pCiAJCQkJZ290byBvdXQ7CiAJCQlu
b2RmcyA9IHRydWU7CiAJCX0KLS0gCjIuMzQuMQoK
--0000000000001e251105fc673bfc--
