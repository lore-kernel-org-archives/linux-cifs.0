Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A605A210FE
	for <linux-cifs@vger.kernel.org>; Wed, 31 Jan 2024 22:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741017; cv=none; b=b+HhyN7gAK1kNXn5zWFP2vsuEyIJjqHrfJNvge4PsAsUGk3ycmMWVe+qHMalmPzqeqNjs+3C95PAODgeGZuw9JoWJZRO6CoNn95hcSZyUEGH2uYb0XkDYBqw3RVNVqDe9KbCBhAyjGZynY+Fvvis5lWyF67mlf4eJ/ypRTBBVHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741017; c=relaxed/simple;
	bh=fiJoFrX4gVKbkETth2esSrlFUbIXiJFxvcyZwlZcOpc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=iGltWsDZ9A1hlIU3yd31xJGi++z5wVudypX6RM8OtCxlA1M4ZnWAe+V+x4+Z575NqSN4dVmyDWcmJjavfFOYbV9+qJ2ctkwMtme4Rn++S0t9bRgX9ND9BdYcLmfqPIwvwXhxjTP/eQGFllFsDv3aOkn8XIEfmghxLVOixpduaqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KitZcBTV; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KitZcBTV"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5112d5ab492so146997e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 31 Jan 2024 14:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706741013; x=1707345813; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8awvc388LrZO6gitjm0sq2JpByAHzsbT5JbnyIhTYFk=;
        b=KitZcBTVM6Xjh8DFFWNk9t/tO2wkfgP7e61gmMFqjpylOfr/Hm66mu1xTywxjsOB3v
         GfoHp2hfCz6bHzoIeBjeRL8F6IA8z981XOPsQVxuvu022jWFtx7Y2YCfhjif6voD9OOt
         ttoEV8N/PGdbG8Gj38na35d4MJmnxPG201Z1eV1g5FaZWLsiNQAOBcEGeEx7KlwfEBAN
         aeA3BUMFxPkyxSv06LyeEILLnQnKzozP+COHeM2bRFhof8jCIScW5Ewy8kja+gh+muD1
         ufG7jdCwR8JZADUlTZ0CCmO88bDD4pWtgh9kzegWiMdbWRlJMalXVbXGA5Dk7uHo1d8r
         xhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706741013; x=1707345813;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8awvc388LrZO6gitjm0sq2JpByAHzsbT5JbnyIhTYFk=;
        b=K5cSM0SM/GjesKAfG3XAol8C+WRISrAnLxI9JJdA1MabothPiXo0Whowk0gLiz2+i/
         hllzVvRZBOmXaai6PBKyOICKcecXhMht32/RBg+g7JidHkFpTp3aokHyyzEzB863NTts
         Th7DbiamZwxKJ9ahHF0yjnflbNGwbpbu+BPIBgnI+86/sY+dq3biggthJ0g9VLe3eyXE
         NNoYTX1Pw+/ckp/NkHQGrCwi4LfG4XU3SADfjL3K07ixcej/rAlfkMJXkRRAv4zRTwUs
         Ov5OYSHnxg3u5o2ehY1lCFBPal2yD5T9uxeXUvxwAMWWOTm4+uFHpyaKghUini3sGOkG
         ingg==
X-Gm-Message-State: AOJu0YxBbgxiKmS+dgaiIZ/2XZQiZi7wPNGvrl9yKKYzUv6Ti2PMegPZ
	dPiFFW/kQGt/7ZoA27sdF4bCbjjq5F33P0U9HUGPxJbYOVqtCSMYVLaruRqOGGLZ7ibov74E+Pi
	gDSUmLqzYMnSSSCXpxyj8Q39xFcg=
X-Google-Smtp-Source: AGHT+IFSOQf07R1WhLlunXCCQ4tqRo8vA41KoA0B4OB64wtXNPGQqSnofYixmpexkFtLeUNfwBTBefEwFPRz+3uarj4=
X-Received: by 2002:ac2:5ec6:0:b0:510:694:13e6 with SMTP id
 d6-20020ac25ec6000000b00510069413e6mr342488lfq.15.1706741013228; Wed, 31 Jan
 2024 14:43:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 31 Jan 2024 16:43:21 -0600
Message-ID: <CAH2r5mvEHKkYqu6CEgk5fzY8tR+UFa-Ynh38gB9Sej4u41YjkA@mail.gmail.com>
Subject: fix for patch "cifs" make sure that channel scaling is done only once"
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Bharath S M <bharathsm@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d14fed0610459b71"

--000000000000d14fed0610459b71
Content-Type: text/plain; charset="UTF-8"

Looks like the patch in for-next "cifs: make sure that channel scaling
is done only once" (see attached) was missing some unlocks that were
noticed by compile with C=1 and/or sparse.   See below.


diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2837fc4465a7..3110aabc32c5 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -400,8 +400,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
        }

        spin_lock(&ses->ses_lock);
-       if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS)
+       if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+               spin_unlock(&ses->ses_lock);
+               mutex_unlock(&ses->session_mutex);
                goto skip_add_channels;
+       }
        ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
        spin_unlock(&ses->ses_lock);


--
Thanks,

Steve

--000000000000d14fed0610459b71
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-make-sure-that-channel-scaling-is-done-only-onc.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-make-sure-that-channel-scaling-is-done-only-onc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ls2di28n0>
X-Attachment-Id: f_ls2di28n0

RnJvbSAxNzUyNTk1MmZhODM0YTc1NzUxZjUxNzI2ZWIzY2Q2ODM5NDhiMTQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDI5IEphbiAyMDI0IDEzOjU4OjEzICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogbWFrZSBzdXJlIHRoYXQgY2hhbm5lbCBzY2FsaW5nIGlzIGRvbmUgb25seSBvbmNlCgpG
b2xsb3dpbmcgYSBzdWNjZXNzZnVsIGNpZnNfdHJlZV9jb25uZWN0LCB3ZSBoYXZlIHRoZSBjb2Rl
CnRvIHNjYWxlIHVwL2Rvd24gdGhlIG51bWJlciBvZiBjaGFubmVscyBpbiB0aGUgc2Vzc2lvbi4K
SG93ZXZlciwgaXQgaXMgbm90IHByb3RlY3RlZCBieSBhIGxvY2sgdG9kYXkuCgpBcyBhIHJlc3Vs
dCwgdGhpcyBjb2RlIGNhbiBiZSBleGVjdXRlZCBieSBzZXZlcmFsIHByb2Nlc3Nlcwp0aGF0IHNl
bGVjdCB0aGUgc2FtZSBjaGFubmVsLiBUaGUgY29yZSBmdW5jdGlvbnMgaGFuZGxlIHRoaXMKd2Vs
bCwgYXMgdGhleSBwaWNrIGNoYW5fbG9jay4gSG93ZXZlciwgd2UndmUgc2VlbiBjYXNlcyB3aGVy
ZQpzbWIyX3JlY29ubmVjdCB0aHJvd3Mgc29tZSB3YXJuaW5ncy4KClRvIGZpeCB0aGF0LCB0aGlz
IGNoYW5nZSBpbnRyb2R1Y2VzIGEgZmxhZ3MgYml0bWFwIGluc2lkZSB0aGUKY2lmc19zZXMgc3Ry
dWN0dXJlLiBBIG5ldyBmbGFnIHR5cGUgaXMgdXNlZCB0byBlbnN1cmUgdGhhdApvbmx5IG9uZSBw
cm9jZXNzIGVudGVycyB0aGlzIHNlY3Rpb24gYXQgYW55IHRpbWUuCgpTaWduZWQtb2ZmLWJ5OiBT
aHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jaWZz
Z2xvYi5oIHwgIDMgKysrCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUuYyAgfCAxNyArKysrKysrKysr
KysrKy0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCBiL2ZzL3NtYi9jbGllbnQv
Y2lmc2dsb2IuaAppbmRleCAxNmJlZmZmNGNiYjQuLjkwOTNjNTA3MDQyZiAxMDA2NDQKLS0tIGEv
ZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaApA
QCAtMTAzMiw2ICsxMDMyLDggQEAgc3RydWN0IGNpZnNfY2hhbiB7CiAJX191OCBzaWdua2V5W1NN
QjNfU0lHTl9LRVlfU0laRV07CiB9OwogCisjZGVmaW5lIENJRlNfU0VTX0ZMQUdfU0NBTEVfQ0hB
Tk5FTFMgKDB4MSkKKwogLyoKICAqIFNlc3Npb24gc3RydWN0dXJlLiAgT25lIG9mIHRoZXNlIGZv
ciBlYWNoIHVpZCBzZXNzaW9uIHdpdGggYSBwYXJ0aWN1bGFyIGhvc3QKICAqLwpAQCAtMTA2NCw2
ICsxMDY2LDcgQEAgc3RydWN0IGNpZnNfc2VzIHsKIAllbnVtIHNlY3VyaXR5RW51bSBzZWN0eXBl
OyAvKiB3aGF0IHNlY3VyaXR5IGZsYXZvciB3YXMgc3BlY2lmaWVkPyAqLwogCWJvb2wgc2lnbjsJ
CS8qIGlzIHNpZ25pbmcgcmVxdWlyZWQ/ICovCiAJYm9vbCBkb21haW5BdXRvOjE7CisJdW5zaWdu
ZWQgaW50IGZsYWdzOwogCV9fdTE2IHNlc3Npb25fZmxhZ3M7CiAJX191OCBzbWIzc2lnbmluZ2tl
eVtTTUIzX1NJR05fS0VZX1NJWkVdOwogCV9fdTggc21iM2VuY3J5cHRpb25rZXlbU01CM19FTkNf
REVDX0tFWV9TSVpFXTsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jIGIvZnMv
c21iL2NsaWVudC9zbWIycGR1LmMKaW5kZXggODZmNmYzNWI3ZjMyLi4yNzNlMjRmOWRhMTMgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21i
MnBkdS5jCkBAIC0zOTksNiArMzk5LDEyIEBAIHNtYjJfcmVjb25uZWN0KF9fbGUxNiBzbWIyX2Nv
bW1hbmQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCWdvdG8gb3V0OwogCX0KIAorCXNwaW5f
bG9jaygmc2VzLT5zZXNfbG9jayk7CisJaWYgKHNlcy0+ZmxhZ3MgJiBDSUZTX1NFU19GTEFHX1ND
QUxFX0NIQU5ORUxTKQorCQlnb3RvIHNraXBfYWRkX2NoYW5uZWxzOworCXNlcy0+ZmxhZ3MgfD0g
Q0lGU19TRVNfRkxBR19TQ0FMRV9DSEFOTkVMUzsKKwlzcGluX3VubG9jaygmc2VzLT5zZXNfbG9j
ayk7CisKIAlpZiAoIXJjICYmCiAJICAgIChzZXJ2ZXItPmNhcGFiaWxpdGllcyAmIFNNQjJfR0xP
QkFMX0NBUF9NVUxUSV9DSEFOTkVMKSkgewogCQltdXRleF91bmxvY2soJnNlcy0+c2Vzc2lvbl9t
dXRleCk7CkBAIC00MjgsMTcgKzQzNCwyMiBAQCBzbWIyX3JlY29ubmVjdChfX2xlMTYgc21iMl9j
b21tYW5kLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlpZiAoc2VzLT5jaGFuX21heCA+IHNl
cy0+Y2hhbl9jb3VudCAmJgogCQkgICAgc2VzLT5pZmFjZV9jb3VudCAmJgogCQkgICAgIVNFUlZF
Ul9JU19DSEFOKHNlcnZlcikpIHsKLQkJCWlmIChzZXMtPmNoYW5fY291bnQgPT0gMSkKKwkJCWlm
IChzZXMtPmNoYW5fY291bnQgPT0gMSkgewogCQkJCWNpZnNfc2VydmVyX2RiZyhWRlMsICJzdXBw
b3J0cyBtdWx0aWNoYW5uZWwgbm93XG4iKTsKKwkJCQlxdWV1ZV9kZWxheWVkX3dvcmsoY2lmc2lv
ZF93cSwgJnRjb24tPnF1ZXJ5X2ludGVyZmFjZXMsCisJCQkJCQkgKFNNQl9JTlRFUkZBQ0VfUE9M
TF9JTlRFUlZBTCAqIEhaKSk7CisJCQl9CiAKIAkJCWNpZnNfdHJ5X2FkZGluZ19jaGFubmVscyhz
ZXMpOwotCQkJcXVldWVfZGVsYXllZF93b3JrKGNpZnNpb2Rfd3EsICZ0Y29uLT5xdWVyeV9pbnRl
cmZhY2VzLAotCQkJCQkgICAoU01CX0lOVEVSRkFDRV9QT0xMX0lOVEVSVkFMICogSFopKTsKIAkJ
fQogCX0gZWxzZSB7CiAJCW11dGV4X3VubG9jaygmc2VzLT5zZXNzaW9uX211dGV4KTsKIAl9CisK
IHNraXBfYWRkX2NoYW5uZWxzOgorCXNwaW5fbG9jaygmc2VzLT5zZXNfbG9jayk7CisJc2VzLT5m
bGFncyAmPSB+Q0lGU19TRVNfRkxBR19TQ0FMRV9DSEFOTkVMUzsKKwlzcGluX3VubG9jaygmc2Vz
LT5zZXNfbG9jayk7CiAKIAlpZiAoc21iMl9jb21tYW5kICE9IFNNQjJfSU5URVJOQUxfQ01EKQog
CQltb2RfZGVsYXllZF93b3JrKGNpZnNpb2Rfd3EsICZzZXJ2ZXItPnJlY29ubmVjdCwgMCk7Ci0t
IAoyLjQwLjEKCg==
--000000000000d14fed0610459b71--
