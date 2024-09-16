Received: from mail.sernet.de (mail.sernet.de [185.199.217.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E621553B7
	for <linux-cifs@vger.kernel.org>; Mon, 16 Sep 2024 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.199.217.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726491964; cv=none; b=Omp6U1QkhbBp8cQ0rhmQ4RDpiZilYlfK5rIGCJwAuwhBEs3o3rGIqxcASpNIIP+gaQNbFDs+63w+yyvsKbU6FsOqjw0b52/QiJi5F4HiI5atrSmymV1tLHJ0d37wvahTAGkMG43WbPRK2VIETOYHbYPmdptjHHNxpYudFSZX6oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726491964; c=relaxed/simple;
	bh=JMB8/IfZwoSdI8FZjHsZ2i4OX9I21AUmJE+1ys9Yx7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2O6lTrF+dh2ajmMl3LEWJcfxaEZQQSWVBfCnOQlPA9FjQmwo2XPVw0fmD0EIXWnWwjvOwt9E7RjgygvP7jPN66Dunihpedd5OcbzG9NNZBcQmybqLkHouFrxT9VtBQPB/kw4t9nzhddIlJHt4hcAVVkxErElXNJDQEcYG9Q7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sernet.de; spf=pass smtp.mailfrom=sernet.de; dkim=pass (2048-bit key) header.d=sernet.de header.i=@sernet.de header.b=VHfLt0v2; dkim=permerror (0-bit key) header.d=sernet.de header.i=@sernet.de header.b=QPBpFn71; arc=none smtp.client-ip=185.199.217.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sernet.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sernet.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sernet.de header.i=@sernet.de header.b="VHfLt0v2";
	dkim=permerror (0-bit key) header.d=sernet.de header.i=@sernet.de header.b="QPBpFn71"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
	s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JMB8/IfZwoSdI8FZjHsZ2i4OX9I21AUmJE+1ys9Yx7s=; b=VHfLt0v2tKP+D4OaTgz/Ac0FML
	Elzy8JViECVZOWn0GFRHakgGlysb+hRs6Eqn8/SemiGZ35hwHZIO3kPxNBM233ZPzuUi7zPne/0Pi
	D1T1Kg3lR5rq5D7ZBk15Lw2+7BNmEt6MMfaH9YgI2U3kbiMxZafCS3mGEL/Bgp1ENPoi+xzl9YTcy
	2L5xCqn+ouHod/FfADPESGj2Ief8TNrSTtYPLrVSk1c5C80+ZX/JvY6lXCMjQyjMMs7kHBMF9K11m
	PgRjzXkcKn+rQ/UA9c5MjLh/8C2CZhMBt7GN3zU1FZ3UUb5pHfexopGdnRwc2YeUrAoY48rDzNn+O
	byPHlpMg==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Reply-To:Message-ID:Subject:Cc:To:From:
	Date:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JMB8/IfZwoSdI8FZjHsZ2i4OX9I21AUmJE+1ys9Yx7s=; b=QPBpFn71Ag4ERCCLuTp1Zp9Uwk
	Q2zKNPn1HJC39a5uQIGy0//otoWrdGZw2VaEThk1mvS88TAcmyHhiC3mt0Bw==;
Date: Mon, 16 Sep 2024 14:51:49 +0200
From: Volker Lendecke <Volker.Lendecke@sernet.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special
 files
Message-ID: <Zugp5RiYKqFUW_bk@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
References: <20240912120548.15877-1-pali@kernel.org>
 <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali>
 <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
 <20240913224248.k5tn2le3gau2prmo@pali>
 <CAH2r5mtgV=NkZVChDY-apdqkvM9KFkraRGy_jDCpLmFU6PFMAA@mail.gmail.com>
 <20240914081742.wlldjjlogrmk533i@pali>
 <20240915174126.ilxwoxlsfakgnl7d@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240915174126.ilxwoxlsfakgnl7d@pali>

Hello Pali,

Am Sun, Sep 15, 2024 at 07:41:26PM +0200 schrieb Pali Rohár:
> Now I have figured out that even the latest Windows Server 2022 version
> provides interoperability of FIFOs in SFU format with Windows NFS 4.1
> Server. So if you configure on Windows Server 2022 one share which is
> exported over SMB and also NFS at the same time, and over SMB you create
> SFU-style fifo, then Windows NFS4.1 server recognize it and properly
> reports nfs4type as NFS4FIFO for NFSv4.1 client.

it might work in this direction. However, in my tests if you create a
fifo over NFS you end up with a NFS-style reparse point, which is much
less prone to misinterpretation. So my suggestion would be to use the
way that Microsoft properly documented in

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ff4df658-7f27-476a-8025-4074c0121eec

for anything that is newly created on all servers that can do reparse
points. For servers that don't support reparse points, WSL might be an
alternative. For me it would be highly confusing to add yet another
representation of unix special files from new code.

Reading existing special files -- sure, where strictly required for
compat reasons. Creating them? No. Too many options make the test
matrix explode.

Volker
