Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DF6C4332F
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Dec 2022 22:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLHWPS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Dec 2022 17:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLHWPP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Dec 2022 17:15:15 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A85379C07
        for <linux-cifs@vger.kernel.org>; Thu,  8 Dec 2022 14:15:12 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id bp15so4142852lfb.13
        for <linux-cifs@vger.kernel.org>; Thu, 08 Dec 2022 14:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g9xmW1UggWnZTp85GQL/J0JoRg9OP7OyQyiVbELdzIg=;
        b=QgTr2c/ZKcGE9eyoGLmAAlYTVlbcRFVPOyR6SVG6F/0NPZKR7e9ObYd2BtaWDfM7h+
         F33stNV8cws+k2bMxKJj5dAqLG5wMDt5rqMH+MH/O6L3j9ed0Eo/Xxg2Jw3hY6KBgx9Q
         y+0DI/IU7KrCsFcnbgKQyDqs60OkH5ZZklnoObpvaMHjGuUkcsZTXTtozE/ZytZ1Jesr
         SHZPQ7cSvdv0Jtr9YEqcIpMjclGpdoli4YMgsI5gAdmoKHhwZN10FvAUqQKwGCvYyaFy
         JC3hTYgV6K9Lp4hQzGmtd/hMsv8LnBQ/ssAGdvU0H1jCzG1kUAK0drHi7r3vw5W9MFKa
         a3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g9xmW1UggWnZTp85GQL/J0JoRg9OP7OyQyiVbELdzIg=;
        b=hETrUZPtargJPd5SjzWMo282FJA3kp5l4Vxh4UpWr+A/xFVbVgY9wRfFVgCy3yaLnZ
         BwX/4PnIH0eqFFKI0IJBUByBXgURi/OtriEdfuwQS5wiN46aKsWxSTIE6vMyxSaUzwLO
         EH0oSkKBpt7wl0Jlr5UL4yMtS0dAEPvnqdVTAhQnm9O2hm0yfLA9wr6P4Nr0eje7778u
         4SHdhX+0Ka3VXfaP/Hp8iCVcbRY836VSQ9CWvN2e+Ut4mUiuqrk+5lhwuTqUXRvVIVmI
         hYDp0Cu2TgAOCg6mgC0mh1oALbEBykE4lqLwV/WJai87//hq92IDqGYTTPOsZdLD7Cgr
         AfLw==
X-Gm-Message-State: ANoB5pnTsWuqsJdPPymhwTYHBpQ0JzRrr43Td/JIp8AWrmBR8NaS6AP/
        5pDf7xi2WZh6To+GdL6vpV6KJ5hgh3ctT68a/j34mHH+8OY=
X-Google-Smtp-Source: AA0mqf7yU5e8J8Uw4y78wT5Ll4da6U0OhpdB1aRn+WjKiwkaxp6Iaue8nQtw21JAJePUDcG2NhApX4EC2LMYsfgHHt4=
X-Received: by 2002:ac2:4bd1:0:b0:4a2:4dc3:a2e with SMTP id
 o17-20020ac24bd1000000b004a24dc30a2emr26932422lfq.403.1670537710041; Thu, 08
 Dec 2022 14:15:10 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Dec 2022 16:14:58 -0600
Message-ID: <CAH2r5ms=n5_0OUeE9ro8MD3w9dG=bMm=_koqCW6x_KjTvuJoUw@mail.gmail.com>
Subject: [[PATCH][CIFS] minor cleanup of some headers pointed out by checkpatch
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000cb15dd05ef585e51"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cb15dd05ef585e51
Content-Type: text/plain; charset="UTF-8"

See attached for minor cleanup of some cifs.ko headers



-- 
Thanks,

Steve

--000000000000cb15dd05ef585e51
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-minor-cleanup-of-some-headers.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-minor-cleanup-of-some-headers.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lbfn0fjt0>
X-Attachment-Id: f_lbfn0fjt0

RnJvbSBlY2RlNzg1MDA0MGNjNjU3OTE3MGQzNmZmZTZhNDBjOTBmZDdlNGM5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOCBEZWMgMjAyMiAxNjoxMTowMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IG1pbm9yIGNsZWFudXAgb2Ygc29tZSBoZWFkZXJzCgpjaGVja3BhdGNoIHNob3dlZCBmb3Jt
YXR0aW5nIHByb2JsZW1zIHdpdGggZXh0cmEgc3BhY2VzLAphbmQgZXh0cmEgc2VtaWNvbG9uIGFu
ZCBzb21lIG1pc3NpbmcgYmxhbmsgbGluZXMgaW4gc29tZQpjaWZzIGhlYWRlcnMuCgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lm
cy9jaWZzX2lvY3RsLmggfCAyICstCiBmcy9jaWZzL2NpZnNmcy5oICAgICB8IDQgKystLQogZnMv
Y2lmcy9jaWZzZ2xvYi5oICAgfCA3ICsrKysrLS0KIDMgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRp
b25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc19pb2N0bC5o
IGIvZnMvY2lmcy9jaWZzX2lvY3RsLmgKaW5kZXggZDg2ZDc4ZDViZmRjLi4zMzI1ODhlNzdjMzEg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19pb2N0bC5oCisrKyBiL2ZzL2NpZnMvY2lmc19pb2N0
bC5oCkBAIC0xMDgsNyArMTA4LDcgQEAgc3RydWN0IHNtYjNfbm90aWZ5X2luZm8gewogI2RlZmlu
ZSBDSUZTX0lPQ19OT1RJRlkgX0lPVyhDSUZTX0lPQ1RMX01BR0lDLCA5LCBzdHJ1Y3Qgc21iM19u
b3RpZnkpCiAjZGVmaW5lIENJRlNfRFVNUF9GVUxMX0tFWSBfSU9XUihDSUZTX0lPQ1RMX01BR0lD
LCAxMCwgc3RydWN0IHNtYjNfZnVsbF9rZXlfZGVidWdfaW5mbykKICNkZWZpbmUgQ0lGU19JT0Nf
Tk9USUZZX0lORk8gX0lPV1IoQ0lGU19JT0NUTF9NQUdJQywgMTEsIHN0cnVjdCBzbWIzX25vdGlm
eV9pbmZvKQotI2RlZmluZSBDSUZTX0lPQ19TSFVURE9XTiBfSU9SICgnWCcsIDEyNSwgX191MzIp
CisjZGVmaW5lIENJRlNfSU9DX1NIVVRET1dOIF9JT1IoJ1gnLCAxMjUsIF9fdTMyKQogCiAvKgog
ICogRmxhZ3MgZm9yIGdvaW5nIGRvd24gb3BlcmF0aW9uCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Np
ZnNmcy5oIGIvZnMvY2lmcy9jaWZzZnMuaAppbmRleCAzODhiNzQ1YTk3OGUuLjAwYTU3M2UwYWQw
ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuaAorKysgYi9mcy9jaWZzL2NpZnNmcy5oCkBA
IC0xMDUsOCArMTA1LDggQEAgZXh0ZXJuIGludCBjaWZzX2xvY2soc3RydWN0IGZpbGUgKiwgaW50
LCBzdHJ1Y3QgZmlsZV9sb2NrICopOwogZXh0ZXJuIGludCBjaWZzX2ZzeW5jKHN0cnVjdCBmaWxl
ICosIGxvZmZfdCwgbG9mZl90LCBpbnQpOwogZXh0ZXJuIGludCBjaWZzX3N0cmljdF9mc3luYyhz
dHJ1Y3QgZmlsZSAqLCBsb2ZmX3QsIGxvZmZfdCwgaW50KTsKIGV4dGVybiBpbnQgY2lmc19mbHVz
aChzdHJ1Y3QgZmlsZSAqLCBmbF9vd25lcl90IGlkKTsKLWV4dGVybiBpbnQgY2lmc19maWxlX21t
YXAoc3RydWN0IGZpbGUgKiAsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqKTsKLWV4dGVybiBpbnQg
Y2lmc19maWxlX3N0cmljdF9tbWFwKHN0cnVjdCBmaWxlICogLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1
Y3QgKik7CitleHRlcm4gaW50IGNpZnNfZmlsZV9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1
Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSk7CitleHRlcm4gaW50IGNpZnNfZmlsZV9zdHJpY3RfbW1h
cChzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpOwogZXh0ZXJu
IGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgY2lmc19kaXJfb3BzOwogZXh0ZXJuIGludCBj
aWZzX2Rpcl9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKTsKIGV4
dGVybiBpbnQgY2lmc19yZWFkZGlyKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgZGlyX2NvbnRl
eHQgKmN0eCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNn
bG9iLmgKaW5kZXggMTQyMGFjZjk4N2YwLi5jZDNhMTczZTY1YjEgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTc4NSw2ICs3ODUsNyBA
QCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludAogaW5fZmxpZ2h0KHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlcikKIHsKIAl1bnNpZ25lZCBpbnQgbnVtOworCiAJc3Bpbl9sb2NrKCZzZXJ2
ZXItPnJlcV9sb2NrKTsKIAludW0gPSBzZXJ2ZXItPmluX2ZsaWdodDsKIAlzcGluX3VubG9jaygm
c2VydmVyLT5yZXFfbG9jayk7CkBAIC03OTUsNiArNzk2LDcgQEAgc3RhdGljIGlubGluZSBib29s
CiBoYXNfY3JlZGl0cyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsIGludCAqY3JlZGl0
cywgaW50IG51bV9jcmVkaXRzKQogewogCWludCBudW07CisKIAlzcGluX2xvY2soJnNlcnZlci0+
cmVxX2xvY2spOwogCW51bSA9ICpjcmVkaXRzOwogCXNwaW5fdW5sb2NrKCZzZXJ2ZXItPnJlcV9s
b2NrKTsKQEAgLTEwMjUsNyArMTAyNyw3IEBAIHN0cnVjdCBjaWZzX3NlcyB7CiAJc3RydWN0IFRD
UF9TZXJ2ZXJfSW5mbyAqc2VydmVyOwkvKiBwb2ludGVyIHRvIHNlcnZlciBpbmZvICovCiAJaW50
IHNlc19jb3VudDsJCS8qIHJlZmVyZW5jZSBjb3VudGVyICovCiAJZW51bSBzZXNfc3RhdHVzX2Vu
dW0gc2VzX3N0YXR1czsgIC8qIHVwZGF0ZXMgcHJvdGVjdGVkIGJ5IGNpZnNfdGNwX3Nlc19sb2Nr
ICovCi0JdW5zaWduZWQgb3ZlcnJpZGVTZWNGbGc7ICAvKiBpZiBub24temVybyBvdmVycmlkZSBn
bG9iYWwgc2VjIGZsYWdzICovCisJdW5zaWduZWQgaW50IG92ZXJyaWRlU2VjRmxnOyAvKiBpZiBu
b24temVybyBvdmVycmlkZSBnbG9iYWwgc2VjIGZsYWdzICovCiAJY2hhciAqc2VydmVyT1M7CQkv
KiBuYW1lIG9mIG9wZXJhdGluZyBzeXN0ZW0gdW5kZXJseWluZyBzZXJ2ZXIgKi8KIAljaGFyICpz
ZXJ2ZXJOT1M7CS8qIG5hbWUgb2YgbmV0d29yayBvcGVyYXRpbmcgc3lzdGVtIG9mIHNlcnZlciAq
LwogCWNoYXIgKnNlcnZlckRvbWFpbjsJLyogc2VjdXJpdHkgcmVhbG0gb2Ygc2VydmVyICovCkBA
IC0xMzgxLDcgKzEzODMsNyBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvIHsKIAlfX3UzMiBwaWQ7CQkv
KiBwcm9jZXNzIGlkIHdobyBvcGVuZWQgZmlsZSAqLwogCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CS8q
IGZpbGUgaWQgZnJvbSByZW1vdGUgKi8KIAlzdHJ1Y3QgbGlzdF9oZWFkIHJsaXN0OyAvKiByZWNv
bm5lY3QgbGlzdCAqLwotCS8qIEJCIGFkZCBsb2NrIHNjb3BlIGluZm8gaGVyZSBpZiBuZWVkZWQg
Ki8gOworCS8qIEJCIGFkZCBsb2NrIHNjb3BlIGluZm8gaGVyZSBpZiBuZWVkZWQgKi8KIAkvKiBs
b2NrIHNjb3BlIGlkICgwIGlmIG5vbmUpICovCiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5OwogCXN0
cnVjdCB0Y29uX2xpbmsgKnRsaW5rOwpAQCAtMTc2OSw2ICsxNzcxLDcgQEAgc3RhdGljIGlubGlu
ZSB2b2lkIGZyZWVfZGZzX2luZm9fYXJyYXkoc3RydWN0IGRmc19pbmZvM19wYXJhbSAqcGFyYW0s
CiAJCQkJICAgICAgIGludCBudW1iZXJfb2ZfaXRlbXMpCiB7CiAJaW50IGk7CisKIAlpZiAoKG51
bWJlcl9vZl9pdGVtcyA9PSAwKSB8fCAocGFyYW0gPT0gTlVMTCkpCiAJCXJldHVybjsKIAlmb3Ig
KGkgPSAwOyBpIDwgbnVtYmVyX29mX2l0ZW1zOyBpKyspIHsKLS0gCjIuMzQuMQoK
--000000000000cb15dd05ef585e51--
