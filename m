Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C16C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 23:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A61860462
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 23:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhHJXLK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 19:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbhHJXLJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 19:11:09 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8FEC061765
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 16:10:46 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x27so1351128lfu.5
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 16:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=n4rahVjOdZUHAow8MRrIr8U8KIu9qnwt4IylDlFM9eg=;
        b=iCIra1pSjVTqIrhhhjEfzmU5LvrKXjjRUN7C2syVzC/J+JP7rfjfo/ak5baTfviLki
         WsAhflFLcSvlH7p06yEtKgitBu775F5G3xdHclzNi916L+QcDoe4w02lSOCfSJCWZCMy
         bUVcSVU15k3TCcd266Mq/keu9msQvoWDvm23s257KGaff0sV7zGXXZ2aP1QZnWofCrw+
         iziKGKnSzfxzgZSndJu8vUWw95dwnZ5lzZ/u8e6uupvAVtnzIzpiL7CFFz/qCe9Y92Qw
         opPXvmJPtNt+uC3jHfcewzpm4O5PULwyDralnlYHwpYjccQn/XotC9BOiKEMwHFGx3zg
         fKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=n4rahVjOdZUHAow8MRrIr8U8KIu9qnwt4IylDlFM9eg=;
        b=cadDzK52mLKlFaZfYRFI/SmM78EJJtG6V1P5rmdufN9n1iGKTtA445b4L/5R75Kbfs
         q1LUiKL0sqiOUC2T/rT5sYf3kPsBAghkqU+hdWdqFojMWw1U4e21sbDYeggtZTPhbwkj
         pFKTnrg8fqiRhjRdjC5RUD31QNe1FzY/nv/EIXHnpyym4kblfSRKNySj2u979OkLhZZK
         60v9c1wxF5yZ1o9H9adQNJR1HhgnF0qNGlNg7uOSN1WkRpLHumZziX8rCTn68yRrWfmS
         AOdYkc8o5qy2CFDq/YMQ6uzyAYYBcY73IlAW4Dkj28Y8AuOzDhlpZBA+umImK2fBRWOD
         2g5w==
X-Gm-Message-State: AOAM533Age5zgwyFwfPZXEpPG6UsuUqAzZh0gbFBHfdAY97puyG44OaP
        eIz1qHXUpVRIRdzUEl0IwqdOEvynPbN6DPQ8jr+0PN0j3uMJiQ==
X-Google-Smtp-Source: ABdhPJwjtQSFJJFgn0JLeCGf2lV0WuGG4oDyB3Ghs1X4KHwRTgfSlAFDaSqr67M0ZonuxwfuEXpedkjDAYRVZ1HEXH0=
X-Received: by 2002:a05:6512:e9a:: with SMTP id bi26mr21859278lfb.282.1628637045024;
 Tue, 10 Aug 2021 16:10:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Aug 2021 18:10:34 -0500
Message-ID: <CAH2r5mswfhBnBxkPm=e-RnrWnYiLL=6BavH92krQ+D-XqvrEhA@mail.gmail.com>
Subject: [PATCH] cifs: fix signed integer overflow when fl_end is OFFSET_MAX
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000089949c05c93c9cd6"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000089949c05c93c9cd6
Content-Type: text/plain; charset="UTF-8"

How about the following minor change to the recent patch from Paulo -
handling the case where we are doing a whole file lock (BSD lock,
flock) - in which case the original patch would send length of 0 (but
we went to send a byte range lock of the whole file)?

+static inline u64 cifs_flock_len(struct file_lock *fl)
+{
+ return fl->fl_end == OFFSET_MAX ? fl->fl_end - fl->fl_start:
fl->fl_end - fl->fl_start + 1;
+}

instead of Paulo's original patch

+static inline u64 cifs_flock_len(struct file_lock *fl)
+{
+ return fl->fl_end == OFFSET_MAX ? 0: fl->fl_end - fl->fl_start + 1;
+}


-- 
Thanks,

Steve

--00000000000089949c05c93c9cd6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-signed-integer-overflow-when-fl_end-is-OFFS.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-signed-integer-overflow-when-fl_end-is-OFFS.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ks6ocrlk0>
X-Attachment-Id: f_ks6ocrlk0

RnJvbSA1N2JiZTA4OGUzYzk4ZDA1ZjEzNDFhZGFmNDgwYzZkOTFhNTc0YTRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsbyBBbGNhbnRhcmEgPHBjQGNqci5uej4KRGF0ZTogVHVl
LCAxMCBBdWcgMjAyMSAxMzoxMDo0NCAtMDMwMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSBjaWZzOiBm
aXggc2lnbmVkIGludGVnZXIgb3ZlcmZsb3cgd2hlbiBmbF9lbmQgaXMKIE9GRlNFVF9NQVgKClRo
aXMgZml4ZXMgdGhlIGZvbGxvd2luZyB3aGVuIHJ1bm5pbmcgeGZzdGVzdHMgZ2VuZXJpYy81MDQ6
CgpbICAxMzQuMzk0Njk4XSBDSUZTOiBBdHRlbXB0aW5nIHRvIG1vdW50IFxcd2luMTYudm0udGVz
dFxTaGFyZQpbICAxMzQuNDIwOTA1XSBDSUZTOiBWRlM6IGdlbmVyYXRlX3NtYjNzaWduaW5na2V5
OiBkdW1waW5nIGdlbmVyYXRlZApBRVMgc2Vzc2lvbiBrZXlzClsgIDEzNC40MjA5MTFdIENJRlM6
IFZGUzogU2Vzc2lvbiBJZCAgICAwNSAwMCAwMCAwMCAwMCBjNCAwMCAwMApbICAxMzQuNDIwOTE0
XSBDSUZTOiBWRlM6IENpcGhlciB0eXBlICAgMQpbICAxMzQuNDIwOTE3XSBDSUZTOiBWRlM6IFNl
c3Npb24gS2V5ICAgZWEgMGIgZDkgMjIgMmUgYWYgMDEgNjkgMzAgMWIKMTUgNzQgYmYgODcgNDEg
MTEKWyAgMTM0LjQyMDkyMF0gQ0lGUzogVkZTOiBTaWduaW5nIEtleSAgIDU5IDI4IDQzIDVjIGYw
IGI2IGIxIDZmIGY1IDdiCjY1IGYyIDlmIDllIDU4IDdkClsgIDEzNC40MjA5MjNdIENJRlM6IFZG
UzogU2VydmVySW4gS2V5ICBlYiBhYSA1OCBjOCA5NSAwMSA5YSBmNyA5MSA5OAplNCBmYSBiYyBk
OCA3NCBmMQpbICAxMzQuNDIwOTI2XSBDSUZTOiBWRlM6IFNlcnZlck91dCBLZXkgMDggNWIgMjEg
ZTUgMmUgNGUgODYgZjYgMDUgYzIKNTggZTAgYWYgNTMgODMgZTcKWyAgMTM0Ljc3MTk0Nl0KPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0KWyAgMTM0Ljc3MTk1M10gVUJTQU46IHNpZ25lZC1pbnRlZ2Vy
LW92ZXJmbG93IGluIGZzL2NpZnMvZmlsZS5jOjE3MDY6MTkKWyAgMTM0Ljc3MTk1N10gOTIyMzM3
MjAzNjg1NDc3NTgwNyArIDEgY2Fubm90IGJlIHJlcHJlc2VudGVkIGluIHR5cGUKJ2xvbmcgbG9u
ZyBpbnQnClsgIDEzNC43NzE5NjBdIENQVTogNCBQSUQ6IDI3NzMgQ29tbTogZmxvY2sgTm90IHRh
aW50ZWQgNS4xMS4yMiAjMQpbICAxMzQuNzcxOTY0XSBIYXJkd2FyZSBuYW1lOiBSZWQgSGF0IEtW
TSwgQklPUyAwLjUuMSAwMS8wMS8yMDExClsgIDEzNC43NzE5NjZdIENhbGwgVHJhY2U6ClsgIDEz
NC43NzE5NzBdICBkdW1wX3N0YWNrKzB4OGQvMHhiNQpbICAxMzQuNzcxOTgxXSAgdWJzYW5fZXBp
bG9ndWUrMHg1LzB4NTAKWyAgMTM0Ljc3MTk4OF0gIGhhbmRsZV9vdmVyZmxvdysweGEzLzB4YjAK
WyAgMTM0Ljc3MTk5N10gID8gbG9ja2RlcF9oYXJkaXJxc19vbl9wcmVwYXJlKzB4ZTgvMHgxYjAK
WyAgMTM0Ljc3MjAwNl0gIGNpZnNfc2V0bGsrMHg2M2MvMHg2ODAgW2NpZnNdClsgIDEzNC43NzIw
ODVdICA/IF9nZXRfeGlkKzB4NWYvMHhhMCBbY2lmc10KWyAgMTM0Ljc3MjA4NV0gIGNpZnNfZmxv
Y2srMHgxMzEvMHg0MDAgW2NpZnNdClsgIDEzNC43NzIwODVdICBfX3g2NF9zeXNfZmxvY2srMHhm
Yy8weDEyMApbICAxMzQuNzcyMDg1XSAgZG9fc3lzY2FsbF82NCsweDMzLzB4NDAKWyAgMTM0Ljc3
MjA4NV0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YTkKWyAgMTM0Ljc3
MjA4NV0gUklQOiAwMDMzOjB4N2ZlYTRmODNiM2ZiClsgIDEzNC43NzIwODVdIENvZGU6IGZmIDQ4
IDhiIDE1IDhmIDFhIDBkIDAwIGY3IGQ4IDY0IDg5IDAyIGI4IGZmIGZmCmZmIGZmIGViIGRhIGU4
IDE2IDBiIDAyIDAwIDY2IDBmIDFmIDQ0IDAwIDAwIGYzIDBmIDFlIGZhIGI4IDQ5IDAwIDAwCjAw
IDBmIDA1IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggOGIgMGQgNWQgMWEgMGQgMDAg
ZjcgZDggNjQgODkKMDEgNDgKClNpZ25lZC1vZmYtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkg
PHBjQGNqci5uej4KUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0
LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29t
PgotLS0KIGZzL2NpZnMvY2lmc2dsb2IuaCB8IDUgKysrKysKIGZzL2NpZnMvY2lmc3NtYi5jICB8
IDMgKystCiBmcy9jaWZzL2ZpbGUuYyAgICAgfCA4ICsrKystLS0tCiAzIGZpbGVzIGNoYW5nZWQs
IDExIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9j
aWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IGMwYmZjMmYwMTAzMC4uZjdiZGY4
NjVmNDM5IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZz
Z2xvYi5oCkBAIC0xOTY0LDQgKzE5NjQsOSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgaXNfdGNvbl9k
ZnMoc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKIAkJdGNvbi0+c2hhcmVfZmxhZ3MgJiAoU0hJMTAw
NV9GTEFHU19ERlMgfCBTSEkxMDA1X0ZMQUdTX0RGU19ST09UKTsKIH0KIAorc3RhdGljIGlubGlu
ZSB1NjQgY2lmc19mbG9ja19sZW4oc3RydWN0IGZpbGVfbG9jayAqZmwpCit7CisJcmV0dXJuIGZs
LT5mbF9lbmQgPT0gT0ZGU0VUX01BWCA/IGZsLT5mbF9lbmQgLSBmbC0+Zmxfc3RhcnQ6IGZsLT5m
bF9lbmQgLSBmbC0+Zmxfc3RhcnQgKyAxOworfQorCiAjZW5kaWYJLyogX0NJRlNfR0xPQl9IICov
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2NpZnMvY2lmc3NtYi5jCmluZGV4
IDY1ZDFhNjViZmMzNy4uNmFiNmNmNjY5NDM4IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNzbWIu
YworKysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtMjYwNyw3ICsyNjA3LDggQEAgQ0lGU1NNQlBv
c2l4TG9jayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CiAJCQlwTG9ja0RhdGEtPmZsX3N0YXJ0ID0gbGU2NF90b19jcHUocGFybV9kYXRhLT5zdGFydCk7
CiAJCQlwTG9ja0RhdGEtPmZsX2VuZCA9IHBMb2NrRGF0YS0+Zmxfc3RhcnQgKwotCQkJCQlsZTY0
X3RvX2NwdShwYXJtX2RhdGEtPmxlbmd0aCkgLSAxOworCQkJCShsZTY0X3RvX2NwdShwYXJtX2Rh
dGEtPmxlbmd0aCkgPworCQkJCSBsZTY0X3RvX2NwdShwYXJtX2RhdGEtPmxlbmd0aCkgLSAxIDog
MCk7CiAJCQlwTG9ja0RhdGEtPmZsX3BpZCA9IC1sZTMyX3RvX2NwdShwYXJtX2RhdGEtPnBpZCk7
CiAJCX0KIAl9CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmlu
ZGV4IDBhNzI4NDBhODhmMS4uZTFjZmQ1MDk5NmEwIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUu
YworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtMTM4NSw3ICsxMzg1LDcgQEAgY2lmc19wdXNoX3Bv
c2l4X2xvY2tzKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKQogCQkJY2lmc19kYmcoVkZTLCAi
Q2FuJ3QgcHVzaCBhbGwgYnJsb2NrcyFcbiIpOwogCQkJYnJlYWs7CiAJCX0KLQkJbGVuZ3RoID0g
MSArIGZsb2NrLT5mbF9lbmQgLSBmbG9jay0+Zmxfc3RhcnQ7CisJCWxlbmd0aCA9IGNpZnNfZmxv
Y2tfbGVuKGZsb2NrKTsKIAkJaWYgKGZsb2NrLT5mbF90eXBlID09IEZfUkRMQ0sgfHwgZmxvY2st
PmZsX3R5cGUgPT0gRl9TSExDSykKIAkJCXR5cGUgPSBDSUZTX1JETENLOwogCQllbHNlCkBAIC0x
NTAxLDcgKzE1MDEsNyBAQCBjaWZzX2dldGxrKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgZmls
ZV9sb2NrICpmbG9jaywgX191MzIgdHlwZSwKIAkgICBib29sIHdhaXRfZmxhZywgYm9vbCBwb3Np
eF9sY2ssIHVuc2lnbmVkIGludCB4aWQpCiB7CiAJaW50IHJjID0gMDsKLQlfX3U2NCBsZW5ndGgg
PSAxICsgZmxvY2stPmZsX2VuZCAtIGZsb2NrLT5mbF9zdGFydDsKKwlfX3U2NCBsZW5ndGggPSBj
aWZzX2Zsb2NrX2xlbihmbG9jayk7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUgPSAoc3Ry
dWN0IGNpZnNGaWxlSW5mbyAqKWZpbGUtPnByaXZhdGVfZGF0YTsKIAlzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uID0gdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspOwogCXN0cnVjdCBUQ1BfU2VydmVyX0lu
Zm8gKnNlcnZlciA9IHRjb24tPnNlcy0+c2VydmVyOwpAQCAtMTU5OSw3ICsxNTk5LDcgQEAgY2lm
c191bmxvY2tfcmFuZ2Uoc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUsIHN0cnVjdCBmaWxlX2xv
Y2sgKmZsb2NrLAogCXN0cnVjdCBjaWZzX3Rjb24gKnRjb24gPSB0bGlua190Y29uKGNmaWxlLT50
bGluayk7CiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpbm9kZSA9IENJRlNfSShkX2lub2RlKGNm
aWxlLT5kZW50cnkpKTsKIAlzdHJ1Y3QgY2lmc0xvY2tJbmZvICpsaSwgKnRtcDsKLQlfX3U2NCBs
ZW5ndGggPSAxICsgZmxvY2stPmZsX2VuZCAtIGZsb2NrLT5mbF9zdGFydDsKKwlfX3U2NCBsZW5n
dGggPSBjaWZzX2Zsb2NrX2xlbihmbG9jayk7CiAJc3RydWN0IGxpc3RfaGVhZCB0bXBfbGxpc3Q7
CiAKIAlJTklUX0xJU1RfSEVBRCgmdG1wX2xsaXN0KTsKQEAgLTE3MDMsNyArMTcwMyw3IEBAIGNp
ZnNfc2V0bGsoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBmaWxlX2xvY2sgKmZsb2NrLCBfX3Uz
MiB0eXBlLAogCSAgIHVuc2lnbmVkIGludCB4aWQpCiB7CiAJaW50IHJjID0gMDsKLQlfX3U2NCBs
ZW5ndGggPSAxICsgZmxvY2stPmZsX2VuZCAtIGZsb2NrLT5mbF9zdGFydDsKKwlfX3U2NCBsZW5n
dGggPSBjaWZzX2Zsb2NrX2xlbihmbG9jayk7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUg
PSAoc3RydWN0IGNpZnNGaWxlSW5mbyAqKWZpbGUtPnByaXZhdGVfZGF0YTsKIAlzdHJ1Y3QgY2lm
c190Y29uICp0Y29uID0gdGxpbmtfdGNvbihjZmlsZS0+dGxpbmspOwogCXN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlciA9IHRjb24tPnNlcy0+c2VydmVyOwotLSAKMi4zMC4yCgo=
--00000000000089949c05c93c9cd6--
