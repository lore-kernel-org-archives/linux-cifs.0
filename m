Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21F8412BF6
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 22:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785276205; cv=pass; b=If3gXhyv4b0EsNeXXPEc4rdD7WWa1oisDXzzT5kkhU0CNj3Rnyk334gUcxgxymS2/4QlNws1avNZQmlVcWy605/VuSEQjZOlLftqZZYL0le2u36QqiECiOWr/hLYs9AzUWzlB/4TVlcoXHW/kzRtOysVYlX7rOVSDAO+fNmKj48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785276205; c=relaxed/simple;
	bh=pm3D3AamGUQAWPLS6+ekF3xsHcTais3VIMOSiHZ67Aw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AIR4SnYGVLBEct4BccZPEqOVUdUA93TrBdDDne6YbpQz4ZHjqX+YJYJWc/9NzzYhNGCQu/pvXSef4Luy9qAcwVzvk1tjCWq4PZcrNN/3DQfgvL7s+FFvLOX3jAbOMpvdt7sRblZLuUS0ZUZANE8ghQuO5OCtT3lmHOEHN6iYg2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5r3+Asa; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5r3+Asa"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8ee88fce572so3492146d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 15:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785276195; cv=none;
        d=google.com; s=arc-20260327;
        b=gZPritOefJXvAEe+vp5kq2RnRyxggBjiWoq0HXTmrgV77SvJlOWWL8w4+ZQBucwqvs
         HnSLo83iak7QlOYDCXHZ7/zrn9ScKobfU7jeUTEjKsXonKTOC9DcteI9BF4f5TJTWXm6
         osJNRVJadxLnixo31NwZWtVuzvJHfA7QB5TClFhFanAgse5fj69JQk2zRCWKD7iS2RoK
         uT9cxnhgnGFEP3VLVVMBfaPVeV2z3F5rtpTeDhgwdP4wmUxhdvNbGtRsV5F8WOibu2wF
         K8kLsbTSguIgqDyOKJlsaVvd2WMD6w1ftqm95UAa+jBTVAGedhsmEF0Tu8iCsVBR9gy5
         gTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pm3D3AamGUQAWPLS6+ekF3xsHcTais3VIMOSiHZ67Aw=;
        fh=9t4ygndu5LAt+6Sk3fWhToqSSTISwCDchivuw75Y7xo=;
        b=Jinbj2ehvHyKofFXnYTNZ7Cub9a3DMtkBI/Klgzzwb6LT/cKCTkn//Sx7iIy/35Zbx
         UaCFg+xNiqKxSXInGHvS5ftUIFpEDeFSCtEJOKSqIFDHkNSIduBcOzBY2p3Q/oOMo+a7
         ZTlR8Bj/jBfA8eMA4KjnYkV8kZ6zXpz/4stBSwuLA47AELzaP0pXdLyzBkP24xEyknlf
         tAH9TGeDblwsBuEdFbBEH6HU35TnAVwbt53W3G3UgC56frBaj/1dNBYNSyogRbS2li5b
         T//F3QKD/xwbv6crlI16QjPGZuRhs+PGGdG+UN+G/TBhwqOmX/JFRTj/9m0qQIu+w1Fi
         bgYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785276195; x=1785880995; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pm3D3AamGUQAWPLS6+ekF3xsHcTais3VIMOSiHZ67Aw=;
        b=W5r3+AsafszXdW9P4aR/FGwJa637CCXV8GCmlzmnwqGnnbB2MtqppTwa8yz6W3563X
         eMTWUWaA/Ent7zNGtMYEVhVntLGB+YrkJEty0ZYqqZj+QII0yMsoAqfIS/CFBnjrCbXd
         00IPZ7gQqIej5bn8PUl0uvcEJlVwVUfbJ4y6BrITHg6Rto33p5PII0wtWFJtXAWbTBFw
         TKe9d9/pXGCA/99dstfe0DnrZVoa6dlZUWSaeXRb17J1PGNi5LH8kHIR4WCcLNmc7ouu
         cE5I5nhI+4TBkHpLYRGLGwYaIT5Vla/uBl2jTcaVtsKvvPNkLv9giU+khM5wIDZ9l7+D
         VKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276195; x=1785880995;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pm3D3AamGUQAWPLS6+ekF3xsHcTais3VIMOSiHZ67Aw=;
        b=evgKugFfHIZai/w8wN6n7bBC06WBP44/22hzCEZ7ATCSNBNVKorAdYgezYE9tszyq5
         ALn/0WyvSC8jypX81v9ajbYbxd5RvcmklipOCse7+leMQddExthKypoQl1ZH3azQSxPx
         Wma84C0Tb+gsGYJo/W4pDuyEeSdypPImE0y/NiRksypN9ddl4sCkB/D9itHRR0pxzIwb
         z6d9xlLAKFE06B47Bi07Jex8mNv5exTtrDn9v3uwqWEUkNSmnu5TYZGXVa3WECEAimDc
         rQfMq8eEz8EStIB2w5IxNAZlixUr4dmwhQY970dDLfpyGhFisOPPgxxZ1r7aw1wLz+4h
         Y/uw==
X-Forwarded-Encrypted: i=1; AHgh+RpX9GnWDsO2JG8IGCwo1HMlGlthqY2tP6BXnQ98slvD7Z4AbnymgyEUCdYBmnOdXvSiVOSY6gDF8MgK@vger.kernel.org
X-Gm-Message-State: AOJu0YzndokDuE2mkwlid1giPmdp+b5CVPM8rmsft53x5qiIeLdS+1yn
	PIkJeb9e3z8o8bU3O5m+NKXBpeQJ9ViDYJlQLhP6lHX0GNzjAHHC1hhAWk+qE72MclIMtd2fO69
	vGcxqH1bCu2UcSXORF8y5NmJLNSjLbQK4Dl6b
X-Gm-Gg: AR+sD13e2Rd6GS6XRAOTrial7LPTTPLLBS0/CASAsCAohIfIO65jkdZ2npxKy6zBQko
	iaLF4Dwih6TSLs7DEpxI3PrT+Q8ge+ex/VAxceoCTUnlOZD4GmzrbnsfuacpCVbbLo7Uhd+4iAW
	vdxYbSkkCo+03HNSNcPfnqXPYd469jkWmWZXmjcqztRh79tRE0SYY/emVX/xPIWE3ZUspSo06+o
	jxLLQWX+04PNOFVTvu1cMSbefeQ0ZeoRFtk414NA7M0buw7eWuWKoT2Vyj6ZmMFCee4Z0nuxJlk
	OvjeKNCk+MK6GedCfac4giVG84UU8MjKK1+YhYSDHiWPBArJuPhCxRo4tePFSFXFpV3O8B4V7zx
	KCtUC4e+Su5SwI/hCQ2EOxk26uoMMdlAAFXs88tIRulbRFjcwuFwsS5ospU6URZWL9puNb25ZeF
	AjHurGIcxxGjFb5yJphbahCuhIFQ==
X-Received: by 2002:a05:6214:390e:b0:8fd:6dc5:94b with SMTP id
 6a1803df08f44-90817426e79mr51521356d6.64.1785276195163; Tue, 28 Jul 2026
 15:03:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784888897.git.tanze@kylinos.cn> <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn> <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com> <c33fecf6-6683-44f6-9eff-f508f172ee7a@samba.org>
In-Reply-To: <c33fecf6-6683-44f6-9eff-f508f172ee7a@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 Jul 2026 17:03:01 -0500
X-Gm-Features: AUfX_mxpU2iucmWCguB3YTP4B7xIA5XU_xvvAJ5FHnz3uY6VBYF5frOatCA6GR4
Message-ID: <CAH2r5mtNTaJWc8MAfqEfg5c5LDE6_RuiP_+nd4WcPXBVNxe40Q@mail.gmail.com>
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Ralph Boehme <slow@samba.org>
Cc: tanze <tanze@kylinos.cn>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>, 
	tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	Stefan Metzmacher <metze@samba.org>, "vl@samba.org" <vl@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I agree - POSIX ACLs should be included in the updated version, but
interesting question is whether they could be made optional so as
server could support the Linux xattrs but not support POSIX ACLs

On Mon, Jul 27, 2026 at 11:58=E2=80=AFPM Ralph Boehme <slow@samba.org> wrot=
e:
>
> On 7/28/26 2:35 AM, Steve French wrote:
> > What other protocol improvements should go into the new version of the =
protocol?
> POSIX ACLs end-to-end comes to mind.



--=20
Thanks,

Steve
