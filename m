Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC7AC4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 19:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E81616103C
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 19:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhHWTIW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 15:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhHWTIS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Aug 2021 15:08:18 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A809C061575
        for <linux-cifs@vger.kernel.org>; Mon, 23 Aug 2021 12:07:35 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id v19so14767213lfo.7
        for <linux-cifs@vger.kernel.org>; Mon, 23 Aug 2021 12:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=lsrUb2w9dBtJar0w3t01JWd9FvqTsF6Gr1yBGgISLs0=;
        b=IgWDfVtBV4mshlBOX21zcT1klCZo4VZiezC6Rmw0+j/vkAjBtubBgjYrMqPrq0S3DR
         P4/VslD2sj3jiRoGRzgZFRPi/5xlJsVEgJhsmtolIzXXBT4cbivh7iwVxOyaDsYxLQOR
         RhAEpyJYskbFKG3Ym/0dJeHlga7SHPCadENgEmxu4TjZKAVDELjI5qrdUIPl3QIQsfgu
         AYGvRRwRQ6KwBfWJBmUl1xvmXXGw/lHW+Tv0+fn8y2HsWfWCZVM/KdZ/EAQ244NVUyUp
         3t7hzoc5QXt2tOj07N3gU6lHLsBToTIIpb9AqYg/R+bUou7qXYB/9W43rqKUAM7eToVn
         Wsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=lsrUb2w9dBtJar0w3t01JWd9FvqTsF6Gr1yBGgISLs0=;
        b=MwXBJI/X9hBzJmRdWVizPytIxdc+UScJnSakhSww+H95s9AKgmgw+OTHTT6HlXvFio
         kl7Fb/zc8ta2hNL8DlHz/eETpelEUjNm/YcFaC0bnsTN4935lZ5LJgz6ZoSk0cat//rG
         24o5Cfxk3t68sT+S78AlApS15+9eAZqgC/Lr80FDpDyMRBhaP/mNdwUV7O1x5TvprJP0
         sEzUTloA5YzOGOmkeLrZJBgQdqYGJg2Pf3U3Cx+4yxQT2atiFTX144TBCHqe0lEmscOX
         QVKzoLZ2XDxcnCQhVvhYru5UjsVl7rBUNdYVNFPFzdPZQ5A1gqOX8M1SjWLMCkNfFmsM
         ZlRg==
X-Gm-Message-State: AOAM531FFedBtaUzMcy5EbcEiAllSdFaF17/bS7o8Crqoe4Rdy+kYkdU
        chBp77pdeL81V2CP/dkdm3Zub3FiqXqdoyNdK6ihscoLoR0=
X-Google-Smtp-Source: ABdhPJyRmZNH6Qx3qE38wYUklJ7hgL/CD8r4oYCZ+sLogo6AThTOjkpH51gxAbk2uIPURUM1acgKYm7ec2TvzV8VyJE=
X-Received: by 2002:a05:6512:3ef:: with SMTP id n15mr3163245lfq.184.1629745653081;
 Mon, 23 Aug 2021 12:07:33 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Aug 2021 14:07:22 -0500
Message-ID: <CAH2r5muZqv0Zv415suhAjv5s9a=rU8nMkY1p7doq5koMYU0wBA@mail.gmail.com>
Subject: [PATCH][SMB3.1.1] incorrect initialization of the posix extensions in
 new mount API
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: multipart/mixed; boundary="000000000000ba1ef305ca3eba58"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ba1ef305ca3eba58
Content-Type: text/plain; charset="UTF-8"

We were incorrectly initializing the posix extensions in the
conversion to the new mount API.

CC: <stable@vger.kernel.org> # 5.11+
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/fs_context.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 4515a0883262..3109def8e199 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1252,10 +1252,17 @@ static int smb3_fs_context_parse_param(struct
fs_context *fc,
  ctx->posix_paths = 1;
  break;
  case Opt_unix:
- if (result.negated)
+ if (result.negated) {
+ if (ctx->linux_ext == 1)
+ pr_warn_once("conflicting posix mount options specified\n");
  ctx->linux_ext = 0;
- else
  ctx->no_linux_ext = 1;
+ } else {
+ if (ctx->no_linux_ext == 1)
+ pr_warn_once("conflicting posix mount options specified\n");
+ ctx->linux_ext = 1;
+ ctx->no_linux_ext = 0;
+ }
  break;
  case Opt_nocase:
  ctx->nocase = 1;

-- 
Thanks,

Steve

--000000000000ba1ef305ca3eba58
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-posix-extensions-mount-option.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-posix-extensions-mount-option.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksp0gft00>
X-Attachment-Id: f_ksp0gft00

RnJvbSBiZmI3ZDFiODgwNmZlOGRlY2M5Nzc5NjNiOWVkZGJmOWM0Y2VkOWQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjMgQXVnIDIwMjEgMTM6NTI6MTIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggcG9zaXggZXh0ZW5zaW9ucyBtb3VudCBvcHRpb24KCldlIHdlcmUgaW5jb3JyZWN0
bHkgaW5pdGlhbGl6aW5nIHRoZSBwb3NpeCBleHRlbnNpb25zIGluIHRoZQpjb252ZXJzaW9uIHRv
IHRoZSBuZXcgbW91bnQgQVBJLgoKQ0M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDUuMTEr
ClJlcG9ydGVkLWJ5OiBDaHJpc3RpYW4gQnJhdW5lciA8Y2hyaXN0aWFuLmJyYXVuZXJAdWJ1bnR1
LmNvbT4KU3VnZ2VzdGVkLWJ5OiBOYW1qYWUgSmVvbiA8bmFtamFlLmplb25Ac2Ftc3VuZy5jb20+
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9jaWZzL2ZzX2NvbnRleHQuYyB8IDExICsrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNf
Y29udGV4dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXggNDUxNWEwODgzMjYyLi4zMTA5
ZGVmOGUxOTkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMv
ZnNfY29udGV4dC5jCkBAIC0xMjUyLDEwICsxMjUyLDE3IEBAIHN0YXRpYyBpbnQgc21iM19mc19j
b250ZXh0X3BhcnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCWN0eC0+cG9zaXhf
cGF0aHMgPSAxOwogCQlicmVhazsKIAljYXNlIE9wdF91bml4OgotCQlpZiAocmVzdWx0Lm5lZ2F0
ZWQpCisJCWlmIChyZXN1bHQubmVnYXRlZCkgeworCQkJaWYgKGN0eC0+bGludXhfZXh0ID09IDEp
CisJCQkJcHJfd2Fybl9vbmNlKCJjb25mbGljdGluZyBwb3NpeCBtb3VudCBvcHRpb25zIHNwZWNp
ZmllZFxuIik7CiAJCQljdHgtPmxpbnV4X2V4dCA9IDA7Ci0JCWVsc2UKIAkJCWN0eC0+bm9fbGlu
dXhfZXh0ID0gMTsKKwkJfSBlbHNlIHsKKwkJCWlmIChjdHgtPm5vX2xpbnV4X2V4dCA9PSAxKQor
CQkJCXByX3dhcm5fb25jZSgiY29uZmxpY3RpbmcgcG9zaXggbW91bnQgb3B0aW9ucyBzcGVjaWZp
ZWRcbiIpOworCQkJY3R4LT5saW51eF9leHQgPSAxOworCQkJY3R4LT5ub19saW51eF9leHQgPSAw
OworCQl9CiAJCWJyZWFrOwogCWNhc2UgT3B0X25vY2FzZToKIAkJY3R4LT5ub2Nhc2UgPSAxOwot
LSAKMi4zMC4yCgo=
--000000000000ba1ef305ca3eba58--
