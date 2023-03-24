Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47604C6FD20
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 17:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjCXRyY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 13:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbjCXRyL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 13:54:11 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFDC1ADD8
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 10:53:21 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id br6so3222436lfb.11
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 10:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680389;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IzWWw8/xJJwc6X0kI0qfm7SaTg961YUDaeoAS3yFHlg=;
        b=dyx9YptcS5KXdF0BGA6ue6XeVAmg5y3SfUl8tgNIPExmPkLPAaBen/W79uuR+rWLUy
         5g84I0LZGVV4V8NLPkUfAIHAVWSZYQrMNfnJMtQF98XlMSqCEtAFpEpMrTQ7r+uk8tl8
         Qzy/WIDordJgC3d19c6WywSSXRzrWDR7n/uWfkHvKb+Sem7mtf/rj8s3MLqej0rS7bg2
         UcgHa+knzBwXIVZx0EQEXG430gVoyeaJR4WxKR5ytQHBVJom6GU1F5tBw3g96bQrSSY1
         NQqSV6lrYcn+kvkl0mQCI5cz7Y/XHn7JjmNm6oE39On052gytM4oGNiKFCr6gMgtOoUt
         XYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680389;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IzWWw8/xJJwc6X0kI0qfm7SaTg961YUDaeoAS3yFHlg=;
        b=rfj7IW2/gJhOhokZceD6hHs2IsbFn5gUK7R3PdkroqvzmDas2Bw9q81qXbS0A72cys
         T6VX2YshEadMiQGceJJ+KsEeGcbvfR/xrUeZtczQhE9qd/R2PND8feK2S9kUnY5X4zOC
         xPHwRlAGHFlxEmqAx1i3dcr0ayRGWx3R9zDNjGpT+TUpk7KOqnWHvJTT1qboaOwO1LTO
         Z+OcKDbpFzqcuAxjiZDaPgpONnV0bRL5FLxiB2yvYVNSfMGqlf3zYIusyXp4xsBMLYwN
         jVeCSRPH9ZotIlq/ArSA2yPnVlqPGGoQYQiVcH6HPEeDwx+Hv7EkLf9drXnSOQWZAF2j
         nGUQ==
X-Gm-Message-State: AAQBX9emkTr6qYI7E4sAPobdiSmTu7/uz6WruG0jC1uhJgMJzVGyhpKp
        PafmuL/4m9JdDMoLYBPypGfCRhCkg8WdVo3c1LLhaZEl
X-Google-Smtp-Source: AKy350aq7wTf6GJLr2ub1tSj85453Q2wIvhEgwDiKSuhXaJey+rUubSWngfcU8quvtULkXWIUVUDbSG99NwLAwLoNAE=
X-Received: by 2002:ac2:5448:0:b0:4ea:fafd:e669 with SMTP id
 d8-20020ac25448000000b004eafafde669mr994943lfn.10.1679680388831; Fri, 24 Mar
 2023 10:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvJvJdo61-qQ6GjCw_NBL7ZM6dx-9SaacaKpRb0rgGpFQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvJvJdo61-qQ6GjCw_NBL7ZM6dx-9SaacaKpRb0rgGpFQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 24 Mar 2023 12:52:57 -0500
Message-ID: <CAH2r5mvtbUFYnMV5KSeuR6s-bMk-cQ5_0+QLxZ3y1oq0dSdpqg@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix unusable share after force unmount failure
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e9ba4a05f7a91009"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e9ba4a05f7a91009
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated based on Paulo's feedback (moved the TID_EXITING up so it is
inside the tc_locktc_unlock).  See attached.




On Thu, Mar 23, 2023 at 4:30=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> If user does forced unmount ("umount -f") while files are still open
> on the share (as was seen in a Kubernetes example running on SMB3.1.1
> mount) then we were marking the share as "TID_EXITING" in umount_begin()
> which caused all subsequent operations (except write) to fail ... but
> unfortunately when umount_begin() is called we do not know yet that
> there are open files or active references on the share that would prevent
> unmount from succeeding.  Kubernetes had example when they were doing
> umount -f when files were open which caused the share to become
> unusable until the files were closed (and the umount retried).
>
> Fix this so that TID_EXITING is not set until we are about to send
> the tree disconnect (not at the beginning of forced umounts in
> umount_begin) so that if "umount -f" fails (due to open files or
> references) the mount is still usable.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve French <stfrench@microsoft.com>
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000e9ba4a05f7a91009
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-SMB3-Close-deferred-file-handles-if-we-get-handle-le.patch"
Content-Disposition: attachment; 
	filename="0003-SMB3-Close-deferred-file-handles-if-we-get-handle-le.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lfmubs480>
X-Attachment-Id: f_lfmubs480

RnJvbSBmZjhjZmZmYmEwNTliM2I4ZGI5MTUyMzEyYTYyMzM1OTI2NzI0ZmEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVGh1LCAyMyBNYXIgMjAyMyAxOTowNTowMCArMDAwMApTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBTTUIzOiBDbG9zZSBkZWZlcnJlZCBmaWxlIGhhbmRsZXMgaWYgd2UgZ2V0IGhhbmRsZSBsZWFz
ZQogYnJlYWsKCldlIHNob3VsZCBub3QgY2FjaGUgZGVmZXJyZWQgZmlsZSBoYW5kbGVzIGlmIHdl
IGRvbnQgaGF2ZQpoYW5kbGUgbGVhc2Ugb24gYSBmaWxlLiBBbmQgd2Ugc2hvdWxkIGltbWVkaWF0
ZWx5IGNsb3NlIGFsbApkZWZlcnJlZCBoYW5kbGVzIGluIGNhc2Ugb2YgaGFuZGxlIGxlYXNlIGJy
ZWFrLiBUaGlzIGlzCnZlcnkgaW1wb3J0YW50IGUuZy4gdG8gcHJldmVudCBhY2Nlc3MgZGVuaWVk
IGVycm9ycwppbiB3cml0aW5nIHRvIHRoZSBzYW1lIGZpbGUgZnJvbSBhIGRpZmZlcmVudCBjbGll
bnQgKGR1cmluZwp0aGlzIGludGVydmFsIHdoaWxlIHRoZSBjbG9zZSBpcyBkZWZlcnJlZCkuCgpT
aWduZWQtb2ZmLWJ5OiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4KRml4ZXM6
IDllMzE2NzhmYjQwMyAoIlNNQjM6IGZpeCBsZWFzZSBicmVhayB0aW1lb3V0IHdoZW4gbXVsdGlw
bGUgZGVmZXJyZWQgY2xvc2UgaGFuZGxlcyBmb3IgdGhlIHNhbWUgZmlsZS4iKQpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZyAjIDYuMCsKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZy
ZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAgMyArKy0KIGZz
L2NpZnMvZmlsZS5jICAgICAgfCAyMSArKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvbWlz
Yy5jICAgICAgfCAgNCArKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8uaCBiL2ZzL2NpZnMv
Y2lmc3Byb3RvLmgKaW5kZXggZTJlZmY2NmVlZmFiLi5kMjgxOWQ0NDlmMDUgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc3Byb3RvLmgKKysrIGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtMjc4LDcg
KzI3OCw4IEBAIGV4dGVybiB2b2lkIGNpZnNfYWRkX2RlZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZz
RmlsZUluZm8gKmNmaWxlLAogCiBleHRlcm4gdm9pZCBjaWZzX2RlbF9kZWZlcnJlZF9jbG9zZShz
dHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSk7CiAKLWV4dGVybiB2b2lkIGNpZnNfY2xvc2VfZGVm
ZXJyZWRfZmlsZShzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lmc19pbm9kZSk7CitleHRlcm4gdm9p
ZCBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5v
ZGUsCisJCQkJICAgICBib29sIHdhaXRfb3Bsb2NrX2hhbmRsZXIpOwogCiBleHRlcm4gdm9pZCBj
aWZzX2Nsb3NlX2FsbF9kZWZlcnJlZF9maWxlcyhzdHJ1Y3QgY2lmc190Y29uICpjaWZzX3Rjb24p
OwogCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmlsZS5jCmluZGV4IDY4
MzFhOTk0OWM0My4uNDdmNjFhNTFmNTUyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2ZpbGUuYworKysg
Yi9mcy9jaWZzL2ZpbGUuYwpAQCAtNDg4NCw2ICs0ODg0LDkgQEAgdm9pZCBjaWZzX29wbG9ja19i
cmVhayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNp
bm9kZSA9IENJRlNfSShpbm9kZSk7CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IHRsaW5rX3Rj
b24oY2ZpbGUtPnRsaW5rKTsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIgPSB0Y29u
LT5zZXMtPnNlcnZlcjsKKwlib29sIGlzX2RlZmVycmVkID0gZmFsc2U7CisJc3RydWN0IGNpZnNf
ZGVmZXJyZWRfY2xvc2UgKmRjbG9zZTsKKwogCWludCByYyA9IDA7CiAJYm9vbCBwdXJnZV9jYWNo
ZSA9IGZhbHNlOwogCkBAIC00OTIxLDYgKzQ5MjQsMjMgQEAgdm9pZCBjaWZzX29wbG9ja19icmVh
ayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCWNpZnNfZGJnKFZGUywgIlB1c2ggbG9ja3Mg
cmMgPSAlZFxuIiwgcmMpOwogCiBvcGxvY2tfYnJlYWtfYWNrOgorCS8qCisJICogV2hlbiBvcGxv
Y2sgYnJlYWsgaXMgcmVjZWl2ZWQgYW5kIHRoZXJlIGFyZSBubyBhY3RpdmUgZmlsZSBoYW5kbGVz
CisJICogYnV0IGNhY2hlZCBmaWxlIGhhbmRsZXMsIHRoZW4gc2NoZWR1bGUgZGVmZXJyZWQgY2xv
c2UgaW1tZWRpYXRlbHkuCisJICogU28sIG5ldyBvcGVuIHdpbGwgbm90IHVzZSBjYWNoZWQgaGFu
ZGxlLgorCSAqLworCXNwaW5fbG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7CisJ
aXNfZGVmZXJyZWQgPSBjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKTsKKwlz
cGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRfbG9jayk7CisJaWYgKCFDSUZTX0NB
Q0hFX0hBTkRMRShjaW5vZGUpICYmIGlzX2RlZmVycmVkICYmCisJCQljZmlsZS0+ZGVmZXJyZWRf
Y2xvc2Vfc2NoZWR1bGVkICYmIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQp
KSB7CisJCWlmIChjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CisJCQlf
Y2lmc0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFsc2UsIGZhbHNlKTsKKwkJCWNpZnNfY2xvc2VfZGVm
ZXJyZWRfZmlsZShjaW5vZGUsIGZhbHNlKTsKKwkJCWdvdG8gb3Bsb2NrX2JyZWFrX2RvbmU7CisJ
CX0KKwl9CisKIAkvKgogCSAqIHJlbGVhc2luZyBzdGFsZSBvcGxvY2sgYWZ0ZXIgcmVjZW50IHJl
Y29ubmVjdCBvZiBzbWIgc2Vzc2lvbiB1c2luZwogCSAqIGEgbm93IGluY29ycmVjdCBmaWxlIGhh
bmRsZSBpcyBub3QgYSBkYXRhIGludGVncml0eSBpc3N1ZSBidXQgZG8KQEAgLTQ5MzMsNiArNDk1
Myw3IEBAIHZvaWQgY2lmc19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQog
CQljaWZzX2RiZyhGWUksICJPcGxvY2sgcmVsZWFzZSByYyA9ICVkXG4iLCByYyk7CiAJfQogCitv
cGxvY2tfYnJlYWtfZG9uZToKIAlfY2lmc0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFsc2UgLyogZG8g
bm90IHdhaXQgZm9yIG91cnNlbGYgKi8sIGZhbHNlKTsKIAljaWZzX2RvbmVfb3Bsb2NrX2JyZWFr
KGNpbm9kZSk7CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5j
CmluZGV4IGI0NGZiNTE5NjhiZi4uZmU0YmYxZjlkZTkxIDEwMDY0NAotLS0gYS9mcy9jaWZzL21p
c2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAtNzM1LDcgKzczNSw3IEBAIGNpZnNfZGVsX2Rl
ZmVycmVkX2Nsb3NlKHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKQogfQogCiB2b2lkCi1jaWZz
X2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUpCitj
aWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUs
IGJvb2wgd2FpdF9vcGxvY2tfaGFuZGxlcikKIHsKIAlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmls
ZSA9IE5VTEw7CiAJc3RydWN0IGZpbGVfbGlzdCAqdG1wX2xpc3QsICp0bXBfbmV4dF9saXN0OwpA
QCAtNzYyLDcgKzc2Miw3IEBAIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShzdHJ1Y3QgY2lmc0lu
b2RlSW5mbyAqY2lmc19pbm9kZSkKIAlzcGluX3VubG9jaygmY2lmc19pbm9kZS0+b3Blbl9maWxl
X2xvY2spOwogCiAJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHRtcF9saXN0LCB0bXBfbmV4dF9s
aXN0LCAmZmlsZV9oZWFkLCBsaXN0KSB7Ci0JCV9jaWZzRmlsZUluZm9fcHV0KHRtcF9saXN0LT5j
ZmlsZSwgdHJ1ZSwgZmFsc2UpOworCQlfY2lmc0ZpbGVJbmZvX3B1dCh0bXBfbGlzdC0+Y2ZpbGUs
IHdhaXRfb3Bsb2NrX2hhbmRsZXIsIGZhbHNlKTsKIAkJbGlzdF9kZWwoJnRtcF9saXN0LT5saXN0
KTsKIAkJa2ZyZWUodG1wX2xpc3QpOwogCX0KLS0gCjIuMzQuMQoK
--000000000000e9ba4a05f7a91009--
