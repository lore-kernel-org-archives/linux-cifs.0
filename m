Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A154FC43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 01:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6687221925
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 01:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HIX64bNb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfCWBB5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 21:01:57 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:42198 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfCWBB4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Mar 2019 21:01:56 -0400
Received: by mail-pf1-f177.google.com with SMTP id r15so2604282pfn.9
        for <linux-cifs@vger.kernel.org>; Fri, 22 Mar 2019 18:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=08a8WZ5tv1n5kaK1zgbkhVuInfOhmCeXnWIJ9t7CUEc=;
        b=HIX64bNb8K3+Jd8bpxLZnXGWGupXyA+H9Qm63/Xz2v2kUEUzcCZKVjXC3HL63pQCUE
         ivZLIpGPt23qQUOmrO/ogImiCDKf/WziRQGOiZ86CB4KsIRwEFOaLvhFo97J17IlHhqm
         M59UW6JFA2ig4JERf2HuPoM+peZhmNVEgx14n9RbrXjJMDYmyWtokNucB+zAAO8G3bj9
         ei5i+q55hIpkAwBgBhvH4LjQB2YYT3hMMaa99iflqSiJqQ55k6L4/mG0VnQKCgvTMSFZ
         UCuHQ8Tw3x+IBBcwK60uqqAlmgNxWdOM1JAwjnrOii2nERqPweFqnLWFZ6e3SXjz8vKd
         W43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=08a8WZ5tv1n5kaK1zgbkhVuInfOhmCeXnWIJ9t7CUEc=;
        b=GuT6ysAHho5f/37J7IFKsJwWDjWvwIhCSloBnqjpdIclNsDtXBF7TX8UIQi0UeNLIo
         WkDkzCRu6VDkoUKBHuAPpKgwpYtfn/owq0eVDzjLrfn+g/SpeTTl2Qv3cPoFDF4WJey+
         mwLNmGBB4uCH5DX6dmp8IkZnqbK0pVhGgRoH78/qAAKoC3b0ZonahVA88p6Nx3OjOezz
         JfNvYeq9B9tIYNHQHsvGFjKx/wbjR7n+rjnQqlsldWGveZWeU+bXc6trZzFZDUZcbteV
         5tIb1IdD+p0VVJXHnltxwtTI8/5pGtJbYBvpV1CFyMIBLFcq5j0maJxOTR949dhbgQ1b
         h9Pg==
X-Gm-Message-State: APjAAAWt9JuVZY5zm2okWfTFrr47ROPUDePf1OeGLaszT3wKGBx0jvS9
        +ruCc0tZ7S7Kh2KWhg4VNelPb/B9t+ugsgUmzwY=
X-Google-Smtp-Source: APXvYqwa1bJfPmIosCWnLwIvjCjGQOyS+4Hpxl/Q0nIZPsIQmf/A4a54SDVygFo3lBceEoI4AMGH4z+K8JxcCyhT4/E=
X-Received: by 2002:a63:c06:: with SMTP id b6mr11824672pgl.440.1553302915519;
 Fri, 22 Mar 2019 18:01:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Mar 2019 20:01:43 -0500
Message-ID: <CAH2r5mvRk9dCu3cwYNrCY8L2jUGR92vKjjiAniMqyPjvzCrV9A@mail.gmail.com>
Subject: [PATCH] Fix guest smb3.1.1 mounts to Samba
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000082356a0584b88456"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000082356a0584b88456
Content-Type: text/plain; charset="UTF-8"

Add to Ronnie's patch check for null user so we can handle guest
mounts for 3.1.1 to Samba as well



-- 
Thanks,

Steve

--00000000000082356a0584b88456
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-Fix-SMB3.1.1-guest-mounts-to-Samba.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-Fix-SMB3.1.1-guest-mounts-to-Samba.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jtksfxdb0>
X-Attachment-Id: f_jtksfxdb0

RnJvbSA1ZjM3N2RkMDgyZmUyNGNlZDdmZDVhOGQzMWQ3ZmFjM2FmNTY4NmI5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjIgTWFyIDIwMTkgMTk6NTI6MjkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBGaXggU01CMy4xLjEgZ3Vlc3QgbW91bnRzIHRvIFNhbWJhCgpXb3JrYXJvdW5kIHByb2Js
ZW0gd2l0aCBTYW1iYSByZXNwb25zZXMgdG8gU01CMy4xLjEKbnVsbCB1c2VyIChndWVzdCkgbW91
bnRzLiAgVGhlIHNlcnZlciBkb2Vzbid0IHNldCB0aGUKZXhwZWN0ZWQgZmxhZyBpbiB0aGUgc2Vz
c2lvbiBzZXR1cCByZXNwb25zZSBzbyB3ZSBoYXZlCnRvIGRvIGEgc2ltaWxhciBjaGVjayB0byB3
aGF0IGlzIGRvbmUgaW4gc21iM192YWxpZGF0ZV9uZWdvdGlhdGUKd2hlcmUgd2UgYWxzbyBjaGVj
ayBpZiB0aGUgdXNlciBpcyBhIG51bGwgdXNlci4KCk5vdGUgdGhhdCB0aGUgY29tbWl0IGJlbG93
IHRpZ2h0ZW5lZCB0aGUgY29uZGl0aW9ucyBhbmQgZm9yY2VkIHNpZ25pbmcKZm9yIHRoZSBTTUIy
LVRyZWVDb25uZWN0IGNvbW1hbmRzIGFzIHBlciBNUy1TTUIyLgpIb3dldmVyLCB0aGlzIHNob3Vs
ZCBvbmx5IGFwcGx5IHRvIG5vcm1hbCB1c2VyIHNlc3Npb25zIGFuZCBub3QgZm9yCmNhc2VzIHdo
ZXJlIHRoZXJlIGlzIG5vIHVzZXIgKGV2ZW4gaWYgc2VydmVyIGZvcmdldHMgdG8gc2V0IHRoZSBm
bGFnCmluIHRoZSByZXNwb25zZSkgc2luY2Ugd2UgZG9uJ3QgaGF2ZSBhbnl0aGluZyB1c2VmdWwg
dG8gc2lnbiB3aXRoLgpUaGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IG5vdyB0aGF0IHRoZSBt
b3JlIHNlY3VyZSBTTUIzLjEuMSBwcm90b2NvbAppcyBpbiB0aGUgZGVmYXVsdCBkaWFsZWN0IGxp
c3QuCgpBbiBlYXJsaWVyIHBhdGNoICgiY2lmczogYWxsb3cgZ3Vlc3QgbW91bnRzIHRvIHdvcmsg
Zm9yIHNtYjMuMTEiKSBmaXhlZAp0aGUgZ3Vlc3QgbW91bnRzIHRvIFdpbmRvd3MuCgogICAgRml4
ZXM6IDYxODhmMjhiZjYwOCAoIlRyZWUgY29ubmVjdCBmb3IgU01CMy4xLjEgbXVzdCBiZSBzaWdu
ZWQgZm9yIG5vbi1lbmNyeXB0ZWQgc2hhcmVzIikKClJldmlld2VkLWJ5OiBSb25uaWUgU2FobGJl
cmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+CkNDOiBTdGFibGUgPHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBi
L2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDhlNGExZGE5NTQxOC4uNGNkZjI2ZTM5NDI2IDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMTYz
MSwxMCArMTYzMSwxMyBAQCBTTUIyX3Rjb24oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfc2VzICpzZXMsIGNvbnN0IGNoYXIgKnRyZWUsCiAJLyoKIAkgKiAzLjExIHRjb24gcmVx
IG11c3QgYmUgc2lnbmVkIGlmIG5vdCBlbmNyeXB0ZWQuIFNlZSBNUy1TTUIyIDMuMi40LjEuMQog
CSAqIHVubGVzcyBpdCBpcyBndWVzdCBvciBhbm9ueW1vdXMgdXNlci4gU2VlIE1TLVNNQjIgMy4y
LjUuMy4xCisJICogKFNhbWJhIHNlcnZlcnMgZG9uJ3QgYWx3YXlzIHNldCB0aGUgZmxhZyBzbyBh
bHNvIGNoZWNrIGlmIG51bGwgdXNlcikKIAkgKi8KIAlpZiAoKHNlcy0+c2VydmVyLT5kaWFsZWN0
ID09IFNNQjMxMV9QUk9UX0lEKSAmJgogCSAgICAhc21iM19lbmNyeXB0aW9uX3JlcXVpcmVkKHRj
b24pICYmCi0JICAgICEoc2VzLT5zZXNzaW9uX2ZsYWdzICYgKFNNQjJfU0VTU0lPTl9GTEFHX0lT
X0dVRVNUfFNNQjJfU0VTU0lPTl9GTEFHX0lTX05VTEwpKSkKKwkgICAgIShzZXMtPnNlc3Npb25f
ZmxhZ3MgJgorCQkgICAgKFNNQjJfU0VTU0lPTl9GTEFHX0lTX0dVRVNUfFNNQjJfU0VTU0lPTl9G
TEFHX0lTX05VTEwpKSAmJgorCSAgICAoc2VzLT51c2VyX25hbWUgIT0gTlVMTCkpCiAJCXJlcS0+
c3luY19oZHIuRmxhZ3MgfD0gU01CMl9GTEFHU19TSUdORUQ7CiAKIAltZW1zZXQoJnJxc3QsIDAs
IHNpemVvZihzdHJ1Y3Qgc21iX3Jxc3QpKTsKLS0gCjIuMTcuMQoK
--00000000000082356a0584b88456--
