Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048D21FF23
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758158929; cv=none; b=lKSg6+tDwJv+wbzGQ13YnJofUL3zqnoQKozW6+SocZDL47oPLpM79xBAHt9FfF0KycCKYeRmb14ztwUGfO0psG2MpxPhp8xM0IXH6MfED+4SLZhA1jzVKo3ODWLplU8W8A+//Hcog1Giq43DgwHg5nNculifYOHQALYK7X/SEpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758158929; c=relaxed/simple;
	bh=jB+qmjpT53K51eSL1PoqDgc4iycbtN8ZQKtrOEKRGuo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Pi2rKjEvrxZcc7xHJcEy9sBwN8nKHtDki5Lw1AtjSw3kUF94A9kW3VT4huEIaeExNt+k8V/D0diThIPGRt1n+4qh8OOMpxI2DtcNfGT1rvJyHor+9rf5AqIIeXfCKOy86en4+j3kGCeGTqeGP5973Wyyg6omgYulyL87Fa8MgcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZEOSC+On; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZEOSC+On"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-78f58f4230cso3869796d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 18:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758158926; x=1758763726; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3o4VFJB9vPlPey68pQktkJ25uNF6M12RpJcksiFpddU=;
        b=ZEOSC+OnE4DTXKcPBUWSHVtrdzxXD2qflZ7ouBpSMJi7tFtFmphz3TsRUtOgvFNjdg
         wKpfR/vjTeG1qd57+INYxjRWr3o+/cU+/zDg+OIvYsLW91o0QaT68xLkiudrkPXU22Z4
         iSRjyCOILjfxMSHqsS13udsfXLeWCLs/gHZcyB6r9Z+lr25DZPDBNjoWng22lbitDzTG
         8+SMAnmWfu4ZQdVi5UoLNZQnLyMmtd7h7sEKHifqlyrpOcqPmfYxBNhk6m3xf22Wgxvw
         1KZL/s0Y5uj7+fc8HIt7L0LWuhvmPt+zX20494CRtTLoDx5HRcuFLPO7zfl2MJaDLWIW
         LUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758158926; x=1758763726;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3o4VFJB9vPlPey68pQktkJ25uNF6M12RpJcksiFpddU=;
        b=FAF0RLZxA5P+QisyVLV32ceZor36dyHHoeiAY3v1uBj0hngUEBNCHzfrtcsyyVfK78
         2HSFjDYo+CDPYv+6lta9FTjMq6CHjukfVhxKiY2Sbl8cZpFd1jHVWhCr7Dk6bbhGJDHk
         NcXPKPmkzSHS2Tg7iZRuzrHyEZ6c+3LQH6IWaB6UCpaPO4A8CcGgl0ge/YrfOR66OgLv
         uREdpCo+xEjmtwAy5fg4CCKkkt1jmzn8UzR7M3Pz7SpTEZMnufV3rWpaOaG68GOqTJkf
         sr+oBXsYDgaDpflvFQcQ635Jt9Hc/375D7ru9JofjKY2uSeEowsEWOfLkIJWyIU1P+cm
         OzEg==
X-Gm-Message-State: AOJu0YxPs4znhctLJMuS2eHyHWtH8KbE+pwSJKJZxZv9QENJe+JWBEGc
	GckIu/favCcQAl3XLUPsIs7mSkQDborRHtdS1kfK6E06wM1Vz/SzJ+825Q0W+Y5zZCUqnmo6VYu
	c8XFIsZtiLLziFSYP1Lemoba+hAk422QF6TtG
X-Gm-Gg: ASbGnctW0GdNcikjwY4LTXCKaH+/kFTchsR0lH6ruPEr8hBeYQvhcJPcxwPn6U1jq8/
	JV04hZWqvntpyjyR60audSSVH3SUcdo3PK7YTlSfUgZDG6D/S0oeyErR9Yj8QJnGV20C8BSGU2F
	eMqA152GnT+OzPHNasWNSse/xZCjo/kB/WXxcVbZKYV7QJb6mzE18CVlFZ4HRHvPgfhTEz7gDCg
	C7lmKzUhzuq8nM9YMn7SdPAdbmRyip6LPna9hmtci/GqdCUbpKwkl3Vat0w7mExuyZoh1oKI8Dz
	tWb4iOWKzYf4hjkRO2trzkmbkQnxaY0BMQaaF87Rk9HwTVs=
X-Google-Smtp-Source: AGHT+IERiwrQHzslqPEPZD7KcCPakuYNFkkpIBsBlAtDs1d4b0xNz7pRqNNcyDhbm/nTa596omGHN5CGxtJFPOyXr3Q=
X-Received: by 2002:ad4:574e:0:b0:78e:274b:302f with SMTP id
 6a1803df08f44-78ece93f9d5mr47192476d6.51.1758158926410; Wed, 17 Sep 2025
 18:28:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 17 Sep 2025 20:28:34 -0500
X-Gm-Features: AS18NWB9IbIbhNEgNMfNo6APBadhgamGcFK4RytqcGfNuWahHrehVQ38iBTrfg8
Message-ID: <CAH2r5mvOJStj3JrZ3GWcmxw04j2oSLqxNq-DFX=mqihjh4iE+w@mail.gmail.com>
Subject: [PATCH v2] smb: client: let recv_done verify data length and remaining_data_length
To: CIFS <linux-cifs@vger.kernel.org>, 
	"Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: multipart/mixed; boundary="000000000000449814063f0946a3"

--000000000000449814063f0946a3
Content-Type: text/plain; charset="UTF-8"

Minor update to Metze's patch in for-next

from:
     wc->byte_len < (u64)data_offset + data_length)
     (u64)wc->byte_len < (u64)data_offset + data_length)

See attached:


-- 
Thanks,

Steve

--000000000000449814063f0946a3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-client-let-recv_done-verify-data_offset-data_len.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-let-recv_done-verify-data_offset-data_len.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mfoqf2ky0>
X-Attachment-Id: f_mfoqf2ky0

RnJvbSBiNTk0ZmE5MWY2ODMxNWFkODQ0YzNlNDZkZTIxY2FmMmEyNTI1OGIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgpE
YXRlOiBXZWQsIDEwIFNlcCAyMDI1IDExOjQ5OjA1ICswMjAwClN1YmplY3Q6IFtQQVRDSCAxLzhd
IHNtYjogY2xpZW50OiBsZXQgcmVjdl9kb25lIHZlcmlmeSBkYXRhX29mZnNldCwKIGRhdGFfbGVu
Z3RoIGFuZCByZW1haW5pbmdfZGF0YV9sZW5ndGgKClRoaXMgaXMgaW5zcGlyZWQgYnkgdGhlIHJl
bGF0ZWQgc2VydmVyIGZpeGVzLgoKQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPgpDYzog
TG9uZyBMaSA8bG9uZ2xpQG1pY3Jvc29mdC5jb20+CkNjOiBsaW51eC1jaWZzQHZnZXIua2VybmVs
Lm9yZwpDYzogc2FtYmEtdGVjaG5pY2FsQGxpc3RzLnNhbWJhLm9yZwpSZXZpZXdlZC1ieTogTmFt
amFlIEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4KRml4ZXM6IGYxOTgxODZhYTliYiAoIkNJ
RlM6IFNNQkQ6IEVzdGFibGlzaCBTTUIgRGlyZWN0IGNvbm5lY3Rpb24iKQpTaWduZWQtb2ZmLWJ5
OiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9zbWJk
aXJlY3QuYyB8IDIwICsrKysrKysrKysrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgMTkgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21i
ZGlyZWN0LmMgYi9mcy9zbWIvY2xpZW50L3NtYmRpcmVjdC5jCmluZGV4IDAyZDZkYjQzMWZkNC4u
ZTZkNTZlNTQ3YTE3IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYmRpcmVjdC5jCisrKyBi
L2ZzL3NtYi9jbGllbnQvc21iZGlyZWN0LmMKQEAgLTQ1Myw5ICs0NTMsMTIgQEAgc3RhdGljIHZv
aWQgcmVjdl9kb25lKHN0cnVjdCBpYl9jcSAqY3EsIHN0cnVjdCBpYl93YyAqd2MpCiAJc3RydWN0
IHNtYmRpcmVjdF9yZWN2X2lvICpyZXNwb25zZSA9CiAJCWNvbnRhaW5lcl9vZih3Yy0+d3JfY3Fl
LCBzdHJ1Y3Qgc21iZGlyZWN0X3JlY3ZfaW8sIGNxZSk7CiAJc3RydWN0IHNtYmRpcmVjdF9zb2Nr
ZXQgKnNjID0gcmVzcG9uc2UtPnNvY2tldDsKKwlzdHJ1Y3Qgc21iZGlyZWN0X3NvY2tldF9wYXJh
bWV0ZXJzICpzcCA9ICZzYy0+cGFyYW1ldGVyczsKIAlzdHJ1Y3Qgc21iZF9jb25uZWN0aW9uICpp
bmZvID0KIAkJY29udGFpbmVyX29mKHNjLCBzdHJ1Y3Qgc21iZF9jb25uZWN0aW9uLCBzb2NrZXQp
OwotCWludCBkYXRhX2xlbmd0aCA9IDA7CisJdTMyIGRhdGFfb2Zmc2V0ID0gMDsKKwl1MzIgZGF0
YV9sZW5ndGggPSAwOworCXUzMiByZW1haW5pbmdfZGF0YV9sZW5ndGggPSAwOwogCiAJbG9nX3Jk
bWFfcmVjdihJTkZPLCAicmVzcG9uc2U9MHglcCB0eXBlPSVkIHdjIHN0YXR1cz0lZCB3YyBvcGNv
ZGUgJWQgYnl0ZV9sZW49JWQgcGtleV9pbmRleD0ldVxuIiwKIAkJICAgICAgcmVzcG9uc2UsIHNj
LT5yZWN2X2lvLmV4cGVjdGVkLCB3Yy0+c3RhdHVzLCB3Yy0+b3Bjb2RlLApAQCAtNDg3LDcgKzQ5
MCwyMiBAQCBzdGF0aWMgdm9pZCByZWN2X2RvbmUoc3RydWN0IGliX2NxICpjcSwgc3RydWN0IGli
X3djICp3YykKIAkvKiBTTUJEIGRhdGEgdHJhbnNmZXIgcGFja2V0ICovCiAJY2FzZSBTTUJESVJF
Q1RfRVhQRUNUX0RBVEFfVFJBTlNGRVI6CiAJCWRhdGFfdHJhbnNmZXIgPSBzbWJkaXJlY3RfcmVj
dl9pb19wYXlsb2FkKHJlc3BvbnNlKTsKKworCQlpZiAod2MtPmJ5dGVfbGVuIDwKKwkJICAgIG9m
ZnNldG9mKHN0cnVjdCBzbWJkaXJlY3RfZGF0YV90cmFuc2ZlciwgcGFkZGluZykpCisJCQlnb3Rv
IGVycm9yOworCisJCXJlbWFpbmluZ19kYXRhX2xlbmd0aCA9IGxlMzJfdG9fY3B1KGRhdGFfdHJh
bnNmZXItPnJlbWFpbmluZ19kYXRhX2xlbmd0aCk7CisJCWRhdGFfb2Zmc2V0ID0gbGUzMl90b19j
cHUoZGF0YV90cmFuc2Zlci0+ZGF0YV9vZmZzZXQpOwogCQlkYXRhX2xlbmd0aCA9IGxlMzJfdG9f
Y3B1KGRhdGFfdHJhbnNmZXItPmRhdGFfbGVuZ3RoKTsKKwkJaWYgKHdjLT5ieXRlX2xlbiA8IGRh
dGFfb2Zmc2V0IHx8CisJCSAgICAodTY0KXdjLT5ieXRlX2xlbiA8ICh1NjQpZGF0YV9vZmZzZXQg
KyBkYXRhX2xlbmd0aCkKKwkJCWdvdG8gZXJyb3I7CisKKwkJaWYgKHJlbWFpbmluZ19kYXRhX2xl
bmd0aCA+IHNwLT5tYXhfZnJhZ21lbnRlZF9yZWN2X3NpemUgfHwKKwkJICAgIGRhdGFfbGVuZ3Ro
ID4gc3AtPm1heF9mcmFnbWVudGVkX3JlY3Zfc2l6ZSB8fAorCQkgICAgKHU2NClyZW1haW5pbmdf
ZGF0YV9sZW5ndGggKyAodTY0KWRhdGFfbGVuZ3RoID4gKHU2NClzcC0+bWF4X2ZyYWdtZW50ZWRf
cmVjdl9zaXplKQorCQkJZ290byBlcnJvcjsKIAogCQlpZiAoZGF0YV9sZW5ndGgpIHsKIAkJCWlm
IChzYy0+cmVjdl9pby5yZWFzc2VtYmx5LmZ1bGxfcGFja2V0X3JlY2VpdmVkKQotLSAKMi40OC4x
Cgo=
--000000000000449814063f0946a3--
