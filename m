Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C2F3955EC
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 09:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295144; cv=none; b=Y96lBFmVBwTJepHEqgmZPJ+2+um3Q6lTjs1bEgEFon5ji21uxC2TpSsrPipRiQLqhd/7bBrh+MsciKRL+0sE15c86E8E2CXAzLlETcXGQCwZ5TePABgMRgkEFKncPrs3hoZ8z+GIS6FY6N2HHretVHbYkGYmfTT9B/XBlVf5yo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295144; c=relaxed/simple;
	bh=MP3QGWTzWMRzL6FiBiu5uGEy4NRw8nZ8yXEmPVyf7R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfm/h1OApMbN2JbgP9j9r7z5rRkPUKCCuILWQMqlj0IdKV6GQebN39jei+quuqoHmrA60gK4MLUpIFbfbOABheEL2lK2K44zkfZE/xywGvCZ6sY26oDeyF4ZMXDdIKyYjxQvrcEVTrqQRMGMiwh3Ko/6jV7AeU04qeWovzNR4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bc56z3hT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bc56z3hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FA21F000E9;
	Wed, 24 Jun 2026 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782295143;
	bh=HzspchSOSkv/1dfbgfottLytTPLLj6NmdgRhema+Ev4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bc56z3hTTEb1gZkVchy+k/+VSEYQe5x33au0fCW6KzNlZf85RWVsKT5d5mDbEL4xv
	 2NI9XMW4ZkyHoYCajAvHjePco18Std9wIKjS92vDq2AUHWflITTk/265FQEDJk2tff
	 yS/FCFpQu+pY3198tdXI3IjjF9+Hwr36kr/2I4f4=
Date: Wed, 24 Jun 2026 10:57:51 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "grayhat@foxmail.com" <grayhat@foxmail.com>
Cc: cve <cve@kernel.org>, sfrench <sfrench@samba.org>,
	"namjae.jeon" <namjae.jeon@samsung.com>,
	linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: Request CVE for ksmbd authenticated permission bypass in
 FSCTL_SET_SPARSE handle
Message-ID: <2026062409-unproven-atypical-20b2@gregkh>
References: <tencent_32075C41A32AB2B941A3641C72794B4B6408@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_32075C41A32AB2B941A3641C72794B4B6408@qq.com>

On Wed, Jun 24, 2026 at 05:53:48PM +0800, grayhat@foxmail.com wrote:
> Hi CNA team,
> 
> I am writing to request a CVE ID for a permission bypass vulnerability in the ksmbd FSCTL_SET_SPARSE handler. A fix for this issue has been merged into the mainline Linux kernel and backported to stable kernels, but no corresponding CVE has yet been assigned.
> 
> Vulnerability classification: CWE-274 (Improper Handling of Insufficient Privileges)
> Commit references:
> - Mainline fix commit: cc57232cae23c0df91b4a59d0f519141ce9b5b02 ("ksmbd: fix FSCTL permission bypass by adding a permission check for FSCTL_SET_SPARSE")
> - Stable backport releases: v7.0.12, v6.18.35, v6.6.143 LTS

Now assigned CVE-2026-52944

Hope this helps,

greg k-h
