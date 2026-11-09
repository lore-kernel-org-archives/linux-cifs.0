Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182631;
	b=a+dMSzN4oTH25iSMD/aW39vIwUyIXfZtB+5P7gaWX0fxtwA8vFhqwYNDKkg+2adVB4MP
	 Mpo7NZmsJpFawwemV8hWMAZpwB4HERmi8lMNGJrquKaebAFuAf3JDAp/egy4Pny2nDj0f
	 LmBqg93zKw5/Od/ndGB2whGznFyZdg6dezPLj3INzXVYAUpK/grJ2AT0xSL2QS6QWVvm9
	 l3SZh+dDBImHpFq2+/07CUu37LjNv4SKFwtUnwvspVG+Yul1ynTgIyGa06J1vaMEiwVWb
	 b9wPvZHc0yHqUITyTAFHpJ1haYDZjUJvcWj8++/TB0Y43L7LCILTFivxm/01RsAvU8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182631;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=ODTF0cDRVwlrau7uwcX5XTBCExmhXrf291CBYIlFVmI=;
	b=V9u7bdpXidhlo7eqdHGExoYwKkUvcCnq0gqDjz1+gpSvMNbQ8lg6Ef0vMmqIArhA2mTL
	 NIt1owKY24EkgGpeAUVWpwXhMchGHbCJT9KUD3Dt/eYBNnw7Lp1DDLwXgYxLRm2oA0p3E
	 XT7JP7Ztm3Vh4AYsZsQrkaYxbMHeT/QiG+pC58pqr/SwcxNTuOUbiQvkvyiaAoPoRL2fB
	 9sqEx4W2pXaERJ+WzUb1/WGunNSq7OP8eVJN61Im/oaHCIo1c1zvzou749pkBGF/8MweD
	 kfoY/yekzLbtxfVZ2HLRKWdNIxDi+EboVdlSh6PhHo0f4h5p2eRNQuLT/IJzWEvzkEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=BtUNW4Dh;
	arc=none smtp.remote-ip=79.135.106.119
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224F0606A320;
	Mon,  9 Nov 2026 00:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 224F0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=BtUNW4Dh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1794182628; x=1794441828;
	bh=ODTF0cDRVwlrau7uwcX5XTBCExmhXrf291CBYIlFVmI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=BtUNW4DhcOA9ljJSoLW4mtiLMz1y3/qX0nMGoZmPmE3emnS3o9jbB+Whr9V5ZOKUa
	 1Ow4DLrhm+3uva4DoY1RTLBURRAbVCEexumH3PmNlrlRofp1jqeOFVuBa78RYrlm3B
	 SLfmFvPLxu4KQ7eAFeSaY5oX5fAuhvgrgTI9BaGL9x9vOZd6b8pC3VidVXPN4jUo4w
	 NWuG4yeZpT/RDPEiB9ck/VD9ZNKNqhbFZhmjj+tJDYTSssTj2O7fvwdz9Z8xUlLWxf
	 QH1Vg0mnRTO7+qRy9oamEXP8AOxy+mY6jqqmkeainsFh7LQ/tjKYt4Mf4ZhXwhesoq
	 +uyCMezErgH1Q==
Date: Mon, 09 Nov 2026 00:03:43 +0000
To: Ian Bridges <icb@fastmail.org>
From: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: linkinjeon@kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksmbd: check sign flag of the current compound command
Message-ID: <-QLU4zFGZ8GTUEjE-z3GTtV3Vf99uHaK_Rvr6Y8NNDQ0vlTDM_QhFEVuNJg1vZgr245i0MeNnauJTVQGvLyJvzfW8wLVuUjqziqYmczA1zs=@proton.me>
In-Reply-To: <20261108235457.1919632-1-icb@fastmail.org>
References: <IQLTi_rZrPgaD4zlFXgSybFdR3EsaBQVIorCAH3otR3SGOlNjacAL7jt2xb4mhqNNcdBMPel5CrrBxTOsKoRIFuil5wToLwoYXtR8AJ9vF8=@proton.me> <20261108235457.1919632-1-icb@fastmail.org>
Feedback-ID: 186545857:user:proton
X-Pm-Message-ID: 1fa33cbad8ec0aab5b598c6487e05bc1a16d1e30
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ian,

Thanks for checking both paths and testing this. I missed that the response=
-signing call happens after the request offset advances. Please don't apply=
 this version; the request and response paths need to be handled separately=
.

Thanks,
Noah
