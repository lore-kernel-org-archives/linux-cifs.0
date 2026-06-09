Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F3E4D8D84
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 22:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781043618; cv=pass; b=kLUUp8S8flvEdUqNikXLIz/mCVvmf3rZ7cNMkB2SYfNHapK9l+vUdePGFOCevXrxCGNAA5MCo+jAgEORv5AzJsU3kwbFLgv4L8ywU9zLzyHcoCL7oXehDzOxUesIkPGgTiVENQTohHNTruv00do2MTtcWrymxnI7odrXufQ1Mow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781043618; c=relaxed/simple;
	bh=hSgi0DQrQeGWXJn/UStoGjVMSyxqvgC7nF5MpkTHiIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CudTknuqW8IwE74rENYTOUaHQXNQAae3WrNZGPGy4/U0xQpQ9guL+Boys0tho3ZQwOrIoyin0sObk7FkrdZer1MU2ajS76hnesNJKum/gvcqC4j9R7eLVcMIYt+FE8Zvz+o0fwCw8DqNklAG5OIdoO4ftj0pNQgisRg32baJ9Io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0c3/SYM; arc=pass smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0c3/SYM"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9158c621ebbso708082185a.2
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2026 15:20:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781043616; cv=none;
        d=google.com; s=arc-20240605;
        b=TyFeeDrqqEwl9Y+pxRhLogkDzp48bJeVy3S3rDEKrzAimc4zkAe/NNEy53iFD5jPQu
         2gpOBfN2yW5h3eyXfJnRCKykfF+yAHf+d1xulB1KiN21a6YBXB3eHUEEHT/ntCOs4O+Y
         6M70IPwKBOWxMan54YNpteicwtmhShxY9MFN/Sw84rz0lkJYRPMX+C1USfSRx9r/2c3k
         1ULt3KMBS7j99jlrr1tgTrxqWzfXvZVlLkHQwDrSOtXlE3KhVTjZk4dAsI979eTmcvKN
         Rawsew68hTXsGQ6whY7b/39A1kXfKrfSEVVRueIbdH5kPzEL3NISM20sr4sqKDz58wZ6
         S4gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+ot/4t41HpYuXj39wqSGjI97S9W+8dZZVBBjzX6WdKw=;
        fh=74J9kUtVznQMJAijN0AgQId9iiXakfi5SQxcKsz5PTw=;
        b=OwRzbUU0NCkCbklQR6sLPxMnOUTVGy4yfJdbe+h3sVY4/ebyBy2MQM58dQDgnepn1k
         iva6E8t9UYPDCJaBNERUWexhXGcY6WJA5tpJcPbxm5mUeNkqoo1NUPt9OYTlfC7dq+UJ
         WWeqpQQvyJvEuKVgZSve7sbBLlg1Czna0OiLRYQ/r0Elke8r2L1LdiIrBpjI8RqTVoMn
         vOGLCIp0tykGAyw6KvFtJYNu0vBP00X5NNmoRx0RSJTeCXm1jS+TL9Bkc+NLNF3/ly7f
         mRxxXFeIG+sCrj5C2q82VF1/+MC0mvq8RN/GxWtBoLzb1rFPmEO92N7N6vrifnurklth
         yYvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781043616; x=1781648416; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ot/4t41HpYuXj39wqSGjI97S9W+8dZZVBBjzX6WdKw=;
        b=g0c3/SYMhZvcbk53OtB81C44qN0i8o9Zfoxo476GFl8lkS85Nlp+OdnWn4Bb1ZBWrS
         QAgNcgXmKOW1lmshHFvhQYaPC3L80gHiwjyltuJBsn7oyyjbbQ+GYINEAUGBXsY1XjHn
         +FcHV48PeNTimZ2QuhXRn1aW/ML/+Dv6USr1hJ2Xl9vm34mjvoKatxf7mDCnr0xN1F14
         3ap4bXfyVQKBJmQVmYb3Gjmj0jsZ8istDJ2cgLGmm2ciP1/bywfTVTtscf9xsFWZ1grQ
         57akXr0upu0ucJAecqgY7RQykDj3yWKOc9EfxaM5G1PWzTLeI/kpNAtw/saC+mnh58vJ
         7uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781043616; x=1781648416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+ot/4t41HpYuXj39wqSGjI97S9W+8dZZVBBjzX6WdKw=;
        b=J8C8GGonWWETpxYvH92Df3REPdEu5JWXBPllqRNyqgqfkAMLZh3PRl8qM75wJUe3SL
         /2e59jKhNB8TfNcdjKhLalITSrGRxEgkJyD07M/F79+9m2TEcp7HWOyRM+3x+yMTYVCF
         PJLq2KecS+O2/pFJhlL1QjJp31LHRkasCPVF4wUFdziZM33a60CwFOD70Hic8ZF5HrUc
         DQiL9Y/D9KXW7pIgTzPxW8TKJIh+dTNGdPCi5AUTniZJaUoVUKPFvlv7XlnYRScY+hes
         6XQ2xr/pbjzCKGldqOnELwJ/3z649LSnSlQMJk1H9+971yZ85mhjW+mIlDtCuCleueXd
         YZDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9AcRCzb/FKDEQauV/Bnj/LseXdcDSJcNCt5M/T3akowTEbEykwdiQlQdn/U6etCT/U/JzeGNoIqVvm@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxb3QsrcWJtCiS3BSisyihZt3NULyuWWDDIXyVf+sIQPlkwLOV
	ZG9cmPaGLfAGuMm5ZKAXS61oL9Ixwzl81ScVPwgiFy5LiwAeV54KrgGaOAGySsuGLWrTfG9XMOe
	hRWhybgH7yx2ekVmPS5UIduLr1iAlPUHl53kIqRc=
X-Gm-Gg: Acq92OHmEnFP4cARj23HKTys8vLSEhSPFJXKhB1ACuPwnFLFuLveg2NX7baA9zXkVvD
	2NL18aIqlA6WNETQKGTsJqg0R1XI1UY1QVhX+E9e7is8A8oAx31WEKE+XkEugH2loFoA07dzEHO
	pgejNfBDjUaXkGPMF9IWl9m5lIwO4+mCRLMhDjjGw6nP5D5XPgjazxDfo753Rsd4RGuQgKaslu8
	f4jmI85Dg5SvpQn0scGeFUk2GPBKPjUIU+XDdFt1+UNyFCXQ1aeC8pAtIw5P3Z+L/8dkYZ6BAaw
	nsAbSHKO7xfPFH0BugSPxnehYCgHlMMxPa78eKz63eAnlgTLbQnSP74I0ggeJzSPVgI05QJa6p5
	iYjQqGeQ3FSsSBh1w1FGNQAYO4Ow8J482Zlzozkg2gl5ZA3ybNAXfAV3NyDWPlOkS6qeTnF+OFl
	gfZa42Yy2nSKglvjxfZrIvUHfvLxTHiqIU
X-Received: by 2002:a05:620a:1d0e:b0:911:9a7a:8076 with SMTP id
 af79cd13be357-915a9c350edmr3718229185a.8.1781043615973; Tue, 09 Jun 2026
 15:20:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202606091825.Fvo4zzYp-lkp@intel.com> <20260609141108.90414-1-cel@kernel.org>
In-Reply-To: <20260609141108.90414-1-cel@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 9 Jun 2026 17:20:04 -0500
X-Gm-Features: AVVi8CeOfYnDex28-rn-0FojbcnrExEKLSF5jGwKXya_gdEo9vDq-mOmY0-SzJg
Message-ID: <CAH2r5mvCKnRjvt4VK7xj47L4yLoBc8_dTc_CRHjG4xq2MuFBjA@mail.gmail.com>
Subject: Re: [cifs:for-next-next 15/16] fs/smb/client/cifsfs.c:1204:22: error:
 use of undeclared identifier 'FS_XFLAG_CASEFOLD'
To: Chuck Lever <cel@kernel.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <stfrench@microsoft.com>, Roland Mainz <roland.mainz@nrubsig.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 9:19=E2=80=AFAM Chuck Lever <cel@kernel.org> wrote:
>
> On 6/9/26 6:24 AM, kernel test robot wrote:
> > >> fs/smb/client/cifsfs.c:1204:22: error: use of undeclared identifier =
'FS_XFLAG_CASEFOLD'
>
> FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are defined by
> "fs: Add case sensitivity flags to file_kattr", the foundational
> patch of the case-sensitivity series. That patch adds the two
> macros to include/uapi/linux/fs.h and folds them into
> FS_XFLAG_RDONLY_MASK in include/linux/fileattr.h.
>
> The cifs consumer ("cifs: Implement fileattr_get for case
> sensitivity") landed in for-next-next without that prerequisite,
> so the identifiers are undeclared. The failure reproduces under
> both clang and gcc because the macros are simply absent, not
> because of any arch- or compiler-specific construct.
>
> Steve, the cifs patch should not be applied ahead of its
> dependency. Either base for-next-next on the branch carrying
> "fs: Add case sensitivity flags to file_kattr", or drop the cifs
> patch until that patch lands. The full series is intended to be
> merged together for this reason.

Removed now - the purpose of this branch ("for-next-next") was not to
forget patches in next merge window,
(ie that are too early to merge into cifs-2.6.git for-next) I didn't
realize that anyone auto-built from for-next-next,
I didn't want to forget about the followon patch to yours:

smb: client: revalidate attrs before reporting FS_COMPR_FL

  cifs_fileattr_get() reports FS_COMPR_FL from inode->cifsAttrs.
  Revalidate the dentry attributes before consulting cifsAttrs
  so that the reported compression flag reflects current server
  state when attribute revalidation is required.

  Signed-off-by: tanze <tanze@kylinos.cn>



--=20
Thanks,

Steve
