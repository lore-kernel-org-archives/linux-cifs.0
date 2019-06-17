Return-Path: <SRS0=A3cw=UQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50659C31E5B
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 22:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 238C2208C0
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jun 2019 22:38:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9gxulqx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfFQWir (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:38:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35832 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQWir (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jun 2019 18:38:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id d126so6436431pfd.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jun 2019 15:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=pjiZXEZ4EwnxxNost5O//yy7iV5QE5TEsGkBJ1niPX8=;
        b=I9gxulqxafE8lnd9FoTZeOoleaToE97ezPuAl63Hy4RjPGNih3xmjrcJNrGV+87tep
         Frdtz52jsiBa99VVx9wcL6e36fqpuG8tqR9iQJn4YR7QcqZceOQUGmpzC1cSzgb5vdBx
         aUrzm1N+GtDkNjUzidQFpvqIa/3KDR3HyxDM+djnlMlEC+9cmml8ID92Ti2OcKjT4HWQ
         Fu0AuTWscHkHWS804AC1J0LqN228MEVWMKNYENL27ghje9+X2TrXqcWKBUQW1E69YpcX
         SBmjy71TS8aCFJJS6+AwNq3w0jJf31AqJmB+6pDLjkUmJHH6vMnTHVLhNjpRJmMtioNX
         fBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pjiZXEZ4EwnxxNost5O//yy7iV5QE5TEsGkBJ1niPX8=;
        b=TVml4/pUxZo8F1NTkdhn8QaF6robyySad6cmmnIGhVrXy/ubfoupEbUvfzElajTQBq
         /diWZAQmpQMtvliVvM4UoBtiviuUUVjlc5YKRrJt7bSG0DhZsTSWtsMn+W4WxgHNZAd6
         ehufnqN9r0o+8mwf3HLb/aLswFcSE92OnTYc4kA7aB/lSzNVhkVypcj8fyp+7QGXmtJY
         sk7/tNZKSDl2jhBPmjpVCmGKiHVUwWrEPirEvnbz9j8P/3mZj8kDt/KLTvtO6H3Mj8Ad
         EtybeTrom90MlQflipaE/jVLhL6c1vxeHvp+aoGN1kJfINp7G/Wx1YkaGVpXQgHevG35
         bqvw==
X-Gm-Message-State: APjAAAVDELWRDc/Vat1W46H+govyQNgj/rGpVe0b0u/uobFZNTq+Vo7c
        ddMpqtpexPsGzEyFkOWwHx4ZrrN74gcYZrKEsq+nO0kP
X-Google-Smtp-Source: APXvYqy1cbDQaEVXEawhSlShj1t9Sx1jsgsGKX6419oTqJZLkJMjCmTOVOsBHI1kbxommYZ/ZfEJEp2U9a+ErbWCXQ8=
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr1604032pje.12.1560811126418;
 Mon, 17 Jun 2019 15:38:46 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 Jun 2019 17:38:35 -0500
Message-ID: <CAH2r5mv=mW+zOgMUpXPjJbAzgUfigsod7YNVUq9-v5Da1Hu9Ug@mail.gmail.com>
Subject: [PATCH][SMB3] if max_credits is specified on mount then display it in /proc/mounts
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c0967c058b8ca873"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c0967c058b8ca873
Content-Type: text/plain; charset="UTF-8"

If "max_credits" is overridden from its default by specifying
it on the smb3 mount then display it in /proc/mounts

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d06edebf3a73..786e07754107 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -554,6 +554,11 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
     seq_printf(s, ",bsize=%u", cifs_sb->bsize);
     seq_printf(s, ",echo_interval=%lu",
             tcon->ses->server->echo_interval / HZ);
+
+    /* Only display max_credits if it was overridden on mount */
+    if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
+        seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
+
     if (tcon->snapshot_time)
         seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
     if (tcon->handle_timeout)
-- 


-- 
Thanks,

Steve

--000000000000c0967c058b8ca873
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-if-max_credits-is-specified-then-display-it-in-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-if-max_credits-is-specified-then-display-it-in-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jx0ymqce0>
X-Attachment-Id: f_jx0ymqce0

RnJvbSBlMzVhZTFiZDY4ODE1MjllMTYyMGU4OTY2NDAxMTZmNjFhMzdjZjk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTcgSnVuIDIwMTkgMTc6MzQ6NTcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBpZiBtYXhfY3JlZGl0cyBpcyBzcGVjaWZpZWQgdGhlbiBkaXNwbGF5IGl0IGluCiAvcHJv
Yy9tb3VudHMKCklmICJtYXhfY3JlZGl0cyIgaXMgb3ZlcnJpZGRlbiBmcm9tIGl0cyBkZWZhdWx0
IGJ5IHNwZWNpZnlpbmcKaXQgb24gdGhlIHNtYjMgbW91bnQgdGhlbiBkaXNwbGF5IGl0IGluIC9w
cm9jL21vdW50cwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2ZzLmMgfCA1ICsrKysrCiAxIGZpbGUgY2hhbmdlZCwg
NSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMv
Y2lmc2ZzLmMKaW5kZXggZDA2ZWRlYmYzYTczLi43ODZlMDc3NTQxMDcgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtNTU0LDYgKzU1NCwxMSBA
QCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIHN0cnVjdCBkZW50cnkgKnJv
b3QpCiAJc2VxX3ByaW50ZihzLCAiLGJzaXplPSV1IiwgY2lmc19zYi0+YnNpemUpOwogCXNlcV9w
cmludGYocywgIixlY2hvX2ludGVydmFsPSVsdSIsCiAJCQl0Y29uLT5zZXMtPnNlcnZlci0+ZWNo
b19pbnRlcnZhbCAvIEhaKTsKKworCS8qIE9ubHkgZGlzcGxheSBtYXhfY3JlZGl0cyBpZiBpdCB3
YXMgb3ZlcnJpZGRlbiBvbiBtb3VudCAqLworCWlmICh0Y29uLT5zZXMtPnNlcnZlci0+bWF4X2Ny
ZWRpdHMgIT0gU01CMl9NQVhfQ1JFRElUU19BVkFJTEFCTEUpCisJCXNlcV9wcmludGYocywgIixt
YXhfY3JlZGl0cz0ldSIsIHRjb24tPnNlcy0+c2VydmVyLT5tYXhfY3JlZGl0cyk7CisKIAlpZiAo
dGNvbi0+c25hcHNob3RfdGltZSkKIAkJc2VxX3ByaW50ZihzLCAiLHNuYXBzaG90PSVsbHUiLCB0
Y29uLT5zbmFwc2hvdF90aW1lKTsKIAlpZiAodGNvbi0+aGFuZGxlX3RpbWVvdXQpCi0tIAoyLjIw
LjEKCg==
--000000000000c0967c058b8ca873--
