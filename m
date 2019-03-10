Return-Path: <SRS0=aWno=RN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86630C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Mar 2019 02:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AA86206DF
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Mar 2019 02:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDMqvD3S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfCJCcE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Mar 2019 21:32:04 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:34226 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfCJCcE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Mar 2019 21:32:04 -0500
Received: by mail-pg1-f181.google.com with SMTP id u65so1274798pgc.1
        for <linux-cifs@vger.kernel.org>; Sat, 09 Mar 2019 18:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5kg9+rzmwy5Gcm8b9W/KQDkvLCJIlcU3ZQEplFCcKJk=;
        b=NDMqvD3S24mFE4LCyiHeSCBtgwpnRpTLfansW4Rp9gC9pWwyHqvGtZqZq5+lAM15P6
         ZpiqpnFXCO0DhWy0b6ZdEBDxd4Q/lFAPr8MVNBD/O40PaCxEiOFNW/PO1TKHxMhQuu8o
         J8JVKw3wtiWaFoPZQg5ESe/MBBxYcoSC8EPh5YCMun314eny6uqKyBOgclhUbyyivaXt
         ATz3KvZ1AIQRwTFp9/K6HHUbzkUtxHhDn59GauUqMUB+Ypj5NWYtGy8aYBh2Tzp8R0Gy
         LnM7mwtiTUl8HVjA0HUSHHWQiWDPoAXv78+AUFDEWDFPamhHkCuCQ81kmn9FYS3EvS5v
         7TYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5kg9+rzmwy5Gcm8b9W/KQDkvLCJIlcU3ZQEplFCcKJk=;
        b=n0NeEt6SEBnbSvbZQgI+E6hFZ33bdnI5IQVXFx32UEGwQDmIAwwl117lx9fv1gt6sZ
         njRYV2NFa8zGSIEXceWF9dnN2jaeTaKwRHojPdhyQCJe3KyZQNxCY7u2602BcYS4Nldy
         oFWIM7eGILNwdZEghckpoTkN69iiUi1K197rvpJixuqm1pEG1xbv3YjbgiRl28sIC6Qn
         BenrykTZFAjRNozDYaexrJphHVA/3Vk23WJWguIMxAGjqoeEoGRXndJ9UmduvMt/S/g4
         yATUo46BJAT3u5DgPuMury7skoFEuxOZjer0tZNrkTrijbx5l+BvaJ28GDJWI2qrKHFa
         8Uhw==
X-Gm-Message-State: APjAAAWUNuaAErGmqR4TbacQmG1XDowevFIkorS+tKxLQdgqPmXAT1Ka
        w7f1lz+GPg/6mEIeqLzn/aoofpDc878oTisf2p+27A==
X-Google-Smtp-Source: APXvYqzKuEPoc91QCEcoI60zYxeRWnIf0k7/bR6j6Dm82X5JKoi7RwM01S/PkgzSftlmSSqiu6aV8xlNFZam5olk2EY=
X-Received: by 2002:a62:b2d9:: with SMTP id z86mr26514981pfl.255.1552185123087;
 Sat, 09 Mar 2019 18:32:03 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 9 Mar 2019 20:31:51 -0600
Message-ID: <CAH2r5msdRYgbuz_V5Rb+LGPXc-EweCusoDMePTQPz-fuguaSTA@mail.gmail.com>
Subject: [PATCH] Add dynamic trace point for timeouts waiting for credits
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000e345790583b442f1"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e345790583b442f1
Content-Type: text/plain; charset="UTF-8"

-- 
Thanks,

Steve

--000000000000e345790583b442f1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-tracepoint-for-timeout-waiting-for-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-tracepoint-for-timeout-waiting-for-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt2axqw60>
X-Attachment-Id: f_jt2axqw60

RnJvbSAwNTUxZmU3YzY4MGY1YTNiYjMzYTVjMjhkOGY3MTNkZDU2MjQ2MmI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgOSBNYXIgMjAxOSAyMDoyOTo1NSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCBkeW5hbWljIHRyYWNlcG9pbnQgZm9yIHRpbWVvdXQgd2FpdGluZyBmb3IgY3JlZGl0
cwoKVG8gaGVscCBkZWJ1ZyBjcmVkaXQgc3RhcnZhdGlvbiBwcm9ibGVtcyB3aGVyZSB3ZSB0aW1l
b3V0CndhaXRpbmcgZm9yIHNlcnZlciB0byBncmFudCB0aGUgY2xpZW50IGNyZWRpdHMuCgpTaWdu
ZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMv
Y2lmcy90cmFjZS5oICAgICB8IDEgKwogZnMvY2lmcy90cmFuc3BvcnQuYyB8IDUgKysrKysKIDIg
ZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFj
ZS5oIGIvZnMvY2lmcy90cmFjZS5oCmluZGV4IGQ4YjA0OWFmYTYwNi4uYzc4ZTk2YzRjYzUzIDEw
MDY0NAotLS0gYS9mcy9jaWZzL3RyYWNlLmgKKysrIGIvZnMvY2lmcy90cmFjZS5oCkBAIC03MTMs
NiArNzEzLDcgQEAgREVGSU5FX0VWRU5UKHNtYjNfY3JlZGl0X2NsYXNzLCBzbWIzXyMjbmFtZSwg
IFwKIAlUUF9BUkdTKGN1cnJtaWQsIGhvc3RuYW1lLCBjcmVkaXRzKSkKIAogREVGSU5FX1NNQjNf
Q1JFRElUX0VWRU5UKHJlY29ubmVjdF93aXRoX2ludmFsaWRfY3JlZGl0cyk7CitERUZJTkVfU01C
M19DUkVESVRfRVZFTlQoY3JlZGl0X3RpbWVvdXQpOwogCiAjZW5kaWYgLyogX0NJRlNfVFJBQ0Vf
SCAqLwogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYW5zcG9ydC5jIGIvZnMvY2lmcy90cmFuc3Bv
cnQuYwppbmRleCBiM2QwNDAxODE5NWMuLjg3MzFjZmE2NjAyNiAxMDA2NDQKLS0tIGEvZnMvY2lm
cy90cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3RyYW5zcG9ydC5jCkBAIC01MjcsNiArNTI3LDgg
QEAgd2FpdF9mb3JfZnJlZV9jcmVkaXRzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwg
Y29uc3QgaW50IG51bV9jcmVkaXRzLAogCQkJCWhhc19jcmVkaXRzKHNlcnZlciwgY3JlZGl0cywg
bnVtX2NyZWRpdHMpLCB0KTsKIAkJCWNpZnNfbnVtX3dhaXRlcnNfZGVjKHNlcnZlcik7CiAJCQlp
ZiAoIXJjKSB7CisJCQkJdHJhY2Vfc21iM19jcmVkaXRfdGltZW91dChzZXJ2ZXItPkN1cnJlbnRN
aWQsCisJCQkJCXNlcnZlci0+aG9zdG5hbWUsIG51bV9jcmVkaXRzKTsKIAkJCQljaWZzX2RiZyhW
RlMsICJ3YWl0IHRpbWVkIG91dCBhZnRlciAlZCBtc1xuIiwKIAkJCQkJIHRpbWVvdXQpOwogCQkJ
CXJldHVybiAtRU5PVFNVUFA7CkBAIC01NjUsNiArNTY3LDkgQEAgd2FpdF9mb3JfZnJlZV9jcmVk
aXRzKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgY29uc3QgaW50IG51bV9jcmVkaXRz
LAogCQkJCQl0KTsKIAkJCQljaWZzX251bV93YWl0ZXJzX2RlYyhzZXJ2ZXIpOwogCQkJCWlmICgh
cmMpIHsKKwkJCQkJdHJhY2Vfc21iM19jcmVkaXRfdGltZW91dCgKKwkJCQkJCXNlcnZlci0+Q3Vy
cmVudE1pZCwKKwkJCQkJCXNlcnZlci0+aG9zdG5hbWUsIG51bV9jcmVkaXRzKTsKIAkJCQkJY2lm
c19kYmcoVkZTLCAid2FpdCB0aW1lZCBvdXQgYWZ0ZXIgJWQgbXNcbiIsCiAJCQkJCQkgdGltZW91
dCk7CiAJCQkJCXJldHVybiAtRU5PVFNVUFA7Ci0tIAoyLjE3LjEKCg==
--000000000000e345790583b442f1--
