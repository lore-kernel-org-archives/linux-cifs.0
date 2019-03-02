Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5ABC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 05:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 237D020857
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 05:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cHwL66Pn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfCBFOL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Mar 2019 00:14:11 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:39768 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfCBFOL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Mar 2019 00:14:11 -0500
Received: by mail-pg1-f175.google.com with SMTP id h8so11923624pgp.6
        for <linux-cifs@vger.kernel.org>; Fri, 01 Mar 2019 21:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qa54KcSsYBslxmLtXIrqLjK4P8u092HBPtzK+Cv0jK8=;
        b=cHwL66PnIpoQmmDPAtaDQAYXq/3aQBrhtBi7PE9OGanpoDOeqaCvppmOji5sTtRbFq
         vkkyMfaKQllKZTfnTx4eH/iYXuUNUGVRf+PCknWCab/5+xqA8caP/SVC/hoL+XDK5rGf
         LZP6xqY+XOkGuj47ZkLLjoh7sjd3OVVNIxS6hMm6nMl2nvZrJnadNwyHB6++B8EI20cq
         lxuYorsYm/s6GoiMsSQlFuMG0jELLce6cp6zF0JTXKfrvBk95lUgv3hivqtkFP6KVacu
         U0sTgZ4K9HbNCm6afMfASC6pJMSkVjocy5VTyjTBBTKeoxBeFStWoyJagS8nTJOg7kcl
         Ut4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qa54KcSsYBslxmLtXIrqLjK4P8u092HBPtzK+Cv0jK8=;
        b=m3/EF13Ok02/rXbLh+KgzklT4tWt7LyjnRK65CsBZNiQ1Ezdg9WtYww9xsTrVH6SWY
         GGMz1WxODal4rRS7KMOiTVBu2yvYhr0KX+oecINi+/dJTQJWTj8JwV5Gz+JKLf3W9kof
         A2WpE9lyR6zVmmdpp8aUpvy1Df4FW+UxLWt52F4mb7HgLmgrL3eIzsBv9K1IkAjg8G74
         PY94TOWsJafEg0qc0kEfE9C9HG7t+5u3rVnp6qyyNE60HFP6IjAX2eDJIEhbqnA+rvXU
         FoVtEmxhk/R73FI2EhuIBa5KRo133xEZt5pczZ0/Ua6dE/GQqzeKxeOVvb/gjNnjDmbM
         kjdA==
X-Gm-Message-State: APjAAAUnH9BTnSOQIhMfTJH3Ue1KEpeVvVvqv+5xmkM7BD7xlP/KT+nU
        mK3aB1eVVMmB6MiApOion01dvBEOg/GnjaK31v3v+BJd
X-Google-Smtp-Source: APXvYqxzk/0K/JD8QlS+J5Bi4eF6hjmITdvIzfrrNuXDyk2i6jK7DNkMDpz/M0ML+VknG7z63tn8p1POAdA1rQKyAo0=
X-Received: by 2002:a65:42c6:: with SMTP id l6mr8485903pgp.344.1551503649848;
 Fri, 01 Mar 2019 21:14:09 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Mar 2019 23:13:58 -0600
Message-ID: <CAH2r5mufwdyGa0vs2=7cNDLbUXz3nVNvnQfcUOTbm7+6GPnNmQ@mail.gmail.com>
Subject: [PATCH] setcifsacl - fix adding ACE when owner sid in unexpected location
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000eae6b705831597f7"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000eae6b705831597f7
Content-Type: text/plain; charset="UTF-8"

Patch to fix setcifsacl when owner/group owner are at end instead of
beginning. Seems to work (see below).

$ setcifsacl -a "ACL:Administrator:ALLOWED/0x0/FULL" /mnt/file1
main: setxattr error: Invalid argument
$ getcifsacl /mnt/file1
REVISION:0x1
CONTROL:0x8404
OWNER:NT Authority\SYSTEM
GROUP:NT Authority\SYSTEM
ACL:NT Authority\SYSTEM:ALLOWED/I/FULL
ACL:BUILTIN\Administrators:ALLOWED/I/FULL
ACL:S-1-5-21-859164523-2028333235-149708467-500:ALLOWED/I/FULL
$ ./setcifsacl -a "ACL:Administrator:ALLOWED/0x0/FULL" /mnt/file1
$ getcifsacl /mnt/file1
REVISION:0x1
CONTROL:0x8004
OWNER:NT Authority\SYSTEM
GROUP:NT Authority\SYSTEM
ACL:NT Authority\SYSTEM:ALLOWED/I/FULL
ACL:BUILTIN\Administrators:ALLOWED/I/FULL
ACL:S-1-5-21-859164523-2028333235-149708467-500:ALLOWED/I/FULL
ACL:\administrator:ALLOWED/0x0/FULL


-- 
Thanks,

Steve

--000000000000eae6b705831597f7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-setcifsacl-fix-problem-in-setting-ACL-when-server-re.patch"
Content-Disposition: attachment; 
	filename="0001-setcifsacl-fix-problem-in-setting-ACL-when-server-re.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jsr16cy50>
X-Attachment-Id: f_jsr16cy50

RnJvbSA3NDMxNGYyNGFmMTNkNzA4ZjM5ZDY4Y2EwYTgwMDMwMWNlMzNkMTdhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMSBNYXIgMjAxOSAyMzoxMToyNSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNl
dGNpZnNhY2w6IGZpeCBwcm9ibGVtIGluIHNldHRpbmcgQUNMIHdoZW4gc2VydmVyIHJldHVybnMK
IG93bmVyIGluZm9ybWF0aW9uIGF0IGVuZCBpbnN0ZWFkIG9mIGJlZ2lubmluZwoKSWYgb3duZXIg
aW5mb3JtYXRpb24gaXMgYWZ0ZXIgdGhlIEFDRXMgaW5zdGVhZCBvZiBiZWZvcmUgKGUuZy4gQXp1
cmUgc2VydmVycykgaW4gdGhlIEFDTCBxdWVyeQp0aGVuIHdlIHdvdWxkIGdldCAiaW52YWxpZCBh
cmd1bWVudCIgcmV0dXJuZWQgb24gc2V0Y2lmc2FjbCAtYSAoYWRkaW5nIGFuIEFDRSkuCgpUaGlz
IGZpeGVzIHRoYXQuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogc2V0Y2lmc2FjbC5jIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL3NldGNpZnNhY2wuYyBiL3NldGNpZnNhY2wuYwppbmRleCBiYTM0NDAzLi4x
Yjk4YzM3IDEwMDY0NAotLS0gYS9zZXRjaWZzYWNsLmMKKysrIGIvc2V0Y2lmc2FjbC5jCkBAIC0x
MDYsMTMgKzEwNiwzMiBAQCBjb3B5X3NlY19kZXNjKGNvbnN0IHN0cnVjdCBjaWZzX250c2QgKnBu
dHNkLCBzdHJ1Y3QgY2lmc19udHNkICpwbm50c2QsCiAKIAkvKiBjb3B5IG93bmVyIHNpZCAqLwog
CW93bmVyX3NpZF9wdHIgPSAoc3RydWN0IGNpZnNfc2lkICopKChjaGFyICopcG50c2QgKyBvc2lk
c29mZnNldCk7Ci0Jbm93bmVyX3NpZF9wdHIgPSAoc3RydWN0IGNpZnNfc2lkICopKChjaGFyICop
cG5udHNkICsgb3NpZHNvZmZzZXQpOwotCXNpemUgPSBjb3B5X2NpZnNfc2lkKG5vd25lcl9zaWRf
cHRyLCBvd25lcl9zaWRfcHRyKTsKLQlidWZzaXplICs9IHNpemU7CisJZ3JvdXBfc2lkX3B0ciA9
IChzdHJ1Y3QgY2lmc19zaWQgKikoKGNoYXIgKilwbnRzZCArIGdzaWRzb2Zmc2V0KTsKKwkvKgor
CSAqIHNvbWUgc2VydmVycyBsaWtlIEF6dXJlIHJldHVybiB0aGUgb3duZXIgYW5kIGdyb3VwIFNJ
RHMgYXQgZW5kIHJhdGhlcgorCSAqIHRoYW4gYXQgdGhlIGJlZ2lubmluZyBvZiB0aGUgQUNMIHNv
IGRvbid0IHdhbnQgdG8gb3ZlcndyaXRlIHRoZSBsYXN0IEFDRXMKKyAgICAgICAgICovCisJaWYg
KGRhY2xvZmZzZXQgPD0gb3NpZHNvZmZzZXQpIHsKKwkJLyogb3duZXJzIHBsYWNlZCBhdCBlbmQg
b2YgQUNMICovCisJCW5vd25lcl9zaWRfcHRyID0gKHN0cnVjdCBjaWZzX3NpZCAqKSgoY2hhciAq
KXBubnRzZCArIGRhY2xvZmZzZXQgKyBzaXplKTsKKwkJcG5udHNkLT5vc2lkb2Zmc2V0ID0gZGFj
bG9mZnNldCArIHNpemU7CisJCXNpemUgPSBjb3B5X2NpZnNfc2lkKG5vd25lcl9zaWRfcHRyLCBv
d25lcl9zaWRfcHRyKTsKKwkJYnVmc2l6ZSArPSBzaXplOworCQkvKiBwdXQgZ3JvdXAgU0lEIGFm
dGVyIG93bmVyIFNJRCAqLworCQluZ3JvdXBfc2lkX3B0ciA9IChzdHJ1Y3QgY2lmc19zaWQgKiko
KGNoYXIgKilub3duZXJfc2lkX3B0ciArIHNpemUpOworCQlwbm50c2QtPmdzaWRvZmZzZXQgPSBw
bm50c2QtPm9zaWRvZmZzZXQgKyBzaXplOworCX0gZWxzZSB7CisJCS8qCisJCSAqIE1vc3Qgc2Vy
dmVycyBwdXQgdGhlIG93bmVyIGluZm9ybWF0aW9uIGF0IHRoZSBiZWdpbm5pbmcsCisJCSAqIGJl
Zm9yZSB0aGUgQUNMCisJCSAqLworCQlub3duZXJfc2lkX3B0ciA9IChzdHJ1Y3QgY2lmc19zaWQg
KikoKGNoYXIgKilwbm50c2QgKyBvc2lkc29mZnNldCk7CisJCXNpemUgPSBjb3B5X2NpZnNfc2lk
KG5vd25lcl9zaWRfcHRyLCBvd25lcl9zaWRfcHRyKTsKKwkJYnVmc2l6ZSArPSBzaXplOworCQlu
Z3JvdXBfc2lkX3B0ciA9IChzdHJ1Y3QgY2lmc19zaWQgKikoKGNoYXIgKilwbm50c2QgKyBnc2lk
c29mZnNldCk7CisJfQogCiAJLyogY29weSBncm91cCBzaWQgKi8KLQlncm91cF9zaWRfcHRyID0g
KHN0cnVjdCBjaWZzX3NpZCAqKSgoY2hhciAqKXBudHNkICsgZ3NpZHNvZmZzZXQpOwotCW5ncm91
cF9zaWRfcHRyID0gKHN0cnVjdCBjaWZzX3NpZCAqKSgoY2hhciAqKXBubnRzZCArIGdzaWRzb2Zm
c2V0KTsKIAlzaXplID0gY29weV9jaWZzX3NpZChuZ3JvdXBfc2lkX3B0ciwgZ3JvdXBfc2lkX3B0
cik7CiAJYnVmc2l6ZSArPSBzaXplOwogCi0tIAoyLjE3LjEKCg==
--000000000000eae6b705831597f7--
