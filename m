Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94916CDB474
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Oct 2023 04:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjJTEct (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Oct 2023 00:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjJTEcs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Oct 2023 00:32:48 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1861A8
        for <linux-cifs@vger.kernel.org>; Thu, 19 Oct 2023 21:32:46 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-5079f6efd64so450952e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Oct 2023 21:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697776364; x=1698381164; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cJ8v4thUWvHEDZGBSVKt08OJQRuQ1zq3oUS8VnC3WW8=;
        b=eDJolx0LtSHDJqde6Y6YdYCXZfxQh8BIAE00vquKbwDrV9NmL7IXzQzXGWPnMxYhyV
         EDYCJlIoSkd80ShOutI5lO15xnFyDmkfzv/xDM+oQJ/r/o3ZKAg+1uXAdEnLLcqCVyP7
         KrlcWSseo41JhGZ8JIQN03A2N8hQmEdbZr1J0wWdKbLbGkXvHRlEgMPtjkrfW+nE8yzx
         SX8MJzayXNJhwhhx8wWKN0/Zv5bo92D2qQF6mwFVTbkG+bDcxNBzQA4mrruNh7oZ6vBY
         XX/9A8668nmjxc7Ng7COD3HIx9zEmc9CxB0hGSQrI4DQ6oUlfsAInzWSqvVGHOf6XBm1
         WECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697776364; x=1698381164;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cJ8v4thUWvHEDZGBSVKt08OJQRuQ1zq3oUS8VnC3WW8=;
        b=edDGtPNRzBnKbNdELetBcd8xmNfQIGOKEekwRCmDl05/R96Cjs1EpRMgzQLRAdwY2s
         tLtoSFh95pCDZ7bWQTgMLJiyhNNkwV2Ua1zcRiQDqQQB6vZz9VB2oO2DUgLZIGRJLc5I
         mgKb2ksF4HzBSMXL6N/C2SFMDMCPm2w+82GfC9FaoMnCG7GpW+ceAqorhs7Ssti+gXEN
         kEzUJa+lV2gtCbFWdTIgOXgh9I2cCknKW3nx+ldidc8bZvzAapZiPZqxnmDziUEjchh6
         /EkB+AO0YmnZ8pkctaCqwlsrJyuLLmEqvY5oJCxrOAI/gGvdVA+xwaETJyog50Ea2Z/p
         NPkA==
X-Gm-Message-State: AOJu0Yz+/nINfZugAd9UJRN8eDo14cGgwp/IvynbO9UseobN1YN5UUUv
        pSA5XsNn9pCe4qogY+GoHcBdnjLftFDmt3MR8thFEmuxbcKzEA==
X-Google-Smtp-Source: AGHT+IGOTp69NW4A0m+s+fQ2mKgb9bjJnQ0wIIGs9YAWSl20SJpg6PtVkApnjMt1DQrniZvXq0BsY77uLtNki/boFsc=
X-Received: by 2002:ac2:5548:0:b0:507:9996:f62b with SMTP id
 l8-20020ac25548000000b005079996f62bmr395168lfk.56.1697776363599; Thu, 19 Oct
 2023 21:32:43 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 19 Oct 2023 23:32:32 -0500
Message-ID: <CAH2r5mvve4euMUqsBBqRr2VWgz7ukEZ15vZRVDO=zbzY=XhF1Q@mail.gmail.com>
Subject: [PATCH][CIFS] allow creating FIFOs when "sfu" mount option specified
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000000f92e306081e5d0b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000000f92e306081e5d0b
Content-Type: text/plain; charset="UTF-8"

mb3: fix creating FIFOs when mounting with "sfu" mount
 option

Fixes some xfstests including generic/564 and generic/157

The "sfu" mount option can be useful for creating special files (character
and block devices in particular) but could not create FIFOs. It did
recognize existing empty files with the "system" attribute flag as FIFOs
but this is too general, so to support creating FIFOs more safely use a new
tag (but the same length as those for char and block devices ie "IntxLNK"
and "IntxBLK") "LnxFIFO" to indicate that the file should be treated as a
FIFO (when mounted with the "sfu").   For some additional context note that
"sfu" followed the way that "Services for Unix" on Windows handled these
special files (at least for character and block devices and symlinks),
which is different than newer Windows which can handle special files
as reparse points (which isn't an option to many servers).

See attached.

-- 
Thanks,

Steve

--0000000000000f92e306081e5d0b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-creating-FIFOs-when-mounting-with-sfu-mount.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-creating-FIFOs-when-mounting-with-sfu-mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lny46ebi0>
X-Attachment-Id: f_lny46ebi0

RnJvbSBhNzg4ZGUzMjUyNTUyYWJlYWNiNzU3ZjU1NDczMTZjZWQ3MTcwOTExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTkgT2N0IDIwMjMgMjM6MDE6NDkgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggY3JlYXRpbmcgRklGT3Mgd2hlbiBtb3VudGluZyB3aXRoICJzZnUiIG1vdW50CiBv
cHRpb24KCkZpeGVzIHNvbWUgeGZzdGVzdHMgaW5jbHVkaW5nIGdlbmVyaWMvNTY0IGFuZCBnZW5l
cmljLzE1NwoKVGhlICJzZnUiIG1vdW50IG9wdGlvbiBjYW4gYmUgdXNlZnVsIGZvciBjcmVhdGlu
ZyBzcGVjaWFsIGZpbGVzIChjaGFyYWN0ZXIKYW5kIGJsb2NrIGRldmljZXMgaW4gcGFydGljdWxh
cikgYnV0IGNvdWxkIG5vdCBjcmVhdGUgRklGT3MuIEl0IGRpZApyZWNvZ25pemUgZXhpc3Rpbmcg
ZW1wdHkgZmlsZXMgd2l0aCB0aGUgInN5c3RlbSIgYXR0cmlidXRlIGZsYWcgYXMgRklGT3MKYnV0
IHRoaXMgaXMgdG9vIGdlbmVyYWwsIHNvIHRvIHN1cHBvcnQgY3JlYXRpbmcgRklGT3MgbW9yZSBz
YWZlbHkgdXNlIGEgbmV3CnRhZyAoYnV0IHRoZSBzYW1lIGxlbmd0aCBhcyB0aG9zZSBmb3IgY2hh
ciBhbmQgYmxvY2sgZGV2aWNlcyBpZSAiSW50eExOSyIKYW5kICJJbnR4QkxLIikgIkxueEZJRk8i
IHRvIGluZGljYXRlIHRoYXQgdGhlIGZpbGUgc2hvdWxkIGJlIHRyZWF0ZWQgYXMgYQpGSUZPICh3
aGVuIG1vdW50ZWQgd2l0aCB0aGUgInNmdSIpLiAgIEZvciBzb21lIGFkZGl0aW9uYWwgY29udGV4
dCBub3RlIHRoYXQKInNmdSIgZm9sbG93ZWQgdGhlIHdheSB0aGF0ICJTZXJ2aWNlcyBmb3IgVW5p
eCIgb24gV2luZG93cyBoYW5kbGVkIHRoZXNlCnNwZWNpYWwgZmlsZXMgKGF0IGxlYXN0IGZvciBj
aGFyYWN0ZXIgYW5kIGJsb2NrIGRldmljZXMgYW5kIHN5bWxpbmtzKSwKd2hpY2ggaXMgZGlmZmVy
ZW50IHRoYW4gbmV3ZXIgV2luZG93cyB3aGljaCBjYW4gaGFuZGxlIHNwZWNpYWwgZmlsZXMKYXMg
cmVwYXJzZSBwb2ludHMgKHdoaWNoIGlzbid0IGFuIG9wdGlvbiB0byBtYW55IHNlcnZlcnMpLgoK
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc3BkdS5oIHwgMiAr
LQogZnMvc21iL2NsaWVudC9pbm9kZS5jICAgfCA0ICsrKysKIGZzL3NtYi9jbGllbnQvc21iMm9w
cy5jIHwgOCArKysrKysrLQogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc3BkdS5oIGIvZnMvc21i
L2NsaWVudC9jaWZzcGR1LmgKaW5kZXggZTE3MjIyZmVjOWQyLi5hNzUyMjBkYjVjMWUgMTAwNjQ0
Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc3BkdS5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc3Bk
dS5oCkBAIC0yNTcwLDcgKzI1NzAsNyBAQCB0eXBlZGVmIHN0cnVjdCB7CiAKIAogc3RydWN0IHdp
bl9kZXYgewotCXVuc2lnbmVkIGNoYXIgdHlwZVs4XTsgLyogSW50eENIUiBvciBJbnR4QkxLICov
CisJdW5zaWduZWQgY2hhciB0eXBlWzhdOyAvKiBJbnR4Q0hSIG9yIEludHhCTEsgb3IgTG54RklG
TyovCiAJX19sZTY0IG1ham9yOwogCV9fbGU2NCBtaW5vcjsKIH0gX19hdHRyaWJ1dGVfXygocGFj
a2VkKSk7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lub2RlLmMgYi9mcy9zbWIvY2xpZW50
L2lub2RlLmMKaW5kZXggZDdjMzAyNDQyYzFlLi5jMDNhMjg2ZWQ0MTggMTAwNjQ0Ci0tLSBhL2Zz
L3NtYi9jbGllbnQvaW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMKQEAgLTU5Miw2
ICs1OTIsMTAgQEAgY2lmc19zZnVfdHlwZShzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsIGNvbnN0
IGNoYXIgKnBhdGgsCiAJCQljaWZzX2RiZyhGWUksICJTeW1saW5rXG4iKTsKIAkJCWZhdHRyLT5j
Zl9tb2RlIHw9IFNfSUZMTks7CiAJCQlmYXR0ci0+Y2ZfZHR5cGUgPSBEVF9MTks7CisJCX0gZWxz
ZSBpZiAobWVtY21wKCJMbnhGSUZPIiwgcGJ1ZiwgOCkgPT0gMCkgeworCQkJY2lmc19kYmcoRllJ
LCAiRklGT1xuIik7CisJCQlmYXR0ci0+Y2ZfbW9kZSB8PSBTX0lGSUZPOworCQkJZmF0dHItPmNm
X2R0eXBlID0gRFRfRklGTzsKIAkJfSBlbHNlIHsKIAkJCWZhdHRyLT5jZl9tb2RlIHw9IFNfSUZS
RUc7IC8qIGZpbGU/ICovCiAJCQlmYXR0ci0+Y2ZfZHR5cGUgPSBEVF9SRUc7CmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4
IDlhZWVjZWU2YjkxYi4uMjg5ODVkYzgxYzA5IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3Nt
YjJvcHMuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwpAQCAtNTA4Nyw3ICs1MDg3LDcg
QEAgc21iMl9tYWtlX25vZGUodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGlub2RlICppbm9kZSwK
IAkgKiBvdmVyIFNNQjIvU01CMyBhbmQgU2FtYmEgd2lsbCBkbyB0aGlzIHdpdGggU01CMy4xLjEg
UE9TSVggRXh0ZW5zaW9ucwogCSAqLwogCi0JaWYgKCFTX0lTQ0hSKG1vZGUpICYmICFTX0lTQkxL
KG1vZGUpKQorCWlmICghU19JU0NIUihtb2RlKSAmJiAhU19JU0JMSyhtb2RlKSAmJiAhU19JU0ZJ
Rk8obW9kZSkpCiAJCXJldHVybiByYzsKIAogCWNpZnNfZGJnKEZZSSwgInNmdSBjb21wYXQgY3Jl
YXRlIHNwZWNpYWwgZmlsZVxuIik7CkBAIC01MTM1LDYgKzUxMzUsMTIgQEAgc21iMl9tYWtlX25v
ZGUodW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGlub2RlICppbm9kZSwKIAkJcGRldi0+bWlub3Ig
PSBjcHVfdG9fbGU2NChNSU5PUihkZXYpKTsKIAkJcmMgPSB0Y29uLT5zZXMtPnNlcnZlci0+b3Bz
LT5zeW5jX3dyaXRlKHhpZCwgJmZpZCwgJmlvX3Bhcm1zLAogCQkJCQkJCSZieXRlc193cml0dGVu
LCBpb3YsIDEpOworCX0gZWxzZSBpZiAoU19JU0JMSyhtb2RlKSkgeworCQltZW1jcHkocGRldi0+
dHlwZSwgIkxueEZJRk8iLCA4KTsKKwkJcGRldi0+bWFqb3IgPSAwOworCQlwZGV2LT5taW5vciA9
IDA7CisJCXJjID0gdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+c3luY193cml0ZSh4aWQsICZmaWQs
ICZpb19wYXJtcywKKwkJCQkJCQkmYnl0ZXNfd3JpdHRlbiwgaW92LCAxKTsKIAl9CiAJdGNvbi0+
c2VzLT5zZXJ2ZXItPm9wcy0+Y2xvc2UoeGlkLCB0Y29uLCAmZmlkKTsKIAlkX2Ryb3AoZGVudHJ5
KTsKLS0gCjIuMzkuMgoK
--0000000000000f92e306081e5d0b--
