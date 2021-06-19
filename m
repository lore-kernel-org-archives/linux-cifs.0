Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78849C2B9F4
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 17:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F9E61208
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Jun 2021 17:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhFSRLL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Jun 2021 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbhFSRLK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Jun 2021 13:11:10 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AEFC061574
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 10:08:58 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id k8so18515571lja.4
        for <linux-cifs@vger.kernel.org>; Sat, 19 Jun 2021 10:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Ije9hIIW14I2rhdmQdSmC/4A92zmkuJmZTCYTGAlzEw=;
        b=JHHGi8rTTmpxjRs00hdFm+x+JCYeAXWLVIBgtkUWi+78aqoPri7yM/7dhvINFF/DBg
         yiZMv2qyrhK08NpNeJCR3iVS0WfmIhQSMLJ5Wei67NwATUW86HvJ46VHJ4UQeSCRbsr9
         pTQUicy4HcQtPs1OSfVto7HdPKNfUzHDp6FYfYo3M82EXSlaz6ejNOoB/1itox7Z4Icl
         EROfRy3EDJS8Z4iK5S/Qbts232WKqABI8+Q8kH3ds7Xeg+NSq+YF7yNP3Pyy+x0qPCBP
         28P+3TRqDJUsGcZhVCGYTiz0IExG2bZDF8LU3GHgIP1WcahgwOp40DVLOXh9bhiV3Sg/
         eENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Ije9hIIW14I2rhdmQdSmC/4A92zmkuJmZTCYTGAlzEw=;
        b=tnAMxIDwBjW8j4rr/i9dtBpsxseVidvUm53eKNcesb9kOasKk2jiap4LRe985NyGHZ
         mTSXBiKCxGsKjQVkMitU8ZYsSWP8xiZ86MMUDSnP1LPD1n5PzZU6POCE1oy6LNGnJAPJ
         5haSkt0Cgl3vt3L2r/4F2pKWANk4L9ybLcIOGmNTG2FrwiZ2it27clOYI0+wTaYZeYi+
         Cb/8z+Px4R+uKg1b6NBVj0VXC7kXZZ/gh4uwHNcmJUVAdgmFkknETeft7XMrTEXlSq3t
         Y7q2Bs/z1Cw5NRl+ofqRLen9MOwuc3zSfmD8OD59U9qUm4eOjSZctmdABl/3N8mJYOf3
         kgiw==
X-Gm-Message-State: AOAM531ON0f0MpcVlFMRYUh4RPiHTZkJFon0Iy20o68JH1SLqn+xEB+S
        aLkv19Vs6qv+7fH0m+/uHkbF2EggesB+fPyhWSVk/Tx5zZsaXw==
X-Google-Smtp-Source: ABdhPJy3F2vFlKacaG3RFpLxRdPx92QzpSWRYgTkqpvRLYEl8e2Hwuy6w0uXO/tqtIEvR6foRo29G5BJp1OudDgbzeg=
X-Received: by 2002:a05:651c:1697:: with SMTP id bd23mr14245916ljb.148.1624122536464;
 Sat, 19 Jun 2021 10:08:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Jun 2021 12:08:45 -0500
Message-ID: <CAH2r5msRpe-d5p9fNgiiUqoON1tvS_YfSuDH2jEepn=Q+0LM-g@mail.gmail.com>
Subject: [CIFS][PATCH] fix unneeded null check
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000dbc11105c5217e93"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000dbc11105c5217e93
Content-Type: text/plain; charset="UTF-8"

tcon can not be null in SMB2_tcon function so the check
is not relevant and removing it makes Coverity happy.



-- 
Thanks,

Steve

--000000000000dbc11105c5217e93
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-unneeded-null-check.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-unneeded-null-check.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq40m6t00>
X-Attachment-Id: f_kq40m6t00

RnJvbSBkMmQ2ZTg2NTdkN2VhZWQxNGNmZjg2OWFlYzkwMmNlYjIzMjBhNjY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMTkgSnVuIDIwMjEgMTI6MDE6MzcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggdW5uZWVkZWQgbnVsbCBjaGVjawoKdGNvbiBjYW4gbm90IGJlIG51bGwgaW4gU01C
Ml90Y29uIGZ1bmN0aW9uIHNvIHRoZSBjaGVjawppcyBub3QgcmVsZXZhbnQgYW5kIHJlbW92aW5n
IGl0IG1ha2VzIENvdmVyaXR5IGhhcHB5LgoKQWNrZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNh
aGxiZXJAcmVkaGF0LmNvbT4KQWRkcmVzc2VzLUNvdmVyaXR5OiAxMzI1MDEzMSAoIkRlcmVmZXJl
bmNlIGJlZm9yZSBudWxsIGNoZWNrIikKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZy
ZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMnBkdS5jIHwgNiArKy0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCAwN2MzOGVlYzM5
MjkuLjQ1NDU4NmQ0YzBmYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMv
Y2lmcy9zbWIycGR1LmMKQEAgLTE3OTMsMTAgKzE3OTMsOCBAQCBTTUIyX3Rjb24oY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsIGNvbnN0IGNoYXIgKnRyZWUsCiAJ
cnNwID0gKHN0cnVjdCBzbWIyX3RyZWVfY29ubmVjdF9yc3AgKilyc3BfaW92Lmlvdl9iYXNlOwog
CXRyYWNlX3NtYjNfdGNvbih4aWQsIHRjb24tPnRpZCwgc2VzLT5TdWlkLCB0cmVlLCByYyk7CiAJ
aWYgKHJjICE9IDApIHsKLQkJaWYgKHRjb24pIHsKLQkJCWNpZnNfc3RhdHNfZmFpbF9pbmModGNv
biwgU01CMl9UUkVFX0NPTk5FQ1RfSEUpOwotCQkJdGNvbi0+bmVlZF9yZWNvbm5lY3QgPSB0cnVl
OwotCQl9CisJCWNpZnNfc3RhdHNfZmFpbF9pbmModGNvbiwgU01CMl9UUkVFX0NPTk5FQ1RfSEUp
OworCQl0Y29uLT5uZWVkX3JlY29ubmVjdCA9IHRydWU7CiAJCWdvdG8gdGNvbl9lcnJvcl9leGl0
OwogCX0KIAotLSAKMi4zMC4yCgo=
--000000000000dbc11105c5217e93--
