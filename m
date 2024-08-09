Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5312F22;
	Fri,  9 Aug 2024 03:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723175429; cv=none; b=YhsnYEpegH8vMvZv0amZVA/Yh1OzLEzAHdWmxq7w77IUPzr3S8YcdAnfenSeBHgpSHLjkqGoKzHdy7W6NMpHGaYGxfHSHuE5DPCugzRAcOKB3FwLqSLA3OgZMHVsJzbG3n3YBJCMgpnlTVeFeeO+aNY+ANKWCnduX25yuT0Ah6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723175429; c=relaxed/simple;
	bh=GcsKyLDJONt+ZvzDLWHq4abBRnvwVFDALz1JbD/AO9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lcDJTSnVB0qo4HB+sgyiaKfsx1cWCXNc0DA6XqGKmoXZdSiHlFlhGbp+K5WxfaxHsBDtRleGGj84VlY7SE+gl9XGNhW11Nz7XCL0EpX8k/2UzgsF1PbuDED242AK0iQfShwbbFkRUcba8M0tJN63KWHbklBH2OyM2O9VHR8E22w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LARA/Qhw; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LARA/Qhw"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f189a2a7f8so16627311fa.2;
        Thu, 08 Aug 2024 20:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723175426; x=1723780226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcsKyLDJONt+ZvzDLWHq4abBRnvwVFDALz1JbD/AO9M=;
        b=LARA/QhwsWs3/2nZXF4MpP/06i0xvIwHevz849z/r6edRlzqnXQXv23GuRHLbHmt89
         6glcbD1yyHLVPD1LnzlpiHOajMJVJRKV3QkB9nb41vTh/ggO52Es5sycIagaI2JCLhgD
         yge5JbclDvqntDtrNt+q1WU8PTD2QABWdSmGMava8YUWerpGNUJ1zkKw2KiGFITHHeiE
         6jnnVHf6OhSEHtVEOlS8H2dNorTNyucDs+Qb9m35/ZYKG1zna0Ty/vOyN9njEsXSh/ab
         lQuVRSAZo+PKsT03p3kfrtrxpWITZsRtiIgBD6KHKZyAsMTDvvvH+yTU6wBdTbwPAk3j
         4c6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723175426; x=1723780226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GcsKyLDJONt+ZvzDLWHq4abBRnvwVFDALz1JbD/AO9M=;
        b=sWwKIi3FWBuhfTWFPpkbyuNgu6cQBU6X93Z0eBMww9cE+ILVQpi4o1EuN96ymIc9eP
         w8G68ZVShKdfO3ZZn3wq6akSTW2zbQpZbdHz5ImzyhViM9BRoXymn3ECYD1LKa9q9ICR
         n9f5+pX9AhzCnbdJKlaIDJ99ILATRQWImNkNjmyyPLIxiEj74IpM2amlY4BvYY9AH3q8
         zbtyorVc7vs8iznLfq5hXgu7Vb9BVT60pqLnu5b9W28qh7MBQRxvTiImQfwpYFOf1g7S
         Cp/k/1zcflWH8n80Tr6lmKDQMAd/6nc+KiXKKbVNKdXOUwUtt9VbhdjfThg/OSh6lWrq
         G2Hw==
X-Forwarded-Encrypted: i=1; AJvYcCW1xm+F9A1B+2nz521ROup05OkW2qP21VG63+A3hO2w190UmHRH9bIsRfuO6QqgQC9NBp6ZHXYpxGrUV1zoIWDMN/Su+RwESHi/tg9e4GJoeELN1iEpqPXM7XRg1EyhL2o+SiPRhZCmYrIpoFArgilwnbrqnTPa3PNzMQ3TJ6+mFfII8m2Cl6BizQ==
X-Gm-Message-State: AOJu0YwHsxPrAdcCPHayWUWXEDUEREZXhiFRM0W4P87xHxVLeUl2X7ne
	M5CgtSB6otOVausbdT317VrBW/sDulqlWZvgLKQv3i/NSauppnc+7wwD/dHx1U9Hn0Uo3VSuPMi
	NMfOo4N8NPWsUMSrRdMu6LVjOlss=
X-Google-Smtp-Source: AGHT+IHAViZ+40B8/UqdywKboDwJDM5h369EKkboKszxuNwuILrsCiD/Dz2BVQ2iWoUGlelJi3lxJWMEmm+/c9da4s8=
X-Received: by 2002:a05:6512:2314:b0:52e:9b9f:9377 with SMTP id
 2adb3069b0e04-530ee9cc5d8mr180073e87.21.1723175425293; Thu, 08 Aug 2024
 20:50:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrVA1N6Iv0Byb3I7@cute> <CAKYAXd-5gKBEAO_GvSKBLciiB1qhjevTSd8kre_-nJQpTw+3vQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-5gKBEAO_GvSKBLciiB1qhjevTSd8kre_-nJQpTw+3vQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 8 Aug 2024 22:50:13 -0500
Message-ID: <CAH2r5muVvaOii15Kg5e0zWzhKdDy5fVh=GjtM=kZ=fyapKxtyQ@mail.gmail.com>
Subject: Re: [PATCH][next] smb: smb2pdu.h: Use static_assert() to check struct sizes
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Thu, Aug 8, 2024 at 9:51=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org> =
wrote:
>
> 2024=EB=85=84 8=EC=9B=94 9=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 7:04, =
Gustavo A. R. Silva <gustavoars@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
> >
> > Commit 9f9bef9bc5c6 ("smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-=
end
> > warnings") introduced tagged `struct create_context_hdr`. We want to
> > ensure that when new members need to be added to the flexible structure=
,
> > they are always included within this tagged struct.
> >
> > So, we use `static_assert()` to ensure that the memory layout for
> > both the flexible structure and the tagged struct is the same after
> > any changes.
> >
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>
> Thanks!
>


--=20
Thanks,

Steve
