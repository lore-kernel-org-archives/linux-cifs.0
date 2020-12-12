Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D707AC433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 18:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5FFF21D46
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 18:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407782AbgLLS4g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 13:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407792AbgLLS4U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 13:56:20 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533D2C0613D3
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 10:55:40 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id m19so19990864lfb.1
        for <linux-cifs@vger.kernel.org>; Sat, 12 Dec 2020 10:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fd0g+XXwihf2XB3TtPMoykutpHFQulXdycRX8btCSAY=;
        b=fENPdOouPihDKHQNjdObNKChHezA3zJDQ7nj4caKg2ECuEpGZ5mHWRGS8dO1R7EmGu
         PcwqR6omNZexFQneXVb1bU23rSsQ+oCKdVgLTc7Aa8BNrLtn5of7HyqTBDTQbTapRdtQ
         NFHQLcxB0MiOqKYlgDCHiewDS+Z0IEsX2F8tw4vKFHM0klCAZ22jTDx47/temBj7bR8F
         YgR/3ggdlID53tTAo0CeTPZfXlpcBQ18VfBojI/NdUqqv/rCq5w0HKbk9s6pHjpjj3Ri
         nOpH17Q3P0jEFVbCcgIIgmN6C05MMzG0tzTyhzOSz9j6lf2KN0Z9k3gOT8YYcEYt0veZ
         EDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fd0g+XXwihf2XB3TtPMoykutpHFQulXdycRX8btCSAY=;
        b=mweouQorVAErPiEJr6SgYxiVFIePm7UOQt2kXQZFnXierAXFhzeCQMZE0AMvwA9s9z
         m39GRQ4WyhznE5grIMhK1ydAz9PKaHEbRlLqekxUc+lY2Eadh1NJFoKvRPEQMQL1URwM
         9FOSyVNfK44xWwUK5pH06bpzpN3MeHbSpQ4Y35OpHGs5EAoh1PG7we4qA0TyPjMYVSs6
         tG8r3iXGK6Kyc/jiKotJ83GKDX8g6ZkFGMj98tiEpHgNEHf4EpJze+BHjZsOlRZq3wrI
         zUmtA2bu5Y+aKhfgXHcGDCGiPbVb8+iiT0G7xFYYtXm9Sqe9PkTyTj0/wn9FiKluHLd1
         g07g==
X-Gm-Message-State: AOAM5313WshBsAvHNJ9/Jsf3BmCKIdyyej0kbpCGHEX+yIM2lBBFapRp
        JBsXwCA/Cws8F/huINYan5ZmVKMENvtzmkKcKjYDW9dcVtQ=
X-Google-Smtp-Source: ABdhPJzwRuOcs47WWheOSwM1Q9JUYnnJllfOc2Z9SK8CBzaCa2PDhR3H9QeoEx2q12W5WE8vErPXl6ZsioVsX4Fjwbw=
X-Received: by 2002:a2e:968d:: with SMTP id q13mr1115618lji.406.1607799338414;
 Sat, 12 Dec 2020 10:55:38 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Dec 2020 12:55:27 -0600
Message-ID: <CAH2r5mtuzxmutODFMpm8OncBk3o13m0DQok+VGLjy1Ei7P9vtg@mail.gmail.com>
Subject: [PATCH][CIFS] update headers included by new file unc.c
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000006fcef305b648f4a4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006fcef305b648f4a4
Content-Type: text/plain; charset="UTF-8"

Avoids trivial warnings that kernel test robot reports on compile



-- 
Thanks,

Steve

--0000000000006fcef305b648f4a4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-remove-some-minor-warnings-pointed-out-by-kerne.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-some-minor-warnings-pointed-out-by-kerne.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kim27c9n0>
X-Attachment-Id: f_kim27c9n0

RnJvbSAxMDQ4MzM0MTkxMjJmMDYwOGQ3ZDM2NTE5NDRhOWU3YjFmMWZkNGU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTIgRGVjIDIwMjAgMTI6NDk6MjggLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiByZW1vdmUgc29tZSBtaW5vciB3YXJuaW5ncyBwb2ludGVkIG91dCBieSBrZXJuZWwgdGVz
dAogcm9ib3QKCkNvcnJlY3Qgc29tZSB0cml2aWFsIHdhcm5pbmdzIGNhdXNlZCB3aGVuIG5ldyBm
aWxlIHVuYy5jCndhcyBjcmVhdGVkLiBGb3IgZXhhbXBsZToKCiAgIEluIGZpbGUgaW5jbHVkZWQg
ZnJvbSBmcy9jaWZzL3VuYy5jOjExOgo+PiBmcy9jaWZzL2NpZnNwcm90by5oOjQ0OjI4OiB3YXJu
aW5nOiAnc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbycgZGVjbGFyZWQgaW5zaWRlIHBhcmFtZXRlciBs
aXN0IHdpbGwgbm90IGJlIHZpc2libGUgb3V0c2lkZSBvZiB0aGlzIGRlZmluaXRpb24gb3IgZGVj
bGFyYXRpb24KICAgICAgNDQgfCBleHRlcm4gaW50IHNtYl9zZW5kKHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKiwgc3RydWN0IHNtYl9oZHIgKiwKClJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2Jv
dCA8bGtwQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvdW5jLmMgfCA0ICsrKysKIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3VuYy5jIGIvZnMvY2lmcy91
bmMuYwppbmRleCAyYzU2NjVmNTU0M2EuLjM5NGFhMDBjZWE0MCAxMDA2NDQKLS0tIGEvZnMvY2lm
cy91bmMuYworKysgYi9mcy9jaWZzL3VuYy5jCkBAIC03LDcgKzcsMTEgQEAKICAqICAgICAgICAg
ICAgICBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPgogICovCiAKKyNpbmNsdWRlIDxs
aW51eC9mcy5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9pbmV0
Lmg+CisjaW5jbHVkZSA8bGludXgvY3R5cGUuaD4KKyNpbmNsdWRlICJjaWZzZ2xvYi5oIgogI2lu
Y2x1ZGUgImNpZnNwcm90by5oIgogCiAvKiBleHRyYWN0IHRoZSBob3N0IHBvcnRpb24gb2YgdGhl
IFVOQyBzdHJpbmcgKi8KLS0gCjIuMjcuMAoK
--0000000000006fcef305b648f4a4--
