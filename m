Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C0E125AA;
	Sat, 13 Jun 2026 01:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781315089; cv=none; b=quJ2ZxiBHzGKTrQFqiwE2IJQjHP3dXAHgG8rfyK42qeuZWx7d4qMEDv3jxoMV/gmV07MzRutZpqXHgXbnrXqV2Px+HHy2Hbg9SnB1AEBg3XxRcAVPOyd56Fd699veyMlhfc+nDg7k7KFiBWqbcvHkA9EoJ0ldFWXq4Ztag0Kxyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781315089; c=relaxed/simple;
	bh=71Kc08qZ4LoJYQCCz+uUXBDJPv7aQtxX6u6OXaDgNoQ=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=q0v0vVjxuhf4KRMKwDHUcm+nlIuZfeqFsw1anktgbYfAPf7KVHx4siVOhDtPmj+ozVrz/W78T70ZPBwtt87cSSZiQq7WrEahr9T/JmbCMXCAQSAXGSU3wUTjdPwVYEAAZo1wj5HZPTv20iOm17tvPmiyZYvFLV0cMhcn1cv2Hlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=XH1qqoyo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Ll+jZRMy; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="XH1qqoyo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ll+jZRMy"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id A4A0DEC0107;
	Fri, 12 Jun 2026 21:44:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 12 Jun 2026 21:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1781315086; x=1781401486; bh=n+TCIL0zllgxw+ILKp2iuoVJlRipkx6xMp+
	2FClOnkU=; b=XH1qqoyogvRAyUNaqYIYEiaKGK26EavqyFPzIyytc3ZhOsuznYG
	+P2JeeDWodOUZ1N+7D/3rNFbGJBeUjZxmeCBg3Ixix+/Zn0KUJN52OhIvCDrAZ+F
	sRHyr0RZfgIr5DQa9u2cSllAsihDSOcOGbz0tbjyojFIjL01IbxJ+ur5UDbNLzVV
	3AjsiL1Z3HGhtMFwv0L4Li3mVApl7g5KO5fSIW1VFMAmEZxraKD7WlbW4WWOL7VN
	GCVwie022YC5saqDnx3viRmmkYiBDi32yy3h+5GqS/kFTmzlrYeAIUGB9MSdr5wm
	kx349nMMHecSvhZdpkjIT3TVTdxzQCwR4Sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781315086; x=
	1781401486; bh=n+TCIL0zllgxw+ILKp2iuoVJlRipkx6xMp+2FClOnkU=; b=L
	l+jZRMyu8NMLf8NqGUaumbzKxDfse8GZsu1Nc+UN40orYnT7/RiwfyTNfSRJkKfv
	xUMvtCMkiP8eJm8qC6qEESOWas4BQCHh4RtuwwnX2uiAUnADIOXYifRCxmkR2+QX
	xp8oiQOrpt1ridaTYFG3tgfcYyNi97cl611oFPhVaTBgHzjrShKaXT6i9m575Sc1
	FmBFP1T+5y5w1vJkMJiz8QB9BXTg/m/mZVELLLcu0uDNZZEfd0NfzTz+6nDt8ouk
	BUfF+qwON+eMq6afPXX8h0gii0xMoT1WqfFcsTgCMWST/rkkLNdGvdrilhtcamsM
	JZO86D24yyw7QYVNmMsrg==
X-ME-Sender: <xms:DrYsavanB9ETV88X3Hdz5Ou-ZbmP9WZJ9dB7PDuu3mWkYn76Ahxi8g>
    <xme:DrYsasoNam4u2TW9iS_KexpZDNrI-aEDmMmR2-H3oQ2_qhC_Ms67fPjEBLMaJuCq3
    7ORPa-IFeZKfT-fYM_xwH_QoTlZJsYJ5qo6rpzqje4rJ5CtEA>
X-ME-Received: <xmr:DrYsarSeESX9GTDRsoTTrIaRLXFJfEjcIN8d1IkrSi6CSn_l3dgliL4MZjeeRJLs9BzWHEwQl5OOi86UflJs1KWPLbDcgSk>
X-ME-Proxy-Cause: dmFkZTGJNud4EK3yXmh2rCVmvaVUI4Gb44ov5A/lV85+DfjwBNoxwUa++tg2/r+bgNGHZk
    hiE7jH9KvieVxOTwEd9HPUCsIIi7O7PD/TDIgznDCKQwneABmFVwKYkval7Ou0rzIx0PcW
    QclTlMxYoY2I9+81hNlUqJjBNdZMjWxZgeufFRWSnLbfz0SHRzzdnbPm1qF5Wjhne7T5gZ
    z+GPBYglqfWAFCj5Zx5WNb7G1X6G5DaZon3bp2gMO2lkGoEznXBVy5e0qCkkE7RIg8896F
    ibKM0gS0DeI2YZP591Jdkw3Q8E19o34cZ/eHOtRekRVLOjHPp8X+F/EbeIUXVOM7c3qmQb
    DfRYlOTFB2wBMCVLDq2fd0Sz0hxYL1dT/UuTOhBbqC985wkT0FYI/seFBCZe1S+Zt10ztF
    yj1aPeYKxqVY/euCe0HFdqjvxB7hL6P7TnzMwce5j9ZISP4dpQsJKAcfBRT4/03LTON3dd
    zpE+JK7kbXo0sxvDEs2ZB2MvIQhiWO0IKOnCZq3ek/CwFomKiqAK0HLJJ+KYM1N+HCyD8D
    OIePzJTvdBywOjr58A8Tgc2EPKFDfMnq/tQ6AcDXOKUC0ghonwZUTqtKNSAQJzCX8WDmXD
    dJm3ZVOL3y+b2qdf1thF+ctVfIB8MwJBAIPhGMHFUZzaMHZxeeFGlH3y1Ujw
X-ME-Proxy: <xmx:DrYsaood6_l20Wqomx2AmyMfAuZmIvgtAP4mjBvxPVJaFUnZ1_gfnw>
    <xmx:DrYsat2qqFy3MMMY7qrOPFJdGFVtRPxUC6f5OyA-SYm70mqS2CMjzg>
    <xmx:DrYsav64QOSMGQ_opEBDUBYJpcKwd40PSBlYywE8e-W7w09hzmoPoQ>
    <xmx:DrYsapQxPOzJ5dmau7PbvmLoywFYmp4jE6PRdxO_deB-7_mXs5AUpg>
    <xmx:DrYsasR1y_YrGJXsyWZlsXoKaosD_Zz2pgPeiMi6JkyBSX2xkjS6hgo4>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Jun 2026 21:44:42 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jori Koolstra" <jkoolstra@xs4all.nl>
Cc: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Steve French" <sfrench@samba.org>, "Steve French" <smfrench@gmail.com>,
 "Al Viro" <viro@zeniv.linux.org.uk>, "Jeff Layton" <jlayton@kernel.org>,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, jkoolstra@xs4all.nl
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
In-reply-to: <20260611145733.43776-1-jkoolstra@xs4all.nl>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
Date: Sat, 13 Jun 2026 11:44:38 +1000
Message-id: <178131507850.3002522.16819279282508142089@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Fri, 12 Jun 2026, Jori Koolstra wrote:
> There is a comment in vfs_prepare_mode() that says:
> 
>   Note that it's currently valid for @type to be 0 if a directory is
>   created. Filesystems raise that flag individually and we need to check
>   whether each filesystem can deal with receiving S_IFDIR from the vfs
>   before we enforce a non-zero type.
> 
> This is a bit challenging since there are many filesystems. Claude Opus
> 4.8 was used to generate the context for each mkdir implementation from
> which it can be judged whether passing S_IFDIR is safe. The result was
> then verified by hand by looking at how the mode argument is used in
> each case. To check whether all mkdir implementations are convered,
> 'rg "\.mkdir" ' was used and checked against the list of uses Claude
> found.
> 
> The only mkdir implementation that I am not as sure of is
> cifs_mkdir(). So this goes cc to the cifs people. But of course, I might
> have made errors in other places (except probably not for the A list as
> those are all just mode | S_IFDIR cases without other uses of mode
> besides logging)

I agree that cifs_mkdir() is not obviously safe.
I think coda_mkdir() and fuse_mkdir() at also not obviously safe.
In all three cases the mode, which now has S_IFDIR included, is sent
unchanged to something outside of Linux - either user-space or over at
network connection.

I think you patch which adds S_IFDIR to mode should mask it back out in
those three functions.  Then we could be certain it is safe.
The maintainers of those filesystems might then choose to remove the
mask if they know it to be safe to do so

Thanks,
NeilBrown
