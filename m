Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5A51D7E57;
	Sun,  8 Jun 2025 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749424243; cv=none; b=oeMxwGbqu9xjPBkcRbIJhGXmi07Z2/to/CGGKhaDvgL8U/qQZJ+mQ+tifUhIFG/5XB7MRwVE1laR/hFjfhoDPblFV91mA8li9JtBqDvQlK6MPm213EsLrxxVaOkD6hM2WViddSu5JwTEmCy7ftt08NkKZ+1TsrlW1gNyh6Iz8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749424243; c=relaxed/simple;
	bh=fSvI8EAUGmbdTio+UKw3YEPG/ZDUdKmwz1ZZrB37JGI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Y2J5Dnaw19E37LzLN6Q06DwZhWfmRqIiYF/hR8xi73EJU5npe8SoZrfGZl62WHVQP9b2yBji+oFVPeiM92l2vFCgiOhfBQqI1MpmbfKv1kPEdjGtYw/1NMluN9OHm/ADYHjegKGiCMF4O+mwRuS7+5sarK4MsJPPXPr2TO6853o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=EsKPY+OR; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="EsKPY+OR"
Message-ID: <17c70afea9476e5a2ebb0ed37ea780ca@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1749424240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSvI8EAUGmbdTio+UKw3YEPG/ZDUdKmwz1ZZrB37JGI=;
	b=EsKPY+OR5KsZ3uWsPJWWsVp3FTLbyT4dD67aAZDJvbLR+qc4bKOS17phcJF+9vXBJr+1fC
	inB39wxO1u6zz/qVExwND4vGqHzn0A04l2DN7to08oapwQZVJtqsxHTI1aMpFAxJUIEL6A
	1wuMXsAe/BtZRxtZojyCtJ4q58FNLvDVKdXDY7CWsB1ugz3qEPpij/6pdAXte4mFYHyXI4
	HZIJlQn9oTjvhif45YpctZKZCfkda/wnHY6srgYF0h4xTuj1RRPvYM5sJGmybOMfYl9+d8
	Guz7vC+yYDhmpj95MFO1q7zV50D6VTQ9tZZSyr5H02pQehQj3Tvb7FGtpyKV9A==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] cifs: Fix validation of SMB2_OP_QUERY_WSL_EA
 response size
In-Reply-To: <20250608221536.fdwxexewsntxs3em@pali>
References: <20250608170119.6813-1-pali@kernel.org>
 <20250608170119.6813-4-pali@kernel.org>
 <1bde0a162a5905828806e0993ba9e524@manguebit.com>
 <20250608221536.fdwxexewsntxs3em@pali>
Date: Sun, 08 Jun 2025 20:10:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> On Sunday 08 June 2025 18:49:43 Paulo Alcantara wrote:
>> Pali Roh=C3=A1r <pali@kernel.org> writes:
>>=20
>> If we're querying all those EAs and the file has only $LXMOD, wouldn't
>> the server return empty EAs except for $LXMOD?
>
> We are using FILE_FULL_EA_INFORMATION for querying EAs, which means that
> always all stored EAs are returned. It is not 4 calls (one by one), but
> rather one call to return everything at once.

Yes.

> Windows server in this case returns just one EA in its response: $LXMOD E=
A.
> And SMB2_WSL_MIN_QUERY_EA_RESP_SIZE specifies that at least 3 EAs must
> be returned, otherwise check_wsl_eas() throws error and do not try to
> parse response.

Can you share a trace of the server returning only a single EA in the
response when we query $LXUID, $LXGID, $LXMOD and $LXDEV?

What I mean is that we query all those EAs when we find reparse points
on non-POSIX mounts, and if the file doesn't have them, the server still
returns the EAs but with a zero smb2_file_full_ea_info::ea_value_len.
check_wsl_eas() skips the EA when is @vlen zero.
