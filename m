Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787066;
	b=R2OtqiUcKeM4eLRbXEl9UkmxvdQFJOfivkPrvgwgWvXY5kcdoVrYodLgeGHGimrJToJH
	 kakZxwRvSAPUy6yiYW65txLDEGXDJFP0QPwqYBLzo7UkPjISbY2GPWQ+2oewbCum/fdPV
	 kz/SnBUwpBTXTxyFXZT2S/ua1vAuH61DNdueg8Sxrcq7J8ohk1QNadYAi+J5vgT7SBGIb
	 WZ4w+MnZOLTzaXTi/vZGVLTyx2ffTU9xH9mdRk/yrfUIXmJNN2FSENhV566xDkVGp9M6Z
	 mKWwSAzR9Jh/QoV9nMI2xX3LRgKJsEqVLf7PsxtpIFFa9AmibWJ08ZSRFPr8vPJjV+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787066;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=mim1g06j4X6tGRGZs0n3cllh8jQPapwnxGe7PyzOw/E=;
	b=QOMo7a1E4Nxwc0UiSy8wiKg2lv7Pj0X2QGT6BGkPekDCiI6HILe2cUuju/rRwrm9t7zK
	 IPqpFbDRFeTJsdyiA4r4wFfuiJz5jQjVp8r8T1xBHYOZYY/55RYN8LErM3TSB5M4wMApq
	 ibZLLm4htwcPmrXlsPTfTAz4aZvQoGtKSPVzs10bEDqS+kG5qePHzUo5x4TidQf3uXcK+
	 Ozp47+Gcp8cZzo7M1+h/eoB6yGwyub67xF0zcYFg2WGWK71ZuuTBlwNhcdDjEJdbPRMQx
	 6gb9YY/BshwpKVP9f2msQP9jeBkSqOXXFJfFFSRjQEKXb4IFaEoAIU+VUFjns3L5BXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=1tXOFMWt;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE9606A320;
	Fri, 23 Oct 2026 20:24:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70DE9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=1tXOFMWt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mim1g06j4X6tGRGZs0n3cllh8jQPapwnxGe7PyzOw/E=; b=1tXOFMWtNCA4TqQgHCGjLR25tR
	Q5J9i1oNw5/lcJoDWPmCzTdpIF11l6u7aKQzubRnhU9VQb0SyhV0z4XGHFSkiwufSA9c4GWvjt0SS
	LKlfELxa6YRDZPDaZasrhTh17m9g0v4uc8ZzSNii9cpY2QMzobIbUIBKA7L3bLhBgdL5JzsjEqpgw
	fHHm1/qvhWx+H2ufJVP+gGly+QUzngjqp1zTM8H6nYabdNJ/PWV2HJzLH71bs/WdNy+ZomNbN+WlK
	pCR1/YF7pX56qPm4MeDHWeC/KI/g4QTuGwWMjq0JIlr6cePgyCofwtLBZde2esM+39tWVjkvQsmsi
	+ueux4hw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xKLoF-000000006oo-3d5l;
	Fri, 23 Oct 2026 17:24:15 -0300
Message-ID: <c416b30156fc537af171146be013dd28@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Abdifatah Suruur <suruurism@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix fiemap wild read on empty truncated
 response
In-Reply-To: <20261023115246.23030-1-suruurism@gmail.com>
References: <20261023115246.23030-1-suruurism@gmail.com>
Date: Fri, 23 Oct 2026 17:24:15 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Abdifatah Suruur <suruurism@gmail.com> writes:

> smb3_fiemap() treats -E2BIG from SMB2_ioctl() as a truncated range blob
> and loops for the next chunk. If the server reports
> STATUS_BUFFER_OVERFLOW with OutputCount == 0, SMB2_ioctl() returns
> -E2BIG with out_data == NULL and out_data_len == 0, and the existing
> length checks accept the empty result. The loop then evaluates
>
> 	next = out_data[num - 1].file_offset + ...
>
> with num == 0, reading 16 bytes before NULL.
>
> Reject a truncated range blob that contains no range, so the resume
> offset is never computed from an empty response. Also require the last
> range in a truncated blob to advance the resume offset without
> overflowing, and to stay within the requested range; a malicious or
> broken server could otherwise make no progress or underflow len and loop
> forever. Free the previous response buffer before retrying.
> ...

Applied.
