Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD26FC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 21:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78B5E2087C
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 21:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oajtc2DA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfCKVZT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 17:25:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34819 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbfCKVZT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 17:25:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id e17so107551pgd.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 14:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gOYI4xaMiMRUJVRp0IyebQAT68sVblRTl/OQI1p/gMw=;
        b=Oajtc2DAxCH6eq4RmP1X3LAoqyOeEVYpYTwPbk7jl6NKdKeJif9gPi6VkVdtJsr5S7
         zg9LUx52xlhfNyqcnZnDkF5GeiN/16K891/EBqUv0YjVPusxFH4Qla9q6kP5RHcrRgln
         QfcPDG59wWGJ0XZJZ/K8R3n/toxwU2Ej5MWFxQNzx+UNGHVoUZ8YsubW1kx9WTE7/6ya
         aQNyGNz1CQl8HFqR3EWmxwU8JQxPCxCbeIdg9HJD59PLqF0o9dMwdUPwPSB7EFG1kxne
         wpykCkbxx1+LLQPggRBaSC3MqxztMUDxEwWbsC3292OKzMgReFU77vwp/9DF7vtz4Tv1
         QZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gOYI4xaMiMRUJVRp0IyebQAT68sVblRTl/OQI1p/gMw=;
        b=F1hLaV7m9qnMQT/XUu84mFOGtUGQLnVV0ngJdWdZKLio+MiNN+07hQaCpanSUlMQGW
         dkgQ5C3MzJHdyO5XUIzdBi8nOcA6YsJ7YhLdc1nEczjd6z46Lz9gg6M9yKkAM6hLXyVf
         RtkeNHkDLSEPW55mrzGhQevy6gZ8/Y/oRY0UNL21gu3VrYMd8IIF0obBrSR5esg+hfDn
         nTQFGVDKPsqJ7FZ4ErzwSQm7q9hrlpkdUA9CkG/JnhCBxEYmV+SVokZOKiKzROoRDfZd
         pj1bCdNf9SXn6HxsFXcVRNJ6k80K5rcUpeh0b8+/YzKgszdQ2b2qySiARnWRT9c5thqj
         PtTQ==
X-Gm-Message-State: APjAAAWv6BErpFIhkd4Lt/ILcar1ZUmvggj5fWGyP54UNO+JUPGsT6rZ
        jrK1uzHc/qeLxC5MPBoEocQXM9QFpePBKs43Wfmh9rTH
X-Google-Smtp-Source: APXvYqzMVBChEeQ48yYH/heXqItKH3OVSbrTRPstiS9NXjFoqWMToujP83R6q+jCTZGk+1qxKXGHg8xG2acDuvfmQHk=
X-Received: by 2002:a62:b2d9:: with SMTP id z86mr35262130pfl.255.1552339516046;
 Mon, 11 Mar 2019 14:25:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 11 Mar 2019 16:25:04 -0500
Message-ID: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
Subject: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000006ce8070583d835e9"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006ce8070583d835e9
Content-Type: text/plain; charset="UTF-8"

Sample output from tracing various newly added dynamic trace points
(with this patch)

(trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir* -e
smb3_delete*)

# entries-in-buffer/entries-written: 44/44   #P:8
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     gvfsd-trash-2224  [004] .... 333095.401381:
smb3_query_info_compound_enter: xid=5 sid=0xbb2583e9 tid=0xe7ab49dc
     gvfsd-trash-2224  [002] .... 333095.402056:
smb3_query_info_compound_err: xid=5 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
     gvfsd-trash-2224  [002] .... 333095.402189:
smb3_query_info_compound_enter: xid=6 sid=0xbb2583e9 tid=0xe7ab49dc
     gvfsd-trash-2224  [002] .... 333095.402688:
smb3_query_info_compound_err: xid=6 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
           mkdir-16324 [002] .... 333123.559043:
smb3_query_info_compound_enter: xid=7 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16324 [003] .... 333123.559654:
smb3_query_info_compound_err: xid=7 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
           mkdir-16324 [003] .... 333123.559673: smb3_mkdir_enter:
xid=8 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16324 [003] .... 333123.560748: smb3_mkdir_done:
xid=8 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16324 [003] .... 333123.560763:
smb3_query_info_compound_enter: xid=8 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16324 [003] .... 333123.561516:
smb3_query_info_compound_done: xid=8 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16325 [002] .... 333126.841897:
smb3_query_info_compound_enter: xid=9 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16325 [003] .... 333126.842580:
smb3_query_info_compound_err: xid=9 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
           mkdir-16325 [003] .... 333126.842601: smb3_mkdir_enter:
xid=10 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16325 [003] .... 333126.843513: smb3_mkdir_done:
xid=10 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16325 [003] .... 333126.843529:
smb3_query_info_compound_enter: xid=10 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16325 [003] .... 333126.844251:
smb3_query_info_compound_done: xid=10 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16326 [000] .... 333129.858413:
smb3_query_info_compound_enter: xid=11 sid=0xbb2583e9 tid=0xe7ab49dc
           mkdir-16326 [000] .... 333129.859193:
smb3_query_info_compound_done: xid=11 sid=0xbb2583e9 tid=0xe7ab49dc
           rmdir-16328 [007] .... 333138.828049:
smb3_query_info_compound_enter: xid=12 sid=0xbb2583e9 tid=0xe7ab49dc
           rmdir-16328 [007] .... 333138.828827:
smb3_query_info_compound_done: xid=12 sid=0xbb2583e9 tid=0xe7ab49dc
           rmdir-16329 [006] .... 333141.388154:
smb3_query_info_compound_enter: xid=14 sid=0xbb2583e9 tid=0xe7ab49dc
           rmdir-16329 [006] .... 333141.388813:
smb3_query_info_compound_err: xid=14 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
              rm-16340 [006] .... 333157.935975:
smb3_query_info_compound_enter: xid=15 sid=0xbb2583e9 tid=0xe7ab49dc
              rm-16340 [006] .... 333157.936607:
smb3_query_info_compound_err: xid=15 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
              rm-16340 [006] .... 333157.936652:
smb3_query_info_compound_enter: xid=16 sid=0xbb2583e9 tid=0xe7ab49dc
              rm-16340 [006] .... 333157.937146:
smb3_query_info_compound_err: xid=16 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
           touch-16349 [005] .... 333184.932302:
smb3_set_info_compound_enter: xid=18 sid=0xbb2583e9 tid=0xe7ab49dc
           touch-16349 [005] .... 333184.938303:
smb3_set_info_compound_done: xid=18 sid=0xbb2583e9 tid=0xe7ab49dc
              rm-16350 [003] .... 333187.920309:
smb3_query_info_compound_enter: xid=20 sid=0xbb2583e9 tid=0xe7ab49dc
              rm-16350 [003] .... 333187.920999:
smb3_query_info_compound_done: xid=20 sid=0xbb2583e9 tid=0xe7ab49dc
              rm-16350 [003] .... 333187.921043: smb3_delete_enter:
xid=21 sid=0xbb2583e9 tid=0xe7ab49dc
              rm-16350 [003] .... 333187.921870: smb3_delete_done:
xid=21 sid=0xbb2583e9 tid=0xe7ab49dc
           touch-16361 [005] .... 333237.447252:
smb3_set_info_compound_enter: xid=23 sid=0xbb2583e9 tid=0xe7ab49dc
           touch-16361 [005] .... 333237.448044:
smb3_set_info_compound_done: xid=23 sid=0xbb2583e9 tid=0xe7ab49dc
              ln-16366 [000] .... 333250.734035:
smb3_query_info_compound_enter: xid=25 sid=0xbb2583e9 tid=0xe7ab49dc
              ln-16366 [001] .... 333250.734689:
smb3_query_info_compound_err: xid=25 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
              ln-16366 [001] .... 333250.734735:
smb3_query_info_compound_enter: xid=26 sid=0xbb2583e9 tid=0xe7ab49dc
              ln-16366 [001] .... 333250.735368:
smb3_query_info_compound_done: xid=26 sid=0xbb2583e9 tid=0xe7ab49dc
              ln-16366 [001] .... 333250.735413:
smb3_query_info_compound_enter: xid=27 sid=0xbb2583e9 tid=0xe7ab49dc
              ln-16366 [001] .... 333250.735947:
smb3_query_info_compound_err: xid=27 sid=0xbb2583e9 tid=0xe7ab49dc
rc=-2
              ln-16366 [001] .... 333250.735973: smb3_hardlink_enter:
xid=28 sid=0xbb2583e9 tid=0xe7ab49dc
              ln-16366 [001] .... 333250.736679: smb3_hardlink_done:
xid=28 sid=0xbb2583e9 tid=0xe7ab49dc
           gmain-2225  [000] .... 333250.736855:
smb3_query_info_compound_enter: xid=29 sid=0xbb2583e9 tid=0xe7ab49dc
           gmain-2225  [001] .... 333250.737527:
smb3_query_info_compound_done: xid=29 sid=0xbb2583e9 tid=0xe7ab49dc


-- 
Thanks,

Steve

--0000000000006ce8070583d835e9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Add-dynamic-trace-points-for-various-compounded.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Add-dynamic-trace-points-for-various-compounded.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jt4uuppu0>
X-Attachment-Id: f_jt4uuppu0

RnJvbSBhYjdkYmZiZWZlMDZmNTFiMGZlOWE1ZWRiZGFiOTM0NjliYzg5NmYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTEgTWFyIDIwMTkgMTY6MjA6MTcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
c21iM10gQWRkIGR5bmFtaWMgdHJhY2UgcG9pbnRzIGZvciB2YXJpb3VzIGNvbXBvdW5kZWQgc21i
Mwogb3BzCgpBZGRzIHRyYWNlIHBvaW50cyBmb3IgZW50ZXIgYW5kIGV4aXQgKGRvbmUgdnMuIGVy
cm9yKSBmb3I6Cgpjb21wb3VuZGVkIHF1ZXJ5IGFuZCBzZXRpbmZvLCBoYXJkbGluaywgcmVuYW1l
LCBta2Rpciwgcm1kaXIsCnNldF9lb2YsIGRlbGV0ZSAodW5saW5rKQoKU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMmlu
b2RlLmMgfCA3MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0KIGZzL2Np
ZnMvdHJhY2UuaCAgICAgfCA4MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTQ4IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyaW5vZGUuYyBiL2ZzL2NpZnMvc21iMmlub2Rl
LmMKaW5kZXggMDFhNzZiY2NkYjhkLi5mM2RlYjU5NjI1YzAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMmlub2RlLmMKKysrIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwpAQCAtMzcsNiArMzcsMTYgQEAK
ICNpbmNsdWRlICJzbWIycGR1LmgiCiAjaW5jbHVkZSAic21iMnByb3RvLmgiCiAKK3N0YXRpYyB2
b2lkCitmcmVlX3NldF9pbmZfY29tcG91bmQoc3RydWN0IHNtYl9ycXN0ICpycXN0KQoreworCWlm
IChycXN0WzFdLnJxX2lvdikKKwkJU01CMl9zZXRfaW5mb19mcmVlKCZycXN0WzFdKTsKKwlpZiAo
cnFzdFsyXS5ycV9pb3YpCisJCVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsyXSk7Cit9CisKKwogc3Rh
dGljIGludAogc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgY29uc3Qg
Y2hhciAqZnVsbF9wYXRoLApAQCAtMTA0LDcgKzExNCw2IEBAIHNtYjJfY29tcG91bmRfb3AoY29u
c3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJbWVtc2V0KCZx
aV9pb3YsIDAsIHNpemVvZihxaV9pb3YpKTsKIAkJcnFzdFtudW1fcnFzdF0ucnFfaW92ID0gcWlf
aW92OwogCQlycXN0W251bV9ycXN0XS5ycV9udmVjID0gMTsKLQogCQlyYyA9IFNNQjJfcXVlcnlf
aW5mb19pbml0KHRjb24sICZycXN0W251bV9ycXN0XSwgQ09NUE9VTkRfRklELAogCQkJCUNPTVBP
VU5EX0ZJRCwgRklMRV9BTExfSU5GT1JNQVRJT04sCiAJCQkJU01CMl9PX0lORk9fRklMRSwgMCwK
QEAgLTExMiwxNCArMTIxLDE3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJICBQQVRIX01BWCAqIDIsIDAsIE5V
TEwpOwogCQlzbWIyX3NldF9uZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbbnVtX3Jxc3RdKTsKIAkJ
c21iMl9zZXRfcmVsYXRlZCgmcnFzdFtudW1fcnFzdCsrXSk7CisJCXRyYWNlX3NtYjNfcXVlcnlf
aW5mb19jb21wb3VuZF9lbnRlcih4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKIAkJYnJlYWs7
CiAJY2FzZSBTTUIyX09QX0RFTEVURToKKwkJdHJhY2Vfc21iM19kZWxldGVfZW50ZXIoeGlkLCBz
ZXMtPlN1aWQsIHRjb24tPnRpZCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9NS0RJUjoKIAkJ
LyoKIAkJICogRGlyZWN0b3JpZXMgYXJlIGNyZWF0ZWQgdGhyb3VnaCBwYXJhbWV0ZXJzIGluIHRo
ZQogCQkgKiBTTUIyX29wZW4oKSBjYWxsLgogCQkgKi8KKwkJdHJhY2Vfc21iM19ta2Rpcl9lbnRl
cih4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX1JN
RElSOgogCQltZW1zZXQoJnNpX2lvdiwgMCwgc2l6ZW9mKHNpX2lvdikpOwpAQCAtMTM1LDYgKzE0
Nyw3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJCQkJU01CMl9PX0lORk9fRklMRSwgMCwgZGF0YSwgc2l6ZSk7CiAJ
CXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAmcnFzdFtudW1fcnFzdF0pOwogCQlzbWIyX3Nl
dF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsKKwkJdHJhY2Vfc21iM19ybWRpcl9lbnRlcih4
aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09QX1NFVF9F
T0Y6CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBAIC0xNTAsNiArMTYz
LDcgQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRhLCBzaXplKTsKIAkJ
c21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7CiAJCXNtYjJfc2V0
X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3NldF9lb2ZfZW50ZXIo
eGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCk7CiAJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9TRVRf
SU5GTzoKIAkJbWVtc2V0KCZzaV9pb3YsIDAsIHNpemVvZihzaV9pb3YpKTsKQEAgLTE2Niw2ICsx
ODAsNyBAQCBzbWIyX2NvbXBvdW5kX29wKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBj
aWZzX3Rjb24gKnRjb24sCiAJCQkJCVNNQjJfT19JTkZPX0ZJTEUsIDAsIGRhdGEsIHNpemUpOwog
CQlzbWIyX3NldF9uZXh0X2NvbW1hbmQodGNvbiwgJnJxc3RbbnVtX3Jxc3RdKTsKIAkJc21iMl9z
ZXRfcmVsYXRlZCgmcnFzdFtudW1fcnFzdCsrXSk7CisJCXRyYWNlX3NtYjNfc2V0X2luZm9fY29t
cG91bmRfZW50ZXIoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCk7CiAJCWJyZWFrOwogCWNhc2Ug
U01CMl9PUF9SRU5BTUU6CiAJCW1lbXNldCgmc2lfaW92LCAwLCBzaXplb2Yoc2lfaW92KSk7CkBA
IC0xOTAsNiArMjA1LDcgQEAgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCQlTTUIyX09fSU5GT19GSUxFLCAwLCBkYXRh
LCBzaXplKTsKIAkJc21iMl9zZXRfbmV4dF9jb21tYW5kKHRjb24sICZycXN0W251bV9ycXN0XSk7
CiAJCXNtYjJfc2V0X3JlbGF0ZWQoJnJxc3RbbnVtX3Jxc3QrK10pOworCQl0cmFjZV9zbWIzX3Jl
bmFtZV9lbnRlcih4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKIAkJYnJlYWs7CiAJY2FzZSBT
TUIyX09QX0hBUkRMSU5LOgogCQltZW1zZXQoJnNpX2lvdiwgMCwgc2l6ZW9mKHNpX2lvdikpOwpA
QCAtMjE0LDYgKzIzMCw3IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCQkJU01CMl9PX0lORk9fRklMRSwgMCwgZGF0
YSwgc2l6ZSk7CiAJCXNtYjJfc2V0X25leHRfY29tbWFuZCh0Y29uLCAmcnFzdFtudW1fcnFzdF0p
OwogCQlzbWIyX3NldF9yZWxhdGVkKCZycXN0W251bV9ycXN0KytdKTsKKwkJdHJhY2Vfc21iM19o
YXJkbGlua19lbnRlcih4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsKIAkJYnJlYWs7CiAJZGVm
YXVsdDoKIAkJY2lmc19kYmcoVkZTLCAiSW52YWxpZCBjb21tYW5kXG4iKTsKQEAgLTI1MiwyMSAr
MjY5LDY1IEBAIHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKIAkJCVNNQjJfcXVlcnlfaW5mb19mcmVlKCZycXN0WzFdKTsKIAkJ
aWYgKHJxc3RbMl0ucnFfaW92KQogCQkJU01CMl9jbG9zZV9mcmVlKCZycXN0WzJdKTsKKwkJaWYg
KHJjKQorCQkJdHJhY2Vfc21iM19xdWVyeV9pbmZvX2NvbXBvdW5kX2Vycih4aWQsICBzZXMtPlN1
aWQsCisJCQkJCQkJICAgdGNvbi0+dGlkLCByYyk7CisJCWVsc2UKKwkJCXRyYWNlX3NtYjNfcXVl
cnlfaW5mb19jb21wb3VuZF9kb25lKHhpZCwgc2VzLT5TdWlkLAorCQkJCQkJCSAgICB0Y29uLT50
aWQpOwogCQlicmVhazsKIAljYXNlIFNNQjJfT1BfREVMRVRFOgorCQlpZiAocmMpCisJCQl0cmFj
ZV9zbWIzX2RlbGV0ZV9lcnIoeGlkLCAgc2VzLT5TdWlkLCB0Y29uLT50aWQsIHJjKTsKKwkJZWxz
ZQorCQkJdHJhY2Vfc21iM19kZWxldGVfZG9uZSh4aWQsIHNlcy0+U3VpZCwgdGNvbi0+dGlkKTsK
KwkJaWYgKHJxc3RbMV0ucnFfaW92KQorCQkJU01CMl9jbG9zZV9mcmVlKCZycXN0WzFdKTsKKwkJ
YnJlYWs7CiAJY2FzZSBTTUIyX09QX01LRElSOgorCQlpZiAocmMpCisJCQl0cmFjZV9zbWIzX21r
ZGlyX2Vycih4aWQsICBzZXMtPlN1aWQsIHRjb24tPnRpZCwgcmMpOworCQllbHNlCisJCQl0cmFj
ZV9zbWIzX21rZGlyX2RvbmUoeGlkLCBzZXMtPlN1aWQsIHRjb24tPnRpZCk7CiAJCWlmIChycXN0
WzFdLnJxX2lvdikKIAkJCVNNQjJfY2xvc2VfZnJlZSgmcnFzdFsxXSk7CiAJCWJyZWFrOwogCWNh
c2UgU01CMl9PUF9IQVJETElOSzoKKwkJaWYgKHJjKQorCQkJdHJhY2Vfc21iM19oYXJkbGlua19l
cnIoeGlkLCAgc2VzLT5TdWlkLCB0Y29uLT50aWQsIHJjKTsKKwkJZWxzZQorCQkJdHJhY2Vfc21i
M19oYXJkbGlua19kb25lKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQpOworCQlmcmVlX3NldF9p
bmZfY29tcG91bmQocnFzdCk7CisJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9SRU5BTUU6CisJCWlm
IChyYykKKwkJCXRyYWNlX3NtYjNfcmVuYW1lX2Vycih4aWQsICBzZXMtPlN1aWQsIHRjb24tPnRp
ZCwgcmMpOworCQllbHNlCisJCQl0cmFjZV9zbWIzX3JlbmFtZV9kb25lKHhpZCwgc2VzLT5TdWlk
LCB0Y29uLT50aWQpOworCQlmcmVlX3NldF9pbmZfY29tcG91bmQocnFzdCk7CisJCWJyZWFrOwog
CWNhc2UgU01CMl9PUF9STURJUjoKKwkJaWYgKHJjKQorCQkJdHJhY2Vfc21iM19ybWRpcl9lcnIo
eGlkLCAgc2VzLT5TdWlkLCB0Y29uLT50aWQsIHJjKTsKKwkJZWxzZQorCQkJdHJhY2Vfc21iM19y
bWRpcl9kb25lKHhpZCwgc2VzLT5TdWlkLCB0Y29uLT50aWQpOworCQlmcmVlX3NldF9pbmZfY29t
cG91bmQocnFzdCk7CisJCWJyZWFrOwogCWNhc2UgU01CMl9PUF9TRVRfRU9GOgorCQlpZiAocmMp
CisJCQl0cmFjZV9zbWIzX3NldF9lb2ZfZXJyKHhpZCwgIHNlcy0+U3VpZCwgdGNvbi0+dGlkLCBy
Yyk7CisJCWVsc2UKKwkJCXRyYWNlX3NtYjNfc2V0X2VvZl9kb25lKHhpZCwgc2VzLT5TdWlkLCB0
Y29uLT50aWQpOworCQlmcmVlX3NldF9pbmZfY29tcG91bmQocnFzdCk7CisJCWJyZWFrOwogCWNh
c2UgU01CMl9PUF9TRVRfSU5GTzoKLQkJaWYgKHJxc3RbMV0ucnFfaW92KQotCQkJU01CMl9zZXRf
aW5mb19mcmVlKCZycXN0WzFdKTsKLQkJaWYgKHJxc3RbMl0ucnFfaW92KQotCQkJU01CMl9jbG9z
ZV9mcmVlKCZycXN0WzJdKTsKKwkJaWYgKHJjKQorCQkJdHJhY2Vfc21iM19zZXRfaW5mb19jb21w
b3VuZF9lcnIoeGlkLCAgc2VzLT5TdWlkLAorCQkJCQkJCSB0Y29uLT50aWQsIHJjKTsKKwkJZWxz
ZQorCQkJdHJhY2Vfc21iM19zZXRfaW5mb19jb21wb3VuZF9kb25lKHhpZCwgc2VzLT5TdWlkLAor
CQkJCQkJCSAgdGNvbi0+dGlkKTsKKwkJZnJlZV9zZXRfaW5mX2NvbXBvdW5kKHJxc3QpOwogCQli
cmVhazsKIAl9CiAJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZVswXSwgcnNwX2lvdlswXS5pb3Zf
YmFzZSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgKaW5k
ZXggYzc4ZTk2YzRjYzUzLi4wNDU1ZmM3ZTUyMzUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhY2Uu
aAorKysgYi9mcy9jaWZzL3RyYWNlLmgKQEAgLTI0Miw2ICsyNDIsODggQEAgREVGSU5FX1NNQjNf
SU5GX0VSUl9FVkVOVChxdWVyeV9pbmZvX2Vycik7CiBERUZJTkVfU01CM19JTkZfRVJSX0VWRU5U
KHNldF9pbmZvX2Vycik7CiBERUZJTkVfU01CM19JTkZfRVJSX0VWRU5UKGZzY3RsX2Vycik7CiAK
K0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19pbmZfY29tcG91bmRfZW50ZXJfY2xhc3MsCisJVFBf
UFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNpZCksCisJ
VFBfQVJHUyh4aWQsIHRpZCwgc2VzaWQpLAorCVRQX1NUUlVDVF9fZW50cnkoCisJCV9fZmllbGQo
dW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkKKwkJX19maWVsZChfX3U2
NCwgc2VzaWQpCisJKSwKKwlUUF9mYXN0X2Fzc2lnbigKKwkJX19lbnRyeS0+eGlkID0geGlkOwor
CQlfX2VudHJ5LT50aWQgPSB0aWQ7CisJCV9fZW50cnktPnNlc2lkID0gc2VzaWQ7CisJKSwKKwlU
UF9wcmludGsoInhpZD0ldSBzaWQ9MHglbGx4IHRpZD0weCV4IiwKKwkJX19lbnRyeS0+eGlkLCBf
X2VudHJ5LT5zZXNpZCwgX19lbnRyeS0+dGlkKQorKQorCisjZGVmaW5lIERFRklORV9TTUIzX0lO
Rl9DT01QT1VORF9FTlRFUl9FVkVOVChuYW1lKSAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfaW5m
X2NvbXBvdW5kX2VudGVyX2NsYXNzLCBzbWIzXyMjbmFtZSwgICAgXAorCVRQX1BST1RPKHVuc2ln
bmVkIGludCB4aWQsCQlcCisJCV9fdTMyCXRpZCwJCQlcCisJCV9fdTY0CXNlc2lkKSwJCQlcCisJ
VFBfQVJHUyh4aWQsIHRpZCwgc2VzaWQpKQorCitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5U
RVJfRVZFTlQocXVlcnlfaW5mb19jb21wb3VuZF9lbnRlcik7CitERUZJTkVfU01CM19JTkZfQ09N
UE9VTkRfRU5URVJfRVZFTlQocXVlcnlfaW5mb19jb21wb3VuZF9kb25lKTsKK0RFRklORV9TTUIz
X0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChoYXJkbGlua19lbnRlcik7CitERUZJTkVfU01CM19J
TkZfQ09NUE9VTkRfRU5URVJfRVZFTlQoaGFyZGxpbmtfZG9uZSk7CitERUZJTkVfU01CM19JTkZf
Q09NUE9VTkRfRU5URVJfRVZFTlQocmVuYW1lX2VudGVyKTsKK0RFRklORV9TTUIzX0lORl9DT01Q
T1VORF9FTlRFUl9FVkVOVChyZW5hbWVfZG9uZSk7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRf
RU5URVJfRVZFTlQocm1kaXJfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVS
X0VWRU5UKHJtZGlyX2RvbmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5U
KHNldF9lb2ZfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKHNl
dF9lb2ZfZG9uZSk7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZFTlQoc2V0X2lu
Zm9fY29tcG91bmRfZW50ZXIpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5U
KHNldF9pbmZvX2NvbXBvdW5kX2RvbmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVS
X0VWRU5UKGRlbGV0ZV9lbnRlcik7CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRU5URVJfRVZF
TlQoZGVsZXRlX2RvbmUpOworREVGSU5FX1NNQjNfSU5GX0NPTVBPVU5EX0VOVEVSX0VWRU5UKG1r
ZGlyX2VudGVyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FTlRFUl9FVkVOVChta2Rpcl9k
b25lKTsKKworREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2luZl9jb21wb3VuZF9lcnJfY2xhc3Ms
CisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNp
ZCwKKwkJaW50CXJjKSwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNpZCwgcmMpLAorCVRQX1NUUlVD
VF9fZW50cnkoCisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191MzIs
IHRpZCkKKwkJX19maWVsZChfX3U2NCwgc2VzaWQpCisJCV9fZmllbGQoaW50LCByYykKKwkpLAor
CVRQX2Zhc3RfYXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4aWQ7CisJCV9fZW50cnktPnRpZCA9
IHRpZDsKKwkJX19lbnRyeS0+c2VzaWQgPSBzZXNpZDsKKwkJX19lbnRyeS0+cmMgPSByYzsKKwkp
LAorCVRQX3ByaW50aygieGlkPSV1IHNpZD0weCVsbHggdGlkPTB4JXggcmM9JWQiLAorCQlfX2Vu
dHJ5LT54aWQsIF9fZW50cnktPnNlc2lkLCBfX2VudHJ5LT50aWQsIF9fZW50cnktPnJjKQorKQor
CisjZGVmaW5lIERFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQobmFtZSkgICAgIFwK
K0RFRklORV9FVkVOVChzbWIzX2luZl9jb21wb3VuZF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAg
ICBcCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJ
X191NjQJc2VzaWQsCQkJXAorCQlpbnQgcmMpLAkJCVwKKwlUUF9BUkdTKHhpZCwgdGlkLCBzZXNp
ZCwgcmMpKQorCitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHF1ZXJ5X2luZm9f
Y29tcG91bmRfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQoaGFyZGxp
bmtfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01QT1VORF9FUlJfRVZFTlQocmVuYW1lX2Vycik7
CitERUZJTkVfU01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHJtZGlyX2Vycik7CitERUZJTkVf
U01CM19JTkZfQ09NUE9VTkRfRVJSX0VWRU5UKHNldF9lb2ZfZXJyKTsKK0RFRklORV9TTUIzX0lO
Rl9DT01QT1VORF9FUlJfRVZFTlQoc2V0X2luZm9fY29tcG91bmRfZXJyKTsKK0RFRklORV9TTUIz
X0lORl9DT01QT1VORF9FUlJfRVZFTlQobWtkaXJfZXJyKTsKK0RFRklORV9TTUIzX0lORl9DT01Q
T1VORF9FUlJfRVZFTlQoZGVsZXRlX2Vycik7CisKIC8qCiAgKiBGb3IgbG9nZ2luZyBTTUIzIFN0
YXR1cyBjb2RlIGFuZCBDb21tYW5kIGZvciByZXNwb25zZXMgd2hpY2ggcmV0dXJuIGVycm9ycwog
ICovCi0tIAoyLjE3LjEKCg==
--0000000000006ce8070583d835e9--
