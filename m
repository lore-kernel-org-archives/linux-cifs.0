Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706255;
	b=TBEXe3ZEmaqNgx7Q6vs/GFWVilhFo5ZE0MxalqgqFgnaNX/G8NmGASuyR/+EorLF10Oi
	 U8+Q55HtHQKW1PqB9Pxre5dSuL4hvt0Sas4WyTc37UgJZ+vBTVIk9PgYBx40I12uLw6eJ
	 tHUvQ7LY8L2NZ7IdjXJhHpqGXMj9enUHAz/y+Oqrtz9SLnTrW46mfIX1WEBCYqQvFVA62
	 k6JwHrYYzU/B1sE3a7M1uCGOjdnB2fPDW/CTCnW5UbRz5+PZ7hniY1CzrpAoOVz16VWjG
	 5hJp8KmZM2/aAuaRNeTYnC/YbqPsv/drr/y2kyyhFgvPIxo6wOa0fvZKE6K6W8frUnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706255;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=6cNJYOTmZ5MbGA5Pko1tW8+2uGtwtwOR7s1crng2nX0=;
	b=Jq9RmiIonO8MgXDteLxdmu9XyxaY+AM9Qvliio2sjJb5qhqiPRiXLH7akXGcc2shhd6Q
	 8nz8TppGshvJlXE2OJR7Id7B5veI86VpZOLfdUyxw8+xM+MA1SQY6dAI5el4cTO+A5qbX
	 hx0RO3is8viK9GWOSPtFwhzHBm+dp5e27KFjJUYuFhB4OP6V7bWFl6sgw0GmVb5SO5Q/x
	 Ibss7Po9R68O/gCv4HR+pPZXpuJ1o9zg61j4pCFR0ZZiFG7R6fnsiT4mvOmMN9hwShs7M
	 5TRXVZBAnthAbPa/nakwRCFJNneNJcYndGUrSUanDEk+JfISz4wqyIspwuv2kNLWmbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=3b+rqWAU;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9D1606A321;
	Thu, 26 Nov 2026 15:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD9D1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=3b+rqWAU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6cNJYOTmZ5MbGA5Pko1tW8+2uGtwtwOR7s1crng2nX0=; b=3b+rqWAUiW2+pRdAe5ditUXtJE
	UWsJk8lxjGhGDoKAlDejpLmn4eMupKQQxb7gAcfLKMEZ3qHLGfSf9i9eCLMVlhF0VH/gH+FMn5uxX
	Gurmm9jm2QQZR3koFzQtAL+xn4Tr62XXibVHXr27Fz4JA1DUwAxZvY73Afso3XrByfmB7fD0lEG4B
	XnMr09H7eNzl0ae9kgteQaBvXayzkvm6cvMy7vdKvmDjFO7wE8rtpG4hba96J6ujfcUEHxGexjuMB
	5r81Zzl2uSRqz/KgHC84AdklI2Z4bvdY18NUOu3iv8lh8Dk/WLTLaJ0t9u46GMHCHkiIrlV+Ip0PR
	YSb67O3g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xWbE4-000000010eB-1JxU;
	Thu, 26 Nov 2026 12:17:32 -0300
Message-ID: <0123330912f899e2f60ea647d767880d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Abdifatah Suruur <suruurism@gmail.com>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Abdifatah Suruur <suruurism@gmail.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: reject oversized SMB1 SET_SECURITY_DESC data
In-Reply-To: <20261118125249.25375-1-suruurism@gmail.com>
References: <20261118125249.25375-1-suruurism@gmail.com>
Date: Thu, 26 Nov 2026 12:17:31 -0300
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

> CIFSSMBSetCIFSACL() copies acllen bytes into the single cifs_buf_get()
> request buffer at data_offset without checking that the data fits.  The
> buffer is CIFSMaxBufSize + MAX_SMB2_HDR_SIZE bytes, while acllen comes
> from the rewritten security descriptor produced by id_mode_to_cifs_acl().
> A malicious server can return a descriptor whose rewritten ACL is larger
> than the buffer, so a chmod()/chown() on a cifsacl mount over SMB1 writes
> past the cifs_request object.
>
> Reject data that cannot fit before the memcpy(), as the SMB2 path now does.

Please check sashiko's review

        https://sashiko.dev/#/patchset/20261118125249.25375-1-suruurism%40gmail.com
