Return-Path: <SRS0=LKAl=TF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11EAC004C9
	for <linux-cifs@archiver.kernel.org>; Sun,  5 May 2019 22:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC28E20651
	for <linux-cifs@archiver.kernel.org>; Sun,  5 May 2019 22:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qjSYIVQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfEEW3M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 May 2019 18:29:12 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:42023 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbfEEW3M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 May 2019 18:29:12 -0400
Received: by mail-pg1-f180.google.com with SMTP id p6so5467749pgh.9
        for <linux-cifs@vger.kernel.org>; Sun, 05 May 2019 15:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rD1Yv08Hv+vzxudJDCYCwQ/X/4r80KweD+kvN6bC3jk=;
        b=qjSYIVQMvCZJxnq9DpunzVOa0s27kPATZDONu/AkTVyezeBTuskaASTh1CkTbvoKUC
         8fC+7hpPP/y7U9Pl0lVUGjeV+FmuEDBk+lchMTweqtmCW1AfVE7vJvaiBOyLuPspVt05
         w1HYy7Dc5FUOMszUi5ce2kQ5Xs+rbIDT4YDO20XANpjHberCNeqBz/SuCophaFiAuplW
         Usgv+Tgt7Nd0c2fnSs8KOdMAL2ly+Z1CVs6aJValwDUtr+cDiGznyXDY3nGt866X1/Tk
         BdByxamU8XgprqipH3BHuwv1MQPP/bokru5tQwYV1Ww9DYAj0VJ8UosPU7ufsDUap6lh
         NMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rD1Yv08Hv+vzxudJDCYCwQ/X/4r80KweD+kvN6bC3jk=;
        b=gBIhDI4QxpgLay2/ZfrqfPJY/mYaAUhMgftE3SIdrkkqSu19CiQzlQlvaz+u/3gsBc
         8LAbpgzdVhCMVHUYJd8tdZ00qzDWTJxKodsDSGdzzZx3tFtOTyiuzUFyDq/JDSJB6V/H
         iJyB6C8sHphmxNHjR6ZCBCRShc1RR/udNNM+lWgIlH1WGZjn5YU4ybgIrKUCGxVB6vnn
         QKQ4u9kYTYi3SuqP2KE9vBcBtwITmTM1ncwTozE577LH0R0eVSGCm1zbuaRQCLDCoIa4
         P+bC3P103pIuyw5SeP/PFswxUQxQdltqLNLGGACrao4hT2VbyBK8Gj5+2x/aadTMBhlG
         fk/A==
X-Gm-Message-State: APjAAAXRsfmMx4PuOcSDRbzhKPqGjigVZX6zs0bF5j/Eluy1i/nm61T5
        x/qUZHpdtn66xn9HAFoNwBOS7Kcz+kK/mfrhLj1782mN
X-Google-Smtp-Source: APXvYqzHmxwMzw8+SUBGpd5ytn/U7nXw+Q/qPKxaN3qf8Ko2LJEj4INwkBf+sgFVByE58YOyxisB13J/Ea71nasSh/c=
X-Received: by 2002:a62:479b:: with SMTP id p27mr29969265pfi.111.1557095351164;
 Sun, 05 May 2019 15:29:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 5 May 2019 17:28:59 -0500
Message-ID: <CAH2r5mt+ogjdc9w+ppvu+GwWfojFOK_izStTkOgjs07bXVbO2A@mail.gmail.com>
Subject: [PATCH][SMB3] Add SMB3 protocol flags and structs for change notify
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000049ea1f05882b83f1"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000049ea1f05882b83f1
Content-Type: text/plain; charset="UTF-8"

See MS-FSCC 2.6 and MS-SMB2 2.2.35



-- 
Thanks,

Steve

--00000000000049ea1f05882b83f1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-protocol-structs-for-change-notify-support.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-protocol-structs-for-change-notify-support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jvbicz2m0>
X-Attachment-Id: f_jvbicz2m0

RnJvbSBhZmU1NDg2YTMxMzMwYTE4MWViMGZkMTQwMGQ5ZDQxMjQyY2JiNTFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgNSBNYXkgMjAxOSAxNzoyNToxMiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IEFkZCBwcm90b2NvbCBzdHJ1Y3RzIGZvciBjaGFuZ2Ugbm90aWZ5IHN1cHBvcnQKCkFkZCB0
aGUgU01CMyBwcm90b2NvbCBmbGFnIGRlZmluaXRpb25zIGFuZCBzdHJ1Y3RzIGZvcgpjaGFuZ2Ug
bm90aWZ5LiAgRnV0dXJlIHBhdGNoZXMgd2lsbCBhZGQgdGhlIGhvb2tzIHRvCmFsbG93IGl0IHRv
IGJlIGludm9rZWQgZnJvbSB0aGUgY2xpZW50LgoKU2VlIE1TLUZTQ0MgMi42IGFuZCBNUy1TTUIy
IDIuMi4zNQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5oIHwgMzQgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IDg2OGIwMDU2ODA4
Yy4uNmJiZmFlYzQyMjYzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9j
aWZzL3NtYjJwZHUuaApAQCAtMTE0OCw2ICsxMTQ4LDQwIEBAIHN0cnVjdCBzbWIyX3dyaXRlX3Jz
cCB7CiAJX191OCAgIEJ1ZmZlclsxXTsKIH0gX19wYWNrZWQ7CiAKKy8qIG5vdGlmeSBmbGFncyAq
LworI2RlZmluZSBTTUIyX1dBVENIX1RSRUUJCQkweDAwMDEKKworLyogbm90aWZ5IGNvbXBsZXRp
b24gZmlsdGVyIGZsYWdzLiBTZWUgTVMtRlNDQyAyLjYgYW5kIE1TLVNNQjIgMi4yLjM1ICovCisj
ZGVmaW5lIEZJTEVfTk9USUZZX0NIQU5HRV9GSUxFX05BTUUJCTB4MDAwMDAwMDEKKyNkZWZpbmUg
RklMRV9OT1RJRllfQ0hBTkdFX0RJUl9OQU1FCQkweDAwMDAwMDAyCisjZGVmaW5lIEZJTEVfTk9U
SUZZX0NIQU5HRV9BVFRSSUJVVEVTCQkweDAwMDAwMDA0CisjZGVmaW5lIEZJTEVfTk9USUZZX0NI
QU5HRV9TSVpFCQkJMHgwMDAwMDAwOAorI2RlZmluZSBGSUxFX05PVElGWV9DSEFOR0VfTEFTVF9X
UklURQkJMHgwMDAwMDAxMAorI2RlZmluZSBGSUxFX05PVElGWV9DSEFOR0VfTEFTVF9BQ0NFU1MJ
CTB4MDAwMDAwMjAKKyNkZWZpbmUgRklMRV9OT1RJRllfQ0hBTkdFX0NSRUFUSU9OCQkweDAwMDAw
MDQwCisjZGVmaW5lIEZJTEVfTk9USUZZX0NIQU5HRV9FQQkJCTB4MDAwMDAwODAKKyNkZWZpbmUg
RklMRV9OT1RJRllfQ0hBTkdFX1NFQ1VSSVRZCQkweDAwMDAwMTAwCisjZGVmaW5lIEZJTEVfTk9U
SUZZX0NIQU5HRV9TVFJFQU1fTkFNRQkJMHgwMDAwMDIwMAorI2RlZmluZSBGSUxFX05PVElGWV9D
SEFOR0VfU1RSRUFNX1NJWkUJCTB4MDAwMDA0MDAKKyNkZWZpbmUgRklMRV9OT1RJRllfQ0hBTkdF
X1NUUkVBTV9XUklURQkJMHgwMDAwMDgwMAorCitzdHJ1Y3Qgc21iMl9jaGFuZ2Vfbm90aWZ5X3Jl
cSB7CisJX19sZTE2CVN0cnVjdHVyZVNpemU7CisJX19sZTE2CUZsYWdzOworCV9fbGUzMglPdXRw
dXRCdWZmZXJMZW5ndGg7CisJX191NjQJUGVyc2lzdGVudEZpbGVJZDsgLyogb3BhcXVlIGVuZGlh
bm5lc3MgKi8KKwlfX3U2NAlWb2xhdGlsZUZpbGVJZDsgLyogb3BhcXVlIGVuZGlhbm5lc3MgKi8K
KwlfX2xlMzIJQ29tcGxldGlvbkZpbHRlcjsKKwlfX3UzMglSZXNlcnZlZDsKK30gX19wYWNrZWQ7
CisKK3N0cnVjdCBzbWIyX2NoYW5nZV9ub3RpZnlfcnNwIHsKKwlfX2xlMTYJU3RydWN0dXJlU2l6
ZTsgIC8qIE11c3QgYmUgOSAqLworCV9fbGUxNglPdXRwdXRCdWZmZXJPZmZzZXQ7CisJX19sZTMy
CU91dHB1dEJ1ZmZlckxlbmd0aDsKKwlfX3U4CUJ1ZmZlclsxXTsgLyogYXJyYXkgb2YgZmlsZSBu
b3RpZnkgc3RydWN0cyAqLworfSBfX3BhY2tlZDsKKwogI2RlZmluZSBTTUIyX0xPQ0tGTEFHX1NI
QVJFRF9MT0NLCTB4MDAwMQogI2RlZmluZSBTTUIyX0xPQ0tGTEFHX0VYQ0xVU0lWRV9MT0NLCTB4
MDAwMgogI2RlZmluZSBTTUIyX0xPQ0tGTEFHX1VOTE9DSwkJMHgwMDA0Ci0tIAoyLjIwLjEKCg==
--00000000000049ea1f05882b83f1--
