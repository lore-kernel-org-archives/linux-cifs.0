Return-Path: <SRS0=UyrF=7M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600D2C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 23:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFF620774
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 23:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gzcwn9ka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgE3XDi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 May 2020 19:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729520AbgE3XDi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 May 2020 19:03:38 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22290C03E969
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2020 16:03:38 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id b62so3146260ybh.8
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2020 16:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=w50qEa13vUloOZC3BoqoktatJ6h2xmJIyk0twZtAbxs=;
        b=Gzcwn9kaG+5CI1ixYQ0vDz38fVpWnZhILeINeZn1TJDlzgXCFSr8st5NQJxdSCEvIL
         VbQ10DUBcSWrlHkbi689NgMdEGmWoYDCtsVGpMmhbuFoteF/8DFAOUCpboYOnit+kjxz
         CXgs6U7PHVAMo2BPrCjt57lt1Q4aXtlw4XZbMi1va3pwO4eNwJu61f7DwmE5OQtm/59c
         0frsikuGwuPHg4IXD+S9uUugGy1R97rGmj0imEk4qZx7KtPC8iuO2Ew4IPQi+M+p+e9c
         b89pizippDbjo7ol9K7C2JrNjORzzUhVqLkw8MDl+IoimnkUhTrw5KpRAUqSOG1XBxKA
         YVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=w50qEa13vUloOZC3BoqoktatJ6h2xmJIyk0twZtAbxs=;
        b=Z3cVKrRCUncMwq7/TPh9hUOZnauKWe9wM/ZdBFnjFbUnbuO+6jak+PpcT8W9VPDHrR
         AIC0yvT1ieuIFzdB2bIivpfkt/VsN2JOcMhnVi6AKel+OBby5YuASntVXPcRYazCNE81
         lTMT64cSOawv8WFjcTF1aMbRE+2H3sLxa4z5qcqn0ItRNC6eZgNvHYbDIjGeQpa0eJ1B
         kV1wGt3jJ+A0J1XA5/54RI39iAGcWCSCrXr28yLAGJH3BxUyhqku07P2LKOYzfMRh6yD
         UmitR/XhU1fUEhnhEFoQ6PgDU+MQb5ieV7c2cJBImluZIoZYACFIhkhTg16tm9Aiz1Kk
         jIDA==
X-Gm-Message-State: AOAM533hIUX5ptlrrsw2BCvW4tras5eNIkYxMVNJAO/eslhveZrF0IAT
        cpa4YfAkxDb44YyLWuF3PQZ2/iOT+D13GPaNSdpy6hsrhiQ=
X-Google-Smtp-Source: ABdhPJwI+A0RUlzBfmkegGN6PxBvYGrcsud8u4sfgI7BV9LBt/WF4psEzK+xxD/0AGy2J2O7iOD+oFzcgoQsE0DFphA=
X-Received: by 2002:a25:3bd8:: with SMTP id i207mr3999811yba.167.1590879817014;
 Sat, 30 May 2020 16:03:37 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 May 2020 18:03:26 -0500
Message-ID: <CAH2r5muqPLibwgguZ+gJBD6HumSDHJYO-wFBxExV_5jYNe6=8w@mail.gmail.com>
Subject: [PATCH][SMB3] multichannel: move channel selection in function
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000005fc81805a6e59214"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005fc81805a6e59214
Content-Type: text/plain; charset="UTF-8"

Wasn't sure if these had been sent to the list again.

This commit moves channel picking code in separate function.

    Signed-off-by: Aurelien Aptel <aaptel@suse.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>



-- 
Thanks,

Steve

--0000000000005fc81805a6e59214
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-multichannel-move-channel-selection-in-function.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-multichannel-move-channel-selection-in-function.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kau8qt2u0>
X-Attachment-Id: f_kau8qt2u0

RnJvbSBhN2NkY2EyZGJkMmJhNzJkYjU5ZmZjYjFjMzk2MTViODAyMDYyMDIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpEYXRl
OiBXZWQsIDIyIEFwciAyMDIwIDE1OjU4OjU3ICswMjAwClN1YmplY3Q6IFtQQVRDSCAxLzRdIGNp
ZnM6IG11bHRpY2hhbm5lbDogbW92ZSBjaGFubmVsIHNlbGVjdGlvbiBpbiBmdW5jdGlvbgoKVGhp
cyBjb21taXQgbW92ZXMgY2hhbm5lbCBwaWNraW5nIGNvZGUgaW4gc2VwYXJhdGUgZnVuY3Rpb24u
CgpTaWduZWQtb2ZmLWJ5OiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lm
cy9jaWZzcHJvdG8uaCB8ICAxICsKIGZzL2NpZnMvdHJhbnNwb3J0LmMgfCAzOCArKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRp
b25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90by5o
IGIvZnMvY2lmcy9jaWZzcHJvdG8uaAppbmRleCAxMmE4OTVlMDJkYjQuLjY5MjgyMmQ0NTIzYSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAorKysgYi9mcy9jaWZzL2NpZnNwcm90by5o
CkBAIC05NSw2ICs5NSw3IEBAIGV4dGVybiBpbnQgY2lmc19jYWxsX2FzeW5jKHN0cnVjdCBUQ1Bf
U2VydmVyX0luZm8gKnNlcnZlciwKIAkJCW1pZF9yZWNlaXZlX3QgKnJlY2VpdmUsIG1pZF9jYWxs
YmFja190ICpjYWxsYmFjaywKIAkJCW1pZF9oYW5kbGVfdCAqaGFuZGxlLCB2b2lkICpjYmRhdGEs
IGNvbnN0IGludCBmbGFncywKIAkJCWNvbnN0IHN0cnVjdCBjaWZzX2NyZWRpdHMgKmV4aXN0X2Ny
ZWRpdHMpOworZXh0ZXJuIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKmNpZnNfcGlja19jaGFubmVs
KHN0cnVjdCBjaWZzX3NlcyAqc2VzKTsKIGV4dGVybiBpbnQgY2lmc19zZW5kX3JlY3YoY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJCQkgIHN0cnVjdCBzbWJf
cnFzdCAqcnFzdCwgaW50ICpyZXNwX2J1Zl90eXBlLAogCQkJICBjb25zdCBpbnQgZmxhZ3MsIHN0
cnVjdCBrdmVjICpyZXNwX2lvdik7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYW5zcG9ydC5jIGIv
ZnMvY2lmcy90cmFuc3BvcnQuYwppbmRleCBjOTc1NzBlYjJjMTguLjZiZTI5M2RkYmE3MiAxMDA2
NDQKLS0tIGEvZnMvY2lmcy90cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3RyYW5zcG9ydC5jCkBA
IC05OTMsNiArOTkzLDMyIEBAIGNpZnNfY2FuY2VsbGVkX2NhbGxiYWNrKHN0cnVjdCBtaWRfcV9l
bnRyeSAqbWlkKQogCURlbGV0ZU1pZFFFbnRyeShtaWQpOwogfQogCisvKgorICogUmV0dXJuIGEg
Y2hhbm5lbCAobWFzdGVyIGlmIG5vbmUpIG9mIEBzZXMgdGhhdCBjYW4gYmUgdXNlZCB0byBzZW5k
CisgKiByZWd1bGFyIHJlcXVlc3RzLgorICoKKyAqIElmIHdlIGFyZSBjdXJyZW50bHkgYmluZGlu
ZyBhIG5ldyBjaGFubmVsIChuZWdwcm90L3Nlc3Muc2V0dXApLAorICogcmV0dXJuIHRoZSBuZXcg
aW5jb21wbGV0ZSBjaGFubmVsLgorICovCitzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpjaWZzX3Bp
Y2tfY2hhbm5lbChzdHJ1Y3QgY2lmc19zZXMgKnNlcykKK3sKKwl1aW50IGluZGV4ID0gMDsKKwor
CWlmICghc2VzKQorCQlyZXR1cm4gTlVMTDsKKworCWlmICghc2VzLT5iaW5kaW5nKSB7CisJCS8q
IHJvdW5kIHJvYmluICovCisJCWlmIChzZXMtPmNoYW5fY291bnQgPiAxKSB7CisJCQlpbmRleCA9
ICh1aW50KWF0b21pY19pbmNfcmV0dXJuKCZzZXMtPmNoYW5fc2VxKTsKKwkJCWluZGV4ICU9IHNl
cy0+Y2hhbl9jb3VudDsKKwkJfQorCQlyZXR1cm4gc2VzLT5jaGFuc1tpbmRleF0uc2VydmVyOwor
CX0gZWxzZSB7CisJCXJldHVybiBjaWZzX3Nlc19zZXJ2ZXIoc2VzKTsKKwl9Cit9CisKIGludAog
Y29tcG91bmRfc2VuZF9yZWN2KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Nl
cyAqc2VzLAogCQkgICBjb25zdCBpbnQgZmxhZ3MsIGNvbnN0IGludCBudW1fcnFzdCwgc3RydWN0
IHNtYl9ycXN0ICpycXN0LApAQCAtMTAxOCwxNyArMTA0NCw3IEBAIGNvbXBvdW5kX3NlbmRfcmVj
dihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJcmV0dXJu
IC1FSU87CiAJfQogCi0JaWYgKCFzZXMtPmJpbmRpbmcpIHsKLQkJdWludCBpbmRleCA9IDA7Ci0K
LQkJaWYgKHNlcy0+Y2hhbl9jb3VudCA+IDEpIHsKLQkJCWluZGV4ID0gKHVpbnQpYXRvbWljX2lu
Y19yZXR1cm4oJnNlcy0+Y2hhbl9zZXEpOwotCQkJaW5kZXggJT0gc2VzLT5jaGFuX2NvdW50Owot
CQl9Ci0JCXNlcnZlciA9IHNlcy0+Y2hhbnNbaW5kZXhdLnNlcnZlcjsKLQl9IGVsc2UgewotCQlz
ZXJ2ZXIgPSBjaWZzX3Nlc19zZXJ2ZXIoc2VzKTsKLQl9CisJc2VydmVyID0gY2lmc19waWNrX2No
YW5uZWwoc2VzKTsKIAogCWlmIChzZXJ2ZXItPnRjcFN0YXR1cyA9PSBDaWZzRXhpdGluZykKIAkJ
cmV0dXJuIC1FTk9FTlQ7Ci0tIAoyLjIwLjEKCg==
--0000000000005fc81805a6e59214--
