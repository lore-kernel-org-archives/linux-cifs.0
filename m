Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF608194143
	for <linux-cifs@vger.kernel.org>; Wed,  2 Oct 2024 07:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727854525; cv=none; b=MPPFcGKwOEYOCuwMuN7364Hy/m78tfdiXWKxmC872pUD6ILapOQValyAjGvMUJIwvTlPufUM4WJjrvCGVo2zjKEYndglWuPmi5duiGdcs058bHNpaX+639Amzue3Ao6bDPirpc4Lk4xGCjctytW9WgTRiCZiDCd8z9i/0H6H0fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727854525; c=relaxed/simple;
	bh=oZ6aL4xfvzQxY1YrwJ/amed0swbrWsGnS/TjQyp55GQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ktNh+wDqKXsj/5n3XNb5ULPfrZLBNAlhnsdGoqhNqBgoTqVQdxdbiU0OIazSRYciNJsONYflQOV3jufRhapREi1oCCQIVyTUd40Iw9gS89AbLxgIXQ31NWn+taa269SnqUP5tB2Atwp8B1wHToYveZMIRn+H3A2nj9yCxhAX++E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SH4dNmdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SH4dNmdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D78C4CED3;
	Wed,  2 Oct 2024 07:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727854525;
	bh=oZ6aL4xfvzQxY1YrwJ/amed0swbrWsGnS/TjQyp55GQ=;
	h=Date:From:To:Subject:From;
	b=SH4dNmdIglHxFJkZiXEjKUmBVl8TrMUB02DqIoYer0Czj7t8wivAPDoL4LlREsIMw
	 mqhhQbBxxBbAMt/FD32+ZGUVSAS/1F+Ki7O4iSL995xflgMW4076oruTsvT6fv5KQN
	 exASJ6nR7kiG1qNbMCmw9UIRDRmWV/UnxhSX8OCnNFrb2a+R4WemIXYup/oWGgKAkc
	 hUaqkgf2HEr0NszukuAo4eXEsErCxPJ/qT2z5F9dlvv8H7asq+XOarib31SpWoHitY
	 WE4kMwWbc8exhheCSmEiCWkOUupWQDPykB3t+2NNm65zCLaWtn4knYbnY5ZcP8lG5o
	 gQS/sqey5QtGA==
Received: by pali.im (Postfix)
	id 1BF7C708; Wed,  2 Oct 2024 09:35:19 +0200 (CEST)
Date: Wed, 2 Oct 2024 09:35:19 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Subject: SMB POSIX Extensions specification
Message-ID: <20241002073519.2fee66fwopzy3dpp@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716

Hello, I would like to ask, is there any normative specification of
SMB POSIX Extensions? Because I was not able to find anything in
MS-SMB2 and neither in other related documents.
