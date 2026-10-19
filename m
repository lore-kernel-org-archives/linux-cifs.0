Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A87552EA0
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 14:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419234; cv=none; b=DlMMK3A8hMO0nHhXnEL+Qa2Sx3mnxoXGcXjg87Fon2dAom7oLdMdK1+5R685mTfWxOnDvmzs95PibiPaWF5tIKaHz4FRaX5QNSeKIcaNQXS5QlVh5M15dCMdavVQiKHoJtdD86rjAvyBfl/Pu6CQ5RqRRXOxWdG1Dw9yaAAlSiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419234; c=relaxed/simple;
	bh=bz51zWK3lsygrwU+pTmiPdYM3xUzHrKDRl5VJvqLxIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P50SYXQdLbELWaNNgb8tU5FzgWhHyDw8Pif2KQ/hnIe2Z49Rm4ZkfYsuOxaDYalHgV+80MnxrDLUNjMdELrbLZS9K1BgDV1H/DACJ/AzxAbypX5Mq0zZkFdl2lmRdQpL2fywwbOgPK2A1C5RV5xMKvyPT3wkkrc28l1rPq/hPxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=KW+DLg1g; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EoTxvB4l; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="KW+DLg1g";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EoTxvB4l"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9DDE97A00C4
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 10:13:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 19 Oct 2026 10:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1792419231; x=1792505631; bh=J9xWzwJZWO
	lbdeKeK3bTThQv26NxXY4xrdFqvt2pQjk=; b=KW+DLg1gy9bh7/N7i50vIwU+w1
	UUOLLFegD092p95o+oGdEdu/V7S+8Bl5QTPm7kA2EQm8kIILyWjMoHM5vL9sBrf0
	+KA2FTsl1H3RedoLNexkXysRJRXEqHHY6UFFIoowDldRWXPuDLCXO4njUYwk4F35
	qGh6WP/aLmmEzID+pavgdNSd7seQMmep1mDBdk4aWZUFf0FyZZCgtSJvN31etfYD
	6ciAV8cwhsZCWiaBXYK4a3BMV2mYJURwqMVA6pVgXoV2ijuh3yjUUcjoi2896U9b
	idqhj7PS+HtlCg+62GW0TAJeFwKzWpKJYIb5M7hTNY0ZH/jOquUX6czZsY2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792419231; x=1792505631; bh=J9xWzwJZWOlbdeKeK3bTThQv26NxXY4xrdF
	qvt2pQjk=; b=EoTxvB4ltDNh/HD+RhJr8I5PWBhAEMRgCmA0K1XSmarvD1yFYMS
	8yC49QdkpLI2C4fviaC3XW4mvn21YvKCs3Az8nYvowoQVMifGYcho4zzKBUwf1zR
	MuZGbkqEfPfhcqCobOBY07MaT3n/cVs1LdmJHrVxrR+qM7/cL7/AGqvk+WSpsG1B
	REYPsbLrPecP2lNblaywBQUmb1lbfKzYkNwGRaoq9LYrVx+nhWQGNUJ+P9XpuRfN
	8kM45dKhD9iWRxsJAeTrar10V49LDBQGusiHDjDzZq9v9yP+Pq/kcuQ8+rzqBroU
	hQnQvIuC3VT0FOPiHuAJb0L4uuQ1l3WK10w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=kroah.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792419231; d=kroah.com;
	mf=PGdyZWdAa3JvYWguY29tPg==;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:fBKe2kftu7+J/u5Ymy1GLlwRbhhCVqfJ7bYsxXPMjlvSrXf
	b1qEzHZKbCQDh+naY/jLJ/vVxrZdKMAhbL4gXvtEQKWCIerdDeohHa+Rq9Lywiv5
	2cgIZ6Z3hNGq6yP6xu4akXmH5XQLrEbVdSDbKiXAC5cmF1PSEazgQKpLBEFeSSRd
	seNTUcf5A2ArFnjnnldSj+NQlhuO1RvtvN2RaW9iWPc7p6aEZU6gbN7ISb2RnvnG
	Ve9KRJOWv+xXwNI9hBnVnqVextL/EC+OyHvJOyxB4h3gKOKZlp4ZPq28udXjgn9D
	eH30McZM7YTDPVjH4O0OVIuCfcLZWZyHwiezkYw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:OLfAuuSEUFRxePVTML1CvBGp8d0gDeBuwWXDhjX68QQ=:bz51zWK3lsygrwU+pTmiPdYM3xUzHrKDRl5VJvqLxIU=;
X-ME-Sender: <xms:nyXWal_CtAS0cKIUkaZVdrzi0torrGEQUZQBs9O71nTatOFtI-VApw>
    <xme:nyXWasT83ytT_Qc_so-Z3X13bc0yMHLgom8Zi99yDvUS5h9P_jp7PKZGsnEtHoHIU
    iNm9AgTJagi_RHfhu0YfrIdSQEihpexNTBsTcQaROYn-vdcCQ>
X-ME-Received: <xmr:nyXWamqMRG8mlRRb9i5KCw9r-lKwk_9nusqww_1CevYoCCjHY5LeYZyK4N0XwLH-QOmVBDCRUsMCVukGvN0>
X-ME-Proxy-Cause: dmFkZTFm4Amxcp/cEC3B9PqZvqSO6JSMhvY9if8ijjQYumYqZ/QqnPMn+tjx1VMe0FydCQ
    lliEF2EdE21QaXvZUl7ew3nc0IZ/LgJO7iXKA0gzk8H78Zs9QW2vXBkFBp976JEYM2R8Q0
    1koe7XsNEWF79sGpPHZ6+U35IGfUrIGo2To7fO9xtItwMqSjYkBzmBpahPq7LhHpph21mD
    q7jb+7PwUlR8aVgG4ZkQYL/sCYWYbDU/udtH2qWAzDD2KGbLy4krbk7hlOs+tZRG7XBvqf
    w8JfoxhIrt9LeHIeyUJqBJ+qquMuXEAvZCi/s9oaEGq2N9kdo65Csce9gyZiQI9pWHsbF8
    hPrur+/T1R1hmVItAQyVE41LVv5NVhHBSfyZjvXg/d7vrOxQb9Q2MpjYYb2gylrExF+Y6k
    w5e4YIbISIQLPJ07NJfqczEkIIkKfNM9PZXQk+MbjSUXNC1L7SBiCDMT4DMdzL/A1ZYBhK
    Uiu9j8brEFaS8nENajjmKSkdSEshCRcxTnsTUcRAOs0f542aF39llHQFKFQN2q8+4XzoIG
    fKkRxKxg7u/0PyZ4tLcLfKRvIcixA++MXiEaonUzqNEjF82XgSTyTmF36oaWa7oN4s2k3T
    6htGGllYDGoE5DJPjML7C+li/FXtA+7zwiQpzmMgXQZpJAaLPqurKX0ocWiw
X-ME-Proxy: <xmx:nyXWapm6m2G2MTgTteShZOVCFYam08yTNlZ_DbgQwQlsT0m4SokVpw>
    <xmx:nyXWavcYgK1Jt9nN9RCUWuy0r_sq2nMYXnz1H42sbMh8BhBiLjIlBg>
    <xmx:nyXWalpBTj0_sIU-qWrEneihP6LNsj6QYfwbRCESd37eY875C3bUQA>
    <xmx:nyXWapOrB339rPpaFdBB_SYxScNBiR-7Ji1YHE48RXh2I2xj_G7q7A>
    <xmx:nyXWauNeesbcOSeDCcMBmy3RgvOfhsrTZZGNMRM1NewGx3giPZkpM4jy>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 10:13:50 -0400 (EDT)
Date: Mon, 19 Oct 2026 16:13:48 +0200
From: Greg KH <greg@kroah.com>
To: Ilan Dudnik <ilan.dudnik@safebreach.com>
Cc: stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: Subject: Request backport: ksmbd: fix heap out-of-bounds write
 in krb5_authenticate()
Message-ID: <2026101945-unlined-swizzle-11f9@gregkh>
References: <CACdWfbyqY_rUJ_Qj0HvuHGEb-PBjwj6eKYCY+r1WZtNnsWuhiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACdWfbyqY_rUJ_Qj0HvuHGEb-PBjwj6eKYCY+r1WZtNnsWuhiw@mail.gmail.com>

On Sun, Oct 18, 2026 at 12:18:33PM +0300, Ilan Dudnik wrote:
> Hi stable team,
> 
> Please consider the following upstream commit for the stable trees:
> 
>   23a0be6a84a3 ("ksmbd: fix heap out-of-bounds write in krb5_authenticate()")
> 
> It was merged in v7.3-rc1 without a Fixes: or Cc: stable tag, so it has
> not been picked up for any stable release yet.
> 
> Why it should be applied:
> When SMB2_SESSION_SETUP is processed as a non-first element of a compound
> request, krb5_authenticate() computes out_len without subtracting
> work->next_smb2_rsp_hdr_off. This overstates the remaining room in
> response_buf, so the length check in ksmbd_krb5_authenticate() passes,
> and memcpy() writes the Kerberos AP-REP blob past the end of
> response_buf into adjacent kernel heap memory. A remote client holding
> a valid Kerberos ticket for the server can trigger this during session
> setup when ksmbd Kerberos authentication is enabled.
> 
> The issue was introduced when smb2_sess_setup() started passing the
> compound-offset response buffer to krb5_authenticate() without updating
> the out_len calculation:
> 
>   Fixes: 98422bdd4cb3 ("ksmbd: fix out of bounds read in smb2_sess_setup")
> 
> Kernel versions:
> 98422bdd4cb3 was backported to all maintained stable trees, and the
> vulnerable out_len calculation is present in the latest releases of
> 7.2.y, 6.18.y, 6.12.y, 6.6.y, 6.1.y and 5.15.y. The fix is a one-line
> change. On 5.15.y the file is fs/ksmbd/smb2pdu.c instead of
> fs/smb/server/smb2pdu.c.

Now queued up, thanks.

greg k-h
