Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120F233958;
	Mon, 17 Aug 2026 18:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786991857; cv=none; b=IWN46KS4ptBMkQkz1km4nRGVhBnG4ZSGIhegT86FmzbA0M3n3amjHLCzQOYz4B/9A+Hvk//Sck4bMhLsueSPHnatt7v8daOY0/OpiNEZo1nsjVWgd56pLDTz8zjAYsRPiPSu+Wu7hgRtLag2RSM4cPy0mmktA0EjJhCpT9q0IQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786991857; c=relaxed/simple;
	bh=U85LDAMK/A6NJ8B8DZMNvIm88HpsEcZBY2TmWfO/x2E=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=IhSNJD/7VnkvnqJf1afLFunCetthIkqe0njV3DWm7/TS7xKMz+inJ38WMyXqHmxrVZG8U1KW29XS+C809RqEoTXLvySw5xmLN0rcuiLTeEnRSszvZHOOCAWPk/X6U9Sb8iQ30HZQZSwLCvo7M7e0y5Zqw0nCcPdwd4JnHmU5WDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=a5xe8Sd0; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="a5xe8Sd0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=53E9Jpbg3eCRROpWbHch7NuxkM40Oow6A5i91k/57jQ=; b=a5xe8Sd0e8XDb9COp9h08KYJql
	ZDanMLvxx56F0utZsYwqCRGjyTL0+/wS4iyh8Oetgdt2eTXBCgqN1mTKkmnI0JZ36L9yB4rimBQ5l
	Sh/SQDaQn14rmDPkxJ3xWV3j7gxWRlMdTkuX4/mP484MtXLhV4hI+WALpX8V3/3dVGqIHnexdHBr4
	EPrWLDEkbDSCJHeecvc+tFhNVD3oB+9g5tAzBBlMm+2gPyCeNRXJovmplbKUciDEe7bsh0WrWAdU1
	G2HtziAt5mjT7iJkIawKaZkyR05vAYClqWx93Cu4O1qUedbkiSE4gALrujSnz9z6E/o9cjCtoCINV
	gzQQD44Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1ww28z-000000009v8-0YtD;
	Mon, 17 Aug 2026 15:33:09 -0300
Message-ID: <c47031397f33123195775ea65d0834ce@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org,
 stfrench@microsoft.com
Cc: stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix use-before-check of ReparseDataLength
 in reparse_buf_ptr()
In-Reply-To: <20260817171657.212776-1-sorenson@redhat.com>
References: <20260817171657.212776-1-sorenson@redhat.com>
Date: Mon, 17 Aug 2026 15:33:08 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> reparse_buf_ptr() reads buf->ReparseDataLength before checking that
> count covers the full fixed header:
>
>     buf = (struct reparse_data_buffer *)((u8 *)io + off);
>     len = sizeof(*buf);                          /* 8 bytes */
>     rdlen = le16_to_cpu(buf->ReparseDataLength); /* offset 4, 2 bytes */
>
>     if (count < len || count < rdlen + len)      /* check comes after */
>
> struct reparse_data_buffer has ReparseDataLength at offset 4.  If a
> server returns OutputCount < 6, the read at offset 4-5 reaches past
> the end of the received data.  The off+count bounds against iov_len
> were already validated, but that does not protect against count being
> smaller than sizeof(*buf).
>
> Split the check: verify count >= sizeof(*buf) before reading
> ReparseDataLength, then verify count covers the data region.
>
> Fixes: a158bb66b137 ("smb: client: optimise reparse point querying")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
