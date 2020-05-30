Return-Path: <SRS0=UyrF=7M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16804C433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 22:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD7D320722
	for <linux-cifs@archiver.kernel.org>; Sat, 30 May 2020 22:31:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fO4blw5v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgE3Wbk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 30 May 2020 18:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729350AbgE3Wbj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 30 May 2020 18:31:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470DEC03E969
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2020 15:31:38 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id p123so3129738yba.6
        for <linux-cifs@vger.kernel.org>; Sat, 30 May 2020 15:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=vZ4KrYugh9MqNQxxMHY/sBjG3fV6eFcp5W+laxT3CkM=;
        b=fO4blw5vxhI83NOwXIpqwB/ahZMklw2g9w2QU+VV1BgIHEiwHFg4T/X0GEUCZRbF8z
         F2sF/xNB53NRhXfMt7xgSuuEDYIGUsKseEQ/xVeEFoxHhAWI7I/EDLyRNXL2rfod/Ztc
         kcigwc2xpLh8de0HuUSBy39QY9mzc9SFSP4lTnszVIag4qOwuHmTH5ApY/D8JT5R8q0o
         1A5bqpxwERvA677Rvw/pTqzvOL5/awvSVbxFxO3f57lmQ21wQZMBkkspJkjWjsuTj3FH
         KQbgEIDDutLPBwoJSfl4RTkVUmwYGKxAtLY0pY1GJUNzCCH+/O6bs3Y8uXTK/YQpw4TF
         GGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vZ4KrYugh9MqNQxxMHY/sBjG3fV6eFcp5W+laxT3CkM=;
        b=QlqBrG4Xv11UG4R4/KktR05BM67tIPbVVNsts/y+pkqHRyq1cK524DuvK9vWLlyYjD
         cPwrtaMHY6vobFKy+MWZO7tJRu90r1S8/19Ji7Qis53wasaZScZAoyOqR/ai1OWEDwl9
         4rgFr/LDtkNhr/0rUB+Qw4Wzx8BhwzJ7HMYeIn2oiflUwfHQ5iJhlX3/f4x7iDwI+LlX
         1ixoKr1aaJIpvgbQL86SZp7dPAVMtYZ7/SmLgzteuI+KgU6pHb1ndNy9rlMa2PQcWv9h
         2bbRgX22jZckm335SlTSebiqR1NN9aDtiKUTIuLHPTrYXUTH/EEI6I6zPa+Wzh52yT8f
         pQ9w==
X-Gm-Message-State: AOAM530tT+yzETd8R6L3esv4/jK6bL/4rl0lCnmVWploVqkv0tILx5IX
        mHDW0perEZ3w0gQP8ARLJmxqhhWkv3EwMgsyBupzWBkNx78=
X-Google-Smtp-Source: ABdhPJyN023HNJLQDD1bfYNYYc33ZJk9gxnZBziEj+cWQ1uRPkfcxmQaScSF0Mn5XS+RvlAPB/a+2/fTimN77uJiZSU=
X-Received: by 2002:a25:f309:: with SMTP id c9mr21793764ybs.364.1590877896892;
 Sat, 30 May 2020 15:31:36 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 30 May 2020 17:31:26 -0500
Message-ID: <CAH2r5mvFSWgEgoyaEH5W7x55Nc1HP3udqDrrid_BdOyWm66RKQ@mail.gmail.com>
Subject: [PATCH][CIFS] fix minor typos in comments and log messages
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ed124605a6e51fcb"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ed124605a6e51fcb
Content-Type: text/plain; charset="UTF-8"

Fix four minor typos in comments and log messages

-- 
Thanks,

Steve

--000000000000ed124605a6e51fcb
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-minor-typos-in-comments-and-log-messages.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-minor-typos-in-comments-and-log-messages.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kau7m7gc0>
X-Attachment-Id: f_kau7m7gc0

RnJvbSA4OWRkNmRhNTYzZDY3YjRjZTMwNzZmNDM2NmNlZmQ1NWM2MTY4ZWRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMzAgTWF5IDIwMjAgMTc6Mjk6NTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggbWlub3IgdHlwb3MgaW4gY29tbWVudHMgYW5kIGxvZyBtZXNzYWdlcwoKRml4IGZv
dXIgbWlub3IgdHlwb3MgaW4gY29tbWVudHMgYW5kIGxvZyBtZXNzYWdlcwoKU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc2Vz
cy5jIHwgOCArKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nlc3MuYyBiL2ZzL2NpZnMvc2Vzcy5jCmlu
ZGV4IDNmOGI0M2U3NzUzOS4uMGFlMjVjYzc3ZmMwIDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nlc3Mu
YworKysgYi9mcy9jaWZzL3Nlc3MuYwpAQCAtMTIyLDcgKzEyMiw3IEBAIGludCBjaWZzX3RyeV9h
ZGRpbmdfY2hhbm5lbHMoc3RydWN0IGNpZnNfc2VzICpzZXMpCiAKIAkJdHJpZXMrKzsKIAkJaWYg
KHRyaWVzID4gMypzZXMtPmNoYW5fbWF4KSB7Ci0JCQljaWZzX2RiZyhGWUksICJ0b28gbWFueSBh
dHRlbXB0IGF0IG9wZW5pbmcgY2hhbm5lbHMgKCVkIGNoYW5uZWxzIGxlZnQgdG8gb3BlbilcbiIs
CisJCQljaWZzX2RiZyhGWUksICJ0b28gbWFueSBjaGFubmVsIG9wZW4gYXR0ZW1wdHMgKCVkIGNo
YW5uZWxzIGxlZnQgdG8gb3BlbilcbiIsCiAJCQkJIGxlZnQpOwogCQkJYnJlYWs7CiAJCX0KQEAg
LTIwMCw3ICsyMDAsNyBAQCBjaWZzX3Nlc19hZGRfY2hhbm5lbChzdHJ1Y3QgY2lmc19zZXMgKnNl
cywgc3RydWN0IGNpZnNfc2VydmVyX2lmYWNlICppZmFjZSkKIAl2b2wuVU5DID0gdW5jOwogCXZv
bC5wcmVwYXRoID0gIiI7CiAKLQkvKiBSZS11c2Ugc2FtZSB2ZXJzaW9uIGFzIG1hc3RlciBjb25u
ZWN0aW9uICovCisJLyogUmV1c2Ugc2FtZSB2ZXJzaW9uIGFzIG1hc3RlciBjb25uZWN0aW9uICov
CiAJdm9sLnZhbHMgPSBzZXMtPnNlcnZlci0+dmFsczsKIAl2b2wub3BzID0gc2VzLT5zZXJ2ZXIt
Pm9wczsKIApAQCAtMjYzLDcgKzI2Myw3IEBAIGNpZnNfc2VzX2FkZF9jaGFubmVsKHN0cnVjdCBj
aWZzX3NlcyAqc2VzLCBzdHJ1Y3QgY2lmc19zZXJ2ZXJfaWZhY2UgKmlmYWNlKQogCQlnb3RvIG91
dDsKIAogCS8qIHN1Y2Nlc3MsIHB1dCBpdCBvbiB0aGUgbGlzdAotCSAqIFhYWDogc2hhcmluZyBz
ZXMgYmV0d2VlbiAyIHRjcCBzZXJ2ZXIgaXMgbm90IHBvc3NpYmxlLCB0aGUKKwkgKiBYWFg6IHNo
YXJpbmcgc2VzIGJldHdlZW4gMiB0Y3Agc2VydmVycyBpcyBub3QgcG9zc2libGUsIHRoZQogCSAq
IHdheSAiaW50ZXJuYWwiIGxpbmtlZCBsaXN0cyB3b3JrcyBpbiBsaW51eCBtYWtlcyBlbGVtZW50
CiAJICogb25seSBhYmxlIHRvIGJlbG9uZyB0byBvbmUgbGlzdAogCSAqCkBAIC05NzIsNyArOTcy
LDcgQEAgc2Vzc19hdXRoX2xhbm1hbihzdHJ1Y3Qgc2Vzc19kYXRhICpzZXNzX2RhdGEpCiAKIAkJ
LyogQ2FsY3VsYXRlIGhhc2ggd2l0aCBwYXNzd29yZCBhbmQgY29weSBpbnRvIGJjY19wdHIuCiAJ
CSAqIEVuY3J5cHRpb24gS2V5IChzdG9yZWQgYXMgaW4gY3J5cHRrZXkpIGdldHMgdXNlZCBpZiB0
aGUKLQkJICogc2VjdXJpdHkgbW9kZSBiaXQgaW4gTmVnb3R0aWF0ZSBQcm90b2NvbCByZXNwb25z
ZSBzdGF0ZXMKKwkJICogc2VjdXJpdHkgbW9kZSBiaXQgaW4gTmVnb3RpYXRlIFByb3RvY29sIHJl
c3BvbnNlIHN0YXRlcwogCQkgKiB0byB1c2UgY2hhbGxlbmdlL3Jlc3BvbnNlIG1ldGhvZCAoaS5l
LiBQYXNzd29yZCBiaXQgaXMgMSkuCiAJCSAqLwogCQlyYyA9IGNhbGNfbGFubWFuX2hhc2goc2Vz
LT5wYXNzd29yZCwgc2VzLT5zZXJ2ZXItPmNyeXB0a2V5LAotLSAKMi4yNS4xCgo=
--000000000000ed124605a6e51fcb--
