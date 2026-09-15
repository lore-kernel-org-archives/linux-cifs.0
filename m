Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D292C4334C7
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 17:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491850; cv=none; b=C3UutpZkiJO3qXt/tIPU8sAlTPzwaTWuOfDSrEL8Nip3HGW4l+2PGUnms5kFV9irCm3s1yt3Xm7/2jx8mvGYFiaPlt0lkaEhgi8pHqds0WEuIgv1IlNs7ladCZ2O+pPWXGb25QoQpDfSnGx8Cw05RH1ctkcPT0uo1JX5aumbE9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491850; c=relaxed/simple;
	bh=xO+mHj7xHXAQh0x3U4pPketPo6GinGg0pqMFuEoq9Bw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=XLI9M6OR/9zQQ2YWYCpTYahE80+hq4yOboaeQsEurhWKOyLl0i9gBiNb8lIRebs24rYiGn3+nxqrGcDvWT1g1ZrB+nivedOVxlsS4Ml0AhlyeldR/wtTBtVhQMZzQtCJorW7J1MwVEwSYefKREDoHxZjVBZWVECMYWawcRu0cMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=R4MMnCFG; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="R4MMnCFG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7QA2XEa08YiIL+VLnifStwJcGW58nR8C0now2j+cTE4=; b=R4MMnCFGS7KKu2NZn/S5/nJjIQ
	rqhpJqnkiZc8DHCAsg7a1YAG3IXWeergGWhn8RRixFqjwsfRBLTne9g8kL4ZABf4cLSQ5CDzCdEci
	U/zjchM7titM/LnkXUzePVAxTl5RIJ1Awj4T48ZaRh3OGW0AfVCKCTavgU6/08l0Z7Lz6KDX5M5zu
	uFqZ5T3v+PlDR7Uu0zhd/RWhPxPob1VsbisLtKAvhIViS5duDhOSwyK1LybuZP3//sww5+qxVM8iy
	2fQ+P9PR/ytK1+BGuVI0EXGo/tM9oUdPywD7RZDJX8z8kmKOFFXne1Ze2n+2aMl4I7+kz5EguSem1
	k9bzQ7iQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x6WZV-00000001VWH-1cum;
	Tue, 15 Sep 2026 14:03:53 -0300
Message-ID: <a392c06421904eea9a1c4ca1798591da@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linkinjeon@kernel.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, metze@samba.org,
 slow@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH cifs-utils 0/2] smbinfo: add alternate and normalized
 name queries
In-Reply-To: <20260915063429.110017-1-chenxiaosong@chenxiaosong.com>
References: <20260915063429.110017-1-chenxiaosong@chenxiaosong.com>
Date: Tue, 15 Sep 2026 14:03:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ChenXiaoSong <chenxiaosong@chenxiaosong.com> writes:

> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> ChenXiaoSong (2):
>   smbinfo: add filealternatenameinfo subcommand
>   smbinfo: add filenormalizednameinfo subcommand
>
>  bash-completion/smbinfo |  7 +++++--
>  smbinfo                 | 36 ++++++++++++++++++++++++++++++++++++
>  smbinfo.rst             |  4 ++++
>  3 files changed, 45 insertions(+), 2 deletions(-)

Applied.
