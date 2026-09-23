Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0D8306D2A
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 09:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790155930; cv=none; b=ks/sT2/GVfK2gEWOJ86MquVGI2itP01o4j4W/Ws5+k6EsbkSSJRj+S7IHgerpDx3sgcNBffY2gSItJiVRYbfPtrRJfhN8I8+8OcUS9hAcSKwofZBqBzwltk+1QTEWEmu+RjFUelWlYBOzlg8GTUhoNs+6SQzj4wfs/oifmflgIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790155930; c=relaxed/simple;
	bh=2L3SoHYV1JIqdPMT/Fxn/Q2XHTbJEt+4pW/ESuTGMU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpZ0/bqgLmS7kAovaO6NLr3G3sY4n4BUbR1VVlAFwCKxoBB5/P9ZeGYq1iM8NpmS8UF4sRQ9VDmJvUX1nFEOeYK+HdTm4k43AyWqB17UexRAuN82eY23WleBHFLiXiE2GdSz5mkKHOxS1elEdwyHKv74cmCzXh4cjL9Cv+9QklA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=gf7DyDHc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xSWzkKgM; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="gf7DyDHc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xSWzkKgM"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2ACD17A007C;
	Wed, 23 Sep 2026 05:32:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 23 Sep 2026 05:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790155927;
	 x=1790242327; bh=LV4jEDntEIfi1c/Mt21nNFZ9M5+p/Cu3ssa5LbK6r90=; b=
	gf7DyDHcDwmtHe+YKZSZNjYIGbXzfN+96zrYIvejOXfspK2JIVZOQBIejSnFbjt+
	/eTHVGfqX4QhBMgiub1xkNcqWcy+D1jKsFToGLZYoDQuzvWxfoDaRAlZJDxQXJhx
	/GMHDfIFZxHOYjM8UqBGrDcEOpFWzwXHtdFnMIoH4FUcuUzT6Vv9EPjcP1OUlHER
	CoIMs7xRjMjkzb4bBm4nkzTUliUlusFGSYHGJYSppWhsd6FqiCkPwBTue28TD/zd
	DiBnGQcdzIHI9lyUt7f121TpCWjaIwAQQZS94EX3+lIjmjoArgdEINk8T54s4Wuz
	SbiLuUHEBRGaBl9/DAhglg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790155927; x=
	1790242327; bh=LV4jEDntEIfi1c/Mt21nNFZ9M5+p/Cu3ssa5LbK6r90=; b=x
	SWzkKgMl54oFRDGOYtLFtOK8UtmvXGeidk/i7jnPShcaU4np7Dn5ALVjMen3nCCH
	3EV1SATgeBRipbWT1hdO5rk+d8ixuTe3YigE8uwejhVRi+x4aWbprJRC34Mv3ZI+
	yFaNwvDHfXcA4qeoK/Io0q1WvSurfZL+idAFBqplPnGVXYQDauZdt77s5ksR61V6
	n6h/TMpjCzZvh/py68zNM8nVnuJg8Y9rfwSTj5z/M4cED8X7TyitirkyqGTrSRej
	Gc6POFjpS1/lJewF5nGqP6MjfIYOVcjabG50Js4mRAv4aE4xNjJ6LHNLCgyalhA9
	3jY8ekESe/CisN2qb+CRg==
X-ME-Sender: <xms:lpyzai6ESrP3IZd4n-z_WlU38vXIaE4aR0A3Mb_VJ63uY5EjeFpvXg>
    <xme:lpyzarW_SiN_D0J4PPx_fupRwiYl4LfiZxiFHBTOkVTMDDcusilY2PAgdZSrm3ayP
    gAqY4YWuZq0-8z75uvWW2a5k5yPv7IhfN7wEszHQ7UrmU6e2A>
X-ME-Received: <xmr:lpyzaihDF3TcKpozhNQq2kKU8vcfgayNY-GXPs75O4M9ZY1qTB0CtEkwybCZ>
X-ME-Proxy-Cause: dmFkZTGhebgx/PDh41xP+iUKNOptwfGq/b13izNFs5RZeGtXa4XavDG7yfFxS+geWysbwL
    Tqtduj+Hb11O8mwbirNE762+uTHAH4oFrMbM5Z9iNl7OBmB4eLYVmVflcrN8wM+FVf2sdU
    sO/iT9Gvf+yTeWNsglTkcb9mXEJB3KrexOmJ1icYnS0lsnkc/l3InM+9T6w8jwKtc4Lch3
    dekaSAW9mUTpjl0cgRvbEDPXynGSla6aVnm3TYpSzGArC1sef7EPoiYH6EMcuSXy1MoVNH
    GAN6Yb+MeczRMAYKePlv5HtLpAPKqaEiOx4pNJPJuBRyTZcDaJXIiMkEtZQv5yYd6e+beT
    cvi9cnK4jo2rxfbXVlBJwdbsdl9K5ENJ5BZ5XNkaRa9fWNFQaYOYybSXG7ZILd/hQir6zr
    QHqha+CGFkSCwomaB1CkviBMt8b/V9ezCNGTlGxxIuttXtf4QboWh6ocCpTCfuJL7elghM
    3VCNo70xluv3JCXcbNKSsZ04xQ4pLXdUVUfEZZyr4ptNa7/DzqKZqPCf7ZI6uBnHxIk5GX
    3pssY/L94TZGdepxh2ReI7f0fVUQAPByCSsHgSgj3GlxysgTmZ4eb+ROKoDdzL68cMutXE
    5oZOeE0RHxpMarMeJfyUnhnhp+oH7HAANHXOA0IRzVBybXPUFwxVEflfcOWA
X-ME-Proxy: <xmx:lpyzajf7xyCLTpoZ0v7yLem4fqMXhT6djeQBXTtgYMzmzlyzU1narw>
    <xmx:lpyzap3QcEpVGXrbI7zkcIGFUPjIa8dV9j0B4-Zn8niwmGWQFwJ0rQ>
    <xmx:lpyzanqww9q6izTrDhMuNl-hdOWi4doHrXACzhTVCDQkkLxyr8k3gA>
    <xmx:lpyzapjKAo1Y1lL_OKSuYvJTgF8bGYWVdFHyshhrjkPDMwjLoq0h9Q>
    <xmx:l5yzarbsPRv7xNzTBtIIfmVMxYU5MW3ILtnilSZtb3GbBNXIYcIs6rJ8>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Sep 2026 05:32:05 -0400 (EDT)
Date: Wed, 23 Sep 2026 11:22:05 +0200
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?5pyx5rWp?= <zhuhao@stu.pku.edu.cn>
Cc: security <security@kernel.org>, linkinjeon <linkinjeon@kernel.org>,
	linkinjeon <linkinjeon@samba.org>, smfrench <smfrench@gmail.com>,
	sfrench <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: ksmbd: unlocked iface_list free during server reset vs
 FSCTL_QUERY_NETWORK_INTERFACE_INFO traversal -> use-after-free (kernel oops)
Message-ID: <2026092344-muck-retainer-dd6d@gregkh>
References: <AL*ADQCbK5q8mAaIolsqNaq-.1.1790153264029.Hmail.2401112100@stu.pku.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AL*ADQCbK5q8mAaIolsqNaq-.1.1790153264029.Hmail.2401112100@stu.pku.edu.cn>

On Wed, Sep 23, 2026 at 04:47:44PM +0800, 朱浩 wrote:
> Hello,
> I would like to privately report a use-after-free vulnerability in the Linux kernel SMB
> server (ksmbd) that leads to a kernel oops (denial of service). The bug is present in the
> current upstream master as of this writing.
> -------------------------------------------------------------------
> Summary
> -------------------------------------------------------------------
> ksmbd frees the global interface list (iface_list) without any lock during server
> reset / hard-kill, *before* stop_sessions() is invoked. Meanwhile the
> FSCTL_QUERY_NETWORK_INTERFACE_INFO ioctl handler traverses that same list while holding
> only rtnl_lock (a lock the free path does not take), dereferencing freed iface nodes.
> A remote authenticated SMB client that floods FSCTL_QUERY_NETWORK_INTERFACE_INFO while the
> server is being reset can trigger a use-after-free read, producing a KASAN
> slab-use-after-free report and a general protection fault (kernel oops / DoS).
> -------------------------------------------------------------------
> Affected component and versions
> -------------------------------------------------------------------
> Component: Linux kernel, fs/smb/server (ksmbd)
> Confirmed present:
>   - Snapshot at commit af5226abb4 (6.15.0-rc3 era), where I reproduced it with KASAN.

That is very very very old and obsolete and known broken and buggy.
Please always test on the latest kernel version, hundreds, if not
thousands, of changes to the ksmbd code have happened since then.

>   - Current upstream master (checked 2026-09): ksmbd_tcp_destroy() still frees iface_list
>     without any lock, and ksmbd_find_netdev_name_iface_list() still traverses it holding
>     only rtnl_lock. No fix is present upstream as far as I can tell.

Please test to verify.

> Suggested fix
> -------------------------------------------------------------------
> Any of:
>   1. Protect iface_list with a dedicated lock shared by ksmbd_tcp_destroy() and
>      ksmbd_find_netdev_name_iface_list() (and all other traversers);
>   2. Free the nodes via RCU and traverse under rcu_read_lock();
>   3. Reorder ksmbd_conn_transport_destroy() to run stop_sessions() before freeing iface_list.

Please create a patch that can be applied to resolve the issue so that
you get full credit for this.

thanks,

greg k-h
