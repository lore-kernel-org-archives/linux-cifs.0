Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8617C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Oct 2022 23:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiJNX5R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 19:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJNX5P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 19:57:15 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493A29A2B7
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 16:57:14 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id p4so2501478uao.0
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 16:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XsziMdiUA8Hdb9u7dKCErGAaHPUxFe/x36c+28DjXi4=;
        b=gpdwgoFiN7zp67h5SgrfnEdLyWF9AiiVIWTMGryEIWEb1K6kvAk2A15O2xo/GUEJPd
         /OZthzU132m3eC0XRHQvPImS5f2AsiORgwhxrhDMFi89PSb4FUbtWKGmHoImSYJzOBSQ
         EKxPjSZ0DA65eJx6B42JFfAm1IGFamD75G6Ikuwrc2u1JPSfK6VsJAj5AgVgaYgAuJ40
         9/ewfLYjsUCtTP/VyF+/Tlx7yeZcd5E/EtmflkumqND5UILUaJo9tiDdbNhSObMwK2Q4
         Bom76e16jVUGmvPUTUNj0mm3qVXPGWVQcjjFBXKa4wNxG405XNoH7zEEvtFy7UMrUapx
         kaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XsziMdiUA8Hdb9u7dKCErGAaHPUxFe/x36c+28DjXi4=;
        b=ARuanuNehO/cvGK3+YdVoW+h5XUT7vh5q/aSa/eyieXa4EcaZLwXau9sdiqPZuwKUg
         /mK6j00fn04U0n/ZONhBD6j6iKbLL1ziYi8qiJ5VMVCqt9r6vIbhHbVf2AY3FeBJirSp
         qjyJ5s+Gxr1bdmY+tXbfK/2JVJZvR1S6yM+o4XZYLOwuEUE3KoDv26yl7xVvunbimZ3f
         weqjxnkC8ZPr+/S9uoUzO2ypNOixM+nUtDNLFiWOqEbdzYgZmV/mKSfFtrdTdeyKnpRH
         w7aw+0y7xhuWAGRqKx7Ip2jBC2uw1zkCR/1sSuXKpQfRHv90AqfhNfb5as088k41AMey
         QY6g==
X-Gm-Message-State: ACrzQf2+x/VQPIsoTBGmycmp4yYKxglrSCh1zJUkMzPmscrQg0EjY0I1
        Z5Cjn+bEjPNA3c3aq4f7M5v18faar3Boa9VcnuSnSwW66NM=
X-Google-Smtp-Source: AMsMyM4+sJ1YradFcoc4k6hUtVk8afNvjHHZcEhWTqaTcLZ42ZJGYhCbt5GbOGnpTYfmTPuVwloOwLq3RdRJWKg5XHg=
X-Received: by 2002:ab0:6f93:0:b0:3d7:b9af:39d4 with SMTP id
 f19-20020ab06f93000000b003d7b9af39d4mr93119uav.84.1665791832954; Fri, 14 Oct
 2022 16:57:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Oct 2022 18:57:00 -0500
Message-ID: <CAH2r5msaxD7WVUHNUpVfZpjrabLTU=sY-kVo+WD=F04m0v4gaA@mail.gmail.com>
Subject: [PATCH][SMB3 client] minor coverity fix for unitialized MBZ ACL fields
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="00000000000079309b05eb076223"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000079309b05eb076223
Content-Type: text/plain; charset="UTF-8"

smb3: must initialize two ACL struct fields to zero

Coverity spotted that we were not initalizing Stbz1 and Stbz2 to
zero in create_sd_buf.

Addresses-Coverity: 1513848 ("Uninitialized scalar variable")

See attached

-- 
Thanks,

Steve

--00000000000079309b05eb076223
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-must-initialize-two-ACL-struct-fields-to-zero.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-must-initialize-two-ACL-struct-fields-to-zero.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l995ft7b0>
X-Attachment-Id: f_l995ft7b0

RnJvbSA0OTQ0ZmM0OGFkMzQ0ZDc2MjYzYjliNDM5NGNlMGQ0NzRiN2Y1ZGUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTQgT2N0IDIwMjIgMTg6NTA6MjAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBtdXN0IGluaXRpYWxpemUgdHdvIEFDTCBzdHJ1Y3QgZmllbGRzIHRvIHplcm8KCkNvdmVy
aXR5IHNwb3R0ZWQgdGhhdCB3ZSB3ZXJlIG5vdCBpbml0YWxpemluZyBTdGJ6MSBhbmQgU3RiejIg
dG8KemVybyBpbiBjcmVhdGVfc2RfYnVmLgoKQWRkcmVzc2VzLUNvdmVyaXR5OiAxNTEzODQ4ICgi
VW5pbml0aWFsaXplZCBzY2FsYXIgdmFyaWFibGUiKQpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmc+ClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0BjanIubno+ClNpZ25l
ZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9j
aWZzL3NtYjJwZHUuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3Nt
YjJwZHUuYwppbmRleCBlMTE2MjIxN2FkMWEuLmY4Zjg5ZmY5NmM1ZCAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTI0MjAsNyArMjQyMCw3
IEBAIGNyZWF0ZV9zZF9idWYodW1vZGVfdCBtb2RlLCBib29sIHNldF9vd25lciwgdW5zaWduZWQg
aW50ICpsZW4pCiAJdW5zaWduZWQgaW50IGFjZWxlbiwgYWNsX3NpemUsIGFjZV9jb3VudDsKIAl1
bnNpZ25lZCBpbnQgb3duZXJfb2Zmc2V0ID0gMDsKIAl1bnNpZ25lZCBpbnQgZ3JvdXBfb2Zmc2V0
ID0gMDsKLQlzdHJ1Y3Qgc21iM19hY2wgYWNsOworCXN0cnVjdCBzbWIzX2FjbCBhY2wgPSB7fTsK
IAogCSpsZW4gPSByb3VuZF91cChzaXplb2Yoc3RydWN0IGNydF9zZF9jdHh0KSArIChzaXplb2Yo
c3RydWN0IGNpZnNfYWNlKSAqIDQpLCA4KTsKIApAQCAtMjQ5Myw2ICsyNDkzLDcgQEAgY3JlYXRl
X3NkX2J1Zih1bW9kZV90IG1vZGUsIGJvb2wgc2V0X293bmVyLCB1bnNpZ25lZCBpbnQgKmxlbikK
IAlhY2wuQWNsUmV2aXNpb24gPSBBQ0xfUkVWSVNJT047IC8qIFNlZSAyLjQuNC4xIG9mIE1TLURU
WVAgKi8KIAlhY2wuQWNsU2l6ZSA9IGNwdV90b19sZTE2KGFjbF9zaXplKTsKIAlhY2wuQWNlQ291
bnQgPSBjcHVfdG9fbGUxNihhY2VfY291bnQpOworCS8qIGFjbC5TYnoxIGFuZCBTYnoyIE1CWiBz
byBhcmUgbm90IHNldCBoZXJlLCBidXQgaW5pdGlhbGl6ZWQgYWJvdmUgKi8KIAltZW1jcHkoYWNs
cHRyLCAmYWNsLCBzaXplb2Yoc3RydWN0IHNtYjNfYWNsKSk7CiAKIAlidWYtPmNjb250ZXh0LkRh
dGFMZW5ndGggPSBjcHVfdG9fbGUzMihwdHIgLSAoX191OCAqKSZidWYtPnNkKTsKLS0gCjIuMzQu
MQoK
--00000000000079309b05eb076223--
