Return-Path: <SRS0=queM=VN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE50C76191
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 03:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD152080A
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Jul 2019 03:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TX6xwPpa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbfGPDGX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Jul 2019 23:06:23 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:40344 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfGPDGX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 Jul 2019 23:06:23 -0400
Received: by mail-pl1-f174.google.com with SMTP id a93so9306733pla.7
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jul 2019 20:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ISDcDGUTk2/tqhKYeJw8UmYKp3pALcnWgmL7jCPj7YY=;
        b=TX6xwPpalpIxp2bV1XANTWj4OeSFZeIlrx9BaJOXOHXe2xJE+tbgx+Vx2MTi7X5mw8
         zVv6qdebZNBn3BzBqUd3mGlN0rfKIdh6OkChl+SOexf4HazWTJVq/4uCs+RUvBjj3oOA
         AvtgphXX2fhUiSwtn7lVLzRpWfoZueR6FDnh2oEUI8+tBulK4wzBMR2lywquF2YDSRtl
         49k33RGI4H/mtsu3PvbL2jBFuV5XFcBGVqTa4Neqv5vt/esMbfv6JnezoyiKLnBGQ4GO
         JQZYTSTo5VGJKj9a3olom7+5gxp8PzEL7qOuLLuwH1s5a1kvAhoM1PUYJNvkWm5+mG/b
         Rdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ISDcDGUTk2/tqhKYeJw8UmYKp3pALcnWgmL7jCPj7YY=;
        b=ky2YqZFmHDW2LErh0IMildxkN5s93Z+LC83QseAKXrzNF1ju0RRiH/eTuPvJjro1gB
         XSFgl8oXWienx33VQRQNlkJj1xwWqb/XFBRRNRu5pQxFd4z3c6LhxZaMEtFY/iFHfXci
         8GAghXUGA0MHMy1JZyi1goz7vJirTL903+cKSJzQGX8wsklT8T4T4y4EDT6DWTg+f+vs
         UB8lFA1JeH3DmMOgsnUWO9BkVvr6dWgjOauRTmvEvGV1LzBHjViKa4bP0YkXaaJMv43v
         VT30UEGYtKtKJ0MTu9zXKTaaumHwnK+mXI7wo4i2E+xXJijgO1KjF1gfJcRklHAX8A5Q
         DSMA==
X-Gm-Message-State: APjAAAU7xJ8HHl/Y9Xp1sWD5Dq2/8fCbRWP1Dyfnx+lj9drxoNnf/x3j
        hsNYkEbjjkEBRt0f//5Nv+cPi1v5lBPZoKkmZyZysHdI
X-Google-Smtp-Source: APXvYqyxYTsKeYJKpUHlo6Y3LPtMjQsfNyGsUgH5XqWWgVvkq9QYYK3TatbqbsRELUWE95WFg6OjWrqwetjW6xZjPQQ=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr32500125plb.46.1563246382139;
 Mon, 15 Jul 2019 20:06:22 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 15 Jul 2019 22:06:11 -0500
Message-ID: <CAH2r5mtkLjmjiT7QYLsGKqVHwx4JBU5=e68gTEztQ5BDCg0PWA@mail.gmail.com>
Subject: [PATCH][SMB3] CONFIG_CIFS_SMB_DIRECT no longer experimental
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004df102058dc3a974"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004df102058dc3a974
Content-Type: text/plain; charset="UTF-8"

Long Li has made good progress in fixing remaining xfstest results
over rdma smb3 mounts



-- 
Thanks,

Steve

--0000000000004df102058dc3a974
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-smbdirect-no-longer-experimental.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-smbdirect-no-longer-experimental.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jy58issm0>
X-Attachment-Id: f_jy58issm0

RnJvbSA5ZmZmODgwNDc4N2Q1OWEzYjY4OGNlM2UwM2EyMzEyNzViNjFlY2RhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTUgSnVsIDIwMTkgMjE6NTk6NDEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBzbWJkaXJlY3Qgbm8gbG9uZ2VyIGV4cGVyaW1lbnRhbAoKY2xhcmlmeSBLY29uZmlnIHRv
IGluZGljYXRlIHRoYXQgc21iIGRpcmVjdAooU01CMyBvdmVyIFJETUEpIGlzIG5vIGxvbmdlciBl
eHBlcmltZW50YWwuCgpPdmVyIHRoZSBsYXN0IHRocmVlIHJlbGVhc2VzIExvbmcgTGkgaGFzCmZp
eGVkIHZhcmlvdXMgcHJvYmxlbXMgdW5jb3ZlcmVkIGJ5IHhmc3Rlc3RpbmcuCgpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9L
Y29uZmlnIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvS2NvbmZpZyBiL2ZzL2NpZnMvS2NvbmZpZwpp
bmRleCBlMzljMTUyNjdiYjQuLmQ2ZjcxZTNjNDc0OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9LY29u
ZmlnCisrKyBiL2ZzL2NpZnMvS2NvbmZpZwpAQCAtMTk3LDEwICsxOTcsMTAgQEAgY29uZmlnIENJ
RlNfTkZTRF9FWFBPUlQKIAkgIEFsbG93cyBORlMgc2VydmVyIHRvIGV4cG9ydCBhIENJRlMgbW91
bnRlZCBzaGFyZSAobmZzZCBvdmVyIGNpZnMpCiAKIGNvbmZpZyBDSUZTX1NNQl9ESVJFQ1QKLQli
b29sICJTTUIgRGlyZWN0IHN1cHBvcnQgKEV4cGVyaW1lbnRhbCkiCisJYm9vbCAiU01CIERpcmVj
dCBzdXBwb3J0IgogCWRlcGVuZHMgb24gQ0lGUz1tICYmIElORklOSUJBTkQgJiYgSU5GSU5JQkFO
RF9BRERSX1RSQU5TIHx8IENJRlM9eSAmJiBJTkZJTklCQU5EPXkgJiYgSU5GSU5JQkFORF9BRERS
X1RSQU5TPXkKIAloZWxwCi0JICBFbmFibGVzIFNNQiBEaXJlY3QgZXhwZXJpbWVudGFsIHN1cHBv
cnQgZm9yIFNNQiAzLjAsIDMuMDIgYW5kIDMuMS4xLgorCSAgRW5hYmxlcyBTTUIgRGlyZWN0IHN1
cHBvcnQgZm9yIFNNQiAzLjAsIDMuMDIgYW5kIDMuMS4xLgogCSAgU01CIERpcmVjdCBhbGxvd3Mg
dHJhbnNmZXJyaW5nIFNNQiBwYWNrZXRzIG92ZXIgUkRNQS4gSWYgdW5zdXJlLAogCSAgc2F5IE4u
CiAKLS0gCjIuMjAuMQoK
--0000000000004df102058dc3a974--
