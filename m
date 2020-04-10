Return-Path: <SRS0=iSrF=52=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8B5C2BB85
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Apr 2020 03:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3263820A8B
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Apr 2020 03:03:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5WFUSvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDJDDk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Apr 2020 23:03:40 -0400
Received: from mail-yb1-f179.google.com ([209.85.219.179]:45067 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDJDDk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Apr 2020 23:03:40 -0400
Received: by mail-yb1-f179.google.com with SMTP id g6so506012ybh.12
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2020 20:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XgWkK59e6sJoN6LQrG3dAjoc1RUK0RdWfL4SmOfSU5M=;
        b=j5WFUSvfwdkUeHAhYUJUnfn+19SkAqiugLxaCJS/CflK+ku5r/dNdY7YZQheDH4Ul1
         cn2hkQF//rlwdFlWj9mPmHzbnSHli+uKkC8eOjk0OSnvRjtL1lEpBIYOUsXwZLkrtN0G
         n2wNqWIc+skpC09TQdNnOFBX86G1H5uNIvHPYXrgmqB/+rYi2KLspqFLxbYl/T1cqMLZ
         1G5S/3Ue3vFMEXBzTZBldeJGbZmct2YI4ipREFw557KPdYRxoaSes7UV+TDiQ/cwNJPT
         LKdHfK9Ugml9b5o+76gYJwKuZ1YrmeWjc7ekRXA3CDhmoGkTdI6uk5G5j31/uQfnUqSF
         EuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XgWkK59e6sJoN6LQrG3dAjoc1RUK0RdWfL4SmOfSU5M=;
        b=LjQWj+34HTo96aqRK8e6OFKs/ZdWfUUqNBgzDVvQMPLCPNDIccuSyi7S4o5nt0Hq3A
         v6o5MCKuhSoCScPiFEqNCG0GWnHbXFWVT6cG/+977ytdUMlYu6YH86OkJpMzSqX44ui2
         x815R9Xu9uiZnkDmbO9SpnvuZ7uOsZ3rBhGqNdjwZcYqNCYGRjot7kBkceIGoUIkVaWt
         ID6iU7wOahFp6UQrqg52CCem7tMM9H7d/LbscGumOUhbzh9GKnDEGKf3CKZelJrYvD86
         i/eyNQijL9/2lFZPrDls+Z6PV3XAHjDDMV9wzQ2E4j4B0dRyPg1CaXcE5xuFxGWRv4yF
         f5OQ==
X-Gm-Message-State: AGi0Pub9RpSk0LPsIzNLo+WFIPX4PfuxWGyZ+9JZLMuqaL2T2zv9d4yo
        AgIO7aKv6R+ZEAuyYY+Im1koEAOuW1NSXGncrIIedSJVgCY=
X-Google-Smtp-Source: APiQypK0uRi6le57lWG26OB8kdPdBaFjJadqU/cirJFPx0ghgui2d3C/CLrQ6W6nV2GfOZs+NSebN2f0Q1CpX4ExSI8=
X-Received: by 2002:a25:b78b:: with SMTP id n11mr5088645ybh.376.1586487819054;
 Thu, 09 Apr 2020 20:03:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Apr 2020 22:03:28 -0500
Message-ID: <CAH2r5mvuDajrk-_t+ewzmxVnp+=ctSHCew6gdYp9QBTVfDpgEg@mail.gmail.com>
Subject: [PATCH][SMB3] add experimental support for swap over SMB3
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e58d9205a2e6fa15"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e58d9205a2e6fa15
Content-Type: text/plain; charset="UTF-8"

Add experimental support for allowing a swap file to be on an SMB3
mount.  There are use cases where swapping over a secure network
filesystem is preferable. In some cases there are no local
block devices large enough, and network block devices can be
hard to setup and secure.  And in some cases there are no
local block devices at all (e.g. with the recent addition of
remote boot over SMB3 mounts).

There are various enhancements that can be added later e.g.:
- doing a mandatory byte range lock over the swapfile (until
the Linux VFS is modified to notify the file system that an open
is for a swapfile, when the file can be opened "DENY_ALL" to prevent
others from opening it).
- pinning more buffers in the underlying transport to minimize memory
allocations in the TCP stack under the fs
- documenting how to create ACLs (on the server) to secure the
swapfile (or adding additional tools to cifs-utils to make it easier)


-- 
Thanks,

Steve

--000000000000e58d9205a2e6fa15
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-enable-swap-on-SMB3-mounts.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-enable-swap-on-SMB3-mounts.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8tluqiy0>
X-Attachment-Id: f_k8tluqiy0

RnJvbSBiODRmODBjMWZkZWMxOTg5YjE0ZGM0YThhMzJmMTFiNDczZDFjMWI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgOSBBcHIgMjAyMCAyMTo0MjoxOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGVuYWJsZSBzd2FwIG9uIFNNQjMgbW91bnRzCgpBZGQgZXhwZXJpbWVudGFsIHN1cHBvcnQg
Zm9yIGFsbG93aW5nIGEgc3dhcCBmaWxlIHRvIGJlIG9uIGFuIFNNQjMKbW91bnQuICBUaGVyZSBh
cmUgdXNlIGNhc2VzIHdoZXJlIHN3YXBwaW5nIG92ZXIgYSBzZWN1cmUgbmV0d29yawpmaWxlc3lz
dGVtIGlzIHByZWZlcmFibGUuIEluIHNvbWUgY2FzZXMgdGhlcmUgYXJlIG5vIGxvY2FsCmJsb2Nr
IGRldmljZXMgbGFyZ2UgZW5vdWdoLCBhbmQgbmV0d29yayBibG9jayBkZXZpY2VzIGNhbiBiZQpo
YXJkIHRvIHNldHVwIGFuZCBzZWN1cmUuICBBbmQgaW4gc29tZSBjYXNlcyB0aGVyZSBhcmUgbm8K
bG9jYWwgYmxvY2sgZGV2aWNlcyBhdCBhbGwgKGUuZy4gd2l0aCB0aGUgcmVjZW50IGFkZGl0aW9u
IG9mCnJlbW90ZSBib290IG92ZXIgU01CMyBtb3VudHMpLgoKVGhlcmUgYXJlIHZhcmlvdXMgZW5o
YW5jZW1lbnRzIHRoYXQgY2FuIGJlIGFkZGVkIGxhdGVyIGUuZy46Ci0gZG9pbmcgYSBtYW5kYXRv
cnkgYnl0ZSByYW5nZSBsb2NrIG92ZXIgdGhlIHN3YXBmaWxlICh1bnRpbAp0aGUgTGludXggVkZT
IGlzIG1vZGlmaWVkIHRvIG5vdGlmeSB0aGUgZmlsZSBzeXN0ZW0gdGhhdCBhbiBvcGVuCmlzIGZv
ciBhIHN3YXBmaWxlLCB3aGVuIHRoZSBmaWxlIGNhbiBiZSBvcGVuZWQgIkRFTllfQUxMIiB0byBw
cmV2ZW50Cm90aGVycyBmcm9tIG9wZW5pbmcgaXQpLgotIHBpbm5pbmcgbW9yZSBidWZmZXJzIGlu
IHRoZSB1bmRlcmx5aW5nIHRyYW5zcG9ydCB0byBtaW5pbWl6ZSBtZW1vcnkKYWxsb2NhdGlvbnMg
aW4gdGhlIFRDUCBzdGFjayB1bmRlciB0aGUgZnMKLSBkb2N1bWVudGluZyBob3cgdG8gY3JlYXRl
IEFDTHMgKG9uIHRoZSBzZXJ2ZXIpIHRvIHNlY3VyZSB0aGUKc3dhcGZpbGUgKG9yIGFkZGluZyBh
ZGRpdGlvbmFsIHRvb2xzIHRvIGNpZnMtdXRpbHMgdG8gbWFrZSBpdCBlYXNpZXIpCgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+CkFja2VkLWJ5OiBQ
YXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KUmV2aWV3ZWQtYnk6IFJvbm5p
ZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNmcy5jICAg
fCAgNCArKysKIGZzL2NpZnMvY2lmc2dsb2IuaCB8ICAxICsKIGZzL2NpZnMvZmlsZS5jICAgICB8
IDYxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2Np
ZnMvaW5vZGUuYyAgICB8ICA0ICsrKwogNCBmaWxlcyBjaGFuZ2VkLCA3MCBpbnNlcnRpb25zKCsp
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lmc2ZzLmMKaW5kZXgg
OTRlM2VkNDg1MGI1Li5jMzFmMzYyZmEwOTggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmMK
KysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtMTIwOCw2ICsxMjA4LDEwIEBAIHN0YXRpYyBzc2l6
ZV90IGNpZnNfY29weV9maWxlX3JhbmdlKHN0cnVjdCBmaWxlICpzcmNfZmlsZSwgbG9mZl90IG9m
ZiwKIHsKIAl1bnNpZ25lZCBpbnQgeGlkID0gZ2V0X3hpZCgpOwogCXNzaXplX3QgcmM7CisJc3Ry
dWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUgPSBkc3RfZmlsZS0+cHJpdmF0ZV9kYXRhOworCisJaWYg
KGNmaWxlLT5zd2FwZmlsZSkKKwkJcmV0dXJuIC1FT1BOT1RTVVBQOwogCiAJcmMgPSBjaWZzX2Zp
bGVfY29weWNodW5rX3JhbmdlKHhpZCwgc3JjX2ZpbGUsIG9mZiwgZHN0X2ZpbGUsIGRlc3RvZmYs
CiAJCQkJCWxlbiwgZmxhZ3MpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMv
Y2lmcy9jaWZzZ2xvYi5oCmluZGV4IDc0NDhlNzIwMmU3YS4uMDVkZDNkZWE2ODRiIDEwMDY0NAot
LS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCkBAIC0xMzEz
LDYgKzEzMTMsNyBAQCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvIHsKIAlzdHJ1Y3QgdGNvbl9saW5rICp0
bGluazsKIAl1bnNpZ25lZCBpbnQgZl9mbGFnczsKIAlib29sIGludmFsaWRIYW5kbGU6MTsJLyog
ZmlsZSBjbG9zZWQgdmlhIHNlc3Npb24gYWJlbmQgKi8KKwlib29sIHN3YXBmaWxlOjE7CiAJYm9v
bCBvcGxvY2tfYnJlYWtfY2FuY2VsbGVkOjE7CiAJdW5zaWduZWQgaW50IG9wbG9ja19lcG9jaDsg
LyogZXBvY2ggZnJvbSB0aGUgbGVhc2UgYnJlYWsgKi8KIAlfX3UzMiBvcGxvY2tfbGV2ZWw7IC8q
IG9wbG9jay9sZWFzZSBsZXZlbCBmcm9tIHRoZSBsZWFzZSBicmVhayAqLwpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCA1OTIwODIwYmZiZDAuLmI0MGRk
Mzc0ZDZmMyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMK
QEAgLTQ4MDgsNiArNDgwOCw2MCBAQCBjaWZzX2RpcmVjdF9pbyhzdHJ1Y3Qga2lvY2IgKmlvY2Is
IHN0cnVjdCBpb3ZfaXRlciAqaXRlcikKICAgICAgICAgcmV0dXJuIC1FSU5WQUw7CiB9CiAKK3N0
YXRpYyBpbnQgY2lmc19zd2FwX2FjdGl2YXRlKHN0cnVjdCBzd2FwX2luZm9fc3RydWN0ICpzaXMs
CisJCQkgICAgICBzdHJ1Y3QgZmlsZSAqc3dhcF9maWxlLCBzZWN0b3JfdCAqc3BhbikKK3sKKwlz
dHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSA9IHN3YXBfZmlsZS0+cHJpdmF0ZV9kYXRhOworCXN0
cnVjdCBpbm9kZSAqaW5vZGUgPSBzd2FwX2ZpbGUtPmZfbWFwcGluZy0+aG9zdDsKKwl1bnNpZ25l
ZCBsb25nIGJsb2NrczsKKwlsb25nIGxvbmcgaXNpemU7CisKKwljaWZzX2RiZyhGWUksICJzd2Fw
IGFjdGl2YXRlXG4iKTsKKworCXNwaW5fbG9jaygmaW5vZGUtPmlfbG9jayk7CisJYmxvY2tzID0g
aW5vZGUtPmlfYmxvY2tzOworCWlzaXplID0gaW5vZGUtPmlfc2l6ZTsKKwlzcGluX3VubG9jaygm
aW5vZGUtPmlfbG9jayk7CisJaWYgKGJsb2Nrcyo1MTIgPCBpc2l6ZSkgeworCQlwcl93YXJuKCJz
d2FwIGFjdGl2YXRlOiBzd2FwZmlsZSBoYXMgaG9sZXNcbiIpOworCQlyZXR1cm4gLUVJTlZBTDsK
Kwl9CisJKnNwYW4gPSBzaXMtPnBhZ2VzOworCisJcHJpbnRrX29uY2UoS0VSTl9XQVJOSU5HICJT
d2FwIHN1cHBvcnQgb3ZlciBTTUIzIGlzIGV4cGVyaW1lbnRhbFxuIik7CisKKwkvKgorCSAqIFRP
RE86IGNvbnNpZGVyIGFkZGluZyBBQ0wgKG9yIGRvY3VtZW50aW5nIGhvdykgdG8gcHJldmVudCBv
dGhlcgorCSAqIHVzZXJzIChvbiB0aGlzIG9yIG90aGVyIHN5c3RlbXMpIGZyb20gcmVhZGluZyBp
dAorCSAqLworCisKKwkvKiBUT0RPOiBhZGQgc2tfc2V0X21lbWFsbG9jKGluZXQpIG9yIHNpbWls
YXIgKi8KKworCWlmIChjZmlsZSkKKwkJY2ZpbGUtPnN3YXBmaWxlID0gdHJ1ZTsKKwkvKgorCSAq
IFRPRE86IFNpbmNlIGZpbGUgYWxyZWFkeSBvcGVuLCB3ZSBjYW4ndCBvcGVuIHdpdGggREVOWV9B
TEwgaGVyZQorCSAqIGJ1dCB3ZSBjb3VsZCBhZGQgY2FsbCB0byBncmFiIGEgYnl0ZSByYW5nZSBs
b2NrIHRvIHByZXZlbnQgb3RoZXJzCisJICogZnJvbSByZWFkaW5nIG9yIHdyaXRpbmcgdGhlIGZp
bGUKKwkgKi8KKworCXJldHVybiAwOworfQorCitzdGF0aWMgdm9pZCBjaWZzX3N3YXBfZGVhY3Rp
dmF0ZShzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSA9
IGZpbGUtPnByaXZhdGVfZGF0YTsKKworCWNpZnNfZGJnKEZZSSwgInN3YXAgZGVhY3RpdmF0ZVxu
Iik7CisKKwkvKiBUT0RPOiB1bmRvIHNrX3NldF9tZW1hbGxvYyhpbmV0IHdpbGwgZXZlbnR1YWxs
eSBiZSBuZWVkZWQgKi8KKworCWlmIChjZmlsZSkKKwkJY2ZpbGUtPnN3YXBmaWxlID0gZmFsc2U7
CisKKwkvKiBkbyB3ZSBuZWVkIHRvIHVucGluIChvciB1bmxvY2spIHRoZSBmaWxlICovCit9CiAK
IGNvbnN0IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgY2lmc19hZGRyX29wcyA9IHsK
IAkucmVhZHBhZ2UgPSBjaWZzX3JlYWRwYWdlLApAQCAtNDgyMSw2ICs0ODc1LDEzIEBAIGNvbnN0
IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgY2lmc19hZGRyX29wcyA9IHsKIAkuZGly
ZWN0X0lPID0gY2lmc19kaXJlY3RfaW8sCiAJLmludmFsaWRhdGVwYWdlID0gY2lmc19pbnZhbGlk
YXRlX3BhZ2UsCiAJLmxhdW5kZXJfcGFnZSA9IGNpZnNfbGF1bmRlcl9wYWdlLAorCS8qCisJICog
VE9ETzogaW52ZXN0aWdhdGUgYW5kIGlmIHVzZWZ1bCB3ZSBjb3VsZCBhZGQgYW4gY2lmc19taWdy
YXRlUGFnZQorCSAqIGhlbHBlciAodW5kZXIgYW4gQ09ORklHX01JR1JBVElPTikgaW4gdGhlIGZ1
dHVyZSwgYW5kIGFsc28KKwkgKiBpbnZlc3RpZ2F0ZSBhbmQgYWRkIGFuIGlzX2RpcnR5X3dyaXRl
YmFjayBoZWxwZXIgaWYgbmVlZGVkCisJICovCisJLnN3YXBfYWN0aXZhdGUgPSBjaWZzX3N3YXBf
YWN0aXZhdGUsCisJLnN3YXBfZGVhY3RpdmF0ZSA9IGNpZnNfc3dhcF9kZWFjdGl2YXRlLAogfTsK
IAogLyoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRl
eCA4ZDAxZWMyZGNhNjYuLjhmYmJkY2RhZDhmZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5j
CisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjAyNiw2ICsyMDI2LDEwIEBAIGNpZnNfcmV2YWxp
ZGF0ZV9tYXBwaW5nKHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJaW50IHJjOwogCXVuc2lnbmVkIGxv
bmcgKmZsYWdzID0gJkNJRlNfSShpbm9kZSktPmZsYWdzOwogCisJLyogc3dhcGZpbGVzIGFyZSBu
b3Qgc3VwcG9zZWQgdG8gYmUgc2hhcmVkICovCisJaWYgKElTX1NXQVBGSUxFKGlub2RlKSkKKwkJ
cmV0dXJuIDA7CisKIAlyYyA9IHdhaXRfb25fYml0X2xvY2tfYWN0aW9uKGZsYWdzLCBDSUZTX0lO
T19MT0NLLCBjaWZzX3dhaXRfYml0X2tpbGxhYmxlLAogCQkJCSAgICAgVEFTS19LSUxMQUJMRSk7
CiAJaWYgKHJjKQotLSAKMi4yMC4xCgo=
--000000000000e58d9205a2e6fa15--
