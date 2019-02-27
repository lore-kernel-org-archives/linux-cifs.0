Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86D1C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 04:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78AA320C01
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 04:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ayNNLhoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfB0EFd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Feb 2019 23:05:33 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:37466 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbfB0EFd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Feb 2019 23:05:33 -0500
Received: by mail-pg1-f169.google.com with SMTP id q206so7271924pgq.4
        for <linux-cifs@vger.kernel.org>; Tue, 26 Feb 2019 20:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JlU7JqL3P1dCdEx0xNYbJGQJNr5OwAZtZOUxMsyljwc=;
        b=ayNNLhoUtLZNfTQyh2yAPBpcfdK9HO8AMz8xSkFb9T3KUq4zBGmt2+vKdwofxaECA9
         ag5rIyfGeUNY+aK1Ipvub7ZeEWrgvOwn/6gDUI3qusDUAUbX3eNgeqW6w5txu8Ent2/u
         2wFZxKPUG5xGztuGYIi1RBs9+PR8uEOlinioeXdkaQXYhCJ+kfDu72TYPcnSf3To1/F9
         4QMY6/4HcqsnRh+qGwe46aMPq+c2Y1AwmqvMa6WBcQRkGdoINMqxDLQpmgcuoqCZF2tb
         fET7k34IvmZQ1kDOAXC5usjCHCGKgx45wGyhSZ6pU2ZWdAMZHGn25Hyn4TKFWZIxVfGI
         e+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JlU7JqL3P1dCdEx0xNYbJGQJNr5OwAZtZOUxMsyljwc=;
        b=NmD8iHGBx04EifyK9eZDm0GwI8OUyMyt3Cfa1JUIs2KdLUPgZZZqlIt+pl5XnmUvNH
         sLaB9VoO6Z7Q8fHgfMsYxqbJLdqpvuZ6dqMbxtqzrcXn3z73TU1mPoBel0sIODLEuNLL
         jBEM+tYPeGAPuZBXk/2a03KFBlxP0sWC3z6BakRksygt8hY7kqd3vwJinDv8JQgU5VKh
         lyw/x4Sh8gyaWWVICGidqSeZndIRVRrLGrOQaDnkPgxn/PjfxaXLorDnb8XNbAfOwCey
         EPkmWXbzaq2nzPmoC3PGlYgas91TBJl1MA+pvTYvsXwqOfXcSGzLhsS0Lrh9u7zRN8Sc
         vNUw==
X-Gm-Message-State: AHQUAuYeiUGgNPRMSlBMGyml3GiGrdxLxwCTyGcvwEdHxU6xpmdfBwPM
        RNt+Nz8W/y17k3OUxvfqUsfPMRLbUTLKVJYGTj0/GsIu
X-Google-Smtp-Source: AHgI3IZLz6yRcsMJCLHNy/vB/2c60B5wSWaPXHvXqXDy0n7zM2P0rHKfmJ8Gwre9yDgMg3s2YPBhMiledq9zuZLkjZY=
X-Received: by 2002:aa7:8d42:: with SMTP id s2mr11057525pfe.116.1551240331838;
 Tue, 26 Feb 2019 20:05:31 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Feb 2019 22:05:19 -0600
Message-ID: <CAH2r5mt3CWn08J-iS8qQEN5LukVSCO5QUvYoFfqkUP-+Ynn59A@mail.gmail.com>
Subject: [PATCH] smb3: add dynamic trace point for query_info_enter/done
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000f0eaa10582d8484a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f0eaa10582d8484a
Content-Type: text/plain; charset="UTF-8"

Adds dynamic trace points for the query_info_enter
and query_info_done (no error) case.  We only had one on query_info
errors in existing code.  These two tracepoints are for the
non-compounded query_info paths.

Sample output (after doing: trace-cmd record -e smb3_query_info*)

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
              ls-24140 [001] .... 27811.866068: smb3_query_info_enter:
xid=7 sid=0xd2d00587 tid=0xb5441939 fid=0xcf082bac class=18 type=0x1
              ls-24140 [001] .... 27811.867656: smb3_query_info_done:
xid=7 sid=0xd2d00587 tid=0xb5441939 fid=0xcf082bac class=18 type=0x1
      getcifsacl-24149 [005] .... 27854.759873: smb3_query_info_enter:
xid=15 sid=0xd2d00587 tid=0xb5441939 fid=0x99896e72 class=0 type=0x3
      getcifsacl-24149 [005] .... 27854.761730: smb3_query_info_done:
xid=15 sid=0xd2d00587 tid=0xb5441939 fid=0x99896e72 class=0 type=0x3


-- 
Thanks,

Steve

--000000000000f0eaa10582d8484a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-trace-point-for-query_info_enter-do.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-point-for-query_info_enter-do.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsmoflf40>
X-Attachment-Id: f_jsmoflf40

RnJvbSA2NzhlNDVjZGUxNmJmYTBjNzljYjJlYzc5ODA3MjA1MGRlOWZjNDhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjYgRmViIDIwMTkgMjE6NTg6MzAgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZSBwb2ludCBmb3IgcXVlcnlfaW5mb19lbnRlci9kb25lCgpB
ZGRzIGR5bmFtaWMgdHJhY2UgcG9pbnRzIGZvciB0aGUgcXVlcnlfaW5mb19lbnRlcgphbmQgcXVl
cnlfaW5mb19kb25lIChubyBlcnJvcikgY2FzZS4gIFdlIG9ubHkgaGFkIG9uZQpleGlzdGluZyB0
cmFjZSBwb2ludCByZWxhdGVkIHRvIHRoaXMgd2hpY2ggd2FzIG9uIHF1ZXJ5X2luZm8KZXJyb3Jz
LiAgTm90ZSB0aGF0IHRoZXNlIHR3byBuZXcgdHJhY2Vwb2ludHMgYXJlIGZvciB0aGUKbm9uLWNv
bXBvdW5kZWQgcXVlcnlfaW5mbyBwYXRocy4KClNhbXBsZSBvdXRwdXQgKGZyb206IHRyYWNlLWNt
ZCByZWNvcmQgLWUgc21iM19xdWVyeV9pbmZvKikKCiAgICAgICAgICBscy0yNDE0MCBbMDAxXSAu
Li4uIDI3ODExLjg2NjA2ODogc21iM19xdWVyeV9pbmZvX2VudGVyOiB4aWQ9NyBzaWQ9MHhkMmQw
MDU4NyB0aWQ9MHhiNTQ0MTkzOSBmaWQ9MHhjZjA4MmJhYyBjbGFzcz0xOCB0eXBlPTB4MQogICAg
ICAgICAgbHMtMjQxNDAgWzAwMV0gLi4uLiAyNzgxMS44Njc2NTY6IHNtYjNfcXVlcnlfaW5mb19k
b25lOiB4aWQ9NyBzaWQ9MHhkMmQwMDU4NyB0aWQ9MHhiNTQ0MTkzOSBmaWQ9MHhjZjA4MmJhYyBj
bGFzcz0xOCB0eXBlPTB4MQogIGdldGNpZnNhY2wtMjQxNDkgWzAwNV0gLi4uLiAyNzg1NC43NTk4
NzM6IHNtYjNfcXVlcnlfaW5mb19lbnRlcjogeGlkPTE1IHNpZD0weGQyZDAwNTg3IHRpZD0weGI1
NDQxOTM5IGZpZD0weDk5ODk2ZTcyIGNsYXNzPTAgdHlwZT0weDMKICBnZXRjaWZzYWNsLTI0MTQ5
IFswMDVdIC4uLi4gMjc4NTQuNzYxNzMwOiBzbWIzX3F1ZXJ5X2luZm9fZG9uZTogeGlkPTE1IHNp
ZD0weGQyZDAwNTg3IHRpZD0weGI1NDQxOTM5IGZpZD0weDk5ODk2ZTcyIGNsYXNzPTAgdHlwZT0w
eDMKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8ICA2ICsrKysrKwogZnMvY2lmcy90cmFjZS5oICAgfCA0
MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hh
bmdlZCwgNDggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIv
ZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggNWUzNGE3YjU0ZDFlLi43MzMwMjE1NjYzNTYgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yODY4
LDYgKzI4NjgsOSBAQCBxdWVyeV9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBj
aWZzX3Rjb24gKnRjb24sCiAJaWYgKHJjKQogCQlnb3RvIHFpbmZfZXhpdDsKIAorCXRyYWNlX3Nt
YjNfcXVlcnlfaW5mb19lbnRlcih4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJCQkJ
ICAgIHNlcy0+U3VpZCwgaW5mb19jbGFzcywgKF9fdTMyKWluZm9fdHlwZSk7CisKIAlyYyA9IGNp
ZnNfc2VuZF9yZWN2KHhpZCwgc2VzLCAmcnFzdCwgJnJlc3BfYnVmdHlwZSwgZmxhZ3MsICZyc3Bf
aW92KTsKIAlyc3AgPSAoc3RydWN0IHNtYjJfcXVlcnlfaW5mb19yc3AgKilyc3BfaW92Lmlvdl9i
YXNlOwogCkBAIC0yODc4LDYgKzI4ODEsOSBAQCBxdWVyeV9pbmZvKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCWdvdG8gcWluZl9leGl0OwogCX0KIAor
CXRyYWNlX3NtYjNfcXVlcnlfaW5mb19kb25lKHhpZCwgcGVyc2lzdGVudF9maWQsIHRjb24tPnRp
ZCwKKwkJCQlzZXMtPlN1aWQsIGluZm9fY2xhc3MsIChfX3UzMilpbmZvX3R5cGUpOworCiAJaWYg
KGRsZW4pIHsKIAkJKmRsZW4gPSBsZTMyX3RvX2NwdShyc3AtPk91dHB1dEJ1ZmZlckxlbmd0aCk7
CiAJCWlmICghKmRhdGEpIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuaCBiL2ZzL2NpZnMv
dHJhY2UuaAppbmRleCAyYTBiZTNlMTkyN2YuLmQ4YjA0OWFmYTYwNiAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy90cmFjZS5oCisrKyBiL2ZzL2NpZnMvdHJhY2UuaApAQCAtMTUzLDYgKzE1Myw0OCBAQCBE
RUZJTkVfU01CM19GRF9FUlJfRVZFTlQoY2xvc2VfZXJyKTsKIC8qCiAgKiBGb3IgaGFuZGxlIGJh
c2VkIHF1ZXJ5L3NldCBpbmZvIGNhbGxzCiAgKi8KK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19p
bmZfZW50ZXJfY2xhc3MsCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191NjQJZmlk
LAorCQlfX3UzMgl0aWQsCisJCV9fdTY0CXNlc2lkLAorCQlfX3U4CWluZmNsYXNzLAorCQlfX3Uz
Mgl0eXBlKSwKKwlUUF9BUkdTKHhpZCwgZmlkLCB0aWQsIHNlc2lkLCBpbmZjbGFzcywgdHlwZSks
CisJVFBfU1RSVUNUX19lbnRyeSgKKwkJX19maWVsZCh1bnNpZ25lZCBpbnQsIHhpZCkKKwkJX19m
aWVsZChfX3U2NCwgZmlkKQorCQlfX2ZpZWxkKF9fdTMyLCB0aWQpCisJCV9fZmllbGQoX191NjQs
IHNlc2lkKQorCQlfX2ZpZWxkKF9fdTgsIGluZmNsYXNzKQorCQlfX2ZpZWxkKF9fdTMyLCB0eXBl
KQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnhpZCA9IHhpZDsKKwkJX19lbnRy
eS0+ZmlkID0gZmlkOworCQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnktPnNlc2lkID0g
c2VzaWQ7CisJCV9fZW50cnktPmluZmNsYXNzID0gaW5mY2xhc3M7CisJCV9fZW50cnktPnR5cGUg
PSB0eXBlOworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgc2lkPTB4JWxseCB0aWQ9MHgleCBmaWQ9
MHglbGx4IGNsYXNzPSV1IHR5cGU9MHgleCIsCisJCV9fZW50cnktPnhpZCwgX19lbnRyeS0+c2Vz
aWQsIF9fZW50cnktPnRpZCwgX19lbnRyeS0+ZmlkLAorCQlfX2VudHJ5LT5pbmZjbGFzcywgX19l
bnRyeS0+dHlwZSkKKykKKworI2RlZmluZSBERUZJTkVfU01CM19JTkZfRU5URVJfRVZFTlQobmFt
ZSkgICAgICAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfaW5mX2VudGVyX2NsYXNzLCBzbWIzXyMj
bmFtZSwgICAgXAorCVRQX1BST1RPKHVuc2lnbmVkIGludCB4aWQsCQlcCisJCV9fdTY0CWZpZCwJ
CQlcCisJCV9fdTMyCXRpZCwJCQlcCisJCV9fdTY0CXNlc2lkLAkJCVwKKwkJX191OAlpbmZjbGFz
cywJCVwKKwkJX191MzIJdHlwZSksCQkJXAorCVRQX0FSR1MoeGlkLCBmaWQsIHRpZCwgc2VzaWQs
IGluZmNsYXNzLCB0eXBlKSkKKworREVGSU5FX1NNQjNfSU5GX0VOVEVSX0VWRU5UKHF1ZXJ5X2lu
Zm9fZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0VOVEVSX0VWRU5UKHF1ZXJ5X2luZm9fZG9uZSk7
CisKIERFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19pbmZfZXJyX2NsYXNzLAogCVRQX1BST1RPKHVu
c2lnbmVkIGludCB4aWQsCiAJCV9fdTY0CWZpZCwKLS0gCjIuMTcuMQoK
--000000000000f0eaa10582d8484a--
