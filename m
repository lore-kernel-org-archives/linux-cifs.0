Received: from wfhigh8-smtp.messagingengine.com (wfhigh8-smtp.messagingengine.com [64.147.123.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5913820DF1
	for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 02:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709172514; cv=none; b=WDQPrKStg/mvcrOpyrjRhsAMGulfL5nMePTxhsNHXFA4DN7MVUNSQ80i+BBuLfV/fYNdCIuT3bh7VRSvFDeLG4/F7MDxB1MX5RJLDBmJWw803BwVhatzAB/FB1pDAzY+/XsVRuFZjm5IVsP+s2afwz+IMjhA3x4Tk1AKOX7rEwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709172514; c=relaxed/simple;
	bh=Nx1GGn/moYJmkzlOTX1tWzfhXT44cNbGv+jkchRgJxM=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=hQH6RSkWQ2HJphEGHvGvrct7vp/6Baif5a3ZbsgxfIE72pChw5pkDfXYQwiInYiAfphjT1HLNXnLcddFu8sF/tsonM1lF/Tw9Qowmb6R7nahp8QryPIjJY0in3zyrlOVd99LcxBKAZlDn7iWMlKDNPaF26WjKR9ewZ+2x5ycpwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tempel.org; spf=pass smtp.mailfrom=tempel.org; dkim=pass (2048-bit key) header.d=tempel.org header.i=@tempel.org header.b=T282/apb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WM4cVS3Q; arc=none smtp.client-ip=64.147.123.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tempel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tempel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tempel.org header.i=@tempel.org header.b="T282/apb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WM4cVS3Q"
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfhigh.west.internal (Postfix) with ESMTP id 8B80C180007F
	for <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 21:08:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 28 Feb 2024 21:08:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tempel.org; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1709172511; x=1709258911; bh=GFaQH+wLxW
	27sj5Mfyma6JqPlsYAim0y4vEvXlwgM5E=; b=T282/apbzmUEIEjDb7dEIVASqJ
	hDGYl4j9uCt/ALvWoGYzRMlVR9TbGjobaDa5fkRFxzLG4Xs1P3Kt0vmMkMnQKLuD
	NoZ717xm1i+bBqsUoMvJv+MZmYqCVGg+oHE0J19y4tLAD+qA2XW3A1F5MN4dQT7c
	3IqdTIYewNKaMtDinv5nN4TY+nuoWzLqIQE8LLCUKbB0nO3YIw5zhOtl1ACzuZIP
	YCloSNRqu680DfyQtNXgzaSlzfE+O/lteNkg1umHwjxyZedCy1XDrBFv72JYgoTB
	2gVsxVmNEXKX6ISaqdFmJxW+Bk1FYbRQ7epampRH0crPIuDitJ2VplhrQHqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1709172511; x=1709258911; bh=GFaQH+wLxW27sj5Mfyma6JqPlsYA
	im0y4vEvXlwgM5E=; b=WM4cVS3Q7PnT3UgOkAd0+QCLPSscDPqBb6QOuxyyrz+z
	xneqJcMeD8dXaKk7QCfj6uUI9Luj/j1ZEVuV3shno/Q8HJOux1JPNHwys8aN9SJn
	Gz19j0wT8IpqgGdQBMJAV9DFlEB7Bv+G7bUCbLdsqJoW0K4VevQIGtQNQNZ1ZZ78
	yDx4r8yR5Zn8qCB/2cGbaVphq/7nAG5XgPJCgXh7oOFC09xz7hGwDco2gKIa4edw
	fqw2nX80HI3D6qj/jNMGnxF1CX944B3g49sNQfvTp+TQa+XCeBqJxfECg3JhZHd2
	V4iYlZhGdczbdIkAX6Xhk0BatV1gaDw74a1sMRimnQ==
X-ME-Sender: <xms:HuffZQ63FboLZxHUtyP2RnYZXkcIVJIre30mAqcYxm4-B8irz2siQg>
    <xme:HuffZR6hk-rJ6OuuG8144a707UqxqVpAxht2Rdw-sWxzARHQqwx8i_Lm7srKVVU1C
    AvZqmt1tDzakLpKfg>
X-ME-Received: <xmr:HuffZfflpAb2U62YW24gypvm2Boh9SH5WRvQFRDoCftwmXNaZJHdvkDF3lTqoovM1CKf7G-TPrBC77KwFLJVRc2E0zaPobCMQNX0jErOpwu1OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrgeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephfgtgfgguffkfffvofesthhqmhdthh
    dtvdenucfhrhhomhepvfhhohhmrghsucfvvghmphgvlhhmrghnnhcuoehtthesthgvmhhp
    vghlrdhorhhgqeenucggtffrrghtthgvrhhnpedugeeuvddvgeegveeuieffffduffekte
    ehleelgeevtdeuiedtudevgedvtdefieenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehtthesthgvmhhpvghlrdhorhhg
X-ME-Proxy: <xmx:HuffZVJAaXF0Fv4aaHtVCp_LuOLQnr_x6xPBPeN3s4xDaV9ztJeQug>
    <xmx:HuffZULTdX0NhL6F5O0f66b-WexeDT_SSbQs5_e6BeQ9gorcpCLT0w>
    <xmx:HuffZWzbtsQ_4rX5r1GQLuP8JY--Wgmr1ON68smZM46PmX9Q2o9s4Q>
    <xmx:H-ffZT86RQUX-pM-CKbv5vfhhv81C5aA4sUyi3HlF7sgM-L5Nz9N_WmxJsg>
Feedback-ID: ie07947e6:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 21:08:30 -0500 (EST)
From: Thomas Tempelmann <tt@tempel.org>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.8\))
Subject: Samba 4.20rc3 does not build on macOS
Message-Id: <AB35292E-7B6C-4B8F-BD1B-E51B5C820ECB@tempel.org>
Date: Thu, 29 Feb 2024 03:08:28 +0100
To: linux-cifs@vger.kernel.org
X-Mailer: Apple Mail (2.3696.120.41.1.8)

Hi, I am new here.

I just tried to build it because I would like to use the "wspsearch" =
(thanks for making that available!) on macOS. (I also built it first on =
Debian 12.5, which worked fine.)

However, ./configure aborts:

> Checking for getrandom                                                 =
           : not found=20
> Checking for program 'pkg-config'                                      =
           : not found=20
> Checking for GnuTLS >=3D 3.7.2                                         =
             : not found=20
> The configuration failed
> (complete log in =
/Volumes/Data/Downloads/samba-4.20.0rc3/bin/config.log)

I suspect that's a known issue (I guess "macOS is unsupported").

Does anyone on the list have a solution for making it build on macOS, =
though? I only need the wspsearch tool, maybe just for that?

Thomas

