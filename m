Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EFE2E3B15;
	Wed, 25 Feb 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772056394; cv=none; b=oeOPDbRaG3mFgIqOmtFn3V/DyLpGvS9GB2DHuYdAdhS0FCoAAP8gt6SLVxLgvayqp2koWeElrbN2EZSo4/UqV2NZeuyPAWA15sWKOdZYQ/G/ybXjVUTjuCo28uTqECHyor4KYreOCFpcPb/WHpcy5XZTwZ5KqXDn5Wouez8Nuds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772056394; c=relaxed/simple;
	bh=ngkxbF9p/Ks5NDUgIRotTSx0LgZaqTKY/4iAP44uvNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQt8KG0i38TeSPfswjmbhwwky4yopIvJrOTZdE6n8jMXm35xkWQQkkaDmqalI99lZDi++Cc+8qTLhjXFFbNZQ7AfHgpo0K3bQ+8JnPl31A1DN9utNkpW/r5TBUM8SEvETyakuUecn/7OyzUaWEMjaSFs2/Q7QULN4WxZYuM3e5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hHQvwfkS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hHQvwfkS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=a6oaRNyr6mu+qEfuVtfqg3VGjTMB/Odz9rQ5aiUlZ7g=; b=hHQvwfkSEXkWPjY4hLA5HBsFOk
	ytEH+ILNZWBkpxti0Z7wB+OST0qYraGdEOoBbo+F/auUoQ2wvRr/aRD1nl3b7oWWtcrTqE7z7InJM
	xW0ghVTEhMi7J3LST1cmG1tixKNglv9OgriDt9CFfXfoJneamZv0N/w4IibD76hUFwCX6ENPNVpdf
	nL9bGvAUa28yJzQMNIwicqcCVjg5cCzi/eoYZVLkjIP6r1TEDf/M638+G/7HSMXQw44v/ZB8x12pe
	9L6PvJvsTf52x5nRp2z9IuFtiThKzjO1T3+HNyPMgyO3scvjwGX/0NKy2zmd84BVyP2Ym9t3kJrkh
	3K6bnyQg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvMoh-00000004xmx-0czJ;
	Wed, 25 Feb 2026 21:53:11 +0000
Message-ID: <2cb12a60-32f1-4656-8a9f-305bd0be069e@infradead.org>
Date: Wed, 25 Feb 2026 13:53:10 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: Denis Nuja <dnuja@enakta.com>, linux-cifs@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, stfrench@microsoft.com,
 Ned Pyle <ned.pyle@tuxera.com>
References: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 2/25/26 8:08 AM, Denis Nuja wrote:
> Hi everyone
> 
> CONFIG_CIFS_SMB_DIRECT cannot be enabled when CONFIG_CIFS=m and
> CONFIG_INFINIBAND=m, despite all declared dependencies being
> satisfied. The option is silently dropped by olddefconfig and
> menuconfig refuses to save it, even though menuconfig displays it as
> [*] (enabled).
> 
> Kernel version: 6.4.0
> 
> File: fs/smb/client/Kconfig
> 
> Current dependency:
> 
> if CIFS
> config CIFS_SMB_DIRECT
>     bool "SMB Direct support"
>     depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y
> && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
> 
> Root cause:
> 
> CIFS_SMB_DIRECT is declared as bool (values: n or y only). With CIFS=m
> and INFINIBAND=m, the left side of the || expression evaluates to:
> 
> CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS
> = m && m && y = m

Where do you get the last "y = m" part?

xconfig says: (This is 7.0-rc1. Guess I'll check 6.4.0 also.)

Prompt: SMB Direct support
Depends on: NETWORK_FILESYSTEMS [=y] && CIFS [=m] && (CIFS [=m]=m [=m] && INFINIBAND [=m] && INFINIBAND_ADDR_TRANS [=y] || CIFS [=m]=y [=y] && INFINIBAND [=m]=y [=y] && INFINIBAND_ADDR_TRANS [=y])

so my .config has:
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SWN_UPCALL is not set
CONFIG_CIFS_SMB_DIRECT=y
# CONFIG_CIFS_COMPRESSION is not set

Working in 7.0-rc1.
What am I missing?


> The result is m (tristate), but since CIFS_SMB_DIRECT is a bool, the
> Kconfig engine coerces m to n and silently drops the option. The right
> side of the || requires CIFS=y && INFINIBAND=y which forces both to be
> built-in — an unnecessarily restrictive requirement.
> 
> Additionally, the CIFS=m/y conditions inside the depends on are
> redundant since the option is already inside an if CIFS block, which
> handles that guard.
> 
> Observed behaviour:
> 
> menuconfig shows [*] SMB Direct support (appears enabled)
> Saving from menuconfig does not write CONFIG_CIFS_SMB_DIRECT=y to .config
> olddefconfig emits warning: override: reassigning to symbol
> CIFS_SMB_DIRECT and drops it
> scripts/config --enable CONFIG_CIFS_SMB_DIRECT silently has no effect
> 
> Proposed fix:
> 
> Since the option is inside if CIFS, the CIFS=m/y conditions are
> redundant. The dependency should simply be:
> 
> - depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y
> && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
> + depends on INFINIBAND && INFINIBAND_ADDR_TRANS
> 
> This correctly expresses the intent (RDMA stack must be present)
> without the tristate/bool coercion problem, and is consistent with how
> the surrounding if CIFS block already guards the option.
> 
> The same issue affects CONFIG_CIFS_FSCACHE on line 191 with an
> identical pattern:
> 
> depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
> 
> which should also be simplified to:
> 
> depends on FSCACHE
> 
> To reproduce:
> 
> # Start with a config where CONFIG_CIFS=m, CONFIG_INFINIBAND=m
> scripts/config --enable CONFIG_CIFS_SMB_DIRECT
> make olddefconfig
> grep SMBDIRECT .config   # empty — option was dropped
> 
> 
> Cheers
> Denis
> Enakta Labs
> 

-- 
~Randy

