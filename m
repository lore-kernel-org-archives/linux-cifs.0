Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF69C433FE
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Oct 2022 16:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJAQzf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 12:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJAQzL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 12:55:11 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEE6264A0
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 09:54:55 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id bi53so3692635vkb.12
        for <linux-cifs@vger.kernel.org>; Sat, 01 Oct 2022 09:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=IS18AKkvs6Ni+OLfS43Y4FnjRvwNRzH8XXbVwq68aoA=;
        b=TsYJAdoRgM4M/jM/6/oohzhNg5OJ0csO7MG9B6vYWTJZcTWd+VmmNR37Ri4r9Us+Tc
         Gy1D0zOSey9o4lkxHz1P/wuEo81O7sEIWy5jyaErkx3Glq1tQ8NIAF2aMEZXueee4xRg
         XJSxaOWuz5nTMtsK5gB+OXcKh2+EK79TLf/p+E8jYrzseTQsmEPvw187jp0LEseRo88U
         pdoXXTlRZpsIaqiSUXbbiGqYfUPOrCHjlvydDH58vgzDgUOy1xqjzfgcnUH/sgYmSJOL
         FdWKx7Fupl/LP2owpT6KIS0dare8tVfeNgxmiC6tPBLGVk5CoRkArpNAMBD78KvpZLrm
         XIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=IS18AKkvs6Ni+OLfS43Y4FnjRvwNRzH8XXbVwq68aoA=;
        b=g66Xf7QVDBsCSnSz+bKSmhfT0nclvbx2Ma0EEdg9rV1sTDjyc30VxPF8XXkZ8dmPuw
         xrCCsnnhiTv1y2m1OuvsACh1Gd5r4akxPvn8YAPhRA8yhKGN/sH80vAexeJ5pqepDNZO
         t47X5L7XqQ1ZrOiNVoPn3pNvMhcVRJAuQyEBEXcGLOYaGyIBaR2i27bkT1WVkq7XK/yj
         WcEcS2w9qdcnysJk//Txo0JnrO7R28fqI0hHz9cNFb4efqnNZr/UHpeoK6KpLWbM8kXV
         a+k+LCngms9ick5K6L0zNNZdr1HFhj5tEpz7j718O4R1lkd1gP5ihhrvyO5yfD0+/4j9
         NPsw==
X-Gm-Message-State: ACrzQf3uPyo/Xq8wxaieDsTeJxJ7uPquvYFRT8JSkbHq/mpVrppE3mvm
        poqcngk0Ef3tMUnG+ECaPB4+X1GT/13z4J+lCrd74Cs4yxM=
X-Google-Smtp-Source: AMsMyM66PwdUyNYg0aQe6ynKxht23H2THhvyK4vZB9qjMsiuLWbCvF9lD7HjKRIxpYFYkbJr2CkDpewOc4716Qul0cE=
X-Received: by 2002:ac5:cb0a:0:b0:3a2:2fa3:87d8 with SMTP id
 r10-20020ac5cb0a000000b003a22fa387d8mr6352562vkl.3.1664643294079; Sat, 01 Oct
 2022 09:54:54 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 Oct 2022 11:54:43 -0500
Message-ID: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
Subject: [PATCH][smb3 client] log less confusing message on multichannel
 mounts to Samba when no interfaces returned
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000038ecb905e9fbf87c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000038ecb905e9fbf87c
Content-Type: text/plain; charset="UTF-8"

Some servers can return an empty network interface list so, unless
multichannel is requested, no need to log an error for this, and
when multichannel is requested on mount but no interfaces, log
something less confusing.  For this case change
   parse_server_interfaces: malformed interface info
to
   empty network interface list returned by server

Cc: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

See attached patch

-- 
Thanks,

Steve

--00000000000038ecb905e9fbf87c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-log-confusing-message-when-server-return.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-log-confusing-message-when-server-return.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l8q5m2il0>
X-Attachment-Id: f_l8q5m2il0

RnJvbSA5NmEwYWYyYzUwYWM1ZTQ1NGQxZTg5NmE5ODc3YTUxZWQxMDAzMTJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMSBPY3QgMjAyMiAxMTo0NDowOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGRvIG5vdCBsb2cgY29uZnVzaW5nIG1lc3NhZ2Ugd2hlbiBzZXJ2ZXIgcmV0dXJucyBubwog
bmV0d29yayBpbnRlcmZhY2VzCgpTb21lIHNlcnZlcnMgY2FuIHJldHVybiBhbiBlbXB0eSBuZXR3
b3JrIGludGVyZmFjZSBsaXN0IHNvLCB1bmxlc3MKbXVsdGljaGFubmVsIGlzIHJlcXVlc3RlZCwg
bm8gbmVlZCB0byBsb2cgYW4gZXJyb3IgZm9yIHRoaXMsIGFuZAp3aGVuIG11bHRpY2hhbm5lbCBp
cyByZXF1ZXN0ZWQgb24gbW91bnQgYnV0IG5vIGludGVyZmFjZXMsIGxvZwpzb21ldGhpbmcgbGVz
cyBjb25mdXNpbmcuICBGb3IgdGhpcyBjYXNlIGNoYW5nZQogICBwYXJzZV9zZXJ2ZXJfaW50ZXJm
YWNlczogbWFsZm9ybWVkIGludGVyZmFjZSBpbmZvCnRvCiAgIGVtcHR5IG5ldHdvcmsgaW50ZXJm
YWNlIGxpc3QgcmV0dXJuZWQgYnkgc2VydmVyCgpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9jaWZzL3NtYjJvcHMuYyB8IDExICsrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTEg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9z
bWIyb3BzLmMKaW5kZXggNWIwNjAwOTM5MjA2Li44OGNiZjI4OTBmNmEgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC01NDMsNiArNTQzLDE3
IEBAIHBhcnNlX3NlcnZlcl9pbnRlcmZhY2VzKHN0cnVjdCBuZXR3b3JrX2ludGVyZmFjZV9pbmZv
X2lvY3RsX3JzcCAqYnVmLAogCX0KIAlzcGluX3VubG9jaygmc2VzLT5pZmFjZV9sb2NrKTsKIAor
CS8qCisJICogU2FtYmEgc2VydmVyIGUuZy4gY2FuIHJldHVybiBhbiBlbXB0eSBpbnRlcmZhY2Ug
bGlzdCBpbiBzb21lIGNhc2VzLAorCSAqIHdoaWNoIHdvdWxkIG9ubHkgYmUgYSBwcm9ibGVtIGlm
IHdlIHdlcmUgcmVxdWVzdGluZyBtdWx0aWNoYW5uZWwKKwkgKi8KKwlpZiAoYnl0ZXNfbGVmdCA9
PSAwKSB7CisJCWlmIChzZXMtPmNoYW5fbWF4ID4gMSkKKwkJCWNpZnNfZGJnKFZGUywgImVtcHR5
IG5ldHdvcmsgaW50ZXJmYWNlIGxpc3QgcmV0dXJuZWQgYnkgc2VydmVyXG4iKTsKKwkJcmMgPSAt
RUlOVkFMOworCQlnb3RvIG91dDsKKwl9CisKIAl3aGlsZSAoYnl0ZXNfbGVmdCA+PSBzaXplb2Yo
KnApKSB7CiAJCW1lbXNldCgmdG1wX2lmYWNlLCAwLCBzaXplb2YodG1wX2lmYWNlKSk7CiAJCXRt
cF9pZmFjZS5zcGVlZCA9IGxlNjRfdG9fY3B1KHAtPkxpbmtTcGVlZCk7Ci0tIAoyLjM0LjEKCg==
--00000000000038ecb905e9fbf87c--
