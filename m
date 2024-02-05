Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3B92E63B
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707147092; cv=none; b=c+OUeDX2xzTXjIfs78bbEN7L6L84QOFyXkzs5jVuOVrIn8x+PJ3Ow6Or4ycl6tH5qKKzTEzfUfJRPp16UOWbw6QUQBbbYA02omFRz4w9w9wAYaOKWvzKDc8MUJysrWsaETNJfM+tmJZNptPX2ax83BGsJja6Ld+L8YHBA7L7VG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707147092; c=relaxed/simple;
	bh=sFn85562wQscrqlW2SWfz1OLFvmKD6XAbCq8DINb7Y0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=TjTBW9HNn8aJHeIiJl7PhJ6L6Jbemaz6y67t4cJOzVyLogR3/D+7epS9CA+XYe8InIHhfU4/gz8umOBksX9YQOtlrLBYniW3Kmi8P2fCICt84C9VbzyUJ3uNVPHAp+LWv1roy98FHGfEYPh5xaCHiAya0iheay+tQxxBoEWFTE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=brvqgXB0; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="brvqgXB0"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4TT99k19Knz7yXS;
	Mon,  5 Feb 2024 16:22:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1707146570; bh=sFn85562wQscrqlW2SWfz1OLFvmKD6XAbCq8DINb7Y0=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=brvqgXB0noSeXt8RvxRVX1ZhAfur3JEVQzhcrzcnecPJzUljpcuntcS2KkIAetW8T
	 GhSxyLgBqcphlcjCWvmVazyfuSF2Epos4Pm5XUmAxCQc3HTZtT1TIn2rMP26T0FznD
	 GrI0bHlyd0UzmOEfLk+XAn+c5JZ1921lL9+4Tpe6wjiTdGkx5V1vVKAgPSZ2UrMndR
	 G6kZqwOlHg7afb+g5CToiYvM3ha4lkxzQhd/rpdlE/OIHlm2wfTMkuEUvVu7uwh9qZ
	 Ex5pYDxsVP0KqYRFTcCXqRjon26OC+jvqPaD43xDJi4qfaK9KSyLPz7De27U+e3gmj
	 FKACd5BROWmXw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4TT99k0nYZz4x8n;
	Mon,  5 Feb 2024 16:22:50 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TT99j6Djpz8scr;
	Mon,  5 Feb 2024 16:22:49 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.251.92])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 574AE1005CA;
	Mon,  5 Feb 2024 16:22:45 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.251.92) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <1d06fc42-48f1-48fa-bdb3-5a70464d4d6a@rd10.de>
Date: Mon, 5 Feb 2024 16:22:44 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to automatically drop unresponsive CIFS /SMB connections
Content-Language: en-GB, es-CO
To: Lucy Kueny <lucy@kueny.fr>
References: <428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de>
 <b5a481ec-7c97-4b28-a807-606bea3617ff@kueny.fr>
 <ec340836-831e-462e-8a4d-3aece977e19e@rd10.de>
 <fbf6d02b-ea48-48d3-b273-47d6e545ea3f@kueny.fr>
From: "R. Diez" <rdiez-2006@rd10.de>
Cc: linux-cifs@vger.kernel.org
In-Reply-To: <fbf6d02b-ea48-48d3-b273-47d6e545ea3f@kueny.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170714656560.19847.18055257460856111304@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 574AE1005CA
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: lVltOmWlckiO45AN/wv82TZyuDSk5k/ahwtih8nM


> On my desktop, the UI can freeze for hours and require a reboot from TTY.
> The 'recent files' submenu in software seems to trigger repeated connection attempts.
> This is a major usability issue, and probably why FUSE is used by KDE.
> [...]

You are right, a lost SMB connection can take a long time to recover from. I just made the mistake again of switching off my Windows 10 PC without severing an existing SMB connection from my Linux laptop. It took me several minutes to tear the connection down from a terminal window. I wasn't even using the connection actively, but I had a Caja window (MATE's file manager) open on that mount, and "umount -t cifs" kept complaining that the connection was still in use, so it refused to close it.

I even clicked on NetworkManager's "Enable networking" option, in order to disable network support completely, in the hope that this way all internal state machines would timeout or fail immediately, to no avail.

Now that you talk about FUSE, I tried using GVfs for a while, but it is full of long-standing issues too. I kept some notes about it inside the comments of this script:

https://github.com/rdiez/Tools/blob/master/MountWindowsShares/mount-windows-shares-gvfs.sh

I wonder whether the KDE way is better, and how I could use it myself. I have had many issues with KDE over the years, so a long time ago I decided to stop using it. At the moment, I sway between Xfce and MATE, as both still have their share of problems, but that is a different subject altogether.

I have heard that KDE has its own "KIO Slaves", which would be the equivalent to GNOME's GVfs. Do you know if it is really more reliable for CIFS / SMB connections? Can you install and use it without installing the whole KDE desktop?

I also wonder about installing an SSHFS server on the Windows boxes. I tried Cygwin's SSH server on Windows 7, and it worked rather well, but I haven't tried its SSHFS support yet. Modern versions of Windows bring their own SSH server, I wonder if that would be more reliable for Linux clients, and whether it integrates with Windows security (so that you do not have to distribute SSH keys around).

Best regards,
   rdiez

