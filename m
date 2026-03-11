Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FA345758
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773242089; cv=none; b=qOVrsk/Vw4EZhPje3YP31HfmfbGWYgWiEmOvjsqDDXi6F8jUX2dpfQZIkpz6AxUNZMHi+X3FH6euBzEg76KRdUav7tRWvBDYPtrcGx+BbO/pbh8vrEYXEt3HuRTGXPfZnlZukwSS3yRluAUldMLON+sZl9B0541t2s6v19L/TYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773242089; c=relaxed/simple;
	bh=GkHRE568CEq6uP3EUVsDwzSuZhJJ0OOZzV5Dcs/sLco=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=lxQEjYFYp62jcdGk3eWD+qlx/We5KCCLw/vHaJFCAYboBnAiiyUMppfSlWNRb+2BLIJKmRe4ePHoNFML4AHgT3PN2vBwsfyM2LWqSnv89lwVGEvBHk3VlHeCw34g2UD28TBTHNSwSwf9EmIsf9dLdUFJnjqaBbj7iP2WGgwc6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=OosaFhY7; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="OosaFhY7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GkHRE568CEq6uP3EUVsDwzSuZhJJ0OOZzV5Dcs/sLco=; b=OosaFhY74IiUtN1CyaDsq51O5C
	TmGJ8QE5Q2JwovxNjIrLBP9wGmRMwa4CXkuothzEVYuhucK5xJb9coGPRab+VBoxnb5X7GLyQfErT
	SgGDjPNu/rPus3eL8mqkMIykVl5QttArZ0LCBS/rC7Ri65xjmex4ljowWS1R/jpT/UcpWIrBKsyLR
	t09jX4ks+RD7VNt2EpCbIVH2dcF06KoB1LV6UB14C2WZ9/GzIA1AuSKYOL+kbixl8KSt10aIH7u8q
	IUwAq8yAHQt+H4Dp4lEU5isCP0DN2UP2IUHeEK8aE2Dodw7GSUv2BzMt4cXjv15XiAQD7z86iGwjM
	+Rk9aM2w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w0LGl-00000000i7U-1u98;
	Wed, 11 Mar 2026 12:14:43 -0300
Message-ID: <fc6e84078205d41aa7c61241942619fe@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix open handle lookup in cifs_open()
In-Reply-To: <e7835ff7-36cf-45a5-9e38-066fb181ab22@chenxiaosong.com>
References: <20260311144055.523527-1-pc@manguebit.org>
 <e7835ff7-36cf-45a5-9e38-066fb181ab22@chenxiaosong.com>
Date: Wed, 11 Mar 2026 12:14:43 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ChenXiaoSong <chenxiaosong@chenxiaosong.com> writes:

> There is a typo here: "defeered", it should be "deferred".

Yep.

Steve, if you're going to apply it, feel free to include the typo fix as
well.
