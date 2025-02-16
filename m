Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6513C7E1
	for <linux-cifs@vger.kernel.org>; Sun, 16 Feb 2025 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739734041; cv=none; b=GBKeVrznMxlEiSGXImizXofSlGpYOR4dDg0Z4/eiPt6YrlcqK+ThDX2W+hQWH7KSenzhn0Z5EoVrsR4vNmZHtxyn1EH1IZvKjpMWAMIAi03bGxOmJ8shz9Xi1jRIbI5KkMGDGei05B2fgiVSey+/xfWcuepTbdKG7HWsdE4CL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739734041; c=relaxed/simple;
	bh=4ex8RcfQu7IHFZxFinFZN7TlSMIqiyusL8wDkw98VtU=;
	h=Message-Id:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=twaKTPAMEgAZmj2S5DVTU9QMiSdYQcroBg9gLbeFnMJMTJDfIrz34oISKWoI9n61QK/ULjeHEhXlF40n0Kztix2J74WdbA4/3OM/j2PbdaovN9QXE6AycJ7QAZKdMtMD/EX/Hb42K3RDM2J45mrG4+xeYf368AUEInu4uIpTBvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=WntFwhUb; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="WntFwhUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1739733603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=XH72tr2idvIk+UOVMGDZP86K+TrBz1B/SN42+v4PqjM=;
	b=WntFwhUbh9kaRhIxZR7/ouELCb1P/J9jwl9SQWmb5Tl0bSfdaZnYQxUJ6sKLyYacrUHiOB
	JGRaA9HQLNX1nhD9SV1A3Q0iUK1G/47TD4DfevdTq9OdJC4YUAEEVAVsm/Uzx+m7Wub/cb
	rTWe6ErWVRhLaPdmxE7TYOaBiu8M9zh8atEoojjPVjF/+2x9kWekDXiG25VgO0NweghkOX
	kpSeqYyldxZ5riB3qCg23Jpl6Cba/dg6/XgxW4eSVMOvN8mBVIfSjZaL0uXYWvViqHfiJs
	+T/3NQ9HmiQw8G0T+1hDu76heB5NhBufqstWcXRNGK2Agfy079n/6Eud9j8W5w==
Message-Id: <41f6d054f2c0a153cdef56de053e109dc3a85952.camel@rx2.rx-server.de>
Subject: Re: man: Incorrect description of mapchars and mapposix
From: Philipp Kerling <pkerling@casix.org>
To: e.bachmakov@gmail.com
Cc: linux-cifs@vger.kernel.org
Date: Sun, 16 Feb 2025 20:20:03 +0100
In-Reply-To: <CADCRUiMn_2Vk3HZzU0WKu3xPgo1P-1aqDy+NjEzOz03W-HFChw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

I am pretty sure you are right, I also noticed this behavior trying to
debug some name mangling issues that I head.

In addition, the description that "nomapchars" is the "default"
behavior is also wrong. Inspecting smb3_init_fs_context in the kernel
source (as of 6.13), it says "default to SFM style remapping of seven
reserved characters unless user overrides it or we negotiate CIFS POSIX
where  it is unnecessary."
Also, the SFM style remapping does a bit more than documented. It also
converts double quotes (") in all positions and space and period chars
at the end of path components.

As far as I can tell, The Linux kernel documentation at
https://docs.kernel.org/admin-guide/cifs/usage.html has the same
issues.

I'm willing to propose changes to the documentation if someone can
confirm that the above statements are indeed correct.

