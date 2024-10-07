Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [185.244.194.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A9A189BAA
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.244.194.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728289991; cv=none; b=rl0ykwi0OXHGXlgbaIgOYtJjDGb0HRd3CwzoLzvPo0eYJNEndKNk5Tazu6+24uevDR5K5U8pvKmFfJLojPmKdVwKlhcnm79Xgfv2a+fsOqb70FGtBmugnkc4SXWvCTD9El0KhTUP4s3bcKGNEbeOKL0/5VGt7l90eCOdGHB3Uok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728289991; c=relaxed/simple;
	bh=VfjICuvGqSHbvYVcFw5xSSjPzNCcZ34PNNnNt2g6VUg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=WHbco3QuLPKR6Dh07ATQobgf7yIwAyzrvfj1gIaxiBByYmGIbU6sJVNaVAn0Gf2O8nzytPynbAsLp6cRQ6FPV5tpzPk5cR+CVuLlg+TazPoaEtT/Zy/kG/5ijxXjnmoQMHTkKsDFKotyhJBXNE55grXJMRiqRezL05uph3PtESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=ZYfNaWWC; arc=none smtp.client-ip=185.244.194.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="ZYfNaWWC"
Received: from relay01-mors.netcup.net (localhost [127.0.0.1])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4XMXLN47gcz8ypM
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 10:26:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1728289596; bh=VfjICuvGqSHbvYVcFw5xSSjPzNCcZ34PNNnNt2g6VUg=;
	h=Date:From:Subject:To:From;
	b=ZYfNaWWCNWZmAemCW+KD+FGP/hd0jPi+/Y4BiTWrFEBBb1XLJvAI/bhttnnRMKQZY
	 Dfhyowqw5aFugjZdbYrpoSwcmffolCkK2i+fcewHrv4/TL/jKaRCrrjMHLk8Megis9
	 HfBDsANDHlkUZXbBoAj6L4CwFkpOGsYVupRZtDOoJ0JCOIzXlHPXqOwT5PE8GgljQM
	 Pam1Um3zhyjtKEFMIQm6RrTDhldX6wCGdn0aBSgLTsIKMfkspHn4Hs05mt9wdrNdmD
	 9wrwIDsx/NGj/WMOk9llVYOkvRd2CboFZwwMK/z12YAGEked9bFlf8A6hvE3OLeAH/
	 gjoq+6TWzIqDg==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4XMXLN3S19z7w93
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 10:26:36 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4XMXLN0Fpmz8stl
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 10:26:36 +0200 (CEST)
Received: from [IPV6:2a02:3102:8e00:19a0:79c:a09:cb9:e47c] (dynamic-2a02-3102-8e00-19a0-079c-0a09-0cb9-e47c.310.pool.telefonica.de [IPv6:2a02:3102:8e00:19a0:79c:a09:cb9:e47c])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id 651B410037B
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 10:26:31 +0200 (CEST)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 2a02:3102:8e00:19a0:79c:a09:cb9:e47c) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[IPV6:2a02:3102:8e00:19a0:79c:a09:cb9:e47c]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <b00ade8a-3cf6-40f9-8015-1602c12ee890@rd10.de>
Date: Mon, 7 Oct 2024 10:26:30 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
From: "R. Diez" <rdiez-2006@rd10.de>
Subject: Long system-wide pauses when CIFS server unreachable
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <172828959169.1540.3076345399963234424@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: 651B410037B
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: e2Z+afvF4oS1/bB9gFe7VMTMJvfWj4X1r6GRsfqc

Hi all:

Today I forgot again to unmount a CIFS mount before turning my Windows 10 PC off. After resuming my Linux laptop from sleep, the file manager and other applications froze for a number of minutes.

Unmounting the unresponsive mount was difficult. Command "lsof | grep mountpoint" showed nothing. I am using echo_interval=4, but that does not help.

I reported this issue here some months ago, and got some feedback from Lucy Kueny, but otherwise CIFS maintainers were silent:

Subject: How to automatically drop unresponsive CIFS /SMB connections
Date: Sat, 3 Feb 2024 23:48:42 +0100	
https://lore.kernel.org/linux-cifs/428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de/

I have been experiencing this problem for years, both at home and at work, with a variety of Linux and Windows versions. It is a well-known pitfall.

I think that this is actually a serious issue. Most users wouldn't know why the Linux system is suddenly unresponsive, or how to fix it. Even restarting a system with a hanging CIFS connection is problematic.

I am using Ubuntu 22.04.5, kernel version 6.8.0-45-generic.

Is there some new work-around available nowadays? Otherwise, is there any chance that the CIFS maintainers will take this problem seriously?

I am considering switching to OpenSSH for Windows, but I can only do that with my personal Windows computers. NFS for Windows is probably not an option. In a business environment, most Windows sysadmins will not install other network protocols anyway just because Linux has issues, so there is not much most Linux users can do.

Regards,
   rdiez

