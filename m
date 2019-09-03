Return-Path: <SRS0=oOOd=W6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C68EC3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 22:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E036F21883
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Sep 2019 22:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDnpZZzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfICWy3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 18:54:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41298 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfICWy3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 18:54:29 -0400
Received: by mail-io1-f68.google.com with SMTP id f19so1469479iof.8
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 15:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XX6PnSS0XGg/J1ZrD4AQewrN8q/0nOz94IYH1WHzKjk=;
        b=HDnpZZzGzCPGC3Wpm2akx2tC2hmTaty2GGI0YqIg89UeaTKrtF3HjiXpy7s+u7aua4
         fTTlC+Gvy2/fN9YnN6Ox4WFTRa47SE4KfmH7UfoLlS5jhLfzd3Pg7p/WtmHQjlcjSH2I
         GjhMjjXrhLGrMuu81xo2ji5Mubghht0jWqwnn0Bq0tRMI9CLNzHjFryx+MjgV4rjZG3Q
         caZe1VXaQHm4bamKHxcV/1umzHeYaqevtN9kEjvLBTI3NF+0ENIuZRyCYVYomXXRAYlE
         mmuw6IBgdfA5uQTR4gX5rUkM9fQ+54QuNvQw2AYMP/MJ2ckh8CQVftWkD5HHCyzIb0LI
         mwog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XX6PnSS0XGg/J1ZrD4AQewrN8q/0nOz94IYH1WHzKjk=;
        b=hpPrQxojYeEHXnMqsZJBRyr6icqA7H5cs1kIXiDrNzvCMCb5j95rqSeq84ngg/YV11
         uXwvRHumloQid7Hx3ZNHahhil1BiwLnDWxy0F+fceU3TFcBg/vHi+hQyvC8ckvRp499a
         Mss8Rw1l1XMdPR7jfqOEJhcDs0UG2onyEbczFM3BE4yNVq36BFkY2QsIADQ8jHlj5on8
         r/tsm8Jy12NpiDpsCrxP2Z2gk2Kr2KZ765u5LPjxgufgllWFUcEeBIZph5eJoIcuyFST
         2WUleI94Gik7wmI/bLz9cKoriZCzfTd/VHZo8fjln8fe6jLL8YuoJpWgtuo9dJDFJa2X
         beMQ==
X-Gm-Message-State: APjAAAUgRZ5nt4dO14E/vJtE1+ElKorHwty+b13ukuCtkAiW5RTLdWRO
        9acZJSDg/NIEsBgepTb+60iN33a/ryULqACkHlxQpVZgqhA=
X-Google-Smtp-Source: APXvYqy7MJrikA6cZoW3mUqxKonOcNME2sfKdgUyF+KZXJfVpeBdjnL7cdGX0I3KFyK0uIxGxc69qqZfNntbTiAAEJY=
X-Received: by 2002:a6b:6303:: with SMTP id p3mr1006199iog.169.1567551268258;
 Tue, 03 Sep 2019 15:54:28 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 3 Sep 2019 17:54:17 -0500
Message-ID: <CAH2r5mtzztgoW91TvG_wTYju10dNJ+=r8Ncx3f3bebstMZiCpA@mail.gmail.com>
Subject: [PATCH] smb3: log warning if CSC policy conflicts with linux kernel
 client cache mount option
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000008327cd0591adf8db"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008327cd0591adf8db
Content-Type: text/plain; charset="UTF-8"

If the server config (e.g. Samba smb.conf "csc policy = disable)
for the share indicates that the share should not be cached, log
a warning message in the Linux kernel client if forced client side
caching ("cache=ro" or "cache=singleclient") was requested on mount.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d9a995588c74..85f8d943a05a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3478,6 +3478,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct
smb_vol *volume_info)
         tcon->use_resilient = true;
     }

+    /* If the user really knows what they are doing they can override */
+    if (tcon->share_flags & SMB2_SHAREFLAG_NO_CACHING) {
+        if (volume_info->cache_ro)
+            cifs_dbg(VFS, "cache=ro requested on mount but NO_CACHING
flag set on share\n");
+        else if (volume_info->cache_rw)
+            cifs_dbg(VFS, "cache=singleclient requested on mount but
NO_CACHING flag set on share\n");
+    }
+
     /*
      * We can have only one retry value for a connection to a share so for
      * resources mounted more than once to the same server share the last

-- 
Thanks,

Steve

--0000000000008327cd0591adf8db
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-log-warning-if-CSC-policy-conflicts-with-cache-.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-log-warning-if-CSC-policy-conflicts-with-cache-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k04fjknu0>
X-Attachment-Id: f_k04fjknu0

RnJvbSBkYWU5MzFjMDJhZWQxNDQyN2VhNDAyMmM3ZTgwMzhhYjMxMDNiNGQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMyBTZXAgMjAxOSAxNzo0OTo0NiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGxvZyB3YXJuaW5nIGlmIENTQyBwb2xpY3kgY29uZmxpY3RzIHdpdGggY2FjaGUgbW91bnQK
IG9wdGlvbgoKSWYgdGhlIHNlcnZlciBjb25maWcgKGUuZy4gU2FtYmEgc21iLmNvbmYgImNzYyBw
b2xpY3kgPSBkaXNhYmxlKQpmb3IgdGhlIHNoYXJlIGluZGljYXRlcyB0aGF0IHRoZSBzaGFyZSBz
aG91bGQgbm90IGJlIGNhY2hlZCwgbG9nCmEgd2FybmluZyBtZXNzYWdlIGlmIGZvcmNlZCBjbGll
bnQgc2lkZSBjYWNoaW5nICgiY2FjaGU9cm8iIG9yCiJjYWNoZT1zaW5nbGVjbGllbnQiKSBpcyBy
ZXF1ZXN0ZWQgb24gbW91bnQuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0LmMgfCA4ICsrKysrKysrCiAxIGZp
bGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0
LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBkOWE5OTU1ODhjNzQuLjg1ZjhkOTQzYTA1YSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIvZnMvY2lmcy9jb25uZWN0LmMKQEAg
LTM0NzgsNiArMzQ3OCwxNCBAQCBjaWZzX2dldF90Y29uKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBz
dHJ1Y3Qgc21iX3ZvbCAqdm9sdW1lX2luZm8pCiAJCXRjb24tPnVzZV9yZXNpbGllbnQgPSB0cnVl
OwogCX0KIAorCS8qIElmIHRoZSB1c2VyIHJlYWxseSBrbm93cyB3aGF0IHRoZXkgYXJlIGRvaW5n
IHRoZXkgY2FuIG92ZXJyaWRlICovCisJaWYgKHRjb24tPnNoYXJlX2ZsYWdzICYgU01CMl9TSEFS
RUZMQUdfTk9fQ0FDSElORykgeworCQlpZiAodm9sdW1lX2luZm8tPmNhY2hlX3JvKQorCQkJY2lm
c19kYmcoVkZTLCAiY2FjaGU9cm8gcmVxdWVzdGVkIG9uIG1vdW50IGJ1dCBOT19DQUNISU5HIGZs
YWcgc2V0IG9uIHNoYXJlXG4iKTsKKwkJZWxzZSBpZiAodm9sdW1lX2luZm8tPmNhY2hlX3J3KQor
CQkJY2lmc19kYmcoVkZTLCAiY2FjaGU9c2luZ2xlY2xpZW50IHJlcXVlc3RlZCBvbiBtb3VudCBi
dXQgTk9fQ0FDSElORyBmbGFnIHNldCBvbiBzaGFyZVxuIik7CisJfQorCiAJLyoKIAkgKiBXZSBj
YW4gaGF2ZSBvbmx5IG9uZSByZXRyeSB2YWx1ZSBmb3IgYSBjb25uZWN0aW9uIHRvIGEgc2hhcmUg
c28gZm9yCiAJICogcmVzb3VyY2VzIG1vdW50ZWQgbW9yZSB0aGFuIG9uY2UgdG8gdGhlIHNhbWUg
c2VydmVyIHNoYXJlIHRoZSBsYXN0Ci0tIAoyLjIwLjEKCg==
--0000000000008327cd0591adf8db--
