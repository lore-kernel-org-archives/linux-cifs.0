Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5961C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 06:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FF5B2082C
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 06:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvZ4oaCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfCEGOr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 01:14:47 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:46200 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfCEGOr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 01:14:47 -0500
Received: by mail-pg1-f176.google.com with SMTP id 196so4880302pgf.13
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 22:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=IPVZabYIsEdw0yGIPjDuXb27q54PK5zqb5weCbYA5CU=;
        b=GvZ4oaCNICS1nGpO75V4Zg98+ioEkffwkLE+7VfQTLyUPFGztNcZnEQKmtsd7zzmfs
         ri1ghQKZgq2rXgW8hcd/XxH+Duhitd/1SxzYtwccbKwAzgtZkHaDz2jQgC/izchx0ahW
         GddGCRSIq0qV9mJUUtWmyxqgchEfD/MDdNVTUksoWdj24zciDOX5frwO+pt5LTUs1jL6
         H/ETMllGUH58farqHqQHvfZj5CjB6URrxdTiPVrYpIvOTwovDwEnZXwLFpiG37dDYzQj
         UlSvyLFgk7c4QpcKmQljlX282bVHnvGBlbUZC1wsBkzK8MwNb18SKKZOveVi0QIZd09b
         zJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=IPVZabYIsEdw0yGIPjDuXb27q54PK5zqb5weCbYA5CU=;
        b=rN88XqORAm+UEVZwGzy+cApkjc6b+5RQgOZeSKKpbcbbCNi/ZkaDPHH2GzF8yJ2lB8
         AYPK7H4hFXLTGjYvpetUt2s9aT3l4YwtD4o9zlhPnpNGfZLcBvQ4de8KVTnnMURVYuQl
         csADsZB0edaQYUubVx74Q/h4eIj7Y1hnPYDS+j8fgguWGzf1lmwN/03Q4o1Z7dTnNAkY
         NZpqb4O1UlvhyScNTyGU4djA3+bPfbKixkC0xWmhEqANahfzxM0zilJXORaTsJGSnSmh
         cZKNf1zTMaXWDJ5awsvgDuDVUkKW3tFPvAEIIaPDPZfnexHY10h1L6IrBDvLQs/OUsWA
         KErQ==
X-Gm-Message-State: APjAAAV1SIbS5uHMooywrMv3TD8jzTKHHodO2zO10AMGCL9Qx7C2yYLh
        mKj2Qxo6/4aEVqhzi+80N0/IKSt3cn2Twnrj95kIbg==
X-Google-Smtp-Source: APXvYqzTFY27/wxa7JMieD+9o1Ve3NaqLz0JKCC0AemFfv+K+FkXmsRNf3ojzzUc9w8pBLEKJspnaOrZMhlDNXn0+4M=
X-Received: by 2002:a63:1053:: with SMTP id 19mr22391296pgq.55.1551766486617;
 Mon, 04 Mar 2019 22:14:46 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Mar 2019 00:14:34 -0600
Message-ID: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com>
Subject: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="00000000000035c33e058352ca0e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000035c33e058352ca0e
Content-Type: text/plain; charset="UTF-8"

merged Aurelien's small patch (attached) into cifs-2.6.git for-next

-- 
Thanks,

Steve

--00000000000035c33e058352ca0e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-CIFS-fix-FSCTL_SET_REPARSE_POINT-SMB2_ioctl-call.patch"
Content-Disposition: attachment; 
	filename="0001-CIFS-fix-FSCTL_SET_REPARSE_POINT-SMB2_ioctl-call.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsvdoxcz0>
X-Attachment-Id: f_jsvdoxcz0

RnJvbSA3NzhkODFiNjVlNGQ1OTYyNTE5NDMwMDI1MjJkOTRhN2M2ZmJjZjY5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpEYXRl
OiBNb24sIDQgTWFyIDIwMTkgMTg6NTA6MTggKzAxMDAKU3ViamVjdDogW1BBVENIXSBDSUZTOiBm
aXggRlNDVExfU0VUX1JFUEFSU0VfUE9JTlQgU01CMl9pb2N0bCgpIGNhbGwKCldpdGhvdXQgdGhp
cyBjaGFuZ2UgdGhlIGlvY3RsKCkgZmFpbHMgd2l0aCBJTlZBTElEX1BBUkFNRVRFUi4KU2luY2Ug
U0VUX1JFUEFSU0VfUE9JTlQgaGFzIG5vIG91dHB1dCwgc2V0IHRoZSBtYXggb3V0cHV0IHJlc3Bv
bnNlCnNpemUgdG8gemVyby4KCltNUy1TTUIyXSByZWFkcyAzLjMuNS4xNSBSZWNlaXZpbmcgYW4g
U01CMiBJT0NUTCBSZXF1ZXN0CgpJZiBlaXRoZXIgSW5wdXRDb3VudCwgTWF4SW5wdXRSZXNwb25z
ZSwgb3IgTWF4T3V0cHV0UmVzcG9uc2UgaXMKZ3JlYXRlciB0aGFuIENvbm5lY3Rpb24uTWF4VHJh
bnNhY3RTaXplLCB0aGUgc2VydmVyIFNIT1VMRDwzMDY+IGZhaWwKdGhlIHJlcXVlc3Qgd2l0aCBT
VEFUVVNfSU5WQUxJRF9QQVJBTUVURVIuCgpUaGUgc2VydmVyIE1VU1QgZmFpbCB0aGUgcmVxdWVz
dCB3aXRoIFNUQVRVU19JTlZBTElEX1BBUkFNRVRFUiBpbiB0aGUgZm9sbG93aW5nIGNhc2VzOgoK
KiBJZiBJbnB1dE9mZnNldCBpcyBncmVhdGVyIHRoYW4gemVybyBidXQgbGVzcyB0aGFuIChzaXpl
IG9mIFNNQjIKICBoZWFkZXIgKyBzaXplIG9mIHRoZSBTTUIyIElPQ1RMIHJlcXVlc3Qgbm90IGlu
Y2x1ZGluZyBCdWZmZXIpIG9yCiAgaWYgSW5wdXRPZmZzZXQgaXMgZ3JlYXRlciB0aGFuIChzaXpl
IG9mIFNNQjIgaGVhZGVyICsgc2l6ZSBvZiB0aGUKICBTTUIyIElPQ1RMIHJlcXVlc3QpLgoKKiBJ
ZiBPdXRwdXRPZmZzZXQgaXMgZ3JlYXRlciB0aGFuIHplcm8gYnV0IGxlc3MgdGhhbiAoc2l6ZSBv
ZiBTTUIyCiAgaGVhZGVyICsgc2l6ZSBvZiB0aGUgU01CMiBJT0NUTCByZXF1ZXN0IG5vdCBpbmNs
dWRpbmcgQnVmZmVyKSBvciBpZgogIE91dHB1dE9mZnNldCBpcyBncmVhdGVyIHRoYW4gKHNpemUg
b2YgU01CMiBoZWFkZXIgKyBzaXplIG9mIHRoZSBTTUIyCiAgSU9DVEwgcmVxdWVzdCkuCgoqIElm
IChJbnB1dE9mZnNldCArIElucHV0Q291bnQpIGlzIGdyZWF0ZXIgdGhhbiAoc2l6ZSBvZiBTTUIy
IGhlYWRlciArCiAgc2l6ZSBvZiB0aGUgU01CMiBJT0NUTCByZXF1ZXN0KS4KCiogSWYgKE91dHB1
dE9mZnNldCArIE91dHB1dENvdW50KSBpcyBncmVhdGVyIHRoYW4gKHNpemUgb2YgU01CMiBoZWFk
ZXIKICArIHNpemUgb2YgdGhlIFNNQjIgSU9DVEwgcmVxdWVzdCkuCgoqIElmIE91dHB1dENvdW50
IGlzIGdyZWF0ZXIgdGhhbiB6ZXJvIGFuZCBPdXRwdXRPZmZzZXQgaXMgbGVzcwogIHRoYW4gKElu
cHV0T2Zmc2V0ICsgSW5wdXRDb3VudCkuCgpTaWduZWQtb2ZmLWJ5OiBBdXJlbGllbiBBcHRlbCA8
YWFwdGVsQHN1c2UuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCA1ICsrKystCiAxIGZpbGUgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCA3MzMwMjE1NjYzNTYuLmNhY2Rm
OWJmOWVmMyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmMKQEAgLTI1MzksNyArMjUzOSwxMCBAQCBTTUIyX2lvY3RsKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIHU2NCBwZXJzaXN0ZW50X2ZpZCwKIAkgKiBp
biByZXNwb25zZXMgKGV4Y2VwdCBmb3IgcmVhZCByZXNwb25zZXMgd2hpY2ggY2FuIGJlIGJpZ2dl
ci4KIAkgKiBXZSBtYXkgd2FudCB0byBidW1wIHRoaXMgbGltaXQgdXAKIAkgKi8KLQlyZXEtPk1h
eE91dHB1dFJlc3BvbnNlID0gY3B1X3RvX2xlMzIoQ0lGU01heEJ1ZlNpemUpOworCWlmIChvcGNv
ZGUgPT0gRlNDVExfU0VUX1JFUEFSU0VfUE9JTlQpCisJCXJlcS0+TWF4T3V0cHV0UmVzcG9uc2Ug
PSBjcHVfdG9fbGUzMigwKTsKKwllbHNlCisJCXJlcS0+TWF4T3V0cHV0UmVzcG9uc2UgPSBjcHVf
dG9fbGUzMihDSUZTTWF4QnVmU2l6ZSk7CiAKIAlpZiAoaXNfZnNjdGwpCiAJCXJlcS0+RmxhZ3Mg
PSBjcHVfdG9fbGUzMihTTUIyXzBfSU9DVExfSVNfRlNDVEwpOwotLSAKMi4xNy4xCgo=
--00000000000035c33e058352ca0e--
