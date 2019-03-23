Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E38C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 03:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF898218A2
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 03:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bShM/kGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfCWDfO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 23:35:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33178 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfCWDfO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Mar 2019 23:35:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id i19so2790167pfd.0
        for <linux-cifs@vger.kernel.org>; Fri, 22 Mar 2019 20:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=SwB+FPtHcS8mALoO0JiBdQQntzDYLXFQ5/3aKKMwa9U=;
        b=bShM/kGplaDV28I1AMAlp8x8m600BkQy05HXuRS+VOoUswFJrBY8Y1vVi3RmiW9SBY
         kC/qXt9b/kbeXRYKk1osov0qrYuW6NG/PfnTyiI3ibegzHYgi/+2E+0n/F5XTqX3FXWA
         z1V5+D/BiMmEYi6cOrJkwgWUcgjiw42HX24QtefXoqS+/iuq/Cg+riW3VhgLhsuk1xet
         ROm2h1KsaF/1sWthG6/VXusanyBQcfGPsGXzcY68+pCWD5vqqyXvLz6FTwtMzCU0Rk4f
         1c8RMNBacuJxDnGSU9/AUGPV7RNVaZr8uceZcdItlTWQ8ELQd8g0VpWXWGTgz1HFVw3w
         yfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=SwB+FPtHcS8mALoO0JiBdQQntzDYLXFQ5/3aKKMwa9U=;
        b=ovTzngRGSKzcTU+SWmKwj/CViExEX4kq/GR6rr1+Je0YL/xwQ+aOcIJZWupC3+WMGV
         Sls+YWxqAtHnyKCccm8k6Tzkzhjw8thWuLLuVUpnn13zT7YHtvVn3LxPgkffUay1mNx9
         9tyuUowelh+hlHAv+cLp4YptulqTBf19EXQiQDY16BB3loB7R2CQHvd6UssC+rcsYIQU
         75CSA44gPwVLCxqsBeDQLQfQdU8DwiNpwvUIZxepYW7amuHKYUhKT1ZeRPNyRhsPDNrB
         SbRXtWEdzY8V4uybVrpu4BF5zENzit8tMNiicO0URylHgOROpIQapGmDkSomlQQb+i72
         sEdg==
X-Gm-Message-State: APjAAAX7ie8q66jsDvgzU5GrwYHIe0+HUpE0nvuOFvgGiCpbnUuVlAoh
        hPIudPa1mpRKdQU0DnB50nmpmYMib3qHEqTP1kYu/g==
X-Google-Smtp-Source: APXvYqwOzS7xogPeJ015pFEhaI4gMBWNTroMH3C6yL/GRX5XCKurj8KroYa4fQz3VJlHiA8BDmMO/mWaOw6qXoOh/DQ=
X-Received: by 2002:a65:508b:: with SMTP id r11mr12321184pgp.242.1553312113077;
 Fri, 22 Mar 2019 20:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvRk9dCu3cwYNrCY8L2jUGR92vKjjiAniMqyPjvzCrV9A@mail.gmail.com>
In-Reply-To: <CAH2r5mvRk9dCu3cwYNrCY8L2jUGR92vKjjiAniMqyPjvzCrV9A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Mar 2019 22:35:01 -0500
Message-ID: <CAH2r5ms_Md9UOsM5x0ACamTz2Zhiu0+HVVzZJF2PGzqyXNY_1g@mail.gmail.com>
Subject: Re: [PATCH] Fix guest smb3.1.1 mounts to Samba
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b9d9430584baa87f"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b9d9430584baa87f
Content-Type: text/plain; charset="UTF-8"

Version 2 of patch added additional check that it is not krb5 mount
when username is null


On Fri, Mar 22, 2019 at 8:01 PM Steve French <smfrench@gmail.com> wrote:
>
> Add to Ronnie's patch check for null user so we can handle guest
> mounts for 3.1.1 to Samba as well
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000b9d9430584baa87f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Fix-SMB3.1.1-guest-mounts-to-Samba.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Fix-SMB3.1.1-guest-mounts-to-Samba.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtkxwxo10>
X-Attachment-Id: f_jtkxwxo10

RnJvbSA0OWJjOTNkYzMzNzFiOTA2OGUxYzk3M2Y1MTY5YWI5NmMwNjhhNzg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjIgTWFyIDIwMTkgMjI6MzE6MTcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBGaXggU01CMy4xLjEgZ3Vlc3QgbW91bnRzIHRvIFNhbWJhCgpXb3JrYXJvdW5kIHByb2Js
ZW0gd2l0aCBTYW1iYSByZXNwb25zZXMgdG8gU01CMy4xLjEKbnVsbCB1c2VyIChndWVzdCkgbW91
bnRzLiAgVGhlIHNlcnZlciBkb2Vzbid0IHNldCB0aGUKZXhwZWN0ZWQgZmxhZyBpbiB0aGUgc2Vz
c2lvbiBzZXR1cCByZXNwb25zZSBzbyB3ZSBoYXZlCnRvIGRvIGEgc2ltaWxhciBjaGVjayB0byB3
aGF0IGlzIGRvbmUgaW4gc21iM192YWxpZGF0ZV9uZWdvdGlhdGUKd2hlcmUgd2UgYWxzbyBjaGVj
ayBpZiB0aGUgdXNlciBpcyBhIG51bGwgdXNlciAoYnV0IG5vdCBzZWM9a3JiNQpzaW5jZSB1c2Vy
bmFtZSBtaWdodCBub3QgYmUgcGFzc2VkIGluIG9uIG1vdW50IGZvciBLZXJiZXJvcyBjYXNlKS4K
Ck5vdGUgdGhhdCB0aGUgY29tbWl0IGJlbG93IHRpZ2h0ZW5lZCB0aGUgY29uZGl0aW9ucyBhbmQg
Zm9yY2VkIHNpZ25pbmcKZm9yIHRoZSBTTUIyLVRyZWVDb25uZWN0IGNvbW1hbmRzIGFzIHBlciBN
Uy1TTUIyLgpIb3dldmVyLCB0aGlzIHNob3VsZCBvbmx5IGFwcGx5IHRvIG5vcm1hbCB1c2VyIHNl
c3Npb25zIGFuZCBub3QgZm9yCmNhc2VzIHdoZXJlIHRoZXJlIGlzIG5vIHVzZXIgKGV2ZW4gaWYg
c2VydmVyIGZvcmdldHMgdG8gc2V0IHRoZSBmbGFnCmluIHRoZSByZXNwb25zZSkgc2luY2Ugd2Ug
ZG9uJ3QgaGF2ZSBhbnl0aGluZyB1c2VmdWwgdG8gc2lnbiB3aXRoLgpUaGlzIGlzIGVzcGVjaWFs
bHkgaW1wb3J0YW50IG5vdyB0aGF0IHRoZSBtb3JlIHNlY3VyZSBTTUIzLjEuMSBwcm90b2NvbApp
cyBpbiB0aGUgZGVmYXVsdCBkaWFsZWN0IGxpc3QuCgpBbiBlYXJsaWVyIHBhdGNoICgiY2lmczog
YWxsb3cgZ3Vlc3QgbW91bnRzIHRvIHdvcmsgZm9yIHNtYjMuMTEiKSBmaXhlZAp0aGUgZ3Vlc3Qg
bW91bnRzIHRvIFdpbmRvd3MuCgogICAgRml4ZXM6IDYxODhmMjhiZjYwOCAoIlRyZWUgY29ubmVj
dCBmb3IgU01CMy4xLjEgbXVzdCBiZSBzaWduZWQgZm9yIG5vbi1lbmNyeXB0ZWQgc2hhcmVzIikK
ClJldmlld2VkLWJ5OiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+CkNDOiBT
dGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5j
aCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8IDUgKysr
Ky0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDhlNGEx
ZGE5NTQxOC4uMjFhYzE5ZmYxOWNiIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysg
Yi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMTYzMSwxMCArMTYzMSwxMyBAQCBTTUIyX3Rjb24oY29u
c3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsIGNvbnN0IGNoYXIgKnRy
ZWUsCiAJLyoKIAkgKiAzLjExIHRjb24gcmVxIG11c3QgYmUgc2lnbmVkIGlmIG5vdCBlbmNyeXB0
ZWQuIFNlZSBNUy1TTUIyIDMuMi40LjEuMQogCSAqIHVubGVzcyBpdCBpcyBndWVzdCBvciBhbm9u
eW1vdXMgdXNlci4gU2VlIE1TLVNNQjIgMy4yLjUuMy4xCisJICogKFNhbWJhIHNlcnZlcnMgZG9u
J3QgYWx3YXlzIHNldCB0aGUgZmxhZyBzbyBhbHNvIGNoZWNrIGlmIG51bGwgdXNlcikKIAkgKi8K
IAlpZiAoKHNlcy0+c2VydmVyLT5kaWFsZWN0ID09IFNNQjMxMV9QUk9UX0lEKSAmJgogCSAgICAh
c21iM19lbmNyeXB0aW9uX3JlcXVpcmVkKHRjb24pICYmCi0JICAgICEoc2VzLT5zZXNzaW9uX2Zs
YWdzICYgKFNNQjJfU0VTU0lPTl9GTEFHX0lTX0dVRVNUfFNNQjJfU0VTU0lPTl9GTEFHX0lTX05V
TEwpKSkKKwkgICAgIShzZXMtPnNlc3Npb25fZmxhZ3MgJgorCQkgICAgKFNNQjJfU0VTU0lPTl9G
TEFHX0lTX0dVRVNUfFNNQjJfU0VTU0lPTl9GTEFHX0lTX05VTEwpKSAmJgorCSAgICAoKHNlcy0+
dXNlcl9uYW1lICE9IE5VTEwpIHx8IChzZXMtPnNlY3R5cGUgPT0gS2VyYmVyb3MpKSkKIAkJcmVx
LT5zeW5jX2hkci5GbGFncyB8PSBTTUIyX0ZMQUdTX1NJR05FRDsKIAogCW1lbXNldCgmcnFzdCwg
MCwgc2l6ZW9mKHN0cnVjdCBzbWJfcnFzdCkpOwotLSAKMi4xNy4xCgo=
--000000000000b9d9430584baa87f--
