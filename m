Return-Path: <SRS0=4171=44=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A230C10F25
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Mar 2020 04:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F09122082E
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Mar 2020 04:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bf2mG29H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgCKEgk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Mar 2020 00:36:40 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:35091 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgCKEgk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Mar 2020 00:36:40 -0400
Received: by mail-yw1-f46.google.com with SMTP id d79so862473ywd.2
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2020 21:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Sf7tpXoI6VUNj+xA4inq2BQ7+d/qXznFFD7cMKOHJPU=;
        b=Bf2mG29HXY7lB4675y2Q3GyTX08NmtdU4Pu815EvspLq5+rKgTuMlRP8LQTfqXiwwG
         mxOQl2J36Jnbi4X9s0w2knn7vDn1dVM9Pfowhjg0Yxyl+12pc6MwXqpyOBKIkSfpEt+y
         LBTfw+GdK/04HvTWC2sNOW/B8V6kQ4MzJ5MnR8QUU5FBxztLwNbsMRBna2lELeXGpcbm
         fV207UTUhEJCgUli76dcvF3uhU0bvpbo0Z2qiYc5W9+5RajPreN1PnEAB0FkWCbeCpeq
         T6iketGVkGwnjRJJc8Qh1g1eYQcU5et8iHF8LoOVEkllEgLPrJPXsxMk87uyfnyrH7ND
         sUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Sf7tpXoI6VUNj+xA4inq2BQ7+d/qXznFFD7cMKOHJPU=;
        b=VoEXX7uY9/EWFJ3hjhYbH3Tm5lKFe8vAUuPg+1x5yqenBousgKJr/AaBdLBl7x5fa+
         Eh07rrgGmyTVrbMOY95gAbGcRUyejjdW3HLKtU+m4RYepsoRLX4YnYxbU5v3s0hGkwMr
         78O0QNFkvClscQYqMh5Hr2FUQirT9wczW59OhP/uZL9C8ZZWUgdJFWSi0KMKiiJAphRu
         IDOVikoVl7XuXd9FrIf6zWc6RGTBAum5iql8gG70Pa2BWlHmRaoTJMKN7dy4rgCqnyGy
         6stmq+C2/Z2i+eodsKPZtN3PvXXaZ3EJvIxPAO/RUwL+Ork26LfSXpMuFz82hhQvOXv1
         a+uQ==
X-Gm-Message-State: ANhLgQ2JQx3slirKKR/B6X6bzBex10VfCmaFYf345Y+kpGEyl4kOAiAP
        kZn1TdifkWH7lgT4X6/bypbBMghdQUBRje+WsxD0Lr19P1Q=
X-Google-Smtp-Source: ADFU+vvBookzUM8kc9TlUJq7ItWdu5lM1F+bieJNyiwNSZ96ju9JOvyVYsDqH5LxK6cTu7Nz2hD+gmi5Oavs7lvbaWo=
X-Received: by 2002:a25:cf85:: with SMTP id f127mr1056697ybg.167.1583901399085;
 Tue, 10 Mar 2020 21:36:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Mar 2020 23:36:27 -0500
Message-ID: <CAH2r5mumjsORpsk6kp-Xp=v1+D340y_pq8Am04zjDaam2Bxzsw@mail.gmail.com>
Subject: [PATCH][SMB3] Increment num_remote_opens stats counter even in case
 of smb2_query_dir_first
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000040959c05a08cc87c"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000040959c05a08cc87c
Content-Type: text/plain; charset="UTF-8"

Patch from Shyam attached (tentatively merged into cifs-2.6.git
for-next). See his description below:

The num_remote_opens counter keeps track of the number of open files
which must be maintained by the server at any point. This is a
per-tree-connect counter, and the value of this counter gets displayed
in the /proc/fs/cifs/Stats output as a following...

    Open files: 0 total (local), 1 open on server
                                 ^^^^^^^^^^^^^^^^
    As a thumb-rule, we want to increment this counter for each
open/create that we successfully execute on the server. Similarly, we
should decrement the counter when we successfully execute a close.

    In this case, an increment was being missed in case of smb2_query_dir_first,
    in case of successful open. As a result, we would underflow the
counter and we could even see the counter go to negative after
sufficient smb2_query_dir_first calls.

    I tested the stats counter for a bunch of filesystem operations
with the fix.
    And it looks like the counter looks correct to me.

    I also check if we missed the increments and decrements elsewhere.
It does not seem so. Few other cases where an open is done and we
don't increment the counter are
    the compound calls where the corresponding close is also sent in
the request.

-- 
Thanks,

Steve

--00000000000040959c05a08cc87c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-Increment-num_remote_opens-stats-counter-even-i.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-Increment-num_remote_opens-stats-counter-even-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k7mtyxgx0>
X-Attachment-Id: f_k7mtyxgx0

RnJvbSBmMzRkMmY4NDg1MjIxOWRkOGIyNTJmMDg3NzNmNGU0OWMzYjJkYjRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8bnNwbWFuZ2Fsb3JlQGdtYWlsLmNv
bT4KRGF0ZTogTW9uLCA5IE1hciAyMDIwIDAxOjM1OjA5IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
Q0lGUzogSW5jcmVtZW50IG51bV9yZW1vdGVfb3BlbnMgc3RhdHMgY291bnRlciBldmVuIGluIGNh
c2UKIG9mIHNtYjJfcXVlcnlfZGlyX2ZpcnN0CgpUaGUgbnVtX3JlbW90ZV9vcGVucyBjb3VudGVy
IGtlZXBzIHRyYWNrIG9mIHRoZSBudW1iZXIgb2Ygb3BlbiBmaWxlcyB3aGljaCBtdXN0IGJlCm1h
aW50YWluZWQgYnkgdGhlIHNlcnZlciBhdCBhbnkgcG9pbnQuIFRoaXMgaXMgYSBwZXItdHJlZS1j
b25uZWN0IGNvdW50ZXIsIGFuZCB0aGUgdmFsdWUKb2YgdGhpcyBjb3VudGVyIGdldHMgZGlzcGxh
eWVkIGluIHRoZSAvcHJvYy9mcy9jaWZzL1N0YXRzIG91dHB1dCBhcyBhIGZvbGxvd2luZy4uLgoK
T3BlbiBmaWxlczogMCB0b3RhbCAobG9jYWwpLCAxIG9wZW4gb24gc2VydmVyCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXl5eXl5eXl5eXl5eXl5eXgpBcyBhIHRodW1iLXJ1bGUsIHdlIHdh
bnQgdG8gaW5jcmVtZW50IHRoaXMgY291bnRlciBmb3IgZWFjaCBvcGVuL2NyZWF0ZSB0aGF0IHdl
CnN1Y2Nlc3NmdWxseSBleGVjdXRlIG9uIHRoZSBzZXJ2ZXIuIFNpbWlsYXJseSwgd2Ugc2hvdWxk
IGRlY3JlbWVudCB0aGUgY291bnRlciB3aGVuCndlIHN1Y2Nlc3NmdWxseSBleGVjdXRlIGEgY2xv
c2UuCgpJbiB0aGlzIGNhc2UsIGFuIGluY3JlbWVudCB3YXMgYmVpbmcgbWlzc2VkIGluIGNhc2Ug
b2Ygc21iMl9xdWVyeV9kaXJfZmlyc3QsCmluIGNhc2Ugb2Ygc3VjY2Vzc2Z1bCBvcGVuLiBBcyBh
IHJlc3VsdCwgd2Ugd291bGQgdW5kZXJmbG93IHRoZSBjb3VudGVyIGFuZCB3ZQpjb3VsZCBldmVu
IHNlZSB0aGUgY291bnRlciBnbyB0byBuZWdhdGl2ZSBhZnRlciBzdWZmaWNpZW50IHNtYjJfcXVl
cnlfZGlyX2ZpcnN0IGNhbGxzLgoKSSB0ZXN0ZWQgdGhlIHN0YXRzIGNvdW50ZXIgZm9yIGEgYnVu
Y2ggb2YgZmlsZXN5c3RlbSBvcGVyYXRpb25zIHdpdGggdGhlIGZpeC4KQW5kIGl0IGxvb2tzIGxp
a2UgdGhlIGNvdW50ZXIgbG9va3MgY29ycmVjdCB0byBtZS4KCkkgYWxzbyBjaGVjayBpZiB3ZSBt
aXNzZWQgdGhlIGluY3JlbWVudHMgYW5kIGRlY3JlbWVudHMgZWxzZXdoZXJlLiBJdCBkb2VzIG5v
dApzZWVtIHNvLiBGZXcgb3RoZXIgY2FzZXMgd2hlcmUgYW4gb3BlbiBpcyBkb25lIGFuZCB3ZSBk
b24ndCBpbmNyZW1lbnQgdGhlIGNvdW50ZXIgYXJlCnRoZSBjb21wb3VuZCBjYWxscyB3aGVyZSB0
aGUgY29ycmVzcG9uZGluZyBjbG9zZSBpcyBhbHNvIHNlbnQgaW4gdGhlIHJlcXVlc3QuCgpTaWdu
ZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8bnNwbWFuZ2Fsb3JlQGdtYWlsLmNvbT4KQ0M6IFN0
YWJsZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNo
IDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwgMiArKwog
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21i
Mm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggODNlNWIzNTFkNWFmLi5lYTlmY2RjYTRk
MjAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5j
CkBAIC0yMjI2LDYgKzIyMjYsOCBAQCBzbWIyX3F1ZXJ5X2Rpcl9maXJzdChjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlnb3RvIHFkZl9mcmVlOwogCX0K
IAorCWF0b21pY19pbmMoJnRjb24tPm51bV9yZW1vdGVfb3BlbnMpOworCiAJcWRfcnNwID0gKHN0
cnVjdCBzbWIyX3F1ZXJ5X2RpcmVjdG9yeV9yc3AgKilyc3BfaW92WzFdLmlvdl9iYXNlOwogCWlm
IChxZF9yc3AtPnN5bmNfaGRyLlN0YXR1cyA9PSBTVEFUVVNfTk9fTU9SRV9GSUxFUykgewogCQl0
cmFjZV9zbWIzX3F1ZXJ5X2Rpcl9kb25lKHhpZCwgZmlkLT5wZXJzaXN0ZW50X2ZpZCwKLS0gCjIu
MjAuMQoK
--00000000000040959c05a08cc87c--
