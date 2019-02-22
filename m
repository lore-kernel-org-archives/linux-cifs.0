Return-Path: <SRS0=FePp=Q5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722F9C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 15:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DC522075A
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 15:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfBVP3a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:29:30 -0500
Received: from ul-exc-pr-as02.ulaval.ca ([132.203.244.30]:56849 "EHLO
        ul-exc-pr-as02.ulaval.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfBVP3a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Feb 2019 10:29:30 -0500
Received: from ul-exc-pr-edg01.ulaval.ca ([132.203.244.26])
  by ul-exc-pr-as02.ulaval.ca with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2019 10:29:24 -0500
Received: from UL-EXC-PR-MBX19.ulaval.ca (10.40.67.119) by
 UL-EXC-PR-EDG01.ulaval.ca (132.203.244.26) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Fri, 22 Feb 2019 10:29:21 -0500
Received: from UL-EXC-PR-MBX20.ulaval.ca (10.40.67.120) by
 UL-EXC-PR-MBX19.ulaval.ca (10.40.67.119) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 22 Feb 2019 10:29:24 -0500
Received: from UL-EXC-PR-MBX20.ulaval.ca ([fe80::5d31:55ba:ae63:96d4]) by
 UL-EXC-PR-MBX20.ulaval.ca ([fe80::5d31:55ba:ae63:96d4%22]) with mapi id
 15.00.1395.000; Fri, 22 Feb 2019 10:29:24 -0500
From:   =?utf-8?B?QWxleGlzIEZvcnRpbi1Dw7R0w6k=?= 
        <alexis.fortin-cote.1@ulaval.ca>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: mount -t cifs fails while smbclient succeed
Thread-Topic: mount -t cifs fails while smbclient succeed
Thread-Index: AQHUyrzXfCa6KTecaEaRGQ0BBWS51qXr8SPB
Date:   Fri, 22 Feb 2019 15:29:24 +0000
Message-ID: <1550849364135.34775@ulaval.ca>
References: <637c6227392d4f67b76aa6ebb8b71d0c@UL-EXC-PR-MBX20.ulaval.ca>
In-Reply-To: <637c6227392d4f67b76aa6ebb8b71d0c@UL-EXC-PR-MBX20.ulaval.ca>
Accept-Language: fr-CA, en-US
Content-Language: fr-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.40.104.18]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

CuKAi0hpLApJIGhhdmUgdHJvdWJsZSBtb3VudGluZyBhIHdpbmRvd3Mgc2hhcmUgb24gbXkgVWJ1
bnR1IDE4LjA0IHdvcmtzdGF0aW9uLgpJJ3ZlIHRyaWVkIGV2ZXJ5IHRoaW5nIEkgZm91bmQgdXNp
bmcgZ29vZ2xlIHNlYXJjaCB0byBubyBhdmFpbC4KClRoZSBmb2xsb3dpbmcgc21iY2xpZW50IGNv
bW1hbmQgd29ya3MsIHNvIEkga25vdyBteSBVc2VybmFtZSBhbmQgUGFzc3dvcmQgYXJlIHdvcmtp
bmcKc21iY2xpZW50IC1VIHVsYXZhbC5jYVxcYWxmb2MgLy8xMzIuMjAzLjIzNS4xNS9QYXJ0YWdl
cy9GU1MKCkJ1dCB0aGUgZm9sbG93aW5nIG1vdW50IGZhaWxzIHdpdGggZXJyb3JzIDoKc3VkbyBt
b3VudCAtdCBjaWZzIC1vIGNyZWQ9L2hvbWUvYWxleGlzL3NtYmNyZWQsdmVycz0yLjAgLy9mc3Nk
YzEuZnNzLnVsYXZhbC5jYS9QYXJ0YWdlcy9GU1MvIC9ob21lL2FsZXhpcy93aW4vCgptb3VudCBl
cnJvcigyMik6IEludmFsaWQgYXJndW1lbnQKCkkndmUgbG9nZ2VkIHRoZSBmYWlsaW5nIGFuZCBz
dWNjZXNzZnVsIHRyYWNlIHdpdGggd2lyZXNoYXJrCmZhaWxlZCA6wqBodHRwczovL3Bhc3RlYmlu
LmNvbS83VVRCTmdzMgpzdWNjZXNzIDrCoGh0dHBzOi8vcGFzdGViaW4uY29tL2tRODB2Vm1yCgpJ
J20gdXNpbmcgS2VybmVsIDQuMjAuMTEtMDQyMDExLWdlbmVyaWMKSSdtIG5vdCBzdXJlIGFib3V0
IHRoZSBzZXJ2ZXIgY29uZmlndXJhdGlvbiwgYnV0IGl0IGxvb2tzIGxpa2UgaXRzIGEgd2luZG93
cyBzZXJ2ZXIgdGhhdCBzdXBwb3J0IHNtYiB2ZXJzPTEuMCBhbmQgdmVycz0yLjAKbW91bnQuY2lm
cyB2ZXJzaW9uOiA2LjgKCmRtZXNnIHdpdGggZGVidWcgaW5mb3JtYXRpb24gcmVhZHMgd2hlbiBp
dCBmYWlsczoKWyAyMDIxLjY1MjMyNF0gU3RhdHVzIGNvZGUgcmV0dXJuZWQgMHhjMDAwMDAxNiBT
VEFUVVNfTU9SRV9QUk9DRVNTSU5HX1JFUVVJUkVEClsgMjAyMS42Njc3NDhdIENJRlMgVkZTOiBE
RlMgY2FwYWJpbGl0eSBjb250cmFkaWN0cyBERlMgZmxhZwpbIDIwMjEuNjczMTY4XSBTdGF0dXMg
Y29kZSByZXR1cm5lZCAweGMwMDAwMjU3IFNUQVRVU19QQVRIX05PVF9DT1ZFUkVEClsgMjAyMS42
NzUwMDFdIENJRlMgVkZTOiBjaWZzX21vdW50IGZhaWxlZCB3L3JldHVybiBjb2RlID0gLTIyCgpU
aGFua3MgZm9yIGhlbHBpbmcsClBsZWFzZSByZXNwb25kIChjYykgdG8gdGhpcyBhZGRyZXNzLuKA
iwoKQWxleAoKICAgIA==
