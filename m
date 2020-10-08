Return-Path: <SRS0=9bed=DP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41160C4363A
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Oct 2020 14:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D670821924
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Oct 2020 14:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUT7v9Nc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgJHOkK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Oct 2020 10:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbgJHOkK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Oct 2020 10:40:10 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127BAC061755
        for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2020 07:40:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d81so6726105wmc.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2020 07:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BQBoHmAffr2kLPF5TWAxk6Ogan+AQ1kLlEbP7MgWHZk=;
        b=EUT7v9Ncr8dJ77zDCtPq+qJDZrGCKdiN4ZS5xd46dhS9Bh600iqhWMZc9h7ni2hl6Z
         1C+rlUCOb14MSBhm+7OAS6LIs3V9Iex84Azh/l+9lV/72AUCqzZCaVmt9TkdkHQrWLN8
         ztsbeu44WIk49pxXoG/OOM/tjvvoATuOX6t6Yg9goIjSle1m5U6y+Xwm6oUNi1akbnLN
         pewIbuSq0AnBHzUr1w+LPk6H2dhSxJNEt4PVNGvIvLSeVsvuyWqafBhQGKsTtXdNfGP8
         ZRLkZRv09wAXTsosbwh91DbxjIbSLti95FFfBn0qBgSkV0MF7L8PyonfRH/+SAqrkki3
         YwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BQBoHmAffr2kLPF5TWAxk6Ogan+AQ1kLlEbP7MgWHZk=;
        b=EZfGjozYSNaUk8WclL8G5rhrFifzxmNwazXE6PSIfCImJGfTp8NoKN8FtbffcLeYUQ
         MNAR6nVesxaw2buIqVTIYe3oB3wBh/2TS4Bq5G0RoZpCcL8tQvA12f2G5CAFA7PDxQ+o
         sOtcRcSORAwJBjJBw+ImMD/f+m5Yqk2sk1d29Bhg6fbld6R9cDUeqc9vTrMPh5A6b/aI
         cfDuxDHwjmJ0zGkmkUCFkvt8FU7ysPtbOo85Mp6p1ylVZVnzizlvqZgL2eTwdCNEY1Xm
         fBSgXH/YLtRp4CWAQgVzuTy+C+RPzALIE5cxaSsC6O4spP+ONgON+MgAT0/A2FaDYZ5Q
         mCQA==
X-Gm-Message-State: AOAM532WXuQyGpsyWC3cDbBqPHMo2MbfG1p9p8GpgbakWubjV5QYvt/w
        U2+AQCj0nYmvKM3idgznepCk1O0ImImTl76k3tY=
X-Google-Smtp-Source: ABdhPJwywdB7RFOFTVdGk51oQj5qYLQ42oBlAGg9vjY0hkWnAO9ojbcJt27Ed9tiAuuY4602oS55BNXf44qiJhDDbxs=
X-Received: by 2002:a1c:3cc3:: with SMTP id j186mr9814556wma.155.1602168008414;
 Thu, 08 Oct 2020 07:40:08 -0700 (PDT)
MIME-Version: 1.0
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Thu, 8 Oct 2020 20:09:57 +0530
Message-ID: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
Subject: [PATCH] Resolve data corruption of TCP server info fields
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000003ca0505b129cfb5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000003ca0505b129cfb5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi All,

With the "esize" mount option, I observed data corruption and cifs
reconnects during performance tests.

TCP server info field server->total_read is modified parallely by
demultiplex thread and decrypt offload worker thread. server->total_read
is used in calculation to discard the remaining data of PDU which is
not read into memory.

Because of parallel modification, =E2=80=9Cserver->total_read=E2=80=9D valu=
e got
corrupted and instead of discarding the remaining data, it discarded
some valid data from the next PDU.

server->total_read field is already updated properly during read from
socket. So, no need to update the same field again after decryption.

Regards,
Rohith

--00000000000003ca0505b129cfb5
Content-Type: application/octet-stream; 
	name="0001-Resolve-data-corruption-of-TCP-server-info-fields.patch"
Content-Disposition: attachment; 
	filename="0001-Resolve-data-corruption-of-TCP-server-info-fields.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kg0x30wj0>
X-Attachment-Id: f_kg0x30wj0

RnJvbSA4YmI5MjQxZjRhZmE0MTQzNjZmMmI2YzdjMWY1OTgxYjllY2UxOTBlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVGh1LCA4IE9jdCAyMDIwIDA5OjU4OjQxICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gUmVzb2x2ZSBkYXRhIGNvcnJ1cHRpb24gb2YgVENQIHNlcnZlciBpbmZvIGZpZWxkcwoKVENQ
IHNlcnZlciBpbmZvIGZpZWxkIHNlcnZlci0+dG90YWxfcmVhZCBpcyBtb2RpZmllZCBwYXJhbGxl
bHkgYnkKZGVtdWx0aXBsZXggdGhyZWFkIGFuZCBkZWNyeXB0IG9mZmxvYWQgd29ya2VyIHRocmVh
ZC4gc2VydmVyLT50b3RhbF9yZWFkCmlzIHVzZWQgaW4gY2FsY3VsYXRpb24gdG8gZGlzY2FyZCB0
aGUgcmVtYWluaW5nIGRhdGEgb2YgUERVIHdoaWNoIGlzCm5vdCByZWFkIGludG8gbWVtb3J5LgoK
QmVjYXVzZSBvZiBwYXJhbGxlbCBtb2RpZmljYXRpb24sIHNlcnZlci0+dG90YWxfcmVhZCBjYW4g
Z2V0IGNvcnJ1cHRlZAphbmQgY2FuIHJlc3VsdCBpbiBkaXNjYXJkaW5nIHRoZSB2YWxpZCBkYXRh
IG9mIG5leHQgUERVLgoKU2lnbmVkLW9mZi1ieTogUm9oaXRoIFN1cmFiYXR0dWxhIDxyb2hpdGhz
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAyIC0tCiAxIGZpbGUgY2hh
bmdlZCwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2Zz
L2NpZnMvc21iMm9wcy5jCmluZGV4IDMyZjkwZGM4MmM4NC4uNWExNTMwMWI4MGE4IDEwMDY0NAot
LS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtNDEyOSw4
ICs0MTI5LDYgQEAgZGVjcnlwdF9yYXdfZGF0YShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2
ZXIsIGNoYXIgKmJ1ZiwKIAogCW1lbW1vdmUoYnVmLCBpb3ZbMV0uaW92X2Jhc2UsIGJ1Zl9kYXRh
X3NpemUpOwogCi0Jc2VydmVyLT50b3RhbF9yZWFkID0gYnVmX2RhdGFfc2l6ZSArIHBhZ2VfZGF0
YV9zaXplOwotCiAJcmV0dXJuIHJjOwogfQogCi0tIAoyLjI1LjEKCg==
--00000000000003ca0505b129cfb5--
