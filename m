Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D8B16B74F
	for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2024 10:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724842558; cv=none; b=ZK5gpbsTGH/NazvemN4RJzCj4QZgaiv/3UA0NGsq/ifnOVjGH7SX8L9x+CagZARtyG11qRonsk2x2MAKc52UosVSQMT/v6zYX8DtQDUhTtRWpfFrrrXnY2hICbQeW37KqqNxQz3BEv0Dcg4ie6yMEKw5fmmyduA5SBphLTotN7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724842558; c=relaxed/simple;
	bh=eeJVyFTkDVBc37eWbaJ8sYC29fBaKsXjsnFee8Hn4Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VbFKA4R9O2fE2KJjMHHloDW2Qp4PFXuDTJc7wQs/PyXVp5E2zR8YOYb+mVdUrBnxrNehT7vUVuXWpt5m24nId/+6n0iZgwcbUmZmaIE3Tj/OFCJDVEJszy5bnQ4ZRQ6DwXOHxhlS2mBUuGLkokPuZn7kfkM89X1yxPqsXVXGep0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=r3WIZjQn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="r3WIZjQn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=viXF4mtCe5yUB1cEJcB012lnBYtOALsGjjhQjsGDepc=; b=r3WIZjQn+RF3TDhQBaqctoDcgy
	QpjzOsVSn43jKZFH1t3smOj608kmDgclTL/L5Q32qHfWmZrXab0OrmB5P4ARV+3Y7fORihl977Kc2
	rht5Qb0hqsj9FAA0VR1FqAGxHN2FZEzAlpx8xVSaEJZaU4I56Z3uFZGoPLosLzJjk0Pg253EXUs7q
	cPNSM2lO0x5na6TUS0/YaPJY2O9yKOkOpcJwJ7JrckxOo4HmaLHY/B2uXAkZ8f3nN2RvaX934XemX
	h/nXnEs9GmVS1eg+vTUXYWiXOB7yuxVO5+PBEukDDQUmE5VceYDnJ0YtbE9qpUB+YDAxYiJ9E5qni
	BJ0xdQHzwSLrB9KqURejbCZz30L2lFK6AK9ZPWhzScWYG/T/3L84rfDRg+RJHPU1TK0io6K0T+WqN
	4fsgb4NXcuviK5UX2c3IxJS1eC/LV5mz36dSEPxmeuDcYKu133d6AXSBbnF5wbaxDJdJaKHyMXJ+0
	2J/Gbgq6T33pGFaZPi0Qd7Bn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sjGL4-008mHu-2G;
	Wed, 28 Aug 2024 10:55:47 +0000
Date: Wed, 28 Aug 2024 10:55:36 +0000
From: David Disseldorp <ddiss@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Jeremy Allison <jra@samba.org>, Paulo Alcantara <pc@manguebit.com>, Tom
 Talpey <tom@talpey.com>, ronnie sahlberg <ronniesahlberg@gmail.com>, David
 Howells via samba-technical <samba-technical@lists.samba.org>, Steve French
 <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Message-ID: <20240828105536.1e6226df.ddiss@samba.org>
In-Reply-To: <951877.1724840740@warthog.procyon.org.uk>
References: <20240823132052.3f591f2f.ddiss@samba.org>
	<Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
	<CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
	<20240522185305.69e04dab@echidna>
	<349671.1716335639@warthog.procyon.org.uk>
	<370800.1716374185@warthog.procyon.org.uk>
	<20240523145420.5bf49110@echidna>
	<CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
	<476489.1716445261@warthog.procyon.org.uk>
	<477167.1716446208@warthog.procyon.org.uk>
	<6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
	<af49124840aa5960107772673f807f88@manguebit.com>
	<319947.1724365560@warthog.procyon.org.uk>
	<951877.1724840740@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi David,

On Wed, 28 Aug 2024 11:25:40 +0100, David Howells wrote:

> Hi David,
> 
> I tried to apply the patch to the Fedora samba rpm, but I get:
> 
> mold: error: undefined symbol: torture_assert_size_equal
> >>> referenced by <artificial>
> >>>               /tmp/ccVA4FUD.ltrans35.ltrans.o:(test_ioctl_sparse_qar_truncated.lto_priv.0)
> >>> referenced by <artificial>
> >>>               /tmp/ccVA4FUD.ltrans35.ltrans.o:(test_ioctl_sparse_qar_truncated.lto_priv.0)
> >>> referenced by <artificial>
> >>>               /tmp/ccVA4FUD.ltrans35.ltrans.o:(test_ioctl_sparse_qar_truncated.lto_priv.0)  
> collect2: error: ld returned 1 exit status

I've no idea which Samba version Fedora ships.
torture_assert_size_equal() was added to lib/torture/torture.h via
46f0c2696582 (samba >= 4.20.0).

> Do I actually need the torture test patch?

No, not if you can use your xfstests reproducer. The server fix is now
in Samba's master branch as commit 5e278a52646 ("smb2_ioctl: fix
truncated FSCTL_QUERY_ALLOCATED_RANGES responses").
