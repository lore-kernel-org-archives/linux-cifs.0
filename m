Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D91B94C
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 12:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707135051; cv=none; b=SNLfayW8Ir7iqZU0E/XsCSaTKa1r/AXsjanrqzMs9y3yHvpO/zQ6mIthlrT/kSL5tNBaNzkR9njIZ4QiFO0Wg+yLXe/4wOvfaOkc200zyvOky9ZNvxX1m6lSpATNqplVX3P2rckhABqO+kPk/GA7cdWKRcaEM4Uk/6T2IJqkn64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707135051; c=relaxed/simple;
	bh=syXo3fg0izAVeytsQ4bx8K2N7S+iUD8da40RgFr/nrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bdvrJv1fuAGbrVMVyOJFlHTH4Y8eiNRSem0TyjBonzJCE4bApDXgzm9m6Igi1jXGQJLRMD4ktR7N3cPiIlNnXd07zBbJUBzHSWccQpotqKd3J7x+NAxVqCMXHxeAU4B1+fOrEBzoyuuevPTfCjDfJyPFBQR3l7EEbIcfhoJhcpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kueny.fr; spf=none smtp.mailfrom=kueny.fr; arc=none smtp.client-ip=212.27.42.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kueny.fr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=kueny.fr
Received: from [192.168.0.17] (unknown [86.242.90.107])
	(Authenticated sender: lucy.kueny@free.fr)
	by smtp2-g21.free.fr (Postfix) with ESMTPSA id 4F2D42003F3;
	Mon,  5 Feb 2024 13:10:46 +0100 (CET)
Message-ID: <fbf6d02b-ea48-48d3-b273-47d6e545ea3f@kueny.fr>
Date: Mon, 5 Feb 2024 13:10:44 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to automatically drop unresponsive CIFS /SMB connections
Content-Language: en-US
To: "R. Diez" <rdiez-2006@rd10.de>, linux-cifs@vger.kernel.org
References: <428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de>
 <b5a481ec-7c97-4b28-a807-606bea3617ff@kueny.fr>
 <ec340836-831e-462e-8a4d-3aece977e19e@rd10.de>
From: Lucy Kueny <lucy@kueny.fr>
In-Reply-To: <ec340836-831e-462e-8a4d-3aece977e19e@rd10.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello rdiez,

> Many thanks for confirming that this problem exists and bugs other people too.

> Let's hope that the CIFS guys take this problem seriously. The Linux desktop freezing for many seconds in a row is probably putting off many users.

On my desktop, the UI can freeze for hours and require a reboot from TTY. The 'recent files' submenu in software seems to trigger repeated connection attempts.
This is a major usability issue, and probably why FUSE is used by KDE.

> The first issue is that there appears to be no documentation about the Linux Kernel CIFS client's behaviour on connection timeout. I find this frustrating. I have done some research in the past, search for 'echo_interval' here:

> Based on my empirical research, there is a fixed 10-second timeout when reconnecting. Therefore, I would rather have an error returned as soon as the connection has been marked as lost by means of 'echo_interval', instead of after attempting to reconnect.

> This may be hard to achieve if the reconnection only happens single threaded and on demand (when a process is trying to access a file under the mount point), instead of automatically on the background.

As I understand it, the connection is managed in a separate thread.
The 10-second timeout depends on multiple smaller timeouts in different parts of the kernel. It's almost impossible to change.

I believe the echo_interval triggers will cause a reconnect attempt to happen, thus "freezes" will be gone after echo_interval+10 seconds.

It's not the best, but it allows the use of a permanent mount to a NAS without trashing userspace if the network goes out of range.

Best regards,
Lucy Kueny
