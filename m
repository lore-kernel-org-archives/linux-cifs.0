Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7118C5517A
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 05:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F0A21D7B
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 05:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BhaHsBSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407638AbgJUF0J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 01:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407533AbgJUF0J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 01:26:09 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E06C0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 22:26:09 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id p15so1121736ljj.8
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 22:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=hptYP+sgbBe/kJvWIw/N36ee72twdhgshClkTUCB3Xc=;
        b=BhaHsBSiIX55IVo0pXbjkOKNFp+dCMxlE+qRmYIwVgY56Wvvmh3GgmhJD8rGJMnm7m
         ooaPDhpAI3p4XfzudwIZ9AIuqYVVpjO0aUyB1EGoI2BNNN+Cx53XbI4zbMbxLmeu/f2p
         tJEgKlW9yPzbiAZqIjHUxaBkrgEpnODQUrrdY7qdwcfj7UnSYs9nAjFB2asYmcOktX6L
         mXbVvRL5jPEqL9ddWBQXKFYRZ28HgxPCroKOmJWgL5G3Sz791zkZP2HAIt/MYdfaRD2S
         RBaIAWZRc76GyT+zoSR/sXmoovaxP07sQu8hQ8E+MHmDInIyhqr2d+Xhh0u8AT7GZQy0
         njWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hptYP+sgbBe/kJvWIw/N36ee72twdhgshClkTUCB3Xc=;
        b=QBamgSC5YGcqL177XMq384ufZkiMTu5dk5XZXeSDPO1UX8/BM8Kgiq1nUvcD8MSKxG
         464LJ9VdLuT8tjYu3i/j8juiyVq4I3LRQzAE3iLR5jWLe6rRVPOgG5w8F1LalhZs7NV5
         9OCwW79XwvdUCGI+DDX0YNb9LCJb6Ay11YYkMG77no8ncpOn2el8hPYdkHa6Nodo8jEK
         s4gtcu7E9KH3tIf4EIAc5VRNALs5lBFEYNCOEvydTfr3szwFPogg8YMpxSw6B5UYT6rX
         YNExmci82Dk0flO5sIxnA1RMdNvFU9cG1ZfQZitpaTHqo65jZGEtblJoSCtNgF+HpdGH
         GA2A==
X-Gm-Message-State: AOAM533qgKTNnsrEANWnRcJOk81vyETdIVk5H4xVWw3W8SMJm6c9Uxsn
        yjX50fTyikG8xMno4UFgrZvq1AP9HApekbllGYQXn3jjYG8m4A==
X-Google-Smtp-Source: ABdhPJzOIo/1n4B501CEhPADxNRwE+tON6bO4ISYgGZSw90ufeefLXNEhJFYHJI0PDQoaCDHGDb8pq4KxUVUMEodE+w=
X-Received: by 2002:a2e:b009:: with SMTP id y9mr556585ljk.372.1603257967552;
 Tue, 20 Oct 2020 22:26:07 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Oct 2020 00:25:56 -0500
Message-ID: <CAH2r5mvY127tWa5mtGDkxKU4gB6SyW5a_jjuAeoWmyDB9vCGrw@mail.gmail.com>
Subject: [PATCH][SMB3] do not try to cache root directory if dir leases not supported
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000a3e74905b22795ec"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000a3e74905b22795ec
Content-Type: text/plain; charset="UTF-8"

To servers which do not support directory leases (e.g. Samba)
    it is wasteful to try to open_shroot (ie attempt to cache the
    root directory handle).  Skip attempt to open_shroot when
    server does not indicate support for directory leases.

    Cuts the number of requests on mount from 17 to 15, and
    cuts the number of requests on stat of the root directory
    from 4 to 3.

(also added cc: stable v5.1+)



-- 
Thanks,

Steve

--000000000000a3e74905b22795ec
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-do-not-try-to-cache-root-directory-if-dir-lease.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-do-not-try-to-cache-root-directory-if-dir-lease.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgiye1s90>
X-Attachment-Id: f_kgiye1s90

RnJvbSBiNjQwZTM3N2NkODI3NmEyZjc0MDZhNmI0NzNiYTE5Zjk4YTMxZmVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjEgT2N0IDIwMjAgMDA6MTU6NDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBkbyBub3QgdHJ5IHRvIGNhY2hlIHJvb3QgZGlyZWN0b3J5IGlmIGRpciBsZWFzZXMgbm90
CiBzdXBwb3J0ZWQKClRvIHNlcnZlcnMgd2hpY2ggZG8gbm90IHN1cHBvcnQgZGlyZWN0b3J5IGxl
YXNlcyAoZS5nLiBTYW1iYSkKaXQgaXMgd2FzdGVmdWwgdG8gdHJ5IHRvIG9wZW5fc2hyb290IChp
ZSBhdHRlbXB0IHRvIGNhY2hlIHRoZQpyb290IGRpcmVjdG9yeSBoYW5kbGUpLiAgU2tpcCBhdHRl
bXB0IHRvIG9wZW5fc2hyb290IHdoZW4Kc2VydmVyIGRvZXMgbm90IGluZGljYXRlIHN1cHBvcnQg
Zm9yIGRpcmVjdG9yeSBsZWFzZXMuCgpDdXRzIHRoZSBudW1iZXIgb2YgcmVxdWVzdHMgb24gbW91
bnQgZnJvbSAxNyB0byAxNSwgYW5kCmN1dHMgdGhlIG51bWJlciBvZiByZXF1ZXN0cyBvbiBzdGF0
IG9mIHRoZSByb290IGRpcmVjdG9yeQpmcm9tIDQgdG8gMy4KClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIu
a2VybmVsLm9yZz4gIyB2NS4xKwotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgNSArKysrLQogMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggYjQyODJhYmMzZDEy
Li5iY2I1MzljMjJlMzkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2Np
ZnMvY29ubmVjdC5jCkBAIC0zNjA4LDcgKzM2MDgsMTAgQEAgY2lmc19nZXRfdGNvbihzdHJ1Y3Qg
Y2lmc19zZXMgKnNlcywgc3RydWN0IHNtYl92b2wgKnZvbHVtZV9pbmZvKQogCSAqLwogCXRjb24t
PnJldHJ5ID0gdm9sdW1lX2luZm8tPnJldHJ5OwogCXRjb24tPm5vY2FzZSA9IHZvbHVtZV9pbmZv
LT5ub2Nhc2U7Ci0JdGNvbi0+bm9oYW5kbGVjYWNoZSA9IHZvbHVtZV9pbmZvLT5ub2hhbmRsZWNh
Y2hlOworCWlmIChzZXMtPnNlcnZlci0+Y2FwYWJpbGl0aWVzICYgU01CMl9HTE9CQUxfQ0FQX0RJ
UkVDVE9SWV9MRUFTSU5HKQorCQl0Y29uLT5ub2hhbmRsZWNhY2hlID0gdm9sdW1lX2luZm8tPm5v
aGFuZGxlY2FjaGU7CisJZWxzZQorCQl0Y29uLT5ub2hhbmRsZWNhY2hlID0gMTsKIAl0Y29uLT5u
b2RlbGV0ZSA9IHZvbHVtZV9pbmZvLT5ub2RlbGV0ZTsKIAl0Y29uLT5sb2NhbF9sZWFzZSA9IHZv
bHVtZV9pbmZvLT5sb2NhbF9sZWFzZTsKIAlJTklUX0xJU1RfSEVBRCgmdGNvbi0+cGVuZGluZ19v
cGVucyk7Ci0tIAoyLjI1LjEKCg==
--000000000000a3e74905b22795ec--
