Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F086913D535;
	Wed, 10 Apr 2024 08:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737599; cv=none; b=S/NSWa0/gL/eho8RT1PfUvo3DtW/m4OcuenLCSmMyAZts9CBgY/Ez5ycr02nShVG1HnEvdxKn4UPx6zGWr8HLIpABZrxrFwHuon8xfD8/UatgvnmxH7l46u4G9xJRpoTWQapnMiHUrBrXByMNUQdpzvlA858psyBXFeKFYHwNto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737599; c=relaxed/simple;
	bh=M1CULTLQapFQR63G83SdeFgSSKY+5gxgZETqZJ8vBeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XSTLiIXUuB1zEhr66vmBfLwz1mPs24eQfGrV9otcCby4fTSaMCNINo7DZhuTHtStA5FXEh3AwkMbsSV+34EurAfrNRWiFtxzBZ9NkfssS/gYUi0BPEZVwSTLkDzzcTgTgKyogxEM54Zpa6zaw0atDpqj2xT+wO+mQmiYHV6E+lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az/DyFll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az/DyFll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6D1C433C7;
	Wed, 10 Apr 2024 08:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712737598;
	bh=M1CULTLQapFQR63G83SdeFgSSKY+5gxgZETqZJ8vBeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=az/DyFllRFhJr2jbAqJh+3PgQ3EJcRMmosTT1nzW28Q067ShclRa9PVgVl+Uo+xTz
	 vE40KWZ3ybUtwCxVpE2XGHVQtdKPmZ554OnGfnsFEnu2sI9CTcgI+KH0A0alQpi/G5
	 l26uf4Ck2vqXJbpWJ+uGtwgC9GfuZH1AgJ72kBrg=
Date: Wed, 10 Apr 2024 10:26:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chenglong Tang <chenglongtang@google.com>
Cc: regressions@lists.linux.dev, pc@manguebit.com, linkinjeon@kernel.org,
	dhowells@redhat.com, linux-cifs@vger.kernel.org,
	Oleksandr Tymoshenko <ovt@google.com>,
	Robert Kolchmeyer <rkolchmeyer@google.com>
Subject: Re: Fwd: kernel panic caused by recent changes in fs/cifs
Message-ID: <2024041005-marbled-lavish-047d@gregkh>
References: <CAOdxtTaceuB9fvnEcoTVO6t0V_90UbLM3dyLbE_CK7uRe1bn=Q@mail.gmail.com>
 <CAOdxtTZfo59ZUxTgbWOybqyL3XHKyiudVthTLaU8jYRhiAqXvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOdxtTZfo59ZUxTgbWOybqyL3XHKyiudVthTLaU8jYRhiAqXvA@mail.gmail.com>

On Tue, Apr 09, 2024 at 11:45:06PM -0700, Chenglong Tang wrote:
> ---------- Forwarded message ---------
> From: Chenglong Tang <chenglongtang@google.com>
> Date: Tue, Apr 9, 2024 at 11:43 PM
> Subject: kernel panic caused by recent changes in fs/cifs
> To: <samba-technical-owner@lists.samba.org>
> 
> 
> Hi, developers,
> 
> This is Chenglong Tang from the Google Container Optimized OS team. We
> recently received a kernel panic bug from the customers regarding cifs.
> 
> This happened since the backport of following changes in cifs(in our kernel
> COS-5.10.208 and COS-5.15.146):
> 
> cifs: Fix non-availability of dedup breaking generic/304:
> https://lore.kernel.org/r/3876191.1701555260@warthog.procyon.org.uk/
> smb: client: fix potential NULL deref in parse_dfs_referrals(): Upstream
> commit 92414333eb375ed64f4ae92d34d579e826936480
> ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE: Upstream
> commit  13736654481198e519059d4a2e2e3b20fa9fdb3e
> smb: client: fix NULL deref in asn1_ber_decoder(): Upstream commit
> 90d025c2e953c11974e76637977c473200593a46
> smb: a few more smb changes...
> 
> The line that crashed is line 197 in fs/cifs/dfs_cache.c
> ```
> if (unlikely(strcmp(cp->charset, cache_cp->charset))) {
> ```
> I attached the dmesg and backtrace for debugging purposes. Let me know if
> you need more information.

Do you know which commit caused this problem?

And 5.15 and 5.10 are very old kernels, does this still happen in the
latest kernel releases?

thanks,

greg k-h
