Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449B8254B19;
	Thu, 27 Nov 2025 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764256735; cv=none; b=czUlsgWaavEBmn+ndWq1zTGpTjUQ8WszYEYRN7R73zFvhQYjTL1blE1agBgorMj61a4XFz1nVgcm6mKCuc52pZYqkxKwMlQ6QuqsKFcefg4nZ79xw1f9nW0Cr+4YbELANf2eEYDqVZFYFc71HSFlDFh2zouzfswslkJE72nLxww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764256735; c=relaxed/simple;
	bh=sS5MayRuwaBDIf1Xv4Hog5CeNsnowy/D2E7pG9bsmrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIM1b427v2RGLgmxxOGmtj+TVFVt8Yg+WMGPGFcepEevA9Un/wL8vBNDHWuYxW+YOCdkSR/gKEcTaXL95ePXwTHpltkVSC4pYtAxObDKJeGK+/41LToPmzO3ZDPL/9m2t9R13H5RRT3GZJnTfBZ6WTR5En3DjPZ1116E4uSjOUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZW50s/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZW50s/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54217C4CEF8;
	Thu, 27 Nov 2025 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764256734;
	bh=sS5MayRuwaBDIf1Xv4Hog5CeNsnowy/D2E7pG9bsmrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZW50s/HsO7ssHWLE8PPMsFj0FdezxGZohN7aU6BGLkkocywJbpm/j9r3KH6//0mv
	 02EUH+bL/gpoS+/jZPT6AY8P8Tou5HkmP99fqBW869bMHoSw45luB4N+pN8ORsWPok
	 PCv/cPmyQo1Q9oqMorbzP04QNri5oIQ8M55h7xSs=
Date: Thu, 27 Nov 2025 16:18:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nazar Kalashnikov <sivartiwe@gmail.com>
Cc: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	Sean Heelan <seanheelan@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 6.1] ksmbd: fix use-after-free in session logoff
Message-ID: <2025112735-vertigo-jujitsu-4647@gregkh>
References: <20251127150512.106552-1-nkalashnikov@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127150512.106552-1-nkalashnikov@astralinux.ru>

On Thu, Nov 27, 2025 at 06:05:10PM +0300, Nazar Kalashnikov wrote:
> From: Nazar Kalashnikov <sivartiwe@gmail.com>
> 
> From: Sean Heelan <seanheelan@gmail.com>

That's odd, which is correct?

thanks,

greg k-h
