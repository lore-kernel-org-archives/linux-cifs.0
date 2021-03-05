Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D5CC433DB
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 02:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E32864FEF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 02:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhCECZr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECZq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Mar 2021 21:25:46 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7248BC061574
        for <linux-cifs@vger.kernel.org>; Thu,  4 Mar 2021 18:25:46 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id r23so870644ljh.1
        for <linux-cifs@vger.kernel.org>; Thu, 04 Mar 2021 18:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/ouMQw4hn703IxWCPfTjylcVrdS2a1+6n0XA7xhMYuc=;
        b=KdQxBQSMPmUcmNTnnDnmfbX1ocHOgytNfsdmy91iCPcmUFbiG161PTr+eZ6UhaIx7v
         07N+tiNmL4u5lJt7905Gyo8/yQ5qRZc4uW+JMZZttWNV/mYPOMa3u1vUUISpmqouTGLW
         HZk/Fn2vOHAQfSw+AM5VwteNYcfDZeSY+uXs9COc8/fJZU0zLLiEn9EVyfKCubplyrTo
         AtzZKj8RRo+fAIhPUHrCads7vRS3dz1BZM802CXEVeLsEs8Qx7Q284kxEFtphfaEyfXy
         BuesNwLgS9Vum7sFopzOPWDQR/LcqkSozppT2JCanxiLj9XJh6rx+F7UTQAe0Hgjacxb
         kptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/ouMQw4hn703IxWCPfTjylcVrdS2a1+6n0XA7xhMYuc=;
        b=PSY2+dtyieELwwhgxzu/NalJFUuihhpuIn+iR1THMS6pour3BhOGdLt5RaBlSYzlgz
         IZzQbCZHWyt+eJ4sIvd3BPSf0tZp/0ZxTtMTWHi+wt4ruuQ4MUKlroUuLK6dw23SrgzO
         p2R2zAlmHZlouWFcgRDg7x3FNfAXKbcJumUYChVt9TzZe/TcO5J+6tr7CifU1h79vzKA
         1Sb0j9rhbquqt/ubvG6Sku8mTRaz1w4uQsUXLkYPrrELoU+kRJil67BMv7H+2YtGHA4w
         2A/oICo5LsSjmqRtW5670w0cPFNOgiLZK/jKN2LhSkZV2Vi7sGHjKdI39f6lLSBcz0Ev
         Jw5w==
X-Gm-Message-State: AOAM533Yj4A7kwiRy50Z10KqBB4+pyVmN3RDJpBO54DNXYbjQhEdDtjF
        IPF9ZWuWEVTK6P+7EpDJHBt5VP2aW3s7yrWmtfshvamZjPd6Pw==
X-Google-Smtp-Source: ABdhPJzBbvLmXDO97L+21Wp4opmFuSwKK5iBNZ+Ci8gVoNR+tE86i5W+Du+VZnqLWCdiQE9gxD5duzU3a/sDdQ5Oaok=
X-Received: by 2002:a05:651c:548:: with SMTP id q8mr3822433ljp.256.1614911144743;
 Thu, 04 Mar 2021 18:25:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Mar 2021 20:25:33 -0600
Message-ID: <CAH2r5muP7MU3QciheN9sbdJtOFwojfhq1yoradMzbunG7dsCQw@mail.gmail.com>
Subject: [PATCH] cifs: fix credit accounting for extra channel
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000206bfe05bcc0cdb1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000206bfe05bcc0cdb1
Content-Type: text/plain; charset="UTF-8"

With multichannel, operations like the queries
from "ls -lR" can cause all credits to be used and
errors to be returned since max_credits was not
being set correctly on the secondary channels and
thus the client was requesting 0 credits incorrectly
in some cases (which can lead to not having
enough credits to perform any operation on that
channel).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 10 +++++-----
 fs/cifs/sess.c    |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 112692300fb6..68642e3d4270 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1429,6 +1429,11 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
  tcp_ses->min_offload = ctx->min_offload;
  tcp_ses->tcpStatus = CifsNeedNegotiate;

+ if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
+ tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
+ else
+ tcp_ses->max_credits = ctx->max_credits;
+
  tcp_ses->nr_targets = 1;
  tcp_ses->ignore_signature = ctx->ignore_signature;
  /* thread spawned, put it on the list */
@@ -2832,11 +2837,6 @@ static int mount_get_conns(struct
smb3_fs_context *ctx, struct cifs_sb_info *cif

  *nserver = server;

- if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
- server->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
- else
- server->max_credits = ctx->max_credits;
-
  /* get a reference to a SMB session */
  ses = cifs_get_smb_ses(server, ctx);
  if (IS_ERR(ses)) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 183a3a868d7b..63d517b9f2ff 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -230,6 +230,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb,
struct cifs_ses *ses,
  ctx.noautotune = ses->server->noautotune;
  ctx.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
  ctx.echo_interval = ses->server->echo_interval / HZ;
+ ctx.max_credits = ses->server->max_credits;

  /*
  * This will be used for encoding/decoding user/domain/pw

-- 
Thanks,

Steve

--000000000000206bfe05bcc0cdb1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-credit-accounting-for-extra-channel.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-credit-accounting-for-extra-channel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_klvoe2yx0>
X-Attachment-Id: f_klvoe2yx0

RnJvbSBhYjY0ZDU1NjVkMzAzZWYwMWQxNmRhZDI5ZWNjNjAwMTcxNWQyN2QyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpEYXRl
OiBUaHUsIDQgTWFyIDIwMjEgMTc6NDI6MjEgKzAwMDAKU3ViamVjdDogW1BBVENIXSBjaWZzOiBm
aXggY3JlZGl0IGFjY291bnRpbmcgZm9yIGV4dHJhIGNoYW5uZWwKCldpdGggbXVsdGljaGFubmVs
LCBvcGVyYXRpb25zIGxpa2UgdGhlIHF1ZXJpZXMKZnJvbSAibHMgLWxSIiBjYW4gY2F1c2UgYWxs
IGNyZWRpdHMgdG8gYmUgdXNlZCBhbmQKZXJyb3JzIHRvIGJlIHJldHVybmVkIHNpbmNlIG1heF9j
cmVkaXRzIHdhcyBub3QKYmVpbmcgc2V0IGNvcnJlY3RseSBvbiB0aGUgc2Vjb25kYXJ5IGNoYW5u
ZWxzIGFuZAp0aHVzIHRoZSBjbGllbnQgd2FzIHJlcXVlc3RpbmcgMCBjcmVkaXRzIGluY29ycmVj
dGx5CmluIHNvbWUgY2FzZXMgKHdoaWNoIGNhbiBsZWFkIHRvIG5vdCBoYXZpbmcKZW5vdWdoIGNy
ZWRpdHMgdG8gcGVyZm9ybSBhbnkgb3BlcmF0aW9uIG9uIHRoYXQKY2hhbm5lbCkuCgpTaWduZWQt
b2ZmLWJ5OiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpDQzogPHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmc+ICMgdjUuOCsKUmV2aWV3ZWQtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2Fk
QG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWlj
cm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDEwICsrKysrLS0tLS0KIGZzL2Np
ZnMvc2Vzcy5jICAgIHwgIDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDUg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nv
bm5lY3QuYwppbmRleCAxMTI2OTIzMDBmYjYuLjY4NjQyZTNkNDI3MCAxMDA2NDQKLS0tIGEvZnMv
Y2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTE0MjksNiArMTQyOSwx
MSBAQCBjaWZzX2dldF90Y3Bfc2Vzc2lvbihzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJ
dGNwX3Nlcy0+bWluX29mZmxvYWQgPSBjdHgtPm1pbl9vZmZsb2FkOwogCXRjcF9zZXMtPnRjcFN0
YXR1cyA9IENpZnNOZWVkTmVnb3RpYXRlOwogCisJaWYgKChjdHgtPm1heF9jcmVkaXRzIDwgMjAp
IHx8IChjdHgtPm1heF9jcmVkaXRzID4gNjAwMDApKQorCQl0Y3Bfc2VzLT5tYXhfY3JlZGl0cyA9
IFNNQjJfTUFYX0NSRURJVFNfQVZBSUxBQkxFOworCWVsc2UKKwkJdGNwX3Nlcy0+bWF4X2NyZWRp
dHMgPSBjdHgtPm1heF9jcmVkaXRzOworCiAJdGNwX3Nlcy0+bnJfdGFyZ2V0cyA9IDE7CiAJdGNw
X3Nlcy0+aWdub3JlX3NpZ25hdHVyZSA9IGN0eC0+aWdub3JlX3NpZ25hdHVyZTsKIAkvKiB0aHJl
YWQgc3Bhd25lZCwgcHV0IGl0IG9uIHRoZSBsaXN0ICovCkBAIC0yODMyLDExICsyODM3LDYgQEAg
c3RhdGljIGludCBtb3VudF9nZXRfY29ubnMoc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4LCBz
dHJ1Y3QgY2lmc19zYl9pbmZvICpjaWYKIAogCSpuc2VydmVyID0gc2VydmVyOwogCi0JaWYgKChj
dHgtPm1heF9jcmVkaXRzIDwgMjApIHx8IChjdHgtPm1heF9jcmVkaXRzID4gNjAwMDApKQotCQlz
ZXJ2ZXItPm1heF9jcmVkaXRzID0gU01CMl9NQVhfQ1JFRElUU19BVkFJTEFCTEU7Ci0JZWxzZQot
CQlzZXJ2ZXItPm1heF9jcmVkaXRzID0gY3R4LT5tYXhfY3JlZGl0czsKLQogCS8qIGdldCBhIHJl
ZmVyZW5jZSB0byBhIFNNQiBzZXNzaW9uICovCiAJc2VzID0gY2lmc19nZXRfc21iX3NlcyhzZXJ2
ZXIsIGN0eCk7CiAJaWYgKElTX0VSUihzZXMpKSB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3Nlc3Mu
YyBiL2ZzL2NpZnMvc2Vzcy5jCmluZGV4IDE4M2EzYTg2OGQ3Yi4uNjNkNTE3YjlmMmZmIDEwMDY0
NAotLS0gYS9mcy9jaWZzL3Nlc3MuYworKysgYi9mcy9jaWZzL3Nlc3MuYwpAQCAtMjMwLDYgKzIz
MCw3IEBAIGNpZnNfc2VzX2FkZF9jaGFubmVsKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2Is
IHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCWN0eC5ub2F1dG90dW5lID0gc2VzLT5zZXJ2ZXItPm5v
YXV0b3R1bmU7CiAJY3R4LnNvY2tvcHRfdGNwX25vZGVsYXkgPSBzZXMtPnNlcnZlci0+dGNwX25v
ZGVsYXk7CiAJY3R4LmVjaG9faW50ZXJ2YWwgPSBzZXMtPnNlcnZlci0+ZWNob19pbnRlcnZhbCAv
IEhaOworCWN0eC5tYXhfY3JlZGl0cyA9IHNlcy0+c2VydmVyLT5tYXhfY3JlZGl0czsKIAogCS8q
CiAJICogVGhpcyB3aWxsIGJlIHVzZWQgZm9yIGVuY29kaW5nL2RlY29kaW5nIHVzZXIvZG9tYWlu
L3B3Ci0tIAoyLjI3LjAKCg==
--000000000000206bfe05bcc0cdb1--
