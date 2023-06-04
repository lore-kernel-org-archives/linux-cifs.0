Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489CDC7EE23
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Jun 2023 17:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjFDRB1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Jun 2023 13:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjFDRB0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Jun 2023 13:01:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8577498
        for <linux-cifs@vger.kernel.org>; Sun,  4 Jun 2023 10:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 135BC60FDD
        for <linux-cifs@vger.kernel.org>; Sun,  4 Jun 2023 17:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB1EC4339E
        for <linux-cifs@vger.kernel.org>; Sun,  4 Jun 2023 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685898084;
        bh=1s7fQmcfiTaa1uaeNKnvGbdOPEqdBA0dKuEEoQS3+wk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mbAdYlP20rUHqusZA0ujPA/oqb59SVfvWLXmdO+FLfYQLdU2pkIsO1zKxKr9mwJVq
         nvoHbEjx6xi6wIIMdEYVj6aLPmnxRLH/Nx9WiowuoY8WOmlONLx424Z72NaFbbFjAH
         paHb211f8Ytw5vjLerES3K2rq4ZOhZNkX/ZNOQzRYR3cwxCB2mh4VFEFpCJNTM9VPp
         hPojVuLeTUMxWRIDCwgI8RvVVHRol1kXQebTeerNx71kuMMTaBtdDMKc1/HuFBIJyD
         Bg4srVISl90cGHm88MZ5wsd/SzFKr6046wT9cLZ6WG59TXznEH+ARpc6/+ZZvBhSQf
         WjeaLlesVfimA==
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-39a661bb7f0so2577163b6e.0
        for <linux-cifs@vger.kernel.org>; Sun, 04 Jun 2023 10:01:24 -0700 (PDT)
X-Gm-Message-State: AC+VfDzE+qcRbd8A2XHHYp/PI518cHu8YL1jbyng/SECSvqID/99M7if
        4WXI8G41SVoz6pMpc8oBdtVXdKA+MdCEYP7P0Kw=
X-Google-Smtp-Source: ACHHUZ6IIo2gcGJX/3qyYpTnarwj8bGxf/EF+Na8cceweOScnTJH8msmcs1XXbK/8J6bStlrooABVLw4eOXc4BZwadg=
X-Received: by 2002:aca:f054:0:b0:39a:7233:3340 with SMTP id
 o81-20020acaf054000000b0039a72333340mr2573692oih.23.1685898083523; Sun, 04
 Jun 2023 10:01:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5c44:0:b0:4df:6fd3:a469 with HTTP; Sun, 4 Jun 2023
 10:01:22 -0700 (PDT)
In-Reply-To: <CAAn9K_v-z-V-D+pgQzNzRmEDx4Rt03Fd=BkvpevR4OJqa_-F5g@mail.gmail.com>
References: <CAAn9K_v-z-V-D+pgQzNzRmEDx4Rt03Fd=BkvpevR4OJqa_-F5g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 5 Jun 2023 02:01:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-7-cWxwx7stFyA9SbHbdbJTKa4RmsWpqXhNcGRj0iWvw@mail.gmail.com>
Message-ID: <CAKYAXd-7-cWxwx7stFyA9SbHbdbJTKa4RmsWpqXhNcGRj0iWvw@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds in smb2_sess_setup+0x3ac/0x1a70
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        atteh.mailbox@gmail.com
Content-Type: multipart/mixed; boundary="000000000000659d9705fd50bcf4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000659d9705fd50bcf4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2023-06-04 3:44 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>:
> Hello, Namjae Jeon,
Hi Chih-Yen,

Could you please check if your issue is fixed ?

Thanks!
>
> The root cause of this bug is the same as
> 3ff6bb18ebaa5458a877b47bf7dbe99100a4ff31 (ksmbd: validate smb request
> protocol id), but it occurs in compound requests.
>
> [    8.912659] BUG: KASAN: slab-out-of-bounds in
> smb2_sess_setup+0x3ac/0x1a70
> [    8.913081] Read of size 4 at addr ffff88800ac8bb34 by task
> kworker/0:0/7
> ...
> [    8.914963] Call Trace:
> [    8.915121]  <TASK>
> [    8.915261]  dump_stack_lvl+0x33/0x50
> [    8.915498]  print_report+0xcc/0x620
> [    8.916242]  kasan_report+0xae/0xe0
> [    8.916717]  kasan_check_range+0x35/0x1b0
> [    8.916965]  smb2_sess_setup+0x3ac/0x1a70
> [    8.918634]  handle_ksmbd_work+0x282/0x820
> [    8.918898]  process_one_work+0x419/0x760
> [    8.919151]  worker_thread+0x2a2/0x6f0
> [    8.919655]  kthread+0x187/0x1d0
> [    8.920165]  ret_from_fork+0x1f/0x30
> [    8.920397]  </TASK>
>
> Thanks. Regards
>

--000000000000659d9705fd50bcf4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-validate-command-payload-size.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-validate-command-payload-size.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBiODZiNzQ3ODAxOWM4ZTNhMWM4ZmU2YzM5ZmQ1NmY3NjM2OTk0YmJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBNb24sIDUgSnVuIDIwMjMgMDE6NTc6MzQgKzA5MDAKU3ViamVjdDogW1BBVENIXSBrc21i
ZDogdmFsaWRhdGUgY29tbWFuZCBwYXlsb2FkIHNpemUKCi0+U3RydWN0dXJlU2l6ZTIgaW5kaWNh
dGVzIGNvbW1hbmQgcGF5bG9hZCBzaXplLiBrc21iZCBzaG91bGQgdmFsaWRhdGUKdGhpcyBzaXpl
IHdpdGggcmZjMTAwMiBsZW5ndGggYmVmb3JlIGFjY2Vzc2luZyBpdC4KVGhpcyBwYXRjaCByZW1v
dmUgdW5uZWVkZWQgY2hlY2sgYW5kIGFkZCB0aGUgdmFsaWRhdGlvbiBmb3IgdGhpcy4KClsgICAg
OC45MTI1ODNdIEJVRzogS0FTQU46IHNsYWItb3V0LW9mLWJvdW5kcyBpbiBrc21iZF9zbWIyX2No
ZWNrX21lc3NhZ2UrMHgxMmEvMHhjNTAKWyAgICA4LjkxMzA1MV0gUmVhZCBvZiBzaXplIDIgYXQg
YWRkciBmZmZmODg4MDBhYzdkOTJjIGJ5IHRhc2sga3dvcmtlci8wOjAvNwouLi4KWyAgICA4Ljkx
NDk2N10gQ2FsbCBUcmFjZToKWyAgICA4LjkxNTEyNl0gIDxUQVNLPgpbICAgIDguOTE1MjY3XSAg
ZHVtcF9zdGFja19sdmwrMHgzMy8weDUwClsgICAgOC45MTU1MDZdICBwcmludF9yZXBvcnQrMHhj
Yy8weDYyMApbICAgIDguOTE2NTU4XSAga2FzYW5fcmVwb3J0KzB4YWUvMHhlMApbICAgIDguOTE3
MDgwXSAga2FzYW5fY2hlY2tfcmFuZ2UrMHgzNS8weDFiMApbICAgIDguOTE3MzM0XSAga3NtYmRf
c21iMl9jaGVja19tZXNzYWdlKzB4MTJhLzB4YzUwClsgICAgOC45MTc5MzVdICBrc21iZF92ZXJp
Znlfc21iX21lc3NhZ2UrMHhhZS8weGQwClsgICAgOC45MTgyMjNdICBoYW5kbGVfa3NtYmRfd29y
aysweDE5Mi8weDgyMApbICAgIDguOTE4NDc4XSAgcHJvY2Vzc19vbmVfd29yaysweDQxOS8weDc2
MApbICAgIDguOTE4NzI3XSAgd29ya2VyX3RocmVhZCsweDJhMi8weDZmMApbICAgIDguOTE5MjIy
XSAga3RocmVhZCsweDE4Ny8weDFkMApbICAgIDguOTE5NzIzXSAgcmV0X2Zyb21fZm9yaysweDFm
LzB4MzAKWyAgICA4LjkxOTk1NF0gIDwvVEFTSz4KClJlcG9ydGVkLWJ5OiBDaGloLVllbiBDaGFu
ZyA8Y2M4NW5vZEBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IE5hbWphZSBKZW9uIDxsaW5raW5q
ZW9uQGtlcm5lbC5vcmc+Ci0tLQogZnMvc21iL3NlcnZlci9zbWIybWlzYy5jIHwgMjMgKysrKysr
KysrKysrLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxMSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvc2VydmVyL3NtYjJtaXNjLmMgYi9mcy9z
bWIvc2VydmVyL3NtYjJtaXNjLmMKaW5kZXggMGZmZTY2M2I3NTkwLi41Nzc0OWY0MWI5OTEgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9zZXJ2ZXIvc21iMm1pc2MuYworKysgYi9mcy9zbWIvc2VydmVyL3Nt
YjJtaXNjLmMKQEAgLTM1MSw2ICszNTEsNyBAQCBpbnQga3NtYmRfc21iMl9jaGVja19tZXNzYWdl
KHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQogCWludCBjb21tYW5kOwogCV9fdTMyIGNsY19sZW47
ICAvKiBjYWxjdWxhdGVkIGxlbmd0aCAqLwogCV9fdTMyIGxlbiA9IGdldF9yZmMxMDAyX2xlbih3
b3JrLT5yZXF1ZXN0X2J1Zik7CisJX191MzIgcmVxX3N0cnVjdF9zaXplOwogCiAJaWYgKGxlMzJf
dG9fY3B1KGhkci0+TmV4dENvbW1hbmQpID4gMCkKIAkJbGVuID0gbGUzMl90b19jcHUoaGRyLT5O
ZXh0Q29tbWFuZCk7CkBAIC0zNzMsMTcgKzM3NCw5IEBAIGludCBrc21iZF9zbWIyX2NoZWNrX21l
c3NhZ2Uoc3RydWN0IGtzbWJkX3dvcmsgKndvcmspCiAJfQogCiAJaWYgKHNtYjJfcmVxX3N0cnVj
dF9zaXplc1tjb21tYW5kXSAhPSBwZHUtPlN0cnVjdHVyZVNpemUyKSB7Ci0JCWlmIChjb21tYW5k
ICE9IFNNQjJfT1BMT0NLX0JSRUFLX0hFICYmCi0JCSAgICAoaGRyLT5TdGF0dXMgPT0gMCB8fCBw
ZHUtPlN0cnVjdHVyZVNpemUyICE9IFNNQjJfRVJST1JfU1RSVUNUVVJFX1NJWkUyX0xFKSkgewot
CQkJLyogZXJyb3IgcGFja2V0cyBoYXZlIDkgYnl0ZSBzdHJ1Y3R1cmUgc2l6ZSAqLwotCQkJa3Nt
YmRfZGVidWcoU01CLAotCQkJCSAgICAiSWxsZWdhbCByZXF1ZXN0IHNpemUgJXUgZm9yIGNvbW1h
bmQgJWRcbiIsCi0JCQkJICAgIGxlMTZfdG9fY3B1KHBkdS0+U3RydWN0dXJlU2l6ZTIpLCBjb21t
YW5kKTsKLQkJCXJldHVybiAxOwotCQl9IGVsc2UgaWYgKGNvbW1hbmQgPT0gU01CMl9PUExPQ0tf
QlJFQUtfSEUgJiYKLQkJCSAgIGhkci0+U3RhdHVzID09IDAgJiYKLQkJCSAgIGxlMTZfdG9fY3B1
KHBkdS0+U3RydWN0dXJlU2l6ZTIpICE9IE9QX0JSRUFLX1NUUlVDVF9TSVpFXzIwICYmCi0JCQkg
ICBsZTE2X3RvX2NwdShwZHUtPlN0cnVjdHVyZVNpemUyKSAhPSBPUF9CUkVBS19TVFJVQ1RfU0la
RV8yMSkgeworCQlpZiAoY29tbWFuZCA9PSBTTUIyX09QTE9DS19CUkVBS19IRSAmJgorCQkgICAg
bGUxNl90b19jcHUocGR1LT5TdHJ1Y3R1cmVTaXplMikgIT0gT1BfQlJFQUtfU1RSVUNUX1NJWkVf
MjAgJiYKKwkJICAgIGxlMTZfdG9fY3B1KHBkdS0+U3RydWN0dXJlU2l6ZTIpICE9IE9QX0JSRUFL
X1NUUlVDVF9TSVpFXzIxKSB7CiAJCQkvKiBzcGVjaWFsIGNhc2UgZm9yIFNNQjIuMSBsZWFzZSBi
cmVhayBtZXNzYWdlICovCiAJCQlrc21iZF9kZWJ1ZyhTTUIsCiAJCQkJICAgICJJbGxlZ2FsIHJl
cXVlc3Qgc2l6ZSAlZCBmb3Igb3Bsb2NrIGJyZWFrXG4iLApAQCAtMzkyLDYgKzM4NSwxNCBAQCBp
bnQga3NtYmRfc21iMl9jaGVja19tZXNzYWdlKHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQogCQl9
CiAJfQogCisJcmVxX3N0cnVjdF9zaXplID0gbGUxNl90b19jcHUocGR1LT5TdHJ1Y3R1cmVTaXpl
MikgKworCQlfX1NNQjJfSEVBREVSX1NUUlVDVFVSRV9TSVpFOworCWlmIChjb21tYW5kID09IFNN
QjJfTE9DS19IRSkKKwkJcmVxX3N0cnVjdF9zaXplIC09IHNpemVvZihzdHJ1Y3Qgc21iMl9sb2Nr
X2VsZW1lbnQpOworCisJaWYgKHJlcV9zdHJ1Y3Rfc2l6ZSA+IGxlbiArIDEpCisJCXJldHVybiAx
OworCiAJaWYgKHNtYjJfY2FsY19zaXplKGhkciwgJmNsY19sZW4pKQogCQlyZXR1cm4gMTsKIAot
LSAKMi4yNS4xCgo=
--000000000000659d9705fd50bcf4--
