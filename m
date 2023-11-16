Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EvjxfPrW"
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0D3B8
	for <linux-cifs@vger.kernel.org>; Thu, 16 Nov 2023 11:09:22 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-50a6ff9881fso1734966e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Nov 2023 11:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700161760; x=1700766560; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Dn04mRqD381J0knM3vu5fALJ+ePstcD8oihEcanhTwM=;
        b=EvjxfPrWJvebZ1SgNDgkY20512h6G4L3cW/5WT6VsSq4D9Jgj4VA4h820vk8k67cTY
         1j4u/XmCFym5WOYOxRpU97YCdZ61wirKAzDydb6nn7x5I+wHSz+QEmIlY6kzdLHp3may
         jzyyv5vjiq3LHeYDI1cPvbe7WUkAt46OuZR5lJism7/qYQbuT48GRSR6aILE50ptkcPa
         Blmo0VNY6ga0W+hYkuoFrqf9IfyhWN1eOjK8b6d7Q/qL1mCZXhwYRgNBidRVuuOS527t
         nZvRmM2Kro5pffbPnaNA/rQ+QPpnEzs4NrA84vnYD95k3KMJZi3K3LZFc7BUIyXHRkEA
         9VQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700161760; x=1700766560;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dn04mRqD381J0knM3vu5fALJ+ePstcD8oihEcanhTwM=;
        b=HYp/qRP7q1q0TiXkcwYzXZTzvnp14PFIEcRv8u0+gdYtYV/9cy6mFpg25xw/s+I/SX
         bsvdtHNdaZeAaY8/4aoSMjrMXYQmQ4DREdItrYQ0tJzs69mVl9hGzb3nUUnQadGJlLrt
         Etgkt3TaBSx05En/S5i8DuS/wnCRfFDe8nKvdm6NX+SHmsu5NYq6jEobcmY5yrD7V7ST
         G65qzXLyMglMlnifejoLIxqCzzpqdnJNWF3hYK74TkrixP8nIzW6x0txBaHJl9SO9Bsd
         xhXgLI5ZjSPHZnLXsIG3NhcpGEPoVS+UgoUnjkNGBm7ATdEraA7CUdj54uzwrrFCmwjI
         2Svw==
X-Gm-Message-State: AOJu0YwAUVmvqshf1LgmXRXO+H/p5QIbB+oxayEu8MhMT3RDlSVViHHh
	cLeod/K49nC3ZuojpNETHXK3gRXvRZ5R2QP6enITrlmTeShqkw==
X-Google-Smtp-Source: AGHT+IF1F+EubZIXeGExd5+TESvIhpKbU4PqgysTlfOId+BT+ooMNX3ywZHQS4ThhqWc1R1JaQsKEuzn1Zy++AhioaI=
X-Received: by 2002:a05:6512:398a:b0:509:145c:6a49 with SMTP id
 j10-20020a056512398a00b00509145c6a49mr16599331lfu.42.1700161760232; Thu, 16
 Nov 2023 11:09:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Nov 2023 13:09:09 -0600
Message-ID: <CAH2r5mvJ9=b=HCKPbi937SP-a0EhY1f5XcQHXPfXCD6TZq70BQ@mail.gmail.com>
Subject: [PATCH][SMB client] two multichannel patches
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c7aa00060a49c1ea"

--000000000000c7aa00060a49c1ea
Content-Type: multipart/alternative; boundary="000000000000c7a9fd060a49c1e8"

--000000000000c7a9fd060a49c1e8
Content-Type: text/plain; charset="UTF-8"

Any thoughts on these two multichannel patches from Shyam (attached)?

The first fixes: "cifs: account for primary channel in the interface list"
which fixes a refcounting issue in channel deallocation.  The second fixes
a lock ordering problem in the recent patch: "cifs: handle when server
stops supporting multichannel"

The code to handle the case of server disabling multichannel
was picking iface_lock with chan_lock held. This goes against
the lock ordering rules, as iface_lock is a higher order lock
(even if it isn't so obvious).

This change fixes the lock ordering by doing the following in
that order for each secondary channel:
1. store iface and server pointers in local variable
2. remove references to iface and server in channels
3. unlock chan_lock
4. lock iface_lock
5. dec ref count for iface
6. unlock iface_lock
7. dec ref count for server
8. lock chan_lock again

Let me know if any test feedback or reviews
-- 
Thanks,

Steve

--000000000000c7a9fd060a49c1e8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Any thoughts on these two multichannel patches from Shyam =
(attached)?<br clear=3D"all"><div><br></div><div>The first fixes: &quot;cif=
s: account for primary channel in the interface list&quot; which fixes a re=
fcounting issue in channel deallocation.=C2=A0 The second fixes a lock orde=
ring problem in the recent patch:=C2=A0&quot;cifs: handle when server stops=
 supporting multichannel&quot;</div><div><br></div><div>The code to handle =
the case of server disabling multichannel<br>was picking iface_lock with ch=
an_lock held. This goes against<br>the lock ordering rules, as iface_lock i=
s a higher order lock<br>(even if it isn&#39;t so obvious).<br><br>This cha=
nge fixes the lock ordering by doing the following in<br>that order for eac=
h secondary channel:<br>1. store iface and server pointers in local variabl=
e<br>2. remove references to iface and server in channels<br>3. unlock chan=
_lock<br>4. lock iface_lock<br>5. dec ref count for iface<br>6. unlock ifac=
e_lock<br>7. dec ref count for server<br>8. lock chan_lock again<br></div><=
div><br></div><div>Let me know if any test feedback or reviews</div><span c=
lass=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gma=
il_signature" data-smartmail=3D"gmail_signature">Thanks,<br><br>Steve</div>=
</div>

--000000000000c7a9fd060a49c1e8--
--000000000000c7aa00060a49c1ea
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-leak-of-iface-for-primary-channel.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-leak-of-iface-for-primary-channel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lp1kbwn30>
X-Attachment-Id: f_lp1kbwn30

RnJvbSAyOTk1NGQ1YjFlMGQ2N2E0Y2Q2MWMzMGMyMjAxMDMwYzk3ZTk0YjFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUdWUsIDE0IE5vdiAyMDIzIDA0OjU0OjEyICswMDAwClN1YmplY3Q6IFtQQVRDSCAx
LzJdIGNpZnM6IGZpeCBsZWFrIG9mIGlmYWNlIGZvciBwcmltYXJ5IGNoYW5uZWwKCk15IGxhc3Qg
Y2hhbmdlIGluIHRoaXMgYXJlYSBpbnRyb2R1Y2VkIGEgY2hhbmdlIHdoaWNoCmFjY291bnRlZCBm
b3IgcHJpbWFyeSBjaGFubmVsIGluIHRoZSBpbnRlcmZhY2UgcmVmIGNvdW50LgpIb3dldmVyLCBp
dCBkaWQgbm90IHJlZHVjZSB0aGlzIHJlZiBjb3VudCBvbiBkZWFsbG9jYXRpb24Kb2YgdGhlIHBy
aW1hcnkgY2hhbm5lbC4gaS5lLiBkdXJpbmcgdW1vdW50LgoKRml4aW5nIHRoaXMgbGVhayBoZXJl
LCBieSBkcm9wcGluZyB0aGlzIHJlZiBjb3VudCBmb3IKcHJpbWFyeSBjaGFubmVsIHdoaWxlIGZy
ZWVpbmcgdXAgdGhlIHNlc3Npb24uCgpGaXhlczogZmExZDA1MDhiZGQ0ICgiY2lmczogYWNjb3Vu
dCBmb3IgcHJpbWFyeSBjaGFubmVsIGluIHRoZSBpbnRlcmZhY2UgbGlzdCIpCkNjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnClJlcG9ydGVkLWJ5OiBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJp
dC5jb20+ClNpZ25lZC1vZmYtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5j
b20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyB8IDYgKysrKysrCiAxIGZpbGUgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMgYi9m
cy9zbWIvY2xpZW50L2Nvbm5lY3QuYwppbmRleCA1N2MyYTdkZjM0NTcuLmY4OTZmNjBjOTI0YiAx
MDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKKysrIGIvZnMvc21iL2NsaWVudC9j
b25uZWN0LmMKQEAgLTIwNjUsNiArMjA2NSwxMiBAQCB2b2lkIF9fY2lmc19wdXRfc21iX3Nlcyhz
dHJ1Y3QgY2lmc19zZXMgKnNlcykKIAkJc2VzLT5jaGFuc1tpXS5zZXJ2ZXIgPSBOVUxMOwogCX0K
IAorCS8qIHdlIG5vdyBhY2NvdW50IGZvciBwcmltYXJ5IGNoYW5uZWwgaW4gaWZhY2UtPnJlZmNv
dW50ICovCisJaWYgKHNlcy0+Y2hhbnNbMF0uaWZhY2UpIHsKKwkJa3JlZl9wdXQoJnNlcy0+Y2hh
bnNbMF0uaWZhY2UtPnJlZmNvdW50LCByZWxlYXNlX2lmYWNlKTsKKwkJc2VzLT5jaGFuc1swXS5z
ZXJ2ZXIgPSBOVUxMOworCX0KKwogCXNlc0luZm9GcmVlKHNlcyk7CiAJY2lmc19wdXRfdGNwX3Nl
c3Npb24oc2VydmVyLCAwKTsKIH0KLS0gCjIuMzkuMgoK
--000000000000c7aa00060a49c1ea
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-cifs-fix-lock-ordering-while-disabling-multichannel.patch"
Content-Disposition: attachment; 
	filename="0002-cifs-fix-lock-ordering-while-disabling-multichannel.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lp1kc5bv1>
X-Attachment-Id: f_lp1kc5bv1

RnJvbSA1ZWVmMTJjNGUzMjMwZjIwMjVkYzQ2YWQ4YzRhM2JjMTk5NzhlNWQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBUdWUsIDE0IE5vdiAyMDIzIDA0OjU4OjIzICswMDAwClN1YmplY3Q6IFtQQVRDSCAy
LzJdIGNpZnM6IGZpeCBsb2NrIG9yZGVyaW5nIHdoaWxlIGRpc2FibGluZyBtdWx0aWNoYW5uZWwK
ClRoZSBjb2RlIHRvIGhhbmRsZSB0aGUgY2FzZSBvZiBzZXJ2ZXIgZGlzYWJsaW5nIG11bHRpY2hh
bm5lbAp3YXMgcGlja2luZyBpZmFjZV9sb2NrIHdpdGggY2hhbl9sb2NrIGhlbGQuIFRoaXMgZ29l
cyBhZ2FpbnN0CnRoZSBsb2NrIG9yZGVyaW5nIHJ1bGVzLCBhcyBpZmFjZV9sb2NrIGlzIGEgaGln
aGVyIG9yZGVyIGxvY2sKKGV2ZW4gaWYgaXQgaXNuJ3Qgc28gb2J2aW91cykuCgpUaGlzIGNoYW5n
ZSBmaXhlcyB0aGUgbG9jayBvcmRlcmluZyBieSBkb2luZyB0aGUgZm9sbG93aW5nIGluCnRoYXQg
b3JkZXIgZm9yIGVhY2ggc2Vjb25kYXJ5IGNoYW5uZWw6CjEuIHN0b3JlIGlmYWNlIGFuZCBzZXJ2
ZXIgcG9pbnRlcnMgaW4gbG9jYWwgdmFyaWFibGUKMi4gcmVtb3ZlIHJlZmVyZW5jZXMgdG8gaWZh
Y2UgYW5kIHNlcnZlciBpbiBjaGFubmVscwozLiB1bmxvY2sgY2hhbl9sb2NrCjQuIGxvY2sgaWZh
Y2VfbG9jawo1LiBkZWMgcmVmIGNvdW50IGZvciBpZmFjZQo2LiB1bmxvY2sgaWZhY2VfbG9jawo3
LiBkZWMgcmVmIGNvdW50IGZvciBzZXJ2ZXIKOC4gbG9jayBjaGFuX2xvY2sgYWdhaW4KClNpbmNl
IHRoaXMgZnVuY3Rpb24gY2FuIG9ubHkgYmUgY2FsbGVkIGluIHNtYjJfcmVjb25uZWN0LCBhbmQK
dGhhdCBjYW5ub3QgYmUgY2FsbGVkIGJ5IHR3byBwYXJhbGxlbCBwcm9jZXNzZXMsIHdlIHNob3Vs
ZCBub3QKaGF2ZSByYWNlcyBkdWUgdG8gZHJvcHBpbmcgY2hhbl9sb2NrIGJldHdlZW4gc3RlcHMg
MyBhbmQgOC4KCkZpeGVzOiBlZTFkMjE3OTRlNTUgKCJjaWZzOiBoYW5kbGUgd2hlbiBzZXJ2ZXIg
c3RvcHMgc3VwcG9ydGluZyBtdWx0aWNoYW5uZWwiKQpSZXBvcnRlZC1ieTogUGF1bG8gQWxjYW50
YXJhIDxwY0BtYW5ndWViaXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3By
YXNhZEBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zZXNzLmMgfCAyMiArKysrKysrKysr
KysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3Nlc3MuYyBiL2ZzL3NtYi9jbGllbnQv
c2Vzcy5jCmluZGV4IDBiYjJhYzkyOTA2MS4uOGIyZDdjMWNhNDI4IDEwMDY0NAotLS0gYS9mcy9z
bWIvY2xpZW50L3Nlc3MuYworKysgYi9mcy9zbWIvY2xpZW50L3Nlc3MuYwpAQCAtMzIyLDI4ICsz
MjIsMzIgQEAgY2lmc19kaXNhYmxlX3NlY29uZGFyeV9jaGFubmVscyhzdHJ1Y3QgY2lmc19zZXMg
KnNlcykKIAkJaWZhY2UgPSBzZXMtPmNoYW5zW2ldLmlmYWNlOwogCQlzZXJ2ZXIgPSBzZXMtPmNo
YW5zW2ldLnNlcnZlcjsKIAorCQkvKgorCQkgKiByZW1vdmUgdGhlc2UgcmVmZXJlbmNlcyBmaXJz
dCwgc2luY2Ugd2UgbmVlZCB0byB1bmxvY2sKKwkJICogdGhlIGNoYW5fbG9jayBoZXJlLCBzaW5j
ZSBpZmFjZV9sb2NrIGlzIGEgaGlnaGVyIGxvY2sKKwkJICovCisJCXNlcy0+Y2hhbnNbaV0uaWZh
Y2UgPSBOVUxMOworCQlzZXMtPmNoYW5zW2ldLnNlcnZlciA9IE5VTEw7CisJCXNwaW5fdW5sb2Nr
KCZzZXMtPmNoYW5fbG9jayk7CisKIAkJaWYgKGlmYWNlKSB7CiAJCQlzcGluX2xvY2soJnNlcy0+
aWZhY2VfbG9jayk7CiAJCQlrcmVmX3B1dCgmaWZhY2UtPnJlZmNvdW50LCByZWxlYXNlX2lmYWNl
KTsKLQkJCXNlcy0+Y2hhbnNbaV0uaWZhY2UgPSBOVUxMOwogCQkJaWZhY2UtPm51bV9jaGFubmVs
cy0tOwogCQkJaWYgKGlmYWNlLT53ZWlnaHRfZnVsZmlsbGVkKQogCQkJCWlmYWNlLT53ZWlnaHRf
ZnVsZmlsbGVkLS07CiAJCQlzcGluX3VubG9jaygmc2VzLT5pZmFjZV9sb2NrKTsKIAkJfQogCi0J
CXNwaW5fdW5sb2NrKCZzZXMtPmNoYW5fbG9jayk7Ci0JCWlmIChzZXJ2ZXIgJiYgIXNlcnZlci0+
dGVybWluYXRlKSB7Ci0JCQlzZXJ2ZXItPnRlcm1pbmF0ZSA9IHRydWU7Ci0JCQljaWZzX3NpZ25h
bF9jaWZzZF9mb3JfcmVjb25uZWN0KHNlcnZlciwgZmFsc2UpOwotCQl9Ci0JCXNwaW5fbG9jaygm
c2VzLT5jaGFuX2xvY2spOwotCiAJCWlmIChzZXJ2ZXIpIHsKLQkJCXNlcy0+Y2hhbnNbaV0uc2Vy
dmVyID0gTlVMTDsKKwkJCWlmICghc2VydmVyLT50ZXJtaW5hdGUpIHsKKwkJCQlzZXJ2ZXItPnRl
cm1pbmF0ZSA9IHRydWU7CisJCQkJY2lmc19zaWduYWxfY2lmc2RfZm9yX3JlY29ubmVjdChzZXJ2
ZXIsIGZhbHNlKTsKKwkJCX0KIAkJCWNpZnNfcHV0X3RjcF9zZXNzaW9uKHNlcnZlciwgZmFsc2Up
OwogCQl9CiAKKwkJc3Bpbl9sb2NrKCZzZXMtPmNoYW5fbG9jayk7CiAJfQogCiBkb25lOgotLSAK
Mi4zOS4yCgo=
--000000000000c7aa00060a49c1ea--
