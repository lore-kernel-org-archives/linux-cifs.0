Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF597E95A8D
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Oct 2023 04:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345030AbjJIEPZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Oct 2023 00:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345004AbjJIEPY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Oct 2023 00:15:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04BBA4
        for <linux-cifs@vger.kernel.org>; Sun,  8 Oct 2023 21:15:22 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-50305abe5f0so5370463e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 08 Oct 2023 21:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696824921; x=1697429721; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IqBxmam5F7+VnQZu3In8O7rmGARTjuwgmHOYYCwTnJs=;
        b=RkdbehIBVb+OELuLk9iJZcwwZmepuRpWyzsORYRqupv8aeOvq9sOO+deD135/EwTzs
         SIDrXsVBYZ/wMnnU127cFKQMaFY9X4kJl4AjJ+SvOtHUSbviKHN0tzIaymmhEt5fsfHu
         A+15oWYLsuLGMCD1O6byqaa3R0Zda4J5+XF4wUYJ4ZflpBhLcOLWSg7xhIVeNogCM1Pw
         OjsfdTUnzAL53pvNgZGDzphFs2z5oz0T1BBA4UWJABGCSvVpPC/Gy4j86OG1wF5DUo4Z
         JbFlTK2nR1tPeZn1SowOhhZWvQHbirhNYVB4aQ9W9MRIG+bBhqPZKkew4/cytMK8yZdI
         1p/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696824921; x=1697429721;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IqBxmam5F7+VnQZu3In8O7rmGARTjuwgmHOYYCwTnJs=;
        b=kaRqAxIVTDV5K1ZEA7zhxi6u3dw6tlle8uZedKjd+4Wu3CohwPIzf2h+Q7oeppI7Eb
         0wRlOb2HN5YwiwroIxO7Qx3AkFcXB2Akl+tG1WCI6gmE8ZjKaRgt4lEQia8gOo/pyQeu
         kFgf/kwGTrd24WKGTUdJ4n/vhItjD2XtjQMrz6RcfFHhUSetn6R6u0formXEXCGCN04J
         Dvv1MOZA5ZUgLiLKDJbc9syNZjDdjyjfxHWmFtImO1nOknkw0g1OQ1k8jVHHkLfoCiv+
         Y7mqVu2hcsOA9uUpNB3GRpzhg4xMCAN3RFtMtlsSL+8aSLWoZVk9Jq+B9dg47+M3bSy0
         pqQA==
X-Gm-Message-State: AOJu0Yzh3LNTxpKRrfukMKW/MumQQyp7UxTlDe9/zjW6U2On8h6+LTJE
        p1DJApQmoe4SXcK35OubxQYnQTOYzqWiA5A9pociMCy1iPE=
X-Google-Smtp-Source: AGHT+IFnrNsj4JYHGAjDAAG0TP0UsOX5fkVRc3A2ywMdHcnuHboz/BKiPDvRO8E6ah/9S9NY3vXPY85/AezIW2IKBu0=
X-Received: by 2002:a05:6512:758:b0:503:59d:fbff with SMTP id
 c24-20020a056512075800b00503059dfbffmr3610209lfs.2.1696824920645; Sun, 08 Oct
 2023 21:15:20 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 8 Oct 2023 23:15:09 -0500
Message-ID: <CAH2r5mvxf3j6aXGdzh8b7cRYJ=fHvjfkv=aHPStJRYR+x8auiA@mail.gmail.com>
Subject: New SMB3.1.1 command
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000a4d2f4060740d6db"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a4d2f4060740d6db
Content-Type: text/plain; charset="UTF-8"

Add structs and defines for new SMB3.1.1 command, server to client notification.

    See MS-SMB2 section 2.2.44

Also another minor patch to clarify some of the unused CreateOptions flags

   See MS-SMB2 section 2.2.13

See attached.
-- 
Thanks,

Steve

--000000000000a4d2f4060740d6db
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Add-definition-for-new-smb3.1.1-command-type.patch"
Content-Disposition: attachment; 
	filename="0001-Add-definition-for-new-smb3.1.1-command-type.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lnidq4bl0>
X-Attachment-Id: f_lnidq4bl0

RnJvbSBiYzZiYjNjMGM4ODgzZjY0ODA2MTFkMjg0NTFmYzI5YWY5NjcyNmQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgOCBPY3QgMjAyMyAyMzowNDowMSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIEFk
ZCBkZWZpbml0aW9uIGZvciBuZXcgc21iMy4xLjEgY29tbWFuZCB0eXBlCgpBZGQgc3RydWN0cyBh
bmQgZGVmaW5lcyBmb3IgbmV3IFNNQjMuMS4xIGNvbW1hbmQsIHNlcnZlciB0byBjbGllbnQgbm90
aWZpY2F0aW9uLgoKU2VlIE1TLVNNQjIgc2VjdGlvbiAyLjIuNDQKClNpZ25lZC1vZmYtYnk6IFN0
ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY29tbW9uL3Nt
YjJwZHUuaCB8IDE1ICsrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlv
bnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvY29tbW9uL3NtYjJwZHUuaCBiL2ZzL3NtYi9jb21t
b24vc21iMnBkdS5oCmluZGV4IDMxOWZiOWZmYzZhMC4uNzNjZGNmMTRlZjI3IDEwMDY0NAotLS0g
YS9mcy9zbWIvY29tbW9uL3NtYjJwZHUuaAorKysgYi9mcy9zbWIvY29tbW9uL3NtYjJwZHUuaApA
QCAtMzQsNiArMzQsNyBAQAogI2RlZmluZSBTTUIyX1FVRVJZX0lORk9fSEUJMHgwMDEwCiAjZGVm
aW5lIFNNQjJfU0VUX0lORk9fSEUJMHgwMDExCiAjZGVmaW5lIFNNQjJfT1BMT0NLX0JSRUFLX0hF
CTB4MDAxMgorI2RlZmluZSBTTUIyX1NFUlZFUl9UT19DTElFTlRfTk9USUZJQ0FUSU9OIDB4MDAx
MwogCiAvKiBUaGUgc2FtZSBsaXN0IGluIGxpdHRsZSBlbmRpYW4gKi8KICNkZWZpbmUgU01CMl9O
RUdPVElBVEUJCWNwdV90b19sZTE2KFNNQjJfTkVHT1RJQVRFX0hFKQpAQCAtNDExLDYgKzQxMiw3
IEBAIHN0cnVjdCBzbWIyX3RyZWVfZGlzY29ubmVjdF9yc3AgewogI2RlZmluZSBTTUIyX0dMT0JB
TF9DQVBfUEVSU0lTVEVOVF9IQU5ETEVTIDB4MDAwMDAwMTAgLyogTmV3IHRvIFNNQjMgKi8KICNk
ZWZpbmUgU01CMl9HTE9CQUxfQ0FQX0RJUkVDVE9SWV9MRUFTSU5HICAweDAwMDAwMDIwIC8qIE5l
dyB0byBTTUIzICovCiAjZGVmaW5lIFNNQjJfR0xPQkFMX0NBUF9FTkNSWVBUSU9OCTB4MDAwMDAw
NDAgLyogTmV3IHRvIFNNQjMgKi8KKyNkZWZpbmUgU01CMl9HTE9CQUxfQ0FQX05PVElGSUNBVElP
TlMJMHgwMDAwMDA4MCAvKiBOZXcgdG8gU01CMy4xLjEgKi8KIC8qIEludGVybmFsIHR5cGVzICov
CiAjZGVmaW5lIFNNQjJfTlRfRklORAkJCTB4MDAxMDAwMDAKICNkZWZpbmUgU01CMl9MQVJHRV9G
SUxFUwkJMHgwMDIwMDAwMApAQCAtOTgxLDYgKzk4MywxOSBAQCBzdHJ1Y3Qgc21iMl9jaGFuZ2Vf
bm90aWZ5X3JzcCB7CiAJX191OAlCdWZmZXJbXTsgLyogYXJyYXkgb2YgZmlsZSBub3RpZnkgc3Ry
dWN0cyAqLwogfSBfX3BhY2tlZDsKIAorLyoKKyAqIFNNQjJfU0VSVkVSX1RPX0NMSUVOVF9OT1RJ
RklDQVRJT046IFNlZSBNUy1TTUIyIHNlY3Rpb24gMi4yLjQ0CisgKi8KKworI2RlZmluZSBTTUIy
X05PVElGWV9TRVNTSU9OX0NMT1NFRAkweDAwMDAKKworc3RydWN0IHNtYjJfc2VydmVyX2NsaWVu
dF9ub3RpZmljYXRpb24geworCXN0cnVjdCBzbWIyX2hkciBoZHI7CisJX19sZTE2CVN0cnVjdHVy
ZVNpemU7CisJX191MTYJUmVzZXJ2ZWQ7IC8qIE1CWiAqLworCV9fbGUzMglOb3RpZmljYXRpb25U
eXBlOworCV9fdTgJTm90aWZpY2F0aW9uQnVmZmVyWzRdOyAvKiBNQlogKi8KK30gX19wYWNrZWQ7
CiAKIC8qCiAgKiBTTUIyX0NSRUFURSAgU2VlIE1TLVNNQjIgc2VjdGlvbiAyLjIuMTMKLS0gCjIu
MzkuMgoK
--000000000000a4d2f4060740d6db
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-clarify-some-of-the-unused-CreateOption-flags.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-clarify-some-of-the-unused-CreateOption-flags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lnidqhwh1>
X-Attachment-Id: f_lnidqhwh1

RnJvbSAzN2E1MmNlYjliN2I2ZTA5ODg0NjQ3MmUxYjgxZWU5NWJmYzBmNmNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgOCBPY3QgMjAyMyAyMzoxMTozOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjM6IGNsYXJpZnkgc29tZSBvZiB0aGUgdW51c2VkIENyZWF0ZU9wdGlvbiBmbGFncwoKVXBkYXRl
IGNvbW1lbnRzIHRvIHNob3cgZmxhZ3Mgd2hpY2ggc2hvdWxkIGJlIG5vdCBzZXQgKHplcm8pLgoK
U2VlIE1TLVNNQjIgc2VjdGlvbiAyLjIuMTMKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY29tbW9uL3NtYjJwZHUuaCB8IDkg
KysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NvbW1vbi9zbWIycGR1LmggYi9mcy9zbWIvY29tbW9uL3Nt
YjJwZHUuaAppbmRleCA3M2NkY2YxNGVmMjcuLjhhNDY5OTI5Y2Y2MiAxMDA2NDQKLS0tIGEvZnMv
c21iL2NvbW1vbi9zbWIycGR1LmgKKysrIGIvZnMvc21iL2NvbW1vbi9zbWIycGR1LmgKQEAgLTEx
MTIsMTYgKzExMTIsMjMgQEAgc3RydWN0IHNtYjJfc2VydmVyX2NsaWVudF9ub3RpZmljYXRpb24g
ewogI2RlZmluZSBGSUxFX1dSSVRFX1RIUk9VR0hfTEUJCWNwdV90b19sZTMyKDB4MDAwMDAwMDIp
CiAjZGVmaW5lIEZJTEVfU0VRVUVOVElBTF9PTkxZX0xFCQljcHVfdG9fbGUzMigweDAwMDAwMDA0
KQogI2RlZmluZSBGSUxFX05PX0lOVEVSTUVESUFURV9CVUZGRVJJTkdfTEUgY3B1X3RvX2xlMzIo
MHgwMDAwMDAwOCkKKy8qIEZJTEVfU1lOQ0hST05PVVNfSU9fQUxFUlRfTEUJCWNwdV90b19sZTMy
KDB4MDAwMDAwMTApIHNob3VsZCBiZSB6ZXJvLCBpZ25vcmVkICovCisvKiBGSUxFX1NZTkNIUk9O
T1VTX0lPX05PTkFMRVJUCQljcHVfdG9fbGUzMigweDAwMDAwMDIwKSBzaG91bGQgYmUgemVybywg
aWdub3JlZCAqLwogI2RlZmluZSBGSUxFX05PTl9ESVJFQ1RPUllfRklMRV9MRQljcHVfdG9fbGUz
MigweDAwMDAwMDQwKQogI2RlZmluZSBGSUxFX0NPTVBMRVRFX0lGX09QTE9DS0VEX0xFCWNwdV90
b19sZTMyKDB4MDAwMDAxMDApCiAjZGVmaW5lIEZJTEVfTk9fRUFfS05PV0xFREdFX0xFCQljcHVf
dG9fbGUzMigweDAwMDAwMjAwKQorLyogRklMRV9PUEVOX1JFTU9URV9JTlNUQU5jRQkJY3B1X3Rv
X2xlMzIoMHgwMDAwMDQwMCkgc2hvdWxkIGJlIHplcm8sIGlnbm9yZWQgKi8KICNkZWZpbmUgRklM
RV9SQU5ET01fQUNDRVNTX0xFCQljcHVfdG9fbGUzMigweDAwMDAwODAwKQotI2RlZmluZSBGSUxF
X0RFTEVURV9PTl9DTE9TRV9MRQkJY3B1X3RvX2xlMzIoMHgwMDAwMTAwMCkKKyNkZWZpbmUgRklM
RV9ERUxFVEVfT05fQ0xPU0VfTEUJCWNwdV90b19sZTMyKDB4MDAwMDEwMDApIC8qIE1CWiAqLwog
I2RlZmluZSBGSUxFX09QRU5fQllfRklMRV9JRF9MRQkJY3B1X3RvX2xlMzIoMHgwMDAwMjAwMCkK
ICNkZWZpbmUgRklMRV9PUEVOX0ZPUl9CQUNLVVBfSU5URU5UX0xFCWNwdV90b19sZTMyKDB4MDAw
MDQwMDApCiAjZGVmaW5lIEZJTEVfTk9fQ09NUFJFU1NJT05fTEUJCWNwdV90b19sZTMyKDB4MDAw
MDgwMDApCisvKiBGSUxFX09QRU5fUkVRVUlSSU5HX09QTE9DSwkJY3B1X3RvX2xlMzIoMHgwMDAx
MDAwMCkgc2hvdWxkIGJlIHplcm8sIGlnbm9yZWQgKi8KKy8qIEZJTEVfRElTQUxMT1dfRVhDTFVT
SVZFCQljcHVfdG9fbGUzMigweDAwMDIwMDAwKSBzaG91bGQgYmUgemVybywgaWdub3JlZCAqLwor
LyogRklMRV9SRVNFUlZFX09QRklMVEVSCQljcHVfdG9fbGUzMigweDAwMTAwMDAwKSBNQlogKi8K
ICNkZWZpbmUgRklMRV9PUEVOX1JFUEFSU0VfUE9JTlRfTEUJY3B1X3RvX2xlMzIoMHgwMDIwMDAw
MCkKICNkZWZpbmUgRklMRV9PUEVOX05PX1JFQ0FMTF9MRQkJY3B1X3RvX2xlMzIoMHgwMDQwMDAw
MCkKKy8qICNkZWZpbmUgRklMRV9PUEVOX0ZPUl9GUkVFX1NQQUNFX1FVRVJZIGNwdV90b19sZTMy
KDB4MDA4MDAwMDApIHNob3VsZCBiZSB6ZXJvLCBpZ25vcmVkICovCiAjZGVmaW5lIENSRUFURV9P
UFRJT05TX01BU0tfTEUgICAgICAgICAgY3B1X3RvX2xlMzIoMHgwMEZGRkZGRikKIAogI2RlZmlu
ZSBGSUxFX1JFQURfUklHSFRTX0xFIChGSUxFX1JFQURfREFUQV9MRSB8IEZJTEVfUkVBRF9FQV9M
RSBcCi0tIAoyLjM5LjIKCg==
--000000000000a4d2f4060740d6db--
