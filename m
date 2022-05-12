Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5562C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 12 May 2022 15:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349369AbiELPtX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 May 2022 11:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356108AbiELPtW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 May 2022 11:49:22 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBBBC9EFB
        for <linux-cifs@vger.kernel.org>; Thu, 12 May 2022 08:49:21 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y32so9826471lfa.6
        for <linux-cifs@vger.kernel.org>; Thu, 12 May 2022 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=hIek/J6WRVp1VcpYA+pPPTz/t8K/ZfRth38UzsHQXQU=;
        b=gKBk3IIMLNczoQ7To1iL3ogqDr/Od/08v5lHTJqfsL8HpwtXPBTkvGXHIVsabvIPln
         uuT2p6xJCxJjCTGhQGIsV1D98SCN67U2vLELYEMu+IxbAND1hIMb5gmyYp1kYJ9o31OD
         CPGkZtpfPnpDaNODIWPiUPp+X9ksKS4MLwiQyF62oDgrIG9zYrSNw7eJCI5B1rhJAprz
         XQTcq2JcH6c9zbe1RWf3SSgL9KwIoZT9HDttUqGAAuAsCOyED3iHZGOG5JMF6WCiuh0O
         bxz+MmP0W+U/RZLaN2oHsdzs6uIF/k5eCJFD4MGh/LNLItvhpd1y32CA+sIodBU2OeMf
         7X6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hIek/J6WRVp1VcpYA+pPPTz/t8K/ZfRth38UzsHQXQU=;
        b=UbCXjNRcxtCMLVk2p8VUzeDfNIsm+Wlq8v5F0tCNVsTu75mTWO2Je0WYH6dRC7haGD
         KZ5dUXYpgTEXnD51vbaD4C4cTNrGPvgY+jxWDAf3y0l4+UDyyEXUELDTvbtTUKcJofdu
         +8VI9ZUwx6KEXAtAPNbkhOYrMMzkfWwO+2mnhvhNiTXjqVL1fkWIDI46SR6UfvOJAgLE
         UDC9xS6CREBTTFc7MLVUrQCsYLUOg3rk3M8RHyrEIhUtATKw3U9QI06xolgabUOLEMhL
         QsHQWAW1Wte4d+zHLLQJPRSU+Dr51wHOGrNwjFhpTaSfgt3WvRDJM8CdVjtT2Hl5aZPa
         WauA==
X-Gm-Message-State: AOAM533OJm77k82x3GilnR4MNaEcTqXML37jNd3DBo22q28cp5QOVy1m
        DrVoPLbJI2VltIiVwJna6j7883rQeKPlZUg1npotRmhECgo=
X-Google-Smtp-Source: ABdhPJzGugCI3Ifr7gKGTimP5nSBQyb8Ap2L4ngToqACFsPXn+S1v5YVKSEULZHiGLk9ZSQ+4XjFAsIwzJwK4u6h1gs=
X-Received: by 2002:ac2:561b:0:b0:472:586b:3209 with SMTP id
 v27-20020ac2561b000000b00472586b3209mr308044lfd.234.1652370558853; Thu, 12
 May 2022 08:49:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 May 2022 10:49:07 -0500
Message-ID: <CAH2r5msJeMzyMSSq_2xea7Qz1=e1UO0XpVVdHS-xH9tS93czsA@mail.gmail.com>
Subject: [PATCH][SMB3] EBADF/EIO errors in rename/open caused by race
 condition in smb2_compound_op
To:     CIFS <linux-cifs@vger.kernel.org>,
        Ondrej Hubsch <ohubsch@purestorage.com>,
        Ralph Boehme <slow@samba.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="00000000000032ed1605ded28001"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000032ed1605ded28001
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Created patch and merged into cifs-2.6.git for-next (pending  the
usual regression testing runs) from the good work Ondrej did on
https://bugzilla.samba.org/show_bug.cgi?id=3D15051

See attached.

There is  a race condition in smb2_compound_op:

    ---
    after_close:
            num_rqst++;

            if (cfile) {
                    cifsFileInfo_put(cfile); // sends SMB2_CLOSE to the ser=
ver
                    cfile =3D NULL;
    ---
This is triggered by smb2_query_path_info operation that happens
during revalidate_dentry. In smb2_query_path_info, get_readable_path
is called to load the cfile, increasing the reference counter. If in
the meantime, this reference becomes the very last, this call to
cifsFileInfo_put(cfile) will trigger a SMB2_CLOSE request sent to the
server just before sending this compound request =E2=80=93 and so then the
compound request fails either with EBADF/EIO depending on the timing
at the server, because the handle is already closed.

--
Thanks,

Steve

--00000000000032ed1605ded28001
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-SMB3-EBADF-EIO-errors-in-rename-open-caused-by-race-.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-EBADF-EIO-errors-in-rename-open-caused-by-race-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l336nhgu0>
X-Attachment-Id: f_l336nhgu0

RnJvbSA0NjUzMDFlMzljMWY3MjY4YjZlZGZiMTYwODViZWJiMzFjNTA3ZGQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTIgTWF5IDIwMjIgMTA6MTg6MDAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBFQkFERi9FSU8gZXJyb3JzIGluIHJlbmFtZS9vcGVuIGNhdXNlZCBieSByYWNlCiBjb25k
aXRpb24gaW4gc21iMl9jb21wb3VuZF9vcApNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6
IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJp
dAoKVGhlcmUgaXMgIGEgcmFjZSBjb25kaXRpb24gaW4gc21iMl9jb21wb3VuZF9vcDoKCi0tLQph
ZnRlcl9jbG9zZToKCW51bV9ycXN0Kys7CgoJaWYgKGNmaWxlKSB7CgkJY2lmc0ZpbGVJbmZvX3B1
dChjZmlsZSk7IC8vIHNlbmRzIFNNQjJfQ0xPU0UgdG8gdGhlIHNlcnZlcgoJCWNmaWxlID0gTlVM
TDsKLS0tCgpUaGlzIGlzIHRyaWdnZXJlZCBieSBzbWIyX3F1ZXJ5X3BhdGhfaW5mbyBvcGVyYXRp
b24gdGhhdCBoYXBwZW5zIGR1cmluZwpyZXZhbGlkYXRlX2RlbnRyeS4gSW4gc21iMl9xdWVyeV9w
YXRoX2luZm8sIGdldF9yZWFkYWJsZV9wYXRoIGlzIGNhbGxlZCB0bwpsb2FkIHRoZSBjZmlsZSwg
aW5jcmVhc2luZyB0aGUgcmVmZXJlbmNlIGNvdW50ZXIuIElmIGluIHRoZSBtZWFudGltZSwgdGhp
cwpyZWZlcmVuY2UgYmVjb21lcyB0aGUgdmVyeSBsYXN0LCB0aGlzIGNhbGwgdG8gY2lmc0ZpbGVJ
bmZvX3B1dChjZmlsZSkgd2lsbAp0cmlnZ2VyIGEgU01CMl9DTE9TRSByZXF1ZXN0IHNlbnQgdG8g
dGhlIHNlcnZlciBqdXN0IGJlZm9yZSBzZW5kaW5nIHRoaXMgY29tcG91bmQKcmVxdWVzdCDigJMg
YW5kIHNvIHRoZW4gdGhlIGNvbXBvdW5kIHJlcXVlc3QgZmFpbHMgZWl0aGVyIHdpdGggRUJBREYv
RUlPIGRlcGVuZGluZwpvbiB0aGUgdGltaW5nIGF0IHRoZSBzZXJ2ZXIsIGJlY2F1c2UgdGhlIGhh
bmRsZSBpcyBhbHJlYWR5IGNsb3NlZC4KCkluIHRoZSBmaXJzdCBzY2VuYXJpbywgdGhlIHJhY2Ug
c2VlbXMgdG8gYmUgaGFwcGVuaW5nIGJldHdlZW4gc21iMl9xdWVyeV9wYXRoX2luZm8KdHJpZ2dl
cmVkIGJ5IHRoZSByZW5hbWUgb3BlcmF0aW9uLCBhbmQgYmV0d2VlbiDigJxjbGVhbnVw4oCdIG9m
IGFzeW5jaHJvbm91cyB3cml0ZXMg4oCTIHdoaWxlCmZzeW5jKGZkKSBsaWtlbHkgd2FpdHMgZm9y
IHRoZSBhc3luY2hyb25vdXMgd3JpdGVzIHRvIGNvbXBsZXRlLCByZWxlYXNpbmcgdGhlIHdyaXRl
YmFjawpzdHJ1Y3R1cmVzIGNhbiBoYXBwZW4gYWZ0ZXIgdGhlIGNsb3NlKGZkKSBjYWxsLiBTbyB0
aGUgRUJBREYvRUlPIGVycm9ycyB3aWxsIHBvcCB1cCBpZgp0aGUgdGltaW5nIGlzIHN1Y2ggdGhh
dDoKMSkgVGhlcmUgYXJlIHN0aWxsIG91dHN0YW5kaW5nIHJlZmVyZW5jZXMgYWZ0ZXIgY2xvc2Uo
ZmQpIGluIHRoZSB3cml0ZWJhY2sgc3RydWN0dXJlcwoyKSBzbWIyX3F1ZXJ5X3BhdGhfaW5mbyBz
dWNjZXNzZnVsbHkgZmV0Y2hlcyB0aGUgY2ZpbGUsIGluY3JlYXNpbmcgdGhlIHJlZmNvdW50ZXIg
YnkgMQozKSBBbGwgd3JpdGViYWNrIHN0cnVjdHVyZXMgcmVsZWFzZSB0aGUgc2FtZSBjZmlsZSwg
cmVkdWNpbmcgcmVmY291bnRlciB0byAxCjQpIHNtYjJfY29tcG91bmRfb3AgaXMgY2FsbGVkIHdp
dGggdGhhdCBjZmlsZQoKSW4gdGhlIHNlY29uZCBzY2VuYXJpbywgdGhlIHJhY2Ugc2VlbXMgdG8g
YmUgc2ltaWxhciDigJMgaGVyZSBvcGVuIHRyaWdnZXJzIHRoZQpzbWIyX3F1ZXJ5X3BhdGhfaW5m
byBvcGVyYXRpb24sIGFuZCBpZiBhbGwgb3RoZXIgdGhyZWFkcyBpbiB0aGUgbWVhbnRpbWUgZGVj
cmVhc2UgdGhlCnJlZmNvdW50ZXIgdG8gMSBzaW1pbGFybHkgdG8gdGhlIGZpcnN0IHNjZW5hcmlv
LCBhZ2FpbiBTTUIyX0NMT1NFIHdpbGwgYmUgc2VudCB0byB0aGUKc2VydmVyIGp1c3QgYmVmb3Jl
IGlzc3VpbmcgdGhlIGNvbXBvdW5kIHJlcXVlc3QuIFRoaXMgY2FzZSBpcyBoYXJkZXIgdG8gcmVw
cm9kdWNlLgoKU2VlIGh0dHBzOi8vYnVnemlsbGEuc2FtYmEub3JnL3Nob3dfYnVnLmNnaT9pZD0x
NTA1MQoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKRml4ZXM6IDhkZTllODZjNjdiYSAoImNp
ZnM6IGNyZWF0ZSBhIGhlbHBlciB0byBmaW5kIGEgd3JpdGVhYmxlIGhhbmRsZSBieSBwYXRoIG5h
bWUiKQpTaWduZWQtb2ZmLWJ5OiBPbmRyZWogSHVic2NoIDxvaHVic2NoQHB1cmVzdG9yYWdlLmNv
bT4KUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KUmV2
aWV3ZWQtYnk6IFBhdWxvIEFsY2FudGFyYSAoU1VTRSkgPHBjQGNqci5uej4KU2lnbmVkLW9mZi1i
eTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21i
Mmlub2RlLmMgfCAyIC0tCiAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3NtYjJpbm9kZS5jIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwppbmRleCBmZTVi
ZmEyNDVmYTcuLjFiODliOWI4YTIxMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyaW5vZGUuYwor
KysgYi9mcy9jaWZzL3NtYjJpbm9kZS5jCkBAIC0zNjIsOCArMzYyLDYgQEAgc21iMl9jb21wb3Vu
ZF9vcChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCW51
bV9ycXN0Kys7CiAKIAlpZiAoY2ZpbGUpIHsKLQkJY2lmc0ZpbGVJbmZvX3B1dChjZmlsZSk7Ci0J
CWNmaWxlID0gTlVMTDsKIAkJcmMgPSBjb21wb3VuZF9zZW5kX3JlY3YoeGlkLCBzZXMsIHNlcnZl
ciwKIAkJCQkJZmxhZ3MsIG51bV9ycXN0IC0gMiwKIAkJCQkJJnJxc3RbMV0sICZyZXNwX2J1ZnR5
cGVbMV0sCi0tIAoyLjM0LjEKCg==
--00000000000032ed1605ded28001--
