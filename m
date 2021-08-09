Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96506C4338F
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Aug 2021 09:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7322060EB7
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Aug 2021 09:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhHIJ4t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Aug 2021 05:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbhHIJ4t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Aug 2021 05:56:49 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B842C0613D3
        for <linux-cifs@vger.kernel.org>; Mon,  9 Aug 2021 02:56:28 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x7so11190923ljn.10
        for <linux-cifs@vger.kernel.org>; Mon, 09 Aug 2021 02:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TmRDOfmYiS8E/TZm9fvbVpaBQakw5iolwi8HH3E9UgM=;
        b=NB9kCom/Wf32JYjhnjG0SXRXxkHo5+6kzwr+1xyQU6aPmSz2bke3wJd0qAaHWUGISp
         bj0+Xx1rA7G1RXGjzTL9Ac0XutZn7e7H5ncOlFouHg4m89JwAivGa2Ccb6KKL0gKp84s
         mf/E31sstTrvhBqSOsHgODoCT8IIisKO0OhvtZRm0saSv8HD7Qwjrk203awoMOGxAbop
         inQIPJnj6QeokMa4zRWZdQP9x+5uBdYaES2rej+IvIF51ONgj0WkIhqpMFADfoObyPTt
         UkaAaRLoudN1GgurzP4q6Dlp7+Ylw5lWJDBvllusFFJt9TXDRlvHfbYvK+GgvYIFiwdL
         1/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TmRDOfmYiS8E/TZm9fvbVpaBQakw5iolwi8HH3E9UgM=;
        b=qVfufi8DU6PD4/ZXMboNa6K/8vxkSrbgZjNGGLMT2W28Inw6cDwFF+j9TCj6boGA5q
         uz0fM2mkAmRKqxBxmhKM713BFsxBGr4VdQaR4NJkBddA4r0CkZDMSSda6dksdYjXXA6a
         l7sTYN5VRF5mH+U0yGwSjHKr/qlC7LjchdkLBKDugmJTUrsGH6GiDPXw8b56hf6VN3Pz
         YC+ggG/McmCK10Gw0ZGhgv1LAHHzK3k2qiCNWo1COaNdydRsMG1Cy0LdGqtrb7NnGacw
         tUIxbvEIddkPKAoQZbSOmGBtUOaDSRhbw3SHOqqlQscMBeUt9c1hmapHfItK3bV2GTDQ
         d9Tg==
X-Gm-Message-State: AOAM533XDLMLLhDm0cSBSGv1gvvXxQlAsS8UybDX9Kvh22DFkw2xIY8z
        34rwDhW/dPYLNprVeDRkuwJHZBU0g/u8pkGvPxQ=
X-Google-Smtp-Source: ABdhPJwDyz3eW/TXImo1kJqfmhqT6V4YxbRSMpdA2P5vSIoswnfEe5o0A2Qf/TjFnccdl1JB4zCDrUO1oj7SyKtU/L8=
X-Received: by 2002:a05:651c:1ad:: with SMTP id c13mr14679852ljn.163.1628502986675;
 Mon, 09 Aug 2021 02:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms3XvZSLbAOb7irrZpS0aFsDUW59qRDdN19H8ZaR_YX+w@mail.gmail.com>
In-Reply-To: <CAH2r5ms3XvZSLbAOb7irrZpS0aFsDUW59qRDdN19H8ZaR_YX+w@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Mon, 9 Aug 2021 15:26:15 +0530
Message-ID: <CACdtm0YKX0AK6axj+QnpG9cd1ee-3D9jreo567vK+Raf8B0MQw@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Handle race conditions during rename
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000009704c05c91d665a"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000009704c05c91d665a
Content-Type: text/plain; charset="UTF-8"

Hi Steve, All,

Have updated the patch slightly with null check to avoid kernel oops.

Regards,
Rohith

On Wed, Aug 4, 2021 at 11:13 PM Steve French <smfrench@gmail.com> wrote:
>
> Lightly updated version of Rohith's newer version of his deferred close fix (fixed minor checkpatch issue and added cc:stable #5.13
>
> --
> Thanks,
>
> Steve

--00000000000009704c05c91d665a
Content-Type: application/octet-stream; 
	name="cifs-Handle-race-conditions-during-rename.patch"
Content-Disposition: attachment; 
	filename="cifs-Handle-race-conditions-during-rename.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ks4gme2z0>
X-Attachment-Id: f_ks4gme2z0

RnJvbSBkODk5NjBlMzk2MjJkYzExMTJiY2I3Y2YzZmRlZDgwNjNmM2VmN2ZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVGh1LCAyOSBKdWwgMjAyMSAwNzo0NToyOSArMDAwMApTdWJqZWN0OiBbUEFU
Q0hdIGNpZnM6IEhhbmRsZSByYWNlIGNvbmRpdGlvbnMgZHVyaW5nIHJlbmFtZQoKV2hlbiByZW5h
bWUgaXMgZXhlY3V0ZWQgb24gZGlyZWN0b3J5IHdoaWNoIGhhcyBmaWxlcyBmb3Igd2hpY2gKY2xv
c2UgaXMgZGVmZXJyZWQsIHRoZW4gcmVuYW1lIHdpbGwgZmFpbCB3aXRoIEVBQ0NFUy4KClRoaXMg
cGF0Y2ggd2lsbCB0cnkgdG8gY2xvc2UgYWxsIGRlZmVycmVkIGZpbGVzIHdoZW4gRUFDQ0VTIGlz
IHJlY2VpdmVkCmFuZCByZXRyeSByZW5hbWUgb24gYSBkaXJlY3RvcnkuCgpTaWduZWQtb2ZmLWJ5
OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0LmNvbT4KQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcgIyA1LjEzClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVu
Y2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2lub2RlLmMgfCAxOSArKysrKysrKysrKysr
KysrKy0tCiBmcy9jaWZzL21pc2MuYyAgfCAxNiArKysrKysrKysrKy0tLS0tCiAyIGZpbGVzIGNo
YW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5jCmluZGV4IGI5NmIyNTNlNzYzNS4uNjVmOGE3
MGNlY2UzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2lub2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5j
CkBAIC0xNjI1LDcgKzE2MjUsNyBAQCBpbnQgY2lmc191bmxpbmsoc3RydWN0IGlub2RlICpkaXIs
IHN0cnVjdCBkZW50cnkgKmRlbnRyeSkKIAkJZ290byB1bmxpbmtfb3V0OwogCX0KIAotCWNpZnNf
Y2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHRjb24pOworCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmls
ZShDSUZTX0koaW5vZGUpKTsKIAlpZiAoY2FwX3VuaXgodGNvbi0+c2VzKSAmJiAoQ0lGU19VTklY
X1BPU0lYX1BBVEhfT1BTX0NBUCAmCiAJCQkJbGU2NF90b19jcHUodGNvbi0+ZnNVbml4SW5mby5D
YXBhYmlsaXR5KSkpIHsKIAkJcmMgPSBDSUZTUE9TSVhEZWxGaWxlKHhpZCwgdGNvbiwgZnVsbF9w
YXRoLApAQCAtMjA4NCw2ICsyMDg0LDcgQEAgY2lmc19yZW5hbWUyKHN0cnVjdCB1c2VyX25hbWVz
cGFjZSAqbW50X3VzZXJucywgc3RydWN0IGlub2RlICpzb3VyY2VfZGlyLAogCUZJTEVfVU5JWF9C
QVNJQ19JTkZPICppbmZvX2J1Zl90YXJnZXQ7CiAJdW5zaWduZWQgaW50IHhpZDsKIAlpbnQgcmMs
IHRtcHJjOworCWludCByZXRyeV9jb3VudCA9IDA7CiAKIAlpZiAoZmxhZ3MgJiB+UkVOQU1FX05P
UkVQTEFDRSkKIAkJcmV0dXJuIC1FSU5WQUw7CkBAIC0yMTEzLDEwICsyMTE0LDI0IEBAIGNpZnNf
cmVuYW1lMihzdHJ1Y3QgdXNlcl9uYW1lc3BhY2UgKm1udF91c2VybnMsIHN0cnVjdCBpbm9kZSAq
c291cmNlX2RpciwKIAkJZ290byBjaWZzX3JlbmFtZV9leGl0OwogCX0KIAotCWNpZnNfY2xvc2Vf
YWxsX2RlZmVycmVkX2ZpbGVzKHRjb24pOworCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShDSUZT
X0koZF9pbm9kZShzb3VyY2VfZGVudHJ5KSkpOworCWlmIChkX2lub2RlKHRhcmdldF9kZW50cnkp
ICE9IE5VTEwpCisJCWNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShDSUZTX0koZF9pbm9kZSh0YXJn
ZXRfZGVudHJ5KSkpOworCiAJcmMgPSBjaWZzX2RvX3JlbmFtZSh4aWQsIHNvdXJjZV9kZW50cnks
IGZyb21fbmFtZSwgdGFyZ2V0X2RlbnRyeSwKIAkJCSAgICB0b19uYW1lKTsKIAorCWlmIChyYyA9
PSAtRUFDQ0VTKSB7CisJCXdoaWxlIChyZXRyeV9jb3VudCA8IDMpIHsKKwkJCWNpZnNfY2xvc2Vf
YWxsX2RlZmVycmVkX2ZpbGVzKHRjb24pOworCQkJcmMgPSBjaWZzX2RvX3JlbmFtZSh4aWQsIHNv
dXJjZV9kZW50cnksIGZyb21fbmFtZSwgdGFyZ2V0X2RlbnRyeSwKKwkJCQkJICAgIHRvX25hbWUp
OworCQkJaWYgKHJjICE9IC1FQUNDRVMpCisJCQkJYnJlYWs7CisJCQlyZXRyeV9jb3VudCsrOwor
CQl9CisJfQorCiAJLyoKIAkgKiBOby1yZXBsYWNlIGlzIHRoZSBuYXR1cmFsIGJlaGF2aW9yIGZv
ciBDSUZTLCBzbyBza2lwIHVubGluayBoYWNrcy4KIAkgKi8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
bWlzYy5jIGIvZnMvY2lmcy9taXNjLmMKaW5kZXggODQ0YWJlYjJiNDhmLi5jZGIxZWMxNDYxZGUg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvbWlzYy5jCisrKyBiL2ZzL2NpZnMvbWlzYy5jCkBAIC03MjMs
MTMgKzcyMywxOSBAQCB2b2lkCiBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0IGNpZnNJ
bm9kZUluZm8gKmNpZnNfaW5vZGUpCiB7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUgPSBO
VUxMOwotCXN0cnVjdCBjaWZzX2RlZmVycmVkX2Nsb3NlICpkY2xvc2U7CisKKwlpZiAoY2lmc19p
bm9kZSA9PSBOVUxMKQorCQlyZXR1cm47CiAKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNmaWxlLCAm
Y2lmc19pbm9kZS0+b3BlbkZpbGVMaXN0LCBmbGlzdCkgewotCQlzcGluX2xvY2soJmNpZnNfaW5v
ZGUtPmRlZmVycmVkX2xvY2spOwotCQlpZiAoY2lmc19pc19kZWZlcnJlZF9jbG9zZShjZmlsZSwg
JmRjbG9zZSkpCi0JCQltb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3EsICZjZmlsZS0+
ZGVmZXJyZWQsIDApOwotCQlzcGluX3VubG9jaygmY2lmc19pbm9kZS0+ZGVmZXJyZWRfbG9jayk7
CisJCWlmIChkZWxheWVkX3dvcmtfcGVuZGluZygmY2ZpbGUtPmRlZmVycmVkKSkgeworCQkJLyoK
KwkJCSAqIElmIHRoZXJlIGlzIG5vIHBlbmRpbmcgd29yaywgbW9kX2RlbGF5ZWRfd29yayBxdWV1
ZXMgbmV3IHdvcmsuCisJCQkgKiBTbywgSW5jcmVhc2UgdGhlIHJlZiBjb3VudCB0byBhdm9pZCB1
c2UtYWZ0ZXItZnJlZS4KKwkJCSAqLworCQkJaWYgKCFtb2RfZGVsYXllZF93b3JrKGRlZmVycmVk
Y2xvc2Vfd3EsICZjZmlsZS0+ZGVmZXJyZWQsIDApKQorCQkJCWNpZnNGaWxlSW5mb19nZXQoY2Zp
bGUpOworCQl9CiAJfQogfQogCi0tIAoyLjMwLjIKCg==
--00000000000009704c05c91d665a--
