Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95222C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Dec 2021 17:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhLRRxc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Dec 2021 12:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhLRRxb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Dec 2021 12:53:31 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCE9C061574
        for <linux-cifs@vger.kernel.org>; Sat, 18 Dec 2021 09:53:31 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e3so20684574edu.4
        for <linux-cifs@vger.kernel.org>; Sat, 18 Dec 2021 09:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=t62NWQiwnOdt+14Z2toQZOP8/GtC2S9kHkHLHMKXVk4=;
        b=O13zQYwNslMa7MVHyuCJB6hv+OIyjjmgZz3FLZj0/l35Tyrf7n4NQC+20hvSjAFs+k
         zWxdf1wDiXgqKIOa5b3/tay7OBZuqTedmQB4pA4XqJJZVuYy8jOngLaF2XV2Pid+h9GZ
         0ew0ZaNUquVfPMjv4ue2glfDUogYn+W8KZlF50w7oYSkkWlJ6LU3LR2HpOrlVLSiUlId
         vxI4tRp2QkizW1/r8aCD3FqsbcRnzhcYEUslUMm+N9tDd57PCcdeni++4juovjEvfbd7
         DnWQJZJ/BJCuzHHbJbpp8wLDp1h8i1IG+H6WX/9K07mM0uFDVxmNe5F8Rx16IGC6KAoo
         0HiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=t62NWQiwnOdt+14Z2toQZOP8/GtC2S9kHkHLHMKXVk4=;
        b=v/2/lmueNjmhADD5lT7OFGzM1pvIJxGLEAxDrv3cG9xwiR424JTbIoj2f1A94MI7Lm
         hZKFGWjjDAkzTtEd+I4EBZWs47mklw/m2Ir0GArUPJh95V6dVFSjkeZf+PzhxQgcdnoP
         ktZcjyZxMFoTPn3LJIdz9D9NZpWLr3ts2wAjx4p4r/QxKB9Vpadl4koIdAzrbC0bVyCc
         OFLsHcAlvWgPKoxyIrI2K+lrECXdKdNyaiebWPdH2mYqRYr+iqezGRXiFtUpUbcBBE6L
         W746djW0MHuStEm2aYRReuXzY7f+ArBsRBdAKh297X98K55LQOqP3j+8NN5T1di1aUik
         6I7Q==
X-Gm-Message-State: AOAM530hw2SbGA7MGoXnWR3Vr49n0YrfvGerWmBd3+ylGRPqJ0rzENdl
        e1JIwbMAeZbRdvFffEecQDUYH7HicrFkS7gb4ho=
X-Google-Smtp-Source: ABdhPJzhAzVYJalUvamGQ6mL3NlhV0PbM/56iogGWyMsVzK4v8Qf/V95WGi/Ckkx4F0fLZ2hOaSxbFJE9aHIGEBFJDI=
X-Received: by 2002:a17:907:869e:: with SMTP id qa30mr6594813ejc.356.1639850009907;
 Sat, 18 Dec 2021 09:53:29 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 18 Dec 2021 09:53:18 -0800
Message-ID: <CANT5p=rxedYesnqitKypJ3X9YU6eANo4zSDid_aKjk7EBCDStg@mail.gmail.com>
Subject: [PATCH] cifs: invalidate dns resolver keys after use
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005384c505d36f558b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005384c505d36f558b
Content-Type: text/plain; charset="UTF-8"

Hi Steve/Paulo/David,

Please review the attached patch.

I noticed that DNS resolution did not always upcall to userspace when
the IP address changed. This addresses the fix for it.

I would even recommend CC:stable for this one.

-- 
Regards,
Shyam

--0000000000005384c505d36f558b
Content-Type: application/octet-stream; 
	name="0001-cifs-invalidate-dns-resolver-keys-after-use.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-invalidate-dns-resolver-keys-after-use.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kxc495ww0>
X-Attachment-Id: f_kxc495ww0

RnJvbSA2MDRhYjRjMzUwYzI1NTJkYWE4ZTc3Zjg2MWE1NDAzMmI0OWJjNzA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBTYXQsIDE4IERlYyAyMDIxIDE3OjI4OjEwICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogaW52YWxpZGF0ZSBkbnMgcmVzb2x2ZXIga2V5cyBhZnRlciB1c2UKCldlIHJlbHkgb24g
ZG5zIHJlc29sdmVyIG1vZHVsZSB0byB1cGNhbGwgdG8gdXNlcnNwYWNlCnVzaW5nIHJlcXVlc3Rf
a2V5IGFuZCBnZXQgdXMgdGhlIEROUyBtYXBwaW5nLgpIb3dldmVyLCB0aGUgaW52YWxpZGF0ZSBh
cmcgZm9yIGRuc19xdWVyeSB3YXMgc2V0CnRvIGZhbHNlLCB3aGljaCBtZWFudCB0aGF0IHRoZSBr
ZXkgY3JlYXRlZCBkdXJpbmcgdGhlCmZpcnN0IGNhbGwgZm9yIGEgaG9zdG5hbWUgd291bGQgY29u
dGludWUgdG8gYmUgY2FjaGVkCnRpbGwgaXQgZXhwaXJlcy4gVGhpcyBleHBpcmF0aW9uIHBlcmlv
ZCBkZXBlbmRzIG9uCmhvdyB0aGUgZG5zX3Jlc29sdmVyIGlzIGNvbmZpZ3VyZWQuCgpGaXhpbmcg
dGhpcyBieSBzZXR0aW5nIGludmFsaWRhdGU9dHJ1ZSBkdXJpbmcgZG5zX3F1ZXJ5LgpUaGlzIG1l
YW5zIHRoYXQgdGhlIGtleSB3aWxsIGJlIGNsZWFuZWQgdXAgYnkgZG5zX3Jlc29sdmVyCnNvb24g
YWZ0ZXIgaXQgcmV0dXJucyB0aGUgZGF0YS4gVGhpcyBhbHNvIG1lYW5zIHRoYXQKdGhlIGRuc19y
ZXNvbHZlciBzdWJzeXN0ZW0gd2lsbCBub3QgY2FjaGUgdGhlIGtleSBmb3IKYW4gaW50ZXJ2YWwg
aW5kaWNhdGVkIGJ5IHRoZSBETlMgcmVjb3JkcyBUVEwuIEJ1dCB0aGlzIGlzCm9rYXkgc2luY2Ug
d2UgdXNlIHRoZSBUVEwgdmFsdWUgcmV0dXJuZWQgdG8gc2NoZWR1bGUgdGhlCm5leHQgbG9va3Vw
LgoKQ2M6IERhdmlkIEhvd2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6
IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9kbnNf
cmVzb2x2ZS5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9kbnNfcmVzb2x2ZS5jIGIvZnMvY2lmcy9kbnNf
cmVzb2x2ZS5jCmluZGV4IDA0NThkMjhkNzFhYS4uODg5MGFmMTUzN2VmIDEwMDY0NAotLS0gYS9m
cy9jaWZzL2Ruc19yZXNvbHZlLmMKKysrIGIvZnMvY2lmcy9kbnNfcmVzb2x2ZS5jCkBAIC02Niw3
ICs2Niw3IEBAIGRuc19yZXNvbHZlX3NlcnZlcl9uYW1lX3RvX2lwKGNvbnN0IGNoYXIgKnVuYywg
Y2hhciAqKmlwX2FkZHIsIHRpbWU2NF90ICpleHBpcnkpCiAKIAkvKiBQZXJmb3JtIHRoZSB1cGNh
bGwgKi8KIAlyYyA9IGRuc19xdWVyeShjdXJyZW50LT5uc3Byb3h5LT5uZXRfbnMsIE5VTEwsIGhv
c3RuYW1lLCBsZW4sCi0JCSAgICAgICBOVUxMLCBpcF9hZGRyLCBleHBpcnksIGZhbHNlKTsKKwkJ
ICAgICAgIE5VTEwsIGlwX2FkZHIsIGV4cGlyeSwgdHJ1ZSk7CiAJaWYgKHJjIDwgMCkKIAkJY2lm
c19kYmcoRllJLCAiJXM6IHVuYWJsZSB0byByZXNvbHZlOiAlKi4qc1xuIiwKIAkJCSBfX2Z1bmNf
XywgbGVuLCBsZW4sIGhvc3RuYW1lKTsK
--0000000000005384c505d36f558b--
