Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341F3D9548
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 10:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791282151; cv=none; b=J+oCfUvVZib5mLKmUbaGJd4OjW5H4n6saHsDEXeewc5FU2UwO6ZwvqbZZCecjzQLF7ClcpuxpV6MXrxpgQKkMdPOzSP8us53uRWxLj2084go6ShJvtFWB82adTH7nfhcAQ5FgdMNbgDB9ENVjVdgQnxZg/Q6HEIskLekaJBcwZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791282151; c=relaxed/simple;
	bh=6Xmou0vFgyfybft0P1ut9ZayCU1Dl8XkVi+/uKMocQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fpmgWX1ivqWNe4n1XYr/VB4wFRNJwsd06RAuLc6O9lHZMSYmtl/QtAEuBYcate1keq919po7zPxozzrjQqlbV9B5EMcV7q415e52z7ER4wR503LPsC/d7imdERuPpdgUYNn7tPXVv1k00/hSzL9HYVh/aT15dyRym+sTby7nVCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rMNBRMNB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rMNBRMNB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=bvvZcDjFAtnynp78a9f8MxPxAGxqVmjSA8EzfmP+Whw=; b=rMNBRMNBsYe07cvKqlapitYfLh
	PNt0GmhzKLyZg9iBnJBVpGmxQhCfjeXvdlDiZAp2Bun+sO4hr8vZVN9/0TFp0NkyaSXyJBMbBKvLA
	dQ2QfkftdMXRhOwoyZ7Ij3OtDfsPhKXPam000xeOnYUUOxkWP+08LYb2gsbqMmMdVEAriMuWaHuUD
	HpWEK/K1arL8vMdsSIuI9TFltSrULS+sTAKbx6wNQb2Lh6ndZXvEW1BlpxSphhZSLeiuxsJjKzA6h
	w9i1jWf9UATqfZ7Om5yd7ymGp+gZ+PyDrK2+/ZqkSuQbL2h5WSeHWR1T7Nrqe3YTijFGkW1w+P9BX
	GDS5R6tf9WXtXYPUsVSrXDXmm9WGiemrP1kAPfjcvSsGJhfwvDAqW+PRT8BRzVqjqF1erixyCukHz
	TxZDRT/i/zR6qJ5azaZ6ogIixGWq3OvGFZvRtG0RaPuwtCnWjZ6Ym5dNFTwuM8ACz59CEiDryL6oR
	ph/dLt6MinqGvurIRA24eH3r;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xE2JW-00000005rcV-1jOp;
	Tue, 06 Oct 2026 10:22:26 +0000
Message-ID: <0c378d19-545e-4fd9-9f48-b00c6962ea59@samba.org>
Date: Tue, 6 Oct 2026 12:22:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and
 teardown races
To: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Tom Talpey <tom@talpey.com>
References: <cover.1791229120.git.metze@samba.org>
 <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CANTrAmwHqivuuH9UhPL=744OQTZ=qzahqHV6k5eLEPgap3uBdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Lee Seong Hyeon,

> Thanks a lot for the fix and for crediting me.
> 
> Could you please use my real name instead of the display name in the
> Reported-by: tags (patch 2/3) and in the cover letter, i.e.:
> 
>    Reported-by: Lee Seong Hyeon <ihopenre@gmail.com>
> 
> The address stays the same. If it is easier for you, I'm also fine with
> you fixing it up when applying, or with Namjae doing it.

I'll update it in v3,

there's still one thing sashiko doesn't like:
https://sashiko.dev/#/patchset/cover.1791229120.git.metze%40samba.org

I'll check what to do this that in the next days.

Thanks!
metze
