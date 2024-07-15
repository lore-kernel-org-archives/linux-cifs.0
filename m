Received: from fout8-smtp.messagingengine.com (fout8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968FD143878;
	Mon, 15 Jul 2024 11:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721044130; cv=none; b=LK2RgGk3n9kQl+DjNqdYpdgo2KQ8zumGPU5I1zkPvT1INkfOaTh1gRZpef12lx/D6IHY6iKbOiNbJ9ND+nkE1U5epLkwvoMzanHi7XVpcTJ2qIXmFK2xo5dk6A+4TlK/5cC0WWt56LxUsnEYJ0Gx8MpQINMHWfq3Hs1yfDV2/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721044130; c=relaxed/simple;
	bh=1Jb9ZEpo0KJGVrKp2xnk52lU2fby512RuPKWMSCVK4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=il7aNL7/Bahz8Rj+tVdDxCrg9oXShoFGbIEsiULGRENZ/kOjW9XCXA7MAyA/mPGDTMm/W5rIDiaR/OKfjzQrLZI8HHFCF3WPNB/6dc735p1PO/ZPbXoBv1bJqIldiJ0BYuU8Y+5RIBlmNIn/C4dd3fQzd21JtrE8Pc9n7FMGAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=E1huWV3O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CJwGA8vJ; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="E1huWV3O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CJwGA8vJ"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfout.nyi.internal (Postfix) with ESMTP id A93481388CA6;
	Mon, 15 Jul 2024 07:48:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 15 Jul 2024 07:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1721044127; x=1721130527; bh=sfQsKawbEx
	k4uo5JyRptHZx3EVWn5tE89zsHoTiGDF8=; b=E1huWV3OdJa/6v+3r1UUt1So17
	tPNHuj4BzaYqsTm2Z9GPdVaunI5ZO/rPiCRAX1HmjFGXK79v/8qBruhKC/KmLMN/
	6wGQo86Z6NOtPaQGARuOZde+9Zc3s9Fa38t2NdnlwHE/xE9WK46jSNyODN62l87P
	+0lBPFmnR//jtdPNTGF2uVOUstBUGJkvmLmyXBzkIJTPOHDRGbdcFq3LUno9HMT+
	6MONJdn50pKpl1fSYcEly8HxRgZ07AReSbWFcX2+GlWcUOR9thnSq7Sec19+UC0S
	vuTbmHYLuk0JIzg/gVsDh0MezVKdiUuMdlc/Tk44WTvMdotr7fVmRxMgIxZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1721044127; x=1721130527; bh=sfQsKawbExk4uo5JyRptHZx3EVWn
	5tE89zsHoTiGDF8=; b=CJwGA8vJDVPF/SE03IJzBLubTJBDhIBhO/IT4l2MmEoX
	D/9LodJ6NQe2mLAlG1emnqDi/Fv4FcIQrOZhuwH/dAUR7qa+1Xbb8rMLPv/TgfKc
	UBcOlXDh+qNKktJRI3LZup8+9tRO8cvleDaYDP+HirZaj9zAojW/r1nxZRpUY3Gv
	Zi0tcMieIi/wKtLkOv0WooY9KtqsRkPcnod0MeJZAGeei0Ewt/fWhctjKOsbyRI+
	hzpw1eoWrgTxXnE5owoEg5153iSlvELe1iLVXgF9rTGvgiIT86mndfFKwKA3+cQx
	goO9h/Ka8dsqRXq9WGoBbH5Ee/MhCuArZtSisuUv5Q==
X-ME-Sender: <xms:ngyVZjeCFYt8LnFuQgop8lMe1uJ5mfzdpOTj-Pn_NORvrMiJ6KcfNQ>
    <xme:ngyVZpP3z49Yu3kBousrEAnp_Q00louZFkB8ft7XBnMPoOkby1ncKEGtHoEvRg2vM
    olfX74_g6VHmA>
X-ME-Received: <xmr:ngyVZsjT3sBk-u0TrqOFVecqbsYZpsKoxlxd-jqY38NqFbjCQ8L80U18zRD4E8uKoy6Z9vQ0Z2LRZw3l-TnHn541quTRX_nLkTm9Aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrgedvgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ngyVZk9IaUJqplxaNRNpYF7lS5rhDHrERm4_BT9ZDoqTbI4Lmcm0Hw>
    <xmx:ngyVZvuH4kRcj2alVGl4PEq1wT0wmcEPsEMl9Gh26sGpSskc-SGQqA>
    <xmx:ngyVZjEE6mDt7CvmXGyG_raHd6W4Jcees5Jvfko64IacpBJ_NoyRRg>
    <xmx:ngyVZmNgMVF-SGHe1o7pRU-7exZYmkrLId2WVSAGZiNpgkPbfTdCZw>
    <xmx:nwyVZg63HbywEDVhzJ7pDHA9sxzWae4aJZnj5o0VEr4jgnP0_nq-ilNV>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Jul 2024 07:48:46 -0400 (EDT)
Date: Mon, 15 Jul 2024 13:48:44 +0200
From: Greg KH <greg@kroah.com>
To: Andrew Paniakin <apanyaki@amazon.com>
Cc: stable@vger.kernel.org, Benjamin Herrenschmidt <benh@amazon.com>,
	Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>,
	Paulo Alcantara <pc@manguebit.com>, Paulo Alcantara <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	"open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <linux-cifs@vger.kernel.org>,
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6.1] cifs: use origin fullpath for automounts
Message-ID: <2024071535-scouting-sleet-08ee@gregkh>
References: <20240713031147.20332-1-apanyaki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240713031147.20332-1-apanyaki@amazon.com>

On Sat, Jul 13, 2024 at 03:11:47AM +0000, Andrew Paniakin wrote:
> From: Paulo Alcantara <pc@cjr.nz>
> 
> commit 7ad54b98fc1f141cfb70cfe2a3d6def5a85169ff upstream.
> 
> Use TCP_Server_Info::origin_fullpath instead of cifs_tcon::tree_name
> when building source paths for automounts as it will be useful for
> domain-based DFS referrals where the connections and referrals would
> get either re-used from the cache or re-created when chasing the dfs
> link.
> 
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> [apanyaki: backport to v6.1-stable]
> Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
> ---
> This patch fixes issue reported in
> https://lore.kernel.org/regressions/ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com
> 
> 1. The set_dest_addr function gets ip address differntly. In kernel 6.1
> the dns_resolve_server_name_to_ip function returns string instead of
> struct sockaddr, this string needs to be converted with
> cifs_convert_address then.
> 
> 2. There's no tmp.leaf_fullpath field in kernel 6.1, it was introduced
> later in a1c0d00572fc ("cifs: share dfs connections and supers")
> 
> 3. __build_path_from_dentry_optional_prefix and
> dfs_get_automount_devname were added to fs/smb/client/cifsproto.h
> instead of fs/cifs/dfs.h which doesn't exist in 6.1

Now queued up, thanks.

greg k-h
