Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E045C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 01:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 049E1218CD
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 01:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oJUBcVCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfB0BOw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Feb 2019 20:14:52 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:39250 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729598AbfB0BOv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Feb 2019 20:14:51 -0500
Received: by mail-pg1-f176.google.com with SMTP id h8so6560477pgp.6
        for <linux-cifs@vger.kernel.org>; Tue, 26 Feb 2019 17:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OM/0csad5bkztAf7K9zzkCAHVvjMK1m17t/0RLvpaHY=;
        b=oJUBcVCeYi/CiDLCu5WQbE9M2ifSQ8IoqUU3PnbzeOusW6Jv2GrO1FLqvd06EQilfl
         +4hHUkwaDtxac86we/vnXW5H+Qop1gGbblDsUfXySoil6eNO9bO5jOcDBLSqp+QOo6e/
         SW0YQrEJik5ZswANSjivAKkwpdA6MhCOfJ90fenizfx5V8xBcbrF5Y4f2wwe6frjlhao
         PeMT4/FhMDAGpssNoqaUFx5vbeZBuSgpcss6nXC6HahTUxuqiAHCoBUirSUcFnT+tkmQ
         qG74ePM/O5KFm9ZC/gqY7G08qMfprKv0S1EabxZ/vFiNJausc/W/7N5l6syAVivgTyJ8
         qBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OM/0csad5bkztAf7K9zzkCAHVvjMK1m17t/0RLvpaHY=;
        b=rilERdTPPHNp/+JMDsw/LTuJoGI3yVM1cf8eusURsmN/GAv7wWCjF55VTuqhjaOKRs
         tRlE131jOGf5uFBDGQGrTUEW75o/7Jg6duncESF4sfs0HELIW6iRafZkYoqxaL5rnYEn
         cIS/Nh6rsPso+jS6+3HXuRATWUBh4sqM/NHKK/H5/09C7pMZzUQ2AuoWaNPVrM5mV4DH
         gILZ/Bmp4ulEhfKy9ghZYXux4abgURCvY7oqHfrmumpQr8lo9yA/K6xtwhoqPRRhW3JJ
         FS8E0R7C3Nw44tTJbjlHbeFjOihTj9Rpgn7ued3zdHeFPMhJqmdaT7CQFWoMp2rVqsLy
         JDZw==
X-Gm-Message-State: AHQUAuYXl34mtkryA7WpOWzyAPr3TM9I1UgvpGMKGe1ObbrA6mVk1jX/
        kdCzYnXUfoxdGZxX1HR4DmEahKQnRW5rOXAeP+aeMKGN
X-Google-Smtp-Source: AHgI3IauDsvVKbwCK67oIRwyYy+EsQkihe3Cec89JbqbBhUV3UTAd/L123Ct5XB52Iu6K3dpMaVGzONhCLYFArhm8Lc=
X-Received: by 2002:a63:8743:: with SMTP id i64mr342793pge.69.1551230089959;
 Tue, 26 Feb 2019 17:14:49 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Feb 2019 19:14:37 -0600
Message-ID: <CAH2r5msgdyPZE077R5hatgiFamWa_M9fAZ+JbgsAZQxk-ki9kw@mail.gmail.com>
Subject: [PATCH] Improve dynamic tracing of open and posix mkdir
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007a3a8f0582d5e66d"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007a3a8f0582d5e66d
Content-Type: text/plain; charset="UTF-8"

Updated to limit it to open and mkdir (not compounded operations) with
feedback from Pavel.

Sample output

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
           mkdir-19287 [002] .... 17897.136632:
smb3_posix_mkdir_enter: xid=8 sid=0xd29a497f tid=0xbc99b185
cr_opts=0x1 des_access=0x100
           mkdir-19287 [002] .... 17897.141109: smb3_posix_mkdir_done:
xid=8 sid=0xd29a497f tid=0xbc99b185 fid=0x3d0ea06a cr_opts=0x1
des_access=0x100
           touch-19289 [002] .... 17910.203266: smb3_open_enter:
xid=12 sid=0xd29a497f tid=0xbc99b185 cr_opts=0x40
des_access=0x40000080
           touch-19289 [002] .... 17910.214443: smb3_open_done: xid=12
sid=0xd29a497f tid=0xbc99b185 fid=0x74770519 cr_opts=0x40
des_access=0x40000080



-- 
Thanks,

Steve

--0000000000007a3a8f0582d5e66d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-improve-dynamic-tracing-of-open-and-posix-mkdir.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-improve-dynamic-tracing-of-open-and-posix-mkdir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsmibqps0>
X-Attachment-Id: f_jsmibqps0

RnJvbSA2ZjA5ZDNmMDNlYzM0OTBhOTY0YjllZjY5ODNjNzlmMzg5Y2QwZThjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjYgRmViIDIwMTkgMTk6MDg6MTIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBpbXByb3ZlIGR5bmFtaWMgdHJhY2luZyBvZiBvcGVuIGFuZCBwb3NpeCBta2RpcgoKQWRk
IGR5bmFtaWMgdHJhY2UgcG9pbnQgZm9yIG9wZW5fZW50ZXIgKGFuZCBta2RpciBlbnRlcikKClNp
Z25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBm
cy9jaWZzL3NtYjJwZHUuYyB8ICA1ICsrKysrCiBmcy9jaWZzL3RyYWNlLmggICB8IDQxICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystCiAyIGZpbGVzIGNoYW5nZWQsIDQ1
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJw
ZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGI3NzRiNDNlZGZiZC4uNWUzNGE3YjU0ZDFl
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpA
QCAtMjE5Niw2ICsyMTk2LDggQEAgaW50IHNtYjMxMV9wb3NpeF9ta2Rpcihjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLAogCXJxc3QucnFfaW92ID0gaW92OwogCXJx
c3QucnFfbnZlYyA9IG5faW92OwogCisJdHJhY2Vfc21iM19wb3NpeF9ta2Rpcl9lbnRlcih4aWQs
IHRjb24tPnRpZCwgc2VzLT5TdWlkLCBDUkVBVEVfTk9UX0ZJTEUsCisJCQkJICAgIEZJTEVfV1JJ
VEVfQVRUUklCVVRFUyk7CiAJLyogcmVzb3VyY2UgIzQ6IHJlc3BvbnNlIGJ1ZmZlciAqLwogCXJj
ID0gY2lmc19zZW5kX3JlY3YoeGlkLCBzZXMsICZycXN0LCAmcmVzcF9idWZ0eXBlLCBmbGFncywg
JnJzcF9pb3YpOwogCWlmIChyYykgewpAQCAtMjQxNCw2ICsyNDE2LDkgQEAgU01CMl9vcGVuKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX29wZW5fcGFybXMgKm9wYXJtcywgX19s
ZTE2ICpwYXRoLAogCWlmIChyYykKIAkJZ290byBjcmVhdF9leGl0OwogCisJdHJhY2Vfc21iM19v
cGVuX2VudGVyKHhpZCwgdGNvbi0+dGlkLCB0Y29uLT5zZXMtPlN1aWQsCisJCW9wYXJtcy0+Y3Jl
YXRlX29wdGlvbnMsIG9wYXJtcy0+ZGVzaXJlZF9hY2Nlc3MpOworCiAJcmMgPSBjaWZzX3NlbmRf
cmVjdih4aWQsIHNlcywgJnJxc3QsICZyZXNwX2J1ZnR5cGUsIGZsYWdzLAogCQkJICAgICZyc3Bf
aW92KTsKIAlyc3AgPSAoc3RydWN0IHNtYjJfY3JlYXRlX3JzcCAqKXJzcF9pb3YuaW92X2Jhc2U7
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgKaW5kZXggNjYw
MTc2ZTM0ZGRlLi5iNjM1MmI2OGYxOGIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhY2UuaAorKysg
Yi9mcy9jaWZzL3RyYWNlLmgKQEAgLTQxMSw4ICs0MTEsNDcgQEAgREVGSU5FX1NNQjNfVENPTl9F
VkVOVCh0Y29uKTsKIAogCiAvKgotICogRm9yIHNtYjIvc21iMyBvcGVuIGNhbGwKKyAqIEZvciBz
bWIyL3NtYjMgb3BlbiAoaW5jbHVkaW5nIGNyZWF0ZSBhbmQgbWtkaXIpIGNhbGxzCiAgKi8KKwor
REVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX29wZW5fZW50ZXJfY2xhc3MsCisJVFBfUFJPVE8odW5z
aWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNpZCwKKwkJaW50CWNyZWF0
ZV9vcHRpb25zLAorCQlpbnQJZGVzaXJlZF9hY2Nlc3MpLAorCVRQX0FSR1MoeGlkLCB0aWQsIHNl
c2lkLCBjcmVhdGVfb3B0aW9ucywgZGVzaXJlZF9hY2Nlc3MpLAorCVRQX1NUUlVDVF9fZW50cnko
CisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkKKwkJ
X19maWVsZChfX3U2NCwgc2VzaWQpCisJCV9fZmllbGQoaW50LCBjcmVhdGVfb3B0aW9ucykKKwkJ
X19maWVsZChpbnQsIGRlc2lyZWRfYWNjZXNzKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9f
ZW50cnktPnhpZCA9IHhpZDsKKwkJX19lbnRyeS0+dGlkID0gdGlkOworCQlfX2VudHJ5LT5zZXNp
ZCA9IHNlc2lkOworCQlfX2VudHJ5LT5jcmVhdGVfb3B0aW9ucyA9IGNyZWF0ZV9vcHRpb25zOwor
CQlfX2VudHJ5LT5kZXNpcmVkX2FjY2VzcyA9IGRlc2lyZWRfYWNjZXNzOworCSksCisJVFBfcHJp
bnRrKCJ4aWQ9JXUgc2lkPTB4JWxseCB0aWQ9MHgleCBjcl9vcHRzPTB4JXggZGVzX2FjY2Vzcz0w
eCV4IiwKKwkJX19lbnRyeS0+eGlkLCBfX2VudHJ5LT5zZXNpZCwgX19lbnRyeS0+dGlkLAorCQlf
X2VudHJ5LT5jcmVhdGVfb3B0aW9ucywgX19lbnRyeS0+ZGVzaXJlZF9hY2Nlc3MpCispCisKKyNk
ZWZpbmUgREVGSU5FX1NNQjNfT1BFTl9FTlRFUl9FVkVOVChuYW1lKSAgICAgICAgXAorREVGSU5F
X0VWRU5UKHNtYjNfb3Blbl9lbnRlcl9jbGFzcywgc21iM18jI25hbWUsICBcCisJVFBfUFJPVE8o
dW5zaWduZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJX191NjQJc2VzaWQsCQkJ
XAorCQlpbnQJY3JlYXRlX29wdGlvbnMsCQlcCisJCWludAlkZXNpcmVkX2FjY2VzcyksCVwKKwlU
UF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgY3JlYXRlX29wdGlvbnMsIGRlc2lyZWRfYWNjZXNzKSkK
KworREVGSU5FX1NNQjNfT1BFTl9FTlRFUl9FVkVOVChvcGVuX2VudGVyKTsKK0RFRklORV9TTUIz
X09QRU5fRU5URVJfRVZFTlQocG9zaXhfbWtkaXJfZW50ZXIpOworCiBERUNMQVJFX0VWRU5UX0NM
QVNTKHNtYjNfb3Blbl9lcnJfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKIAkJ
X191MzIJdGlkLAotLSAKMi4xNy4xCgo=
--0000000000007a3a8f0582d5e66d--
