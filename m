Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F49499F2E
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 12:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790166962; cv=none; b=SW461DesorBs3fPqrZQQKdb25EQ0QPtJfg94LR73xaVnQHeSy8lRleHcesPXyTLjEjyzM2olpQUqhD0OI2AC0wMOZsUPSM3sa/AXDCtbsGZL4a0EBy56hVfk1wHdTWWQsj7hh0Yh7sUPYxYShWSa1PWOHPTqcKneJfDrPUY4Lkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790166962; c=relaxed/simple;
	bh=DeDZtizp/9btnRavUGlnUmKJ0pwtfG9P46A7uKvTUlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZ2s6LP9pL9NbVquTiw4Hk0p+LG0qEfRAOxWguDYm/c+kyx55DZlEGv8AkcIbi1hzN124LPZlE0d6nW4i0ZHLayaMKP88PPj04fExGhy7tPs9ObD+cIH8oIKqGKuPUfdE6Bf7RyXWYGllUVa4U18EYGQUshhel+ldWdf3Cqjg4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=hHMvaOao; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WqMAY9Ui; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="hHMvaOao";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WqMAY9Ui"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A70037A0111;
	Wed, 23 Sep 2026 08:35:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Wed, 23 Sep 2026 08:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790166959;
	 x=1790253359; bh=2wjHdwDAlhp5l/HlZTfjMoYaMl8K0a6jYEPkeuIFHIk=; b=
	hHMvaOaohsk+4TOmkILUve3KfSpVIpwRIxcfv906rgy/+wSdxNYCN2WQL5DRw2Y4
	clBb0q1h0q41DFIF3yCeljBjk0Kh18SMbvi2V2p7prDQuzZpRgrZm4rwnDpLWeoo
	u8a3SmI9wACl9tltxE14e/eqxn0F/X/GMAC3oI89v/GjvcRLDxFSaTwdCl9DkyZt
	ucoT2rVRrYV1iO5BMX0mN8CIKjEA+dUFLv36NXxrpxVfOVN564QhK6XW3Jo2eCBV
	bN0mVQ7gPHjozbipehp4bfGgywzxJW+fCgWKifnExEIWUOoG9a+w667tkv0dbWqF
	hgMDfJoIBrga5xjBCpmo+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790166959; x=
	1790253359; bh=2wjHdwDAlhp5l/HlZTfjMoYaMl8K0a6jYEPkeuIFHIk=; b=W
	qMAY9UiUx2MJpn/4kbmktJE9AA++wrSNP90fgmL/sQQcGSNPlrVEdJ/cMBuObCm7
	U6pKnkN0EQ6LozlLjoKCiHfwXkmF/95EdelMxnJEz6SdtKP3/040IUZBysa0e8k2
	thYqra453JRTS/x6/4oWKBDpoObL9h7kK48G8ADNqCLkVwporFTDzjv+cw0oh2hw
	mz60PoTffyIxgHJ2r8yaf5gv5fhr7zx6nsEUP5FDBQuO7B2ULwJe9A8xVoUhsNPu
	xu0uxEvgKeHGv5e9BKAhMhvOZfGDUNtLat4kUuUtM1IGPTtxTaMicG5Vin3IMaiZ
	EjrpEhPLR21JzOW5fFGpA==
X-ME-Sender: <xms:r8ezasYoB75KBxYeNgcJQCf387gxME3DGTTB19WVjvrITPoUGJptaA>
    <xme:r8ezam1knb3RkdywAc8XDP_33kEZxeY3BpvP3-H5qQE0xfO0BicL_TultkljHVfDu
    yxxSwhAuEzF8AgH8yXrVby43d1gjLoVUK17WMJqzXibeYbGKgI>
X-ME-Received: <xmr:r8ezaoC15NKX3AOcJAAkyiWg0xpzVjbHtWTX5QzcGiTImlF1BAPHFn1HDmNX>
X-ME-Proxy-Cause: dmFkZTEVQqeqPq8xXLI0VMjegImeLOZ2+Q6ApeZsGZlLTwtF3HexkHxyHECrDmv8z+U6Fu
    xvvXxoTbitN7zpqXwuVMyuQiNCCfpKq/oO9J/6PyYK5tgZNUH9CvO/afVA2MyMZxrSU+xw
    QEiYhFN2R3Z6wEF3btMr+Ee6qNlSqspuncXlWehopsBwNaoQ8A+v8i2VT0NaFZpvcs7gMY
    G7pEZPk1c3u2WUszvJVoj5cfQ6uqw+RcMFhOy/RrEJNhBrUwm8pHCKP+WHkZmmlBnebKFz
    vpGtlYEEpJ90ntrVD1T3fHJ1Bd+99Gc527yOybbaymdbdg/Cd+g8UMeaMsg8ChjdOh/nJE
    BnBNLPbacoi4TPipgWiJwgJgULk+ADgbWrZkgPOCa8s6sKHU4WpkJzeyU1awufStqyFV8d
    yleleoTrXGu1UHV6C62Bf+9ih9fvHVC5X4gS4n/b90o+5kWrKdKxrDhwZQX4ec9RCrOfTW
    a3d6Q8MWD14+hPKWxhHk8va/EivTQ1FCpdVdfidOaJvmH0VI1bGIijzkeEqfFkO4KZei1Q
    57DhzTgVJ867iX9kKT38Bo5FzT2ue0v6zBiwqMUP66KEPb37KafNPyRf+bKOo5+siWMxvX
    uShN8r8AL31Qs+NePnWE/UnXAFkTtS5eISo4HBmTxeExpkdojyuaxoTsx0WA
X-ME-Proxy: <xmx:r8ezaq-6HMy-UbaJHQHZnaDnub1U3Ki3eXHvYJhHnXY8tCe6WhfXJQ>
    <xmx:r8ezarUmLPRgjtvf23YUgowKUWqLJO-NAT-E_OHBpnU6ylCkQMXrVw>
    <xmx:r8ezarLoAJ3mNKtWYKcr1Yze9axesirNTi2BAJlE3PMjwWTDE8aMIQ>
    <xmx:r8ezanAKNqUTCY9VNzu93eyw5srXQsqV-psqZMsnmiZ5NLRzb0XCDQ>
    <xmx:r8ezahh4SdBA-Qo_Os160TP9EnueH0yVxs9TlWaQTKrj_8NwPfyOx6cw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Sep 2026 08:35:58 -0400 (EDT)
Date: Wed, 23 Sep 2026 14:35:56 +0200
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?5pyx5rWp?= <zhuhao@stu.pku.edu.cn>
Cc: security <security@kernel.org>, linkinjeon <linkinjeon@kernel.org>,
	linkinjeon <linkinjeon@samba.org>, smfrench <smfrench@gmail.com>,
	sfrench <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: ksmbd: unlocked iface_list free during server reset vs
 FSCTL_QUERY_NETWORK_INTERFACE_INFO traversal -> use-after-free (kernel oops)
Message-ID: <2026092314-correct-entrench-c63e@gregkh>
References: <AL*ADQCbK5q8mAaIolsqNaq-.1.1790153264029.Hmail.2401112100@stu.pku.edu.cn>
 <2026092344-muck-retainer-dd6d@gregkh>
 <AK2AhgCLKwK9zwB7Ti6KtqpK.3.1790166059428.Hmail.2401112100@stu.pku.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AK2AhgCLKwK9zwB7Ti6KtqpK.3.1790166059428.Hmail.2401112100@stu.pku.edu.cn>

On Wed, Sep 23, 2026 at 08:20:59PM +0800, 朱浩 wrote:
> Thank you for your feedback. I'm sending the patch and test report below. Is replying to this email the appropriate way to submit them, or would you prefer another submission channel?

Please submit it in a format that it can be applied in (please read the
submitting patches documentation).  This was sent in html format and all
of the whitespace totally corrupted.

thanks,

greg k-h
