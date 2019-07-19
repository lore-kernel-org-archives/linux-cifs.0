Return-Path: <SRS0=X4Gq=VQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B693AC76188
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Jul 2019 08:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F12C2084C
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Jul 2019 08:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQ8MQ7da"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfGSIbr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Jul 2019 04:31:47 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:37499 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfGSIbr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Jul 2019 04:31:47 -0400
Received: by mail-pg1-f179.google.com with SMTP id i70so3396418pgd.4
        for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2019 01:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qr+vzmrxKDJE3gBHNNljtkicer3EU9BSwZ8D3VJsD4U=;
        b=VQ8MQ7daYgPvOsz2V9bOKgxoKHQCjyLZxI8clEbPpecMTLGyT10hYwSAaAu0KZ5J/0
         MIe+rxxQo0k502AXofDlQI7w/9Do3Ooq6OMd3JQBNVVD8jctU96JQMd/OjRyYEqEdwoE
         HEwQsGeInQ6oiw5wjGSylWk9Ky3f8QKXf8sMUJ5B8FYZgH2z5uL1YKeOVUALBc6tjcNq
         9OsEj7Mvz4JipMQtQgCMdpcba9+hmKOJ4iDNTiQWpU/KfRs2aItdBZvoc6RUcNTh/emJ
         HxqFxivmUotgXFIiipMk7y3A6GcNqwK1QFiy+2AyOKkSVfNmPrntQrKOiIUzO8SwTwdd
         j5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qr+vzmrxKDJE3gBHNNljtkicer3EU9BSwZ8D3VJsD4U=;
        b=UA3VdsLJcq76unGpVDAHby7Kx/vqY9l+0seco5S59FOVtRRneWKp4BftrotbKtuaHB
         x8Nu/L8BGD7g+7J594ToITTr9WOrYtxQ+eMIcnPcNevU0qpgkNEf5ZCZzSBrITuTuS3Z
         vec79LTKhTIhbPgZim0cnXDTOdmmSHYBDpucE+XEp+UitizmNPFu5OPrfvCQ0Wh+RsX6
         F1es/YFcmryOAmIvCwD8jpToKxpxyr3ElYQNQ/y8jBXDg8ghYbeOwEZ5sBmOqVYSVpWo
         sMg/4+5j4YefLrjAxFZGUrws0NTgdO7esHLU8X5qH5PaJ24+tfoDQ8w1OQGX0xQFLtXe
         btDA==
X-Gm-Message-State: APjAAAWTdMCimwmNHT/OG4L2ONixtd8fTdNYIsT5oVDLgUuVmhjdfiR+
        KmOftbmuvKJEsodlAMOOjvC5UVCIWpx08T0qeCQUEkIafX4=
X-Google-Smtp-Source: APXvYqwUaTWp6cTkmWccO0tBAODdqHs6PFQvHj5hlaQqSrk06JBC9zzxcp7SsznCmsDKOYuh17pbrIKS/Wvpx/LsKT4=
X-Received: by 2002:a65:6454:: with SMTP id s20mr52852475pgv.15.1563525105313;
 Fri, 19 Jul 2019 01:31:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Jul 2019 03:31:33 -0500
Message-ID: <CAH2r5msHdqJ-oSiB+RGEoknHvY4FWeX81YAw2+_D_wYuoL3PJA@mail.gmail.com>
Subject: [PATCH][CIFS] Allow chmod to set mode using special SID
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000801e52058e048eb2"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000801e52058e048eb2
Content-Type: text/plain; charset="UTF-8"

    When mounting with "modefromsid" set mode bits (chmod) by
    adding ACE with special SID (S-1-5-88-3-<mode>) to the ACL.
    Subsequent patch will fix setting default mode on file
    create and mkdir.

    See See e.g.
        https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/hh509017(v=ws.10)

An example:

# touch /mnt-to-windows/newfile0754

# chmod 0754 /mnt-to-windows/newfile0754

# stat /mnt-to-windows/newfile0754
  File: /mnt-to-windows/newfile0754
  Size: 0          Blocks: 0          IO Block: 1048576 regular empty file
Device: 33h/51d Inode: 3659174697263184  Links: 1
Access: (0754/-rwxr-xr--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-07-19 08:21:14.970287500 +0000
Modify: 2019-07-19 08:21:14.970287500 +0000
Change: 2019-07-19 08:21:25.665086200 +0000

(Notice the last ACE which has the mode bits embedded, 492 decimal is
0754 octal)

# getcifsacl /mnt-to-windows/newfile0754
REVISION:0x1
CONTROL:0x8004
OWNER:S-1-5-32-544
GROUP:S-1-5-21-3447553893-1265514152-1435875098-513
ACL:S-1-5-32-544:ALLOWED/0x0/FULL
ACL:S-1-5-21-3447553893-1265514152-1435875098-513:ALLOWED/0x0/0x1f01b9
ACL:S-1-1-0:ALLOWED/0x0/0x1f0199
ACL:S-1-5-88-3-492:DENIED/0x0/

-- 
Thanks,

Steve

--000000000000801e52058e048eb2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-allow-chmod-to-set-mode-bits-using-special-sid.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-allow-chmod-to-set-mode-bits-using-special-sid.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jy9ugwyy0>
X-Attachment-Id: f_jy9ugwyy0

RnJvbSBlZTJjZWExMGEzMjgyN2JlOTdkMGY3NTA0YWM1YTgzNWEzNWJkMWE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBVYnVudHUKIDxzbWZyZW5jaEB1YnVudHUxOWdjbWZhc3QuNXJl
b2U1Ym9vY3p1ZGVxcWY0aDRtdm4ydWUuanguaW50ZXJuYWwuY2xvdWRhcHAubmV0PgpEYXRlOiBG
cmksIDE5IEp1bCAyMDE5IDA4OjE1OjU1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gY2lmczogYWxs
b3cgY2htb2QgdG8gc2V0IG1vZGUgYml0cyB1c2luZyBzcGVjaWFsIHNpZAoKICAgIFdoZW4gbW91
bnRpbmcgd2l0aCAibW9kZWZyb21zaWQiIHNldCBtb2RlIGJpdHMgKGNobW9kKSBieQogICAgYWRk
aW5nIEFDRSB3aXRoIHNwZWNpYWwgU0lEIChTLTEtNS04OC0zLTxtb2RlPikgdG8gdGhlIEFDTC4K
ICAgIFN1YnNlcXVlbnQgcGF0Y2ggd2lsbCBmaXggc2V0dGluZyBkZWZhdWx0IG1vZGUgb24gZmls
ZQogICAgY3JlYXRlIGFuZCBta2Rpci4KCiAgICBTZWUgU2VlIGUuZy4KICAgICAgICBodHRwczov
L2RvY3MubWljcm9zb2Z0LmNvbS9lbi11cy9wcmV2aW91cy12ZXJzaW9ucy93aW5kb3dzL2l0LXBy
by93aW5kb3dzLXNlcnZlci0yMDA4LVIyLWFuZC0yMDA4L2hoNTA5MDE3KHY9d3MuMTApCgogICAg
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvY2lmc2FjbC5jIHwgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tCiBmcy9jaWZzL2lub2RlLmMgICB8ICA2ICsrKystLQogMiBmaWxlcyBjaGFuZ2Vk
LCA0MSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
Y2lmc2FjbC5jIGIvZnMvY2lmcy9jaWZzYWNsLmMKaW5kZXggMmExNDc0OGI4ZTA5Li5hMzFiZWU1
MWIxYjQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2FjbC5jCisrKyBiL2ZzL2NpZnMvY2lmc2Fj
bC5jCkBAIC04MDYsNyArODA2LDcgQEAgc3RhdGljIHZvaWQgcGFyc2VfZGFjbChzdHJ1Y3QgY2lm
c19hY2wgKnBkYWNsLCBjaGFyICplbmRfb2ZfYWNsLAogCiAKIHN0YXRpYyBpbnQgc2V0X2NobW9k
X2RhY2woc3RydWN0IGNpZnNfYWNsICpwbmRhY2wsIHN0cnVjdCBjaWZzX3NpZCAqcG93bmVyc2lk
LAotCQkJc3RydWN0IGNpZnNfc2lkICpwZ3Jwc2lkLCBfX3U2NCBubW9kZSkKKwkJCXN0cnVjdCBj
aWZzX3NpZCAqcGdycHNpZCwgX191NjQgbm1vZGUsIGJvb2wgbW9kZWZyb21zaWQpCiB7CiAJdTE2
IHNpemUgPSAwOwogCXN0cnVjdCBjaWZzX2FjbCAqcG5uZGFjbDsKQEAgLTgyMCw4ICs4MjAsMzMg
QEAgc3RhdGljIGludCBzZXRfY2htb2RfZGFjbChzdHJ1Y3QgY2lmc19hY2wgKnBuZGFjbCwgc3Ry
dWN0IGNpZnNfc2lkICpwb3duZXJzaWQsCiAJc2l6ZSArPSBmaWxsX2FjZV9mb3Jfc2lkKChzdHJ1
Y3QgY2lmc19hY2UgKikoKGNoYXIgKilwbm5kYWNsICsgc2l6ZSksCiAJCQkJCSAmc2lkX2V2ZXJ5
b25lLCBubW9kZSwgU19JUldYTyk7CiAKKwkvKiBUQkQ6IE1vdmUgdGhpcyBBQ0UgdG8gdGhlIHRv
cCBvZiBBQ0UgbGlzdCBpbnN0ZWFkIG9mIGJvdHRvbSAqLworCWlmIChtb2RlZnJvbXNpZCkgewor
CQlzdHJ1Y3QgY2lmc19hY2UgKnBudGFjZSA9CisJCQkoc3RydWN0IGNpZnNfYWNlICopKChjaGFy
ICopcG5uZGFjbCArIHNpemUpOworCQlpbnQgaTsKKworCQlwbnRhY2UtPnR5cGUgPSBBQ0NFU1Nf
REVOSUVEOworCQlwbnRhY2UtPmZsYWdzID0gMHgwOworCQlwbnRhY2UtPnNpZC5udW1fc3ViYXV0
aCA9IDM7CisJCXBudGFjZS0+c2lkLnJldmlzaW9uID0gMTsKKwkJLyogc2l6ZSA9IDEgKyAxICsg
MiArIDQgKyAxICsgMSArIDYgKyAocHNpZC0+bnVtX3N1YmF1dGggKiA0KSAqLworCQlwbnRhY2Ut
PnNpemUgPSBjcHVfdG9fbGUxNigyOCk7CisJCXNpemUgKz0gMjg7CisJCWZvciAoaSA9IDA7IGkg
PCBOVU1fQVVUSFM7IGkrKykKKwkJCXBudGFjZS0+c2lkLmF1dGhvcml0eVtpXSA9CisJCQkJc2lk
X3VuaXhfTkZTX21vZGUuYXV0aG9yaXR5W2ldOworICAgICAgICAgICAgICAgIHBudGFjZS0+c2lk
LnN1Yl9hdXRoWzBdID0gc2lkX3VuaXhfTkZTX21vZGUuc3ViX2F1dGhbMF07CisJCXBudGFjZS0+
c2lkLnN1Yl9hdXRoWzFdID0gc2lkX3VuaXhfTkZTX21vZGUuc3ViX2F1dGhbMV07CisJCXBudGFj
ZS0+c2lkLnN1Yl9hdXRoWzJdID0gY3B1X3RvX2xlMzIobm1vZGUgJiAwNzc3Nyk7CisKKwkJcG5k
YWNsLT5udW1fYWNlcyA9IGNwdV90b19sZTMyKDQpOworCQlzaXplICs9IGZpbGxfYWNlX2Zvcl9z
aWQoKHN0cnVjdCBjaWZzX2FjZSAqKSgoY2hhciAqKXBubmRhY2wgKyBzaXplKSwKKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJnNpZF91bml4X05GU19tb2RlLCBubW9k
ZSwgU19JUldYTyk7CisJfSBlbHNlCisJCXBuZGFjbC0+bnVtX2FjZXMgPSBjcHVfdG9fbGUzMigz
KTsKKwogCXBuZGFjbC0+c2l6ZSA9IGNwdV90b19sZTE2KHNpemUgKyBzaXplb2Yoc3RydWN0IGNp
ZnNfYWNsKSk7Ci0JcG5kYWNsLT5udW1fYWNlcyA9IGNwdV90b19sZTMyKDMpOwogCiAJcmV0dXJu
IDA7CiB9CkBAIC05MjEsNyArOTQ2LDggQEAgc3RhdGljIGludCBwYXJzZV9zZWNfZGVzYyhzdHJ1
Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAogCiAvKiBDb252ZXJ0IHBlcm1pc3Npb24gYml0cyBm
cm9tIG1vZGUgdG8gZXF1aXZhbGVudCBDSUZTIEFDTCAqLwogc3RhdGljIGludCBidWlsZF9zZWNf
ZGVzYyhzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCwgc3RydWN0IGNpZnNfbnRzZCAqcG5udHNkLAot
CV9fdTMyIHNlY2Rlc2NsZW4sIF9fdTY0IG5tb2RlLCBrdWlkX3QgdWlkLCBrZ2lkX3QgZ2lkLCBp
bnQgKmFjbGZsYWcpCisJX191MzIgc2VjZGVzY2xlbiwgX191NjQgbm1vZGUsIGt1aWRfdCB1aWQs
IGtnaWRfdCBnaWQsCisJYm9vbCBtb2RlX2Zyb21fc2lkLCBpbnQgKmFjbGZsYWcpCiB7CiAJaW50
IHJjID0gMDsKIAlfX3UzMiBkYWNsb2Zmc2V0OwpAQCAtOTQ2LDcgKzk3Miw3IEBAIHN0YXRpYyBp
bnQgYnVpbGRfc2VjX2Rlc2Moc3RydWN0IGNpZnNfbnRzZCAqcG50c2QsIHN0cnVjdCBjaWZzX250
c2QgKnBubnRzZCwKIAkJbmRhY2xfcHRyLT5udW1fYWNlcyA9IDA7CiAKIAkJcmMgPSBzZXRfY2ht
b2RfZGFjbChuZGFjbF9wdHIsIG93bmVyX3NpZF9wdHIsIGdyb3VwX3NpZF9wdHIsCi0JCQkJCW5t
b2RlKTsKKwkJCQkgICAgbm1vZGUsIG1vZGVfZnJvbV9zaWQpOwogCQlzaWRzb2Zmc2V0ID0gbmRh
Y2xvZmZzZXQgKyBsZTE2X3RvX2NwdShuZGFjbF9wdHItPnNpemUpOwogCQkvKiBjb3B5IHNlYyBk
ZXNjIGNvbnRyb2wgcG9ydGlvbiAmIG93bmVyIGFuZCBncm91cCBzaWRzICovCiAJCWNvcHlfc2Vj
X2Rlc2MocG50c2QsIHBubnRzZCwgc2lkc29mZnNldCk7CkBAIC0xMTk2LDYgKzEyMjIsNyBAQCBp
ZF9tb2RlX3RvX2NpZnNfYWNsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGNvbnN0IGNoYXIgKnBhdGgs
IF9fdTY0IG5tb2RlLAogCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IgPSBDSUZTX1NCKGlu
b2RlLT5pX3NiKTsKIAlzdHJ1Y3QgdGNvbl9saW5rICp0bGluayA9IGNpZnNfc2JfdGxpbmsoY2lm
c19zYik7CiAJc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgKm9wczsKKwlib29sIG1vZGVf
ZnJvbV9zaWQ7CiAKIAlpZiAoSVNfRVJSKHRsaW5rKSkKIAkJcmV0dXJuIFBUUl9FUlIodGxpbmsp
OwpAQCAtMTIzMyw4ICsxMjYwLDEzIEBAIGlkX21vZGVfdG9fY2lmc19hY2woc3RydWN0IGlub2Rl
ICppbm9kZSwgY29uc3QgY2hhciAqcGF0aCwgX191NjQgbm1vZGUsCiAJCXJldHVybiAtRU5PTUVN
OwogCX0KIAorCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTU9ERV9G
Uk9NX1NJRCkKKwkJbW9kZV9mcm9tX3NpZCA9IHRydWU7CisJZWxzZQorCQltb2RlX2Zyb21fc2lk
ID0gZmFsc2U7CisKIAlyYyA9IGJ1aWxkX3NlY19kZXNjKHBudHNkLCBwbm50c2QsIHNlY2Rlc2Ns
ZW4sIG5tb2RlLCB1aWQsIGdpZCwKLQkJCQkmYWNsZmxhZyk7CisJCQkgICAgbW9kZV9mcm9tX3Np
ZCwgJmFjbGZsYWcpOwogCiAJY2lmc19kYmcoTk9JU1ksICJidWlsZF9zZWNfZGVzYyByYzogJWRc
biIsIHJjKTsKIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pbm9kZS5jIGIvZnMvY2lmcy9pbm9kZS5j
CmluZGV4IGMxZTYyMGViY2Y3Yy4uODM2NjQ3MzVlZmE1IDEwMDY0NAotLS0gYS9mcy9jaWZzL2lu
b2RlLmMKKysrIGIvZnMvY2lmcy9pbm9kZS5jCkBAIC0yNDg5LDcgKzI0ODksOCBAQCBjaWZzX3Nl
dGF0dHJfbm91bml4KHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LCBzdHJ1Y3QgaWF0dHIgKmF0dHJz
KQogCWlmIChhdHRycy0+aWFfdmFsaWQgJiBBVFRSX0dJRCkKIAkJZ2lkID0gYXR0cnMtPmlhX2dp
ZDsKIAotCWlmIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfQ0lGU19BQ0wp
IHsKKwlpZiAoKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9DSUZTX0FDTCkg
fHwKKyAgICAgICAgICAgIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9VTlRfTU9E
RV9GUk9NX1NJRCkpIHsKIAkJaWYgKHVpZF92YWxpZCh1aWQpIHx8IGdpZF92YWxpZChnaWQpKSB7
CiAJCQlyYyA9IGlkX21vZGVfdG9fY2lmc19hY2woaW5vZGUsIGZ1bGxfcGF0aCwgTk9fQ0hBTkdF
XzY0LAogCQkJCQkJCXVpZCwgZ2lkKTsKQEAgLTI1MTAsNyArMjUxMSw4IEBAIGNpZnNfc2V0YXR0
cl9ub3VuaXgoc3RydWN0IGRlbnRyeSAqZGlyZW50cnksIHN0cnVjdCBpYXR0ciAqYXR0cnMpCiAJ
aWYgKGF0dHJzLT5pYV92YWxpZCAmIEFUVFJfTU9ERSkgewogCQltb2RlID0gYXR0cnMtPmlhX21v
ZGU7CiAJCXJjID0gMDsKLQkJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VO
VF9DSUZTX0FDTCkgeworCQlpZiAoKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VO
VF9DSUZTX0FDTCkgfHwKKwkJICAgIChjaWZzX3NiLT5tbnRfY2lmc19mbGFncyAmIENJRlNfTU9V
TlRfTU9ERV9GUk9NX1NJRCkpIHsKIAkJCXJjID0gaWRfbW9kZV90b19jaWZzX2FjbChpbm9kZSwg
ZnVsbF9wYXRoLCBtb2RlLAogCQkJCQkJSU5WQUxJRF9VSUQsIElOVkFMSURfR0lEKTsKIAkJCWlm
IChyYykgewotLSAKMi4yMC4xCgo=
--000000000000801e52058e048eb2--
