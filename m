Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA062063E2
	for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472420; cv=none; b=MH9xqWjMv+PZX32+XA2zWbt2wMngyj+UWHjQswR2X0FBLa3BY9RaxzCN7+2LdaBUu/IHIUWoRsiqeTOkX9RuZ3//UnWv8Co13vW5Ph7g7FwZ0vt4pcH1BSe1s9wHu62AzYIaRaACPi0XrLSyo77Bwg86CWK65LiZHvV0bjAOb5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472420; c=relaxed/simple;
	bh=BQub891vhjxVUrFv06nqtYqjs3dNPrn0nefFVa7SG6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VH+i5mZ+vVJEJI5pTneyq6JhdAwSrtwZupEI/994C3kPJu3yLTypZX6Gmdd926P8fu7M8rpei4xXvPGKXxBMI+zVny27AUFfHa8l/PHlEIpbkqcA4E8FofEG6/rJzE0Vi4a2U7o8R2Hlj6Pw+4paJUj18q5Rt3yqNCIOMwkSnYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/m1aYwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/m1aYwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD5FC4CED1;
	Thu, 13 Feb 2025 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739472419;
	bh=BQub891vhjxVUrFv06nqtYqjs3dNPrn0nefFVa7SG6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o/m1aYwuFbfxHpd1rEjR2ZqgETwm+PZVK905Dh0s1R7w8lOBhisi+00i5U1XfGYGZ
	 AYDh0M6/7c12+OyLCc9rITSiE8veuf+L0MKsFRmMMNCuqiF6CeUSdOTJQWEQxkg2z/
	 NDigY670yHRUTYF8MINfKeKABuUglw4BT6o2ABQJn0ynXqbTMrlc6ywf9eaaxgycaW
	 6cy5FEksR0V6EIWshKKDAf4Fegf6EmJG7xrGKAOGzZbzephLrGfbP5bIVoEIeeDpEy
	 q9ukH+qxCeXx6KiZuMQavyumFHTrJNgUMaoMR091kGJj4ygENT3S6m9Kp/cUGVz0Nk
	 b1BXQMUbxTp3Q==
Received: by pali.im (Postfix)
	id 1BAFE732; Thu, 13 Feb 2025 19:46:47 +0100 (CET)
Date: Thu, 13 Feb 2025 19:46:47 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250213184646.5qydqtgpjh3do7s6@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250212224330.g7wmpd225fripkit@pali>
 <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
 <CAH2r5mtzwOtokQjbX9NzzB6G==t5Wq3Xqz=-K+qqLuBnoKB15g@mail.gmail.com>
 <20250213000234.s5ugs57chvi7g7pa@pali>
 <CAH2r5mvvgoGvvgpBj09zCA1G=Heca3if8x41cuthmUxGTdNgRw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvvgoGvvgpBj09zCA1G=Heca3if8x41cuthmUxGTdNgRw@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Wednesday 12 February 2025 20:46:35 Steve French wrote:
> ok - how about this updated patch to getcifsacl?

Looks good.

As an additional improvement it would be nice to show exact reason what
is missing in error message - missing SeSecurityPrivilege privilege.
Because just generic error "Insufficient priviledges" does not say what
exactly is missing.
