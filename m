Return-Path: <SRS0=z2/z=U3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA3FC4321A
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jun 2019 07:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6A32086D
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jun 2019 07:08:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aA4yKQ92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfF1HIu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jun 2019 03:08:50 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:45634 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfF1HIt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jun 2019 03:08:49 -0400
Received: by mail-pl1-f171.google.com with SMTP id bi6so2706947plb.12
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jun 2019 00:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sbCtySyG/9fHGgOfVGmRAFyptQXgGv58u3Mjq2Ac6B8=;
        b=aA4yKQ92O1sHsx8lEfkHqJTA/7EVik9dzllu9yAcMzSXoVJewQKBZtSeSJb0Ni3wLa
         K/yUAl/3S3MpOlWX+Fa5sPHFk9HhEYzKx43sDE5naSrTGPD1oVsuWdt3Ug20lH9/47jc
         vJibtNZioN/WJo3aumfb4zhbf8CSt0iA8Ukbvm1m2MS10bPerSJaBBfPeQZL30i+Givy
         S/5hZ+uhgnacpGGr7MqfzWKusve8wCwBTUoueVYUYOSKgx03Q6EMbj3+nLOJIiNztW/e
         BMcIrCfachYJyDWsfB8Z/KBKVPFnUNkleUYdOb9H9XOPiynaoxCQW18QZh8Bosi8DZ/K
         IKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sbCtySyG/9fHGgOfVGmRAFyptQXgGv58u3Mjq2Ac6B8=;
        b=AYDeSxnVFM3KgE61DK01ddmE7UG69/xj1H+pYcfUGQTwhZ3i0evZTcTs17+hU+0ArO
         NxSZTwcx09ofHzNHThZQOb79K5XUUUTK+zEd+VluexEhliwPXoviIOO4VEZlcHUpR/0U
         XW6bXggQ1hNRYkn66RY3fkOTxfK8hXkVGoSJo1Y7ui9WgZmwxu41en7ZwanwBWW4x9iC
         sQ47wl3WaxsxbqXmwE7hhqgedT6hY/4MuopdCQ87bz5uv7RCiUAJVfYyHJ27ZQwo/6zg
         SFTE7CgZBSjFPS+BoSsor7Hyz+8N4Hk7FydAUDjWDQyEGGxZxpBvPQxuFSVkmTohvxRQ
         SeNw==
X-Gm-Message-State: APjAAAUDYp+PVWvycSleFzOfw5AxeIdUTbeXh2rXAy59AfWiKyCIkF/G
        Yhrl0Uj8nRqm9yqzDUzSQcfTqvTlMq8a/LZimZq7eMXs
X-Google-Smtp-Source: APXvYqwVb5nnwm9cm3oprVXuEFHi1uBZp34+mpFGqQ3N6LMf+N3K2RAOIf/I1ZFj62w6shCvPrbXICF9mQsE278dO5U=
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr9852924plc.78.1561705728498;
 Fri, 28 Jun 2019 00:08:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Jun 2019 02:08:37 -0500
Message-ID: <CAH2r5msqF-Cvq=q7ae1XmnOi6DbB3UKSDSDvZbT8MNscLH3XTA@mail.gmail.com>
Subject: [PATCH]Fix querying symlinks
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000310d91058c5cf3e2"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000310d91058c5cf3e2
Content-Type: text/plain; charset="UTF-8"

Querying of symlinks to the Samba server with POSIX extensions works!

(Also would work for querying symlinks generated in Windows NFS server)

# stat /mnt1/symlink-source
  File: /mnt1/symlink-source -> symlink-target
  Size: 14            Blocks: 2048       IO Block: 16384  symbolic link
Device: 39h/57d    Inode: 10354691    Links: 1
Access: (0000/l---------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-06-28 01:43:37.145324400 -0500
Modify: 2019-06-28 01:43:37.145324400 -0500
Change: 2019-06-28 01:43:37.145324400 -0500
 Birth: -


-- 
Thanks,

Steve

--000000000000310d91058c5cf3e2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-Allow-query-of-symlinks-stored-as-reparse-point.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-Allow-query-of-symlinks-stored-as-reparse-point.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jxfr8gra0>
X-Attachment-Id: f_jxfr8gra0

RnJvbSBhYWFlYWQ3M2IyZmU4NGJmZTU2NDIzY2E1MjhhNmZjZjVjMmVhNGY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjggSnVuIDIwMTkgMDI6MDQ6MTggLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBbGxvdyBxdWVyeSBvZiBzeW1saW5rcyBzdG9yZWQgYXMgcmVwYXJzZSBwb2ludHMKClRo
ZSAnTkZTJyBzdHlsZSBzeW1saW5rcyAoc2VlIE1TLUZTQ0MgMi4xLjIuNCkgd2VyZSBub3QKYmVp
bmcgcXVlcmllZCBwcm9wZXJseSBpbiBxdWVyeV9zeW1saW5rLiBGaXggdGhpcy4KClNpZ25lZC1v
ZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L3NtYjJvcHMuYyB8IDYwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4
IDc1ZjMzNDhhNDcxZS4uYzQwNDdhZDdiNDNmIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMu
YworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjM3Myw2ICsyMzczLDM5IEBAIHNtYjJfZ2V0
X2Rmc19yZWZlcihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywK
IAlyZXR1cm4gcmM7CiB9CiAKK3N0YXRpYyBpbnQKK3BhcnNlX3JlcGFyc2VfcG9zaXgoc3RydWN0
IHJlcGFyc2VfcG9zaXhfZGF0YSAqc3ltbGlua19idWYsCisJCSAgICAgIHUzMiBwbGVuLCBjaGFy
ICoqdGFyZ2V0X3BhdGgsCisJCSAgICAgIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IpCit7
CisJdW5zaWduZWQgaW50IGxlbjsKKworCS8qIFNlZSBNUy1GU0NDIDIuMS4yLjYgZm9yIHRoZSAn
TkZTJyBzdHlsZSByZXBhcnNlIHRhZ3MgKi8KKwlsZW4gPSBsZTE2X3RvX2NwdShzeW1saW5rX2J1
Zi0+UmVwYXJzZURhdGFMZW5ndGgpOworCisJaWYgKGxlbiArIHNpemVvZihzdHJ1Y3QgcmVwYXJz
ZV9kYXRhX2J1ZmZlcikgPiBwbGVuKSB7CisJCWNpZnNfZGJnKFZGUywgInNydiByZXR1cm5lZCBt
YWxmb3JtZWQgc3ltbGluayBidWZmZXJcbiIpOworCQlyZXR1cm4gLUVJTlZBTDsKKwl9CisKKwlp
ZiAobGU2NF90b19jcHUoc3ltbGlua19idWYtPklub2RlVHlwZSkgIT0gTkZTX1NQRUNGSUxFX0xO
SykgeworCQljaWZzX2RiZyhWRlMsICIlbGxkIG5vdCBhIHN1cHBvcnRlZCBzeW1saW5rIHR5cGVc
biIsCisJCQlsZTY0X3RvX2NwdShzeW1saW5rX2J1Zi0+SW5vZGVUeXBlKSk7CisJCXJldHVybiAt
RU9QTk9UU1VQUDsKKwl9CisKKwkqdGFyZ2V0X3BhdGggPSBjaWZzX3N0cm5kdXBfZnJvbV91dGYx
NigKKwkJCQlzeW1saW5rX2J1Zi0+UGF0aEJ1ZmZlciwKKwkJCQlsZW4sIHRydWUsIGNpZnNfc2It
PmxvY2FsX25scyk7CisJaWYgKCEoKnRhcmdldF9wYXRoKSkKKwkJcmV0dXJuIC1FTk9NRU07CisK
Kwljb252ZXJ0X2RlbGltaXRlcigqdGFyZ2V0X3BhdGgsICcvJyk7CisJY2lmc19kYmcoRllJLCAi
JXM6IHRhcmdldCBwYXRoOiAlc1xuIiwgX19mdW5jX18sICp0YXJnZXRfcGF0aCk7CisKKwlyZXR1
cm4gMDsKK30KKwogc3RhdGljIGludAogcGFyc2VfcmVwYXJzZV9zeW1saW5rKHN0cnVjdCByZXBh
cnNlX3N5bWxpbmtfZGF0YV9idWZmZXIgKnN5bWxpbmtfYnVmLAogCQkgICAgICB1MzIgcGxlbiwg
Y2hhciAqKnRhcmdldF9wYXRoLApAQCAtMjM4MSwxMSArMjQxNCw3IEBAIHBhcnNlX3JlcGFyc2Vf
c3ltbGluayhzdHJ1Y3QgcmVwYXJzZV9zeW1saW5rX2RhdGFfYnVmZmVyICpzeW1saW5rX2J1ZiwK
IAl1bnNpZ25lZCBpbnQgc3ViX2xlbjsKIAl1bnNpZ25lZCBpbnQgc3ViX29mZnNldDsKIAotCS8q
IFdlIG9ubHkgaGFuZGxlIFN5bWJvbGljIExpbmsgOiBNUy1GU0NDIDIuMS4yLjQgKi8KLQlpZiAo
bGUzMl90b19jcHUoc3ltbGlua19idWYtPlJlcGFyc2VUYWcpICE9IElPX1JFUEFSU0VfVEFHX1NZ
TUxJTkspIHsKLQkJY2lmc19kYmcoVkZTLCAic3J2IHJldHVybmVkIGludmFsaWQgc3ltbGluayBi
dWZmZXJcbiIpOwotCQlyZXR1cm4gLUVJTzsKLQl9CisJLyogV2UgaGFuZGxlIFN5bWJvbGljIExp
bmsgcmVwYXJzZSB0YWcgaGVyZS4gU2VlOiBNUy1GU0NDIDIuMS4yLjQgKi8KIAogCXN1Yl9vZmZz
ZXQgPSBsZTE2X3RvX2NwdShzeW1saW5rX2J1Zi0+U3Vic3RpdHV0ZU5hbWVPZmZzZXQpOwogCXN1
Yl9sZW4gPSBsZTE2X3RvX2NwdShzeW1saW5rX2J1Zi0+U3Vic3RpdHV0ZU5hbWVMZW5ndGgpOwpA
QCAtMjQwNyw2ICsyNDM2LDI1IEBAIHBhcnNlX3JlcGFyc2Vfc3ltbGluayhzdHJ1Y3QgcmVwYXJz
ZV9zeW1saW5rX2RhdGFfYnVmZmVyICpzeW1saW5rX2J1ZiwKIAlyZXR1cm4gMDsKIH0KIAorc3Rh
dGljIGludAorcGFyc2VfcmVwYXJzZV9wb2ludChzdHJ1Y3QgcmVwYXJzZV9zeW1saW5rX2RhdGFf
YnVmZmVyICpidWYsCisJCSAgICAgIHUzMiBwbGVuLCBjaGFyICoqdGFyZ2V0X3BhdGgsCisJCSAg
ICAgIHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IpCit7CisJLyogU2VlIE1TLUZTQ0MgMi4x
LjIgKi8KKwlpZiAobGUzMl90b19jcHUoYnVmLT5SZXBhcnNlVGFnKSA9PSBJT19SRVBBUlNFX1RB
R19ORlMpCisJCXJldHVybiBwYXJzZV9yZXBhcnNlX3Bvc2l4KChzdHJ1Y3QgcmVwYXJzZV9wb3Np
eF9kYXRhICopYnVmLAorCQkJcGxlbiwgdGFyZ2V0X3BhdGgsIGNpZnNfc2IpOworCWVsc2UgaWYg
KGxlMzJfdG9fY3B1KGJ1Zi0+UmVwYXJzZVRhZykgPT0gSU9fUkVQQVJTRV9UQUdfU1lNTElOSykK
KwkJcmV0dXJuIHBhcnNlX3JlcGFyc2Vfc3ltbGluayhidWYsIHBsZW4sIHRhcmdldF9wYXRoLAor
CQkJCQljaWZzX3NiKTsKKworCWNpZnNfZGJnKFZGUywgInNydiByZXR1cm5lZCBpbnZhbGlkIHN5
bWxpbmsgYnVmZmVyIHRhZzolZFxuIiwKKwkJbGUzMl90b19jcHUoYnVmLT5SZXBhcnNlVGFnKSk7
CisKKwlyZXR1cm4gLUVJTzsKK30KKwogI2RlZmluZSBTTUIyX1NZTUxJTktfU1RSVUNUX1NJWkUg
XAogCShzaXplb2Yoc3RydWN0IHNtYjJfZXJyX3JzcCkgLSAxICsgc2l6ZW9mKHN0cnVjdCBzbWIy
X3N5bWxpbmtfZXJyX3JzcCkpCiAKQEAgLTI1NDcsNyArMjU5NSw3IEBAIHNtYjJfcXVlcnlfc3lt
bGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJ
Z290byBxdWVydHlfZXhpdDsKIAkJfQogCi0JCXJjID0gcGFyc2VfcmVwYXJzZV9zeW1saW5rKAor
CQlyYyA9IHBhcnNlX3JlcGFyc2VfcG9pbnQoCiAJCQkoc3RydWN0IHJlcGFyc2Vfc3ltbGlua19k
YXRhX2J1ZmZlciAqKXJlcGFyc2VfYnVmLAogCQkJcGxlbiwgdGFyZ2V0X3BhdGgsIGNpZnNfc2Ip
OwogCQlnb3RvIHF1ZXJ0eV9leGl0OwotLSAKMi4yMC4xCgo=
--000000000000310d91058c5cf3e2--
