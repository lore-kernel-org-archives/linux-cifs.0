Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A29E4A5ECC;
	Wed,  2 Sep 2026 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373824; cv=none; b=IOoNZaoTJM0jwplhUunbPsd7WZ+BsYgKOs7WivyWSvhfca/l/wqmV5zOw14Gy5gUemjUgxMZVn7tF8dUpbE5FspUqKhfiSqSGb/kEOYrN4es6n32d8Z3C4pzWIL4k0n8iQPx3BkNer/ZkbA4Nu8IaYP13IaaclUlD2RD/eroRs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373824; c=relaxed/simple;
	bh=2sFXgXNjXISahYP2v+qJ5JWgKNOKFTCn6JH5VenmoMc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=cSJ98XGuSRvRdIyhDI9Ifb4756oOgm3taZjY1gIGDX6Xo5K77IK0/zFY6+NktcJZmlpLMOUP/GdvlrDIhdlyPUReEM1NgF8hKru4EcvmUk91YUYXaEb1NlmA+maB3I1cVbWFdL6OL5Oqafcw1MobkoDUDc83QJXKIC40jPYGp/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=L38RPkKD; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="L38RPkKD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2sFXgXNjXISahYP2v+qJ5JWgKNOKFTCn6JH5VenmoMc=; b=L38RPkKDir2YkXG9QstvrWLyY+
	3NRHsbiAPZdiZEvwCNR3M3X/Rqgqrtt5Gt5f0x+0cGR+1fk13tZPXnh4p+yF0YIbsfy4nRgLLIu6g
	jqp/eMkGPwQhva4dF2Ce6grfu85Ru/sMSjljm8UstICv4ZZGGcvlVNw1Ar5CeIQbQbNKqtzqw4iNB
	CYWWxpueLeHTnnk1Vmam2SoHO2dDqXUUW/4FjMhdusofCG+QZ+sfXKJpfMPjF8OHDQ5UUMwj/KNc2
	p9lD2qcxN5xDTl34ZTahwxDKEQKlQ+emwJ8sHlWfHfM1O5+8UtMRdNOjP5wLQh0eXmydFPx08o4bT
	NCLDsiZA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1pj1-00000000XRq-057G;
	Wed, 02 Sep 2026 15:30:19 -0300
Message-ID: <e2ec5a5c07bcd549fc9b6a595bcfab31@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Diego Oliva <diego@bynar.io>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] smb: client: fix out-of-bounds reads in
 CIFSSMBRead()
In-Reply-To: <20260902104207.1820332-1-diego@bynar.io>
References: <20260902104207.1820332-1-diego@bynar.io>
Date: Wed, 02 Sep 2026 15:30:18 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Diego Oliva <diego@bynar.io> writes:

> CIFSSMBRead() parses the server's READ_RSP without validating either
> the length of the response or the DataOffset it carries. A malicious
> or compromised SMB1 server can exploit either to read past the end of
> the receive buffer, leaking adjacent kernel heap into the caller's
> read buffer or oopsing on unmapped memory. SMB1 is not negotiated by
> default; reaching this code requires an explicit vers=1.0 mount.
>
> Patch 1 rejects responses too short to contain a whole READ_RSP, so
> the header fields can be dereferenced safely. Patch 2 ejects a
> DataOffset/DataLength pair that falls outside the received response.
> ....

Applied.
