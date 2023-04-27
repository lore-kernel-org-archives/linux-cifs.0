Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095FBC77B60
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Apr 2023 03:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbjD0DJ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Apr 2023 23:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242895AbjD0DJZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Apr 2023 23:09:25 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924F440DA
        for <linux-cifs@vger.kernel.org>; Wed, 26 Apr 2023 20:09:23 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2a8dd1489b0so76919251fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Apr 2023 20:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682564961; x=1685156961;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xf+gurgH4g455L2T8b5XNhCtdmfV7A+6I1FsTUYGsi0=;
        b=JO+gP0AXlZLdtQi5MTNxY90WCF+JhjEwohXf8rLqa6rEheAdq4+UR8ECIun5mwrRKM
         RQ+r2747TmE8z6WUPMivBwg1I9SJ+VJZX+ntwlh+OjOGumfKJfK1fbTQMLj9RiJT8jNd
         ilFoOctmuXZ3ZJFNFyiMNmd+oweiLYJjuBjsQd3ZTrMhOGPiP+BUm07E/Ulc80qxuD/h
         ZTdtSpDgciHtLWAFh9ABGAc5xnV1mSp2d4Tp1jRgGrZVlZgFMEKr5udq0d7fTGce3BLj
         vHxJ/QyMicSn/FJuEQbdFIBo2hCAg9QMxsnt0QGzSfQevsf9IuwnWIa4Xcc74HZDi3li
         fsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682564961; x=1685156961;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xf+gurgH4g455L2T8b5XNhCtdmfV7A+6I1FsTUYGsi0=;
        b=l0dE3otH2abjLZUoXAnEp4B6sHKqYARAvD3/4/qHiwLaIdBRyWQP0z2yigEh7Mzn2t
         6rR/PfBr5qbnZkbEelf3X6iImXW0jSljQL9BThG37KV7IQwTGf2i3lXCLt+VzeBLdgm8
         KDmHiIFHplAhLoBU0obUCcC7QEQsDetmbEpgOB02/dYMJo3WraMX8+AGGUYF3PqC+vW7
         +ZbAq64nf8OPdRaKush2/Go/o+LnRqY1eYy3bzpZ7UkBFnTnfxpNWIXtH9OM30CSpFKy
         CxpqNaIfgCNI8FUGahKTJPJ3ZOZ8eIySdGIxqGp+ozPlGwXyQXtwtLNLSIZwmndii7+a
         wOBA==
X-Gm-Message-State: AC+VfDxpTEOLdsUrcGiCoAc5xG58KNdMXZaRW/wnkNFuWCfLxtyQI1mG
        XQPbxpCimF8SES85cd2kOXxXoWwQL6famnnBU+8YqNlmV5k=
X-Google-Smtp-Source: ACHHUZ6I9t4sJOqos8UudO4WLVIPUXtG0QDDReJZBgnl1B1GeP0JUCkE57j718zcGxxIYtrXsi1Sl2QxVTQ7gm6psRM=
X-Received: by 2002:ac2:5930:0:b0:4eb:1527:e2a7 with SMTP id
 v16-20020ac25930000000b004eb1527e2a7mr68250lfi.45.1682564961231; Wed, 26 Apr
 2023 20:09:21 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 26 Apr 2023 22:09:10 -0500
Message-ID: <CAH2r5msM9ayyLmijEWjTQJN_kn-gy_Jp5BQRRYuhc-KYqRqYoA@mail.gmail.com>
Subject: [PATCH][CIFS] missing lock when updating session status
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d3793505fa48ae50"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d3793505fa48ae50
Content-Type: text/plain; charset="UTF-8"

Coverity noted a place where we were not grabbing
the ses_lock when setting (and checking) ses_status.

Addresses-Coverity: 1536833 ("Data race condition (MISSING_LOCK)")


-- 
Thanks,

Steve

--000000000000d3793505fa48ae50
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-missing-lock-when-updating-session-status.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-missing-lock-when-updating-session-status.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lgyjq48c0>
X-Attachment-Id: f_lgyjq48c0

RnJvbSAzOTBjOTBjMjkyOGEzM2YyNjMyZTlkNjY4Y2QzYjViNzY5YzliMWU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjYgQXByIDIwMjMgMjI6MDE6MzEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtaXNzaW5nIGxvY2sgd2hlbiB1cGRhdGluZyBzZXNzaW9uIHN0YXR1cwoKQ292ZXJpdHkg
bm90ZWQgYSBwbGFjZSB3aGVyZSB3ZSB3ZXJlIG5vdCBncmFiYmluZwp0aGUgc2VzX2xvY2sgd2hl
biBzZXR0aW5nIChhbmQgY2hlY2tpbmcpIHNlc19zdGF0dXMuCgpBZGRyZXNzZXMtQ292ZXJpdHk6
IDE1MzY4MzMgKCJEYXRhIHJhY2UgY29uZGl0aW9uIChNSVNTSU5HX0xPQ0spIikKU2lnbmVkLW9m
Zi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMv
Y29ubmVjdC5jIHwgNSArKysrLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25u
ZWN0LmMKaW5kZXggMWNiYjkwNTg3OTk1Li5jYzUzOGVkNjFiYzAgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0xOTE2LDE5ICsxOTE2LDIy
IEBAIHZvaWQgY2lmc19wdXRfc21iX3NlcyhzdHJ1Y3QgY2lmc19zZXMgKnNlcykKIAkvKiBzZXNf
Y291bnQgY2FuIG5ldmVyIGdvIG5lZ2F0aXZlICovCiAJV0FSTl9PTihzZXMtPnNlc19jb3VudCA8
IDApOwogCisJc3Bpbl9sb2NrKCZzZXMtPnNlc19sb2NrKTsKIAlpZiAoc2VzLT5zZXNfc3RhdHVz
ID09IFNFU19HT09EKQogCQlzZXMtPnNlc19zdGF0dXMgPSBTRVNfRVhJVElORzsKIAogCWNpZnNf
ZnJlZV9pcGMoc2VzKTsKIAogCWlmIChzZXMtPnNlc19zdGF0dXMgPT0gU0VTX0VYSVRJTkcgJiYg
c2VydmVyLT5vcHMtPmxvZ29mZikgeworCQlzcGluX3VubG9jaygmc2VzLT5zZXNfbG9jayk7CiAJ
CXhpZCA9IGdldF94aWQoKTsKIAkJcmMgPSBzZXJ2ZXItPm9wcy0+bG9nb2ZmKHhpZCwgc2VzKTsK
IAkJaWYgKHJjKQogCQkJY2lmc19zZXJ2ZXJfZGJnKFZGUywgIiVzOiBTZXNzaW9uIExvZ29mZiBm
YWlsdXJlIHJjPSVkXG4iLAogCQkJCV9fZnVuY19fLCByYyk7CiAJCV9mcmVlX3hpZCh4aWQpOwot
CX0KKwl9IGVsc2UKKwkJc3Bpbl91bmxvY2soJnNlcy0+c2VzX2xvY2spOwogCiAJc3Bpbl9sb2Nr
KCZjaWZzX3RjcF9zZXNfbG9jayk7CiAJbGlzdF9kZWxfaW5pdCgmc2VzLT5zbWJfc2VzX2xpc3Qp
OwotLSAKMi4zNC4xCgo=
--000000000000d3793505fa48ae50--
