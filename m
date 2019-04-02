Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD883C4360F
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 23:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94D3620663
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 23:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdyV+Zj/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfDBXYT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Apr 2019 19:24:19 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:33307 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfDBXYT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Apr 2019 19:24:19 -0400
Received: by mail-pl1-f181.google.com with SMTP id t16so5147931plo.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2019 16:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BxTE3WRHMguJHa51Qy80AZAqon0o51wBbtLc8K4oSOo=;
        b=SdyV+Zj/loIgGa9KW4A6Ud6FgNuL98HyHxkTWSbOovZCboMax+pfuPniZBWuF7zIkY
         nhdqbv9GVfXzREfXdfAHmdClwGlt1oRU6yz7GgfiHZDOoM+DyMEdPorlrvi/AL+Pdcyk
         vRtOtgzvWx60k6iCG2FUOwfP5/CTgl4Chsy9jWYyS8B6qJrZ+xRp+rpQ7IXvt6o6puo2
         TIg7e/3vdu/8T9cnV1kaoYx8LeL0LuY79rwtzZw1bOyv9EzBVgAt8pF1H81RWKuUONK1
         m9SJAc1GVEMhS80T8d5p9G2en0Q/UAqsgHu37/jIphZs99uDh4nyU/FIfmv2E50XZH0y
         hmHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BxTE3WRHMguJHa51Qy80AZAqon0o51wBbtLc8K4oSOo=;
        b=fnZs7k1dAziswbw1tqKuMsZEOD3BVnD6rB5O6GVvSlP2XdrMgJqCnwsURmN8FLtZbF
         a9hLY2ebwcEtDukm0yFqCN7GttnD4q2hQ4lXUr8o26/v3RKp5r2Mow8Tg5K1m6c6sa9y
         DC7uRF7r1UxuYb1WewHvr9x7CqnXsZmCUqsO6pzomnuHPevd4G7/hJhw+aO3fOM8gofg
         oagKx9KsxryId1sx6m36efrlUTufTVUpGEuYzqEXv3x7FbYlxLpbnJiVPzH3Dg7/rZ09
         avFOxfP9rIZIG3Pm1e3s8TgjFueSr3efZ3hZtF+TqMMG5FetBUOzaw4vYfHUzX0Q2tyo
         qbTg==
X-Gm-Message-State: APjAAAUt/ZHXTyU8rPAAWTJHXbNhhPIR7/0wAxELgnGXkclDeeUEv0bA
        igDCsy1xC5D+T/L8CYZjfNCtS3U3EoeblrMisVtp0IJl
X-Google-Smtp-Source: APXvYqz+xGNNgBB8yy2DMsBVEJchj7mkDD5VVKWAchepN45BC3PYCxGLhelBj3oWKsn6IyWesBcfKbTxWjMkXPiL4Dk=
X-Received: by 2002:a17:902:7841:: with SMTP id e1mr14186539pln.303.1554247457640;
 Tue, 02 Apr 2019 16:24:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Apr 2019 18:24:05 -0500
Message-ID: <CAH2r5mt7UjqRRCcdRt6Hw-VxLibasFuRWVAXzgWO+L4AD=FzVw@mail.gmail.com>
Subject: [PATCH][CIFSUTILS SMBINFO] Do not convert snapshot time to local time zone
To:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000009b6a280585946f8e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000009b6a280585946f8e
Content-Type: text/plain; charset="UTF-8"

    We  get snapshot times in GMT time, but need to convert them
    to DCE time (SMB time format) without changing the time zone.

-- 
Thanks,

Steve

--0000000000009b6a280585946f8e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbinfo-snapshots-are-returned-in-gmt-time-so-don-t-.patch"
Content-Disposition: attachment; 
	filename="0001-smbinfo-snapshots-are-returned-in-gmt-time-so-don-t-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ju0es6l40>
X-Attachment-Id: f_ju0es6l40

RnJvbSA2NGEyYmE0NmY2N2M4OTM1NjkxN2NhY2RlMTI0NDNkMGZhNzkwMWY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMiBBcHIgMjAxOSAxODoyMDowNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YmluZm86IHNuYXBzaG90cyBhcmUgcmV0dXJuZWQgaW4gZ210IHRpbWUgc28gZG9uJ3QgY29udmVy
dAogdGltZXpvbmUKCldlICBkaXNwbGF5IHNuYXBzaG90IHRpbWVzIGluIEdNVCB0aW1lLCBidXQg
bmVlZCB0byBjb252ZXJ0IHRoZW0KdG8gRENFIHRpbWUgKFNNQiB0aW1lIGZvcm1hdCkgd2l0aG91
dCBjaGFuZ2luZyB0aGUgdGltZSB6b25lLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIHNtYmluZm8uYyB8IDIgKy0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3NtYmluZm8u
YyBiL3NtYmluZm8uYwppbmRleCBkN2E2NDMxLi5jMDBmODliIDEwMDY0NAotLS0gYS9zbWJpbmZv
LmMKKysrIGIvc21iaW5mby5jCkBAIC0xMDA5LDcgKzEwMDksNyBAQCBzdGF0aWMgdm9pZCBwcmlu
dF9zbmFwc2hvdHMoc3RydWN0IHNtYl9zbmFwc2hvdF9hcnJheSAqcHNuYXApCiAJCQl1bnNpZ25l
ZCBsb25nIGxvbmcgZGNlX3RpbWU7CiAJCQlqID0gMDsKIAkJCXN0cnB0aW1lKGdtdF90b2tlbiwg
R01UX0ZPUk1BVCwgJnRtKTsKLQkJCWRjZV90aW1lID0gbWt0aW1lKCZ0bSkgKiAxMDAwMDAwMCAr
IE5URlNfVElNRV9PRkZTRVQ7CisJCQlkY2VfdGltZSA9IHRpbWVnbSgmdG0pICogMTAwMDAwMDAg
KyBOVEZTX1RJTUVfT0ZGU0VUOwogCQkJcHJpbnRmKCJcbiAgIFNNQjM6JWxsZCAiLCBkY2VfdGlt
ZSk7CiAJCX0KIAl9Ci0tIAoyLjE3LjEKCg==
--0000000000009b6a280585946f8e--
