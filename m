Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0AE29BD91;
	Tue, 28 Jul 2026 01:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785202846; cv=none; b=mufKRs/sFz984ddJKnCEyFFuchPS9rvxwYIwlkTa/tC8NEc2u6puz06dcRxiWzF3K+7CjensqzrgcPTv1MCVLUQCzhWoFe3/Ec7S4WnQ+QkiC0redgd5qdWRP5P5a0ynlV2bHOE9mp3etCRSo9vQ0ATeC2pB+i9mIn3rgBkNYmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785202846; c=relaxed/simple;
	bh=rWV6/2/RFrqxnluL/f5gTroGqPOblBVRNB9N2gQ27Lg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=V0vZWiVVlz9i7I+pcsUyVbI2QFPJtDRtkChrpv3LnqAawRMbQr4I9jp2FL/lVT/mPyyRx4J7MCUaVl2cdzKqL2uIjGQ00WvxeR47Im7wzej6H6aduMtSPjkNCcZ7OJLVuHLqlL4/DX1wpWUDmL+cZVRVSNH0HI5e2wwTK5Nqbwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHa8TX1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHa8TX1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384021F000E9;
	Tue, 28 Jul 2026 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785202845;
	bh=ja+1SsJ/lxrB2YJx9HXIkuxDt0HvI/ZYxwTmCQkMUNY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lHa8TX1DU5kSUfW8Tm1jn6Dcm9DbiljIBR6peIHfHVIT7hSbfDXDhbhqvzx8sh/WV
	 I337my09MHK1bKmyNBAWqe405SqHXfd4pZg/gZ1ENKMlERHpzMWce0Cd4ihf61kqyq
	 xIMEYrXOVH8T/s6ooWG8gnJKl8Jgf0mQ1iu6Z4RjXsFETYM2BD3Aza8WdLUQCTuEjM
	 9jjGbOlv3/x8wZso7DY002/v22Ub3fJ854iojzaNKIuT9TgAyGh1tCm4C4APZmGZ2I
	 mOa4kRD4ZdKefpaD9oi7WoX84PXDpMGBh68qjGif9jar0sTj6RCmJPp6NxaM9KSG0Y
	 TtS+Uz76+LqPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9390C380CEE1;
	Tue, 28 Jul 2026 01:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dns_resolver: allow shorter names in
 dns_query()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178520281013.1496519.1216459605963417675.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 01:40:10 +0000
References: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
In-Reply-To: <20260722-net-dns_resolver-v1-1-c3385898ccf9@manguebit.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, dhowells@redhat.com,
 sorenson@redhat.com, netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
 plambri@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jul 2026 18:28:37 -0300 you wrote:
> Customer reported a problem with mounting CIFS shares where the server
> hostname was 2 chars long.  Turned out that the CIFS client wasn't
> able to resolve NetBIOS names shorter than 3 chars.
> 
> Fix this by allowing a minimum of one character per hostname in
> dns_query().
> 
> [...]

Here is the summary with links:
  - [net-next] net: dns_resolver: allow shorter names in dns_query()
    https://git.kernel.org/netdev/net-next/c/a50eba1e778a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


