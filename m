Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2A8C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 22:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79DC20842
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 22:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbMC0iSY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfBYW1U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:27:20 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:44445 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfBYW1U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 17:27:20 -0500
Received: by mail-pg1-f181.google.com with SMTP id j3so5128583pgm.11
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 14:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/Xisd/jqaO42X92M0XRoPwpL3ZRA/KYRxL1QG+fjxzM=;
        b=jbMC0iSYg9+yxxJvkM8t5R+eFfvNJ5+KmhNRX7Pj4r342R+WsS/cEjwnQjjNYA7U1G
         mVISLyB+VML/MyOeBSCR+W0DLbeagYrBpKMCSgpQIPdBg3xSfe1uS0d20s6AMn6Sobn6
         6uxwPcp6HoSuRH+XDWRo1hLTIztDWb04M3TW51Y1krG5cfYutZRG6S926LjUPiPepnn2
         GJZ3LA3B00PKX0fB62EduPo0NM8YeAc5b8PpE6imtPBtarNpmOHX36Nfq+CNbHvl9cwl
         Me0EgE9xZc0+2KGbfUmVhxFHGpH2N/5LLf9UqqVej2+mkQmLK0nNJ+G6hL8fQPjTpDxR
         5Tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/Xisd/jqaO42X92M0XRoPwpL3ZRA/KYRxL1QG+fjxzM=;
        b=QteNkFgJdpabYyWnlSzGP2g6F0HmaUS7JNv/CnAVXX74HfM+ZkVyyHuI+CqrnhIisj
         RpbSzDGKmd3AdJ7XBhw0MdXoTyCFjJd2rABDIZQ7YiV7+7SJexdCH28laCoqzC37/IWd
         Z78fVy5JOrCQYRvTYloLDWjuO7yVU3hknITA05gvppOASo5d2HIbq7sX7glwggxbt9cA
         HnQRnLaa118YHC3vYExL9HRvLsTRU2GdopbwsQFc66K3UgzAhrVmiG/8RwhfjJw0wIjp
         9aHy7QgPjDZ1W/cnvWgH7jZWGz5v4OVIWUQzA9w3KEkAZSlCibmP0SO36A1nb3NHSoOr
         oqvA==
X-Gm-Message-State: AHQUAuaFq+A3b4s7PXJomKPe95xKJEsg/hPAm4AQB3beDv4xygL9O7G+
        dmPl56plbtcDQJW2SSqW0w1uoYwJOAR8gRcmDQ6krOpf
X-Google-Smtp-Source: AHgI3IbIewNCyyHQ9m54p1YmA5YQ/Sdm5PLN+MkS2invkVgc9foNrCd+JL3K0SudWbHXuF6UFCWNijLlqH80ZO1A8bM=
X-Received: by 2002:a63:2c8a:: with SMTP id s132mr21220006pgs.440.1551133638839;
 Mon, 25 Feb 2019 14:27:18 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 16:27:06 -0600
Message-ID: <CAH2r5msOkMhOOSK1838dsWfiNm6ZTGMRQ2m3jVK0ReNP63LT5g@mail.gmail.com>
Subject: [PATCH] dynamic tracing open_enter/done
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008af3430582bf71cf"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008af3430582bf71cf
Content-Type: text/plain; charset="UTF-8"

Sample output (note that they are mostly compounded so fid is not very
meaningful - and set to 0)

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
              ls-1008  [001] .... 97979.221345: smb3_open_enter: xid=8
sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x81
              ls-1008  [001] .... 97979.222446: smb3_open_done: xid=8
sid=0xfab79a42 tid=0x4b599fda fid=0xec26ce8a cr_opts=0x0
des_access=0x81
              ls-1009  [007] .... 97985.278984: smb3_open_enter:
xid=11 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
              ls-1009  [007] .... 97985.280496: smb3_open_done: xid=11
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
              ls-1009  [007] .... 97985.280569: smb3_open_enter:
xid=12 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x81
              ls-1009  [003] .... 97985.281311: smb3_open_err: xid=12
sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x81 rc=-13
            stat-1013  [005] .... 97993.537550: smb3_open_enter:
xid=14 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
            stat-1013  [005] .... 97993.538634: smb3_open_err: xid=14
sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80 rc=-2
           mkdir-1015  [006] .... 97997.445397: smb3_open_enter:
xid=15 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
           mkdir-1015  [006] .... 97997.446442: smb3_open_err: xid=15
sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80 rc=-2
           mkdir-1015  [006] .... 97997.446457: smb3_open_enter:
xid=16 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x1 des_access=0x100
           mkdir-1015  [006] .... 97997.447839: smb3_open_done: xid=16
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x1 des_access=0x100
           mkdir-1015  [006] .... 97997.447852: smb3_open_enter:
xid=16 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
           mkdir-1015  [006] .... 97997.449092: smb3_open_done: xid=16
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
            stat-1017  [006] .... 98002.176448: smb3_open_enter:
xid=17 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
            stat-1017  [006] .... 98002.177836: smb3_open_done: xid=17
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
           touch-1018  [007] .... 98006.350783: smb3_open_enter:
xid=18 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x40
des_access=0x40000080
           touch-1018  [007] .... 98006.351938: smb3_open_done: xid=18
sid=0xfab79a42 tid=0x4b599fda fid=0x25565488 cr_opts=0x40
des_access=0x40000080
           touch-1018  [007] .... 98006.352410: smb3_open_enter:
xid=19 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x100
           touch-1018  [007] .... 98006.353429: smb3_open_done: xid=19
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x100
              rm-1022  [006] .... 98011.406241: smb3_open_enter:
xid=21 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
              rm-1022  [006] .... 98011.407548: smb3_open_done: xid=21
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
              rm-1022  [006] .... 98011.407596: smb3_open_enter:
xid=22 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x201000
des_access=0x10000
              rm-1022  [006] .... 98011.408723: smb3_open_done: xid=22
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x201000
des_access=0x10000
           rmdir-1023  [001] .... 98017.810408: smb3_open_enter:
xid=23 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x0 des_access=0x80
           rmdir-1023  [001] .... 98017.811916: smb3_open_done: xid=23
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x0 des_access=0x80
           rmdir-1023  [001] .... 98017.811934: smb3_open_enter:
xid=24 sid=0xfab79a42 tid=0x4b599fda cr_opts=0x1 des_access=0x10000
           rmdir-1023  [002] .... 98017.813449: smb3_open_done: xid=24
sid=0xfab79a42 tid=0x4b599fda fid=0x0 cr_opts=0x1 des_access=0x10000



-- 
Thanks,

Steve

--0000000000008af3430582bf71cf
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-improve-dynamic-tracing-of-open-and-compounding.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-improve-dynamic-tracing-of-open-and-compounding.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jskwwryq0>
X-Attachment-Id: f_jskwwryq0

RnJvbSBhMjhlOWJmMmViZWM3YTlhYWJjZDk0NDk3MDIyZTVhMzM1YzI4ZjgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjUgRmViIDIwMTkgMTY6MTg6MTggLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBpbXByb3ZlIGR5bmFtaWMgdHJhY2luZyBvZiBvcGVuIGFuZCBjb21wb3VuZGluZwoKQWRk
IGR5bmFtaWMgdHJhY2UgcG9pbnQgZm9yIG9wZW5fZW50ZXIgKGFuZCBta2RpciBlbnRlcikgYW5k
CnJlc3VsdCBvZiBvcGVuIG9uIGNvbXBvdW5kZWQgY2FsbHMuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyaW5vZGUu
YyB8IDEyICsrKysrKysrKysrLQogZnMvY2lmcy9zbWIyb3BzLmMgICB8ICA2ICsrKy0tLQogZnMv
Y2lmcy9zbWIycGR1LmMgICB8IDEwICsrKysrKystLS0KIGZzL2NpZnMvc21iMnByb3RvLmggfCAg
NiArKystLS0KIGZzL2NpZnMvdHJhY2UuaCAgICAgfCA0MSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLQogNSBmaWxlcyBjaGFuZ2VkLCA2NCBpbnNlcnRpb25zKCspLCAx
MSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJpbm9kZS5jIGIvZnMvY2lm
cy9zbWIyaW5vZGUuYwppbmRleCAwMWE3NmJjY2RiOGQuLjgwM2VlNDkwZjdjNyAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWIyaW5vZGUuYworKysgYi9mcy9jaWZzL3NtYjJpbm9kZS5jCkBAIC05MCw3
ICs5MCw3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKIAltZW1zZXQoJm9wZW5faW92LCAwLCBzaXplb2Yob3Blbl9pb3Yp
KTsKIAlycXN0W251bV9ycXN0XS5ycV9pb3YgPSBvcGVuX2lvdjsKIAlycXN0W251bV9ycXN0XS5y
cV9udmVjID0gU01CMl9DUkVBVEVfSU9WX1NJWkU7Ci0JcmMgPSBTTUIyX29wZW5faW5pdCh0Y29u
LCAmcnFzdFtudW1fcnFzdF0sICZvcGxvY2ssICZvcGFybXMsCisJcmMgPSBTTUIyX29wZW5faW5p
dCh4aWQsIHRjb24sICZycXN0W251bV9ycXN0XSwgJm9wbG9jaywgJm9wYXJtcywKIAkJCSAgICB1
dGYxNl9wYXRoKTsKIAlrZnJlZSh1dGYxNl9wYXRoKTsKIAlpZiAocmMpCkBAIC0yMzcsNiArMjM3
LDE2IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAogIGZpbmlzaGVkOgogCVNNQjJfb3Blbl9mcmVlKCZycXN0WzBdKTsK
KwlpZiAocmMpCisJCXRyYWNlX3NtYjNfb3Blbl9lcnIoeGlkLCB0Y29uLT50aWQsIHNlcy0+U3Vp
ZCwKKwkJCQkgICAgb3Bhcm1zLmNyZWF0ZV9vcHRpb25zLAorCQkJCSAgICBvcGFybXMuZGVzaXJl
ZF9hY2Nlc3MsIHJjKTsKKwllbHNlCisJCXRyYWNlX3NtYjNfb3Blbl9kb25lKHhpZCwgMCAvKiBm
aWQgaGFyZCB0byBwYXJzZSBoZXJlICovLAorCQkJCSAgICAgdGNvbi0+dGlkLCBzZXMtPlN1aWQs
CisJCQkJICAgICBvcGFybXMuY3JlYXRlX29wdGlvbnMsCisJCQkJICAgICBvcGFybXMuZGVzaXJl
ZF9hY2Nlc3MpOworCiAJc3dpdGNoIChjb21tYW5kKSB7CiAJY2FzZSBTTUIyX09QX1FVRVJZX0lO
Rk86CiAJCWlmIChyYyA9PSAwKSB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2Zz
L2NpZnMvc21iMm9wcy5jCmluZGV4IDEyNDM0MDdjOTU0Ni4uMzc0NzJmZGVhZmYyIDEwMDY0NAot
LS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMTAyMCw3
ICsxMDIwLDcgQEAgc21iMl9zZXRfZWEoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAlvcGFybXMuZmlkID0gJmZpZDsKIAlvcGFybXMucmVjb25uZWN0ID0g
ZmFsc2U7CiAKLQlyYyA9IFNNQjJfb3Blbl9pbml0KHRjb24sICZycXN0WzBdLCAmb3Bsb2NrLCAm
b3Bhcm1zLCB1dGYxNl9wYXRoKTsKKwlyYyA9IFNNQjJfb3Blbl9pbml0KHhpZCwgdGNvbiwgJnJx
c3RbMF0sICZvcGxvY2ssICZvcGFybXMsIHV0ZjE2X3BhdGgpOwogCWlmIChyYykKIAkJZ290byBz
ZWFfZXhpdDsKIAlzbWIyX3NldF9uZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbMF0pOwpAQCAtMTMw
Niw3ICsxMzA2LDcgQEAgc21iMl9pb2N0bF9xdWVyeV9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4
aWQsCiAJb3Bhcm1zLmZpZCA9ICZmaWQ7CiAJb3Bhcm1zLnJlY29ubmVjdCA9IGZhbHNlOwogCi0J
cmMgPSBTTUIyX29wZW5faW5pdCh0Y29uLCAmcnFzdFswXSwgJm9wbG9jaywgJm9wYXJtcywgcGF0
aCk7CisJcmMgPSBTTUIyX29wZW5faW5pdCh4aWQsIHRjb24sICZycXN0WzBdLCAmb3Bsb2NrLCAm
b3Bhcm1zLCBwYXRoKTsKIAlpZiAocmMpCiAJCWdvdG8gaXFpbmZfZXhpdDsKIAlzbWIyX3NldF9u
ZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbMF0pOwpAQCAtMTk3Miw3ICsxOTcyLDcgQEAgc21iMl9x
dWVyeV9pbmZvX2NvbXBvdW5kKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rj
b24gKnRjb24sCiAJb3Bhcm1zLmZpZCA9ICZmaWQ7CiAJb3Bhcm1zLnJlY29ubmVjdCA9IGZhbHNl
OwogCi0JcmMgPSBTTUIyX29wZW5faW5pdCh0Y29uLCAmcnFzdFswXSwgJm9wbG9jaywgJm9wYXJt
cywgdXRmMTZfcGF0aCk7CisJcmMgPSBTTUIyX29wZW5faW5pdCh4aWQsIHRjb24sICZycXN0WzBd
LCAmb3Bsb2NrLCAmb3Bhcm1zLCB1dGYxNl9wYXRoKTsKIAlpZiAocmMpCiAJCWdvdG8gcWljX2V4
aXQ7CiAJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0WzBdKTsKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggYjc3NGI0M2VkZmJk
Li5lNmZmNTE1ZmI0Y2UgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2Np
ZnMvc21iMnBkdS5jCkBAIC0yMTk2LDYgKzIxOTYsOCBAQCBpbnQgc21iMzExX3Bvc2l4X21rZGly
KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBpbm9kZSAqaW5vZGUsCiAJcnFzdC5ycV9p
b3YgPSBpb3Y7CiAJcnFzdC5ycV9udmVjID0gbl9pb3Y7CiAKKwl0cmFjZV9zbWIzX3Bvc2l4X21r
ZGlyX2VudGVyKHhpZCwgdGNvbi0+dGlkLCBzZXMtPlN1aWQsIENSRUFURV9OT1RfRklMRSwKKwkJ
CQkgICAgRklMRV9XUklURV9BVFRSSUJVVEVTKTsKIAkvKiByZXNvdXJjZSAjNDogcmVzcG9uc2Ug
YnVmZmVyICovCiAJcmMgPSBjaWZzX3NlbmRfcmVjdih4aWQsIHNlcywgJnJxc3QsICZyZXNwX2J1
ZnR5cGUsIGZsYWdzLCAmcnNwX2lvdik7CiAJaWYgKHJjKSB7CkBAIC0yMjI2LDcgKzIyMjgsOCBA
QCBpbnQgc21iMzExX3Bvc2l4X21rZGlyKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBp
bm9kZSAqaW5vZGUsCiB9CiAKIGludAotU01CMl9vcGVuX2luaXQoc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwgc3RydWN0IHNtYl9ycXN0ICpycXN0LCBfX3U4ICpvcGxvY2ssCitTTUIyX29wZW5faW5p
dChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAorCSAgICAg
ICBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsIF9fdTggKm9wbG9jaywKIAkgICAgICAgc3RydWN0IGNp
ZnNfb3Blbl9wYXJtcyAqb3Bhcm1zLCBfX2xlMTYgKnBhdGgpCiB7CiAJc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqc2VydmVyID0gdGNvbi0+c2VzLT5zZXJ2ZXI7CkBAIC0yMzU5LDcgKzIzNjIsOCBA
QCBTTUIyX29wZW5faW5pdChzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3Qgc21iX3Jxc3Qg
KnJxc3QsIF9fdTggKm9wbG9jaywKIAkJCXJldHVybiByYzsKIAl9CiAKLQorCXRyYWNlX3NtYjNf
b3Blbl9lbnRlcih4aWQsIHRjb24tPnRpZCwgdGNvbi0+c2VzLT5TdWlkLAorCQkJb3Bhcm1zLT5j
cmVhdGVfb3B0aW9ucywgb3Bhcm1zLT5kZXNpcmVkX2FjY2Vzcyk7CiAJcnFzdC0+cnFfbnZlYyA9
IG5faW92OwogCXJldHVybiAwOwogfQpAQCAtMjQxMCw3ICsyNDE0LDcgQEAgU01CMl9vcGVuKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX29wZW5fcGFybXMgKm9wYXJtcywgX19s
ZTE2ICpwYXRoLAogCXJxc3QucnFfaW92ID0gaW92OwogCXJxc3QucnFfbnZlYyA9IFNNQjJfQ1JF
QVRFX0lPVl9TSVpFOwogCi0JcmMgPSBTTUIyX29wZW5faW5pdCh0Y29uLCAmcnFzdCwgb3Bsb2Nr
LCBvcGFybXMsIHBhdGgpOworCXJjID0gU01CMl9vcGVuX2luaXQoeGlkLCB0Y29uLCAmcnFzdCwg
b3Bsb2NrLCBvcGFybXMsIHBhdGgpOwogCWlmIChyYykKIAkJZ290byBjcmVhdF9leGl0OwogCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIycHJvdG8uaAppbmRl
eCA4NzczM2IyN2E2NWYuLjFlNWJhNmE3OTNhZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycHJv
dG8uaAorKysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC0xMzYsOSArMTM2LDkgQEAgZXh0ZXJu
IGludCBTTUIyX29wZW4oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfb3Blbl9w
YXJtcyAqb3Bhcm1zLAogCQkgICAgIF9fbGUxNiAqcGF0aCwgX191OCAqb3Bsb2NrLAogCQkgICAg
IHN0cnVjdCBzbWIyX2ZpbGVfYWxsX2luZm8gKmJ1ZiwKIAkJICAgICBzdHJ1Y3Qga3ZlYyAqZXJy
X2lvdiwgaW50ICpyZXNwX2J1ZnR5cGUpOwotZXh0ZXJuIGludCBTTUIyX29wZW5faW5pdChzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3QsCi0JCQkgIF9fdTggKm9w
bG9jaywgc3RydWN0IGNpZnNfb3Blbl9wYXJtcyAqb3Bhcm1zLAotCQkJICBfX2xlMTYgKnBhdGgp
OworZXh0ZXJuIGludCBTTUIyX29wZW5faW5pdChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAorCQkgICAgIHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwgX191OCAq
b3Bsb2NrLAorCQkgICAgIHN0cnVjdCBjaWZzX29wZW5fcGFybXMgKm9wYXJtcywgX19sZTE2ICpw
YXRoKTsKIGV4dGVybiB2b2lkIFNNQjJfb3Blbl9mcmVlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCk7
CiBleHRlcm4gaW50IFNNQjJfaW9jdGwoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJICAgICB1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9m
aWQsIHUzMiBvcGNvZGUsCmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3Ry
YWNlLmgKaW5kZXggNjYwMTc2ZTM0ZGRlLi5iNjM1MmI2OGYxOGIgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvdHJhY2UuaAorKysgYi9mcy9jaWZzL3RyYWNlLmgKQEAgLTQxMSw4ICs0MTEsNDcgQEAgREVG
SU5FX1NNQjNfVENPTl9FVkVOVCh0Y29uKTsKIAogCiAvKgotICogRm9yIHNtYjIvc21iMyBvcGVu
IGNhbGwKKyAqIEZvciBzbWIyL3NtYjMgb3BlbiAoaW5jbHVkaW5nIGNyZWF0ZSBhbmQgbWtkaXIp
IGNhbGxzCiAgKi8KKworREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX29wZW5fZW50ZXJfY2xhc3Ms
CisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNp
ZCwKKwkJaW50CWNyZWF0ZV9vcHRpb25zLAorCQlpbnQJZGVzaXJlZF9hY2Nlc3MpLAorCVRQX0FS
R1MoeGlkLCB0aWQsIHNlc2lkLCBjcmVhdGVfb3B0aW9ucywgZGVzaXJlZF9hY2Nlc3MpLAorCVRQ
X1NUUlVDVF9fZW50cnkoCisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQo
X191MzIsIHRpZCkKKwkJX19maWVsZChfX3U2NCwgc2VzaWQpCisJCV9fZmllbGQoaW50LCBjcmVh
dGVfb3B0aW9ucykKKwkJX19maWVsZChpbnQsIGRlc2lyZWRfYWNjZXNzKQorCSksCisJVFBfZmFz
dF9hc3NpZ24oCisJCV9fZW50cnktPnhpZCA9IHhpZDsKKwkJX19lbnRyeS0+dGlkID0gdGlkOwor
CQlfX2VudHJ5LT5zZXNpZCA9IHNlc2lkOworCQlfX2VudHJ5LT5jcmVhdGVfb3B0aW9ucyA9IGNy
ZWF0ZV9vcHRpb25zOworCQlfX2VudHJ5LT5kZXNpcmVkX2FjY2VzcyA9IGRlc2lyZWRfYWNjZXNz
OworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgc2lkPTB4JWxseCB0aWQ9MHgleCBjcl9vcHRzPTB4
JXggZGVzX2FjY2Vzcz0weCV4IiwKKwkJX19lbnRyeS0+eGlkLCBfX2VudHJ5LT5zZXNpZCwgX19l
bnRyeS0+dGlkLAorCQlfX2VudHJ5LT5jcmVhdGVfb3B0aW9ucywgX19lbnRyeS0+ZGVzaXJlZF9h
Y2Nlc3MpCispCisKKyNkZWZpbmUgREVGSU5FX1NNQjNfT1BFTl9FTlRFUl9FVkVOVChuYW1lKSAg
ICAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfb3Blbl9lbnRlcl9jbGFzcywgc21iM18jI25hbWUs
ICBcCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJ
X191NjQJc2VzaWQsCQkJXAorCQlpbnQJY3JlYXRlX29wdGlvbnMsCQlcCisJCWludAlkZXNpcmVk
X2FjY2VzcyksCVwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgY3JlYXRlX29wdGlvbnMsIGRl
c2lyZWRfYWNjZXNzKSkKKworREVGSU5FX1NNQjNfT1BFTl9FTlRFUl9FVkVOVChvcGVuX2VudGVy
KTsKK0RFRklORV9TTUIzX09QRU5fRU5URVJfRVZFTlQocG9zaXhfbWtkaXJfZW50ZXIpOworCiBE
RUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfb3Blbl9lcnJfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWdu
ZWQgaW50IHhpZCwKIAkJX191MzIJdGlkLAotLSAKMi4xNy4xCgo=
--0000000000008af3430582bf71cf--
