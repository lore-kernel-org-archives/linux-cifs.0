Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8682773D3
	for <linux-cifs@vger.kernel.org>; Fri, 29 Aug 2025 22:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756506714; cv=none; b=W/x6i+HWXQBazm8E/txIpgqs57rf97bSwXIPonqUDWvNJzCSikqEs1rMOWhcUwDqal8Q0Fd32mL/xlVRuOi1KTtCTA4s5ZUfTfHljbA0Ugn3GqMutaHhcq92uzBOBR7FgPc2EW7Eh1j0GzHlUVoNJwiHPZKr7EXUMEzQnFsQE6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756506714; c=relaxed/simple;
	bh=pl4yWMXm05pH8qrhw+YyZZ8thRs3K1jf5W/FUNDBdFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=co0AhQmUOCpHBJPBOYlgNc0sS0YYCMTnnAc+zcs/gGTzFcUw82KZbvR/0dqCNa/aTEKBr8Iarx6l8IsNbbBb6GldoMFEMpCuDmg9PtYnmwuPPAVCvDvW7SbBo9gwHjdL0VM3Me3zb+2HWTK7zZInHyZDjuOjC/s2n+UpslIsFrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhqzOsMq; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhqzOsMq"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b30f73ca19so7205121cf.0
        for <linux-cifs@vger.kernel.org>; Fri, 29 Aug 2025 15:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756506711; x=1757111511; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D5LILI3BrETC9EOLPWKkYIiAly3h6+hVppm2fXa/NIo=;
        b=DhqzOsMq7jTa08FYpJZSBKrRlExe/s4iZjG30p82oQAA3gJnu8jKG9LoCoyFXFyWrQ
         9Ux9io9T+31Pzw8418FspAA8fcbcmqlQ9iWZia00deaemFu9icpMa+wwbvLff+/9IPQH
         SJAkI7ZP8s3RIB3FOWKe8ANACDyWmJnHatHcaa3CuVlwJaIDqSSNPK6gWdSQ0l/9LcYN
         5tOIap1wvh6WBea9faAAzFsnc2/6wVpzRvLmzUqCsasSNnttMTmLnVMcRCUPulOOQchj
         6omiYqwGhxU+UhzdifVHtFHUzwf3xRFi7mwYfgk4wByvSPU/7gUOv39Rgs0131DQzdZQ
         L57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756506711; x=1757111511;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5LILI3BrETC9EOLPWKkYIiAly3h6+hVppm2fXa/NIo=;
        b=BBKL61Wfa7idDAn/H5Q2BkxCpiP7ruDUOrLNM2eZ6Awqzdry4zntqr/5DHOhdcp6pE
         LfR+IKS4lJd18Cvohh3OYpUtlIjkQc7VsVWwOShPI74Td1QzyyuHhuTo1yprWbsyl4RY
         pVuap73tkV0ZY/6Z75jj9QQiLjbdLunJfMW4YjyWQnCZDQDkl8h/QP+BJ8uvhHq8ysSe
         w8CvC+MSaKtNlBy+J5+vVMvL/JJxRQTyYWPXJAcqAgF0/8UTsYE/zkRdRhCrszlGNL8D
         IfsjhhLe8H6MKqmeVQMc6l5kA9Pxi/04PPhrh5Q45eaMYG7E9Fd1jFjeq3ZlO4ZrgKVl
         wqzw==
X-Forwarded-Encrypted: i=1; AJvYcCXO45zWDoX9+KBqBay1nQbHNZQmKMAFcBOTvP+o/3cPuPPZUVfa4co5U9H8rBsNke6yBYSFND1c/t1/@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/YALz+zGMlwNheB3uSyvf19BLm/S43VpS2sSupc6F34qE84NA
	iClhItGMwRfgPxajy5DtMzzYqK1cZ4iR/jsmH5mQYc66dl0OSEmy7FtbMuhccN1LrSBtFMEcF+G
	JY/d5TTGoz9idgYLFkbklPDV8whNvghw=
X-Gm-Gg: ASbGnct88YLZn7hffT3FxGhTBfJpVO3khxRqlS3E7a5+bMbBxSke5X/iXxToWWe3Wqq
	zeVFtfFTWAeAIhXiXTT0UOtyi2cfSRiTr/Xvjq4ysMxZKvfT4smbwxE+Z0npbkz3JBdNknOxaFq
	nU/vWd7QhqkNbRlwGPPpsBfljsRzSlyttNzfYcVmOZTnRTvG4FIHhmpteruriY0/QqQMN27XkPA
	pva8q3uCZoKth1PgFgMm+RRNSSDB66+MdoIJbK6LZOPJIRGSzLBM+xWeZGL8hq41VxoNKhOCv19
	NlyJO3GlZB1FeMdhUGXZ5w==
X-Google-Smtp-Source: AGHT+IFDfPhHbTtYrim7gXYOnXvle+8uZtP9WNKRHl5jXOS1PDOuqPXEBxSOVFv40M3RJiRulBGma80bQyB+ZLGOBKs=
X-Received: by 2002:a05:6214:f08:b0:70d:dbf3:a377 with SMTP id
 6a1803df08f44-70fac7868c2mr2891016d6.24.1756506711347; Fri, 29 Aug 2025
 15:31:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202508291432.M5gWPqJX-lkp@intel.com> <c18ba6b4-847e-4470-bd0e-9e5232add730@samba.org>
 <CAH2r5mvksbiH-D4FbVb0PVg1vnik+WU7d0kxRUk0S9h9S+=zvw@mail.gmail.com> <2854f742-a0bc-4456-a372-9fa2d4e2ee3f@samba.org>
In-Reply-To: <2854f742-a0bc-4456-a372-9fa2d4e2ee3f@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Aug 2025 17:31:39 -0500
X-Gm-Features: Ac12FXxmXORTkXDusjVFRlJFrVpRS2gNUmp2AJ53_1tM1bxR6Wu59aPYuOkdcAs
Message-ID: <CAH2r5muGufmSdjxqTv9wcpbZoMsoEq=1ufFo_Yty352uDf+3-w@mail.gmail.com>
Subject: Re: [cifs:for-next-next 28/146] fs/smb/client/smbdirect.c:1856:25:
 warning: stack frame size (1272) exceeds limit (1024) in 'smbd_get_connection'
To: Stefan Metzmacher <metze@samba.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <stfrench@microsoft.com>, kernel test robot <lkp@intel.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000937270063d8896d6"

--000000000000937270063d8896d6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated " smb: smbdirect: introduce smbdirect_socket_init()" patch attached

Also updated cifs-2.6.git for-next-next

Let me know if any additional problems or other patches to update

On Fri, Aug 29, 2025 at 1:03=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 29.08.25 um 19:59 schrieb Steve French:
> > I have updated the patch (see attached), and updated cifs-2.6.git for-n=
ext-next
> >
> >> I'm not sure if the following should be added
> >> Reported-by: kernel test robot <lkp@intel.com>
> >
> > That is a good question, but I lean against it since the "initial bug"
> > was not reported by them that caused the patch.  If it was a distinct
> > patch fixing the bug they pointed out, then yes it should be added,
> > but could be confusing if what they pointed out was totally unrelated
> > to the purpose of the patch.
>
> You squashed it into the wrong commit. Please patch this one:
> f2e2769275f4aa6e4d5fa98004301e91282a094a smb: smbdirect: introduce smbdir=
ect_socket_init()
>
> Thanks!
> metze



--=20
Thanks,

Steve

--000000000000937270063d8896d6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb-smbdirect-introduce-smbdirect_socket_init.patch"
Content-Disposition: attachment; 
	filename="0001-smb-smbdirect-introduce-smbdirect_socket_init.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mexept750>
X-Attachment-Id: f_mexept750

RnJvbSA2ZWQ4MDhkNjE4NzgzNzYxZGZiOTc2ODFmZDBhMGZkNWQzM2I3YzhmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgpE
YXRlOiBGcmksIDggQXVnIDIwMjUgMTU6MDg6MzMgKzAyMDAKU3ViamVjdDogW1BBVENIXSBzbWI6
IHNtYmRpcmVjdDogaW50cm9kdWNlIHNtYmRpcmVjdF9zb2NrZXRfaW5pdCgpCgpUaGlzIHdpbGwg
bWFrZSBpdCBlYXNpZXIgdG8ga2VlcCB0aGUgaW5pdGlhbGl6YXRpb24KaW4gYSBzaW5nbGUgcGxh
Y2UuCgpGb3Igbm93IGl0J3MgYW4gX19hbHdheXNfaW5saW5lIGZ1bmN0aW9uIGFzIHdlIG9ubHkK
c2hhcmUgdGhlIGhlYWRlciBmaWxlcy4gT25jZSBtb3ZlIHRvIGNvbW1vbiBmdW5jdGlvbnMKd2Un
bGwgaGF2ZSBhIGRlZGljYXRlZCBzbWJkaXJlY3Qua28gdGhhdCBleHBvcnRzIGZ1bmN0aW9ucy4u
LgoKQ2M6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPgpDYzogVG9tIFRhbHBleSA8
dG9tQHRhbHBleS5jb20+CkNjOiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4KQ2M6IE5h
bWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+CkNjOiBsaW51eC1jaWZzQHZnZXIua2Vy
bmVsLm9yZwpDYzogc2FtYmEtdGVjaG5pY2FsQGxpc3RzLnNhbWJhLm9yZwpTaWduZWQtb2ZmLWJ5
OiBTdGVmYW4gTWV0em1hY2hlciA8bWV0emVAc2FtYmEub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2
ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NvbW1vbi9zbWJk
aXJlY3Qvc21iZGlyZWN0X3NvY2tldC5oIHwgMTggKysrKysrKysrKysrKysrKysrCiAxIGZpbGUg
Y2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jb21tb24vc21i
ZGlyZWN0L3NtYmRpcmVjdF9zb2NrZXQuaCBiL2ZzL3NtYi9jb21tb24vc21iZGlyZWN0L3NtYmRp
cmVjdF9zb2NrZXQuaAppbmRleCA4MGMzYjcxMjgwNGMuLjE3OGY3NjczZGM3ZiAxMDA2NDQKLS0t
IGEvZnMvc21iL2NvbW1vbi9zbWJkaXJlY3Qvc21iZGlyZWN0X3NvY2tldC5oCisrKyBiL2ZzL3Nt
Yi9jb21tb24vc21iZGlyZWN0L3NtYmRpcmVjdF9zb2NrZXQuaApAQCAtMTEzLDYgKzExMywyNCBA
QCBzdHJ1Y3Qgc21iZGlyZWN0X3NvY2tldCB7CiAJfSByZWN2X2lvOwogfTsKIAorc3RhdGljIF9f
YWx3YXlzX2lubGluZSB2b2lkIHNtYmRpcmVjdF9zb2NrZXRfaW5pdChzdHJ1Y3Qgc21iZGlyZWN0
X3NvY2tldCAqc2MpCit7CisJLyoKKwkgKiBUaGlzIGFsc28gc2V0cyBzdGF0dXMgPSBTTUJESVJF
Q1RfU09DS0VUX0NSRUFURUQKKwkgKi8KKwlCVUlMRF9CVUdfT04oU01CRElSRUNUX1NPQ0tFVF9D
UkVBVEVEICE9IDApOworCW1lbXNldChzYywgMCwgc2l6ZW9mKCpzYykpOworCisJaW5pdF93YWl0
cXVldWVfaGVhZCgmc2MtPnN0YXR1c193YWl0KTsKKworCUlOSVRfTElTVF9IRUFEKCZzYy0+cmVj
dl9pby5mcmVlLmxpc3QpOworCXNwaW5fbG9ja19pbml0KCZzYy0+cmVjdl9pby5mcmVlLmxvY2sp
OworCisJSU5JVF9MSVNUX0hFQUQoJnNjLT5yZWN2X2lvLnJlYXNzZW1ibHkubGlzdCk7CisJc3Bp
bl9sb2NrX2luaXQoJnNjLT5yZWN2X2lvLnJlYXNzZW1ibHkubG9jayk7CisJaW5pdF93YWl0cXVl
dWVfaGVhZCgmc2MtPnJlY3ZfaW8ucmVhc3NlbWJseS53YWl0X3F1ZXVlKTsKK30KKwogc3RydWN0
IHNtYmRpcmVjdF9zZW5kX2lvIHsKIAlzdHJ1Y3Qgc21iZGlyZWN0X3NvY2tldCAqc29ja2V0Owog
CXN0cnVjdCBpYl9jcWUgY3FlOwotLSAKMi40OC4xCgo=
--000000000000937270063d8896d6--
