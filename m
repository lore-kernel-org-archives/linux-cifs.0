Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039372;
	b=g5ybAXUB1SDqD98Pepw1d69mxHocSQRy999qy1j3/2CfHZCb9yIUj5JvZkVwc8Hha1+k
	 4aqSjtVmeVhHAm63vH8Lr3j5yGOaSVEG8MfciKmzvDU0mNwXO5+Jvx71/Vf3fgEAgoMs2
	 Or23pjweEnIZflHGeDw3LNsdueKwpACbRTQcAe0jLUehY6QTNe8MwT8t0VvQ0shYLWour
	 t7HlJfR4XQK1IQixr7SmAqZfaoHtgzLijVHCuWtxmYju+XYjFNtSfIT2/m5ob7xZ366U4
	 Nysa6fbXO9LtDBpqJKnEgt5e9LdQ5oTf0DecdXMlTK1/RX3UKpwUJ0h3kVud8GAzDOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039372;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=5RMqObuj0fL+2jdnL0nqymmDC8FL7Dnnl2i27KqPBdo=;
	b=V4n289mhPSn64t0tWL60IbApYWlv1KNfa/wDwVxGtn9cW37G6LpvZfuy/5G5/Br2G9f1
	 DRCumyUtxvyLousm9BySKDYXw7KJjCrU/9k5MxCEBd+Sn7pqNr32k3qNDjnWvWo0ifRU+
	 Ji+9i30wUcHb0/7dTFHqQ/eSTbEF4J/tLrxre158fSIfBP1A+tIUhnYw+g5ty0Yba05x8
	 44LL7s5by1Tgf9VhOYstu71Mm5hhjn/c8fkRx9UZd67B9JBsXworhx6UDGTCzOe1Y/lH0
	 +/WSEE7vBfEL4QmKuaXgKxisIMMoKOk1RUx6xzPrJQP48tGR7qdLmNJQF4aJ4wCOtOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=lhZEe7j8;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDDA606A32C;
	Wed, 18 Nov 2026 22:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EDDA606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=lhZEe7j8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5RMqObuj0fL+2jdnL0nqymmDC8FL7Dnnl2i27KqPBdo=; b=lhZEe7j8EqJRkrtOxvTsIzWjRq
	QFlsxnE1RuPHwRC47VXH3t5xZXqltIiyGYqsJtEXPAtYuJdbGrmzoFA0KyBu8xoWsKA79rRpa+L71
	WV7vDQ2Szsce3qf7JmiVDp0ZV1YdwmBtgF+1PA4pMzztiW9ve7EsgA7spSnoJ3erfAHkfEXuH5cBx
	2KzHnpphrlloCD6E/Fz9BVzzNF3iqZ+CO2tHF2zd3Zsf3aim5AfqZwhp0VUs+TRvYbRtT4sWrXUv2
	6SW5hdfaHj8g4PK7noSYfD2W9XZm7Zvz4jwnH+ls/8XgmS6ae7a/7TOJlgTYxu6/EAegnsPreh8C4
	RPFnkApA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xTnjk-00000000KWJ-08hW;
	Wed, 18 Nov 2026 19:02:40 -0300
Message-ID: <696b8c3e063478965da1084ffae1d6cf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: shyckless@gmail.com, linkinjeon@kernel.org
Cc: ematsumiya@suse.de, sprasad@microsoft.com, linux-cifs@vger.kernel.org,
 bharathsm@microsoft.com, ronniesahlberg@gmail.com,
 samba-technical@lists.samba.org, daniel.birtwhistle@gehealthcare.com,
 linux-kernel@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com,
 tom@talpey.com
Subject: Re: [PATCH v2 1/2] smb: client: fail SMB2 responses with a bad
 signature
In-Reply-To: <20261116-smb2-sign-v2-1-a823a90d0db4@gmail.com>
References: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
 <20261116-smb2-sign-v2-1-a823a90d0db4@gmail.com>
Date: Wed, 18 Nov 2026 19:02:39 -0300
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

Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
writes:

> From: Suyuan Wang <stevewong@hust.edu.cn>
>
> smb2_check_receive() checks the response signature when signing is on,
> but a failed check is only logged:
>
>     rc = smb2_verify_signature(&rqst, server);
>     if (rc)
>             cifs_server_dbg(VFS, "SMB signature verification returned ...",
>                             rc);
>     ...
>     return map_smb2_to_linux_error(mid->resp_buf, log_error);
>
> The status from the response is returned as usual, and the caller goes
> on to use a response whose signature is wrong. This is the path for
> synchronous and compound requests and for smb2_writev_callback(). On a
> signed but unencrypted connection, anyone who can modify the traffic
> can change e.g. a directory listing or file attributes, and the client
> accepts it.
>
> Return the verification error instead. That alone is not enough for
> compound_send_recv(), which still hands the response buffer to the
> caller after check_receive() fails. smb2_compound_op() then maps the
> status from that buffer again and copies the payload out, and other
> callers look at the buffer on error too, e.g. smb2_open_file() parses
> a symlink target out of a STATUS_STOPPED_ON_SYMLINK response. So also
> mark the mid MID_RESPONSE_MALFORMED, and have compound_send_recv() handle
> it like a mid in a bad state: mark the earlier mids cancelled, so that a
> CREATE which did succeed gets its handle closed, and don't pass any
> response on.
>
> Unlike the SMB1 fix in commit dc96f01d54cc ("smb: client: terminate
> session upon failed client required signing"), don't reconnect: this
> runs in the thread that sent the request, and only cifsd should call
> cifs_reconnect(). And fail the request whichever side required signing,
> since a response with a bad signature can't be trusted either way.
> ...

Applied.
