Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904E5C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 20:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CFE2087C
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 20:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rlQK1Ch+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfBYUws (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 15:52:48 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37524 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfBYUwr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 15:52:47 -0500
Received: by mail-pg1-f170.google.com with SMTP id q206so5039816pgq.4
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 12:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sbFSYLpPos/SIxSxQP++8hGnQhJ0hDCR87aen5amVEc=;
        b=rlQK1Ch+q/lzw7ggoffxrs7t8nHZ6VMiLDBlrYgdSghqVbZWIWck/oAs7rOMW/G5SW
         r4xjUcITPZkyZwnLKqVvOB6tmMglDB3KwQrVOgmsBTFj5DyoHHDSJDPHhVa0XhFPXNIF
         EdRDEWn6/eyz5ONAHTk4HVxqeVF+507s03kwv9/zJpV0x1y1nu3KWO+bjBhEein7YqCU
         aQNdwCdL9A4VXTkw8nqDF0Va/e22V/gQH67a35zRxFDhMhdlfVCwVVrsCCagL07k76JT
         n5C7v6vB8Whp6hVYOrO7wSYjukppNVcycr2LFotlCNhTyQFsjzILPXKHRlMIFwIHi2Os
         H8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sbFSYLpPos/SIxSxQP++8hGnQhJ0hDCR87aen5amVEc=;
        b=eKaQ3XAbyP8rftXn3Nw4zbcW1ei6Vlc5Gza7XT3IHZ0tu466Kwj0DEWMh1pBKJQoL4
         VpFUP6NiVZFnTW77m68PFvpoeWy3Z9PRel4+XLI5Gpixx4Gq35zFnkBW6iVkGLFPJhuM
         XrSEPER7fLswLQGMJtT7gaVBEg6q5GagoRapj/eoJ0bq6ksZeUy1C4sw2JpAgsbRpNj8
         LquJsv+PIq5a++ehUO0kA4I2+G9DrjBbLOhHXL0PxhfO66RGDKH0D7vgCamLtNTpWFfl
         A3YLJEIbzmMxHy7W2W0lC1ikt3A1O3PR8tnYvtGE7HOQYjwBObnF1KmNURXLcO0fKYw3
         y+NQ==
X-Gm-Message-State: AHQUAuayeGPJvJNmVaILtIHznQUCY6mwy+n9T0mBAdmrydk0ZMpCIGro
        f68EeqoZn2I2F6hSWg1poPL6DKtK5vX6X/reHUic9I8f
X-Google-Smtp-Source: AHgI3IYuX7FhyxbokjWjPgc98tIHmpVX8VfcjYTz1il8MjBq1dgpkNd8ScRKeQ+KFneCAe4u7wnm40/3MMWwRl9WfuY=
X-Received: by 2002:aa7:8d42:: with SMTP id s2mr3494662pfe.116.1551127966121;
 Mon, 25 Feb 2019 12:52:46 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 14:52:34 -0600
Message-ID: <CAH2r5mtPFfn+wi1LEfe=po+DYMFO51w+ZVtOAiY2Ex7CJMxdug@mail.gmail.com>
Subject: Updated ftrace patches for read/write/query_dir
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006c21e90582be1f45"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006c21e90582be1f45
Content-Type: text/plain; charset="UTF-8"

Sample output (from "trace-cmd record -e  smb3_query* -e smb3_read* -e
smb3_write*")

#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
              ls-25909 [004] .... 91084.368421: smb3_query_dir_enter:
xid=8 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0
len=0x4000
              ls-25909 [004] .... 91084.369413: smb3_query_dir_done:
xid=8 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0 len=0x8
              ls-25909 [004] .... 91084.369530: smb3_query_dir_enter:
xid=9 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0
len=0x4000
              ls-25909 [004] .... 91084.370020: smb3_query_dir_done:
xid=9 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0 len=0x0
              dd-25915 [004] .... 91101.999225: smb3_read_enter: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x0 len=0x400000
           cifsd-25891 [005] .... 91102.010600: smb3_read_done: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x0 len=0x400000
              dd-25915 [004] .... 91102.015131: smb3_read_enter: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x400000
len=0x3d0000
           cifsd-25891 [005] .... 91102.026541: smb3_read_done: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x400000
len=0x3d0000
              dd-25915 [004] .... 91102.028261: smb3_read_enter: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x7d0000
len=0x1000
              dd-25919 [006] .... 91121.554908: smb3_write_enter:
xid=0 sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x0
len=0x400000
              dd-25919 [006] .... 91121.556448: smb3_write_enter:
xid=0 sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x400000
len=0x3d0000
           cifsd-25891 [005] .... 91121.559831: smb3_write_done: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x0 len=0x400000
           cifsd-25891 [005] .... 91121.561798: smb3_write_done: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x400000
len=0x3d0000
              dd-25931 [007] .... 91161.643194: smb3_read_enter: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x0 len=0x400000
           cifsd-25891 [005] .... 91161.650859: smb3_read_done: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x0 len=0x400000
              dd-25931 [007] .... 91161.655470: smb3_read_enter: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x400000
len=0x3d0000
           cifsd-25891 [004] .... 91161.663517: smb3_read_done: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x400000
len=0x3d0000
              dd-25931 [001] .... 91161.664921: smb3_read_enter: xid=0
sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x7d0000
len=0x1000


-- 
Thanks,

Steve

--0000000000006c21e90582be1f45
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-tracepoints-for-query-dir.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-tracepoints-for-query-dir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsktj2l90>
X-Attachment-Id: f_jsktj2l90

RnJvbSAyYWQwMTZhNjE2Njc2MWQwOGY3NTk2ZWI2M2IzMTg4MDc0YjY1ZTc5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjUgRmViIDIwMTkgMTM6NTE6MTEgLTA2MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gc21iMzogYWRkIHRyYWNlcG9pbnRzIGZvciBxdWVyeSBkaXIKCkFkZHMgdHdvIHRyYWNlcG9p
bnRzIC0gb25lIGZvciBxdWVyeV9kaXIgZG9uZSAobm8gZXJyKSBhbmQgb25lIGZvciBxdWVyeV9k
aXJfZXJyCgpTYW5wbGUgb3V0cHV0OgoKVG8gc3RhcnQgdGhlIHRyYWNlIGluIG9uZSB3aW5kb3c6
CiAgICAgICB0cmFjZS1jbWQgcmVjb3JkIC1lIHNtYjNfcXVlcnlfZGlyKgoKVGhlbiBpbiBhbm90
aGVyIHdpbmRvdyBhZnRlciBkb2luZyBhbgogICAgICAgbHMgL21udAoKVmlldyB0aGUgdHJhY2Ug
b3V0cHV0IGJ5OgoKICAgICAgICB0cmFjZS1jbWQgc2hvdwoKU2FtcGxlIG91dHB1dDoKCiAgICAg
ICAgICAgVEFTSy1QSUQgICBDUFUjICB8fHx8ICAgIFRJTUVTVEFNUCAgRlVOQ1RJT04KICAgICAg
ICAgICAgICB8IHwgICAgICAgfCAgIHx8fHwgICAgICAgfCAgICAgICAgIHwKICAgICAgICAgICAg
IGxzLTI0ODY5IFswMDddIC4uLi4gOTA2OTUuNDUyMDA5OiBzbWIzX3F1ZXJ5X2Rpcl9kb25lOiB4
aWQ9NyBzaWQ9MHg1MDI3ZDI0ZCB0aWQ9MHhiOTVjZjI1YSBmaWQ9MHhjNDFhOGMzZSBvZmZzZXQ9
MHgwIGxlbj0weDE2CiAgICAgICAgICAgICBscy0yNDg2OSBbMDAwXSAuLi4uIDkwNjk1LjQ1Mjc2
NDogc21iM19xdWVyeV9kaXJfZG9uZTogeGlkPTggc2lkPTB4NTAyN2QyNGQgdGlkPTB4Yjk1Y2Yy
NWEgZmlkPTB4YzQxYThjM2Ugb2Zmc2V0PTB4MCBsZW49MHgwCiAgICAgICAgICAgICBscy0yNDg3
NCBbMDAzXSAuLi4uIDkwNzAxLjUwNjM0Mjogc21iM19xdWVyeV9kaXJfZG9uZTogeGlkPTExIHNp
ZD0weDUwMjdkMjRkIHRpZD0weGI5NWNmMjVhIGZpZD0weDMzYWQzNjAxIG9mZnNldD0weDAgbGVu
PTB4OAogICAgICAgICAgICAgbHMtMjQ4NzQgWzAwM10gLi4uLiA5MDcwMS41MDY5MTc6IHNtYjNf
cXVlcnlfZGlyX2RvbmU6IHhpZD0xMiBzaWQ9MHg1MDI3ZDI0ZCB0aWQ9MHhiOTVjZjI1YSBmaWQ9
MHgzM2FkMzYwMSBvZmZzZXQ9MHgwIGxlbj0weDAKClJldmlld2VkLWJ5OiBQYXZlbCBTaGlsb3Zz
a3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5jIHwgMTQgKysrKysr
KysrKysrLS0KIGZzL2NpZnMvdHJhY2UuaCAgIHwgIDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgMTQg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJw
ZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDY0ZTE3MjYzM2JjNC4uOTY1YzRjN2U4N2Y5
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpA
QCAtMzg1NywxOCArMzg1NywyNiBAQCBTTUIyX3F1ZXJ5X2RpcmVjdG9yeShjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCWlmIChyYykgewogCQlpZiAocmMg
PT0gLUVOT0RBVEEgJiYKIAkJICAgIHJzcC0+c3luY19oZHIuU3RhdHVzID09IFNUQVRVU19OT19N
T1JFX0ZJTEVTKSB7CisJCQl0cmFjZV9zbWIzX3F1ZXJ5X2Rpcl9kb25lKHhpZCwgcGVyc2lzdGVu
dF9maWQsCisJCQkJdGNvbi0+dGlkLCB0Y29uLT5zZXMtPlN1aWQsIGluZGV4LCAwKTsKIAkJCXNy
Y2hfaW5mLT5lbmRPZlNlYXJjaCA9IHRydWU7CiAJCQlyYyA9IDA7Ci0JCX0gZWxzZQorCQl9IGVs
c2UgeworCQkJdHJhY2Vfc21iM19xdWVyeV9kaXJfZXJyKHhpZCwgcGVyc2lzdGVudF9maWQsIHRj
b24tPnRpZCwKKwkJCQl0Y29uLT5zZXMtPlN1aWQsIGluZGV4LCAwLCByYyk7CiAJCQljaWZzX3N0
YXRzX2ZhaWxfaW5jKHRjb24sIFNNQjJfUVVFUllfRElSRUNUT1JZX0hFKTsKKwkJfQogCQlnb3Rv
IHFkaXJfZXhpdDsKIAl9CiAKIAlyYyA9IHNtYjJfdmFsaWRhdGVfaW92KGxlMTZfdG9fY3B1KHJz
cC0+T3V0cHV0QnVmZmVyT2Zmc2V0KSwKIAkJCSAgICAgICBsZTMyX3RvX2NwdShyc3AtPk91dHB1
dEJ1ZmZlckxlbmd0aCksICZyc3BfaW92LAogCQkJICAgICAgIGluZm9fYnVmX3NpemUpOwotCWlm
IChyYykKKwlpZiAocmMpIHsKKwkJdHJhY2Vfc21iM19xdWVyeV9kaXJfZXJyKHhpZCwgcGVyc2lz
dGVudF9maWQsIHRjb24tPnRpZCwKKwkJCXRjb24tPnNlcy0+U3VpZCwgaW5kZXgsIDAsIHJjKTsK
IAkJZ290byBxZGlyX2V4aXQ7CisJfQogCiAJc3JjaF9pbmYtPnVuaWNvZGUgPSB0cnVlOwogCkBA
IC0zODk2LDYgKzM5MDQsOCBAQCBTTUIyX3F1ZXJ5X2RpcmVjdG9yeShjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCWVsc2UKIAkJY2lmc19kYmcoVkZTLCAi
aWxsZWdhbCBzZWFyY2ggYnVmZmVyIHR5cGVcbiIpOwogCisJdHJhY2Vfc21iM19xdWVyeV9kaXJf
ZG9uZSh4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJCQl0Y29uLT5zZXMtPlN1aWQs
IGluZGV4LCBzcmNoX2luZi0+ZW50cmllc19pbl9idWZmZXIpOwogCXJldHVybiByYzsKIAogcWRp
cl9leGl0OgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFjZS5oIGIvZnMvY2lmcy90cmFjZS5oCmlu
ZGV4IDU5YmU0ODIwNjkzMi4uYmY0ZjQzZjY4OTNiIDEwMDY0NAotLS0gYS9mcy9jaWZzL3RyYWNl
LmgKKysrIGIvZnMvY2lmcy90cmFjZS5oCkBAIC01OCw2ICs1OCw3IEBAIERFRklORV9FVkVOVChz
bWIzX3J3X2Vycl9jbGFzcywgc21iM18jI25hbWUsICAgIFwKIAogREVGSU5FX1NNQjNfUldfRVJS
X0VWRU5UKHdyaXRlX2Vycik7CiBERUZJTkVfU01CM19SV19FUlJfRVZFTlQocmVhZF9lcnIpOwor
REVGSU5FX1NNQjNfUldfRVJSX0VWRU5UKHF1ZXJ5X2Rpcl9lcnIpOwogCiAKIC8qIEZvciBsb2dn
aW5nIHN1Y2Nlc3NmdWwgcmVhZCBvciB3cml0ZSAqLwpAQCAtMTAyLDYgKzEwMyw3IEBAIERFRklO
RV9FVkVOVChzbWIzX3J3X2RvbmVfY2xhc3MsIHNtYjNfIyNuYW1lLCAgIFwKIAogREVGSU5FX1NN
QjNfUldfRE9ORV9FVkVOVCh3cml0ZV9kb25lKTsKIERFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQo
cmVhZF9kb25lKTsKK0RFRklORV9TTUIzX1JXX0RPTkVfRVZFTlQocXVlcnlfZGlyX2RvbmUpOwog
CiAvKgogICogRm9yIGhhbmRsZSBiYXNlZCBjYWxscyBvdGhlciB0aGFuIHJlYWQgYW5kIHdyaXRl
LCBhbmQgZ2V0L3NldCBpbmZvCi0tIAoyLjE3LjEKCg==
--0000000000006c21e90582be1f45
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-smb3-Add-tracepoints-for-read-write-and-query_dir-en.patch"
Content-Disposition: attachment; 
	filename="0002-smb3-Add-tracepoints-for-read-write-and-query_dir-en.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsktj6qc1>
X-Attachment-Id: f_jsktj6qc1

RnJvbSA2ZGI5MjRlNzBkYWFlMTU1ODQ1YzZiN2RkMGY0NDFkYmZmN2JkNjU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjUgRmViIDIwMTkgMDA6NTI6NDMgLTA2MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gc21iMzogQWRkIHRyYWNlcG9pbnRzIGZvciByZWFkLCB3cml0ZSBhbmQgcXVlcnlfZGlyIGVu
dGVyCgpBbGxvd3MgdHJhY2luZyBiZWdpbiAobm90IGp1c3QgY29tcGxldGlvbikgb2YgcmVhZCwg
d3JpdGUKYW5kIHF1ZXJ5X2RpciB3aGljaCBtYXkgYmUgaGVscGZ1bCBpbiBmaW5kaW5nIHNsb3cg
cmVxdWVzdHMKYW5kIG90aGVyIHRpbWluZyBpbmZvcm1hdGlvbgoKU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgpSZXZpZXdlZC1ieTogUGF2ZWwgU2hp
bG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAx
NSArKysrKysrKysrKysrKysKIGZzL2NpZnMvdHJhY2UuaCAgIHwgIDMgKysrCiAyIGZpbGVzIGNo
YW5nZWQsIDE4IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBi
L2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDk2NWM0YzdlODdmOS4uZWM5YWJlMjkzMjc5IDEwMDY0
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
--0000000000006c21e90582be1f45--
