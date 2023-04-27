Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6F6C77B61
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Apr 2023 17:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbjD0Rxd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Apr 2023 13:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbjD0Rxc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Apr 2023 13:53:32 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CF63C15
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 10:53:31 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4efe8991bafso7384697e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 10:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682618009; x=1685210009;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G0G1OOvalzxqSwT7StWqbHprCwVNGnOUNfUIj0/D1vQ=;
        b=dfNLMsj3NCKM0KMunnJNUDgrkp7LaMT8hgx+1R8tFaT8oDepwEAfHXHFOZ7Wxa8CTx
         kWQAlnJolSE6xOYH7petB4nAoEFK2BcPW10l6sBl4rXoWN1SrAQ76T14K5Zknl+s6PkR
         A0Yj4LF0Zud774Y0lGZc/FFqKiZTKm8Uj/iRpXpLNC5WplScyWQB1W8Tq/MNC2lCx4of
         o1tm+vnAwV+Wb5kVIGCiS6f6AboebJulL2v9AsIOWHLS7yuXr/Q1E1wvpcUQr+D1lvfv
         ZA8XKVrDcdH7g/d5I3A5FWrAp/bhFxrUKF6UGDgbBxIpbiTNvFzDm2kFBGf3PKhIlRQE
         zwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682618009; x=1685210009;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G0G1OOvalzxqSwT7StWqbHprCwVNGnOUNfUIj0/D1vQ=;
        b=lczUlhCpwVR3Y7YnHlGM/GgxEA/XjC1oMhr5PS3zqvWJtPlFFVyCU10NHuWLwGgSul
         kTwkGPBqSsBDmqFbUKaCASBCfFWQYv8ytqe0O1mfJAKu8Mf5T+n2d0bu+wy8qSKM5vgn
         hl5CF6w7mse+5mpE34/UlBOHHLrtOdZf/aZNGodWVAE4flaPPpIt6w5BjDSw6aAdRZ/w
         jsyc/VXUWqEzGUbN/Okm4UeXhUsI1OJehHD/bNFeCmbv/3F+5f7KY9htLYICDX9a1Owx
         2ed2C0Xg4J+GRY1RfxHpABN1vG6LGuptwgUeYrERkVYUXZI3P0dLWILV73vXzm59mpdq
         8/bw==
X-Gm-Message-State: AC+VfDwQyLUwTjfRKfbzZaKbLBoLDn9YFcXs0S+K5IA9GD6wTVpv7bIP
        i7nQnfxnjk3n6DVhgo2lk8vZlJL6r+2Djm01MlWhRq/ePMU=
X-Google-Smtp-Source: ACHHUZ7A8WhVM+50uJjPParZ8lRvihPlQnKU6s/mNv+1VAUiwrkx5B5TWkdcpOPDebPHUAC2nNGzdBdRzRBlazvKBYo=
X-Received: by 2002:a2e:9d49:0:b0:2a8:e480:a3c1 with SMTP id
 y9-20020a2e9d49000000b002a8e480a3c1mr799292ljj.0.1682618008965; Thu, 27 Apr
 2023 10:53:28 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 Apr 2023 12:53:17 -0500
Message-ID: <CAH2r5mtoYkS+FGVRJCSpeuxLi5n=kdFLPhGLJvjcMGeG7VxW+g@mail.gmail.com>
Subject: [PATCH] SMB3.1.1: add new tree connect ShareFlags
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b7acb105fa5508b7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b7acb105fa5508b7
Content-Type: text/plain; charset="UTF-8"

Also update these flag names in a few places to match the simpler
easier to understand names now used in the protocol documentation
(see MS-SMB2 section 2.2.10)

Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
index ace133cf6072..334f11ed5146 100644
--- a/fs/smbfs_common/smb2pdu.h
+++ b/fs/smbfs_common/smb2pdu.h
@@ -327,17 +327,18 @@ struct smb2_tree_connect_req {
 #define SMB2_SHAREFLAG_NO_CACHING                      0x00000030
 #define SHI1005_FLAGS_DFS                              0x00000001
 #define SHI1005_FLAGS_DFS_ROOT                         0x00000002
-#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS         0x00000100
-#define SHI1005_FLAGS_FORCE_SHARED_DELETE              0x00000200
-#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING          0x00000400
-#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM      0x00000800
-#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK             0x00001000
-#define SHI1005_FLAGS_ENABLE_HASH_V1                   0x00002000
-#define SHI1005_FLAGS_ENABLE_HASH_V2                   0x00004000
+#define SMB2_SHAREFLAG_RESTRICT_EXCLUSIVE_OPENS                0x00000100
+#define SMB2_SHAREFLAG_FORCE_SHARED_DELETE             0x00000200
+#define SMB2_SHAREFLAG_ALLOW_NAMESPACE_CACHING         0x00000400
+#define SMB2_SHAREFLAG_ACCESS_BASED_DIRECTORY_ENUM     0x00000800
+#define SMB2_SHAREFLAG_FORCE_LEVELII_OPLOCK            0x00001000
+#define SMB2_SHAREFLAG_ENABLE_HASH_V1                  0x00002000
+#define SMB2_SHAREFLAG_ENABLE_HASH_V2                  0x00004000
 #define SHI1005_FLAGS_ENCRYPT_DATA                     0x00008000
 #define SMB2_SHAREFLAG_IDENTITY_REMOTING               0x00040000 /* 3.1.1 */
 #define SMB2_SHAREFLAG_COMPRESS_DATA                   0x00100000 /* 3.1.1 */
-#define SHI1005_FLAGS_ALL                              0x0014FF33
+#define SMB2_SHAREFLAG_ISOLATED_TRANSPORT              0x00200000
+#define SHI1005_FLAGS_ALL                              0x0034FF33

 /* Possible share capabilities */
 #define SMB2_SHARE_CAP_DFS     cpu_to_le32(0x00000008) /* all dialects */


-- 
Thanks,

Steve

--000000000000b7acb105fa5508b7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-SMB3.1.1-add-new-tree-connect-ShareFlags.patch"
Content-Disposition: attachment; 
	filename="0002-SMB3.1.1-add-new-tree-connect-ShareFlags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lgzfb4or0>
X-Attachment-Id: f_lgzfb4or0

RnJvbSAxNjEyZDg4YThkMDI1MTE3MGNjYTc0N2Y5NjhhZTZhNjA4YzZmNjRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjcgQXByIDIwMjMgMTI6NDU6NTQgLTA1MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gU01CMy4xLjE6IGFkZCBuZXcgdHJlZSBjb25uZWN0IFNoYXJlRmxhZ3MKCkFsc28gdXBkYXRl
IHRoZXNlIGZsYWcgbmFtZXMgaW4gYSBmZXcgcGxhY2VzIHRvIG1hdGNoIHRoZSBzaW1wbGVyCmVh
c2llciB0byB1bmRlcnN0YW5kIG5hbWVzIG5vdyB1c2VkIGluIHRoZSBwcm90b2NvbCBkb2N1bWVu
dGF0aW9uCihzZWUgTVMtU01CMiBzZWN0aW9uIDIuMi4xMCkKClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWJmc19jb21tb24vc21i
MnBkdS5oIHwgMTcgKysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlv
bnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iZnNfY29tbW9uL3NtYjJw
ZHUuaCBiL2ZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmgKaW5kZXggYWNlMTMzY2Y2MDcyLi4zMzRm
MTFlZDUxNDYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYmZzX2NvbW1vbi9zbWIycGR1LmgKKysrIGIvZnMv
c21iZnNfY29tbW9uL3NtYjJwZHUuaApAQCAtMzI3LDE3ICszMjcsMTggQEAgc3RydWN0IHNtYjJf
dHJlZV9jb25uZWN0X3JlcSB7CiAjZGVmaW5lIFNNQjJfU0hBUkVGTEFHX05PX0NBQ0hJTkcJCQkw
eDAwMDAwMDMwCiAjZGVmaW5lIFNISTEwMDVfRkxBR1NfREZTCQkJCTB4MDAwMDAwMDEKICNkZWZp
bmUgU0hJMTAwNV9GTEFHU19ERlNfUk9PVAkJCQkweDAwMDAwMDAyCi0jZGVmaW5lIFNISTEwMDVf
RkxBR1NfUkVTVFJJQ1RfRVhDTFVTSVZFX09QRU5TCQkweDAwMDAwMTAwCi0jZGVmaW5lIFNISTEw
MDVfRkxBR1NfRk9SQ0VfU0hBUkVEX0RFTEVURQkJMHgwMDAwMDIwMAotI2RlZmluZSBTSEkxMDA1
X0ZMQUdTX0FMTE9XX05BTUVTUEFDRV9DQUNISU5HCQkweDAwMDAwNDAwCi0jZGVmaW5lIFNISTEw
MDVfRkxBR1NfQUNDRVNTX0JBU0VEX0RJUkVDVE9SWV9FTlVNCTB4MDAwMDA4MDAKLSNkZWZpbmUg
U0hJMTAwNV9GTEFHU19GT1JDRV9MRVZFTElJX09QTE9DSwkJMHgwMDAwMTAwMAotI2RlZmluZSBT
SEkxMDA1X0ZMQUdTX0VOQUJMRV9IQVNIX1YxCQkJMHgwMDAwMjAwMAotI2RlZmluZSBTSEkxMDA1
X0ZMQUdTX0VOQUJMRV9IQVNIX1YyCQkJMHgwMDAwNDAwMAorI2RlZmluZSBTTUIyX1NIQVJFRkxB
R19SRVNUUklDVF9FWENMVVNJVkVfT1BFTlMJCTB4MDAwMDAxMDAKKyNkZWZpbmUgU01CMl9TSEFS
RUZMQUdfRk9SQ0VfU0hBUkVEX0RFTEVURQkJMHgwMDAwMDIwMAorI2RlZmluZSBTTUIyX1NIQVJF
RkxBR19BTExPV19OQU1FU1BBQ0VfQ0FDSElORwkJMHgwMDAwMDQwMAorI2RlZmluZSBTTUIyX1NI
QVJFRkxBR19BQ0NFU1NfQkFTRURfRElSRUNUT1JZX0VOVU0JMHgwMDAwMDgwMAorI2RlZmluZSBT
TUIyX1NIQVJFRkxBR19GT1JDRV9MRVZFTElJX09QTE9DSwkJMHgwMDAwMTAwMAorI2RlZmluZSBT
TUIyX1NIQVJFRkxBR19FTkFCTEVfSEFTSF9WMQkJCTB4MDAwMDIwMDAKKyNkZWZpbmUgU01CMl9T
SEFSRUZMQUdfRU5BQkxFX0hBU0hfVjIJCQkweDAwMDA0MDAwCiAjZGVmaW5lIFNISTEwMDVfRkxB
R1NfRU5DUllQVF9EQVRBCQkJMHgwMDAwODAwMAogI2RlZmluZSBTTUIyX1NIQVJFRkxBR19JREVO
VElUWV9SRU1PVElORwkJMHgwMDA0MDAwMCAvKiAzLjEuMSAqLwogI2RlZmluZSBTTUIyX1NIQVJF
RkxBR19DT01QUkVTU19EQVRBCQkJMHgwMDEwMDAwMCAvKiAzLjEuMSAqLwotI2RlZmluZSBTSEkx
MDA1X0ZMQUdTX0FMTAkJCQkweDAwMTRGRjMzCisjZGVmaW5lIFNNQjJfU0hBUkVGTEFHX0lTT0xB
VEVEX1RSQU5TUE9SVAkJMHgwMDIwMDAwMAorI2RlZmluZSBTSEkxMDA1X0ZMQUdTX0FMTAkJCQkw
eDAwMzRGRjMzCiAKIC8qIFBvc3NpYmxlIHNoYXJlIGNhcGFiaWxpdGllcyAqLwogI2RlZmluZSBT
TUIyX1NIQVJFX0NBUF9ERlMJY3B1X3RvX2xlMzIoMHgwMDAwMDAwOCkgLyogYWxsIGRpYWxlY3Rz
ICovCi0tIAoyLjM0LjEKCg==
--000000000000b7acb105fa5508b7--
