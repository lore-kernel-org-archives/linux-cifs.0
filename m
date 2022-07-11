Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098A1C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Jul 2022 03:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiGKDQM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 10 Jul 2022 23:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKDQK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 10 Jul 2022 23:16:10 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEEC13D6D
        for <linux-cifs@vger.kernel.org>; Sun, 10 Jul 2022 20:16:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j3so3714993pfb.6
        for <linux-cifs@vger.kernel.org>; Sun, 10 Jul 2022 20:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=DBgxnktNUZ6iUbTeXr82wxYoqPsyQjoU+AOfbLzGAdo=;
        b=hRPil8KWVcjAtxmY+JGUwJhWL8BN4yQZJtj28JjRQj00LTmjBy/eGx2gXI+xAtXRZK
         OO7PrYXrmKzUJYe1KLkKoGvsOZFzgCcM+Q6stjeeAqtH50lALBPqk7WGGZRm7HPWPukd
         7y6XffdkYTTWhiYlRY4tkBe61iO6PeWzeT13Cbgd2m/8D967ft1fDJQUIK9JGaBAJzmY
         YSfnpk5sF5gpvirByntMKb7h4/hJYaHYvwkFhiYm/bRJBGHabJ7wYTQDOIFZ8F8fubff
         pazmze2dqcQrj95C6hU1s7NqRyStVvjocSRgND518TMRWJvFTlGOP62XjYOWZVsCwkmK
         n7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DBgxnktNUZ6iUbTeXr82wxYoqPsyQjoU+AOfbLzGAdo=;
        b=mYm5ZSPAJuitOcyVFLgw7mYTKNP7M5mrb0s+WgfN8rBxPPXukGJetRV5R49JRfIO7N
         OGguAJ/Lna97zOyVKPFxpzde2doRMLxCFmH4wHWCF0wXHrcjc5tvbEV9qnFn40BeReRr
         FfSOAKU4xRwVHJBhO4d+QhXjB2Z6sKryViIdjSMcjw9EQYd04q5jVAPZ+sNFrMq5nF4I
         9hSPmeXktW8CY2msXIbGT9/QPUAdmvOtyu8qd8vbGNAYf7hV6BPNSXIf3MPJUPqVaUJ0
         0Wxshvc/7xscaL7lKNDukjXc0H4MpMadPwAZCTlVoAz3+LTyNbP+qIp8IiZIuNRLrbwB
         50IA==
X-Gm-Message-State: AJIora+XbTLM/eMXGQemQ7RJEAJVLfVSUjqoc/UkzeG0oXwyjpmEQ+eD
        yNaH1u38/htkLgzy3+c+zCGl4WwwNX/cOdjltZBn0qGwYYQ=
X-Google-Smtp-Source: AGRyM1vdSpn5TbomETEb6MFx6aipknPsrwbjM/h1p/pypBGAKn7276h5SQzlQ0XTygmPC4FtcBJ9kLWJtp1ewjyte1c=
X-Received: by 2002:a63:2bcb:0:b0:412:2f70:92bb with SMTP id
 r194-20020a632bcb000000b004122f7092bbmr14163158pgr.439.1657509369041; Sun, 10
 Jul 2022 20:16:09 -0700 (PDT)
MIME-Version: 1.0
From:   Brian Caine <brian.d.caine@gmail.com>
Date:   Sun, 10 Jul 2022 23:09:06 -0400
Message-ID: <CAARpZ=_WCZhEZ2DzR3jRNLNLx28duH2iSn7WwRVezGKpjX0LDA@mail.gmail.com>
Subject: mount.cifs broken after update, advice?
To:     linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000276c4305e37ef9fb"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000276c4305e37ef9fb
Content-Type: text/plain; charset="UTF-8"

Hey all,

So I recently updated my kernel and my previously-working CIFS
mountpoints are broken. The server hasn't changed.

I can successfully access it via smbclient. Only mount.cifs is broken.

On the server:

% /usr/local/sbin/smbd --version
Version 4.12.15

On the client:

$ mount.cifs --version
mount.cifs version: 6.15

$ smbclient --version
Version 4.16.2

$ uname -r
5.18.9-arch1-1

(I know it's not a vanilla kernel, so I wanted to ask for advice here
before making a bug report.)

As mentioned, smbclient still works:

$ smbclient -U brian //192.168.1.131/backup -c ls
Password for [WORKGROUP\brian]:
  .                                   D        0  Sat Apr 24 16:01:23 2021
  ..                                  D        0  Tue Dec  1 20:18:28 2020
  brian                               D        0  Sat Apr 24 16:09:46 2021

15119769681 blocks of size 1024. 12418540722 blocks available

This doesn't though:

# mount.cifs --verbose --verbose -o username=brian
//192.168.1.131/backup /tmp/foo
Password for brian@//192.168.1.131/backup:
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
kernel log messages (dmesg)

I attached my kernel output. Is there anything there that jumps out at
anyone? Any easy fixes or should I look into opening a bug report?
Anything else I can provide, just ask.

Thanks,
Brian

--000000000000276c4305e37ef9fb
Content-Type: text/x-log; charset="US-ASCII"; name="trace.log"
Content-Disposition: attachment; filename="trace.log"
Content-Transfer-Encoding: base64
Content-ID: <f_l5g5uqgd0>
X-Attachment-Id: f_l5g5uqgd0

WzE3NzYyOC41MjQ3MDFdIGRldmljZSBlbnA0czAgZW50ZXJlZCBwcm9taXNjdW91cyBtb2RlClsx
Nzc2MjguNTI0NzIyXSBhdWRpdDogdHlwZT0xNzAwIGF1ZGl0KDE2NTc1MDgyMDUuNjU0OjIwMzQp
OiBkZXY9ZW5wNHMwIHByb209MjU2IG9sZF9wcm9tPTAgYXVpZD0xMDAwIHVpZD0wIGdpZD0wIHNl
cz00ClsxNzc2MjguNTI1MDAwXSBhdWRpdDogdHlwZT0xMzAwIGF1ZGl0KDE2NTc1MDgyMDUuNjU0
OjIwMzQpOiBhcmNoPWMwMDAwMDNlIHN5c2NhbGw9NTQgc3VjY2Vzcz15ZXMgZXhpdD0wIGEwPTQg
YTE9MTA3IGEyPTEgYTM9N2ZmY2NmNmQxZmQwIGl0ZW1zPTAgcHBpZD04MjM2IHBpZD0xMzgwOTkg
YXVpZD0xMDAwIHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAgc2dpZD0w
IGZzZ2lkPTAgdHR5PXB0czkgc2VzPTQgY29tbT0idGNwZHVtcCIgZXhlPSIvdXNyL2Jpbi90Y3Bk
dW1wIiBrZXk9KG51bGwpClsxNzc2MjguNTI1MDAzXSBhdWRpdDogdHlwZT0xMzI3IGF1ZGl0KDE2
NTc1MDgyMDUuNjU0OjIwMzQpOiBwcm9jdGl0bGU9NzQ2MzcwNjQ3NTZENzAwMDJENzMwMDMwMDAy
RDc3MDA3NDcyNjE2MzY1MkU3MDYzNjE3MApbMTc3NjQwLjMyNTA0M10gQ0lGUzogZnMvY2lmcy9m
c19jb250ZXh0LmM6IENJRlM6IHBhcnNpbmcgY2lmcyBtb3VudCBvcHRpb24gJ3NvdXJjZScKWzE3
NzY0MC4zMjUwNTNdIENJRlM6IGZzL2NpZnMvZnNfY29udGV4dC5jOiBDSUZTOiBwYXJzaW5nIGNp
ZnMgbW91bnQgb3B0aW9uICdpcCcKWzE3NzY0MC4zMjUwNTddIENJRlM6IGZzL2NpZnMvZnNfY29u
dGV4dC5jOiBDSUZTOiBwYXJzaW5nIGNpZnMgbW91bnQgb3B0aW9uICd1bmMnClsxNzc2NDAuMzI1
MDU5XSBDSUZTOiBmcy9jaWZzL2ZzX2NvbnRleHQuYzogQ0lGUzogcGFyc2luZyBjaWZzIG1vdW50
IG9wdGlvbiAndXNlcicKWzE3NzY0MC4zMjUwNjFdIENJRlM6IGZzL2NpZnMvZnNfY29udGV4dC5j
OiBDSUZTOiBwYXJzaW5nIGNpZnMgbW91bnQgb3B0aW9uICdwYXNzJwpbMTc3NjQwLjMyNTA2NF0g
Q0lGUzogZnMvY2lmcy9jaWZzZnMuYzogRGV2bmFtZTogXFwxOTIuMTY4LjEuMTMxXGJhY2t1cCBm
bGFnczogMApbMTc3NjQwLjMyNTA2OF0gQ0lGUzogZnMvY2lmcy9jb25uZWN0LmM6IFVzZXJuYW1l
OiBicmlhbgpbMTc3NjQwLjMyNTA3MF0gQ0lGUzogZnMvY2lmcy9jb25uZWN0LmM6IGZpbGUgbW9k
ZTogMDc1NSAgZGlyIG1vZGU6IDA3NTUKWzE3NzY0MC4zMjUwNzNdIENJRlM6IGZzL2NpZnMvY29u
bmVjdC5jOiBWRlM6IGluIG1vdW50X2dldF9jb25ucyBhcyBYaWQ6IDcyIHdpdGggdWlkOiAwClsx
Nzc2NDAuMzI1MDc2XSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogVU5DOiBcXDE5Mi4xNjguMS4x
MzFcYmFja3VwClsxNzc2NDAuMzI1MDgwXSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogZ2VuZXJp
Y19pcF9jb25uZWN0OiBjb25uZWN0aW5nIHRvIDE5Mi4xNjguMS4xMzE6NDQ1ClsxNzc2NDAuMzI1
MDkwXSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogU29ja2V0IGNyZWF0ZWQKWzE3NzY0MC4zMjUw
OTJdIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBzbmRidWYgMTYzODQgcmN2YnVmIDEzMTA3MiBy
Y3Z0aW1lbyAweDgzNApbMTc3NjQwLjMyNTcyNF0gQ0lGUzogZnMvY2lmcy9jb25uZWN0LmM6IGNp
ZnNfZ2V0X3RjcF9zZXNzaW9uOiBuZXh0IGRucyByZXNvbHV0aW9uIHNjaGVkdWxlZCBmb3IgNjAw
IHNlY29uZHMgaW4gdGhlIGZ1dHVyZQpbMTc3NjQwLjMyNTcyN10gQ0lGUzogZnMvY2lmcy9jb25u
ZWN0LmM6IFZGUzogaW4gY2lmc19nZXRfc21iX3NlcyBhcyBYaWQ6IDczIHdpdGggdWlkOiAwClsx
Nzc2NDAuMzI1NzI5XSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogRXhpc3Rpbmcgc21iIHNlc3Mg
bm90IGZvdW5kClsxNzc2NDAuMzI1NzI4XSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogRGVtdWx0
aXBsZXggUElEOiAxMzgxMTEKWzE3NzY0MC4zMjU3MzJdIENJRlM6IGZzL2NpZnMvc21iMnBkdS5j
OiBOZWdvdGlhdGUgcHJvdG9jb2wKWzE3NzY0MC4zMjU3MzhdIENJRlM6IGZzL2NpZnMvdHJhbnNw
b3J0LmM6IHdhaXRfZm9yX2ZyZWVfY3JlZGl0czogcmVtb3ZlIDEgY3JlZGl0cyB0b3RhbD0wClsx
Nzc2NDAuMzI1NzUwXSBDSUZTOiBmcy9jaWZzL3RyYW5zcG9ydC5jOiBTZW5kaW5nIHNtYjogc21i
X2xlbj0yNDQKWzE3NzY0MC4zMzkzNzZdIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBSRkMxMDAy
IGhlYWRlciAweDQ5ClsxNzc2NDAuMzM5MzgxXSBDSUZTOiBmcy9jaWZzL3NtYjJtaXNjLmM6IFNN
QjIgZGF0YSBsZW5ndGggMCBvZmZzZXQgMApbMTc3NjQwLjMzOTM4Ml0gQ0lGUzogZnMvY2lmcy9z
bWIybWlzYy5jOiBTTUIyIGxlbiA3MwpbMTc3NjQwLjMzOTM4NV0gQ0lGUzogZnMvY2lmcy9zbWIy
b3BzLmM6IHNtYjJfYWRkX2NyZWRpdHM6IGFkZGVkIDEgY3JlZGl0cyB0b3RhbD0xClsxNzc2NDAu
MzM5Mzk1XSBDSUZTOiBmcy9jaWZzL3RyYW5zcG9ydC5jOiBjaWZzX3N5bmNfbWlkX3Jlc3VsdDog
Y21kPTAgbWlkPTAgc3RhdGU9NApbMTc3NjQwLjMzOTM5OV0gQ0lGUzogZnMvY2lmcy9zbWIybWFw
ZXJyb3IuYzogTWFwcGluZyBTTUIyIHN0YXR1cyBjb2RlIDB4YzAwMDAwMGQgdG8gUE9TSVggZXJy
IC0yMgpbMTc3NjQwLjMzOTQwM10gQ0lGUzogZnMvY2lmcy9taXNjLmM6IE51bGwgYnVmZmVyIHBh
c3NlZCB0byBjaWZzX3NtYWxsX2J1Zl9yZWxlYXNlClsxNzc2NDAuMzM5NDA2XSBDSUZTOiBmcy9j
aWZzL2Nvbm5lY3QuYzogVkZTOiBsZWF2aW5nIGNpZnNfZ2V0X3NtYl9zZXMgKHhpZCA9IDczKSBy
YyA9IC0yMgpbMTc3NjQwLjMzOTQwOV0gQ0lGUzogZnMvY2lmcy9kZnNfY2FjaGUuYzogY2FjaGVf
cmVmcmVzaF9wYXRoOiBzZWFyY2ggcGF0aDogXDE5Mi4xNjguMS4xMzFcYmFja3VwClsxNzc2NDAu
MzM5NDExXSBDSUZTOiBmcy9jaWZzL2Rmc19jYWNoZS5jOiBnZXRfZGZzX3JlZmVycmFsOiBnZXQg
YW4gREZTIHJlZmVycmFsIGZvciBcMTkyLjE2OC4xLjEzMVxiYWNrdXAKWzE3NzY0MC4zMzk0MTdd
IENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBWRlM6IGxlYXZpbmcgbW91bnRfcHV0X2Nvbm5zICh4
aWQgPSA3MikgcmMgPSAwClsxNzc2NDAuMzM5NDE4XSBDSUZTOiBWRlM6IGNpZnNfbW91bnQgZmFp
bGVkIHcvcmV0dXJuIGNvZGUgPSAtMjIKWzE3NzY0Ny43NDczMjFdIGRldmljZSBlbnA0czAgbGVm
dCBwcm9taXNjdW91cyBtb2RlClsxNzc2NDcuNzQ3MzM5XSBhdWRpdDogdHlwZT0xNzAwIGF1ZGl0
KDE2NTc1MDgyMjQuODc3OjIwMzUpOiBkZXY9ZW5wNHMwIHByb209MCBvbGRfcHJvbT0yNTYgYXVp
ZD0xMDAwIHVpZD0wIGdpZD0wIHNlcz00Cg==
--000000000000276c4305e37ef9fb--
