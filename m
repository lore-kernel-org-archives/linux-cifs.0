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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B006FC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 23:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99476619D3
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 23:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZX6W (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 19:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZX5x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Mar 2021 19:57:53 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25590C0613AA
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 16:57:53 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b14so10108882lfv.8
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 16:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=T0HNGL9RjbosSy6iahR8KqBCgoS7bcDTI8Uyweu3nC4=;
        b=a2IoXtMrD63cpObX2DvmUqovLEhbN/zc7AdQC00u7drhU2iCRPCwbqVixsZehW5m9z
         ODwJMTn13hZQJjxVn5GKY34vDXJP9bnSVN86eMX21E8aSDIKzOyQVG5Q7XnT6J84jzQZ
         dK29VIsiiw3kVjKKKlL8mOWcOqS5W/HNa5jVmMKBokW8j/EwSwBha0/i5FVmNwQiyCtQ
         gILnmxlYdSYoT74MQq51yRluXaJ4roevoE/nIlQ4iW5tfKYxUg0nNN614qXhAJbxHOxe
         znATOSN48GD4dXWoclQP4NeIRlJlo6Y+xMfgmwQiUD+XuGD5dQdLLcsvUamJ/1y+DieF
         w5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=T0HNGL9RjbosSy6iahR8KqBCgoS7bcDTI8Uyweu3nC4=;
        b=BlnZez/OQqPCL4WAdo35z+HAIJ5atinYb3IutS1vZvRHFj10c7BHmAE4N8TLHgD8rx
         ZjW4beMdbAAr+wT3JyjkbPE9yw1DVX42/491+QQl1DxYh15q2PaiY7paOmkBwN6Addg5
         j6Y7u8UYrGJL5Kxh2UE863Lei4N889VFfDRPZLBZKT2nHxKedR86fSQTfJbLMMAY5E71
         ht+t2a8aUD56xQgw7UIvHE1J655BUzaIJTQEWMXgOG/bv36SCVvXJKk1z79M9ydDohBn
         uBBEavSlusY3NNXgUN7o2ZjuwEiUGPoTnCb2v1OQdEM5g8qzUTRfpUt+gPLtFoIDZyK9
         WGag==
X-Gm-Message-State: AOAM532YZS1khfULQAZ+ZGZRsw5Y11y663+6a6ESfqcldOkVn5QkAl37
        QPo+1bRPW3tpgkL4Pz6Ax9iUTrGzR6e/TggZPgN8K0qQIMvE3Q==
X-Google-Smtp-Source: ABdhPJwtEtpFhEVtKEzqS1cWIGiyqgEqRDZXUBsUwZNtOfMZ/Pj7rWvJnebWwuQq2TWQI/kgmMRCPEZ0kWLr4pJA09w=
X-Received: by 2002:a19:404f:: with SMTP id n76mr9810532lfa.184.1616803071281;
 Fri, 26 Mar 2021 16:57:51 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 26 Mar 2021 18:57:40 -0500
Message-ID: <CAH2r5mu8sfBKoYfoD5KjZ8Yq4_Ld3rp+797H1R7Fj5LBSK9rcg@mail.gmail.com>
Subject: [PATCH][SMB3] Fix file size problems in duplicate extents (reflink)
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000bc608105be794c3c"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000bc608105be794c3c
Content-Type: text/plain; charset="UTF-8"

There were two problems (one of which could cause data corruption)
that were noticed with duplicate extents (ie reflink)
when debugging why various xfstests were being incorrectly skipped
(e.g. generic/138, generic/140, generic/142). First, we were not
updating the file size locally in the cache when extending a
file due to reflink (it would refresh after actimeo expires)
but xfstest was checking the size immediately which was still
0 so caused the test to be skipped.  Second, we were setting
the target file size (which could shrink the file) in all cases
to the end of the reflinked range rather than only setting the
target file size when reflink would extend the file.

CC: <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2ops.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3e94f83897e9..f703204fb185 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2038,6 +2038,7 @@ smb2_duplicate_extents(const unsigned int xid,
 {
  int rc;
  unsigned int ret_data_len;
+ struct inode *inode;
  struct duplicate_extents_to_file dup_ext_buf;
  struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);

@@ -2054,10 +2055,21 @@ smb2_duplicate_extents(const unsigned int xid,
  cifs_dbg(FYI, "Duplicate extents: src off %lld dst off %lld len %lld\n",
  src_off, dest_off, len);

- rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
- if (rc)
- goto duplicate_extents_out;
+ inode = d_inode(trgtfile->dentry);
+ if (inode->i_size < dest_off + len) {
+ rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
+ if (rc)
+ goto duplicate_extents_out;

+ /*
+ * Although also could set plausible allocation size (i_blocks)
+ * here in addition to setting the file size, in reflink
+ * it is likely that the target file is sparse. Its allocation
+ * size will be queried on next revalidate, but it is important
+ * to make sure that file's cached size is updated immediately
+ */
+ cifs_setsize(inode, dest_off + len);
+ }
  rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
  trgtfile->fid.volatile_fid,
  FSCTL_DUPLICATE_EXTENTS_TO_FILE,

-- 
Thanks,

Steve

--000000000000bc608105be794c3c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-cached-file-size-problems-in-duplicate-exte.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-cached-file-size-problems-in-duplicate-exte.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmqyslxv0>
X-Attachment-Id: f_kmqyslxv0

RnJvbSBjZmM2M2ZjODEyNmE5M2NiZjk1Mzc5YmM0Y2FkNzlhN2IxNWI2ZWNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjYgTWFyIDIwMjEgMTg6NDE6NTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggY2FjaGVkIGZpbGUgc2l6ZSBwcm9ibGVtcyBpbiBkdXBsaWNhdGUgZXh0ZW50cwog
KHJlZmxpbmspCgpUaGVyZSB3ZXJlIHR3byBwcm9ibGVtcyAob25lIG9mIHdoaWNoIGNvdWxkIGNh
dXNlIGRhdGEgY29ycnVwdGlvbikKdGhhdCB3ZXJlIG5vdGljZWQgd2l0aCBkdXBsaWNhdGUgZXh0
ZW50cyAoaWUgcmVmbGluaykKd2hlbiBkZWJ1Z2dpbmcgd2h5IHZhcmlvdXMgeGZzdGVzdHMgd2Vy
ZSBiZWluZyBpbmNvcnJlY3RseSBza2lwcGVkCihlLmcuIGdlbmVyaWMvMTM4LCBnZW5lcmljLzE0
MCwgZ2VuZXJpYy8xNDIpLiBGaXJzdCwgd2Ugd2VyZSBub3QKdXBkYXRpbmcgdGhlIGZpbGUgc2l6
ZSBsb2NhbGx5IGluIHRoZSBjYWNoZSB3aGVuIGV4dGVuZGluZyBhCmZpbGUgZHVlIHRvIHJlZmxp
bmsgKGl0IHdvdWxkIHJlZnJlc2ggYWZ0ZXIgYWN0aW1lbyBleHBpcmVzKQpidXQgeGZzdGVzdCB3
YXMgY2hlY2tpbmcgdGhlIHNpemUgaW1tZWRpYXRlbHkgd2hpY2ggd2FzIHN0aWxsCjAgc28gY2F1
c2VkIHRoZSB0ZXN0IHRvIGJlIHNraXBwZWQuICBTZWNvbmQsIHdlIHdlcmUgc2V0dGluZwp0aGUg
dGFyZ2V0IGZpbGUgc2l6ZSAod2hpY2ggY291bGQgc2hyaW5rIHRoZSBmaWxlKSBpbiBhbGwgY2Fz
ZXMKdG8gdGhlIGVuZCBvZiB0aGUgcmVmbGlua2VkIHJhbmdlIHJhdGhlciB0aGFuIG9ubHkgc2V0
dGluZyB0aGUKdGFyZ2V0IGZpbGUgc2l6ZSB3aGVuIHJlZmxpbmsgd291bGQgZXh0ZW5kIHRoZSBm
aWxlLgoKQ0M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIyb3BzLmMgfCAx
OCArKysrKysrKysrKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9z
bWIyb3BzLmMKaW5kZXggM2U5NGY4Mzg5N2U5Li5mNzAzMjA0ZmIxODUgMTAwNjQ0Ci0tLSBhL2Zz
L2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0yMDM4LDYgKzIwMzgs
NyBAQCBzbWIyX2R1cGxpY2F0ZV9leHRlbnRzKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCiB7CiAJ
aW50IHJjOwogCXVuc2lnbmVkIGludCByZXRfZGF0YV9sZW47CisJc3RydWN0IGlub2RlICppbm9k
ZTsKIAlzdHJ1Y3QgZHVwbGljYXRlX2V4dGVudHNfdG9fZmlsZSBkdXBfZXh0X2J1ZjsKIAlzdHJ1
Y3QgY2lmc190Y29uICp0Y29uID0gdGxpbmtfdGNvbih0cmd0ZmlsZS0+dGxpbmspOwogCkBAIC0y
MDU0LDEwICsyMDU1LDIxIEBAIHNtYjJfZHVwbGljYXRlX2V4dGVudHMoY29uc3QgdW5zaWduZWQg
aW50IHhpZCwKIAljaWZzX2RiZyhGWUksICJEdXBsaWNhdGUgZXh0ZW50czogc3JjIG9mZiAlbGxk
IGRzdCBvZmYgJWxsZCBsZW4gJWxsZFxuIiwKIAkJc3JjX29mZiwgZGVzdF9vZmYsIGxlbik7CiAK
LQlyYyA9IHNtYjJfc2V0X2ZpbGVfc2l6ZSh4aWQsIHRjb24sIHRyZ3RmaWxlLCBkZXN0X29mZiAr
IGxlbiwgZmFsc2UpOwotCWlmIChyYykKLQkJZ290byBkdXBsaWNhdGVfZXh0ZW50c19vdXQ7CisJ
aW5vZGUgPSBkX2lub2RlKHRyZ3RmaWxlLT5kZW50cnkpOworCWlmIChpbm9kZS0+aV9zaXplIDwg
ZGVzdF9vZmYgKyBsZW4pIHsKKwkJcmMgPSBzbWIyX3NldF9maWxlX3NpemUoeGlkLCB0Y29uLCB0
cmd0ZmlsZSwgZGVzdF9vZmYgKyBsZW4sIGZhbHNlKTsKKwkJaWYgKHJjKQorCQkJZ290byBkdXBs
aWNhdGVfZXh0ZW50c19vdXQ7CiAKKwkJLyoKKwkJICogQWx0aG91Z2ggYWxzbyBjb3VsZCBzZXQg
cGxhdXNpYmxlIGFsbG9jYXRpb24gc2l6ZSAoaV9ibG9ja3MpCisJCSAqIGhlcmUgaW4gYWRkaXRp
b24gdG8gc2V0dGluZyB0aGUgZmlsZSBzaXplLCBpbiByZWZsaW5rCisJCSAqIGl0IGlzIGxpa2Vs
eSB0aGF0IHRoZSB0YXJnZXQgZmlsZSBpcyBzcGFyc2UuIEl0cyBhbGxvY2F0aW9uCisJCSAqIHNp
emUgd2lsbCBiZSBxdWVyaWVkIG9uIG5leHQgcmV2YWxpZGF0ZSwgYnV0IGl0IGlzIGltcG9ydGFu
dAorCQkgKiB0byBtYWtlIHN1cmUgdGhhdCBmaWxlJ3MgY2FjaGVkIHNpemUgaXMgdXBkYXRlZCBp
bW1lZGlhdGVseQorCQkgKi8KKwkJY2lmc19zZXRzaXplKGlub2RlLCBkZXN0X29mZiArIGxlbik7
CisJfQogCXJjID0gU01CMl9pb2N0bCh4aWQsIHRjb24sIHRyZ3RmaWxlLT5maWQucGVyc2lzdGVu
dF9maWQsCiAJCQl0cmd0ZmlsZS0+ZmlkLnZvbGF0aWxlX2ZpZCwKIAkJCUZTQ1RMX0RVUExJQ0FU
RV9FWFRFTlRTX1RPX0ZJTEUsCi0tIAoyLjI3LjAKCg==
--000000000000bc608105be794c3c--
