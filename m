Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18C7C77B73
	for <linux-cifs@archiver.kernel.org>; Wed, 31 May 2023 09:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbjEaJEd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 May 2023 05:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbjEaJDv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 May 2023 05:03:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B041AD
        for <linux-cifs@vger.kernel.org>; Wed, 31 May 2023 02:03:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 668E5634A6
        for <linux-cifs@vger.kernel.org>; Wed, 31 May 2023 09:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF39EC4339C
        for <linux-cifs@vger.kernel.org>; Wed, 31 May 2023 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685523801;
        bh=D1mnLQ/i00q7Nx5n6c78yUmDEB8v7Z3nlsnMKavKKiY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=fMfg1s5xdF+2g5ZDOhCupP+K8pPNwNqsTt4J2fFA/Hc4Aa29gmQ07U+coJD8RScot
         o9L6/hpFJlzCgRpLL7QkuEHrICxA4jec1Jz5DrJmuzzoQgZtoD110/Hxoae9JsTE75
         TkF5J3QJwgOnqt8MlGwDu8xHmKjR6JDobWtxl9cKX9TNlVvBGpVtPpdXMDY0gWjB1a
         36PxdkbUV++OeR0Jde8VDNnNikD6u60tYzDITXI3xSierzibkYbmpO5kC0B1FX0Bql
         FVGyTotx3YeTxEe/IYDmGmOfcBLY1nCNz7Yya/vv4wpy6hDNZ2T/tzXVfn/TtgVNWs
         +Gmhtrn1o5FgQ==
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-19f54a99cd5so1578510fac.1
        for <linux-cifs@vger.kernel.org>; Wed, 31 May 2023 02:03:21 -0700 (PDT)
X-Gm-Message-State: AC+VfDygPBB34uOjwiHlyWjBhkoFJIEk3C9zN2nr5jt8Q70OZ9ra79/k
        vv9qigl3opR7/HMQsszxIY3YXW3rD4t+4zsAsKc=
X-Google-Smtp-Source: ACHHUZ4Aj1iKSBFNADGHe6fM/ADhc5jaUnZZezYdLwok4mzJBrwc5vO6Z0lakMzZNUFfMG8y9Z+8F54OiKoWrtuRLjo=
X-Received: by 2002:a05:6870:e14d:b0:19e:fa1f:fc2f with SMTP id
 z13-20020a056870e14d00b0019efa1ffc2fmr2213246oaa.38.1685523800864; Wed, 31
 May 2023 02:03:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acd:0:b0:4de:afc5:4d13 with HTTP; Wed, 31 May 2023
 02:03:19 -0700 (PDT)
In-Reply-To: <CAAn9K_tB+mX5RrRihaPpAPFmkr0ROxD2ahqph3vHX6ROK=LAPg@mail.gmail.com>
References: <CAAn9K_tB+mX5RrRihaPpAPFmkr0ROxD2ahqph3vHX6ROK=LAPg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 31 May 2023 18:03:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8_LNdyqLX0FBecsrhGrb6g-9OPFztcojcr6vniPZR8_Q@mail.gmail.com>
Message-ID: <CAKYAXd8_LNdyqLX0FBecsrhGrb6g-9OPFztcojcr6vniPZR8_Q@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds in init_smb2_rsp_hdr+0x1b9/0x1f0
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, atteh.mailbox@gmail.com,
        linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000069866305fcf997a9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000069866305fcf997a9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2023-05-31 16:35 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>=
:
> I think the root cause of this bug likes the d6c43f4 one.
>
> The attacker can forge ProtocolID to be 0 and bypass the `pdu_size <
> SMB2_MIN_SUPPORTED_HEADER_SIZE` check. When the ksmbd accesses
> `rcv_hdr->Signature` in the function `init_smb2_rsp_hdr`, the oob read bu=
g
> will be triggered.
Thanks for your report:)

Could you please check if this patch fix this issue ?

From a931b1fd4e186a7abced51c6895914b38970a15d Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 31 May 2023 17:59:32 +0900
Subject: [PATCH] ksmbd: validate smb request protocol id

This patch add the validation for smb request protocol id.
If it is not one of the four ids(SMB1_PROTO_NUMBER, SMB2_PROTO_NUMBER,
SMB2_TRANSFORM_PROTO_NUM, SMB2_COMPRESSION_TRANSFORM_ID), don't allow
processing the request. And this will fix the following KASAN warning
also.

[   13.905265] BUG: KASAN: slab-out-of-bounds in init_smb2_rsp_hdr+0x1b9/0x=
1f0
[   13.905900] Read of size 16 at addr ffff888005fd2f34 by task kworker/0:2=
/44
...
[   13.908553] Call Trace:
[   13.908793]  <TASK>
[   13.908995]  dump_stack_lvl+0x33/0x50
[   13.909369]  print_report+0xcc/0x620
[   13.910870]  kasan_report+0xae/0xe0
[   13.911519]  kasan_check_range+0x35/0x1b0
[   13.911796]  init_smb2_rsp_hdr+0x1b9/0x1f0
[   13.912492]  handle_ksmbd_work+0xe5/0x820

Reported-by: Chih-Yen Chang <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c |  5 +++--
 fs/smb/server/smb_common.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index e11d4a1e63d7..2a717d158f02 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -364,8 +364,6 @@ int ksmbd_conn_handler_loop(void *p)
 			break;

 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
-		if (!ksmbd_smb_request(conn))
-			break;

 		/*
 		 * We already read 4 bytes to find out PDU size, now
@@ -383,6 +381,9 @@ int ksmbd_conn_handler_loop(void *p)
 			continue;
 		}

+		if (!ksmbd_smb_request(conn))
+			break;
+
 		if (((struct smb2_hdr *)smb2_get_msg(conn->request_buf))->ProtocolId =3D=
=3D
 		    SMB2_PROTO_NUMBER) {
 			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index c6e4d38319df..a7e81067bc99 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -158,7 +158,19 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
  */
 bool ksmbd_smb_request(struct ksmbd_conn *conn)
 {
-	return conn->request_buf[0] =3D=3D 0;
+	__le32 *proto =3D (__le32 *)smb2_get_msg(conn->request_buf);
+
+	if (*proto =3D=3D SMB2_COMPRESSION_TRANSFORM_ID) {
+		pr_err_ratelimited("smb2 compression not support yet");
+		return false;
+	}
+
+	if (*proto !=3D SMB1_PROTO_NUMBER &&
+	    *proto !=3D SMB2_PROTO_NUMBER &&
+	    *proto !=3D SMB2_TRANSFORM_PROTO_NUM)
+		return false;
+
+	return true;
 }

 static bool supported_protocol(int idx)
--=20
2.25.1

>
> [   13.905265] BUG: KASAN: slab-out-of-bounds in
> init_smb2_rsp_hdr+0x1b9/0x1f0
> [   13.905900] Read of size 16 at addr ffff888005fd2f34 by task
> kworker/0:2/44
> ...
> [   13.908553] Call Trace:
> [   13.908793]  <TASK>
> [   13.908995]  dump_stack_lvl+0x33/0x50
> [   13.909369]  print_report+0xcc/0x620
> [   13.910870]  kasan_report+0xae/0xe0
> [   13.911519]  kasan_check_range+0x35/0x1b0
> [   13.911796]  init_smb2_rsp_hdr+0x1b9/0x1f0
> [   13.912492]  handle_ksmbd_work+0xe5/0x820
> ...
> [   13.915753]  </TASK>
>

--00000000000069866305fcf997a9
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-validate-smb-request-protocol-id.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-validate-smb-request-protocol-id.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBhOTMxYjFmZDRlMTg2YTdhYmNlZDUxYzY4OTU5MTRiMzg5NzBhMTVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBXZWQsIDMxIE1heSAyMDIzIDE3OjU5OjMyICswOTAwClN1YmplY3Q6IFtQQVRDSF0ga3Nt
YmQ6IHZhbGlkYXRlIHNtYiByZXF1ZXN0IHByb3RvY29sIGlkCgpUaGlzIHBhdGNoIGFkZCB0aGUg
dmFsaWRhdGlvbiBmb3Igc21iIHJlcXVlc3QgcHJvdG9jb2wgaWQuCklmIGl0IGlzIG5vdCBvbmUg
b2YgdGhlIGZvdXIgaWRzKFNNQjFfUFJPVE9fTlVNQkVSLCBTTUIyX1BST1RPX05VTUJFUiwKU01C
Ml9UUkFOU0ZPUk1fUFJPVE9fTlVNLCBTTUIyX0NPTVBSRVNTSU9OX1RSQU5TRk9STV9JRCksIGRv
bid0IGFsbG93CnByb2Nlc3NpbmcgdGhlIHJlcXVlc3QuIEFuZCB0aGlzIHdpbGwgZml4IHRoZSBm
b2xsb3dpbmcgS0FTQU4gd2FybmluZwphbHNvLgoKWyAgIDEzLjkwNTI2NV0gQlVHOiBLQVNBTjog
c2xhYi1vdXQtb2YtYm91bmRzIGluIGluaXRfc21iMl9yc3BfaGRyKzB4MWI5LzB4MWYwClsgICAx
My45MDU5MDBdIFJlYWQgb2Ygc2l6ZSAxNiBhdCBhZGRyIGZmZmY4ODgwMDVmZDJmMzQgYnkgdGFz
ayBrd29ya2VyLzA6Mi80NAouLi4KWyAgIDEzLjkwODU1M10gQ2FsbCBUcmFjZToKWyAgIDEzLjkw
ODc5M10gIDxUQVNLPgpbICAgMTMuOTA4OTk1XSAgZHVtcF9zdGFja19sdmwrMHgzMy8weDUwClsg
ICAxMy45MDkzNjldICBwcmludF9yZXBvcnQrMHhjYy8weDYyMApbICAgMTMuOTEwODcwXSAga2Fz
YW5fcmVwb3J0KzB4YWUvMHhlMApbICAgMTMuOTExNTE5XSAga2FzYW5fY2hlY2tfcmFuZ2UrMHgz
NS8weDFiMApbICAgMTMuOTExNzk2XSAgaW5pdF9zbWIyX3JzcF9oZHIrMHgxYjkvMHgxZjAKWyAg
IDEzLjkxMjQ5Ml0gIGhhbmRsZV9rc21iZF93b3JrKzB4ZTUvMHg4MjAKClJlcG9ydGVkLWJ5OiBD
aGloLVllbiBDaGFuZyA8Y2M4NW5vZEBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IE5hbWphZSBK
ZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+Ci0tLQogZnMvc21iL3NlcnZlci9jb25uZWN0aW9u
LmMgfCAgNSArKystLQogZnMvc21iL3NlcnZlci9zbWJfY29tbW9uLmMgfCAxNCArKysrKysrKysr
KysrLQogMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvY29ubmVjdGlvbi5jIGIvZnMvc21iL3NlcnZlci9j
b25uZWN0aW9uLmMKaW5kZXggZTExZDRhMWU2M2Q3Li4yYTcxN2QxNThmMDIgMTAwNjQ0Ci0tLSBh
L2ZzL3NtYi9zZXJ2ZXIvY29ubmVjdGlvbi5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvY29ubmVjdGlv
bi5jCkBAIC0zNjQsOCArMzY0LDYgQEAgaW50IGtzbWJkX2Nvbm5faGFuZGxlcl9sb29wKHZvaWQg
KnApCiAJCQlicmVhazsKIAogCQltZW1jcHkoY29ubi0+cmVxdWVzdF9idWYsIGhkcl9idWYsIHNp
emVvZihoZHJfYnVmKSk7Ci0JCWlmICgha3NtYmRfc21iX3JlcXVlc3QoY29ubikpCi0JCQlicmVh
azsKIAogCQkvKgogCQkgKiBXZSBhbHJlYWR5IHJlYWQgNCBieXRlcyB0byBmaW5kIG91dCBQRFUg
c2l6ZSwgbm93CkBAIC0zODMsNiArMzgxLDkgQEAgaW50IGtzbWJkX2Nvbm5faGFuZGxlcl9sb29w
KHZvaWQgKnApCiAJCQljb250aW51ZTsKIAkJfQogCisJCWlmICgha3NtYmRfc21iX3JlcXVlc3Qo
Y29ubikpCisJCQlicmVhazsKKwogCQlpZiAoKChzdHJ1Y3Qgc21iMl9oZHIgKilzbWIyX2dldF9t
c2coY29ubi0+cmVxdWVzdF9idWYpKS0+UHJvdG9jb2xJZCA9PQogCQkgICAgU01CMl9QUk9UT19O
VU1CRVIpIHsKIAkJCWlmIChwZHVfc2l6ZSA8IFNNQjJfTUlOX1NVUFBPUlRFRF9IRUFERVJfU0la
RSkKZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvc21iX2NvbW1vbi5jIGIvZnMvc21iL3NlcnZl
ci9zbWJfY29tbW9uLmMKaW5kZXggYzZlNGQzODMxOWRmLi5hN2U4MTA2N2JjOTkgMTAwNjQ0Ci0t
LSBhL2ZzL3NtYi9zZXJ2ZXIvc21iX2NvbW1vbi5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvc21iX2Nv
bW1vbi5jCkBAIC0xNTgsNyArMTU4LDE5IEBAIGludCBrc21iZF92ZXJpZnlfc21iX21lc3NhZ2Uo
c3RydWN0IGtzbWJkX3dvcmsgKndvcmspCiAgKi8KIGJvb2wga3NtYmRfc21iX3JlcXVlc3Qoc3Ry
dWN0IGtzbWJkX2Nvbm4gKmNvbm4pCiB7Ci0JcmV0dXJuIGNvbm4tPnJlcXVlc3RfYnVmWzBdID09
IDA7CisJX19sZTMyICpwcm90byA9IChfX2xlMzIgKilzbWIyX2dldF9tc2coY29ubi0+cmVxdWVz
dF9idWYpOworCisJaWYgKCpwcm90byA9PSBTTUIyX0NPTVBSRVNTSU9OX1RSQU5TRk9STV9JRCkg
eworCQlwcl9lcnJfcmF0ZWxpbWl0ZWQoInNtYjIgY29tcHJlc3Npb24gbm90IHN1cHBvcnQgeWV0
Iik7CisJCXJldHVybiBmYWxzZTsKKwl9CisKKwlpZiAoKnByb3RvICE9IFNNQjFfUFJPVE9fTlVN
QkVSICYmCisJICAgICpwcm90byAhPSBTTUIyX1BST1RPX05VTUJFUiAmJgorCSAgICAqcHJvdG8g
IT0gU01CMl9UUkFOU0ZPUk1fUFJPVE9fTlVNKQorCQlyZXR1cm4gZmFsc2U7CisKKwlyZXR1cm4g
dHJ1ZTsKIH0KIAogc3RhdGljIGJvb2wgc3VwcG9ydGVkX3Byb3RvY29sKGludCBpZHgpCi0tIAoy
LjI1LjEKCg==
--00000000000069866305fcf997a9--
