Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7102025569
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 22:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705530507; cv=none; b=R1S+nXiVbkRNQUB99qSqD4x0JzjxNTYDzcpxh+PXOaTDgm9Awz1Meye2eWwThhgL8yLgv0VcwJcvqYDRNcBgDkFZLRo6pRnLNlkHzYDPi1Jfd90wiaeddmohfvK91n3DGxlQZd349PvX7vcfihcwGwCJ2yDJDpADttCizSaYhe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705530507; c=relaxed/simple;
	bh=NAMc9Npooyg9jZZEHHnvXWkj8ltsHkd8vcYv7r5Fs68=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 From:Date:Message-ID:Subject:To:Cc:Content-Type; b=oBIwPTAsAEPECM+n5pFqK0hjyPrkUg+vej5jjb9CSKNdIIdGqAZzZ6CbduPp5KMA6MH63QeKJ7kpAVNnzNyl/XXYD+DFuANh7TfYzzcv+251PucttbrPgfopDFVZPkjgBCtvjQxhMucSLFubynjEdtqtyosYpGGOKiX1Q/rKBL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnRtX4AU; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnRtX4AU"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50eabd1c701so14435263e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 17 Jan 2024 14:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705530503; x=1706135303; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=84XkGLvsoppwnjCl11vVf4LSthAdwJOsUjCsA2aCCuo=;
        b=JnRtX4AU2l5hd/t9Gbep7ci1mb7coPcciGrkOSBr8mde9crw3lr1+y/zQWn8SZAlnz
         /ekWbOw5gO9TLo3O3jgAIjBaJ0bPdYuSrkyiiAeXJlnHA0SLLL0LxWdEUkYZfAtFSbXW
         3YWZ3lale4jnDAKUa28OkN2RBxKyBaN+UvWigyWXQRvVfsIC4tCfdRZDx+SlMWJZ0crV
         2LZFf+e7MsBwtTwlB0oQ+ORr315LMBxwXaC/LVpuo5wyCMFa+NY26GJU1xSlFqjLLnQe
         bx61R83swnj3VFT8vo+nC+s0gQs0SPrNwaE5H/9QA5owJHGS3F43qXL+sNlLLreMbGnc
         ZOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705530503; x=1706135303;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=84XkGLvsoppwnjCl11vVf4LSthAdwJOsUjCsA2aCCuo=;
        b=flqhst57MfFaeOIhhiqmYmzHQOndro0MY6Qn/+RkG5DM+FS3lSRoTS7bhucBb9RtcF
         8001f56/pdYU93ijC8pv7KzsizqpPz7fquKcO0fj6V6FQx0QXWHUxTWaw+kX63M6dozL
         A7H2z8Czyk/1mfnvpQT3RZPQlXlvvrkqwdyWZ1D2yuJaxV0/ivIdqV2O8cy9kPu9Ns1e
         F3HT3O18r7ZO7EkU11vzhCqdAnCdo4tQgy5VeIn13apjL2o1AVTCb9a/XG9z/zAlSEV0
         /CQjeLcfsE4tNjKTLtA4QatfsCoT6/jGjDE7FbgsIe5TMgSux1odksOQRjgXxtpKrDMa
         FSvw==
X-Gm-Message-State: AOJu0Yzn3eZMhEwTbv7PlwNmSiNRqrcUy0JmZQ4xinE36a0G/qMfFuYP
	quSWO4XgfREYya+9t1jru5n0og13oYIDNcGRxUpNHWR08USZYA==
X-Google-Smtp-Source: AGHT+IHe7584WO2xjM8XG8HJoRVvKIZLd9hxhb9ZJhjMK1Tvg7ut6/cLj1Di9DSsrG8/t5h3dzqYX3zEua7QPyfLlZU=
X-Received: by 2002:ac2:46e9:0:b0:50e:7b0d:5b66 with SMTP id
 q9-20020ac246e9000000b0050e7b0d5b66mr4561023lfo.73.1705530502845; Wed, 17 Jan
 2024 14:28:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 17 Jan 2024 16:28:11 -0600
Message-ID: <CAH2r5mu-1g33hBOjcY4S0JBuwD3VKD1goTiQKurj+9wj+XmXpg@mail.gmail.com>
Subject: [PATCH][SMB3 client] show beginning time for per share stats
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c6ac32060f2bc32e"

--000000000000c6ac32060f2bc32e
Content-Type: text/plain; charset="UTF-8"

In analyzing problems, one missing piece of debug data is when the
mount occurred.  A related problem is when collecting stats we don't
know the  period of time the stats covered, ie when this set of stats
for the tcon started to be collected.  To make debugging easier track
the stats begin time. Set it when the mount occurred at mount time,
and reset it to current time whenever stats are reset. For example,

...
1) \\localhost\test
SMBs: 14 since 2024-01-17 22:17:30 UTC
Bytes read: 0  Bytes written: 0
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
...
2) \\localhost\scratch
SMBs: 24 since 2024-01-17 22:16:04 UTC
Bytes read: 0  Bytes written: 0
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
...

Note the time "since ... UTC" is now displayed in /proc/fs/cifs/Stats
for each share that is mounted.

See attached

-- 
Thanks,

Steve

--000000000000c6ac32060f2bc32e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-show-beginning-time-for-per-share-stats.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-show-beginning-time-for-per-share-stats.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lrictcne0>
X-Attachment-Id: f_lrictcne0

RnJvbSAxMTQyYzFhOTIyZDU2ODFjZjQ0Yzg0YzY1M2RjODEwNGZiMzI5MzNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTcgSmFuIDIwMjQgMTY6MTU6MTggLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBzaG93IGJlZ2lubmluZyB0aW1lIGZvciBwZXIgc2hhcmUgc3RhdHMKCkluIGFuYWx5emlu
ZyBwcm9ibGVtcywgb25lIG1pc3NpbmcgcGllY2Ugb2YgZGVidWcgZGF0YSBpcyB3aGVuIHRoZQpt
b3VudCBvY2N1cnJlZC4gIEEgcmVsYXRlZCBwcm9ibGVtIGlzIHdoZW4gY29sbGVjdGluZyBzdGF0
cyB3ZSBkb24ndAprbm93IHRoZSAgcGVyaW9kIG9mIHRpbWUgdGhlIHN0YXRzIGNvdmVyZWQsIGll
IHdoZW4gdGhpcyBzZXQgb2Ygc3RhdHMKZm9yIHRoZSB0Y29uIHN0YXJ0ZWQgdG8gYmUgY29sbGVj
dGVkLiAgVG8gbWFrZSBkZWJ1Z2dpbmcgZWFzaWVyIHRyYWNrCnRoZSBzdGF0cyBiZWdpbiB0aW1l
LiBTZXQgaXQgd2hlbiB0aGUgbW91bnQgb2NjdXJyZWQgYXQgbW91bnQgdGltZSwKYW5kIHJlc2V0
IGl0IHRvIGN1cnJlbnQgdGltZSB3aGVuZXZlciBzdGF0cyBhcmUgcmVzZXQuIEZvciBleGFtcGxl
LAoKLi4uCjEpIFxcbG9jYWxob3N0XHRlc3QKU01CczogMTQgc2luY2UgMjAyNC0wMS0xNyAyMjox
NzozMCBVVEMKQnl0ZXMgcmVhZDogMCAgQnl0ZXMgd3JpdHRlbjogMApPcGVuIGZpbGVzOiAwIHRv
dGFsIChsb2NhbCksIDAgb3BlbiBvbiBzZXJ2ZXIKVHJlZUNvbm5lY3RzOiAxIHRvdGFsIDAgZmFp
bGVkClRyZWVEaXNjb25uZWN0czogMCB0b3RhbCAwIGZhaWxlZAouLi4KMikgXFxsb2NhbGhvc3Rc
c2NyYXRjaApTTUJzOiAyNCBzaW5jZSAyMDI0LTAxLTE3IDIyOjE2OjA0IFVUQwpCeXRlcyByZWFk
OiAwICBCeXRlcyB3cml0dGVuOiAwCk9wZW4gZmlsZXM6IDAgdG90YWwgKGxvY2FsKSwgMCBvcGVu
IG9uIHNlcnZlcgpUcmVlQ29ubmVjdHM6IDEgdG90YWwgMCBmYWlsZWQKVHJlZURpc2Nvbm5lY3Rz
OiAwIHRvdGFsIDAgZmFpbGVkCi4uLgoKTm90ZSB0aGUgdGltZSAic2luY2UgLi4uIFVUQyIgaXMg
bm93IGRpc3BsYXllZCBpbiAvcHJvYy9mcy9jaWZzL1N0YXRzCmZvciBlYWNoIHNoYXJlIHRoYXQg
aXMgbW91bnRlZC4KClN1Z2dlc3RlZC1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9z
b2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQu
Y29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIHwgNiArKysrLS0KIGZzL3NtYi9j
bGllbnQvY2lmc2dsb2IuaCAgIHwgMSArCiBmcy9zbWIvY2xpZW50L21pc2MuYyAgICAgICB8IDEg
KwogMyBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMgYi9mcy9zbWIvY2xpZW50L2NpZnNf
ZGVidWcuYwppbmRleCA2MDAyN2Y1YWViZTguLjNlNDIwOWY0MWMxOCAxMDA2NDQKLS0tIGEvZnMv
c21iL2NsaWVudC9jaWZzX2RlYnVnLmMKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMK
QEAgLTY1OSw2ICs2NTksNyBAQCBzdGF0aWMgc3NpemVfdCBjaWZzX3N0YXRzX3Byb2Nfd3JpdGUo
c3RydWN0IGZpbGUgKmZpbGUsCiAJCQkJCXNwaW5fbG9jaygmdGNvbi0+c3RhdF9sb2NrKTsKIAkJ
CQkJdGNvbi0+Ynl0ZXNfcmVhZCA9IDA7CiAJCQkJCXRjb24tPmJ5dGVzX3dyaXR0ZW4gPSAwOwor
CQkJCQl0Y29uLT5zdGF0c19mcm9tX3RpbWUgPSBrdGltZV9nZXRfcmVhbF9zZWNvbmRzKCk7CiAJ
CQkJCXNwaW5fdW5sb2NrKCZ0Y29uLT5zdGF0X2xvY2spOwogCQkJCQlpZiAoc2VydmVyLT5vcHMt
PmNsZWFyX3N0YXRzKQogCQkJCQkJc2VydmVyLT5vcHMtPmNsZWFyX3N0YXRzKHRjb24pOwpAQCAt
NzM3LDggKzczOCw5IEBAIHN0YXRpYyBpbnQgY2lmc19zdGF0c19wcm9jX3Nob3coc3RydWN0IHNl
cV9maWxlICptLCB2b2lkICp2KQogCQkJCXNlcV9wcmludGYobSwgIlxuJWQpICVzIiwgaSwgdGNv
bi0+dHJlZV9uYW1lKTsKIAkJCQlpZiAodGNvbi0+bmVlZF9yZWNvbm5lY3QpCiAJCQkJCXNlcV9w
dXRzKG0sICJcdERJU0NPTk5FQ1RFRCAiKTsKLQkJCQlzZXFfcHJpbnRmKG0sICJcblNNQnM6ICVk
IiwKLQkJCQkJICAgYXRvbWljX3JlYWQoJnRjb24tPm51bV9zbWJzX3NlbnQpKTsKKwkJCQlzZXFf
cHJpbnRmKG0sICJcblNNQnM6ICVkIHNpbmNlICVwdFRzIFVUQyIsCisJCQkJCSAgIGF0b21pY19y
ZWFkKCZ0Y29uLT5udW1fc21ic19zZW50KSwKKwkJCQkJICAgJnRjb24tPnN0YXRzX2Zyb21fdGlt
ZSk7CiAJCQkJaWYgKHNlcnZlci0+b3BzLT5wcmludF9zdGF0cykKIAkJCQkJc2VydmVyLT5vcHMt
PnByaW50X3N0YXRzKG0sIHRjb24pOwogCQkJfQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDg3OWQ1ZWY4YTY2ZS4u
ZjU3NmNlZWU2MTU3IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIv
ZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBAIC0xMjA3LDYgKzEyMDcsNyBAQCBzdHJ1Y3QgY2lm
c190Y29uIHsKIAlfX3U2NCAgICBieXRlc19yZWFkOwogCV9fdTY0ICAgIGJ5dGVzX3dyaXR0ZW47
CiAJc3BpbmxvY2tfdCBzdGF0X2xvY2s7ICAvKiBwcm90ZWN0cyB0aGUgdHdvIGZpZWxkcyBhYm92
ZSAqLworCXRpbWU2NF90IHN0YXRzX2Zyb21fdGltZTsKIAlGSUxFX1NZU1RFTV9ERVZJQ0VfSU5G
TyBmc0RldkluZm87CiAJRklMRV9TWVNURU1fQVRUUklCVVRFX0lORk8gZnNBdHRySW5mbzsgLyog
b2sgaWYgZnMgbmFtZSB0cnVuY2F0ZWQgKi8KIAlGSUxFX1NZU1RFTV9VTklYX0lORk8gZnNVbml4
SW5mbzsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvbWlzYy5jIGIvZnMvc21iL2NsaWVudC9t
aXNjLmMKaW5kZXggYzIxMzdlYTNjMjUzLi4wNzQ4ZDdiNzU3YjkgMTAwNjQ0Ci0tLSBhL2ZzL3Nt
Yi9jbGllbnQvbWlzYy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvbWlzYy5jCkBAIC0xNDAsNiArMTQw
LDcgQEAgdGNvbl9pbmZvX2FsbG9jKGJvb2wgZGlyX2xlYXNlc19lbmFibGVkKQogCXNwaW5fbG9j
a19pbml0KCZyZXRfYnVmLT5zdGF0X2xvY2spOwogCWF0b21pY19zZXQoJnJldF9idWYtPm51bV9s
b2NhbF9vcGVucywgMCk7CiAJYXRvbWljX3NldCgmcmV0X2J1Zi0+bnVtX3JlbW90ZV9vcGVucywg
MCk7CisJcmV0X2J1Zi0+c3RhdHNfZnJvbV90aW1lID0ga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygp
OwogI2lmZGVmIENPTkZJR19DSUZTX0RGU19VUENBTEwKIAlJTklUX0xJU1RfSEVBRCgmcmV0X2J1
Zi0+ZGZzX3Nlc19saXN0KTsKICNlbmRpZgotLSAKMi40MC4xCgo=
--000000000000c6ac32060f2bc32e--
