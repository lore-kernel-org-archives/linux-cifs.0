Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6316DC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 06:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40ACB611AE
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 06:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhKDGMr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 02:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhKDGMq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 02:12:46 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964C9C061714
        for <linux-cifs@vger.kernel.org>; Wed,  3 Nov 2021 23:10:08 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d12so6325305lfv.6
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 23:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KJt7w9HUtwqjLGuVfMWXu6W69sayYk8QAjyyDHSwDdA=;
        b=qzXxdMbz9w1B77l9kZyfLjD89q2J67SsY3fNFvY3xQrogmQ+disCqfeqoUQxL/8Ges
         0gnnoVYeHBYPQbDwaoIEiFKUAaBHBO2Cgt2gUxE2Oujr3Z1AvjKLOggaZD/GE6qeazrB
         s6s8eL8a/uptlnY7l3kVA+LaR0SjzliL+kTmQWx6UPr8T+zWJtm6la78+YDgErmc3x8c
         flYvQK4G2OTeMMwPghXfbv6xM0g3/4xFVsjwusyndx/0KIxZQco+KykfvacDTIcXCIlY
         anUVRI9fFkHcHa8ejv88jEUd5IMYxEwRndm8YDnDtxfezWgM0yymPqZPsvgZYz5TuK+T
         J/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KJt7w9HUtwqjLGuVfMWXu6W69sayYk8QAjyyDHSwDdA=;
        b=k9Stgm7Zc9gYMYrJOWLAn1HavLDa+dyPgGa3cC4ePEhdTlH+Tr9/P1uFGpAddx6YF2
         3ZHuV152HAMb/vY+UbdR4TToSO4l5CYIbnQUY0Ytx3VuRhOjR+hXjKKPlcwlzxKcFOSC
         WZhjMTelNo6MPjpyUPkl1/MuZDCTMUYOZeK8pVCvQVvrgSnOF4TjRGq+sz0P3o0mGCHQ
         SY9AdnSTJM5AcfJEuFBtxk5hAsvyJToVKdJ679L0aWowXeJkHvM8D8wjXwtqZPD1qWi3
         C5LBnxUXJjfNOK+tg3MVtMH+ezb14izafuzthm9SSoMY0iqOQ5m+jCXBpCJo/s5gmQw0
         6dBg==
X-Gm-Message-State: AOAM533iI8Yb+69juqdZNj20AiMBtlYNXaacgkUyKDny79tUtAZcLYx2
        Z0OFuI358t+A9WsYSpYP2ko7sCfXjxD8z/J2v63tpz0Ql1k=
X-Google-Smtp-Source: ABdhPJwrOBxhWkWlWLelbG49J55727xA1pIMtQsLfk7d9n+7HHaumkWF+SiWRfBIww+G7GA3XSJ/YMI8bE0KFWEYaew=
X-Received: by 2002:ac2:4309:: with SMTP id l9mr44988461lfh.667.1636006206655;
 Wed, 03 Nov 2021 23:10:06 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Nov 2021 01:09:55 -0500
Message-ID: <CAH2r5mtoz_droUOS-Uats_WL6MwFY5-pkHRVZo0nUwLdRjOvcA@mail.gmail.com>
Subject: trace point to print ip address we are trying to connect to
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="000000000000cc6e0105cff06004"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cc6e0105cff06004
Content-Type: text/plain; charset="UTF-8"

It wasn't obvious to me the best way to pass in a pointer to the ipv4
(and ipv6 address) to a dynamic trace point (unless I create a temp
string first in generic_ip_connect and do the conversion (via "%pI4"
and "%pI6" with sprintf) e.g.

        sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);

The approach I tried passing in the pointer to sin_addr (the
ipv4_address) caused an oops on loading it the first time and the
warning:

[14928.818532] event smb3_ipv4_connect has unsafe dereference of argument 3
[14928.818534] print_fmt: "conn_id=0x%llx server=%s addr=%pI4:%d",
REC->conn_id, __get_str(hostname), REC->ipaddr, REC->port


What I tried was the following (also see attached diff) to print the
ipv4 address that we were trying to connect to

DECLARE_EVENT_CLASS(smb3_connect_class,
TP_PROTO(char *hostname,
__u64 conn_id,
__u16 port,
struct in_addr *ipaddr),
TP_ARGS(hostname, conn_id, port, ipaddr),
TP_STRUCT__entry(
__string(hostname, hostname)
__field(__u64, conn_id)
__field(__u16, port)
__field(const void *, ipaddr)
),
TP_fast_assign(
__entry->port = port;
__entry->conn_id = conn_id;
__entry->ipaddr = ipaddr;
__assign_str(hostname, hostname);
),
TP_printk("conn_id=0x%llx server=%s addr=%pI4:%d",
__entry->conn_id,
__get_str(hostname),
__entry->ipaddr,
__entry->port)
)

#define DEFINE_SMB3_CONNECT_EVENT(name)        \
DEFINE_EVENT(smb3_connect_class, smb3_##name,  \
TP_PROTO(char *hostname, \
__u64 conn_id, \
__u16 port, \
struct in_addr *ipaddr), \
TP_ARGS(hostname, conn_id, port, ipaddr))

DEFINE_SMB3_CONNECT_EVENT(ipv4_connect);

Any ideas how to pass in the ipv4 address - or is it better to convert
it to a string before we call the trace point (which seems wasteful to
me but there must be examples of how to pass in structs to printks in
trace in Linux)

-- 
Thanks,

Steve

--000000000000cc6e0105cff06004
Content-Type: text/x-patch; charset="US-ASCII"; name="add-ipv4-trace-point.diff"
Content-Disposition: attachment; filename="add-ipv4-trace-point.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kvkjtjkz0>
X-Attachment-Id: f_kvkjtjkz0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXgg
ZTZlMjYxZGZkMTA3Li40Y2JmY2E5MGE0N2MgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5j
CisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yNTkwLDYgKzI1OTAsOCBAQCBnZW5lcmljX2lw
X2Nvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQlzZmFtaWx5ID0gQUZf
SU5FVDsKIAkJY2lmc19kYmcoRllJLCAiJXM6IGNvbm5lY3RpbmcgdG8gJXBJNDolZFxuIiwgX19m
dW5jX18sICZpcHY0LT5zaW5fYWRkciwKIAkJCQludG9ocyhzcG9ydCkpOworCQl0cmFjZV9zbWIz
X2lwdjRfY29ubmVjdChzZXJ2ZXItPmhvc3RuYW1lLCBzZXJ2ZXItPmNvbm5faWQsCisJCQkJCW50
b2hzKHNwb3J0KSwgJmlwdjQtPnNpbl9hZGRyKTsKIAl9CiAKIAlpZiAoc29ja2V0ID09IE5VTEwp
IHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuaCBiL2ZzL2NpZnMvdHJhY2UuaAppbmRleCBk
YWZjYjZhYjA1MGQuLjMxNjJmNDg0ZmI4NSAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFjZS5oCisr
KyBiL2ZzL2NpZnMvdHJhY2UuaApAQCAtMTEsNyArMTEsNyBAQAogI2RlZmluZSBfQ0lGU19UUkFD
RV9ICiAKICNpbmNsdWRlIDxsaW51eC90cmFjZXBvaW50Lmg+Ci0KKyNpbmNsdWRlIDxsaW51eC9p
bmV0Lmg+CiAvKgogICogUGxlYXNlIHVzZSB0aGlzIDMtcGFydCBhcnRpY2xlIGFzIGEgcmVmZXJl
bmNlIGZvciB3cml0aW5nIG5ldyB0cmFjZXBvaW50czoKICAqIGh0dHBzOi8vbHduLm5ldC9BcnRp
Y2xlcy8zNzk5MDMvCkBAIC04NTQsNiArODU0LDQxIEBAIERFRklORV9FVkVOVChzbWIzX2xlYXNl
X2Vycl9jbGFzcywgc21iM18jI25hbWUsICBcCiAKIERFRklORV9TTUIzX0xFQVNFX0VSUl9FVkVO
VChsZWFzZV9lcnIpOwogCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfY29ubmVjdF9jbGFzcywK
KwlUUF9QUk9UTyhjaGFyICpob3N0bmFtZSwKKwkJX191NjQgY29ubl9pZCwKKwkJX191MTYgcG9y
dCwKKwkJc3RydWN0IGluX2FkZHIgKmlwYWRkciksCisJVFBfQVJHUyhob3N0bmFtZSwgY29ubl9p
ZCwgcG9ydCwgaXBhZGRyKSwKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlfX3N0cmluZyhob3N0bmFt
ZSwgaG9zdG5hbWUpCisJCV9fZmllbGQoX191NjQsIGNvbm5faWQpCisJCV9fZmllbGQoX191MTYs
IHBvcnQpCisJCV9fZmllbGQoY29uc3Qgdm9pZCAqLCBpcGFkZHIpCisJKSwKKwlUUF9mYXN0X2Fz
c2lnbigKKwkJX19lbnRyeS0+cG9ydCA9IHBvcnQ7CisJCV9fZW50cnktPmNvbm5faWQgPSBjb25u
X2lkOworCQlfX2VudHJ5LT5pcGFkZHIgPSBpcGFkZHI7CisJCV9fYXNzaWduX3N0cihob3N0bmFt
ZSwgaG9zdG5hbWUpOworCSksCisJVFBfcHJpbnRrKCJjb25uX2lkPTB4JWxseCBzZXJ2ZXI9JXMg
YWRkcj0lcEk0OiVkIiwKKwkJX19lbnRyeS0+Y29ubl9pZCwKKwkJX19nZXRfc3RyKGhvc3RuYW1l
KSwKKwkJX19lbnRyeS0+aXBhZGRyLAorCQlfX2VudHJ5LT5wb3J0KQorKQorCisjZGVmaW5lIERF
RklORV9TTUIzX0NPTk5FQ1RfRVZFTlQobmFtZSkgICAgICAgIFwKK0RFRklORV9FVkVOVChzbWIz
X2Nvbm5lY3RfY2xhc3MsIHNtYjNfIyNuYW1lLCAgXAorCVRQX1BST1RPKGNoYXIgKmhvc3RuYW1l
LAkJXAorCQlfX3U2NCBjb25uX2lkLAkJCVwKKwkJX191MTYgcG9ydCwJCQlcCisJCXN0cnVjdCBp
bl9hZGRyICppcGFkZHIpLAlcCisJVFBfQVJHUyhob3N0bmFtZSwgY29ubl9pZCwgcG9ydCwgaXBh
ZGRyKSkKKworREVGSU5FX1NNQjNfQ09OTkVDVF9FVkVOVChpcHY0X2Nvbm5lY3QpOworCiBERUNM
QVJFX0VWRU5UX0NMQVNTKHNtYjNfcmVjb25uZWN0X2NsYXNzLAogCVRQX1BST1RPKF9fdTY0CWN1
cnJtaWQsCiAJCV9fdTY0IGNvbm5faWQsCg==
--000000000000cc6e0105cff06004--
