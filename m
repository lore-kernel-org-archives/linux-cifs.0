Received: from wfhigh8-smtp.messagingengine.com (wfhigh8-smtp.messagingengine.com [64.147.123.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF181F951
	for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 02:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709173974; cv=none; b=fNGJjSgU0svbSB5ji2TZfBh140bDOrxovt9vy5Try6601nOE3+Frdpbtrf8LPxuYuPO7C8ECpJX6aIfmiIQ5z0ebY/J/L8aNGo1JZFnK0XGqfqWSjtkEmQtDL+uGMojnmL3iISuAsqt3qgESbUUY7pool+rUYDKZBicdDs+s7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709173974; c=relaxed/simple;
	bh=jpH8NkAjKRsjYCmgjwpdQeArjyz8dcg3YoAstpjzU/o=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=sbEr9Pc49gqbvMTJ73mxp/XnMPWUXjFm3TX224P6c0BmjsxJcvgIGhVOeqPBemqQJ6jEmqNJTjL7+Tb02XiNXjG0dGxBEF5rtCv8JRYvegM+xnEbMZYxc8geJrdKpPw3Ia5qMQtJvTFtT015tU3XULbrXDEU6w2X6bfMZfFH+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tempel.org; spf=pass smtp.mailfrom=tempel.org; dkim=pass (2048-bit key) header.d=tempel.org header.i=@tempel.org header.b=ZzoCNYG+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SD8W2503; arc=none smtp.client-ip=64.147.123.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tempel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tempel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tempel.org header.i=@tempel.org header.b="ZzoCNYG+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SD8W2503"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.west.internal (Postfix) with ESMTP id 1C9F1180006C
	for <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 21:32:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 28 Feb 2024 21:32:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tempel.org; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1709173970;
	 x=1709260370; bh=cnUIB8lNhbPMQP45bY5uhXAGRNWg78H+ssinX/JhsWs=; b=
	ZzoCNYG+GA/qqzHdtCKqkHp2jgJ+wu9BnHfyASkjHZJ7o4iehOwDCCe0ZSzsyZ6B
	AVk22Wg4ZwBqiO1uKcJRJ6bO48oFUQ3RXPZju20HoUJAXeuyNK/kh4b2vQQz9nXW
	mt1Yj37AeU9Si+BlYe1dZPNYjxg6j+28fh208n0z80k1OypgjZNDv64Z1g9fKfpv
	bEdJaZ+7/2tr5VqtA/hVCkxtNG5FojBK/hp825XCbr88DXF0WC9Db23JM4lIabnD
	84NeFPLEyxBVYzE904vz09BKQzz/CpQlUtpKFYOiRvGhpUoZJfPo5cpFGYG5a5sX
	59BblyQCTdY4tJG5R6RuHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1709173970; x=
	1709260370; bh=cnUIB8lNhbPMQP45bY5uhXAGRNWg78H+ssinX/JhsWs=; b=S
	D8W2503dDSdM6ncZN6SfXxCuLjd3PUalxrh6aaskPWvTu3fogKBq0PuL03FiR1/p
	bWK/hGAxQlaRNpOoU6hMpevB3nJvXIs1EJDZYasKqfwoY30A5tAOfm9qwDhRhdjY
	H2+uBNDV71BdG6FFyR8p153NWgUWg2/LEXthwKPDtOwKNBYwp6m5ElM9oKwt3iPR
	fE48edUgdEXzs/r1H6DE8MoT8EYlIHSJ8Yxsc8gi8yCHeqwvRJia9OFs8lxJXRc8
	YeSmGzP7N5IeZEzbzLtswmXO0nhdo4HbZUi9X8nM192SAbd7G7vOM1l7HsQGaEcs
	f4+ITgLrj+c29AfGjGUPg==
X-ME-Sender: <xms:0uzfZcCm4mjrJ979Kh7AuqhegQ4qWgUDwmxc_fe-2s-YYNzA54DT4w>
    <xme:0uzfZeibR8s1wbxaS7zWOZAPvOpJdHdGo3ui4PYCveT4Ok0BIjEoyj0y8yFKr17Gp
    k4Ick5iXSQKb-czrw>
X-ME-Received: <xmr:0uzfZfkp0MT2wDTXVu3kEh84HKwqeKGGGlExD4FYydwndLgW2G8v2Mpc_2BYNssBJsWJ7LXNHlWfPCtiamrVwOlBg3W1k1UTwZpozMHu0tWh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrgeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephfgtgfgguffffhfvjgfkofesthhqmh
    dthhdtvdenucfhrhhomhepvfhhohhmrghsucfvvghmphgvlhhmrghnnhcuoehtthesthgv
    mhhpvghlrdhorhhgqeenucggtffrrghtthgvrhhnpedttdfftddthfehteetgeejuddvfe
    eiveeuffeitdehudeuhefgtddugeettedtleenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehtthesthgvmhhpvghlrdhorhhg
X-ME-Proxy: <xmx:0uzfZSwBx7a3xupIJWINgdxaDY3BgPXEG6JpfLMNc9U0aq5ZpvG4jg>
    <xmx:0uzfZRTMnBYmzt9LamkLmB36lC6OdxmuV0mzj_gIP8ytlMV2-DMyPA>
    <xmx:0uzfZdZ4c3tsky5OC7y4KtH_XPn2exfIYu5siWxaJvm4civKRx_Ncw>
    <xmx:0uzfZcGCsTV9XycGoDfkNmFexPowUekbJGDA2GTSO4CeS_NBM8kXwbrUVSk>
Feedback-ID: ie07947e6:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-cifs@vger.kernel.org>; Wed, 28 Feb 2024 21:32:50 -0500 (EST)
From: Thomas Tempelmann <tt@tempel.org>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: Samba 4.20rc3 does not build on macOS
Date: Thu, 29 Feb 2024 03:32:49 +0100
References: <AB35292E-7B6C-4B8F-BD1B-E51B5C820ECB@tempel.org>
To: linux-cifs@vger.kernel.org
In-Reply-To: <AB35292E-7B6C-4B8F-BD1B-E51B5C820ECB@tempel.org>
Message-Id: <4A302905-533E-4786-93F8-E545FE953BE8@tempel.org>
X-Mailer: Apple Mail (2.3445.9.7)

Sorry, wrong list. Got confused after majordomo gave me the run-around. =
Will unsub here again.

> On 29. Feb 2024, at 03:08, Thomas Tempelmann <tt@tempel.org> wrote:
>=20
> Hi, I am new here.
>=20
> I just tried to build it because I would like to use the "wspsearch" =
(thanks for making that available!) on macOS. (I also built it first on =
Debian 12.5, which worked fine.)
>=20
> However, ./configure aborts:
>=20
>> Checking for getrandom                                                =
            : not found=20
>> Checking for program 'pkg-config'                                     =
            : not found=20
>> Checking for GnuTLS >=3D 3.7.2                                        =
              : not found=20
>> The configuration failed
>> (complete log in =
/Volumes/Data/Downloads/samba-4.20.0rc3/bin/config.log)
>=20
> I suspect that's a known issue (I guess "macOS is unsupported").
>=20
> Does anyone on the list have a solution for making it build on macOS, =
though? I only need the wspsearch tool, maybe just for that?
>=20
> Thomas
>=20
>=20

