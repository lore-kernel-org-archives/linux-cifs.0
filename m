Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC097C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24DF2070D
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 06:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqyay50G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfCMGne (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 02:43:34 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36367 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfCMGnd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 02:43:33 -0400
Received: by mail-pf1-f180.google.com with SMTP id n22so700647pfa.3
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2019 23:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=h2Ln+QIBR47s8dWdmAzdo3QGPkGCjYrY/uYfg10Z20s=;
        b=dqyay50GqOnECifvVhsm7AqB+Ankv76M6NOck1tPRcwgL3JNrlnbmyjcFnChMrfXsA
         TbDOxBf5xZ3S/osXNLLnR2UXoHPTfpx17PLRJSmM8zuuydYYRqikQ+yF04TB+FeVRD5g
         3/hBYLrlb/L6nDS4sr03AOqs6cCfGH+XOSwI0kq8/PcPJ++Qpz4bXGL2VKPKJlfd35iu
         gK9MbY/0mhA56A8/2EluNB5hOBuPaHJpdSj2A1q8GS4OvlsSAlCxD3BEJ8c7CoG0gzgk
         Spc/e7Xm81izkU+o5NqkQN7M2279gDb4hnJkBhE/kEj7Oc6e8Shg0XNiYCcl0k+UMsfb
         F4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=h2Ln+QIBR47s8dWdmAzdo3QGPkGCjYrY/uYfg10Z20s=;
        b=jFSIlmliRC8MYkkHIQVZRhPTL06qCG9Nb3RUTJsEzkIe/YJGpPMwZUcKSPYLYigmwU
         bC92YQDgCnKP8ttvu1y5lVvJhQ3LNxZfq9t1yphDQG6vg5sicpI60PfZEX6izb0Da5xK
         9UPgxdRO8hu/cXw1Mue2SZy58rCT9Vn+RXUMWRSnDHKl0trUicZUw1rQZmCMCwuBsr2P
         dKiQc266opqWkRL9sumAjcKpwdvzwiXLXqRDph1ijmBrO3GNGi7Vd+VF8eLaexm984YH
         bPQ972BtwwlVPgLitlojKsNpMxqRT3W3rpdYj1Qx7wldiO/nozd7fdlgbDe/B33BgcD9
         SWbA==
X-Gm-Message-State: APjAAAXKMYU3+PbRAv9ME0Np1mRKeDj5FweihbjWRqTStnyxImmKUswt
        VSdLmB8rO5vYWbBXDQ4lp1yd3mJJHV+ifPWBsCE=
X-Google-Smtp-Source: APXvYqxaRb4Mw/BSTaXSLChfyxv4sSit61QcH6RNxpMj2bKWtLliQL+8caBfyJ3lyB0gJ2kpUa4g6EINBGoWbpWG0Qs=
X-Received: by 2002:a17:902:b618:: with SMTP id b24mr42092232pls.73.1552459412531;
 Tue, 12 Mar 2019 23:43:32 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Mar 2019 01:43:21 -0500
Message-ID: <CAH2r5mu_adiGYpgLO_UUAjmS=tXBtYi1Q7EZK_PD7o_a9ChMaA@mail.gmail.com>
Subject: [PATCH] add dynamic tracepoints for two simple falloc and zero range
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d00b0c0583f41fed"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d00b0c0583f41fed
Content-Type: text/plain; charset="UTF-8"

Sample output (trace-cmd record -e *smb3*falloc* -e *smb3*zero*):

#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
       fallocate-25699 [002] .... 453345.398491: smb3_falloc_enter:
xid=8 sid=0xa342bb96 tid=0xd2a49757 fid=0x93514326 offset=0x0
len=0x200000
       fallocate-25699 [002] .... 453345.398494: smb3_falloc_err:
xid=8 sid=0xa342bb96 tid=0xd2a49757 fid=0x93514326 offset=0x0
len=0x200000 rc=-95
       fallocate-25738 [006] .... 453408.813356: smb3_zero_enter:
xid=12 sid=0xa342bb96 tid=0xd2a49757 fid=0x9fe7e532 offset=0x2710
len=0x64
       fallocate-25738 [006] .... 453408.813359: smb3_zero_err:
xid=12 sid=0xa342bb96 tid=0xd2a49757 fid=0x9fe7e532 offset=0x2710
len=0x64 rc=-95


-- 
Thanks,

Steve

--000000000000d00b0c0583f41fed
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-tracepoints-for-simple-fallocate-an.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-tracepoints-for-simple-fallocate-an.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt6u8qod0>
X-Attachment-Id: f_jt6u8qod0

RnJvbSBmNTA1MmI5MTQxMzQ2YzIyY2RjODNlNWI2NzE4NjQ4ZmM1NDcwZTU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTMgTWFyIDIwMTkgMDE6NDE6NDkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZXBvaW50cyBmb3Igc2ltcGxlIGZhbGxvY2F0ZSBhbmQgemVy
bwogcmFuZ2UKCkNhbiBiZSBoZWxwZnVsIGluIGRlYnVnZ2luZyB2YXJpb3VzIHhmc3Rlc3RzIHRo
YXQgYXJlIGN1cnJlbnRseQpza2lwcGVkIG9yIGZhaWxpbmcgZHVlIHRvIG1pc3NpbmcgZmVhdHVy
ZXMgaW4gb3VyIGN1cnJlbnQKaW1wbGVtZW50YXRpb24gb2YgZmFsbG9jYXRlLgoKU2lnbmVkLW9m
Zi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMv
c21iMm9wcy5jIHwgMzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMv
dHJhY2UuaCAgIHwgIDYgKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKykK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4
IGJkM2QyMjg4MTYxYy4uODIzYTU4NTUwZGZkIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMu
YworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjU3MSwxMCArMjU3MSwxNiBAQCBzdGF0aWMg
bG9uZyBzbWIzX3plcm9fcmFuZ2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24sCiAJaW5vZGUgPSBkX2lub2RlKGNmaWxlLT5kZW50cnkpOwogCWNpZnNpID0gQ0lGU19J
KGlub2RlKTsKIAorICAgICAgICB0cmFjZV9zbWIzX3plcm9fZW50ZXIoeGlkLCBjZmlsZS0+Zmlk
LnBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJCQkgICAgICBzZXMtPlN1aWQsIG9mZnNldCwg
bGVuKTsKKworCiAJLyogaWYgZmlsZSBub3Qgb3Bsb2NrZWQgY2FuJ3QgYmUgc3VyZSB3aGV0aGVy
IGFza2luZyB0byBleHRlbmQgc2l6ZSAqLwogCWlmICghQ0lGU19DQUNIRV9SRUFEKGNpZnNpKSkK
IAkJaWYgKGtlZXBfc2l6ZSA9PSBmYWxzZSkgewogCQkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJCXRy
YWNlX3NtYjNfemVyb19lcnIoeGlkLCBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkLAorCQkJCXRj
b24tPnRpZCwgc2VzLT5TdWlkLCBvZmZzZXQsIGxlbiwgcmMpOwogCQkJZnJlZV94aWQoeGlkKTsK
IAkJCXJldHVybiByYzsKIAkJfQpAQCAtMjU4NSw2ICsyNTkxLDggQEAgc3RhdGljIGxvbmcgc21i
M196ZXJvX3JhbmdlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CSAqLwogCWlmICghKGNpZnNpLT5jaWZzQXR0cnMgJiBGSUxFX0FUVFJJQlVURV9TUEFSU0VfRklM
RSkpIHsKIAkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJdHJhY2Vfc21iM196ZXJvX2Vycih4aWQsIGNm
aWxlLT5maWQucGVyc2lzdGVudF9maWQsIHRjb24tPnRpZCwKKwkJCSAgICAgIHNlcy0+U3VpZCwg
b2Zmc2V0LCBsZW4sIHJjKTsKIAkJZnJlZV94aWQoeGlkKTsKIAkJcmV0dXJuIHJjOwogCX0KQEAg
LTI2NDQsNiArMjY1MiwxMiBAQCBzdGF0aWMgbG9uZyBzbWIzX3plcm9fcmFuZ2Uoc3RydWN0IGZp
bGUgKmZpbGUsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJZnJlZV9yc3BfYnVmKHJlc3BfYnVm
dHlwZVswXSwgcnNwX2lvdlswXS5pb3ZfYmFzZSk7CiAJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlw
ZVsxXSwgcnNwX2lvdlsxXS5pb3ZfYmFzZSk7CiAJZnJlZV94aWQoeGlkKTsKKwlpZiAocmMpCisJ
CXRyYWNlX3NtYjNfemVyb19lcnIoeGlkLCBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkLCB0Y29u
LT50aWQsCisJCQkgICAgICBzZXMtPlN1aWQsIG9mZnNldCwgbGVuLCByYyk7CisJZWxzZQorCQl0
cmFjZV9zbWIzX3plcm9fZG9uZSh4aWQsIGNmaWxlLT5maWQucGVyc2lzdGVudF9maWQsIHRjb24t
PnRpZCwKKwkJCSAgICAgIHNlcy0+U3VpZCwgb2Zmc2V0LCBsZW4pOwogCXJldHVybiByYzsKIH0K
IApAQCAtMjY5OCw5ICsyNzEyLDEzIEBAIHN0YXRpYyBsb25nIHNtYjNfc2ltcGxlX2ZhbGxvYyhz
dHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlpbm9kZSA9IGRfaW5v
ZGUoY2ZpbGUtPmRlbnRyeSk7CiAJY2lmc2kgPSBDSUZTX0koaW5vZGUpOwogCisJdHJhY2Vfc21i
M19mYWxsb2NfZW50ZXIoeGlkLCBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQs
CisJCQkJdGNvbi0+c2VzLT5TdWlkLCBvZmYsIGxlbik7CiAJLyogaWYgZmlsZSBub3Qgb3Bsb2Nr
ZWQgY2FuJ3QgYmUgc3VyZSB3aGV0aGVyIGFza2luZyB0byBleHRlbmQgc2l6ZSAqLwogCWlmICgh
Q0lGU19DQUNIRV9SRUFEKGNpZnNpKSkKIAkJaWYgKGtlZXBfc2l6ZSA9PSBmYWxzZSkgeworCQkJ
dHJhY2Vfc21iM19mYWxsb2NfZXJyKHhpZCwgY2ZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKKwkJ
CQl0Y29uLT50aWQsIHRjb24tPnNlcy0+U3VpZCwgb2ZmLCBsZW4sIHJjKTsKIAkJCWZyZWVfeGlk
KHhpZCk7CiAJCQlyZXR1cm4gcmM7CiAJCX0KQEAgLTI3MjAsNiArMjczOCwxMiBAQCBzdGF0aWMg
bG9uZyBzbWIzX3NpbXBsZV9mYWxsb2Moc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJCS8qIEJCOiBpbiBmdXR1cmUgYWRkIGVsc2UgY2xhdXNlIHRvIGV4dGVuZCBm
aWxlICovCiAJCWVsc2UKIAkJCXJjID0gLUVPUE5PVFNVUFA7CisJCWlmIChyYykKKwkJCXRyYWNl
X3NtYjNfZmFsbG9jX2Vycih4aWQsIGNmaWxlLT5maWQucGVyc2lzdGVudF9maWQsCisJCQkJdGNv
bi0+dGlkLCB0Y29uLT5zZXMtPlN1aWQsIG9mZiwgbGVuLCByYyk7CisJCWVsc2UKKwkJCXRyYWNl
X3NtYjNfZmFsbG9jX2RvbmUoeGlkLCBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkLAorCQkJCXRj
b24tPnRpZCwgdGNvbi0+c2VzLT5TdWlkLCBvZmYsIGxlbik7CiAJCWZyZWVfeGlkKHhpZCk7CiAJ
CXJldHVybiByYzsKIAl9CkBAIC0yNzM1LDYgKzI3NTksOCBAQCBzdGF0aWMgbG9uZyBzbWIzX3Np
bXBsZV9mYWxsb2Moc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CSAqLwogCQlpZiAoKG9mZiA+IDgxOTIpIHx8IChvZmYgKyBsZW4gKyA4MTkyIDwgaV9zaXplX3Jl
YWQoaW5vZGUpKSkgewogCQkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJCXRyYWNlX3NtYjNfZmFsbG9j
X2Vycih4aWQsIGNmaWxlLT5maWQucGVyc2lzdGVudF9maWQsCisJCQkJdGNvbi0+dGlkLCB0Y29u
LT5zZXMtPlN1aWQsIG9mZiwgbGVuLCByYyk7CiAJCQlmcmVlX3hpZCh4aWQpOwogCQkJcmV0dXJu
IHJjOwogCQl9CkBAIC0yNzQzLDYgKzI3NjksMTIgQEAgc3RhdGljIGxvbmcgc21iM19zaW1wbGVf
ZmFsbG9jKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCX0KIAkv
KiBCQjogZWxzZSAuLi4gaW4gZnV0dXJlIGFkZCBjb2RlIHRvIGV4dGVuZCBmaWxlIGFuZCBzZXQg
c3BhcnNlICovCiAKKwlpZiAocmMpCisJCXRyYWNlX3NtYjNfZmFsbG9jX2Vycih4aWQsIGNmaWxl
LT5maWQucGVyc2lzdGVudF9maWQsIHRjb24tPnRpZCwKKwkJCQl0Y29uLT5zZXMtPlN1aWQsIG9m
ZiwgbGVuLCByYyk7CisJZWxzZQorCQl0cmFjZV9zbWIzX2ZhbGxvY19kb25lKHhpZCwgY2ZpbGUt
PmZpZC5wZXJzaXN0ZW50X2ZpZCwgdGNvbi0+dGlkLAorCQkJCXRjb24tPnNlcy0+U3VpZCwgb2Zm
LCBsZW4pOwogCiAJZnJlZV94aWQoeGlkKTsKIAlyZXR1cm4gcmM7CmRpZmYgLS1naXQgYS9mcy9j
aWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgKaW5kZXggMzBiZjUxYzdlOGZlLi5mYTIyNmRl
NDhlZjMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhY2UuaAorKysgYi9mcy9jaWZzL3RyYWNlLmgK
QEAgLTU5LDYgKzU5LDggQEAgREVGSU5FX0VWRU5UKHNtYjNfcndfZXJyX2NsYXNzLCBzbWIzXyMj
bmFtZSwgICAgXAogREVGSU5FX1NNQjNfUldfRVJSX0VWRU5UKHdyaXRlX2Vycik7CiBERUZJTkVf
U01CM19SV19FUlJfRVZFTlQocmVhZF9lcnIpOwogREVGSU5FX1NNQjNfUldfRVJSX0VWRU5UKHF1
ZXJ5X2Rpcl9lcnIpOworREVGSU5FX1NNQjNfUldfRVJSX0VWRU5UKHplcm9fZXJyKTsKK0RFRklO
RV9TTUIzX1JXX0VSUl9FVkVOVChmYWxsb2NfZXJyKTsKIAogCiAvKiBGb3IgbG9nZ2luZyBzdWNj
ZXNzZnVsIHJlYWQgb3Igd3JpdGUgKi8KQEAgLTEwNCw5ICsxMDYsMTMgQEAgREVGSU5FX0VWRU5U
KHNtYjNfcndfZG9uZV9jbGFzcywgc21iM18jI25hbWUsICAgXAogREVGSU5FX1NNQjNfUldfRE9O
RV9FVkVOVCh3cml0ZV9lbnRlcik7CiBERUZJTkVfU01CM19SV19ET05FX0VWRU5UKHJlYWRfZW50
ZXIpOwogREVGSU5FX1NNQjNfUldfRE9ORV9FVkVOVChxdWVyeV9kaXJfZW50ZXIpOworREVGSU5F
X1NNQjNfUldfRE9ORV9FVkVOVCh6ZXJvX2VudGVyKTsKK0RFRklORV9TTUIzX1JXX0RPTkVfRVZF
TlQoZmFsbG9jX2VudGVyKTsKIERFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQod3JpdGVfZG9uZSk7
CiBERUZJTkVfU01CM19SV19ET05FX0VWRU5UKHJlYWRfZG9uZSk7CiBERUZJTkVfU01CM19SV19E
T05FX0VWRU5UKHF1ZXJ5X2Rpcl9kb25lKTsKK0RFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQoemVy
b19kb25lKTsKK0RFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQoZmFsbG9jX2RvbmUpOwogCiAvKgog
ICogRm9yIGhhbmRsZSBiYXNlZCBjYWxscyBvdGhlciB0aGFuIHJlYWQgYW5kIHdyaXRlLCBhbmQg
Z2V0L3NldCBpbmZvCi0tIAoyLjE3LjEKCg==
--000000000000d00b0c0583f41fed--
