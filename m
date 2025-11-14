Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E431326D
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 10:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763117890; cv=none; b=V5/42Pr1OXDwaqYWazf7rFh4AJ74BLCfOMbr2sjv06NaoaHDN6pTDJEsMG9HDSP/X2Jom04DVhi1l6usrPmJE0Wjwtx0KL4bj5B3MkZlggGD5KT3YHc7iqAo9p07YPrDNUeUPiYMtUNU4UTQkWH4rYZgOW7rhy+Jp4iLrasrUmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763117890; c=relaxed/simple;
	bh=7E7aTrRNn7GqCCmL74GcMKnCl8xh0/uDJAjG5qOFM64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fm4vm2yL//9idMoTti3Qrl3/Ddk8jx56IeIjRCOjgZvrJciRLgshcIh+QYs213xHmxIy0gOP/8cFdX7hVvkJgC11V6q2rq5tTmAVwBHzdhr+XK8fco9+sozQ1cUVXfk1Q/kx0XmXxl68vG8zDSP7uicf0Et7bdMLYy2M1/C2XQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qz+0sfjO; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qz+0sfjO"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b72b495aa81so224397466b.2
        for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 02:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763117885; x=1763722685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7E7aTrRNn7GqCCmL74GcMKnCl8xh0/uDJAjG5qOFM64=;
        b=Qz+0sfjOwi+X3pF63p+sLVj3yF9dg9KKg6TRDdvyOlYsQ9QSk14smS5XMVGDtxT241
         +bKQmQTozycg4IhwxezRRSOo056Q6xWu9nYMDTZB/ucy/1KiJA6rRqWxXy5Kr0A7966/
         5CMletSMRFhFiJmOvgjpuyN/hEE7lNinQgiygHxwgic/5IdkBYeyTj9pouEDvdiGNaiy
         TU6cyLkWr1/AZTKicPqTA9q8LK2s7gkketyQErKiTDqrVq0+cHlSgfIOqQHndlSOnCO0
         d2zCHM9LJjFIOUm8az4CG+CtCI2mNrQt+52E1Z24WXgD+HnL9bBHEKOlRigtaHA2XMMP
         k19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763117885; x=1763722685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7E7aTrRNn7GqCCmL74GcMKnCl8xh0/uDJAjG5qOFM64=;
        b=PSDezBUwx+QySbY44JcaVi5vDd+lj4AikgwtSVmXltr/fYEuhSImo+2jLBJl+l2tqE
         ozMsOC2cbVqVEP1zCUWoJLiLZWPy2pnK+JZwRu01bpOB2C+UfYvVt+88wq7XrFs5wRi7
         Vwi0ibtqwizaE4LxuwO+1F74q19SZj3MtqEu6Qvzmjs+APGPLc4mkz+czSi8Dk5wm27+
         XiX3aHfXUW8MDh2qMB+ZKKO/P3FR2h8QFtB6To/j4KVgq1kah7BTDlX0tC9rL35KNgrv
         BjGOkwEcoVqoE01kXc6HTA3m8Q6H3hWoH2AoGFXQz9LvoA1sXQ7GrWHI1pyZ9K8s0Qsr
         eSEg==
X-Forwarded-Encrypted: i=1; AJvYcCVgpbUXTlw1CDXDufAiod5C8mJwQRNs7s+F2LA0bRWx+unvqwJbBjAG47dyG7qu+d8N93jsSEUWQCaX@vger.kernel.org
X-Gm-Message-State: AOJu0YwvwuXry9S059aJDo4VY3+y0B/dBHnvpUxPcEom/4/PIV4aMPd/
	1d1IX9l4a4ktcQfnhMWcOaKH/u45ogfYPaHbz4mxaZLvtEJje5qxHatckcBxbw0wITxNz52DqcB
	wzO33VSSs/2XETvTioV1Yz5O18rJb99o=
X-Gm-Gg: ASbGncsvF4mLeJw33nHJ5761akIVBdLnk9KPJPh2DaDZhefo36MFYLbSl+vKcaqMidf
	7qYRuNB0QjbuVNUfm2EAgR09P+aRPBL+eoVzMj1ib1FQzAPyFuKGZsKlC2xyF5psAnwXyFupyvA
	g5UsqSB3GfTl3t8Mh1LMIhDCN2BgVPo1b9r36LZhCBpwnjHy6kq+fd5ZMUejSRYuRSrTdeGRcwA
	oeor/xjTzXqMGC73IH9uROne3nyLVNqmQC9Z3mZoH1PhtuW41HSuARBeIhhYMgjJJfjFA==
X-Google-Smtp-Source: AGHT+IFBcvbMBl3RJ1ZvnW55LhaDnV7WSjkZ7E1QXNbIMNVg3xOOXziXF+960gA7Iyy2u7uDRx+E77gqcq11Z9vCE7E=
X-Received: by 2002:a17:907:1b04:b0:b73:392b:89ff with SMTP id
 a640c23a62f3a-b73678094c1mr265530766b.10.1763117884574; Fri, 14 Nov 2025
 02:58:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
 <958479.1762852948@warthog.procyon.org.uk> <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com>
 <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com>
 <1392200.1762971247@warthog.procyon.org.uk> <CANT5p=p4KSRsCAB-peTKehvsYYiuOxy3qLNDO9j5H+5PP_eiyw@mail.gmail.com>
 <1640439.1763042251@warthog.procyon.org.uk> <CANT5p=pye46OnCQB+DB=ts7PkZS-bCpC+cURC1HnptmSwApX-Q@mail.gmail.com>
 <1726855.1763117354@warthog.procyon.org.uk>
In-Reply-To: <1726855.1763117354@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 14 Nov 2025 16:27:52 +0530
X-Gm-Features: AWmQ_bk4HuDCV_hLzOiNB6msXAoXZqIm547_U3KBVDvP33_6s33vnPmOU8f2vYg
Message-ID: <CANT5p=oJ2WJorES9cG9YfBKLfTf_bs69gcCUjvhksC0729M=fA@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: David Howells <dhowells@redhat.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, Mark A Whiting <whitingm@opentext.com>, 
	henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>, 
	Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 4:19=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Looks good.
>
> Acked-by: David Howells <dhowells@redhat.com>
>

Thanks David.

--=20
Regards,
Shyam
