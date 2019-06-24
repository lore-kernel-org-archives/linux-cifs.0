Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE343C43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 18:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7760020645
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 18:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUbFgaPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725268AbfFXSXT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 14:23:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39832 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732808AbfFXSXS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 14:23:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so8002412pfe.6
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 11:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=XZG3KHUU9tWGT+lfGD6s4TazO6o5hwnYBiZTyqgYqE4=;
        b=hUbFgaPOuh4lbMgnRG3gEC/cJQPnbHBfgJjJ5vyRjPkoWsd37Oo8QgBHkr4GlSpElA
         /BPWbywXAxElMecO5q7Ktga6rtTbWpviEH0IMKLwWqWa8hNFvIsCS8tvT08NX8S/cyAH
         iv+B+gKfz+M5SLvOZKzfCaUQrUdhqU/96K75E8Kdhm5nQFVblhBoGr5FazzZHD/Abc2B
         myx+kDVYuT2kNNV9wyCrOUJArRRf5uJj/LnHJDQuqF7IyIwqtjNGsil9KaZye/FWXwNe
         xW+SIzviZbb2Pls9gQ8L6YXNhRcLYXTNP3HiJd5XWQyKecxzEOE2u/AsySIlUIC8Pb0I
         iEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=XZG3KHUU9tWGT+lfGD6s4TazO6o5hwnYBiZTyqgYqE4=;
        b=ZQVNFvncT3UYGwUYC0RQhI/YmQMPkm6ukUOqqdq4SP4O7cgud7IdiqZ9/t6FdDmjD9
         YT10ukLcNLL0/MF1gd2f6yxkIpNbvcVESB2aU+O1e4XT3P+jHGI9bUf7yR0DZi0Nq+tK
         WbWoK6ps/LpyCC/Wzoq8dLbQVYpIVQtNlbmz8sz64pAwdvSR+fHKZRMRD1gW34vOkE9I
         k3kepuBfhxO8Fq6qXWLJfLClocI3tseItYPAr3jEza63o9Sa81si0MctI5UF4ygqho/X
         V/qrsJPcjRJDnTmGoRvkzw+KpzR4/GipJxxnhd3Q3aeBP+15B8FdrHfd9DuOWe59llbu
         d00A==
X-Gm-Message-State: APjAAAVPq0/1c8/o8XIBF3LF07PdbkNuFjyc2wU37IWQFCpC//FiU2fn
        uSAjLvd5Qq2e7AS6yDHCxpIkkii3HcMDNf4ev5resg==
X-Google-Smtp-Source: APXvYqypHndpZRGG4XDx9BW+8u35/f5nAm+175EGZRAQQgfuX6ujMxXbkQGI4Eax89lma62/vlJR3iXAzDiHx3KT8bU=
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr27120255pje.12.1561400597113;
 Mon, 24 Jun 2019 11:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
In-Reply-To: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 13:23:06 -0500
Message-ID: <CAH2r5muF+bppZPXFKq2qMc=muVEmg30455M_EXjDZhf6r_i0tQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] add mount option to allow retrieving POSIX mode
 from special ACE
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000f1adac058c15e771"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000f1adac058c15e771
Content-Type: text/plain; charset="UTF-8"

I missed a couple lines in the earlier version of this patch that I
sent last night - updated one attached.


On Mon, Jun 24, 2019 at 2:11 AM Steve French <smfrench@gmail.com> wrote:
>
> See e.g. https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/hh509017(v=ws.10)
>
> where it describes use of an ACE with special SID S-1-5-88-3 to store the mode.
>
> Followon patches will add the support for chmod and query_info (stat)
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

--000000000000f1adac058c15e771
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-new-mount-option-to-retrieve-mode-from-spec.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-new-mount-option-to-retrieve-mode-from-spec.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxaplcfo0>
X-Attachment-Id: f_jxaplcfo0

RnJvbSAwNTc2ZTI5NjJjYTdiMzA1MjFjMjM2ZjNkMGZkN2NlYTlmZjU1ZTFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjQgSnVuIDIwMTkgMDI6MDE6NDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgbmV3IG1vdW50IG9wdGlvbiB0byByZXRyaWV2ZSBtb2RlIGZyb20gc3BlY2lhbCBB
Q0UKClRoZXJlIGlzIGEgc3BlY2lhbCBBQ0UgdXNlZCBieSBzb21lIHNlcnZlcnMgdG8gYWxsb3cg
dGhlIG1vZGUKYml0cyB0byBiZSBzdG9yZWQuICBUaGlzIGNhbiBiZSBlc3BlY2lhbGx5IGhlbHBm
dWwgaW4gc2NlbmFyaW9zCmluIHdoaWNoIHRoZSBjbGllbnQgaXMgdHJ1c3RlZCwgYW5kIGFjY2Vz
cyBjaGVja2luZyBvbiB0aGUKY2xpZW50IHZzIHRoZSBQT1NJWCBtb2RlIGJpdHMgaXMgc3VmZmlj
aWVudC4KCkFkZCBtb3VudCBvcHRpb24gdG8gYWxsb3cgZW5hYmxpbmcgdGhpcyBiZWhhdmlvci4K
Rm9sbG93IG9uIHBhdGNoIHdpbGwgYWRkIHN1cHBvcnQgZm9yIGNobW9kIGFuZCBxdWVyeWluZm8K
KHN0YXQpIGJ5IHJldHJpZXZpbmcgdGhlIFBPU0lYIG1vZGUgYml0cyBmcm9tIHRoZSBzcGVjaWFs
CkFDRSwgU0lEOiBTLTEtNS04OC0zCgpTZWUgZS5nLgpodHRwczovL2RvY3MubWljcm9zb2Z0LmNv
bS9lbi11cy9wcmV2aW91cy12ZXJzaW9ucy93aW5kb3dzL2l0LXByby93aW5kb3dzLXNlcnZlci0y
MDA4LVIyLWFuZC0yMDA4L2hoNTA5MDE3KHY9d3MuMTApCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzX2ZzX3NiLmgg
fCAxICsKIGZzL2NpZnMvY2lmc2ZzLmMgICAgIHwgMiArKwogZnMvY2lmcy9jaWZzZ2xvYi5oICAg
fCAzICsrLQogZnMvY2lmcy9jb25uZWN0LmMgICAgfCA4ICsrKysrKystCiA0IGZpbGVzIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9jaWZzX2ZzX3NiLmggYi9mcy9jaWZzL2NpZnNfZnNfc2IuaAppbmRleCBhZmE1NjIzN2EwYzMu
Ljc0NGU0OGJkY2I2YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2ZzX3NiLmgKKysrIGIvZnMv
Y2lmcy9jaWZzX2ZzX3NiLmgKQEAgLTUyLDYgKzUyLDcgQEAKICNkZWZpbmUgQ0lGU19NT1VOVF9V
SURfRlJPTV9BQ0wgMHgyMDAwMDAwIC8qIHRyeSB0byBnZXQgVUlEIHZpYSBzcGVjaWFsIFNJRCAq
LwogI2RlZmluZSBDSUZTX01PVU5UX05PX0hBTkRMRV9DQUNIRSAweDQwMDAwMDAgLyogZGlzYWJs
ZSBjYWNoaW5nIGRpciBoYW5kbGVzICovCiAjZGVmaW5lIENJRlNfTU9VTlRfTk9fREZTIDB4ODAw
MDAwMCAvKiBkaXNhYmxlIERGUyByZXNvbHZpbmcgKi8KKyNkZWZpbmUgQ0lGU19NT1VOVF9NT0RF
X0ZST01fQUNFIDB4MTAwMDAwMDAgLyogcmV0cmlldmUgbW9kZSBmcm9tIHNwZWNpYWwgQUNFICov
CiAKIHN0cnVjdCBjaWZzX3NiX2luZm8gewogCXN0cnVjdCByYl9yb290IHRsaW5rX3RyZWU7CmRp
ZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCBkYzVm
ZDdhNjQ4ZjAuLmUzM2RhNzNiZDMwMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysg
Yi9mcy9jaWZzL2NpZnNmcy5jCkBAIC01MjYsNiArNTI2LDggQEAgY2lmc19zaG93X29wdGlvbnMo
c3RydWN0IHNlcV9maWxlICpzLCBzdHJ1Y3QgZGVudHJ5ICpyb290KQogCQlzZXFfcHV0cyhzLCAi
LG5vYnJsIik7CiAJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9OT19I
QU5ETEVfQ0FDSEUpCiAJCXNlcV9wdXRzKHMsICIsbm9oYW5kbGVjYWNoZSIpOworCWlmIChjaWZz
X3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTU9ERV9GUk9NX0FDRSkKKwkJc2VxX3B1
dHMocywgIixtb2RlZnJvbWFjZSIpOwogCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJ
RlNfTU9VTlRfQ0lGU19BQ0wpCiAJCXNlcV9wdXRzKHMsICIsY2lmc2FjbCIpOwogCWlmIChjaWZz
X3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfRFlOUEVSTSkKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCAxNmYyNDA5MTExOTIu
LjkwODY3MjY0YmE0ZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2Np
ZnMvY2lmc2dsb2IuaApAQCAtNTUwLDYgKzU1MCw3IEBAIHN0cnVjdCBzbWJfdm9sIHsKIAlib29s
IG92ZXJyaWRlX2dpZDoxOwogCWJvb2wgZHlucGVybToxOwogCWJvb2wgbm9wZXJtOjE7CisJYm9v
bCBtb2RlX2FjZToxOwogCWJvb2wgbm9fcHN4X2FjbDoxOyAvKiBzZXQgaWYgcG9zaXggYWNsIHN1
cHBvcnQgc2hvdWxkIGJlIGRpc2FibGVkICovCiAJYm9vbCBjaWZzX2FjbDoxOwogCWJvb2wgYmFj
a3VwdWlkX3NwZWNpZmllZDsgLyogbW91bnQgb3B0aW9uICBiYWNrdXB1aWQgIGlzIHNwZWNpZmll
ZCAqLwpAQCAtNjE4LDcgKzYxOSw3IEBAIHN0cnVjdCBzbWJfdm9sIHsKIAkJCSBDSUZTX01PVU5U
X01VTFRJVVNFUiB8IENJRlNfTU9VTlRfU1RSSUNUX0lPIHwgXAogCQkJIENJRlNfTU9VTlRfQ0lG
U19CQUNLVVBVSUQgfCBDSUZTX01PVU5UX0NJRlNfQkFDS1VQR0lEIHwgXAogCQkJIENJRlNfTU9V
TlRfVUlEX0ZST01fQUNMIHwgQ0lGU19NT1VOVF9OT19IQU5ETEVfQ0FDSEUgfCBcCi0JCQkgQ0lG
U19NT1VOVF9OT19ERlMpCisJCQkgQ0lGU19NT1VOVF9OT19ERlMgfCBDSUZTX01PVU5UX01PREVf
RlJPTV9BQ0UpCiAKIC8qKgogICogR2VuZXJpYyBWRlMgc3VwZXJibG9jayBtb3VudCBmbGFncyAo
c19mbGFncykgdG8gY29uc2lkZXIgd2hlbgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMg
Yi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBiOGE2MDA2MGQzMjkuLjU0ZTJiMjY1MmMzZCAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTk2
LDcgKzk2LDcgQEAgZW51bSB7CiAJT3B0X211bHRpdXNlciwgT3B0X3Nsb3BweSwgT3B0X25vc2hh
cmVzb2NrLAogCU9wdF9wZXJzaXN0ZW50LCBPcHRfbm9wZXJzaXN0ZW50LAogCU9wdF9yZXNpbGll
bnQsIE9wdF9ub3Jlc2lsaWVudCwKLQlPcHRfZG9tYWluYXV0bywgT3B0X3JkbWEsCisJT3B0X2Rv
bWFpbmF1dG8sIE9wdF9yZG1hLCBPcHRfbW9kZWFjZSwKIAogCS8qIE1vdW50IG9wdGlvbnMgd2hp
Y2ggdGFrZSBudW1lcmljIHZhbHVlICovCiAJT3B0X2JhY2t1cHVpZCwgT3B0X2JhY2t1cGdpZCwg
T3B0X3VpZCwKQEAgLTE3NSw2ICsxNzUsNyBAQCBzdGF0aWMgY29uc3QgbWF0Y2hfdGFibGVfdCBj
aWZzX21vdW50X29wdGlvbl90b2tlbnMgPSB7CiAJeyBPcHRfc2VydmVyaW5vLCAic2VydmVyaW5v
IiB9LAogCXsgT3B0X25vc2VydmVyaW5vLCAibm9zZXJ2ZXJpbm8iIH0sCiAJeyBPcHRfcndwaWRm
b3J3YXJkLCAicndwaWRmb3J3YXJkIiB9LAorCXsgT3B0X21vZGVhY2UsICJtb2RlZnJvbWFjZSIg
fSwKIAl7IE9wdF9jaWZzYWNsLCAiY2lmc2FjbCIgfSwKIAl7IE9wdF9ub2NpZnNhY2wsICJub2Np
ZnNhY2wiIH0sCiAJeyBPcHRfYWNsLCAiYWNsIiB9LApAQCAtMTgzMCw2ICsxODMxLDkgQEAgY2lm
c19wYXJzZV9tb3VudF9vcHRpb25zKGNvbnN0IGNoYXIgKm1vdW50ZGF0YSwgY29uc3QgY2hhciAq
ZGV2bmFtZSwKIAkJY2FzZSBPcHRfcndwaWRmb3J3YXJkOgogCQkJdm9sLT5yd3BpZGZvcndhcmQg
PSAxOwogCQkJYnJlYWs7CisJCWNhc2UgT3B0X21vZGVhY2U6CisJCQl2b2wtPm1vZGVfYWNlID0g
MTsKKwkJCWJyZWFrOwogCQljYXNlIE9wdF9jaWZzYWNsOgogCQkJdm9sLT5jaWZzX2FjbCA9IDE7
CiAJCQlicmVhazsKQEAgLTM5NzYsNiArMzk4MCw4IEBAIGludCBjaWZzX3NldHVwX2NpZnNfc2Io
c3RydWN0IHNtYl92b2wgKnB2b2x1bWVfaW5mbywKIAkJY2lmc19zYi0+bW50X2NpZnNfZmxhZ3Mg
fD0gQ0lGU19NT1VOVF9OT1BPU0lYQlJMOwogCWlmIChwdm9sdW1lX2luZm8tPnJ3cGlkZm9yd2Fy
ZCkKIAkJY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9SV1BJREZPUldBUkQ7
CisJaWYgKHB2b2x1bWVfaW5mby0+bW9kZV9hY2UpCisJCWNpZnNfc2ItPm1udF9jaWZzX2ZsYWdz
IHw9IENJRlNfTU9VTlRfTU9ERV9GUk9NX0FDRTsKIAlpZiAocHZvbHVtZV9pbmZvLT5jaWZzX2Fj
bCkKIAkJY2lmc19zYi0+bW50X2NpZnNfZmxhZ3MgfD0gQ0lGU19NT1VOVF9DSUZTX0FDTDsKIAlp
ZiAocHZvbHVtZV9pbmZvLT5iYWNrdXB1aWRfc3BlY2lmaWVkKSB7Ci0tIAoyLjIwLjEKCg==
--000000000000f1adac058c15e771--
