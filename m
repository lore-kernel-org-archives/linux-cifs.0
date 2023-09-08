Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C00EEB570
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Sep 2023 20:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjIHU5B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Sep 2023 16:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbjIHU5A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Sep 2023 16:57:00 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB68E46
        for <linux-cifs@vger.kernel.org>; Fri,  8 Sep 2023 13:56:56 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-500b66f8b27so4249798e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 08 Sep 2023 13:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694206614; x=1694811414; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xlHnM71IVQndtFWO8vnVcCbrPstyvscLz0cy9DLCZEg=;
        b=L1arBHschRc1mdaxC24oTN5t6GVbJT+HXxxG3UlqsfBSXWxqQYUTBcJM6g9GtmvRrX
         Bmg3SP7JaGJtmVpxhmCFw234PDYyUDwTWh8lN65KLXBTlbQHWHroPvWmOFN3WLQIGBWA
         dv3C+yINtOezkb2GbbY4ShUS2gEOI9hT4ebLRKpuvlfiuWWCncNvpEGY3mDg6gQpdb71
         9M1DzMRDyR2frR/OBAHJVDfWYoj9I5xIaqrwvDZNg4W4Rnh6qrtuAapvpCGk3bSF6+kA
         PP6o7EW7dj6ZE8+22zBR1bVyQspo2xxxQYRlLoDp1KiUnanVNkxfW8rL9ZUFgrrxFUYn
         aq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694206614; x=1694811414;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xlHnM71IVQndtFWO8vnVcCbrPstyvscLz0cy9DLCZEg=;
        b=nLOPZAO82515Jc6AfeKiA+th5f3SdSheNbqwRhsnon0cnkY5cPfq6bZzJAGeAS+Eom
         n2FH+8veJ7aQngd9mzxnXmXRiy0YMoe3qY7B58Qcc1QYo8cmx+KEjOfNFjUa1I4ePjc5
         G4cuK/5Nz3slG3K7ZJGitj5xpSpJQkrwK6JHgPl8swvsUwFSOI/FymKiNPk89wxmpAWH
         w5l66JqOsp0tIcU258aeWPxnkG/zo66sSGO/ua3kkEqKRMnN69WbQNrwYjnhPbuoJST6
         WH2T4BdsHepST97d1GJmPJgc0J97NXgvBUWsUMz5Kj64v5mcjpfu3OQ45l+2jFvjpqhW
         pxFw==
X-Gm-Message-State: AOJu0Yxex7hQo713q2rq+wcDVlsULnNMw8WTyAMTbpvKgQ5n7iKW/XF0
        XxBEdtksd0VHAPbR9QoEXMTzS8sUX0VxPTh5TKhPItGMoj8FZg==
X-Google-Smtp-Source: AGHT+IE8hgvOV0HTlhugaaeR8RTqpgw9eDWJPwCeHv1wpF0v039UxCr7nWpK3Vh8bCook2DJQpl3K/kOfElxCXJH3j8=
X-Received: by 2002:a05:6512:b95:b0:501:bbbb:de1e with SMTP id
 b21-20020a0565120b9500b00501bbbbde1emr3476605lfv.6.1694206614010; Fri, 08 Sep
 2023 13:56:54 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Sep 2023 15:56:42 -0500
Message-ID: <CAH2r5msh3RUvBEwf2henYJ-oVt=4PwBDePnu-EVSrTpOCWLyUw@mail.gmail.com>
Subject: [PATCH][SMB3] Trivial typo fix
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000006798290604df37ab"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006798290604df37ab
Content-Type: text/plain; charset="UTF-8"

    smb3: fix minor typo in SMB2_GLOBAL_CAP_LARGE_MTU

    There was a minor typo in the define for SMB2_GLOBAL_CAP_LARGE_MTU
          0X00000004 instead of 0x00000004
    make it consistent

    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 2680251b9aac..319fb9ffc6a0 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -406,7 +406,7 @@ struct smb2_tree_disconnect_rsp {
 /* Capabilities flags */
 #define SMB2_GLOBAL_CAP_DFS            0x00000001
 #define SMB2_GLOBAL_CAP_LEASING                0x00000002 /* Resp
only New to SMB2.1 */
-#define SMB2_GLOBAL_CAP_LARGE_MTU      0X00000004 /* Resp only New to SMB2.1 */
+#define SMB2_GLOBAL_CAP_LARGE_MTU      0x00000004 /* Resp only New to SMB2.1 */
 #define SMB2_GLOBAL_CAP_MULTI_CHANNEL  0x00000008 /* New to SMB3 */
 #define SMB2_GLOBAL_CAP_PERSISTENT_HANDLES 0x00000010 /* New to SMB3 */
 #define SMB2_GLOBAL_CAP_DIRECTORY_LEASING  0x00000020 /* New to SMB3 */


-- 
Thanks,

Steve

--0000000000006798290604df37ab
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-minor-typo-in-SMB2_GLOBAL_CAP_LARGE_MTU.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-minor-typo-in-SMB2_GLOBAL_CAP_LARGE_MTU.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lmb2v6at0>
X-Attachment-Id: f_lmb2v6at0

RnJvbSBlMDE4OGQ0MmE3MmMxMmFhMWJjYmM0MWIwYjkwYmFiNzhhN2JiNWQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgOCBTZXAgMjAyMyAxNTo0ODo1NyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBtaW5vciB0eXBvIGluIFNNQjJfR0xPQkFMX0NBUF9MQVJHRV9NVFUKClRoZXJlIHdh
cyBhIG1pbm9yIHR5cG8gaW4gdGhlIGRlZmluZSBmb3IgU01CMl9HTE9CQUxfQ0FQX0xBUkdFX01U
VQogICAgICAwWDAwMDAwMDA0IGluc3RlYWQgb2YgMHgwMDAwMDAwNAptYWtlIGl0IGNvbnNpc3Rl
bnQKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9zbWIvY29tbW9uL3NtYjJwZHUuaCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jb21tb24vc21i
MnBkdS5oIGIvZnMvc21iL2NvbW1vbi9zbWIycGR1LmgKaW5kZXggMjY4MDI1MWI5YWFjLi4zMTlm
YjlmZmM2YTAgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jb21tb24vc21iMnBkdS5oCisrKyBiL2ZzL3Nt
Yi9jb21tb24vc21iMnBkdS5oCkBAIC00MDYsNyArNDA2LDcgQEAgc3RydWN0IHNtYjJfdHJlZV9k
aXNjb25uZWN0X3JzcCB7CiAvKiBDYXBhYmlsaXRpZXMgZmxhZ3MgKi8KICNkZWZpbmUgU01CMl9H
TE9CQUxfQ0FQX0RGUwkJMHgwMDAwMDAwMQogI2RlZmluZSBTTUIyX0dMT0JBTF9DQVBfTEVBU0lO
RwkJMHgwMDAwMDAwMiAvKiBSZXNwIG9ubHkgTmV3IHRvIFNNQjIuMSAqLwotI2RlZmluZSBTTUIy
X0dMT0JBTF9DQVBfTEFSR0VfTVRVCTBYMDAwMDAwMDQgLyogUmVzcCBvbmx5IE5ldyB0byBTTUIy
LjEgKi8KKyNkZWZpbmUgU01CMl9HTE9CQUxfQ0FQX0xBUkdFX01UVQkweDAwMDAwMDA0IC8qIFJl
c3Agb25seSBOZXcgdG8gU01CMi4xICovCiAjZGVmaW5lIFNNQjJfR0xPQkFMX0NBUF9NVUxUSV9D
SEFOTkVMCTB4MDAwMDAwMDggLyogTmV3IHRvIFNNQjMgKi8KICNkZWZpbmUgU01CMl9HTE9CQUxf
Q0FQX1BFUlNJU1RFTlRfSEFORExFUyAweDAwMDAwMDEwIC8qIE5ldyB0byBTTUIzICovCiAjZGVm
aW5lIFNNQjJfR0xPQkFMX0NBUF9ESVJFQ1RPUllfTEVBU0lORyAgMHgwMDAwMDAyMCAvKiBOZXcg
dG8gU01CMyAqLwotLSAKMi4zOS4yCgo=
--0000000000006798290604df37ab--
