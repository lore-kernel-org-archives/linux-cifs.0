Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC70816423
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999022; cv=none; b=GQ6WYOIzaqcmq6vtU5owiP1V8bYq9meEPQyfdSF2zj8DH7pubFHvsm0op/uEmfAM4yREyNuqZVJ60xrcNbPKeENKucQxNXzZcwlC5U+3QSDhO4+g/3LEwzbsEAuysl3vanNa9Mo6c8DXNZ4cx/WzpkTW3eTShc1L9/Tmg9NeUT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999022; c=relaxed/simple;
	bh=a5r795h/Mz4zRuDgmwxE6rEhSwDu7apYfvhlOEvP3qM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=dcbrRwcbRPAsCRVRdLbtW9BJDFNEbX3Ro9MwI2of2fWNjAwODziLJMFH4PxFReuXa7Q/5bj00LmuMvOCi/oRLlRQxv3PLBuv77fU3mPGB0NxL99enoon4ONcHNAS6yInD+ayy+1lknLiEPJ+wevVKOZB2541GrrUnKnnX78wqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de; spf=pass smtp.mailfrom=rd10.de; dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b=L6F6Xyzc; arc=none smtp.client-ip=188.68.61.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rd10.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rd10.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rd10.de header.i=@rd10.de header.b="L6F6Xyzc"
Received: from mors-relay-8403.netcup.net (localhost [127.0.0.1])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4TS6TC2xkgz7ysh
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:17:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rd10.de; s=key2;
	t=1706998655; bh=a5r795h/Mz4zRuDgmwxE6rEhSwDu7apYfvhlOEvP3qM=;
	h=Date:From:Subject:To:From;
	b=L6F6XyzcRwL6oK3PBpGNVJ+KTmW5kTuaBsl3Ln0A2ayCJgC42OYuvz6r4va8UdCp3
	 1MkFvyLrn0hRNERQHQSIijRR0pR6NTiS9yWmfd8mPYr9tarQU1b0KFs7+d7F+P8RBS
	 Zt9wrhz2yB011kcR9K4q1mGvlODWDXc8jbyjiLFXLrx28Yhm0gM1QQ8N9I23KsraEz
	 Sl+O52zbi1x00UVix1ucZsQrIQYwf0DCuo6TeIslJUmlNddIrdbtQdV4mXnynQBwNL
	 kiTEwVTdvxAq3QOubg9YiiLIdWl7qSryh6pzkxWdoN38DRntZ/v2lCVLmRsD6PACXN
	 VpOSg/j2UcYbQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4TS6TC2YGvz7ysZ
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:17:35 +0100 (CET)
Received: from mx2eb1.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4TS6TC15jVz8svG
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:17:35 +0100 (CET)
Received: from [192.168.115.138] (unknown [62.27.244.140])
	by mx2eb1.netcup.net (Postfix) with ESMTPSA id A20F110048C
	for <linux-cifs@vger.kernel.org>; Sat,  3 Feb 2024 23:17:30 +0100 (CET)
Authentication-Results: mx2eb1;
        spf=pass (sender IP is 62.27.244.140) smtp.mailfrom=rdiez-2006@rd10.de smtp.helo=[192.168.115.138]
Received-SPF: pass (mx2eb1: connection is authenticated)
Message-ID: <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
Date: Sat, 3 Feb 2024 23:17:30 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
From: "R. Diez" <rdiez-2006@rd10.de>
Subject: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <170699865087.22854.2162666169918145527@mx2eb1.netcup.net>
X-Rspamd-Queue-Id: A20F110048C
X-Rspamd-Server: rspamd-worker-8404
X-NC-CID: Gh+biqSikFw3L8ZK5WIPjylvUxYPU1CzKkfPIebH

Hi all:

I just wanted to bring to your attention that SMB 1.0 writes appear to have gone broken between Kernel versions 6.2 and 6.5. Writing about 111 kBytes of data to a file is not reliable any more, you get 5 holes with binary zeros at regular intervals.

Here is the research about this bug I have done so far:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634

Regards,
   rdiez

