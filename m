Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962ABC4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Oct 2022 11:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJLLRG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Oct 2022 07:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLLRF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Oct 2022 07:17:05 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA44C1DBD
        for <linux-cifs@vger.kernel.org>; Wed, 12 Oct 2022 04:17:04 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id a2so11413523vsc.13
        for <linux-cifs@vger.kernel.org>; Wed, 12 Oct 2022 04:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A/QAT4TehrQda82TJZR2XQc7myKiImj4ikJYX2w+0nY=;
        b=O0XUVelRQxhH9mhfoCV6H3L48ePVjoLA6p363wLOP+KZEEKoF5JLWkrAy1ScpW4kuW
         8VoGmp9GFDV4U3Monhak3dT1c+odwYlvOWWHzTsM+ME3CVg78sNEfdWrIft9yGE5q1hi
         l+wzOFrR36n/wGmq6WZoI3CcRkPlKBUL3Mf9/YMOiXMeMcNnk/ij1INjmKi2Ed9eqxTo
         BXb93lcemHNxEGGWK0L3XgE3ZSfGpeFLEKMBbRLx0ysA2kHcJTkjsoqWAgeU7W59fam/
         jNmVGB05gKOjHY27s1J8GBiIqOig5c82/es3ANkDzVi6c450Nl7QqjoczFTxPJ3rGgVK
         W/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A/QAT4TehrQda82TJZR2XQc7myKiImj4ikJYX2w+0nY=;
        b=VM/9ffY2OV8fo6Y7tYpKOicPypOn6Un9RoXQOZsGaOQY1vMBZ/gAhxR7YhAMP9Kz8N
         1Rb67T+rrNaDh8+vTdgvvvyTgDEKmyQgAD8TB8JrqFO7J9Ub543PTXRK/UlOy08yUxqy
         EtS3CVm81janhddHllgVpglFluQ1fJp+0QS6Hb0/rj8Ibb4krE578LEAnrWwYDwI+cd8
         2a63muxlfDuavyJe4HHJeo2JPpwn6QAo6OVk8k/VMkb4hEUZ2/xCoELn/QCLUsQ1h5wG
         wlBcZZTu8E4oXyIkXJfG85SL7hR7XAPrsVAbwAtFVTqtFcg4v/MuW43M47WoNgxaiGTx
         ASHw==
X-Gm-Message-State: ACrzQf3ZJEl01h8wpr/1Xexhp4t+/1r0ZTCnH18sf68QGJYJ4N4tjgLy
        3SeawREY5e6x40CSQTBIXoi2L+qvnUmyZXnf+PHlFOuY
X-Google-Smtp-Source: AMsMyM7JqIo3DCxMqwmEci0dZOInJzSC00xRNHpPKbVLBHuDT6vMGzwqb7ozcgKTRv1teIIoKmv428eQ2R/Dx13eL3c=
X-Received: by 2002:a05:6102:5cf:b0:3a7:95ac:fc04 with SMTP id
 v15-20020a05610205cf00b003a795acfc04mr6523652vsf.17.1665573423217; Wed, 12
 Oct 2022 04:17:03 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 12 Oct 2022 06:16:50 -0500
Message-ID: <CAH2r5msDHS2Gu_DCU_er0Ju4Hdx5A37exvt3M6ra2GVc-M26kA@mail.gmail.com>
Subject: patch 5 in dir lease series
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000003d187005ead4886f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003d187005ead4886f
Content-Type: text/plain; charset="UTF-8"

I had a merge conflict with patch 5 of the dir lease series and fixed it

Is the one attached current



-- 
Thanks,

Steve

--0000000000003d187005ead4886f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-find-and-use-the-dentry-for-cached-non-root-dir.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-find-and-use-the-dentry-for-cached-non-root-dir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l95jehsd0>
X-Attachment-Id: f_l95jehsd0

RnJvbSBmODU5MGUxYTJjYjU2ODgwOTE5ZjFhNGJlZDIwZjZkMTYxOTIxYjUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFdlZCwgMTIgT2N0IDIwMjIgMDY6MTM6MDMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaW5kIGFuZCB1c2UgdGhlIGRlbnRyeSBmb3IgY2FjaGVkIG5vbi1yb290IGRpcmVjdG9y
aWVzCiBhbHNvCgpUaGlzIGFsbG93cyB1cyB0byB1c2UgY2FjaGVkIGF0dHJpYnV0ZXMgZm9yIHRo
ZSBlbnRyaWVzIGluIGEgY2FjaGVkCmRpcmVjdG9yeSBmb3IgYXMgbG9uZyBhcyBhIGxlYXNlIGlz
IGhlbGQgb24gdGhlIGRpcmVjdG9yeSBpdHNlbGYuClByZXZpb3VzbHkgd2UgaGF2ZSBhbHdheXMg
YWxsb3dlZCAidXNlZCBjYWNoZWQgYXR0cmlidXRlcyBmb3IgMSBzZWNvbmQiCmJ1dCB0aGlzIGV4
dGVuZHMgdGhpcyB0byB0aGUgbGlmZXRpbWUgb2YgdGhlIGxlYXNlIGFzIHdlbGwgYXMgbWFraW5n
IHRoZQpjYWNoaW5nIHNhZmVyLgoKU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2Fo
bGJlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jYWNoZWRfZGlyLmMgfCA2MyArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2Vy
dGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2FjaGVkX2Rp
ci5jIGIvZnMvY2lmcy9jYWNoZWRfZGlyLmMKaW5kZXggZTU1NzNkNGUyZDgzLi5mZTg4YjY3Yzg2
M2YgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2FjaGVkX2Rpci5jCisrKyBiL2ZzL2NpZnMvY2FjaGVk
X2Rpci5jCkBAIC01LDYgKzUsNyBAQAogICogIENvcHlyaWdodCAoYykgMjAyMiwgUm9ubmllIFNh
aGxiZXJnIDxsc2FobGJlckByZWRoYXQuY29tPgogICovCiAKKyNpbmNsdWRlIDxsaW51eC9uYW1l
aS5oPgogI2luY2x1ZGUgImNpZnNnbG9iLmgiCiAjaW5jbHVkZSAiY2lmc3Byb3RvLmgiCiAjaW5j
bHVkZSAiY2lmc19kZWJ1Zy5oIgpAQCAtNTksNiArNjAsNDQgQEAgc3RhdGljIHN0cnVjdCBjYWNo
ZWRfZmlkICpmaW5kX29yX2NyZWF0ZV9jYWNoZWRfZGlyKHN0cnVjdCBjYWNoZWRfZmlkcyAqY2Zp
ZHMsCiAJcmV0dXJuIGNmaWQ7CiB9CiAKK3N0YXRpYyBzdHJ1Y3QgZGVudHJ5ICoKK3BhdGhfdG9f
ZGVudHJ5KHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIGNvbnN0IGNoYXIgKnBhdGgpCit7
CisJc3RydWN0IGRlbnRyeSAqZGVudHJ5OworCWNvbnN0IGNoYXIgKnMsICpwOworCWNoYXIgc2Vw
OworCisJc2VwID0gQ0lGU19ESVJfU0VQKGNpZnNfc2IpOworCWRlbnRyeSA9IGRnZXQoY2lmc19z
Yi0+cm9vdCk7CisJcyA9IHBhdGg7CisKKwlkbyB7CisJCXN0cnVjdCBpbm9kZSAqZGlyID0gZF9p
bm9kZShkZW50cnkpOworCQlzdHJ1Y3QgZGVudHJ5ICpjaGlsZDsKKworCQlpZiAoIVNfSVNESVIo
ZGlyLT5pX21vZGUpKSB7CisJCQlkcHV0KGRlbnRyeSk7CisJCQlkZW50cnkgPSBFUlJfUFRSKC1F
Tk9URElSKTsKKwkJCWJyZWFrOworCQl9CisKKwkJLyogc2tpcCBzZXBhcmF0b3JzICovCisJCXdo
aWxlICgqcyA9PSBzZXApCisJCQlzKys7CisJCWlmICghKnMpCisJCQlicmVhazsKKwkJcCA9IHMr
KzsKKwkJLyogbmV4dCBzZXBhcmF0b3IgKi8KKwkJd2hpbGUgKCpzICYmICpzICE9IHNlcCkKKwkJ
CXMrKzsKKworCQljaGlsZCA9IGxvb2t1cF9wb3NpdGl2ZV91bmxvY2tlZChwLCBkZW50cnksIHMg
LSBwKTsKKwkJZHB1dChkZW50cnkpOworCQlkZW50cnkgPSBjaGlsZDsKKwl9IHdoaWxlICghSVNf
RVJSKGRlbnRyeSkpOworCXJldHVybiBkZW50cnk7Cit9CisKIC8qCiAgKiBPcGVuIHRoZSBhbmQg
Y2FjaGUgYSBkaXJlY3RvcnkgaGFuZGxlLgogICogSWYgZXJyb3IgdGhlbiAqY2ZpZCBpcyBub3Qg
aW5pdGlhbGl6ZWQuCkBAIC04Niw3ICsxMjUsNiBAQCBpbnQgb3Blbl9jYWNoZWRfZGlyKHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJc3RydWN0IGNhY2hlZF9maWQg
KmNmaWQ7CiAJc3RydWN0IGNhY2hlZF9maWRzICpjZmlkczsKIAotCiAJaWYgKHRjb24gPT0gTlVM
TCB8fCB0Y29uLT5jZmlkcyA9PSBOVUxMIHx8IHRjb24tPm5vaGFuZGxlY2FjaGUgfHwKIAkgICAg
aXNfc21iMV9zZXJ2ZXIodGNvbi0+c2VzLT5zZXJ2ZXIpKQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7
CkBAIC0xMDEsMTMgKzEzOSw2IEBAIGludCBvcGVuX2NhY2hlZF9kaXIodW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlpZiAoY2lmc19zYi0+cm9vdCA9PSBOVUxMKQog
CQlyZXR1cm4gLUVOT0VOVDsKIAotCS8qCi0JICogVE9ETzogZm9yIGJldHRlciBjYWNoaW5nIHdl
IG5lZWQgdG8gZmluZCBhbmQgdXNlIHRoZSBkZW50cnkgYWxzbwotCSAqIGZvciBub24tcm9vdCBk
aXJlY3Rvcmllcy4KLQkgKi8KLQlpZiAoIXBhdGhbMF0pCi0JCWRlbnRyeSA9IGNpZnNfc2ItPnJv
b3Q7Ci0KIAl1dGYxNl9wYXRoID0gY2lmc19jb252ZXJ0X3BhdGhfdG9fdXRmMTYocGF0aCwgY2lm
c19zYik7CiAJaWYgKCF1dGYxNl9wYXRoKQogCQlyZXR1cm4gLUVOT01FTTsKQEAgLTE5OSwxMiAr
MjMwLDYgQEAgaW50IG9wZW5fY2FjaGVkX2Rpcih1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCW9wYXJtcy5maWQtPm1pZCA9IGxlNjRfdG9fY3B1KG9fcnNwLT5oZHIu
TWVzc2FnZUlkKTsKICNlbmRpZiAvKiBDSUZTX0RFQlVHMiAqLwogCi0JY2ZpZC0+dGNvbiA9IHRj
b247Ci0JaWYgKGRlbnRyeSkgewotCQljZmlkLT5kZW50cnkgPSBkZW50cnk7Ci0JCWRnZXQoZGVu
dHJ5KTsKLQl9Ci0JLyogQkIgVEJEIGNoZWNrIHRvIHNlZSBpZiBvcGxvY2sgbGV2ZWwgY2hlY2sg
Y2FuIGJlIHJlbW92ZWQgYmVsb3cgKi8KIAlpZiAob19yc3AtPk9wbG9ja0xldmVsICE9IFNNQjJf
T1BMT0NLX0xFVkVMX0xFQVNFKQogCQlnb3RvIG9zaHJfZnJlZTsKIApAQCAtMjIzLDYgKzI0OCwx
NiBAQCBpbnQgb3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJCQkJJnJzcF9pb3ZbMV0sIHNpemVvZihzdHJ1Y3Qgc21iMl9maWxlX2FsbF9p
bmZvKSwKIAkJCQkoY2hhciAqKSZjZmlkLT5maWxlX2FsbF9pbmZvKSkKIAkJY2ZpZC0+ZmlsZV9h
bGxfaW5mb19pc192YWxpZCA9IHRydWU7CisKKwlpZiAoIXBhdGhbMF0pCisJCWRlbnRyeSA9IGRn
ZXQoY2lmc19zYi0+cm9vdCk7CisJZWxzZSB7CisJCWRlbnRyeSA9IHBhdGhfdG9fZGVudHJ5KGNp
ZnNfc2IsIHBhdGgpOworCQlpZiAoSVNfRVJSKGRlbnRyeSkpCisJCQlnb3RvIG9zaHJfZnJlZTsK
Kwl9CisJY2ZpZC0+ZGVudHJ5ID0gZGVudHJ5OworCWNmaWQtPnRjb24gPSB0Y29uOwogCWNmaWQt
PnRpbWUgPSBqaWZmaWVzOwogCWNmaWQtPmlzX29wZW4gPSB0cnVlOwogCWNmaWQtPmhhc19sZWFz
ZSA9IHRydWU7Ci0tIAoyLjM0LjEKCg==
--0000000000003d187005ead4886f--
