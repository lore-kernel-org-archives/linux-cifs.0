Return-Path: <SRS0=X4Gq=VQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D988C76188
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Jul 2019 06:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DC1420873
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Jul 2019 06:43:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdf9UHBK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfGSGnk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Jul 2019 02:43:40 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:44807 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfGSGnk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Jul 2019 02:43:40 -0400
Received: by mail-pl1-f173.google.com with SMTP id t14so15106157plr.11
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jul 2019 23:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wUpTp6AtD2MSjysLZIpVuQJ8GCkcCI+SDwn1o/40S6I=;
        b=cdf9UHBKRmNsTsC6SrFvM6KDjgms9b5T8zLuwVhFTU1mQUAuBHvnpC8vzfNLt+aqX5
         oAiv2WnhEKJmw5Rz4PmTb5Ww8r9opsVjgQZ4ZbncHSF05Zf+GkVEXjKkJXt9amoC5Tbk
         O8/JyCr3K7R5fLDGH+3F7X3YiOL0jxFA8zQETQcltpeVE3S7Oqq/OwQoCy6J08QPn6mN
         MJ8m29NDUp6CzJ/IUjeu2o5Hcw3WwFg8ffoeGhIj3zvf6mNmNtAnGU2/uQIQsRmS9nHj
         6gHbGV2xA7LejyhVyMul0GYOhdyrEv902u44GPxOndqhfn00mWIZq8qd9Ec8MAuF24dF
         s5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wUpTp6AtD2MSjysLZIpVuQJ8GCkcCI+SDwn1o/40S6I=;
        b=ArSDWT0Rt4Ft82USBnj4yYgfoPF3G1ZO+b8SP3LTHzgQx4CervIuCLHO8sfKBaBEVI
         Hw0HbnTIeOi81yrHIc/BcAZYrmfLxM5ImzC8BHn5Nfa+KRUCqRLXI8JETTKoSpgeDpiL
         UUslskh65PJcq+xgtOWA4cp+5+tHQ45+FJecSmoSaPLsYZJt5BfMV/tr8upOt92AtPWW
         xooAewrERRSum4+ln753uTjqelqEf7g4lhopEcCnEBZrzLKHTdQThrzD5Zsn6J2dt/ZE
         XvkZAkJpDuMerbUH7TBvsOYo+Vw63VdXkO2apmNWRZtQDNC4raW8xzQzgoLR4UKWnO1B
         1xpw==
X-Gm-Message-State: APjAAAWT5watufmsIaerugLuyEkefP63N/6ubeTtqquCg8PiGNNPlr7k
        zy7iuSte7+Ve29ISBb2teVrb5kLsWSr7mYeQR0Y4jwfG0Y8=
X-Google-Smtp-Source: APXvYqyfKrCzq+tAW1DSC4TumQUveGvc27el0r+xB/xC74f22ruV7zcFtbqkpr4TzPSksFFRH7LKpLjbgutEu4udI+A=
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr55728433plc.78.1563518618911;
 Thu, 18 Jul 2019 23:43:38 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Jul 2019 01:43:27 -0500
Message-ID: <CAH2r5msVEy++DoMJAwK80jpo=hpeXn7wWi11QsWLvYyS13GJcg@mail.gmail.com>
Subject: [PATCH][CIFS] Get mode bits on stat from special SID when requested
 on mount
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e170f7058e030bb1"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e170f7058e030bb1
Content-Type: text/plain; charset="UTF-8"

When mounting with "modefromsid" retrieve mode bits from
special SID (S-1-5-88-3) on stat.  Subsequent patch will fix
setattr (chmod) to save mode bits in S-1-5-88-3-<mode>

Note that when an ACE matching S-1-5-88-3 is not found, we
default the mode to an approximation based on the owner, group
and everyone permissions (as with the "cifsacl" mount option).

See See e.g.
    https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/hh509017(v=ws.10)

Below is an example of 3 files created (over NFS to Windows) with
three different modes, and note that their permissions now display
accurately:

# stat /mnt-to-windows/file0777
  File: /mnt-to-windows/file0777
  Size: 0          Blocks: 0          IO Block: 1048576 regular empty file
Device: 33h/51d Inode: 4785074604105433  Links: 1
Access: (0777/-rwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-07-19 01:31:53.728517100 +0000
Modify: 2019-07-19 01:31:53.728517100 +0000
Change: 2019-07-19 01:36:40.588153100 +0000
 Birth: -

# stat /mnt-to-windows/file0400
  File: /mnt-to-windows/file0400
  Size: 0          Blocks: 0          IO Block: 1048576 regular empty file
Device: 33h/51d Inode: 1970324836998972  Links: 1
Access: (0400/-r--------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-07-19 01:31:55.760662400 +0000
Modify: 2019-07-19 01:31:55.760662400 +0000
Change: 2019-07-19 01:36:40.588153100 +0000
 Birth: -

# stat /mnt-to-windows/file3777
  File: /mnt-to-windows/file3777
  Size: 0          Blocks: 0          IO Block: 1048576 regular empty file
Device: 33h/51d Inode: 1407374883577661  Links: 1
Access: (3777/-rwxrwsrwt)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-07-19 01:32:01.653725200 +0000
Modify: 2019-07-19 01:32:01.653725200 +0000
Change: 2019-07-19 01:36:40.588153100 +0000


-- 
Thanks,

Steve

--000000000000e170f7058e030bb1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-get-mode-bits-from-special-sid-on-stat.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-get-mode-bits-from-special-sid-on-stat.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jy9qllza0>
X-Attachment-Id: f_jy9qllza0

RnJvbSA2Zjg2ODc0YzFkMDNlZGE1YjYxODEwNjRmZGU3YjRiZjBkMmUzN2Y0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBVYnVudHUKIDxzbWZyZW5jaEB1YnVudHUxOWdjbWZhc3QuNXJl
b2U1Ym9vY3p1ZGVxcWY0aDRtdm4ydWUuanguaW50ZXJuYWwuY2xvdWRhcHAubmV0PgpEYXRlOiBG
cmksIDE5IEp1bCAyMDE5IDA2OjMwOjA3ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gY2lmczogZ2V0
IG1vZGUgYml0cyBmcm9tIHNwZWNpYWwgc2lkIG9uIHN0YXQKCldoZW4gbW91bnRpbmcgd2l0aCAi
bW9kZWZyb21zaWQiIHJldHJpZXZlIG1vZGUgYml0cyBmcm9tCnNwZWNpYWwgU0lEIChTLTEtNS04
OC0zKSBvbiBzdGF0LiAgU3Vic2VxdWVudCBwYXRjaCB3aWxsIGZpeApzZXRhdHRyIChjaG1vZCkg
dG8gc2F2ZSBtb2RlIGJpdHMgaW4gUy0xLTUtODgtMy08bW9kZT4KCk5vdGUgdGhhdCB3aGVuIGFu
IEFDRSBtYXRjaGluZyBTLTEtNS04OC0zIGlzIG5vdCBmb3VuZCwgd2UKZGVmYXVsdCB0aGUgbW9k
ZSB0byBhbiBhcHByb3hpbWF0aW9uIGJhc2VkIG9uIHRoZSBvd25lciwgZ3JvdXAKYW5kIGV2ZXJ5
b25lIHBlcm1pc3Npb25zIChhcyB3aXRoIHRoZSAiY2lmc2FjbCIgbW91bnQgb3B0aW9uKS4KClNl
ZSBTZWUgZS5nLgogICAgaHR0cHM6Ly9kb2NzLm1pY3Jvc29mdC5jb20vZW4tdXMvcHJldmlvdXMt
dmVyc2lvbnMvd2luZG93cy9pdC1wcm8vd2luZG93cy1zZXJ2ZXItMjAwOC1SMi1hbmQtMjAwOC9o
aDUwOTAxNyh2PXdzLjEwKQoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBt
aWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2FjbC5jICAgfCAzNyArKysrKysrKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLS0tCiBmcy9jaWZzL2NpZnNwcm90by5oIHwgIDEgKwogZnMv
Y2lmcy9pbm9kZS5jICAgICB8IDEzICsrKysrKysrKysrLS0KIDMgZmlsZXMgY2hhbmdlZCwgMzgg
aW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZz
YWNsLmMgYi9mcy9jaWZzL2NpZnNhY2wuYwppbmRleCAxZDM3N2I3ZjI4NjAuLjJhMTQ3NDhiOGUw
OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzYWNsLmMKKysrIGIvZnMvY2lmcy9jaWZzYWNsLmMK
QEAgLTcwMSwxMCArNzAxLDkgQEAgc3RhdGljIHZvaWQgZHVtcF9hY2Uoc3RydWN0IGNpZnNfYWNl
ICpwYWNlLCBjaGFyICplbmRfb2ZfYWNsKQogfQogI2VuZGlmCiAKLQogc3RhdGljIHZvaWQgcGFy
c2VfZGFjbChzdHJ1Y3QgY2lmc19hY2wgKnBkYWNsLCBjaGFyICplbmRfb2ZfYWNsLAogCQkgICAg
ICAgc3RydWN0IGNpZnNfc2lkICpwb3duZXJzaWQsIHN0cnVjdCBjaWZzX3NpZCAqcGdycHNpZCwK
LQkJICAgICAgIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikKKwkJICAgICAgIHN0cnVjdCBjaWZz
X2ZhdHRyICpmYXR0ciwgYm9vbCBtb2RlX2Zyb21fc3BlY2lhbF9zaWQpCiB7CiAJaW50IGk7CiAJ
aW50IG51bV9hY2VzID0gMDsKQEAgLTc1NywyMiArNzU2LDM0IEBAIHN0YXRpYyB2b2lkIHBhcnNl
X2RhY2woc3RydWN0IGNpZnNfYWNsICpwZGFjbCwgY2hhciAqZW5kX29mX2FjbCwKICNpZmRlZiBD
T05GSUdfQ0lGU19ERUJVRzIKIAkJCWR1bXBfYWNlKHBwYWNlW2ldLCBlbmRfb2ZfYWNsKTsKICNl
bmRpZgotCQkJaWYgKGNvbXBhcmVfc2lkcygmKHBwYWNlW2ldLT5zaWQpLCBwb3duZXJzaWQpID09
IDApCisJCQlpZiAobW9kZV9mcm9tX3NwZWNpYWxfc2lkICYmCisJCQkgICAgKGNvbXBhcmVfc2lk
cygmKHBwYWNlW2ldLT5zaWQpLAorCQkJCQkgICZzaWRfdW5peF9ORlNfbW9kZSkgPT0gMCkpIHsK
KwkJCQkvKgorCQkJCSAqIEZ1bGwgcGVybWlzc2lvbnMgYXJlOgorCQkJCSAqIDA3Nzc3ID0gU19J
U1VJRCB8IFNfSVNHSUQgfCBTX0lTVlRYIHwKKwkJCQkgKiAJICAgU19JUldYVSB8IFNfSVJXWEcg
fCBTX0lSV1hPCisJCQkJICovCisJCQkJZmF0dHItPmNmX21vZGUgJj0gfjA3Nzc3OworCQkJCWZh
dHRyLT5jZl9tb2RlIHw9CisJCQkJCWxlMzJfdG9fY3B1KHBwYWNlW2ldLT5zaWQuc3ViX2F1dGhb
Ml0pOworCQkJCWJyZWFrOworCQkJfSBlbHNlIGlmIChjb21wYXJlX3NpZHMoJihwcGFjZVtpXS0+
c2lkKSwgcG93bmVyc2lkKSA9PSAwKQogCQkJCWFjY2Vzc19mbGFnc190b19tb2RlKHBwYWNlW2ld
LT5hY2Nlc3NfcmVxLAogCQkJCQkJICAgICBwcGFjZVtpXS0+dHlwZSwKIAkJCQkJCSAgICAgJmZh
dHRyLT5jZl9tb2RlLAogCQkJCQkJICAgICAmdXNlcl9tYXNrKTsKLQkJCWlmIChjb21wYXJlX3Np
ZHMoJihwcGFjZVtpXS0+c2lkKSwgcGdycHNpZCkgPT0gMCkKKwkJCWVsc2UgaWYgKGNvbXBhcmVf
c2lkcygmKHBwYWNlW2ldLT5zaWQpLCBwZ3Jwc2lkKSA9PSAwKQogCQkJCWFjY2Vzc19mbGFnc190
b19tb2RlKHBwYWNlW2ldLT5hY2Nlc3NfcmVxLAogCQkJCQkJICAgICBwcGFjZVtpXS0+dHlwZSwK
IAkJCQkJCSAgICAgJmZhdHRyLT5jZl9tb2RlLAogCQkJCQkJICAgICAmZ3JvdXBfbWFzayk7Ci0J
CQlpZiAoY29tcGFyZV9zaWRzKCYocHBhY2VbaV0tPnNpZCksICZzaWRfZXZlcnlvbmUpID09IDAp
CisJCQllbHNlIGlmIChjb21wYXJlX3NpZHMoJihwcGFjZVtpXS0+c2lkKSwgJnNpZF9ldmVyeW9u
ZSkgPT0gMCkKIAkJCQlhY2Nlc3NfZmxhZ3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwK
IAkJCQkJCSAgICAgcHBhY2VbaV0tPnR5cGUsCiAJCQkJCQkgICAgICZmYXR0ci0+Y2ZfbW9kZSwK
IAkJCQkJCSAgICAgJm90aGVyX21hc2spOwotCQkJaWYgKGNvbXBhcmVfc2lkcygmKHBwYWNlW2ld
LT5zaWQpLCAmc2lkX2F1dGh1c2VycykgPT0gMCkKKwkJCWVsc2UgaWYgKGNvbXBhcmVfc2lkcygm
KHBwYWNlW2ldLT5zaWQpLCAmc2lkX2F1dGh1c2VycykgPT0gMCkKIAkJCQlhY2Nlc3NfZmxhZ3Nf
dG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwKIAkJCQkJCSAgICAgcHBhY2VbaV0tPnR5cGUs
CiAJCQkJCQkgICAgICZmYXR0ci0+Y2ZfbW9kZSwKQEAgLTg1MSw3ICs4NjIsOCBAQCBzdGF0aWMg
aW50IHBhcnNlX3NpZChzdHJ1Y3QgY2lmc19zaWQgKnBzaWQsIGNoYXIgKmVuZF9vZl9hY2wpCiAK
IC8qIENvbnZlcnQgQ0lGUyBBQ0wgdG8gUE9TSVggZm9ybSAqLwogc3RhdGljIGludCBwYXJzZV9z
ZWNfZGVzYyhzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAotCQlzdHJ1Y3QgY2lmc19udHNk
ICpwbnRzZCwgaW50IGFjbF9sZW4sIHN0cnVjdCBjaWZzX2ZhdHRyICpmYXR0cikKKwkJc3RydWN0
IGNpZnNfbnRzZCAqcG50c2QsIGludCBhY2xfbGVuLCBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIs
CisJCWJvb2wgZ2V0X21vZGVfZnJvbV9zcGVjaWFsX3NpZCkKIHsKIAlpbnQgcmMgPSAwOwogCXN0
cnVjdCBjaWZzX3NpZCAqb3duZXJfc2lkX3B0ciwgKmdyb3VwX3NpZF9wdHI7CkBAIC05MDAsNyAr
OTEyLDcgQEAgc3RhdGljIGludCBwYXJzZV9zZWNfZGVzYyhzdHJ1Y3QgY2lmc19zYl9pbmZvICpj
aWZzX3NiLAogCiAJaWYgKGRhY2xvZmZzZXQpCiAJCXBhcnNlX2RhY2woZGFjbF9wdHIsIGVuZF9v
Zl9hY2wsIG93bmVyX3NpZF9wdHIsCi0JCQkgICBncm91cF9zaWRfcHRyLCBmYXR0cik7CisJCQkg
ICBncm91cF9zaWRfcHRyLCBmYXR0ciwgZ2V0X21vZGVfZnJvbV9zcGVjaWFsX3NpZCk7CiAJZWxz
ZQogCQljaWZzX2RiZyhGWUksICJubyBBQ0xcbiIpOyAvKiBCQiBncmFudCBhbGwgb3IgZGVmYXVs
dCBwZXJtcz8gKi8KIApAQCAtMTEyOCw4ICsxMTQwLDggQEAgaW50IHNldF9jaWZzX2FjbChzdHJ1
Y3QgY2lmc19udHNkICpwbm50c2QsIF9fdTMyIGFjbGxlbiwKIC8qIFRyYW5zbGF0ZSB0aGUgQ0lG
UyBBQ0wgKHNpbWlsYXIgdG8gTlRGUyBBQ0wpIGZvciBhIGZpbGUgaW50byBtb2RlIGJpdHMgKi8K
IGludAogY2lmc19hY2xfdG9fZmF0dHIoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3Ry
dWN0IGNpZnNfZmF0dHIgKmZhdHRyLAotCQkgIHN0cnVjdCBpbm9kZSAqaW5vZGUsIGNvbnN0IGNo
YXIgKnBhdGgsCi0JCSAgY29uc3Qgc3RydWN0IGNpZnNfZmlkICpwZmlkKQorCQkgIHN0cnVjdCBp
bm9kZSAqaW5vZGUsIGJvb2wgbW9kZV9mcm9tX3NwZWNpYWxfc2lkLAorCQkgIGNvbnN0IGNoYXIg
KnBhdGgsIGNvbnN0IHN0cnVjdCBjaWZzX2ZpZCAqcGZpZCkKIHsKIAlzdHJ1Y3QgY2lmc19udHNk
ICpwbnRzZCA9IE5VTEw7CiAJdTMyIGFjbGxlbiA9IDA7CkBAIC0xMTU2LDggKzExNjgsMTEgQEAg
Y2lmc19hY2xfdG9fZmF0dHIoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IGNp
ZnNfZmF0dHIgKmZhdHRyLAogCWlmIChJU19FUlIocG50c2QpKSB7CiAJCXJjID0gUFRSX0VSUihw
bnRzZCk7CiAJCWNpZnNfZGJnKFZGUywgIiVzOiBlcnJvciAlZCBnZXR0aW5nIHNlYyBkZXNjXG4i
LCBfX2Z1bmNfXywgcmMpOworCX0gZWxzZSBpZiAobW9kZV9mcm9tX3NwZWNpYWxfc2lkKSB7CisJ
CXJjID0gcGFyc2Vfc2VjX2Rlc2MoY2lmc19zYiwgcG50c2QsIGFjbGxlbiwgZmF0dHIsIHRydWUp
OwogCX0gZWxzZSB7Ci0JCXJjID0gcGFyc2Vfc2VjX2Rlc2MoY2lmc19zYiwgcG50c2QsIGFjbGxl
biwgZmF0dHIpOworCQkvKiBnZXQgYXBwcm94aW1hdGVkIG1vZGUgZnJvbSBBQ0wgKi8KKwkJcmMg
PSBwYXJzZV9zZWNfZGVzYyhjaWZzX3NiLCBwbnRzZCwgYWNsbGVuLCBmYXR0ciwgZmFsc2UpOwog
CQlrZnJlZShwbnRzZCk7CiAJCWlmIChyYykKIAkJCWNpZnNfZGJnKFZGUywgInBhcnNlIHNlYyBk
ZXNjIGZhaWxlZCByYyA9ICVkXG4iLCByYyk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90
by5oIGIvZnMvY2lmcy9jaWZzcHJvdG8uaAppbmRleCBlMjMyMzQyMDdmYzIuLjJkZWY4NzJlYTcy
NyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcHJvdG8uaAorKysgYi9mcy9jaWZzL2NpZnNwcm90
by5oCkBAIC0xOTcsNiArMTk3LDcgQEAgZXh0ZXJuIGludCBjaWZzX3JlbmFtZV9wZW5kaW5nX2Rl
bGV0ZShjb25zdCBjaGFyICpmdWxsX3BhdGgsCiAJCQkJICAgICAgY29uc3QgdW5zaWduZWQgaW50
IHhpZCk7CiBleHRlcm4gaW50IGNpZnNfYWNsX3RvX2ZhdHRyKHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IsCiAJCQkgICAgICBzdHJ1Y3QgY2lmc19mYXR0ciAqZmF0dHIsIHN0cnVjdCBpbm9k
ZSAqaW5vZGUsCisJCQkgICAgICBib29sIGdldF9tb2RlX2Zyb21fc3BlY2lhbF9zaWQsCiAJCQkg
ICAgICBjb25zdCBjaGFyICpwYXRoLCBjb25zdCBzdHJ1Y3QgY2lmc19maWQgKnBmaWQpOwogZXh0
ZXJuIGludCBpZF9tb2RlX3RvX2NpZnNfYWNsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGNvbnN0IGNo
YXIgKnBhdGgsIF9fdTY0LAogCQkJCQlrdWlkX3QsIGtnaWRfdCk7CmRpZmYgLS1naXQgYS9mcy9j
aWZzL2lub2RlLmMgYi9mcy9jaWZzL2lub2RlLmMKaW5kZXggNTZjYTRiOGNjYWJhLi5jMWU2MjBl
YmNmN2MgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW5vZGUuYworKysgYi9mcy9jaWZzL2lub2RlLmMK
QEAgLTg5Myw4ICs4OTMsMTcgQEAgY2lmc19nZXRfaW5vZGVfaW5mbyhzdHJ1Y3QgaW5vZGUgKipp
bm9kZSwgY29uc3QgY2hhciAqZnVsbF9wYXRoLAogCX0KIAogCS8qIGZpbGwgaW4gMDc3NyBiaXRz
IGZyb20gQUNMICovCi0JaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9D
SUZTX0FDTCkgewotCQlyYyA9IGNpZnNfYWNsX3RvX2ZhdHRyKGNpZnNfc2IsICZmYXR0ciwgKmlu
b2RlLCBmdWxsX3BhdGgsIGZpZCk7CisJaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lG
U19NT1VOVF9NT0RFX0ZST01fU0lEKSB7CisJCXJjID0gY2lmc19hY2xfdG9fZmF0dHIoY2lmc19z
YiwgJmZhdHRyLCAqaW5vZGUsIHRydWUsCisJCQkJICAgICAgIGZ1bGxfcGF0aCwgZmlkKTsKKwkJ
aWYgKHJjKSB7CisJCQljaWZzX2RiZyhGWUksICIlczogR2V0IG1vZGUgZnJvbSBTSUQgZmFpbGVk
LiByYz0lZFxuIiwKKwkJCQlfX2Z1bmNfXywgcmMpOworCQkJZ290byBjZ2lpX2V4aXQ7CisJCX0K
Kwl9IGVsc2UgaWYgKGNpZnNfc2ItPm1udF9jaWZzX2ZsYWdzICYgQ0lGU19NT1VOVF9DSUZTX0FD
TCkgeworCQlyYyA9IGNpZnNfYWNsX3RvX2ZhdHRyKGNpZnNfc2IsICZmYXR0ciwgKmlub2RlLCBm
YWxzZSwKKwkJCQkgICAgICAgZnVsbF9wYXRoLCBmaWQpOwogCQlpZiAocmMpIHsKIAkJCWNpZnNf
ZGJnKEZZSSwgIiVzOiBHZXR0aW5nIEFDTCBmYWlsZWQgd2l0aCBlcnJvcjogJWRcbiIsCiAJCQkJ
IF9fZnVuY19fLCByYyk7Ci0tIAoyLjIwLjEKCg==
--000000000000e170f7058e030bb1--
