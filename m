Return-Path: <SRS0=41bt=7X=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DD9C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Jun 2020 00:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F4D206C3
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Jun 2020 00:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQB/eaX0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgFJAyl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Jun 2020 20:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFJAyl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Jun 2020 20:54:41 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BD7C05BD1E
        for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2020 17:54:40 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id b15so246005ybg.12
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2020 17:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BksAVh5CUmza5LFck2gxvUVleYd212qdvNTvNwU2IDU=;
        b=IQB/eaX0uohD/xVjOlrwzbbs2le73SnY8JHpb8g4MY9Q+UvbLeRmBajqzcvsAVghjW
         gP40AGZjWAuFbayvT99NCfcPfXPhvrzhbLNg28Qxldz2Yiv6yozO/0mwC5Ic9DBU/+Gn
         HN6qxDGODNcRU6N1/9VFm1YYVsnO5V+FHbVlWBjC9ZoMzXz2snsAh5i6RldzAjXjia6O
         hNyfYbRiLIAMPYSjJx/i8Fpf5nMXo+x75ulVsyi+BG7kMiCXa/4/wyCI49z5NyISzDjA
         ezl2cpaqWuVvNZJi+72j5uL6Ykeo6i8stiibrrwmpWJwA4dZu2TQ8tbV3RkVmrdPg7P6
         11uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BksAVh5CUmza5LFck2gxvUVleYd212qdvNTvNwU2IDU=;
        b=bYYMOSJuDry4teRyMCn+6pxSFir1IL5PW7Y8Jhafn06+tJzrPmQMl2GyJE6LMpAxIC
         fiKED3XFym1HSIh9Y+uqz3hezoLd00L3l5AYprZfldD59pW2C4qkpAzWBVl5P9eVmeyb
         AEEHkDl+xfx8UyspmqwAfhTecQ8aviIYb4OCdIk6IlcSwmsAdyKGWHF9e2C4YlXw2vDh
         LpcZF7Mt80sl4DSaHmKoV9pNlmRJ4WeP5PU4VxbDaFqyMwxfgrRHRRKveO9vbPbxU57z
         v+7/db9wwA12A0sRZHqkizhowZbLvqYKHNE0uOFWxR5az6VWuOaegFEvH/h8gtOu3LUY
         Tcuw==
X-Gm-Message-State: AOAM533n4VhkKJNLTkcfWn0fUT7mPuDBR4El0r8X19XAIIz6kr9JNnC7
        D8WAQvavwTpTJIJi8qtJ9cAj2ieIKq7vmOierZYBTGDqtWU=
X-Google-Smtp-Source: ABdhPJwikpJG99xN+F1TRIwebzjfwPoeyjHzRMD7hwqewNfN9vQH4A4LPTxUJ5zcKmmS2ylelhaeiaLQ4omp43Lf8YU=
X-Received: by 2002:a25:4487:: with SMTP id r129mr1332232yba.14.1591750478348;
 Tue, 09 Jun 2020 17:54:38 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Jun 2020 19:54:27 -0500
Message-ID: <CAH2r5mv-BZbqsDaTu+PX7Q+zxcosn=N5mM28Thr0LGyAKi9MRQ@mail.gmail.com>
Subject: [PATCH] smb3: fix typo in mount options displayed in /proc/mounts
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d55de505a7b049b6"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d55de505a7b049b6
Content-Type: text/plain; charset="UTF-8"

Missing the final 's' in "max_channels" mount option when displayed in
/proc/mounts (or by mount command)

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 889f9c71049b..0fb99d25e8a8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -623,7 +623,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
  seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);

  if (tcon->ses->chan_max > 1)
- seq_printf(s, ",multichannel,max_channel=%zu",
+ seq_printf(s, ",multichannel,max_channels=%zu",
     tcon->ses->chan_max);

  return 0;

-- 
Thanks,

Steve

--000000000000d55de505a7b049b6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-typo-in-mount-options-displayed-in-proc-mou.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-typo-in-mount-options-displayed-in-proc-mou.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kb8n424n0>
X-Attachment-Id: f_kb8n424n0

RnJvbSAxZWNmMGJlZjAxNjk5NDg4NDliODI4YmM5NDEyZDc3ZTk1NGFiZjM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOSBKdW4gMjAyMCAxOTo1MDo0MCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCB0eXBvIGluIG1vdW50IG9wdGlvbnMgZGlzcGxheWVkIGluIC9wcm9jL21vdW50cwoK
TWlzc2luZyB0aGUgZmluYWwgJ3MnIGluICJtYXhfY2hhbm5lbHMiIG1vdW50IG9wdGlvbiB3aGVu
IGRpc3BsYXllZCBpbgovcHJvYy9tb3VudHMgKG9yIGJ5IG1vdW50IGNvbW1hbmQpCgpDQzogU3Rh
YmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2gg
PHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyB8IDIgKy0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY2lmc2ZzLmMgYi9mcy9jaWZzL2NpZnNmcy5jCmluZGV4IDg4OWY5YzcxMDQ5Yi4u
MGZiOTlkMjVlOGE4IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMv
Y2lmc2ZzLmMKQEAgLTYyMyw3ICs2MjMsNyBAQCBjaWZzX3Nob3dfb3B0aW9ucyhzdHJ1Y3Qgc2Vx
X2ZpbGUgKnMsIHN0cnVjdCBkZW50cnkgKnJvb3QpCiAJc2VxX3ByaW50ZihzLCAiLGFjdGltZW89
JWx1IiwgY2lmc19zYi0+YWN0aW1lbyAvIEhaKTsKIAogCWlmICh0Y29uLT5zZXMtPmNoYW5fbWF4
ID4gMSkKLQkJc2VxX3ByaW50ZihzLCAiLG11bHRpY2hhbm5lbCxtYXhfY2hhbm5lbD0lenUiLAor
CQlzZXFfcHJpbnRmKHMsICIsbXVsdGljaGFubmVsLG1heF9jaGFubmVscz0lenUiLAogCQkJICAg
dGNvbi0+c2VzLT5jaGFuX21heCk7CiAKIAlyZXR1cm4gMDsKLS0gCjIuMjUuMQoK
--000000000000d55de505a7b049b6--
