Return-Path: <SRS0=lqiH=7Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EFCC433DF
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jun 2020 04:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A902074B
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jun 2020 04:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMFid17N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgFCEVT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jun 2020 00:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCEVS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jun 2020 00:21:18 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6688C05BD43
        for <linux-cifs@vger.kernel.org>; Tue,  2 Jun 2020 21:21:18 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id a80so372532ybg.1
        for <linux-cifs@vger.kernel.org>; Tue, 02 Jun 2020 21:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=slh6yBO0jWz0DFWzHcd2paEGLCk5s4IJ70Q+yDxTFuY=;
        b=bMFid17NMYrWYE/NLMGsWkaEjn7aZtOlw5JAN3hzqOvpcSTrG4xEl7syjPVKayw/ME
         9ebn77mLMZUVVB7WcAuyuuM3is9LqaBaywBsvx6UUvXu9pmdKWmppb7Sepy928XVhSp+
         C/tNMu2k1rKnkpqAehAiweUOowg8sPNoEmO/7BbS0o3UDaC56dq6FoG7LlAF5P932hfu
         u1PdiUDgcIRjW6CxknTFLYlqqK9krcoJCJaHya4iFZ9OSGLKL9KHekdODuVK9VterSE8
         PADHL574usZd8m/R8tZo472QaTEKw/Xdd41gTlOhFDrBjHjwuvPOUNrs6SIM+7M7EkHa
         XQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=slh6yBO0jWz0DFWzHcd2paEGLCk5s4IJ70Q+yDxTFuY=;
        b=jTYnoxaMHl+OJOf6FmkXkSE+TIkao3UxlGQ46tAHHuAVL+nXQbGLlRTivc340wiR+H
         +oHtHgk7Ioy7beWRLLmLGx22TuEKgo/Pl3YrHMatDOe8ECS+OBsKzMLL5zlsmR/vw6m1
         iCW3vCm/5oNT51oihpFvwrcKx7NBBEn4dOH3joyEbfBvfE7MckXTVO9hxqHZTaATfsXp
         H7keD4s9j5zvu0SHkI/+Sqt0xxzEHi5MBsjdONNBxr2RQ/bMf4Rae+w2PEQC1yInugbd
         C3FS6txCN7uVoc8pIkX0PBhYztamRUOM46f8LEonP7A2vpEVMWVWWEuFgZbEIFTAPz3i
         72/A==
X-Gm-Message-State: AOAM533+kAAGX8WDLte56TgPglDIkbhijlDwOiTgDoy9Eak6WHDMKo6M
        PT/tNKGz7PaAh2jPhVGwtHJUBSXsUj3r0PEMW5/lnbaz/d8=
X-Google-Smtp-Source: ABdhPJyJxzwH+lwTpRD18ce5tbF+GbQXOCSDf34DiYcEvCTNBok1zBFNkbQYfsqAFv2hk7qycc2sZ/FzGRmNc0YNqL0=
X-Received: by 2002:a25:4487:: with SMTP id r129mr34627318yba.14.1591158077560;
 Tue, 02 Jun 2020 21:21:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Jun 2020 23:21:06 -0500
Message-ID: <CAH2r5msvShbNa-X5-ZH-H66W2Kc_sZ3g+XDwns2_zR3P9ZCMtg@mail.gmail.com>
Subject: [PATCH][SMB3] default to minimum of two channels when multichannel specified
To:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000feb9dd05a7265b9b"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000feb9dd05a7265b9b
Content-Type: text/plain; charset="UTF-8"

    When "multichannel" is specified on mount, make sure to default to
    at least two channels.



-- 
Thanks,

Steve

--000000000000feb9dd05a7265b9b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-default-to-minimum-of-two-channels-when-multich.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-default-to-minimum-of-two-channels-when-multich.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kayufajo0>
X-Attachment-Id: f_kayufajo0

RnJvbSBlZDU4ZTExN2QxZGM0YjhhYTMxN2IyNTE2MjY5NThiNWZmYjA2ZjVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMiBKdW4gMjAyMCAyMzoxNzoxNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGRlZmF1bHQgdG8gbWluaW11bSBvZiB0d28gY2hhbm5lbHMgd2hlbiBtdWx0aWNoYW5uZWwK
IHNwZWNpZmllZAoKV2hlbiAibXVsdGljaGFubmVsIiBpcyBzcGVjaWZpZWQgb24gbW91bnQsIG1h
a2Ugc3VyZSB0byBkZWZhdWx0IHRvCmF0IGxlYXN0IHR3byBjaGFubmVscy4KClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nv
bm5lY3QuYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZGFmOTBm
OTg4ZGUxLi5mZGZkN2NmNGM3MjAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBi
L2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0xOTY0LDkgKzE5NjQsMTMgQEAgY2lmc19wYXJzZV9tb3Vu
dF9vcHRpb25zKGNvbnN0IGNoYXIgKm1vdW50ZGF0YSwgY29uc3QgY2hhciAqZGV2bmFtZSwKIAkJ
CWJyZWFrOwogCQljYXNlIE9wdF9tdWx0aWNoYW5uZWw6CiAJCQl2b2wtPm11bHRpY2hhbm5lbCA9
IHRydWU7CisJCQkvKiBpZiBudW1iZXIgb2YgY2hhbm5lbHMgbm90IHNwZWNpZmllZCwgZGVmYXVs
dCB0byAyICovCisJCQlpZiAodm9sLT5tYXhfY2hhbm5lbHMgPCAyKQorCQkJCXZvbC0+bWF4X2No
YW5uZWxzID0gMjsKIAkJCWJyZWFrOwogCQljYXNlIE9wdF9ub211bHRpY2hhbm5lbDoKIAkJCXZv
bC0+bXVsdGljaGFubmVsID0gZmFsc2U7CisJCQl2b2wtPm1heF9jaGFubmVscyA9IDE7CiAJCQli
cmVhazsKIAkJY2FzZSBPcHRfY29tcHJlc3M6CiAJCQl2b2wtPmNvbXByZXNzaW9uID0gVU5LTk9X
Tl9UWVBFOwotLSAKMi4yNS4xCgo=
--000000000000feb9dd05a7265b9b--
