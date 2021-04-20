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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF65C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 04:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06612613AB
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 04:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhDTE2X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Apr 2021 00:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhDTE2W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Apr 2021 00:28:22 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D81C06174A
        for <linux-cifs@vger.kernel.org>; Mon, 19 Apr 2021 21:27:51 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id o5so8884850ljc.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Apr 2021 21:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=M9aAz716m1bO6LdaILBzz+qpcW/u4AmcNxzXXDB+JDA=;
        b=LinfN0exYV/AHHWgWaYt6dwHO1RRiWaQSdiEhnyoZYhihgCSP4NAndW01W9dBe0Gw7
         QuD76k039rX9anTA11K7v7AZqNuHYeQGFIgkza5ytCoqB7hok6KRB2aCUWp2AybPER23
         B4dp+aozk4Qw1uDMWD3yzb9W7Fhddv3GmJ+yO7r8/skUVF833At1xCXituuqE5evkXR6
         OENqRpf5z9idRqoJ2bCJk1lPRy21aVPRmVax4zlS9wSVUxuGeu2KQ/M/200vL5Wxdcbq
         TL8yAZhc27I7sMxMMBcvxRgS7GHFLGHw5CStLSEUpDXCdlqPj/1jL4svwB/h1Le6PYF+
         Beyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=M9aAz716m1bO6LdaILBzz+qpcW/u4AmcNxzXXDB+JDA=;
        b=fhOo8pPhMulUAqWxcPIP9RQY//vmPLPhHOpwjzN2qxeflWxxiVVoW5YgDj2jMprzYc
         6lj8xKhouUH6zOfgVFam13wqjTKzQXZ49S6c6UkmHHGt+9oIMLTwvMy+24+EVOPqDHKy
         a0DOMX7J9UC8Jtgba6QWnle/ayPzod9E6hCiaJfh257DJUzwQVplPM704DZS8+xS3dut
         BqehSLwBThNnfsTJHXXVeQ6G/akBGYDh4Nf2stW7OLXNwj0pmD2/yD+LAkxOYyTlWrx6
         het35IygBmd6FSIKj5CZht0o2AcE+fh9ruGXhRHEEPTkyu9vc65Px39InQDhEMZyJbre
         AoPQ==
X-Gm-Message-State: AOAM5328EMNO/4H765fzKcfWhA2DKzCxAHpRu993NEcop+JH79s98Hxh
        +w9KwYigSVNxuaZq9gJN+zA+tw8GS8a1NuBmlCa3zTvQiMg=
X-Google-Smtp-Source: ABdhPJwsWKqmawEZ7b4ItGz+Q1bea5hY8sTSg7jGr2QMk3ZUhEjqvY/eAWTax5J/rNtWZZ5zW1omb6PfvvxjJ3gyCxk=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr13258981ljp.406.1618892870072;
 Mon, 19 Apr 2021 21:27:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Apr 2021 23:27:39 -0500
Message-ID: <CAH2r5msPnCHf2qHtJ=tJymfa9cgyOgnrv9xPEiYF=nsWTg1syg@mail.gmail.com>
Subject: [PATCH][SMB3] limit noisy error
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000735e4805c05fde2b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000735e4805c05fde2b
Content-Type: text/plain; charset="UTF-8"

For servers which don't support copy_range (SMB3 CopyChunk), the
logging of:
 CIFS: VFS: \\server\share refcpy ioctl error -95 getting resume key
can fill the client logs and make debugging real problems more
difficult.  Change the -EOPNOTSUPP on copy_range to a "warn once"

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5ccc36d98dad..dd0eb665b680 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1567,7 +1567,10 @@ SMB2_request_res_key(const unsigned int xid,
struct cifs_tcon *tcon,
  NULL, 0 /* no input */, CIFSMaxBufSize,
  (char **)&res_key, &ret_data_len);

- if (rc) {
+ if (rc == -EOPNOTSUPP) {
+ pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
+ goto req_res_keyFor servers which don't support copy_range (SMB3
CopyChunk), the
logging of:
 CIFS: VFS: \\server\share refcpy ioctl error -95 getting resume key
can fill the client logs and make debugging real problems more
difficult.  Change the -EOPNOTSUPP on copy_range to a "warn once"

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5ccc36d98dad..dd0eb665b680 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1567,7 +1567,10 @@ SMB2_request_res_key(const unsigned int xid,
struct cifs_tcon *tcon,
  NULL, 0 /* no input */, CIFSMaxBufSize,
  (char **)&res_key, &ret_data_len);

- if (rc) {
+ if (rc == -EOPNOTSUPP) {
+ pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
+ goto req_res_key_exit;
+ } else if (rc) {
  cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
  goto req_res_key_exit;
  }_exit;
+ } else if (rc) {
  cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
  goto req_res_key_exit;
  }

-- 
Thanks,

Steve

--000000000000735e4805c05fde2b
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-smb3-limit-noisy-error.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-limit-noisy-error.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_knpj07390>
X-Attachment-Id: f_knpj07390

RnJvbSAwZTg4NjgyMTJkMWNhMmY2MzkxNzFmZWI5M2Y3YjJiMjcwZWM5YWJhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTkgQXByIDIwMjEgMjM6MjI6MzcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBsaW1pdCBub2lzeSBlcnJvcgoKRm9yIHNlcnZlcnMgd2hpY2ggZG9uJ3Qgc3VwcG9ydCBj
b3B5X3JhbmdlIChTTUIzIENvcHlDaHVuayksIHRoZQpsb2dnaW5nIG9mOgogQ0lGUzogVkZTOiBc
XHNlcnZlclxzaGFyZSByZWZjcHkgaW9jdGwgZXJyb3IgLTk1IGdldHRpbmcgcmVzdW1lIGtleQpj
YW4gZmlsbCB0aGUgY2xpZW50IGxvZ3MgYW5kIG1ha2UgZGVidWdnaW5nIHJlYWwgcHJvYmxlbXMg
bW9yZQpkaWZmaWN1bHQuICBDaGFuZ2UgdGhlIC1FT1BOT1RTVVBQIG9uIGNvcHlfcmFuZ2UgdG8g
YSAid2FybiBvbmNlIgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm9wcy5jIHwgNSArKysrLQogMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggNWNjYzM2ZDk4ZGFkLi5kZDBlYjY2
NWI2ODAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9w
cy5jCkBAIC0xNTY3LDcgKzE1NjcsMTAgQEAgU01CMl9yZXF1ZXN0X3Jlc19rZXkoY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCU5VTEwsIDAgLyogbm8g
aW5wdXQgKi8sIENJRlNNYXhCdWZTaXplLAogCQkJKGNoYXIgKiopJnJlc19rZXksICZyZXRfZGF0
YV9sZW4pOwogCi0JaWYgKHJjKSB7CisJaWYgKHJjID09IC1FT1BOT1RTVVBQKSB7CisJCXByX3dh
cm5fb25jZSgiU2VydmVyIHNoYXJlICVzIGRvZXMgbm90IHN1cHBvcnQgY29weSByYW5nZVxuIiwg
dGNvbi0+dHJlZU5hbWUpOworCQlnb3RvIHJlcV9yZXNfa2V5X2V4aXQ7CisJfSBlbHNlIGlmIChy
YykgewogCQljaWZzX3Rjb25fZGJnKFZGUywgInJlZmNweSBpb2N0bCBlcnJvciAlZCBnZXR0aW5n
IHJlc3VtZSBrZXlcbiIsIHJjKTsKIAkJZ290byByZXFfcmVzX2tleV9leGl0OwogCX0KLS0gCjIu
MjcuMAoK
--000000000000735e4805c05fde2b--
