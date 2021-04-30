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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F398CC433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 22:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0BAE613C8
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 22:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhD3WUi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Apr 2021 18:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3WUi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Apr 2021 18:20:38 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A13AC06138C
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 15:19:48 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n138so112489811lfa.3
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 15:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=677GcbHbokuUz3ONbfkNbzflb201QxYqU7+ghCNqpbc=;
        b=BHUrv5NP4Fd2YMxGip1UqfRuZLCwDV2X4wvdf8qzgorWRqoetejtOY1+SW1UeyuhQW
         eBe1oBoc+zKbkHU73I/ivmlv5MjBnm7Fx34StdxBucLD1VAggLvRpgIZwiiYHF7H2FDv
         TrkDpXJBytM+1nuofF4mFOLPqX7DRMXwdKUPEcOlSXJAWLtO6cR11jTXLaTWucooELNi
         uq5muAGrHlWRUBLYAHYuLJDKKBvAa4IuK2X5/zXav+clky57t4UZydlFn+k88xBQBcwS
         GOaZ+5TuJIS6w4EElf0tz78yBsOhEDZDAou6vSzcnf8BFnjFw9KJVPZBg9p8/IdLCehC
         qQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=677GcbHbokuUz3ONbfkNbzflb201QxYqU7+ghCNqpbc=;
        b=sfzXLz7O+x71hmfVFCke+VGvG13ZaNnFw5T+8soYhy5vQi6s1hcri/acTPudivtKhg
         4qM4fPl1HvDuC+2IODF4KPRSu/fElOW23LslCXO1NjkfIkusFtA14jYHqENlPdbAlBs5
         mUyHldq/XW2/JJKHVWY5S6Oy+ZZ39/Nsw68TuZxLNXJTO0KfkS3xav9AQ3NHk6PezL5e
         E5pOpxEUfNKAjSYiKIi8Nud22Ntv8uAZRUf/oSW1oYBawBfe3k72jWGUi/hv627XhrRP
         I17jB31kGO/3iAYH8X1BGeiucy1JEk4SuyT7VPv2aeZObMr91KfMxzg2rOH5pmg2rvky
         JAbw==
X-Gm-Message-State: AOAM5339jwryHZEA8zhhD8XDS+v6fENGrGEajiRO8UiXp2vCReuWX4hu
        ghw6DdN8XwIjvMNte+2voVAc3S6WMNJIZEoc/x/OIHbKlg8=
X-Google-Smtp-Source: ABdhPJy3UDscRBKYNvUxMRAICDfGRNZbJj9nqMWhFL0yUvA0ciNLJlNDwe9ooE4ySoGkqorZSNbNtuohpD+x+kq4vTo=
X-Received: by 2002:a19:e21d:: with SMTP id z29mr267504lfg.175.1619821186383;
 Fri, 30 Apr 2021 15:19:46 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 30 Apr 2021 17:19:35 -0500
Message-ID: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
Subject: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve debugging of
 encrypted shares
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary="0000000000006a104905c1380236"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000006a104905c1380236
Content-Type: text/plain; charset="UTF-8"

Previously we were only able to dump CCM or GCM-128 keys (see "smbinfo
keys" e.g.)
to allow network debugging (e.g. wireshark) of mounts to SMB3.1.1 encrypted
shares.  But with the addition of GCM-256 support, we have to be able to dump
32 byte instead of 16 byte keys which requires adding an additional ioctl
for that.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifs_ioctl.h | 19 +++++++++++++++++++
 fs/cifs/ioctl.c      | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
index f262c64516bc..9f2ed9cccb08 100644
--- a/fs/cifs/cifs_ioctl.h
+++ b/fs/cifs/cifs_ioctl.h
@@ -57,6 +57,12 @@ struct smb_query_info {
  /* char buffer[]; */
 } __packed;

+/*
+ * Dumping the commonly used 16 byte (e.g. CCM and GCM128) keys still supported
+ * for backlevel compatibility, but is not sufficient for dumping the less
+ * frequently used GCM256 (32 byte) keys (see the newer "CIFS_DUMP_FULL_KEY"
+ * ioctl for dumping decryption info for GCM256 mounts)
+ */
 struct smb3_key_debug_info {
  __u64 Suid;
  __u16 cipher_type;
@@ -65,6 +71,18 @@ struct smb3_key_debug_info {
  __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
 } __packed;

+/*
+ * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
+ * is needed if GCM256 (stronger encryption) negotiated
+ */
+struct smb3_full_key_debug_info {
+ __u64 Suid;
+ __u16 cipher_type;
+ __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
+ __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
+ __u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
+} __packed;
+
 struct smb3_notify {
  __u32 completion_filter;
  bool watch_tree;
@@ -78,6 +96,7 @@ struct smb3_notify {
 #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
 #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_info)
 #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
+#define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct
smb3_full_key_debug_info)
 #define CIFS_IOC_SHUTDOWN _IOR ('X', 125, __u32)

 /*
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index ef41fa878793..e4321e2a27d2 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -218,6 +218,7 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
 {
  struct inode *inode = file_inode(filep);
  struct smb3_key_debug_info pkey_inf;
+ struct smb3_full_key_debug_info pfull_key_inf;
  int rc = -ENOTTY; /* strange error - but the precedent */
  unsigned int xid;
  struct cifsFileInfo *pSMBFile = filep->private_data;
@@ -354,6 +355,38 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  else
  rc = 0;
  break;
+ /*
+ * Dump full key (32 bytes instead of 16 bytes) is
+ * needed if GCM256 (stronger encryption) negotiated
+ */
+ case CIFS_DUMP_FULL_KEY:
+ if (pSMBFile == NULL)
+ break;
+ if (!capable(CAP_SYS_ADMIN)) {
+ rc = -EACCES;
+ break;
+ }
+
+ tcon = tlink_tcon(pSMBFile->tlink);
+ if (!smb3_encryption_required(tcon)) {
+ rc = -EOPNOTSUPP;
+ break;
+ }
+ pfull_key_inf.cipher_type =
+ le16_to_cpu(tcon->ses->server->cipher_type);
+ pfull_key_inf.Suid = tcon->ses->Suid;
+ memcpy(pfull_key_inf.auth_key, tcon->ses->auth_key.response,
+ 16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
+ memcpy(pfull_key_inf.smb3decryptionkey,
+       tcon->ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
+ memcpy(pfull_key_inf.smb3encryptionkey,
+       tcon->ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE);
+ if (copy_to_user((void __user *)arg, &pfull_key_inf,
+ sizeof(struct smb3_full_key_debug_info)))
+ rc = -EFAULT;
+ else
+ rc = 0;
+ break;
  case CIFS_IOC_NOTIFY:
  if (!S_ISDIR(inode->i_mode)) {
  /* Notify can only be done on directories */

-- 
Thanks,

Steve

--0000000000006a104905c1380236
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3.1.1-allow-dumping-GCM256-keys-to-improve-debugg.patch"
Content-Disposition: attachment; 
	filename="0001-smb3.1.1-allow-dumping-GCM256-keys-to-improve-debugg.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko4vol0c0>
X-Attachment-Id: f_ko4vol0c0

RnJvbSBhNTFhMmVhMGY4ZDcyZjBjM2U2OTFmMjUzYmIyYjQ4ZGI2OWNiMDM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMzAgQXByIDIwMjEgMTc6MTQ6NDUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzLjEuMTogYWxsb3cgZHVtcGluZyBHQ00yNTYga2V5cyB0byBpbXByb3ZlIGRlYnVnZ2luZyBv
ZgogZW5jcnlwdGVkIHNoYXJlcwoKUHJldmlvdXNseSB3ZSB3ZXJlIG9ubHkgYWJsZSB0byBkdW1w
IENDTSBvciBHQ00tMTI4IGtleXMgKHNlZSAic21iaW5mbyBrZXlzIiBlLmcuKQp0byBhbGxvdyBu
ZXR3b3JrIGRlYnVnZ2luZyAoZS5nLiB3aXJlc2hhcmspIG9mIG1vdW50cyB0byBTTUIzLjEuMSBl
bmNyeXB0ZWQKc2hhcmVzLiAgQnV0IHdpdGggdGhlIGFkZGl0aW9uIG9mIEdDTS0yNTYgc3VwcG9y
dCwgd2UgaGF2ZSB0byBiZSBhYmxlIHRvIGR1bXAKMzIgYnl0ZSBpbnN0ZWFkIG9mIDE2IGJ5dGUg
a2V5cyB3aGljaCByZXF1aXJlcyBhZGRpbmcgYW4gYWRkaXRpb25hbCBpb2N0bApmb3IgdGhhdC4K
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9jaWZzL2NpZnNfaW9jdGwuaCB8IDE5ICsrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMv
aW9jdGwuYyAgICAgIHwgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiAyIGZp
bGVzIGNoYW5nZWQsIDUyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNf
aW9jdGwuaCBiL2ZzL2NpZnMvY2lmc19pb2N0bC5oCmluZGV4IGYyNjJjNjQ1MTZiYy4uOWYyZWQ5
Y2NjYjA4IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNfaW9jdGwuaAorKysgYi9mcy9jaWZzL2Np
ZnNfaW9jdGwuaApAQCAtNTcsNiArNTcsMTIgQEAgc3RydWN0IHNtYl9xdWVyeV9pbmZvIHsKIAkv
KiBjaGFyIGJ1ZmZlcltdOyAqLwogfSBfX3BhY2tlZDsKIAorLyoKKyAqIER1bXBpbmcgdGhlIGNv
bW1vbmx5IHVzZWQgMTYgYnl0ZSAoZS5nLiBDQ00gYW5kIEdDTTEyOCkga2V5cyBzdGlsbCBzdXBw
b3J0ZWQKKyAqIGZvciBiYWNrbGV2ZWwgY29tcGF0aWJpbGl0eSwgYnV0IGlzIG5vdCBzdWZmaWNp
ZW50IGZvciBkdW1waW5nIHRoZSBsZXNzCisgKiBmcmVxdWVudGx5IHVzZWQgR0NNMjU2ICgzMiBi
eXRlKSBrZXlzIChzZWUgdGhlIG5ld2VyICJDSUZTX0RVTVBfRlVMTF9LRVkiCisgKiBpb2N0bCBm
b3IgZHVtcGluZyBkZWNyeXB0aW9uIGluZm8gZm9yIEdDTTI1NiBtb3VudHMpCisgKi8KIHN0cnVj
dCBzbWIzX2tleV9kZWJ1Z19pbmZvIHsKIAlfX3U2NAlTdWlkOwogCV9fdTE2CWNpcGhlcl90eXBl
OwpAQCAtNjUsNiArNzEsMTggQEAgc3RydWN0IHNtYjNfa2V5X2RlYnVnX2luZm8gewogCV9fdTgJ
c21iM2RlY3J5cHRpb25rZXlbU01CM19TSUdOX0tFWV9TSVpFXTsKIH0gX19wYWNrZWQ7CiAKKy8q
CisgKiBEdW1wIGZ1bGwga2V5ICgzMiBieXRlIGVuY3J5cHQvZGVjcnlwdCBrZXlzIGluc3RlYWQg
b2YgMTYgYnl0ZXMpCisgKiBpcyBuZWVkZWQgaWYgR0NNMjU2IChzdHJvbmdlciBlbmNyeXB0aW9u
KSBuZWdvdGlhdGVkCisgKi8KK3N0cnVjdCBzbWIzX2Z1bGxfa2V5X2RlYnVnX2luZm8geworCV9f
dTY0CVN1aWQ7CisJX191MTYJY2lwaGVyX3R5cGU7CisJX191OAlhdXRoX2tleVsxNl07IC8qIFNN
QjJfTlRMTVYyX1NFU1NLRVlfU0laRSAqLworCV9fdTgJc21iM2VuY3J5cHRpb25rZXlbU01CM19F
TkNfREVDX0tFWV9TSVpFXTsKKwlfX3U4CXNtYjNkZWNyeXB0aW9ua2V5W1NNQjNfRU5DX0RFQ19L
RVlfU0laRV07Cit9IF9fcGFja2VkOworCiBzdHJ1Y3Qgc21iM19ub3RpZnkgewogCV9fdTMyCWNv
bXBsZXRpb25fZmlsdGVyOwogCWJvb2wJd2F0Y2hfdHJlZTsKQEAgLTc4LDYgKzk2LDcgQEAgc3Ry
dWN0IHNtYjNfbm90aWZ5IHsKICNkZWZpbmUgQ0lGU19RVUVSWV9JTkZPIF9JT1dSKENJRlNfSU9D
VExfTUFHSUMsIDcsIHN0cnVjdCBzbWJfcXVlcnlfaW5mbykKICNkZWZpbmUgQ0lGU19EVU1QX0tF
WSBfSU9XUihDSUZTX0lPQ1RMX01BR0lDLCA4LCBzdHJ1Y3Qgc21iM19rZXlfZGVidWdfaW5mbykK
ICNkZWZpbmUgQ0lGU19JT0NfTk9USUZZIF9JT1coQ0lGU19JT0NUTF9NQUdJQywgOSwgc3RydWN0
IHNtYjNfbm90aWZ5KQorI2RlZmluZSBDSUZTX0RVTVBfRlVMTF9LRVkgX0lPV1IoQ0lGU19JT0NU
TF9NQUdJQywgMTAsIHN0cnVjdCBzbWIzX2Z1bGxfa2V5X2RlYnVnX2luZm8pCiAjZGVmaW5lIENJ
RlNfSU9DX1NIVVRET1dOIF9JT1IgKCdYJywgMTI1LCBfX3UzMikKIAogLyoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvaW9jdGwuYyBiL2ZzL2NpZnMvaW9jdGwuYwppbmRleCBlZjQxZmE4Nzg3OTMuLmU0
MzIxZTJhMjdkMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pb2N0bC5jCisrKyBiL2ZzL2NpZnMvaW9j
dGwuYwpAQCAtMjE4LDYgKzIxOCw3IEBAIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmls
ZXAsIHVuc2lnbmVkIGludCBjb21tYW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIHsKIAlzdHJ1Y3Qg
aW5vZGUgKmlub2RlID0gZmlsZV9pbm9kZShmaWxlcCk7CiAJc3RydWN0IHNtYjNfa2V5X2RlYnVn
X2luZm8gcGtleV9pbmY7CisJc3RydWN0IHNtYjNfZnVsbF9rZXlfZGVidWdfaW5mbyBwZnVsbF9r
ZXlfaW5mOwogCWludCByYyA9IC1FTk9UVFk7IC8qIHN0cmFuZ2UgZXJyb3IgLSBidXQgdGhlIHBy
ZWNlZGVudCAqLwogCXVuc2lnbmVkIGludCB4aWQ7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqcFNN
QkZpbGUgPSBmaWxlcC0+cHJpdmF0ZV9kYXRhOwpAQCAtMzU0LDYgKzM1NSwzOCBAQCBsb25nIGNp
ZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5zaWdu
ZWQgbG9uZyBhcmcpCiAJCQllbHNlCiAJCQkJcmMgPSAwOwogCQkJYnJlYWs7CisJCS8qCisJCSAq
IER1bXAgZnVsbCBrZXkgKDMyIGJ5dGVzIGluc3RlYWQgb2YgMTYgYnl0ZXMpIGlzCisJCSAqIG5l
ZWRlZCBpZiBHQ00yNTYgKHN0cm9uZ2VyIGVuY3J5cHRpb24pIG5lZ290aWF0ZWQKKwkJICovCisJ
CWNhc2UgQ0lGU19EVU1QX0ZVTExfS0VZOgorCQkJaWYgKHBTTUJGaWxlID09IE5VTEwpCisJCQkJ
YnJlYWs7CisJCQlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpIHsKKwkJCQlyYyA9IC1FQUND
RVM7CisJCQkJYnJlYWs7CisJCQl9CisKKwkJCXRjb24gPSB0bGlua190Y29uKHBTTUJGaWxlLT50
bGluayk7CisJCQlpZiAoIXNtYjNfZW5jcnlwdGlvbl9yZXF1aXJlZCh0Y29uKSkgeworCQkJCXJj
ID0gLUVPUE5PVFNVUFA7CisJCQkJYnJlYWs7CisJCQl9CisJCQlwZnVsbF9rZXlfaW5mLmNpcGhl
cl90eXBlID0KKwkJCQlsZTE2X3RvX2NwdSh0Y29uLT5zZXMtPnNlcnZlci0+Y2lwaGVyX3R5cGUp
OworCQkJcGZ1bGxfa2V5X2luZi5TdWlkID0gdGNvbi0+c2VzLT5TdWlkOworCQkJbWVtY3B5KHBm
dWxsX2tleV9pbmYuYXV0aF9rZXksIHRjb24tPnNlcy0+YXV0aF9rZXkucmVzcG9uc2UsCisJCQkJ
CTE2IC8qIFNNQjJfTlRMTVYyX1NFU1NLRVlfU0laRSAqLyk7CisJCQltZW1jcHkocGZ1bGxfa2V5
X2luZi5zbWIzZGVjcnlwdGlvbmtleSwKKwkJCSAgICAgIHRjb24tPnNlcy0+c21iM2RlY3J5cHRp
b25rZXksIFNNQjNfRU5DX0RFQ19LRVlfU0laRSk7CisJCQltZW1jcHkocGZ1bGxfa2V5X2luZi5z
bWIzZW5jcnlwdGlvbmtleSwKKwkJCSAgICAgIHRjb24tPnNlcy0+c21iM2VuY3J5cHRpb25rZXks
IFNNQjNfRU5DX0RFQ19LRVlfU0laRSk7CisJCQlpZiAoY29weV90b191c2VyKCh2b2lkIF9fdXNl
ciAqKWFyZywgJnBmdWxsX2tleV9pbmYsCisJCQkJCXNpemVvZihzdHJ1Y3Qgc21iM19mdWxsX2tl
eV9kZWJ1Z19pbmZvKSkpCisJCQkJcmMgPSAtRUZBVUxUOworCQkJZWxzZQorCQkJCXJjID0gMDsK
KwkJCWJyZWFrOwogCQljYXNlIENJRlNfSU9DX05PVElGWToKIAkJCWlmICghU19JU0RJUihpbm9k
ZS0+aV9tb2RlKSkgewogCQkJCS8qIE5vdGlmeSBjYW4gb25seSBiZSBkb25lIG9uIGRpcmVjdG9y
aWVzICovCi0tIAoyLjI3LjAKCg==
--0000000000006a104905c1380236--
