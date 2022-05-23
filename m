Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90656C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 00:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiEWAJt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 May 2022 20:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiEWAJt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 May 2022 20:09:49 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385B5387BF
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 17:09:48 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id x11so5888499vkn.11
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 17:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BXlXcrtdB+MCZFrhZ0z1VdX2ZQCbj8lUlYw2sPrlbds=;
        b=P6/w1hf50+RZ3RxMQ1ULqpPm3YPa3Sds4ghE7alrKxxBK1jjWrRj28qTxEYetgnt6v
         egAnAq5pscNtj2wEomEsfM3N60/VA5G2uGIdsmYNsaBrPY2oOfcLqwYpgYUmlxGOSE8Q
         U+ZVji90y1VL2hfGMYQNZdHrRHqMDeO480rxchMA6aeRzK0qNsHqwPm5O8JeKu9zQCSR
         Wcik+HNItuMQFMDwaCtYu8YsNeb+K06gxcxmSdD5ChHOnSEhUcdD37A57GrOrLpQHoR4
         XKk23HnJl/edQGr26KXIAmAsBr56osE9o1t3KgcIcT2uI/r4S5QSxVlnRWhntNon41/j
         w9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BXlXcrtdB+MCZFrhZ0z1VdX2ZQCbj8lUlYw2sPrlbds=;
        b=fxrwJbB9LCu3pg0daVZvwBrT3I7uJ2YoAaYTWdZjXMCwOy029QEU8dfC26Q6co7/kx
         BoyUmeUlUM2ZeE9IL2lOcs8EOnSlzzUo6cr/h0PBm9E5MXud/ukq51lcgJg5gwey+4p5
         tnh3oae8KFWPx1exX08z3wlpW74lQZt0UjVLUkJTN6QwzDcXhhHhdq7xeGAsPOPWtgAP
         v/6c8zl6QA08XC+vudeZxEUgK6jFZkrqmWH/DZ/0dKqA4RAq/ZtZRpCqohKAKkj0OsWa
         oei+zasNTWrAfLvlM77ZZnc0rlNSUEbiWbXdbZkOFEOYVv4vA6mwiV3HTwuYGlOqYt4y
         9Uyg==
X-Gm-Message-State: AOAM530OvL+t54elsvC9q8BGnWPp82zi58gGw5D9mMXEbIRdQ685K9pt
        b8pEYQQ2Pt5zdUIyd9CNhexHsFvfW9Qo5Lz4vl+dVpjN
X-Google-Smtp-Source: ABdhPJxVOLCOszD4KwfmehfHpQQpKNUT/IwC7tr5x5Qw+0tjfdOJWudXK4Iyny5fMktzTOZjYbjNdE/Rjy/rglvzgvI=
X-Received: by 2002:a1f:a7d5:0:b0:34e:4447:6309 with SMTP id
 q204-20020a1fa7d5000000b0034e44476309mr6990182vke.38.1653264586092; Sun, 22
 May 2022 17:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muiMW76Xt2zRNJWTcQVuewEj3Qs3p4oc8tvEyw5f6528g@mail.gmail.com>
In-Reply-To: <CAH2r5muiMW76Xt2zRNJWTcQVuewEj3Qs3p4oc8tvEyw5f6528g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 22 May 2022 19:09:34 -0500
Message-ID: <CAH2r5mveWTtio_Aei3VEht6KaxU6quSgwgopvXbFfMtE40q0YQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add defines for various newer FSCTLs
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000005fcfc405dfa2a889"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000005fcfc405dfa2a889
Content-Type: text/plain; charset="UTF-8"

Fixed minor typo in one define


On Sun, May 22, 2022 at 6:36 PM Steve French <smfrench@gmail.com> wrote:
>
> Checking MS-FSCC section 2.3 found six FSCTL defines that were missing
>
> See attached
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--0000000000005fcfc405dfa2a889
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Add-defines-for-various-newer-FSCTLs.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Add-defines-for-various-newer-FSCTLs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3hz1g4d0>
X-Attachment-Id: f_l3hz1g4d0

RnJvbSA4MmE3MGUzNDFiOTRmZGYwMmE2MWVmNzExOGFiMzRhOWMxNWY5ZjRiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjIgTWF5IDIwMjIgMTg6MzA6MzggLTA1MDAKU3ViamVjdDogW1BBVENIXSBb
U01CM10gQWRkIGRlZmluZXMgZm9yIHZhcmlvdXMgbmV3ZXIgRlNDVExzCgpDaGVja2luZyBNUy1G
U0NDIHNlY3Rpb24gMi4zIGZvdW5kIHNpeCBGU0NUTCBkZWZpbmVzCnRoYXQgd2VyZSBtaXNzaW5n
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvc21iZnNfY29tbW9uL3NtYmZzY3RsLmggfCA2ICsrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYmZzX2NvbW1vbi9zbWJmc2N0bC5o
IGIvZnMvc21iZnNfY29tbW9uL3NtYmZzY3RsLmgKaW5kZXggZDUxOTM5YzQzYWQ3Li45ZTllODZk
ZTk1ZjYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYmZzX2NvbW1vbi9zbWJmc2N0bC5oCisrKyBiL2ZzL3Nt
YmZzX2NvbW1vbi9zbWJmc2N0bC5oCkBAIC04OCwyMSArODgsMjcgQEAKICNkZWZpbmUgRlNDVExf
UkVBRF9SQVdfRU5DUllQVEVEICAgICAweDAwMDkwMEUzIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNk
ZWZpbmUgRlNDVExfUkVBRF9GSUxFX1VTTl9EQVRBICAgICAweDAwMDkwMEVCIC8qIEJCIGFkZCBz
dHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfV1JJVEVfVVNOX0NMT1NFX1JFQ09SRCAweDAwMDkwMEVG
IC8qIEJCIGFkZCBzdHJ1Y3QgKi8KKyNkZWZpbmUgRlNDVExfTUFSS19IQU5ETEUJICAgICAweDAw
MDkwMEZDIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfU0lTX0NPUFlGSUxFICAg
ICAgICAgICAweDAwMDkwMTAwIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfUkVD
QUxMX0ZJTEUgICAgICAgICAgICAweDAwMDkwMTE3IC8qIEJCIGFkZCBzdHJ1Y3QgKi8KICNkZWZp
bmUgRlNDVExfUVVFUllfU1BBUklOR19JTkZPICAgICAweDAwMDkwMTM4IC8qIEJCIGFkZCBzdHJ1
Y3QgKi8KKyNkZWZpbmUgRlNDVExfUVVFUllfT05fRElTS19WT0xVTUVfSU5GTyAweDAwMDkwMTND
CiAjZGVmaW5lIEZTQ1RMX1NFVF9aRVJPX09OX0RFQUxMT0MgICAgMHgwMDA5MDE5NCAvKiBCQiBh
ZGQgc3RydWN0ICovCiAjZGVmaW5lIEZTQ1RMX1NFVF9TSE9SVF9OQU1FX0JFSEFWSU9SIDB4MDAw
OTAxQjQgLyogQkIgYWRkIHN0cnVjdCAqLwogI2RlZmluZSBGU0NUTF9HRVRfSU5URUdSSVRZX0lO
Rk9STUFUSU9OIDB4MDAwOTAyN0MKKyNkZWZpbmUgRlNDVExfUVVFUllfRklMRV9SRUdJT05TICAg
ICAweDAwMDkwMjg0CiAjZGVmaW5lIEZTQ1RMX0dFVF9SRUZTX1ZPTFVNRV9EQVRBICAgMHgwMDA5
MDJEOCAvKiBTZWUgTVMtRlNDQyAyLjMuMjQgKi8KICNkZWZpbmUgRlNDVExfU0VUX0lOVEVHUklU
WV9JTkZPUk1BVElPTl9FWFQgMHgwMDA5MDM4MAogI2RlZmluZSBGU0NUTF9HRVRfUkVUUklFVkFM
X1BPSU5URVJTX0FORF9SRUZDT1VOVCAweDAwMDkwM2QzCiAjZGVmaW5lIEZTQ1RMX0dFVF9SRVRS
SUVWQUxfUE9JTlRFUl9DT1VOVCAweDAwMDkwNDJiCiAjZGVmaW5lIEZTQ1RMX1JFRlNfU1RSRUFN
X1NOQVBTSE9UX01BTkFHRU1FTlQgMHgwMDA5MDQ0MAogI2RlZmluZSBGU0NUTF9RVUVSWV9BTExP
Q0FURURfUkFOR0VTIDB4MDAwOTQwQ0YKKyNkZWZpbmUgRlNDVExfT0ZGTE9BRF9SRUFECTB4MDAw
OTQyNjQgLyogQkIgYWRkIHN0cnVjdCAqLworI2RlZmluZSBGU0NUTF9PRkZMT0FEX1dSSVRFCTB4
MDAwOTgyNjggLyogQkIgYWRkIHN0cnVjdCAqLwogI2RlZmluZSBGU0NUTF9TRVRfREVGRUNUX01B
TkFHRU1FTlQgIDB4MDAwOTgxMzQgLyogQkIgYWRkIHN0cnVjdCAqLwogI2RlZmluZSBGU0NUTF9G
SUxFX0xFVkVMX1RSSU0gICAgICAgIDB4MDAwOTgyMDggLyogQkIgYWRkIHN0cnVjdCAqLwogI2Rl
ZmluZSBGU0NUTF9EVVBMSUNBVEVfRVhURU5UU19UT19GSUxFIDB4MDAwOTgzNDQKKyNkZWZpbmUg
RlNDVExfRFVQTElDQVRFX0VYVEVOVFNfVE9fRklMRV9FWCAweDAwMDk4M0U4CiAjZGVmaW5lIEZT
Q1RMX1NJU19MSU5LX0ZJTEVTICAgICAgICAgMHgwMDA5QzEwNAogI2RlZmluZSBGU0NUTF9TRVRf
SU5URUdSSVRZX0lORk9STUFUSU9OIDB4MDAwOUMyODAKICNkZWZpbmUgRlNDVExfUElQRV9QRUVL
ICAgICAgICAgICAgICAweDAwMTE0MDBDIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KLS0gCjIuMzQuMQoK
--0000000000005fcfc405dfa2a889--
