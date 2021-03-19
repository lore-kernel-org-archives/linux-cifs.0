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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75AE1C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 05:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D20D64F59
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 05:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhCSFZl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 01:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhCSFZX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 01:25:23 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A97C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 22:25:22 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id r20so10457204ljk.4
        for <linux-cifs@vger.kernel.org>; Thu, 18 Mar 2021 22:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Oshase93bF1Ivofc+egjrvcsBJ7hy/99gSrLVUqUqp0=;
        b=HusKyZqcGycB665rHzGUbAmkTMD+Ezv8ks5tYsdbOocglQ6mISJSq+igiPaaiqONaM
         SB+AKrxJtQWFqHk9LZmxnrGhzRoRZ8iIFouxKCrGeK5vdc5Uo5wY20N6cK3mtWPPobSZ
         jz8Pt5t/t11aq61mPsnpUlTx4vmJguXmh4H9SYwwUfGV3UrvZgdBEWnS0Rsymsx23LlZ
         4Jt+RlsikquHHWgWwevL022GHF2GA8WK+CT3MWPcsdZGCaTpFkLZ3Bd6GMWZnkoRYwHj
         0KH0JYo9gVMf4FHzXqhGvaPHI/NEYOYXgcDDuqWjNs3PU62FAWXOmG1L7brUxTQWc9dY
         v/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Oshase93bF1Ivofc+egjrvcsBJ7hy/99gSrLVUqUqp0=;
        b=SgNp/Aiqoe/x1/W1GpQYxnLVCBWRXAHpUNLE9zemI638/kvDetbMN9dRTnBs9dAsk4
         JLirg3v+DRPKJfu5yUYnQOJxxmM8690gGFNzgX2doqFuEMwKJnEeWbLFcr3Cl3g/Ah+r
         K5xOOkBiVvx8uCKNnWHLY0kYuyDkeIpGfSqhPyr2qHIQUvKaexORsAsZNF3wa8Wb7HfU
         /FjbQD4yZNaXwthbRscDOb0tCpInS5mMybM2f7mY4KbKSD/ZYDQrO8iPdOV1vlBt0NTA
         OilNcN5YQqgR3YSuIakaSc9fqkrnYJvyy3kbp5AlbjdiQ/KiMVErR1cqeVDdGLBtuNos
         yIww==
X-Gm-Message-State: AOAM5334bUGgsEZfnaYD2tMWOYqspFeCmdBX1paO31isZn1oBU3QZLRH
        fQ7qMY7vNoLNPsAvM4U42i+ohBt//EL0cKBlQaxCN41HJ8furQ==
X-Google-Smtp-Source: ABdhPJxgl1i3lnu8G3kTFVriJVvQn4DIzu/XY6YX+4ItN+CO13nMjZfQF6Exda6sZ/HHyTdKWWPllDNnyf+IXAIOQOE=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr7438347ljp.406.1616131519323;
 Thu, 18 Mar 2021 22:25:19 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 00:25:08 -0500
Message-ID: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
Subject: [PATCH] cifs: fix allocation size on newly created files
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001f39c805bddcf119"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001f39c805bddcf119
Content-Type: text/plain; charset="UTF-8"

Applications that create and extend and write to a file do not
expect to see 0 allocation size.  When file is extended,
set its allocation size to a plausible value until we have a
chance to query the server for it.  When the file is cached
this will prevent showing an impossible number of allocated
blocks (like 0).  This fixes e.g. xfstests 614 which does

    1) create a file and set its size to 64K
    2) mmap write 64K to the file
    3) stat -c %b for the file (to query the number of allocated blocks)

It was failing because we returned 0 blocks.  Even though we would
return the correct cached file size, we returned an impossible
allocation size.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: <stable@vger.kernel.org>
---
 fs/cifs/inode.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7c61bc9573c0..17a2c87b811c 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2395,7 +2395,7 @@ int cifs_getattr(struct user_namespace
*mnt_userns, const struct path *path,
  * We need to be sure that all dirty pages are written and the server
  * has actual ctime, mtime and file length.
  */
- if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
+ if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
STATX_BLOCKS)) &&
      !CIFS_CACHE_READ(CIFS_I(inode)) &&
      inode->i_mapping && inode->i_mapping->nrpages != 0) {
  rc = filemap_fdatawait(inode->i_mapping);
@@ -2585,6 +2585,14 @@ cifs_set_file_size(struct inode *inode, struct
iattr *attrs,
  if (rc == 0) {
  cifsInode->server_eof = attrs->ia_size;
  cifs_setsize(inode, attrs->ia_size);
+ /*
+ * i_blocks is not related to (i_size / i_blksize),
+ * but instead 512 byte (2**9) size is required for
+ * calculating num blocks. Until we can query the
+ * server for actual allocation size, this is best estimate
+ * we have for the blocks allocated for this file
+ */
+ inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;

  /*
  * The man page of truncate says if the size changed,
@@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
struct iattr *attrs)
  sys_utimes in which case we ought to fail the call back to
  the user when the server rejects the call */
  if ((rc) && (attrs->ia_valid &
- (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
+     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
  rc = 0;
  }

-- 

-- 
Thanks,

Steve

--0000000000001f39c805bddcf119
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-allocation-size-on-newly-created-files.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-allocation-size-on-newly-created-files.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmfuy32h0>
X-Attachment-Id: f_kmfuy32h0

RnJvbSAyZWE3ZjQ0ZTU0YzdkM2M0ZTgyMzZlODI5NTBlZmI2YWVkZGEyNDg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTkgTWFyIDIwMjEgMDA6MDU6NDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggYWxsb2NhdGlvbiBzaXplIG9uIG5ld2x5IGNyZWF0ZWQgZmlsZXMKCkFwcGxpY2F0
aW9ucyB0aGF0IGNyZWF0ZSBhbmQgZXh0ZW5kIGFuZCB3cml0ZSB0byBhIGZpbGUgZG8gbm90CmV4
cGVjdCB0byBzZWUgMCBhbGxvY2F0aW9uIHNpemUuICBXaGVuIGZpbGUgaXMgZXh0ZW5kZWQsCnNl
dCBpdHMgYWxsb2NhdGlvbiBzaXplIHRvIGEgcGxhdXNpYmxlIHZhbHVlIHVudGlsIHdlIGhhdmUg
YQpjaGFuY2UgdG8gcXVlcnkgdGhlIHNlcnZlciBmb3IgaXQuICBXaGVuIHRoZSBmaWxlIGlzIGNh
Y2hlZAp0aGlzIHdpbGwgcHJldmVudCBzaG93aW5nIGFuIGltcG9zc2libGUgbnVtYmVyIG9mIGFs
bG9jYXRlZApibG9ja3MgKGxpa2UgMCkuICBUaGlzIGZpeGVzIGUuZy4geGZzdGVzdHMgNjE0IHdo
aWNoIGRvZXMKCiAgICAxKSBjcmVhdGUgYSBmaWxlIGFuZCBzZXQgaXRzIHNpemUgdG8gNjRLCiAg
ICAyKSBtbWFwIHdyaXRlIDY0SyB0byB0aGUgZmlsZQogICAgMykgc3RhdCAtYyAlYiBmb3IgdGhl
IGZpbGUgKHRvIHF1ZXJ5IHRoZSBudW1iZXIgb2YgYWxsb2NhdGVkIGJsb2NrcykKCkl0IHdhcyBm
YWlsaW5nIGJlY2F1c2Ugd2UgcmV0dXJuZWQgMCBibG9ja3MuICBFdmVuIHRob3VnaCB3ZSB3b3Vs
ZApyZXR1cm4gdGhlIGNvcnJlY3QgY2FjaGVkIGZpbGUgc2l6ZSwgd2UgcmV0dXJuZWQgYW4gaW1w
b3NzaWJsZQphbGxvY2F0aW9uIHNpemUuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0
ZnJlbmNoQG1pY3Jvc29mdC5jb20+CkNDOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KLS0tCiBm
cy9jaWZzL2lub2RlLmMgfCAxMiArKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBi
L2ZzL2NpZnMvaW5vZGUuYwppbmRleCA3YzYxYmM5NTczYzAuLjE3YTJjODdiODExYyAxMDA2NDQK
LS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjM5NSw3ICsy
Mzk1LDcgQEAgaW50IGNpZnNfZ2V0YXR0cihzdHJ1Y3QgdXNlcl9uYW1lc3BhY2UgKm1udF91c2Vy
bnMsIGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoLAogCSAqIFdlIG5lZWQgdG8gYmUgc3VyZSB0aGF0
IGFsbCBkaXJ0eSBwYWdlcyBhcmUgd3JpdHRlbiBhbmQgdGhlIHNlcnZlcgogCSAqIGhhcyBhY3R1
YWwgY3RpbWUsIG10aW1lIGFuZCBmaWxlIGxlbmd0aC4KIAkgKi8KLQlpZiAoKHJlcXVlc3RfbWFz
ayAmIChTVEFUWF9DVElNRSB8IFNUQVRYX01USU1FIHwgU1RBVFhfU0laRSkpICYmCisJaWYgKChy
ZXF1ZXN0X21hc2sgJiAoU1RBVFhfQ1RJTUUgfCBTVEFUWF9NVElNRSB8IFNUQVRYX1NJWkUgfCBT
VEFUWF9CTE9DS1MpKSAmJgogCSAgICAhQ0lGU19DQUNIRV9SRUFEKENJRlNfSShpbm9kZSkpICYm
CiAJICAgIGlub2RlLT5pX21hcHBpbmcgJiYgaW5vZGUtPmlfbWFwcGluZy0+bnJwYWdlcyAhPSAw
KSB7CiAJCXJjID0gZmlsZW1hcF9mZGF0YXdhaXQoaW5vZGUtPmlfbWFwcGluZyk7CkBAIC0yNTg1
LDYgKzI1ODUsMTQgQEAgY2lmc19zZXRfZmlsZV9zaXplKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0
cnVjdCBpYXR0ciAqYXR0cnMsCiAJaWYgKHJjID09IDApIHsKIAkJY2lmc0lub2RlLT5zZXJ2ZXJf
ZW9mID0gYXR0cnMtPmlhX3NpemU7CiAJCWNpZnNfc2V0c2l6ZShpbm9kZSwgYXR0cnMtPmlhX3Np
emUpOworCQkvKgorCQkgKiBpX2Jsb2NrcyBpcyBub3QgcmVsYXRlZCB0byAoaV9zaXplIC8gaV9i
bGtzaXplKSwKKwkJICogYnV0IGluc3RlYWQgNTEyIGJ5dGUgKDIqKjkpIHNpemUgaXMgcmVxdWly
ZWQgZm9yCisJCSAqIGNhbGN1bGF0aW5nIG51bSBibG9ja3MuIFVudGlsIHdlIGNhbiBxdWVyeSB0
aGUKKwkJICogc2VydmVyIGZvciBhY3R1YWwgYWxsb2NhdGlvbiBzaXplLCB0aGlzIGlzIGJlc3Qg
ZXN0aW1hdGUKKwkJICogd2UgaGF2ZSBmb3IgdGhlIGJsb2NrcyBhbGxvY2F0ZWQgZm9yIHRoaXMg
ZmlsZQorCQkgKi8KKwkJaW5vZGUtPmlfYmxvY2tzID0gKDUxMiAtIDEgKyBhdHRycy0+aWFfc2l6
ZSkgPj4gOTsKIAogCQkvKgogCQkgKiBUaGUgbWFuIHBhZ2Ugb2YgdHJ1bmNhdGUgc2F5cyBpZiB0
aGUgc2l6ZSBjaGFuZ2VkLApAQCAtMjkxMiw3ICsyOTIwLDcgQEAgY2lmc19zZXRhdHRyX25vdW5p
eChzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSwgc3RydWN0IGlhdHRyICphdHRycykKIAkJc3lzX3V0
aW1lcyBpbiB3aGljaCBjYXNlIHdlIG91Z2h0IHRvIGZhaWwgdGhlIGNhbGwgYmFjayB0bwogCQl0
aGUgdXNlciB3aGVuIHRoZSBzZXJ2ZXIgcmVqZWN0cyB0aGUgY2FsbCAqLwogCQlpZiAoKHJjKSAm
JiAoYXR0cnMtPmlhX3ZhbGlkICYKLQkJCQkoQVRUUl9NT0RFIHwgQVRUUl9HSUQgfCBBVFRSX1VJ
RCB8IEFUVFJfU0laRSkpKQorCQkJICAgIChBVFRSX01PREUgfCBBVFRSX0dJRCB8IEFUVFJfVUlE
IHwgQVRUUl9TSVpFKSkpCiAJCQlyYyA9IDA7CiAJfQogCi0tIAoyLjI3LjAKCg==
--0000000000001f39c805bddcf119--
