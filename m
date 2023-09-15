Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADA1EE3F2E
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Sep 2023 06:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjIOGWV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Sep 2023 02:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjIOGWV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Sep 2023 02:22:21 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67385270B
        for <linux-cifs@vger.kernel.org>; Thu, 14 Sep 2023 23:22:13 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-501bd6f7d11so2917301e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 Sep 2023 23:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694758931; x=1695363731; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2RccZgHor3QZym6ylEU6M76/5lXyfHljjADUUYosgcI=;
        b=cyM0TxEDhNGiXrmdsjuuAmyA3J3HTojfffgTgfyhppWOK9YCoFcKXh3pA6j8PYSPiI
         UQoAyCm/ZJYVSbzf4Zt57JPUZ3ERh+aVTYtxPO/mVRTPyN0EoigpUFdGtFdlDavzEk+e
         +TbBRMDebttBX7K9cSi/CRgVoFq8OJKd5OyDHSUV3AI6WsBVJUee6nrCuOZJRunzqQYY
         q/uKfYPIB2u70Fy9iVAmxKi3xz6trJ8SzYuAdQDFOr3lgp2c9+yAspLkf+RWqhiDlbES
         cyg1UHDBH9ShOXRC7Fi3R1MRQ0v7ccwWD8dr5EW/KWlRjhF1fvEzn5JNJ/J1oaTkKeh0
         QbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694758931; x=1695363731;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2RccZgHor3QZym6ylEU6M76/5lXyfHljjADUUYosgcI=;
        b=YRvJwu0X0oVDP66qXE5GuvPDcer8lMZqg0Re89yANlHBcxmckydVJfkZTA5ZIX15t6
         Qi8fRwdpoE1nOEHSbTveChXKF4tkL/soXkmWWwcgWbWXs8D5tkADIu9004jdAlkLWr2c
         ur3pnZ/xH4bip4sIady0f4uQbhu9sua6v4Q0Vdx1qb1xa08shmuTpKgSShcmNyNWLa/q
         cHoVouHxT9H6/YV5dfJqrIn1LsPSivVK/56Qp0sQQvtedxuG8QyfjrqT/Qa03DCxRkCA
         Lf9Ju4TPxhL+Uh2Xjf9FUBruGvP+F6WEP+9YtSbnix1U38ihpigKieZ8x4SKi2rJbSW1
         7qfg==
X-Gm-Message-State: AOJu0Yxy8AXJYtCpwSS9btsfrIBYoySOYmulMcDTAIXAu3i32B/zW9eI
        gJCQQq1j8voSHs5r9jl1Jap1klkLj/IMisNeeKi0WPNHKEE=
X-Google-Smtp-Source: AGHT+IEckzRSQIR1DR3VSVC+k2EagreCuK0ZkTOSAdZtLoiIvJMyu530j06nhuNLTXt3DmAkjnyBBQIS5ci9xbobsDU=
X-Received: by 2002:ac2:58d7:0:b0:4fd:cbd6:d2ff with SMTP id
 u23-20020ac258d7000000b004fdcbd6d2ffmr563386lfo.33.1694758931070; Thu, 14 Sep
 2023 23:22:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Sep 2023 01:21:59 -0500
Message-ID: <CAH2r5mvqOh3DEFjORWki3zROfq9Z04-MDKqmTvsafref6SwW6A@mail.gmail.com>
Subject: [PATCH][SMB3] minor cleanup fix
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001149ff06055fd0b1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001149ff06055fd0b1
Content-Type: text/plain; charset="UTF-8"

checkpatch flagged a few places with:
     WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
Also fixed minor typo

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/inode.c   | 2 +-
 fs/smb/client/smb2ops.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index de2dfbaae821..d7c302442c1e 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2680,7 +2680,7 @@ int cifs_fiemap(struct inode *inode, struct
fiemap_extent_info *fei, u64 start,
  }

  cifsFileInfo_put(cfile);
- return -ENOTSUPP;
+ return -EOPNOTSUPP;
 }

 int cifs_truncate_page(struct address_space *mapping, loff_t from)
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d9eda2e958b4..9aeecee6b91b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -297,7 +297,7 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
  cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
  credits->value, new_val);

- return -ENOTSUPP;
+ return -EOPNOTSUPP;
  }

  spin_lock(&server->req_lock);
@@ -1161,7 +1161,7 @@ smb2_set_ea(const unsigned int xid, struct
cifs_tcon *tcon,
  /* Use a fudge factor of 256 bytes in case we collide
  * with a different set_EAs command.
  */
- if(CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
+ if (CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
     MAX_SMB2_CLOSE_RESPONSE_SIZE - 256 <
     used_len + ea_name_len + ea_value_len + 1) {
  rc = -ENOSPC;
@@ -4591,7 +4591,7 @@ handle_read_data(struct TCP_Server_Info *server,
struct mid_q_entry *mid,

  if (shdr->Command != SMB2_READ) {
  cifs_server_dbg(VFS, "only big read responses are supported\n");
- return -ENOTSUPP;
+ return -EOPNOTSUPP;
  }

  if (server->ops->is_session_expired &&

-- 
Thanks,

Steve

--0000000000001149ff06055fd0b1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-correct-places-where-ENOTSUPP-is-used-instead-o.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-correct-places-where-ENOTSUPP-is-used-instead-o.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lmk7ol450>
X-Attachment-Id: f_lmk7ol450

RnJvbSBlYmMzZDRlNDRhN2UwNTQ1NzgyNWUwM2QwNTYwMTUzNjg3MjY1NTIzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMTUgU2VwIDIwMjMgMDE6MTA6NDAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBjb3JyZWN0IHBsYWNlcyB3aGVyZSBFTk9UU1VQUCBpcyB1c2VkIGluc3RlYWQgb2YKIHBy
ZWZlcnJlZCBFT1BOT1RTVVBQCgpjaGVja3BhdGNoIGZsYWdnZWQgYSBmZXcgcGxhY2VzIHdpdGg6
CiAgICAgV0FSTklORzogRU5PVFNVUFAgaXMgbm90IGEgU1VTVjQgZXJyb3IgY29kZSwgcHJlZmVy
IEVPUE5PVFNVUFAKQWxzbyBmaXhlZCBtaW5vciB0eXBvCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBG
cmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9pbm9kZS5j
ICAgfCAyICstCiBmcy9zbWIvY2xpZW50L3NtYjJvcHMuYyB8IDYgKysrLS0tCiAyIGZpbGVzIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L2lub2RlLmMgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMKaW5kZXggZGUyZGZiYWFl
ODIxLi5kN2MzMDI0NDJjMWUgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvaW5vZGUuYworKysg
Yi9mcy9zbWIvY2xpZW50L2lub2RlLmMKQEAgLTI2ODAsNyArMjY4MCw3IEBAIGludCBjaWZzX2Zp
ZW1hcChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmllbWFwX2V4dGVudF9pbmZvICpmZWks
IHU2NCBzdGFydCwKIAl9CiAKIAljaWZzRmlsZUluZm9fcHV0KGNmaWxlKTsKLQlyZXR1cm4gLUVO
T1RTVVBQOworCXJldHVybiAtRU9QTk9UU1VQUDsKIH0KIAogaW50IGNpZnNfdHJ1bmNhdGVfcGFn
ZShzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywgbG9mZl90IGZyb20pCmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4
IGQ5ZWRhMmU5NThiNC4uOWFlZWNlZTZiOTFiIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3Nt
YjJvcHMuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwpAQCAtMjk3LDcgKzI5Nyw3IEBA
IHNtYjJfYWRqdXN0X2NyZWRpdHMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQlj
aWZzX3NlcnZlcl9kYmcoVkZTLCAicmVxdWVzdCBoYXMgbGVzcyBjcmVkaXRzICglZCkgdGhhbiBy
ZXF1aXJlZCAoJWQpIiwKIAkJCQljcmVkaXRzLT52YWx1ZSwgbmV3X3ZhbCk7CiAKLQkJcmV0dXJu
IC1FTk9UU1VQUDsKKwkJcmV0dXJuIC1FT1BOT1RTVVBQOwogCX0KIAogCXNwaW5fbG9jaygmc2Vy
dmVyLT5yZXFfbG9jayk7CkBAIC0xMTYxLDcgKzExNjEsNyBAQCBzbWIyX3NldF9lYShjb25zdCB1
bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJLyogVXNlIGEgZnVk
Z2UgZmFjdG9yIG9mIDI1NiBieXRlcyBpbiBjYXNlIHdlIGNvbGxpZGUKIAkJCSAqIHdpdGggYSBk
aWZmZXJlbnQgc2V0X0VBcyBjb21tYW5kLgogCQkJICovCi0JCQlpZihDSUZTTWF4QnVmU2l6ZSAt
IE1BWF9TTUIyX0NSRUFURV9SRVNQT05TRV9TSVpFIC0KKwkJCWlmIChDSUZTTWF4QnVmU2l6ZSAt
IE1BWF9TTUIyX0NSRUFURV9SRVNQT05TRV9TSVpFIC0KIAkJCSAgIE1BWF9TTUIyX0NMT1NFX1JF
U1BPTlNFX1NJWkUgLSAyNTYgPAogCQkJICAgdXNlZF9sZW4gKyBlYV9uYW1lX2xlbiArIGVhX3Zh
bHVlX2xlbiArIDEpIHsKIAkJCQlyYyA9IC1FTk9TUEM7CkBAIC00NTkxLDcgKzQ1OTEsNyBAQCBo
YW5kbGVfcmVhZF9kYXRhKHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgc3RydWN0IG1p
ZF9xX2VudHJ5ICptaWQsCiAKIAlpZiAoc2hkci0+Q29tbWFuZCAhPSBTTUIyX1JFQUQpIHsKIAkJ
Y2lmc19zZXJ2ZXJfZGJnKFZGUywgIm9ubHkgYmlnIHJlYWQgcmVzcG9uc2VzIGFyZSBzdXBwb3J0
ZWRcbiIpOwotCQlyZXR1cm4gLUVOT1RTVVBQOworCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAJfQog
CiAJaWYgKHNlcnZlci0+b3BzLT5pc19zZXNzaW9uX2V4cGlyZWQgJiYKLS0gCjIuMzkuMgoK
--0000000000001149ff06055fd0b1--
