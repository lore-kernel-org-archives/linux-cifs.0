Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B02C52CCC9
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169775; cv=none; b=IoUe1ZArMgK4ZcdmT2+SvHIXzk411yeVS+xCLSlEZdmCItCYGdvaVPG/K38eqZdgJwHX7FFT4/XoeiQN7F3oz5RJVNgv+hDR9o8np8oJS6QIAycyOOiAO+vNInc3sMOEPpVrlmOC9AsUH6Wysakf++dFsJMtVSAv/AEUvZW+xdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169775; c=relaxed/simple;
	bh=4D8PyH2lSydq8Jg6k9ObYForWYSmdE5pN9Dcs5Gxh1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRLJUOl7vZpoxnUkhX2g0NqGBmaaRmHAMnIZj4tK7krNH8sfXVV4Ls7oJ8T1P7vfr582svqV9SbmR8Jz6Q4ZgsJdftsdfW9bSn3foG4GY20LBIzwR6su1NeZkoDgP5jjT8YVCjnPJCPeoANhXdLTrs9pfPjQA5PHwOS8IOHASCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=afP48/vM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SamkMPm9; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="afP48/vM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SamkMPm9"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 01A287A00F9;
	Wed, 23 Sep 2026 09:22:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 23 Sep 2026 09:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790169771;
	 x=1790256171; bh=WxK9h2XLt8ZE5Dg3lRonmWvSaWUMiu49xpiBuCatZy0=; b=
	afP48/vMfarW7PKgX6fzbaBxr9s4jb7L2E9Vm4zz5V+/eDT4koqusFiR2cCPOpZT
	3D9AKMK45nKSZdjDi6K2koEzl/AdBsrHrojAGSQZvV110b9pxeLcesmuYYsnRGnQ
	9k+PcEw/3gnz59ZTN7DVUOYvyoK2NCPdod6a0LKtqIUqfcVYKFzNTVQk3u5kK1Os
	Q4+Y4l0gP/1NN8Rw1zfUGHZchvtgAEzTBq9zNm8lpEjjsV3xcWF9SVLp7MlVDjw8
	8Hh3BWxHpdvjljtJ9AWabi71XdYlt4pKgXTHJ8emeJEkZX2xiveMFevRKbyIpLG8
	mb69BYfPSapqsbi71fwiEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790169771; x=
	1790256171; bh=WxK9h2XLt8ZE5Dg3lRonmWvSaWUMiu49xpiBuCatZy0=; b=S
	amkMPm9Rc0T+/WNxMMln23w7ljA5k5fzUcHNyOOd6gQb14wZeqrN/marRpUiYKdu
	hFNEtV2Y7NYiDz6ol5wb9b/vA/Rfx2RkovbXWe/AZwhAJ0t/PURWwueyZj1ZshPs
	/M0I++K9w2k8Tb8gAT5bRMe7FP0OQMCXN4PkKCxwVZKNtr3vxai0NlG0sg+2lXT2
	LMalP+uUAD+CaIWjmMGZt9yTE1r54c8BxgcG1CJQHxrCnJ7zwVsV3rJc0KLeOBQ8
	QsGuflUFEUcIagLG6k7HzKttwRqZEbVNxUuBYQfi1FkjaIjrDX18YjREL4N/CtoT
	lTt0O+iKri8McHkRXTELg==
X-ME-Sender: <xms:q9Kzai4jhk20eo1pUPdAzBwjCkRlJCmYCt92x1QXuR4huD9TnmjbqA>
    <xme:q9KzarVyh_MR_ydrzLSKGdFYVONTUMtzI3PiDkkk7Oe9uea2_pfKRR4OQwrj3rrVz
    M_fXmAGO4ooyvXYBVsA-qaVVaVQzhP4mJsuU5Zm3MCCH5fz-l0>
X-ME-Received: <xmr:q9Kzaih6waq3IqRAOZ8n1GYcVyIy4D1VEW8hVUxlstQQYT9MIskmFikV84Rh>
X-ME-Proxy-Cause: dmFkZTGOCQPjs6y28iwbPYEt2gjVfWEVl10xOBpkOkj1s++gcIHTXUFjXvvq9J1BG/FVA9
    WPVVZ2PuwUCOTqdcd6sVwlezMeCjX/fjcBaVwQYjJtTG9qhPcwtsqvklpMIkreidzG7TB8
    MVGyEwzmbdOcWSDIoPY51wl5EQbnEi7LdzJbnWpfN2f69a/JhUVDffRCaU8NWwqNT/jkGc
    fOnNKewTJhO6jQkARBsCZuJ2irBvWv0Iy/whYhlBkLyMKzjs2A+2RH3RIAiFeYGnQBD4KB
    TTymk54BUMI5Wq/85A4jtdrv1wgm/ULPdhHkRzS7QV24Dx/lKHUMd8yo5jhTnw1+vRFvZN
    AyHwMhRcp7FLpUfjmu547r3yS9OKKBC1xUI3s8F6ijdrv97jGv2glDmLyDp7ngFt0Z4bvj
    07QDHg9BHFj839T1/Y5bz1IahsvOSQd8R4xvaqvKIrlVmHVpSCXrwVpl5OwTObLg/houfR
    BCXyj+cgjlSUjhTMo+8fU2rLJO27ORBEVAzANsHMukJZjwAovjMFh9RkoZdjhbppB1Ur0F
    XCjNSSxkWiHNB4i6j5j8mgMS09mTFI0FQjkJ0Daey3tgTMXPAL4Mfg+DSFxLi1EKOnq1ht
    KOCtxuNM5QeVXLnt9wYQM0VxeF5peY9xB3ugXj9FdOKATM2sBmF6d8zh/SOQ
X-ME-Proxy: <xmx:q9Kzajdmqwj2relwieTByuvxVEylkD-PoLqKoAOh-1RqbWSWFCORfA>
    <xmx:q9Kzap1fZ_xZVzKi5H6bY9aQqaEtCRn1ycMtl_7S__FpW54sEanl8g>
    <xmx:q9KzanqTOPlipjNrN_Dz-OSyE59UJ9Aa-tfm13Lk5EGALUnRxqzc2Q>
    <xmx:q9KzaphxucyB7H-Lep7hbXgl23TAT0g5FQrXECQCIwz2MdeoKY5HJA>
    <xmx:q9KzarazAJZ5tP8LVIB_lS9HKmzjNQNwacq-KkB_vm88xFSffEsq2VCh>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Sep 2026 09:22:51 -0400 (EDT)
Date: Wed, 23 Sep 2026 15:22:48 +0200
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?5pyx5rWp?= <zhuhao@stu.pku.edu.cn>
Cc: security <security@kernel.org>, linkinjeon <linkinjeon@kernel.org>,
	linkinjeon <linkinjeon@samba.org>, smfrench <smfrench@gmail.com>,
	sfrench <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: Subject: [RESEND][PATCH] ksmbd: add rwsem locking for iface_list
 to fix UAF during server reset
Message-ID: <2026092307-pursuant-catapult-1bea@gregkh>
References: <APEAYwCSK6S9UyHZK957O4qI.1.1790169581212.Hmail.2401112100@stu.pku.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <APEAYwCSK6S9UyHZK957O4qI.1.1790169581212.Hmail.2401112100@stu.pku.edu.cn>

On Wed, Sep 23, 2026 at 09:19:41PM +0800, 朱浩 wrote:
> Hi,
> Thank you for the feedback on formatting. I have repackaged the fix as a proper git format-patch patch (plain text, no HTML), so it applies cleanly.

You sent an html email and a binary, compressed attachment :(

Please read the documentation again, specifically the email clients
file, for how to do this properly.  Perhaps point your LLM at it?

thanks,

greg k-h
