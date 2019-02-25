Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CEEC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 07:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E878F20842
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 07:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WUM4VQkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfBYHLB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 02:11:01 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:36895 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfBYHLB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 02:11:01 -0500
Received: by mail-pf1-f178.google.com with SMTP id s22so4058500pfh.4
        for <linux-cifs@vger.kernel.org>; Sun, 24 Feb 2019 23:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NxZvqMR4DlkXx2V1Q3KmKoUxZ279xccaqMZH5shDUPg=;
        b=WUM4VQkwwFeP5GEW4YVuEMVsTFZ/cUsdTu69vUFNaAsQ9iwWB86BKhX+xIza8vRo71
         kIG9uxBB2C1TLt71IoKmIkH9pJXEz5UuRfFy1KUIblMpnOgL97K9ovj4jGpEFsBYr5hG
         z4H9wdZ0E8JZlZrODdVw57vzkypChkFpWIVatapEZkypYR4VjKj4EN1oGy1t39XPxptb
         uTlESTqB3g6mkOw0f9OCwPzeYzymwwkynpBXy8xTiXsSmy6nWoZrBIzpafCjItZANBX4
         ZIIBwucXbXw0NbhxObC65Oo+PtCwDLxQAvtW9+dYkCf2x9z4U+XU07oMNV6arNlkw8VB
         qPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NxZvqMR4DlkXx2V1Q3KmKoUxZ279xccaqMZH5shDUPg=;
        b=QysXoD6ICppUq+sONOG2CBe6efcQIV/jJsrKDfl0ERNLUzDx3w44wb0lMsfUwWc5tr
         vgjKGckRH+KDchBhtZgDw0FwSkQlfB95MCx3WzIzaHzc3nUmfVTXSwTGw+5uHQ4pFFd9
         GdfzGXyZNneOw2882ZENwYhLhZe2JVjj//tu2KxQOOroTnMR69UgrW1qqhAbFaJUO5tc
         p4uvtvT1Gusfz9IzFm/h13V1ciTFYtLU4zyhMiIkLSah/d3cUFJlc6Zm6ZMYi6W7eO3H
         HZr7+t36PYFfx4xn/sU9PA/DpenvQla6U1fq70+frlg680w33zll+mCLzCw4jNaeQxzf
         C5vw==
X-Gm-Message-State: AHQUAubVsY0uTMj3NIhtdUCU6k4+vY9Ir+klX5Z+/Su6/r92fNBxR+ns
        6MfxeUxIywKUuvLMmwj3s4BefqWwcBQuGltrHTYPGfJn
X-Google-Smtp-Source: AHgI3Ibc5HFfcA5Qykv/l+oZxq8hX6scMpDct3G3zrE1Yg8+g4DVa1cp/0JCtiimF78AJlfIa/6xCkvK7ExSnRb/3Nw=
X-Received: by 2002:a63:2c8a:: with SMTP id s132mr17593133pgs.440.1551078659583;
 Sun, 24 Feb 2019 23:10:59 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 01:10:48 -0600
Message-ID: <CAH2r5mt4zNDMkqg1ioqfoiZpNmt2_VnbALG9X8piDeyx5hLdhw@mail.gmail.com>
Subject: [PATCH] smb3 tracepoints for read_enter, write_enter and query_dir_enter
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008611e70582b2a476"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008611e70582b2a476
Content-Type: text/plain; charset="UTF-8"

May be helpful to get timing info for large reads/writes/query_dirs or
to better find hangs or operations that trigger reconnects.   Sample
output from various readdirs with the new tracepoints

# trace-cmd show
# tracer: nop
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              ls-30820 [004] .... 77492.662476: smb3_query_dir_enter:
xid=8 sid=0x2fa2c9ab tid=0x1377432b fid=0xfc37e912 offset=0x0
len=0x4000
              ls-30820 [004] .... 77492.663906: smb3_query_dir_done:
xid=8 sid=0x2fa2c9ab tid=0x1377432b fid=0xfc37e912 offset=0x0 len=0x13
              ls-30820 [004] .... 77492.664107: smb3_query_dir_enter:
xid=9 sid=0x2fa2c9ab tid=0x1377432b fid=0xfc37e912 offset=0x0
len=0x4000
              ls-30820 [004] .... 77492.664639: smb3_query_dir_err:
 xid=9 sid=0x2fa2c9ab tid=0x1377432b fid=0xfc37e912 offset=0x0 len=0x0
rc=0
            bash-27628 [000] .... 77502.150630: smb3_query_dir_enter:
xid=12 sid=0x2fa2c9ab tid=0x1377432b fid=0x26e379e1 offset=0x0
len=0x4000
            bash-27628 [000] .... 77502.151783: smb3_query_dir_done:
xid=12 sid=0x2fa2c9ab tid=0x1377432b fid=0x26e379e1 offset=0x0
len=0x13
            bash-27628 [000] .... 77502.151855: smb3_query_dir_enter:
xid=13 sid=0x2fa2c9ab tid=0x1377432b fid=0x26e379e1 offset=0x0
len=0x4000
            bash-27628 [000] .... 77502.152378: smb3_query_dir_err:
 xid=13 sid=0x2fa2c9ab tid=0x1377432b fid=0x26e379e1 offset=0x0
len=0x0 rc=0
              ls-30821 [001] .... 77502.156573: smb3_query_dir_enter:
xid=15 sid=0x2fa2c9ab tid=0x1377432b fid=0x4f5cedcd offset=0x0
len=0x4000
              ls-30821 [001] .... 77502.157308: smb3_query_dir_done:
xid=15 sid=0x2fa2c9ab tid=0x1377432b fid=0x4f5cedcd offset=0x0 len=0x3
              ls-30821 [001] .... 77502.157364: smb3_query_dir_enter:
xid=16 sid=0x2fa2c9ab tid=0x1377432b fid=0x4f5cedcd offset=0x0
len=0x4000
              ls-30821 [001] .... 77502.157880: smb3_query_dir_err:
 xid=16 sid=0x2fa2c9ab tid=0x1377432b fid=0x4f5cedcd offset=0x0
len=0x0 rc=0
              ls-30821 [001] .... 77502.159819: smb3_query_dir_enter:
xid=18 sid=0x2fa2c9ab tid=0x1377432b fid=0xcb88f96d offset=0x0
len=0x4000
              ls-30821 [003] .... 77502.160591: smb3_query_dir_done:
xid=18 sid=0x2fa2c9ab tid=0x1377432b fid=0xcb88f96d offset=0x0 len=0x3
              ls-30821 [003] .... 77502.160651: smb3_query_dir_enter:
xid=19 sid=0x2fa2c9ab tid=0x1377432b fid=0xcb88f96d offset=0x0
len=0x4000
              ls-30821 [003] .... 77502.161106: smb3_query_dir_err:
 xid=19 sid=0x2fa2c9ab tid=0x1377432b fid=0xcb88f96d offset=0x0
len=0x0 rc=0
              ls-30821 [003] .... 77502.162653: smb3_query_dir_enter:
xid=21 sid=0x2fa2c9ab tid=0x1377432b fid=0x9ca0a6bc offset=0x0
len=0x4000
              ls-30821 [003] .... 77502.163334: smb3_query_dir_done:
xid=21 sid=0x2fa2c9ab tid=0x1377432b fid=0x9ca0a6bc offset=0x0 len=0x3
              ls-30821 [003] .... 77502.163382: smb3_query_dir_enter:
xid=22 sid=0x2fa2c9ab tid=0x1377432b fid=0x9ca0a6bc offset=0x0
len=0x4000
              ls-30821 [003] .... 77502.163894: smb3_query_dir_err:
 xid=22 sid=0x2fa2c9ab tid=0x1377432b fid=0x9ca0a6bc offset=0x0
len=0x0 rc=0


-- 
Thanks,

Steve

--0000000000008611e70582b2a476
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-tracepoints-for-read-write-and-query_dir-en.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-tracepoints-for-read-write-and-query_dir-en.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsk06e480>
X-Attachment-Id: f_jsk06e480

RnJvbSA3YjRiZWRiMTdhNTZhMjBmYTNiNzg2NzhhYWQwN2E3ZWI5ZTdkNzYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjUgRmViIDIwMTkgMDA6NTI6NDMgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBZGQgdHJhY2Vwb2ludHMgZm9yIHJlYWQsIHdyaXRlIGFuZCBxdWVyeV9kaXIgZW50ZXIK
CkFsbG93cyB0cmFjaW5nIGJlZ2luIChub3QganVzdCBjb21wbGV0aW9uKSBvZiByZWFkLCB3cml0
ZQphbmQgcXVlcnlfZGlyIHdoaWNoIG1heSBiZSBoZWxwZnVsIGluIGZpbmRpbmcgc2xvdyByZXF1
ZXN0cwphbmQgb3RoZXIgdGltaW5nIGluZm9ybWF0aW9uCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAx
NSArKysrKysrKysrKysrKysKIGZzL2NpZnMvdHJhY2UuaCAgIHwgIDMgKysrCiAyIGZpbGVzIGNo
YW5nZWQsIDE4IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBi
L2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGI2ZTJhMWY0MDA3OC4uMzU4OTUxODQwNzU2IDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMzE0
Miw2ICszMTQyLDExIEBAIHNtYjJfbmV3X3JlYWRfcmVxKHZvaWQgKipidWYsIHVuc2lnbmVkIGlu
dCAqdG90YWxfbGVuLAogCXJlcS0+TWluaW11bUNvdW50ID0gMDsKIAlyZXEtPkxlbmd0aCA9IGNw
dV90b19sZTMyKGlvX3Bhcm1zLT5sZW5ndGgpOwogCXJlcS0+T2Zmc2V0ID0gY3B1X3RvX2xlNjQo
aW9fcGFybXMtPm9mZnNldCk7CisKKwl0cmFjZV9zbWIzX3JlYWRfZW50ZXIoMCAvKiB4aWQgKi8s
CisJCQlpb19wYXJtcy0+cGVyc2lzdGVudF9maWQsCisJCQlpb19wYXJtcy0+dGNvbi0+dGlkLCBp
b19wYXJtcy0+dGNvbi0+c2VzLT5TdWlkLAorCQkJaW9fcGFybXMtPm9mZnNldCwgaW9fcGFybXMt
Pmxlbmd0aCk7CiAjaWZkZWYgQ09ORklHX0NJRlNfU01CX0RJUkVDVAogCS8qCiAJICogSWYgd2Ug
d2FudCB0byBkbyBhIFJETUEgd3JpdGUsIGZpbGwgaW4gYW5kIGFwcGVuZApAQCAtMzU0MSw2ICsz
NTQ2LDkgQEAgc21iMl9hc3luY193cml0ZXYoc3RydWN0IGNpZnNfd3JpdGVkYXRhICp3ZGF0YSwK
IAlyZXEtPkRhdGFPZmZzZXQgPSBjcHVfdG9fbGUxNigKIAkJCQlvZmZzZXRvZihzdHJ1Y3Qgc21i
Ml93cml0ZV9yZXEsIEJ1ZmZlcikpOwogCXJlcS0+UmVtYWluaW5nQnl0ZXMgPSAwOworCisJdHJh
Y2Vfc21iM193cml0ZV9lbnRlcigwIC8qIHhpZCAqLywgd2RhdGEtPmNmaWxlLT5maWQucGVyc2lz
dGVudF9maWQsCisJCXRjb24tPnRpZCwgdGNvbi0+c2VzLT5TdWlkLCB3ZGF0YS0+b2Zmc2V0LCB3
ZGF0YS0+Ynl0ZXMpOwogI2lmZGVmIENPTkZJR19DSUZTX1NNQl9ESVJFQ1QKIAkvKgogCSAqIElm
IHdlIHdhbnQgdG8gZG8gYSBzZXJ2ZXIgUkRNQSByZWFkLCBmaWxsIGluIGFuZCBhcHBlbmQKQEAg
LTM2ODgsNiArMzY5NiwxMCBAQCBTTUIyX3dyaXRlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0
cnVjdCBjaWZzX2lvX3Bhcm1zICppb19wYXJtcywKIAkJCQlvZmZzZXRvZihzdHJ1Y3Qgc21iMl93
cml0ZV9yZXEsIEJ1ZmZlcikpOwogCXJlcS0+UmVtYWluaW5nQnl0ZXMgPSAwOwogCisJdHJhY2Vf
c21iM193cml0ZV9lbnRlcih4aWQsIGlvX3Bhcm1zLT5wZXJzaXN0ZW50X2ZpZCwKKwkJaW9fcGFy
bXMtPnRjb24tPnRpZCwgaW9fcGFybXMtPnRjb24tPnNlcy0+U3VpZCwKKwkJaW9fcGFybXMtPm9m
ZnNldCwgaW9fcGFybXMtPmxlbmd0aCk7CisKIAlpb3ZbMF0uaW92X2Jhc2UgPSAoY2hhciAqKXJl
cTsKIAkvKiAxIGZvciBCdWZmZXIgKi8KIAlpb3ZbMF0uaW92X2xlbiA9IHRvdGFsX2xlbiAtIDE7
CkBAIC0zODUwLDYgKzM4NjIsOSBAQCBTTUIyX3F1ZXJ5X2RpcmVjdG9yeShjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXJxc3QucnFfaW92ID0gaW92Owog
CXJxc3QucnFfbnZlYyA9IDI7CiAKKwl0cmFjZV9zbWIzX3F1ZXJ5X2Rpcl9lbnRlcih4aWQsIHBl
cnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJCQl0Y29uLT5zZXMtPlN1aWQsIGluZGV4LCBvdXRw
dXRfc2l6ZSk7CisKIAlyYyA9IGNpZnNfc2VuZF9yZWN2KHhpZCwgc2VzLCAmcnFzdCwgJnJlc3Bf
YnVmdHlwZSwgZmxhZ3MsICZyc3BfaW92KTsKIAljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKHJlcSk7
CiAJcnNwID0gKHN0cnVjdCBzbWIyX3F1ZXJ5X2RpcmVjdG9yeV9yc3AgKilyc3BfaW92Lmlvdl9i
YXNlOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFjZS5oIGIvZnMvY2lmcy90cmFjZS5oCmluZGV4
IGJmNGY0M2Y2ODkzYi4uNjYwMTc2ZTM0ZGRlIDEwMDY0NAotLS0gYS9mcy9jaWZzL3RyYWNlLmgK
KysrIGIvZnMvY2lmcy90cmFjZS5oCkBAIC0xMDEsNiArMTAxLDkgQEAgREVGSU5FX0VWRU5UKHNt
YjNfcndfZG9uZV9jbGFzcywgc21iM18jI25hbWUsICAgXAogCQlfX3UzMglsZW4pLAkJCVwKIAlU
UF9BUkdTKHhpZCwgZmlkLCB0aWQsIHNlc2lkLCBvZmZzZXQsIGxlbikpCiAKK0RFRklORV9TTUIz
X1JXX0RPTkVfRVZFTlQod3JpdGVfZW50ZXIpOworREVGSU5FX1NNQjNfUldfRE9ORV9FVkVOVChy
ZWFkX2VudGVyKTsKK0RFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQocXVlcnlfZGlyX2VudGVyKTsK
IERFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQod3JpdGVfZG9uZSk7CiBERUZJTkVfU01CM19SV19E
T05FX0VWRU5UKHJlYWRfZG9uZSk7CiBERUZJTkVfU01CM19SV19ET05FX0VWRU5UKHF1ZXJ5X2Rp
cl9kb25lKTsKLS0gCjIuMTcuMQoK
--0000000000008611e70582b2a476--
