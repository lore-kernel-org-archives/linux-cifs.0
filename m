Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3915C3611E;
	Sat, 10 Feb 2024 10:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707560389; cv=none; b=I9Sx+B66VUsjelUezwtSxdQ8MqDlpC1+Nfqk9PYBSJxwC+LC/4M6Eiyj2zmPONPPQ2ElbhIV+SWhqKDLe7ucoOTa6bxMqfTPtGk+gKZDUAatXFOGqOseLycx4Bw3nUPfutAEzcWAs9gTgk28hhvJ4QfdHxuWavWy05CDKhHXDFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707560389; c=relaxed/simple;
	bh=U4L/V+ABFf+Rk1CyuuovGhbfOcNDDFyBQe+o6V1dDQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YsyflUziVwFrKQc42dRgskUWueEgpMs7osQTepUPJx+pFkXWG2lmhhZY+htg5IvTIPbfOA/j7UweN2CAKUtOuU6/FH/NC+MYXcHocrRrYeGZpAFXVjfsagHWgV8fj7+QghNUygiruOboJVJZUYyMUB1Ahi70X4lsUDNfFLDbVU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHah1jB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHah1jB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B300C433F1;
	Sat, 10 Feb 2024 10:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707560388;
	bh=U4L/V+ABFf+Rk1CyuuovGhbfOcNDDFyBQe+o6V1dDQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WHah1jB97SgtPCNqsQrn1Ea0m8qois01ICUpo9qlNYTWX+smgRQ5hzaJV5cbQfv0Y
	 66/lgNZ23i0hxRiHg9zi0JBUtEh/iY6qsvNLV4+xi7XKdgqHYsKnLgg8xk32vaVEWY
	 WcITKsvBi8vqCGXqGa4a9PzMAtjQzfxGk0sUyyEk=
Date: Sat, 10 Feb 2024 10:19:46 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Convert struct fealist away from 1-element array
Message-ID: <2024021034-populace-aerospace-03f3@gregkh>
References: <20230215000832.never.591-kees@kernel.org>
 <qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf>
 <202402091559.52D7C2AC@keescook>
 <20240210003314.jyrvg57z6ox3is5u@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240210003314.jyrvg57z6ox3is5u@altlinux.org>

On Sat, Feb 10, 2024 at 03:33:14AM +0300, Vitaly Chikunov wrote:
> Greg, Sasha,
> 
> Can you please backport this commit (below) to a stable 6.1.y tree, it's
> confirmed be Kees this could cause kernel panic due to false positive
> strncpy fortify, and this is already happened for some users.

What is the git commit id?

thanks,

greg k-h
