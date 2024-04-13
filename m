Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29AB47A6F
	for <linux-cifs@vger.kernel.org>; Sat, 13 Apr 2024 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713034750; cv=pass; b=SKl2TuYXnSPa7soYbuf0W0rSto4aGITVNQxqnoLu7gq9YndJiJgjCAM9lY46YRlwJcnsOiDF/5NZZCw7Dt8c5QSiufAHQ67y09SxDnrMJ6m09ppBHfx9DDx5MAO6O/VK9t7JOi9cno+DLTWf7YcYBV23YLbeRsigsvBrLhohMWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713034750; c=relaxed/simple;
	bh=EczdKnN6dbq7E8FwjXDcnjXn2SFKDrWcsZZBzEnBB1w=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JbuDBLlmnQx8Q6CBF/Jxvn0cmhUs+dVp6ycCAMYgfbEzXnqACZhS5n81Uz3Wi9R24Vd0dYlSyGE5N7w8LJGzwg983C1EbuncMeJAd2zjSn/44XIVBS6GwskDwrDYOgHK5Q0kWEM21ORsVdRbQryrmkNJU4VA0NB4IDSsuhng3qE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=FB2l9ld6; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="FB2l9ld6"
Message-ID: <a59f0e1b5074d3f814135169bac6bb20@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713034739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3sfbbukhvlG5VWpQHo68FsVTpCTMaH2JR9fjT/d6asc=;
	b=FB2l9ld6sYiL/P19I+hfEfNmXQuE+8VGLrXhNIhlr77mH4HfgDxBuVsb8+GzlDS7yImIxT
	DqHCFT7IYjeNgCGanku37H8gyMe9FzQv9riPNY63CGu4HD5ZHb9EWmZ2C7yQnZ/6hupV5R
	0mso+ysVRCau1TD0hsJ4ZMQ+Zg6l6CunoZ7gY73//GAddPqQ4ia8pPJainOFEKCFEdgDbh
	kMFKe8hsIktEsXJx9giSFMVbrfrNElWCrMBizWkx6es14n9Feh/L1TMX16R2rGqpVzTw/F
	tIY+WLZdgs/RCxJZwIytGwBpMTIqGuHcBoV0dsfXqVzDl35kRudciEKdfwr1Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1713034739; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3sfbbukhvlG5VWpQHo68FsVTpCTMaH2JR9fjT/d6asc=;
	b=HE0qQJ7hkops6RbRZ6oRUW+I24kbXWEjTc9Y2FgMyoaJzpSnhqOi8DcSMYFzYc1QeAkeZr
	668aqBWJO/Gkvc7YWcX3MrFIZrQYRzXZODOC7gEZfTsT7Gep+5gddiBiPhjP9gyEwkvMwm
	Zt8pghV2Jze+wAgmt/MuByKUjnbQKI8dW/tMBf9RIfva8uyRwL7yeCmA8DA1WmpqoYaUCH
	XzEjSIlrTiEXZ/1e8tqaNZ9hjVN4DKoOWAcumI9WWH54YGQX1ZbW8s9r4r0zet+F3WlLnu
	vEdpadgyMiyHuDY31I/4qa9rUM1z+7ZXU9OYuUkQyjhctyTf4slBv0ziMaOPRw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1713034739; a=rsa-sha256;
	cv=none;
	b=qOrZ5wY/nh+tCmcN4Sp2D+cvbSkDDZt2EwizMT0aX+Mj0vKyaGOwp7zDlbKvHNpY0dKnSL
	LXYOTu5oaWb/rdpUGMmx8IRYixRxYlayDNPzzIPIILLMIm8/TBdt482+XkNIjAFbJd9pgD
	lonK/A+xr0EHwts2838s3xhV/F4f7nwa7QvmZW37cGxF2Vg77hxbXOmB5blYP69edkq8BT
	VH8JuUfCdmsCd8aK6sk/W+341on3Y4b63z+383q/4odrfQrBsyEORZsx49nMIOpFBtGKwK
	eNkONkk06Ds7GASzn6mISNCQdLj4JBLLmnonpkrc64TyhY0KqufcsO1NGIga5Q==
From: Paulo Alcantara <pc@manguebit.com>
To: Chenglong Tang <chenglongtang@google.com>, linux-cifs@vger.kernel.org
Subject: Re: kernel panic caused by recent changes in fs/cifs
In-Reply-To: <CAOdxtTbv9g4tW4RM9N-k_4C2HevQQNW9-2_7gKcFR51cjWbHEg@mail.gmail.com>
References: <CAOdxtTbv9g4tW4RM9N-k_4C2HevQQNW9-2_7gKcFR51cjWbHEg@mail.gmail.com>
Date: Sat, 13 Apr 2024 15:58:56 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Chenglong Tang <chenglongtang@google.com> writes:

> bfd18c0 smb: client: fix OOB in SMB2_query_info_init() by Paulo
> Alcantara =C2=B7 4 months ago

Does your kernel have eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
arrays with flex-arrays")?  If not, then above commit would be a
potential candidate to have caused the regression [1].

[1] https://lore.kernel.org/all/446860c571d0699ed664175262a9e84b@manguebit.=
com/
