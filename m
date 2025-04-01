Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520AE1DF261
	for <linux-cifs@vger.kernel.org>; Tue,  1 Apr 2025 19:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743536751; cv=none; b=XTuwh1vG+Wl/nJWtjoE8s2J0UXJS7GKYJ99QemZ6PJlEnW6iyB8+FfQyBXARt3nkcAy/ECPa6UAEWfgGV/C6p/+QSJ42Phu1EgxqzEljiEgBkznbZis60pQSAzlWQ5taUAwWq/0SMbJsTkgs8/IlilXMqzgIjgwGSe2GNHAVDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743536751; c=relaxed/simple;
	bh=VFTf63V1S6NRJ6QfJ6nXX1AU3NfRl/M/xSwUC7obL+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1GvofwWiu0k6Gi5lTpLKhfWlZEu3oWOdJ3ZVCdpJ0XMmSObnl4/2smlKML8jd6I9q+07Sos4GQLpAOebhNQvGhkyFayeJUeDyGoPi6E2Qpu9/6o2XIKUJJpg39HquBjUy3HWsf1Gw+HyLobZOqiERXtZ24958gKHkeSDfFnbzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLEqiZ28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLEqiZ28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DEAC4CEE5;
	Tue,  1 Apr 2025 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743536750;
	bh=VFTf63V1S6NRJ6QfJ6nXX1AU3NfRl/M/xSwUC7obL+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cLEqiZ28qYzNQz4IIBQrrbp2lT9trvcUGAWP9Wgd6cKrFuePhnrSlqdk96n28kZm8
	 QTjMhCmrunaXYxZZRIdNN1eScULcXqAqxGneqkBqbmIiLq/oZuEGU5zqA59DveRUPY
	 pY7AiYLjQ7Q4JQGrIXoEbsUiW6Ov8TT1e+05dunV9H9hA0d5GumlbpgQ5BRlRnVDk3
	 z+xAo3Gl33S3RS9PAgy400ZqnKz93X3m3EvC8k5IMRLWwnWYUuFq3B1TidyYxO7pN9
	 +jhkBHEhVhIohgTmHKpFjNyTWTMv6D/HYHd8HjlLAc9qVkm1xSbfFhw6zQih0+hhLL
	 DFFd99QG4Otkg==
Received: by pali.im (Postfix)
	id E65424AD; Tue,  1 Apr 2025 21:45:34 +0200 (CEST)
Date: Tue, 1 Apr 2025 21:45:34 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: Improve SMB2+ stat() to work also without
 FILE_READ_ATTRIBUTES
Message-ID: <20250401194534.iezt3tmlmx5xwky4@pali>
References: <CAH2r5mtEYHzvgv09ofhSyRmhZt=VsWtOpDvtSsPy=D=aHx7OdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtEYHzvgv09ofhSyRmhZt=VsWtOpDvtSsPy=D=aHx7OdA@mail.gmail.com>
User-Agent: NeoMutt/20180716

Hello, yes, I have simple reproducer for this issue. I wrote it in the
cover letter of the patch series which contains this patch and which I
have already sent to the list. Reproducer is available at the link:

cifs: Improve access without FILE_READ_ATTRIBUTES permission
https://lore.kernel.org/linux-cifs/20241222132029.23431-1-pali@kernel.org/

On Tuesday 01 April 2025 04:56:24 Steve French wrote:
> Pali,
> Do you have a reproduction example for "cifs: Improve SMB2+ stat() to
> work also without
>  FILE_READ_ATTRIBUTES"   ?
> 
> -- 
> Thanks,
> 
> Steve
