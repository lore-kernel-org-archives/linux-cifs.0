Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26ECC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 05:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A20961B6F
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Nov 2021 05:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhKPFoO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235431AbhKPFoG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Nov 2021 00:44:06 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE51C0D943C
        for <linux-cifs@vger.kernel.org>; Mon, 15 Nov 2021 19:05:19 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id k2so32447829lji.4
        for <linux-cifs@vger.kernel.org>; Mon, 15 Nov 2021 19:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2WrJwGJ4t3DNvO7Ru2mlFYRZm57l4lwyfeq30z2RXgc=;
        b=hyhutEZyhfipxq/+BHtbqqjeftoTQPjdnXXs9j+dbQxnYmHVXkxkVisx19G3GIC4XT
         Vy4FNRh6Bgay4zR+siTlD527kE2wGibAaxM0xK5CZk9JQ2OUC2kGLNaT7HQg2MnwSicV
         WllBHM/Q5VLvzNbBRWzAdajK/NGNchhA8CkopYx/gLfLizHxiIbUoLjbwrpcyHkpY5pz
         owmn0QHfhx5yQQRA1qZ5t0tWu/0jtTghgw3VAiFdr8WGfq0qvPPYCukgNRtv9HPd4q39
         rDGaqgGaZ8krPBhS1pVWS3G8ezPAqOraoOWG57UUn5Waamvv7nrdq1dypGR0PgaJ2ChX
         GdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2WrJwGJ4t3DNvO7Ru2mlFYRZm57l4lwyfeq30z2RXgc=;
        b=RmZzwCnLZF/Q/LyGcj2PLRmyOQexN/KZK0Qra0c+aDV8Z4PS6YV+Nbswdka/nlIOjF
         lm6Tl41eoUnj0gKjGeSNcyY/ZSAjDBydiMsvRE/kng57wuvMvk5ocgk3jXVj76yoPEG2
         p33KqiRoAAZ32Jwdr9Nv70BzpRLVFsXvYAYiR3HNkPC1KZ7WcHZQKPFqBjoZmpApFKS9
         UDr0daIVU2wX5vA5tTMripJtzCLnoUgkf83b1GWOscoTSfaoTrR1Y4V0QLL78b/v78T9
         JgXXbQHXBfWE9ZhCAcLFIcSF7CrDyrTusbuMW5B3boNvKLxBt9WE6LSuj20uXj6dr53u
         TjhA==
X-Gm-Message-State: AOAM530fo6f6ynQsFrYg6Fde5LjkbgJFsrcM8VIlfU4Yxoo+aS8+Z4br
        frVm5HpEGVjVMo2Y/BZVPMsZFG28JY5ciHDlCvNJXzwY
X-Google-Smtp-Source: ABdhPJy74la1V+TUt8Br7j5BW0NeOsCaFM6JlBdZtEdywC9u1FNpzPp2uWGXgofu9KvWHaliAFAE3Gmb9H6cTygSGRo=
X-Received: by 2002:a2e:7c16:: with SMTP id x22mr3661023ljc.460.1637031917888;
 Mon, 15 Nov 2021 19:05:17 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 15 Nov 2021 21:05:06 -0600
Message-ID: <CAH2r5msH=b0UCkxfXsCEHpqQxkcvJ68qUSD+cy6JeMYi17zsHA@mail.gmail.com>
Subject: [PATCH] trivial coverity cleanup from multichannel series
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="000000000000f3bfff05d0df31df"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f3bfff05d0df31df
Content-Type: text/plain; charset="UTF-8"

Coverity complains about printks inside of spinlocks - move the
cifs_debug print call in cifs_try_adding_channels outside of the
spinlock.  See attached patch.

c

-- 
Thanks,

Steve

--000000000000f3bfff05d0df31df
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-move-debug-print-out-of-spinlock.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-move-debug-print-out-of-spinlock.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kw1ij1k10>
X-Attachment-Id: f_kw1ij1k10

RnJvbSA5NTMwNWI0MTQxZWNlOTFlNzc2OTE4NjBiNzBjZGY0ZDI4NTM3YTdmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTUgTm92IDIwMjEgMjE6MDA6MDggLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtb3ZlIGRlYnVnIHByaW50IG91dCBvZiBzcGlubG9jawoKSXQgaXMgYmV0dGVyIHRvIHBy
aW50IGRlYnVnIG1lc3NhZ2VzIG91dHNpZGUgb2YgdGhlIGNoYW5fbG9jawpzcGlubG9jayB3aGVy
ZSBwb3NzaWJsZS4KCkNDOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpB
ZGRyZXNzZXMtQ292ZXJpdHk6IDE0OTM4NTQgKCJUaHJlYWQgZGVhZGxvY2siKQpTaWduZWQtb2Zm
LWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9z
ZXNzLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nlc3MuYyBiL2ZzL2NpZnMvc2Vzcy5jCmluZGV4IDJj
MTBiMTg2ZWQ2ZS4uN2RiOGIyMmVkYWM5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nlc3MuYworKysg
Yi9mcy9jaWZzL3Nlc3MuYwpAQCAtOTUsOSArOTUsOSBAQCBpbnQgY2lmc190cnlfYWRkaW5nX2No
YW5uZWxzKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0cnVjdCBjaWZzX3NlcyAqc2Vz
KQogCX0KIAogCWlmICghKHNlcy0+c2VydmVyLT5jYXBhYmlsaXRpZXMgJiBTTUIyX0dMT0JBTF9D
QVBfTVVMVElfQ0hBTk5FTCkpIHsKLQkJY2lmc19kYmcoVkZTLCAic2VydmVyICVzIGRvZXMgbm90
IHN1cHBvcnQgbXVsdGljaGFubmVsXG4iLCBzZXMtPnNlcnZlci0+aG9zdG5hbWUpOwogCQlzZXMt
PmNoYW5fbWF4ID0gMTsKIAkJc3Bpbl91bmxvY2soJnNlcy0+Y2hhbl9sb2NrKTsKKwkJY2lmc19k
YmcoVkZTLCAic2VydmVyICVzIGRvZXMgbm90IHN1cHBvcnQgbXVsdGljaGFubmVsXG4iLCBzZXMt
PnNlcnZlci0+aG9zdG5hbWUpOwogCQlyZXR1cm4gMDsKIAl9CiAJc3Bpbl91bmxvY2soJnNlcy0+
Y2hhbl9sb2NrKTsKLS0gCjIuMzIuMAoK
--000000000000f3bfff05d0df31df--
