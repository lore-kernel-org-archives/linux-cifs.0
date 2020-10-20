Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5293C433E7
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 07:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5F42237B
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 07:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qxvLq8tX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgJTHIw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgJTHIv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Oct 2020 03:08:51 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAE6C061755
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 00:08:51 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a28so880993ljn.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 00:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Jxa0yeBUMZBSJbdC+QO/5jCPZ5PnwioZbq+aJtj5Y/g=;
        b=qxvLq8tXoy21swqT2UFOusLm8SW85WMEGJqXAvLbmIGy1h3qAC9N1Lo6b/xuWf0J64
         JQT3OxG839980w1/3cBhZFcyWz7ezr0UBYE/SDYz3IEihwXI4wjzRqKsLRkeuAdBYIbk
         FrnVuPaD7YGDHwp+NnXkKhvy5s2YrNz7RUXBYPB2Eix3uXKBctznEtx87UB4vdPVqzbx
         1T4/f7vSoGHQVO48IGPhtxqrb/R1hWz2LbGi/JaliArlRX4AVFbuQtP5FNhEMwZDVWDE
         Y7j+pmcf6I2Z5kVF9Y+1KQZ6jkZKs0cKIC1AlFAo/ndDSFQlpwPwZlW/taA1hkkzMbcN
         MzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Jxa0yeBUMZBSJbdC+QO/5jCPZ5PnwioZbq+aJtj5Y/g=;
        b=pycXMux9gA0zWABQEm+UrdUUQrNLAiBsOCvqu3hmyZGhFYU+K8CNyDZQVwFfr1mKiM
         Qu1Z7tSQoeH6MLKqQXrdVACFeR7XcYJVAeJH3dc5GjfAH4AA4iKaabqICLZHvKJiRJ8f
         TaOhySuZ4wpHN+a/TZoXrUXncQ0Yy4kvipE/iDkGtgtqY9FEOthJf9ElZt+8vA1AzKSy
         lpV9Cj9Rj6mVnQmM72ju5VRqigu6aTwqELtXKgRZvpOMLRtE+WA49HHcj+SHBLPyOfui
         OtwweLwUtX7wsQkK5RDDwhnyryrmsbQ/M78l11xbKsRmgirsr45RQy6j4lCa927QR9cS
         /cGg==
X-Gm-Message-State: AOAM532guod9HABNed0VJcZzYfAp6IC0d0zlsmN8zkv5sGdzsTnrbiR5
        Lh1NN8bduhVXj8p/3Qlf/5gkn+s2kQ6HlwXMHsP/Gd0MDob20Q==
X-Google-Smtp-Source: ABdhPJwRHJPtCoNdL5PiVqoSI5GOrSkNEmfk/1UfamnexzPrwPFouFPBkprjcp/dkfwiZXl4WR008ivkl2b7S4nErrI=
X-Received: by 2002:a05:651c:2db:: with SMTP id f27mr525013ljo.394.1603177729518;
 Tue, 20 Oct 2020 00:08:49 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 20 Oct 2020 02:08:38 -0500
Message-ID: <CAH2r5mupOWfBrki8w0bWDamWLB0m=HhSF+bqEwGsEs++K0x0Mg@mail.gmail.com>
Subject: [SMB3.1.1][PATCH] SMB3.1.1: Fix ids returned in POSIX query dir
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000148c0e05b214e763"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000148c0e05b214e763
Content-Type: text/plain; charset="UTF-8"

We were setting the uid/gid to the default in each dir entry
in the parsing of the POSIX query dir response, rather
than attempting to map the user and group SIDs returned by
the server to well known SIDs (or upcall if not found).

I noticed that Samba server (Jeremy's POSIX branch) returns well known sid
for the group but not for the owner (e.g. S-1-22-2-1000 for the group but
a complex SID for the user owner) but at least even if cifs upcall is
not configured
we still get the group owner displayed correctly.



-- 
Thanks,

Steve

--000000000000148c0e05b214e763
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-Fix-ids-returned-in-POSIX-query-dir.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-Fix-ids-returned-in-POSIX-query-dir.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kghmmagh0>
X-Attachment-Id: f_kghmmagh0

RnJvbSBiOWI4YTE4MWEwNWQzODRlYzkyYmQyZWY0MTVkZWEwNjY1ODExYThiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjAgT2N0IDIwMjAgMDI6MDI6MDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzLjEuMTogRml4IGlkcyByZXR1cm5lZCBpbiBQT1NJWCBxdWVyeSBkaXIKCldlIHdlcmUgc2V0
dGluZyB0aGUgdWlkL2dpZCB0byB0aGUgZGVmYXVsdCBpbiBlYWNoIGRpciBlbnRyeQppbiB0aGUg
cGFyc2luZyBvZiB0aGUgUE9TSVggcXVlcnkgZGlyIHJlc3BvbnNlLCByYXRoZXIKdGhhbiBhdHRl
bXB0aW5nIHRvIG1hcCB0aGUgdXNlciBhbmQgZ3JvdXAgU0lEcyByZXR1cm5lZCBieQp0aGUgc2Vy
dmVyIHRvIHdlbGwga25vd24gU0lEcyAob3IgdXBjYWxsIGlmIG5vdCBmb3VuZCkuCgpDQzogU3Rh
YmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzYWNsLmMgICB8IDUgKysr
LS0KIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAyICsrCiBmcy9jaWZzL3JlYWRkaXIuYyAgIHwgNSAr
Ky0tLQogMyBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzYWNsLmMgYi9mcy9jaWZzL2NpZnNhY2wuYwppbmRleCBm
Y2ZmMTRlZjFjNzAuLjIzYjIxZTk0MzY1MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzYWNsLmMK
KysrIGIvZnMvY2lmcy9jaWZzYWNsLmMKQEAgLTMzOCw3ICszMzgsNyBAQCBpZF90b19zaWQodW5z
aWduZWQgaW50IGNpZCwgdWludCBzaWR0eXBlLCBzdHJ1Y3QgY2lmc19zaWQgKnNzaWQpCiAJZ290
byBvdXRfa2V5X3B1dDsKIH0KIAotc3RhdGljIGludAoraW50CiBzaWRfdG9faWQoc3RydWN0IGNp
ZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2lkICpwc2lkLAogCQlzdHJ1Y3QgY2lm
c19mYXR0ciAqZmF0dHIsIHVpbnQgc2lkdHlwZSkKIHsKQEAgLTM1OSw3ICszNTksOCBAQCBzaWRf
dG9faWQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2lkICpwc2lk
LAogCQlyZXR1cm4gLUVJTzsKIAl9CiAKLQlpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgJiBD
SUZTX01PVU5UX1VJRF9GUk9NX0FDTCkgeworCWlmICgoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3Mg
JiBDSUZTX01PVU5UX1VJRF9GUk9NX0FDTCkgfHwKKwkgICAgKGNpZnNfc2JfbWFzdGVyX3Rjb24o
Y2lmc19zYiktPnBvc2l4X2V4dGVuc2lvbnMpKSB7CiAJCXVpbnQzMl90IHVuaXhfaWQ7CiAJCWJv
b2wgaXNfZ3JvdXA7CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmggYi9mcy9jaWZz
L2NpZnNwcm90by5oCmluZGV4IGJiNjhjYmY4MTA3NC4uMjRjNmYzNjE3N2JhIDEwMDY0NAotLS0g
YS9mcy9jaWZzL2NpZnNwcm90by5oCisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKQEAgLTIwOSw2
ICsyMDksOCBAQCBleHRlcm4gaW50IGNpZnNfc2V0X2ZpbGVfaW5mbyhzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgaWF0dHIgKmF0dHJzLAogZXh0ZXJuIGludCBjaWZzX3JlbmFtZV9wZW5kaW5n
X2RlbGV0ZShjb25zdCBjaGFyICpmdWxsX3BhdGgsCiAJCQkJICAgICAgc3RydWN0IGRlbnRyeSAq
ZGVudHJ5LAogCQkJCSAgICAgIGNvbnN0IHVuc2lnbmVkIGludCB4aWQpOworZXh0ZXJuIGludCBz
aWRfdG9faWQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNpZnNfc2lkICpw
c2lkLAorCQkJCXN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0ciwgdWludCBzaWR0eXBlKTsKIGV4dGVy
biBpbnQgY2lmc19hY2xfdG9fZmF0dHIoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAkJ
CSAgICAgIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0ciwgc3RydWN0IGlub2RlICppbm9kZSwKIAkJ
CSAgICAgIGJvb2wgZ2V0X21vZGVfZnJvbV9zcGVjaWFsX3NpZCwKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvcmVhZGRpci5jIGIvZnMvY2lmcy9yZWFkZGlyLmMKaW5kZXggMzFhMThhYWU1ZTY0Li41YWJm
MWVhMjFhYmUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvcmVhZGRpci5jCisrKyBiL2ZzL2NpZnMvcmVh
ZGRpci5jCkBAIC0yNjcsOSArMjY3LDggQEAgY2lmc19wb3NpeF90b19mYXR0cihzdHJ1Y3QgY2lm
c19mYXR0ciAqZmF0dHIsIHN0cnVjdCBzbWIyX3Bvc2l4X2luZm8gKmluZm8sCiAJaWYgKHJlcGFy
c2VfZmlsZV9uZWVkc19yZXZhbChmYXR0cikpCiAJCWZhdHRyLT5jZl9mbGFncyB8PSBDSUZTX0ZB
VFRSX05FRURfUkVWQUw7CiAKLQkvKiBUT0RPIG1hcCBTSURzICovCi0JZmF0dHItPmNmX3VpZCA9
IGNpZnNfc2ItPm1udF91aWQ7Ci0JZmF0dHItPmNmX2dpZCA9IGNpZnNfc2ItPm1udF9naWQ7CisJ
c2lkX3RvX2lkKGNpZnNfc2IsICZwYXJzZWQub3duZXIsIGZhdHRyLCBTSURPV05FUik7CisJc2lk
X3RvX2lkKGNpZnNfc2IsICZwYXJzZWQuZ3JvdXAsIGZhdHRyLCBTSURHUk9VUCk7CiB9CiAKIHN0
YXRpYyB2b2lkIF9fZGlyX2luZm9fdG9fZmF0dHIoc3RydWN0IGNpZnNfZmF0dHIgKmZhdHRyLCBj
b25zdCB2b2lkICppbmZvKQotLSAKMi4yNS4xCgo=
--000000000000148c0e05b214e763--
