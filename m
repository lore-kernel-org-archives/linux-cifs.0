Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A710EC3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 05:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70896217F5
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 05:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GefnAJXe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfH1FDH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 01:03:07 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:42677 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfH1FDG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Aug 2019 01:03:06 -0400
Received: by mail-io1-f51.google.com with SMTP id e20so3314101iob.9
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 22:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4j9z9y9SvcPz2jQyvlQNFgNY7UjeD0bmv7SSxcLtAiU=;
        b=GefnAJXemNU6AaZnvQXw9kifehOZZUGZotQZuHhMWDqOwLgJP13amdeoqA8YPOsAV2
         Ar8+PwgKJi6jiA+otTtvStBUgB80igyJIt6A2YE1o2imQZqgHNOCYGmsLuXbkA47LHmz
         SYBmcWT272JsBjU7pysSS+CdLiPvrGX+QVMSILzMs/q/Uy2bfsEht6gWRT688nQYZiiL
         z6WQZ+3d79w/vkJnRRZsermmuWVgh7+BacCU0bN2UmFhTYIaTefPyVuAq0GlVlDJ8AmG
         BWtW8YDlkJEqEjZL0sBPN4Z3rTG6ilIq5PEi8mJ44pg9b6DaLmiJcTXO2pWlGURjSRGp
         oSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4j9z9y9SvcPz2jQyvlQNFgNY7UjeD0bmv7SSxcLtAiU=;
        b=YTBmb++v/BOtAYqo9Em5BQxXww95fSUQcxRa81cRbYMmlAPETobffeEFB9ymezQEUw
         W0rWkkITzkKxZ6KBWk9vW2y8jFwl5c8UACoC2wWnmq2eYuaRRKvFhEDEPjVQW5PRNxDF
         nfUWQhOYHizkV0W+B0egue2t2dWnszk+t1ebc2yZb9YopwdmOgyhC4douB9D48ozkVXX
         Y4sayvmCVKP6Abx48/420AnMTAFeGbtCGIlUOioXQ8pF0ZG4OZybi/BKkmyR8rMocNs9
         slrmLu9prnP+CK9onu3BJbh+aa/At9fAsRlC13oXnlwLx3qD8aezMDkGaXxkQB5VqA0T
         FGcw==
X-Gm-Message-State: APjAAAVUqQ+UKQybXw22G8poo2vv7m9cqT4fi44HH4E2ZonhUWA14DQF
        sXai7vnMfvFadmz4mH5bl/nmjLgIEWDicjQeY0+U2fQn
X-Google-Smtp-Source: APXvYqxQO4f4j9fFb9mawkMhlcEYrTeHetqTgpyJeB+E4/NPj0jYfwBKxOpzC2lNiyXT8UudxIzk2dcHSeNF7WpNxoo=
X-Received: by 2002:a5d:8591:: with SMTP id f17mr2201689ioj.5.1566968585427;
 Tue, 27 Aug 2019 22:03:05 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Aug 2019 00:02:53 -0500
Message-ID: <CAH2r5mu_koRUCV9snYu_A6at8r+kJ85DgFszG4=seEEn+qb0LQ@mail.gmail.com>
Subject: [RFC][SMB3][PATCH] Allow share to be mounted with "cache=ro" if
 immutable share
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e92dd10591264d3e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e92dd10591264d3e
Content-Type: text/plain; charset="UTF-8"

Increases performance a lot in cases where we know that the share is
not changing



-- 
Thanks,

Steve

--000000000000e92dd10591264d3e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-mount-option-to-allow-forced-caching-of-rea.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-mount-option-to-allow-forced-caching-of-rea.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jzusmkrt0>
X-Attachment-Id: f_jzusmkrt0

RnJvbSBhMmM1NmZhMDc3MThlYzdkZTMwODY2OTE5YzdhZTQ0MmE3MmY4YTVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjcgQXVnIDIwMTkgMjM6NTg6NTQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbW91bnQgb3B0aW9uIHRvIGFsbG93IGZvcmNlZCBjYWNoaW5nIG9mIHJlYWQgb25s
eQogc2hhcmUKCklmIGEgc2hhcmUgaXMgaW1tdXRhYmxlIChhdCBsZWFzdCBmb3IgdGhlIHBlcmlv
ZCB0aGF0IGl0IHdpbGwKYmUgbW91bnRlZCkgaXQgd291bGQgYmUgaGVscGZ1bCB0byBub3QgaGF2
ZSB0byByZXZhbGlkYXRlCmRlbnRyaWVzIHJlcGVhdGVkbHkgdGhhdCB3ZSBrbm93IGNhbiBub3Qg
YmUgY2hhbmdlZCByZW1vdGVseS4KCkFkZCAiY2FjaGU9IiBvcHRpb24gKGNhY2hlPXJvKSBmb3Ig
bW91bnRpbmcgcmVhZCBvbmx5IHNoYXJlcwppbiBvcmRlciB0byBpbXByb3ZlIHBlcmZvcm1hbmNl
IGluIGNhc2VzIGluIHdoaWNoIHdlIGtub3cgdGhhdAp0aGUgc2hhcmUgd2lsbCBub3QgYmUgY2hh
bmdpbmcgd2hpbGUgaXQgaXMgaW4gdXNlLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc19mc19zYi5oIHwgIDEgKwog
ZnMvY2lmcy9jaWZzZnMuYyAgICAgfCAgMiArKwogZnMvY2lmcy9jaWZzZ2xvYi5oICAgfCAgMyAr
Ky0KIGZzL2NpZnMvY29ubmVjdC5jICAgIHwgMTQgKysrKysrKysrKysrKysKIDQgZmlsZXMgY2hh
bmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvY2lmc19mc19zYi5oIGIvZnMvY2lmcy9jaWZzX2ZzX3NiLmgKaW5kZXggYjMyNmQyY2EzNzY1
Li4yODZhMTA0YzQ3NjEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc19mc19zYi5oCisrKyBiL2Zz
L2NpZnMvY2lmc19mc19zYi5oCkBAIC01Myw2ICs1Myw3IEBACiAjZGVmaW5lIENJRlNfTU9VTlRf
Tk9fSEFORExFX0NBQ0hFIDB4NDAwMDAwMCAvKiBkaXNhYmxlIGNhY2hpbmcgZGlyIGhhbmRsZXMg
Ki8KICNkZWZpbmUgQ0lGU19NT1VOVF9OT19ERlMgMHg4MDAwMDAwIC8qIGRpc2FibGUgREZTIHJl
c29sdmluZyAqLwogI2RlZmluZSBDSUZTX01PVU5UX01PREVfRlJPTV9TSUQgMHgxMDAwMDAwMCAv
KiByZXRyaWV2ZSBtb2RlIGZyb20gc3BlY2lhbCBBQ0UgKi8KKyNkZWZpbmUgQ0lGU19NT1VOVF9S
T19DQUNIRQkweDIwMDAwMDAwICAvKiBhc3N1bWVzIHNoYXJlIHdpbGwgbm90IGNoYW5nZSAqLwog
CiBzdHJ1Y3QgY2lmc19zYl9pbmZvIHsKIAlzdHJ1Y3QgcmJfcm9vdCB0bGlua190cmVlOwpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXggMzI4OWI1
NjY0NjNmLi45NzAyNTFiYzA2NjEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMKKysrIGIv
ZnMvY2lmcy9jaWZzZnMuYwpAQCAtNDAwLDYgKzQwMCw4IEBAIGNpZnNfc2hvd19jYWNoZV9mbGF2
b3Ioc3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiKQogCQlz
ZXFfcHV0cyhzLCAic3RyaWN0Iik7CiAJZWxzZSBpZiAoY2lmc19zYi0+bW50X2NpZnNfZmxhZ3Mg
JiBDSUZTX01PVU5UX0RJUkVDVF9JTykKIAkJc2VxX3B1dHMocywgIm5vbmUiKTsKKwllbHNlIGlm
IChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfUk9fQ0FDSEUpCisJCXNlcV9w
dXRzKHMsICJybyIpOyAvKiByZWFkIG9ubHkgY2FjaGluZyBhc3N1bWVkICovCiAJZWxzZQogCQlz
ZXFfcHV0cyhzLCAibG9vc2UiKTsKIH0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBi
L2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCBmZTYxMGU3ZTM2NzAuLmYyZWUyMDFlYzk4YSAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAt
NTU5LDYgKzU1OSw3IEBAIHN0cnVjdCBzbWJfdm9sIHsKIAlib29sIHNlcnZlcl9pbm86MTsgLyog
dXNlIGlub2RlIG51bWJlcnMgZnJvbSBzZXJ2ZXIgaWUgVW5pcXVlSWQgKi8KIAlib29sIGRpcmVj
dF9pbzoxOwogCWJvb2wgc3RyaWN0X2lvOjE7IC8qIHN0cmljdCBjYWNoZSBiZWhhdmlvciAqLwor
CWJvb2wgY2FjaGVfcm86MTsKIAlib29sIHJlbWFwOjE7ICAgICAgLyogc2V0IHRvIHJlbWFwIHNl
dmVuIHJlc2VydmVkIGNoYXJzIGluIGZpbGVuYW1lcyAqLwogCWJvb2wgc2Z1X3JlbWFwOjE7ICAv
KiByZW1hcCBzZXZlbiByZXNlcnZlZCBjaGFycyBhbGEgU0ZVICovCiAJYm9vbCBwb3NpeF9wYXRo
czoxOyAvKiB1bnNldCB0byBub3QgYXNrIGZvciBwb3NpeCBwYXRobmFtZXMuICovCkBAIC0xMzY2
LDcgKzEzNjcsNyBAQCB2b2lkIGNpZnNGaWxlSW5mb19wdXQoc3RydWN0IGNpZnNGaWxlSW5mbyAq
Y2lmc19maWxlKTsKICNkZWZpbmUgQ0lGU19DQUNIRV9SV19GTEcJKENJRlNfQ0FDSEVfUkVBRF9G
TEcgfCBDSUZTX0NBQ0hFX1dSSVRFX0ZMRykKICNkZWZpbmUgQ0lGU19DQUNIRV9SSFdfRkxHCShD
SUZTX0NBQ0hFX1JXX0ZMRyB8IENJRlNfQ0FDSEVfSEFORExFX0ZMRykKIAotI2RlZmluZSBDSUZT
X0NBQ0hFX1JFQUQoY2lub2RlKSAoY2lub2RlLT5vcGxvY2sgJiBDSUZTX0NBQ0hFX1JFQURfRkxH
KQorI2RlZmluZSBDSUZTX0NBQ0hFX1JFQUQoY2lub2RlKSAoKGNpbm9kZS0+b3Bsb2NrICYgQ0lG
U19DQUNIRV9SRUFEX0ZMRykgfHwgKENJRlNfU0IoY2lub2RlLT52ZnNfaW5vZGUuaV9zYiktPm1u
dF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9ST19DQUNIRSkpCiAjZGVmaW5lIENJRlNfQ0FDSEVf
SEFORExFKGNpbm9kZSkgKGNpbm9kZS0+b3Bsb2NrICYgQ0lGU19DQUNIRV9IQU5ETEVfRkxHKQog
I2RlZmluZSBDSUZTX0NBQ0hFX1dSSVRFKGNpbm9kZSkgKGNpbm9kZS0+b3Bsb2NrICYgQ0lGU19D
QUNIRV9XUklURV9GTEcpCiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lm
cy9jb25uZWN0LmMKaW5kZXggNGZlNTU5ODIxYWZmLi44MWNlYmY0YzIyNjkgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0yOTgsNiArMjk4
LDcgQEAgZW51bSB7CiAJT3B0X2NhY2hlX2xvb3NlLAogCU9wdF9jYWNoZV9zdHJpY3QsCiAJT3B0
X2NhY2hlX25vbmUsCisJT3B0X2NhY2hlX3JvLAogCU9wdF9jYWNoZV9lcnIKIH07CiAKQEAgLTMw
NSw2ICszMDYsNyBAQCBzdGF0aWMgY29uc3QgbWF0Y2hfdGFibGVfdCBjaWZzX2NhY2hlZmxhdm9y
X3Rva2VucyA9IHsKIAl7IE9wdF9jYWNoZV9sb29zZSwgImxvb3NlIiB9LAogCXsgT3B0X2NhY2hl
X3N0cmljdCwgInN0cmljdCIgfSwKIAl7IE9wdF9jYWNoZV9ub25lLCAibm9uZSIgfSwKKwl7IE9w
dF9jYWNoZV9ybywgInJvIiB9LAogCXsgT3B0X2NhY2hlX2VyciwgTlVMTCB9CiB9OwogCkBAIC0x
NDE4LDE0ICsxNDIwLDIyIEBAIGNpZnNfcGFyc2VfY2FjaGVfZmxhdm9yKGNoYXIgKnZhbHVlLCBz
dHJ1Y3Qgc21iX3ZvbCAqdm9sKQogCWNhc2UgT3B0X2NhY2hlX2xvb3NlOgogCQl2b2wtPmRpcmVj
dF9pbyA9IGZhbHNlOwogCQl2b2wtPnN0cmljdF9pbyA9IGZhbHNlOworCQl2b2wtPmNhY2hlX3Jv
ID0gZmFsc2U7CiAJCWJyZWFrOwogCWNhc2UgT3B0X2NhY2hlX3N0cmljdDoKIAkJdm9sLT5kaXJl
Y3RfaW8gPSBmYWxzZTsKIAkJdm9sLT5zdHJpY3RfaW8gPSB0cnVlOworCQl2b2wtPmNhY2hlX3Jv
ID0gZmFsc2U7CiAJCWJyZWFrOwogCWNhc2UgT3B0X2NhY2hlX25vbmU6CiAJCXZvbC0+ZGlyZWN0
X2lvID0gdHJ1ZTsKIAkJdm9sLT5zdHJpY3RfaW8gPSBmYWxzZTsKKwkJdm9sLT5jYWNoZV9ybyA9
IGZhbHNlOworCQlicmVhazsKKwljYXNlIE9wdF9jYWNoZV9ybzoKKwkJdm9sLT5kaXJlY3RfaW8g
PSBmYWxzZTsKKwkJdm9sLT5zdHJpY3RfaW8gPSBmYWxzZTsKKwkJdm9sLT5jYWNoZV9ybyA9IHRy
dWU7CiAJCWJyZWFrOwogCWRlZmF1bHQ6CiAJCWNpZnNfZGJnKFZGUywgImJhZCBjYWNoZT0gb3B0
aW9uOiAlc1xuIiwgdmFsdWUpOwpAQCAtNDA0MCw2ICs0MDUwLDEwIEBAIGludCBjaWZzX3NldHVw
X2NpZnNfc2Ioc3RydWN0IHNtYl92b2wgKnB2b2x1bWVfaW5mbywKIAkJY2lmc19kYmcoRllJLCAi
bW91bnRpbmcgc2hhcmUgdXNpbmcgZGlyZWN0IGkvb1xuIik7CiAJCWNpZnNfc2ItPm1udF9jaWZz
X2ZsYWdzIHw9IENJRlNfTU9VTlRfRElSRUNUX0lPOwogCX0KKwlpZiAocHZvbHVtZV9pbmZvLT5j
YWNoZV9ybykgeworCQljaWZzX2RiZyhWRlMsICJtb3VudGluZyBzaGFyZSB3aXRoIHJlYWQgb25s
eSBjYWNoaW5nLiBFbnN1cmUgdGhhdCB0aGUgc2hhcmUgd2lsbCBub3QgYmUgbW9kaWZpZWQgd2hp
bGUgaW4gdXNlLlxuIik7CisJCWNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzIHw9IENJRlNfTU9VTlRf
Uk9fQ0FDSEU7CisJfQogCWlmIChwdm9sdW1lX2luZm8tPm1mc3ltbGlua3MpIHsKIAkJaWYgKHB2
b2x1bWVfaW5mby0+c2Z1X2VtdWwpIHsKIAkJCS8qCi0tIAoyLjIwLjEKCg==
--000000000000e92dd10591264d3e--
