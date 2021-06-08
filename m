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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2A9C47082
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 21:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8115261278
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 21:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhFHVvl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbhFHVvl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Jun 2021 17:51:41 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40028C061574
        for <linux-cifs@vger.kernel.org>; Tue,  8 Jun 2021 14:49:47 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id r5so34555494lfr.5
        for <linux-cifs@vger.kernel.org>; Tue, 08 Jun 2021 14:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BSS4C+Tof4hX7XOl0u8vZzIzOJkeQij5kHDcnOxRbtQ=;
        b=u9hj/yoXRsvtCUvpFePU7s2TiK+2tivLMfkX5m6iJFRZrIZzt8312bf7U0Qa4ahyuU
         MzeHFa/IuBbB2yBDJOaIowEMKVDd/SWB8SX0dig0uQdWFmzTg7IE3TMA6I0mJGxe/5Rc
         Y/dE85naosBmQxURJ8jbtHUAc2k3OrrKeT/4PRYsM41zALOb2A2B+MgIGaf3Ep3Qv03B
         q9FXCk5mLAPHgTv5Uut67j/EG3ERdXf1SJRHCP3J4RrHSKC5L94ys0ZMylzSe7tlJdpo
         K9dB51dj13JUev4f5ONQoHYd5wNtKQ7uE+E/+QcxrJjSefXcP3mjP7WFX2nuFziYS8/I
         up/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BSS4C+Tof4hX7XOl0u8vZzIzOJkeQij5kHDcnOxRbtQ=;
        b=RMWw0kfFMLdLvUDm0QXQCrF7XpqXHA9fEUz+xG8nam9N/HxDdnFGdkzg07qMrTaCW+
         6pWaL3ZdqdjYGDUZBWkCK3bzN2kEHeoGXD0iTYexm/LbjSTu5OaogkeYMVEJ2qLG208w
         UAoDCC0+Vc6Ceuk8c+vEhHfYHohr2DmwaJxwKTOZyYx4Z3lEfFNX7sb4KR8UEenrzBos
         qtaJaQCuV7CBV0wGAsJ1pTtmIywfHt0zhzk7lxiBcrvers+fgCgu/X2ygOsaORzsbFZM
         19+UYVfP8wWX2oRZCZQELhcu4yXINK456MIJs3KkUhdUtWqAOKECZmBHbCVIiY9DHlcQ
         YksA==
X-Gm-Message-State: AOAM530fearMJmmazo2ex5kmgwBNjkIbfznw0xioycI0YZAG2IJFTQ/Q
        a/OnN09zIUDQd3htj+I1G0FQuYmju5z9Y2xc/9/v3p2JCks=
X-Google-Smtp-Source: ABdhPJz0r+myW7wXzehh/u9I4qp8s9yNYWkKTuV6fXEQni7Q4eJ9LWDU3QSCbb3mlJBWaylwYcUS/XauJ4A1j+eritw=
X-Received: by 2002:a05:6512:3694:: with SMTP id d20mr8645060lfs.184.1623188985306;
 Tue, 08 Jun 2021 14:49:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 8 Jun 2021 16:49:34 -0500
Message-ID: <CAH2r5mtXtY9K5=DA8dfgNm2rbvLB7GJUUvC7_0q8R1uGLtxV0Q@mail.gmail.com>
Subject: [CIFS][PATCH] Enable extended stats by default
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: multipart/mixed; boundary="000000000000df7b6a05c4482259"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000df7b6a05c4482259
Content-Type: text/plain; charset="UTF-8"

Patch to enable CONFIG_CIFS_STATS2 by default



-- 
Thanks,

Steve

--000000000000df7b6a05c4482259
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-enable-extended-stats-by-default.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-enable-extended-stats-by-default.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kpoksrh60>
X-Attachment-Id: f_kpoksrh60

RnJvbSA3YTZiNmQ1YTVmZmU5YmFlNzViZjEzMGUyZDgyYTM0YzM5ZGJlZTY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOCBKdW4gMjAyMSAxNjo0Mzo0MSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGVuYWJsZSBleHRlbmRlZCBzdGF0cyBieSBkZWZhdWx0CgpDT05GSUdfQ0lGU19TVEFUUzIg
Y2FuIGJlIHZlcnkgdXNlZnVsIHNpbmNlIGl0IHNob3dzCmxhdGVuY2llcyBieSBjb21tYW5kLCBh
bmQgYWxsb3dzIGVuYWJsaW5nIHRoZSBzbG93IHJlc3BvbnNlCmR5bmFtaWMgdHJhY2Vwb2ludCB3
aGljaCBjYW4gYmUgdXNlZnVsIHRvIGlkZW50aWZ5CnBlcmZvcm1hbmNlIHByb2JsZW1zLgoKRm9y
IGV4YW1wbGU6CgpUb3RhbCB0aW1lIHNwZW50IHByb2Nlc3NpbmcgYnkgY29tbWFuZC4gVGltZSB1
bml0cyBhcmUgamlmZmllcyAoMTAwMCBwZXIgc2Vjb25kKQogIFNNQjMgQ01ECU51bWJlcglUb3Rh
bCBUaW1lCUZhc3Rlc3QJU2xvd2VzdAogIC0tLS0tLS0tCS0tLS0tLQktLS0tLS0tLS0tCS0tLS0t
LS0JLS0tLS0tLQogIDAJCTEJMgkJMgkyCiAgMQkJMgk2CQkyCTQKICAyCQkwCTAJCTAJMAogIDMJ
CTQJMTEJCTIJNAogIDQJCTIJMTYJCTUJMTEKICA1CQk0NTQ2CTM0MTA0CQkyCTQ4NwogIDYJCTQ0
MjEJMzI5MDEJCTIJNDg3CiAgNwkJMAkwCQkwCTAKICA4CQk2OTUJMjc4MQkJMgkzOQogIDkJCTM5
MQkxNzA4CQkyCTI3CiAgMTAJCTAJMAkJMAkwCiAgMTEJCTQJNgkJMQkyCiAgMTIJCTAJMAkJMAkw
CiAgMTMJCTAJMAkJMAkwCiAgMTQJCTM4ODcJMTc2OTYJCTAJMTI4CiAgMTUJCTAJMAkJMAkwCiAg
MTYJCTE0NzEJOTk1MAkJMQk0ODcKICAxNwkJMTY5CTI2OTUJCTkJMTE2CiAgMTgJCTgwCTM4MQkJ
MgkxMAogIDEJCTIJNgkJMgk0CiAgMgkJMAkwCQkwCTAKICAzCQk0CTExCQkyCTQKICA0CQkyCTE2
CQk1CTExCiAgNQkJNDU0NgkzNDEwNAkJMgk0ODcKICA2CQk0NDIxCTMyOTAxCQkyCTQ4NwogIDcJ
CTAJMAkJMAkwCiAgOAkJNjk1CTI3ODEJCTIJMzkKICA5CQkzOTEJMTcwOAkJMgkyNwogIDEwCQkw
CTAJCTAJMAogIDExCQk0CTYJCTEJMgogIDEyCQkwCTAJCTAJMAogIDEzCQkwCTAJCTAJMAogIDE0
CQkzODg3CTE3Njk2CQkwCTEyOAogIDE1CQkwCTAJCTAJMAogIDE2CQkxNDcxCTk5NTAJCTEJNDg3
CiAgMTcJCTE2OQkyNjk1CQk5CTExNgogIDE4CQk4MAkzODEJCTIJMTAKClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL0tjb25m
aWcgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9LY29uZmlnIGIvZnMvY2lmcy9LY29uZmlnCmluZGV4
IDdkZTVjODkzYzE4MS4uNzM2NDk1MGE5ZWY0IDEwMDY0NAotLS0gYS9mcy9jaWZzL0tjb25maWcK
KysrIGIvZnMvY2lmcy9LY29uZmlnCkBAIC01OSw2ICs1OSw3IEBAIGNvbmZpZyBDSUZTCiBjb25m
aWcgQ0lGU19TVEFUUzIKIAlib29sICJFeHRlbmRlZCBzdGF0aXN0aWNzIgogCWRlcGVuZHMgb24g
Q0lGUworCWRlZmF1bHQgeQogCWhlbHAKIAkgIEVuYWJsaW5nIHRoaXMgb3B0aW9uIHdpbGwgYWxs
b3cgbW9yZSBkZXRhaWxlZCBzdGF0aXN0aWNzIG9uIFNNQgogCSAgcmVxdWVzdCB0aW1pbmcgdG8g
YmUgZGlzcGxheWVkIGluIC9wcm9jL2ZzL2NpZnMvRGVidWdEYXRhIGFuZCBhbHNvCkBAIC02Nyw4
ICs2OCw3IEBAIGNvbmZpZyBDSUZTX1NUQVRTMgogCSAgZm9yIG1vcmUgZGV0YWlscy4gVGhlc2Ug
YWRkaXRpb25hbCBzdGF0aXN0aWNzIG1heSBoYXZlIGEgbWlub3IgZWZmZWN0CiAJICBvbiBwZXJm
b3JtYW5jZSBhbmQgbWVtb3J5IHV0aWxpemF0aW9uLgogCi0JICBVbmxlc3MgeW91IGFyZSBhIGRl
dmVsb3BlciBvciBhcmUgZG9pbmcgbmV0d29yayBwZXJmb3JtYW5jZSBhbmFseXNpcwotCSAgb3Ig
dHVuaW5nLCBzYXkgTi4KKwkgIElmIHVuc3VyZSwgc2F5IFkuCiAKIGNvbmZpZyBDSUZTX0FMTE9X
X0lOU0VDVVJFX0xFR0FDWQogCWJvb2wgIlN1cHBvcnQgbGVnYWN5IHNlcnZlcnMgd2hpY2ggdXNl
IGxlc3Mgc2VjdXJlIGRpYWxlY3RzIgotLSAKMi4zMC4yCgo=
--000000000000df7b6a05c4482259--
