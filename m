Return-Path: <SRS0=UMHq=DS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0530C433DF
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Oct 2020 01:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B35120759
	for <linux-cifs@archiver.kernel.org>; Sun, 11 Oct 2020 01:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JIyx5mIQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgJKBZh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Oct 2020 21:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgJKBZg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Oct 2020 21:25:36 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C126CC0613D0
        for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2020 18:25:34 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id p15so13325970ljj.8
        for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2020 18:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=THcgmlGOC9FfPamwQ91DRL4oK5/e5E+5YuMC036l3hg=;
        b=JIyx5mIQVXhBqgQh2ow+LLeVo8WMMmaHp2wsCLgDl6Tuyjx23b99sxfWGYWRr0Mj+T
         bLcKIqM30LKks60wvrzHUA72IgRqeHlK11RG6RxtxS9LAZbu7L85PdzALVQBVmvcxRUm
         BEfbNuFBfPGF4mK+V6dBFTGvVPX9sc70Exic9ywQm8wAExv+r0gBrYayDSof5yNBVd36
         lKHWxOwry6KE1A6Jmob/dExCWKESzCwbeRJxg5zQDEaEQZMpzghTU0dfLrkwsUWUg7/Q
         4JoI02TEm+tR9+IA0A8W6YxiIUQQDHjpr4WorOsLcW7XT7CAlC6pJgRDUvV2Jomkm6c4
         xFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=THcgmlGOC9FfPamwQ91DRL4oK5/e5E+5YuMC036l3hg=;
        b=WCeFE3yxcCxAByqNV1GgjjN5uji6JLXNKdpFjPdKHmryVea8IdM/+9zgCaXC97MtNz
         tuSH3fxl41DDjhb4AjozP6OpcJStnNOmER68U0irU9qdz5OkSUQerSiq78Yqp0RnTbsY
         J+MKu46PaLHfE5Tj0Zxyc6uQUETDrKvyjIrcRTFNYe//kkh5HdlvjcX6YY7nV4bt/HTN
         YzGkcGUazWAU3Qy2n1ZB5kuOXgZGEB1c0jnTGtjwDN3z37l4Qi6JSe7c1ui1ApYg3m9Q
         kudmy3gChdldu5pafarkLsGUe7ZsoTMsQCIwtRU8PXTzLwjEpMXnEyRXZv5KkCCCYoPH
         xTcw==
X-Gm-Message-State: AOAM532lYlD97QkO9FQ0dv8W8GsVk8YK5Hx/ftO+jKlSiIVCZ4j+jnl3
        JPQnQ+bv5SKnveHaDSUz9r91UNPF9DONo86FKqIlFunPm2p3pQ==
X-Google-Smtp-Source: ABdhPJxNURjDiL+cCzKIcp8CgWbdxgMc1s1lFZOfz2TKgHg2exphqSU5zdtLmQujKfixN64wbcZZRlKMUUWyE0uNpbk=
X-Received: by 2002:a2e:9ad3:: with SMTP id p19mr7383375ljj.374.1602379531178;
 Sat, 10 Oct 2020 18:25:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Oct 2020 20:25:19 -0500
Message-ID: <CAH2r5mtwBHTk-Xoeuo+RbgNwiNw-cWTAhdy1YG5y+vXnNDSv4w@mail.gmail.com>
Subject: [PATCH][SMB3.1.1] Add defines for new signing context
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c06bab05b15b0e54"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c06bab05b15b0e54
Content-Type: text/plain; charset="UTF-8"

Add defines for the three supported signing algorithms

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2pdu.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 4dfb51dd7065..5932fc0dc62c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -323,6 +323,7 @@ struct smb2_negotiate_req {
 #define SMB2_NETNAME_NEGOTIATE_CONTEXT_ID cpu_to_le16(5)
 #define SMB2_TRANSPORT_CAPABILITIES cpu_to_le16(6)
 #define SMB2_RDMA_TRANSFORM_CAPABILITIES cpu_to_le16(7)
+#define SMB2_SIGNING_CAPABILITIES cpu_to_le16(8)
 #define SMB2_POSIX_EXTENSIONS_AVAILABLE cpu_to_le16(0x100)

 struct smb2_neg_context {
@@ -416,6 +417,19 @@ struct smb2_rdma_transform_capabilities_context {
  __le16 RDMATransformIds[1];
 } __packed;

+/* Signing algorithms */
+#define SIGNING_ALG_HMAC_SHA256 0
+#define SIGNING_ALG_AES_CMAC 1
+#define SIGNING_ALG_AES_GMAC 2
+
+struct smb2_signing_capabilities {
+ __le16 ContextType; /* 8 */
+ __le16 DataLength;
+ __u32 Reserved;
+ __le16 SigningAlgorithmCount;
+ __le16 SigningAlgorithms[];
+} __packed;
+
 #define POSIX_CTXT_DATA_LEN 16
 struct smb2_posix_neg_context {
  __le16 ContextType; /* 0x100 */
-- 
Thanks,

Steve

--000000000000c06bab05b15b0e54
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-add-defines-for-new-signing-negotiate-conte.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-add-defines-for-new-signing-negotiate-conte.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kg4fd3d70>
X-Attachment-Id: f_kg4fd3d70

RnJvbSBlOTEzYjUyYzg5MDNmZjQ0ODhhYjU4N2NhMmU0NzU2MDhlNDA1YjI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTAgT2N0IDIwMjAgMjA6MTE6NDcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzLjEuMTogYWRkIGRlZmluZXMgZm9yIG5ldyBzaWduaW5nIG5lZ290aWF0ZSBjb250ZXh0CgpD
dXJyZW50bHkgdGhlcmUgYXJlIHRocmVlIHN1cHBvcnRlZCBzaWduaW5nIGFsZ29yaXRobXMKClNp
Z25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBm
cy9jaWZzL3NtYjJwZHUuaCB8IDE0ICsrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTQg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9z
bWIycGR1LmgKaW5kZXggNGRmYjUxZGQ3MDY1Li41OTMyZmMwZGM2MmMgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5oCkBAIC0zMjMsNiArMzIzLDcg
QEAgc3RydWN0IHNtYjJfbmVnb3RpYXRlX3JlcSB7CiAjZGVmaW5lIFNNQjJfTkVUTkFNRV9ORUdP
VElBVEVfQ09OVEVYVF9JRAljcHVfdG9fbGUxNig1KQogI2RlZmluZSBTTUIyX1RSQU5TUE9SVF9D
QVBBQklMSVRJRVMJCWNwdV90b19sZTE2KDYpCiAjZGVmaW5lIFNNQjJfUkRNQV9UUkFOU0ZPUk1f
Q0FQQUJJTElUSUVTCWNwdV90b19sZTE2KDcpCisjZGVmaW5lIFNNQjJfU0lHTklOR19DQVBBQklM
SVRJRVMJCWNwdV90b19sZTE2KDgpCiAjZGVmaW5lIFNNQjJfUE9TSVhfRVhURU5TSU9OU19BVkFJ
TEFCTEUJCWNwdV90b19sZTE2KDB4MTAwKQogCiBzdHJ1Y3Qgc21iMl9uZWdfY29udGV4dCB7CkBA
IC00MTYsNiArNDE3LDE5IEBAIHN0cnVjdCBzbWIyX3JkbWFfdHJhbnNmb3JtX2NhcGFiaWxpdGll
c19jb250ZXh0IHsKIAlfX2xlMTYJUkRNQVRyYW5zZm9ybUlkc1sxXTsKIH0gX19wYWNrZWQ7CiAK
Ky8qIFNpZ25pbmcgYWxnb3JpdGhtcyAqLworI2RlZmluZSBTSUdOSU5HX0FMR19ITUFDX1NIQTI1
NgkwCisjZGVmaW5lIFNJR05JTkdfQUxHX0FFU19DTUFDCTEKKyNkZWZpbmUgU0lHTklOR19BTEdf
QUVTX0dNQUMJMgorCitzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyB7CisJX19sZTE2
CUNvbnRleHRUeXBlOyAvKiA4ICovCisJX19sZTE2CURhdGFMZW5ndGg7CisJX191MzIJUmVzZXJ2
ZWQ7CisJX19sZTE2CVNpZ25pbmdBbGdvcml0aG1Db3VudDsKKwlfX2xlMTYJU2lnbmluZ0FsZ29y
aXRobXNbXTsKK30gX19wYWNrZWQ7CisKICNkZWZpbmUgUE9TSVhfQ1RYVF9EQVRBX0xFTgkxNgog
c3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQgewogCV9fbGUxNglDb250ZXh0VHlwZTsgLyog
MHgxMDAgKi8KLS0gCjIuMjUuMQoK
--000000000000c06bab05b15b0e54--
