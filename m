Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965C218A6BA
	for <linux-cifs@vger.kernel.org>; Wed,  5 Feb 2025 18:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738780495; cv=none; b=VHzYqQ3bA2z76uA7IG7M7M0qZd5/ml8aThzxmZiDCkpcTeep6XRlwneCaFrgYzldUJUJdEoylGcseLhn5SMHYA0bx+T8z7+N6qFV4f0gO/Si0VKDKemogMK1CxPfHd2+ZRZ1jhi3tRi4x1CVOcK0WIrscjo5iIfSe6AOPfkoT50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738780495; c=relaxed/simple;
	bh=9Djz68Ef2GetdKjbvCz8sQksPWSYndVS/pvswPoHL5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRpI6Pk1xfpohX0rQKhTpaJXIscWzqdYO6Wg5G+yLcKlWbHU12M4h16asNE/YqFcOtdXI35VoMWKEYBa8p9futpD+gbmIS0PhN78GAy7UxuUJGLEHdIUF7Ha+0FSi1+qmXgob+GN+5rOquGNVceg3ayySTAzgglYLaaMkdq9DEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hph1OM9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hph1OM9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14F5C4CED1;
	Wed,  5 Feb 2025 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738780494;
	bh=9Djz68Ef2GetdKjbvCz8sQksPWSYndVS/pvswPoHL5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hph1OM9e0qVskNqfo6ulC7bzTOGTrRO9da+RPyUAVMN0b35yUGfTUcCGB/AGsck1g
	 wg1cUy0KlXSf0Rpkw8JAKsKQa9J9a1lObd4zQGhJUgeo/9Q3D6iY1poMO5eVybNEL8
	 KXMd3rA4z8gU+qRFH1d2z4wbubk8GDfPy4flDRshcmGLN0kkkYfbR/whE2GMilECdV
	 g6OYpxUJcMdP9TPB2aWmS2G7WTikZoqm/Y12sFwqxbkr3K9hXYCTLydyFW1uv8wgZM
	 e7A9bK1Tpl8Q0XKhAD2qgysGucrwIpNmTwc7j7cEQVxsIzO41sitE0iCr/1+5JqaAv
	 GzSADwlzk4LSw==
Received: by pali.im (Postfix)
	id BE4474FC; Wed,  5 Feb 2025 19:34:42 +0100 (CET)
Date: Wed, 5 Feb 2025 19:34:42 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 12/43] cifs: Throw -EOPNOTSUPP error on unsupported
 reparse
Message-ID: <20250205183442.ajdrg7onq3qekzxl@pali>
References: <CAH2r5msCiefg1fo+p7hsAMc14mkL2fc+rD5pHRKOuPFrJ9MK8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msCiefg1fo+p7hsAMc14mkL2fc+rD5pHRKOuPFrJ9MK8w@mail.gmail.com>
User-Agent: NeoMutt/20180716

This change is dependency for followup patch "cifs: Treat unhandled
directory name surrogate reparse points as mount directory nodes".
Without it that followup patch would not get information if the reparse
point was handled or not. It is visible in the original patch series:
https://lore.kernel.org/linux-cifs/20241222145845.23801-1-pali@kernel.org/t/#u

On Tuesday 04 February 2025 18:22:35 Steve French wrote:
> Do you have an easy repro scenario for the attached patch of Pali's
> (e.g. creating on windows, a reparse point that will be unhandled on
> Linux)?
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
