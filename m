Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F21E1A3B
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jan 2025 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735738790; cv=none; b=sfj2mzQq2a92kALvSjqxYah/3aqeOStyDaf5nZ/gY0jFrjv3RoZeLt1hK9VcKUE1XGT48uiIqqmF2OTDihxNcX5x12H2EsU3nrS0qvTnUXva4vky6J2opvwBSS8BYCR7kvX/ZmaN+/4HXeIl9CrLf4vTs0I2c5r80qmkCb9HM2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735738790; c=relaxed/simple;
	bh=2lKoWF/ijWNY+XzR6zUkINp415sq6LcgBkNysbwQv2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NukJSBgNDM3Vey4fzU4ay5aYAx9PnycMi32x6nHtFOs+ujUMcSMpiyDnpo4FCnHaFMngpHpSbR5mtFDL5jRnS0Hs3JFt//u38QCtJlPyAgCNVY1Wif3U9pRDAYd5/id0RcTCzvQQyfkJS3T1DxmDnNYg0rbBvk7uaKrReJ/tRpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mM0oE6e4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mM0oE6e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D230C4CED1;
	Wed,  1 Jan 2025 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735738789;
	bh=2lKoWF/ijWNY+XzR6zUkINp415sq6LcgBkNysbwQv2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mM0oE6e40tHfIqzGUogwKQ72Gj4YQflRJbFTVNWyWB0sR3lF05LakryHw77Y0Sp8j
	 JE/OOZYx9Sz0ajkbvoTI4ahRObmXSE8MT3bWkwm1L7laPJ4OQjQnLBkvnpaIgJt2oV
	 UkwaT7aPQXNMe9hlenvKLUYBIm6HSTq0lKGTJlg5cpdhjITAIDFVSWRFUKrXTck6dD
	 n93seby7FAUudegP8GVuwWtchpdjrm3O+KySLAg+tzgcG5bjabl6ruVZlAykOr5O/x
	 aFr0idhdF4Ub0D7tRlRxjrXIzAs2qR+tlQsnSSRAvoN4B+9o2Al8ZCNQRNUCBfi76z
	 8BXKxi742WoVg==
Received: by pali.im (Postfix)
	id 26186768; Wed,  1 Jan 2025 14:39:39 +0100 (CET)
Date: Wed, 1 Jan 2025 14:39:39 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Ralph Boehme <slow@samba.org>,
	Steven French <Steven.French@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
Message-ID: <20250101133939.5izufhh2fctxo3et@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <20241209183946.yafga2vixfdx5edu@pali>
 <1098e751d1109d8730254ada7648ae4d@manguebit.com>
 <20241209193445.yrcaa7ciqegvs6fz@pali>
 <829df5e75aba7f0857ff688689b52676@manguebit.com>
 <20241209195420.7mnya3ua2y7nl6tp@pali>
 <8d0a687be2cba9cb4d2745c0752d8fbf@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d0a687be2cba9cb4d2745c0752d8fbf@manguebit.com>
User-Agent: NeoMutt/20180716

On Tuesday 10 December 2024 10:19:26 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Ok. Would you have a time to prepare a patch? I have still feeling that
> > the smb2_compound_op() code and EAs code is rather complicated for me.
> > I would like if somebody else could look at it, as I have feeling if I
> > try to do it, it can end up with something more broken...
> 
> Yeah, it's a bit tricky.  I'll let you know when I have patch so I can
> try it against your old servers.

I looked at that code and it looks to be really more complicated to
implement partial parsing of the reply, as compound code is bound to
many places and code paths.

Meanwhile I have tried to implement a new version to retry the call
without querying EAs when server returns that EAs on specific paths are
unsupported:
https://patchwork.kernel.org/project/cifs-client/patch/20241224131859.3457-1-pali@kernel.org/

I think that this approach should now work correctly.
