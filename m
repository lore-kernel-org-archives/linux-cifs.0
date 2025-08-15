Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2899475
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755278653; cv=none; b=euCekkFB4eM04t5NH1TOYlWS0NYwNVtDWcDHRaSS5DzpzpyuL4PXvrzePo3K3Ox3BCaKDcyrVU0d18Ak7BmxFjmtGVVYyxEMA9cXjOLWejR+es2anQD5BKXakcvaho5OR08vOKThYzs+0SEUe3fQr3uOy2ZodPPsWwC1F+RMokY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755278653; c=relaxed/simple;
	bh=Y08at7TpbJd/U4JXJREaZFY5/tp+so9Ix3bsm5izo7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pbWhr+E7HkWkiBkkPSgYKOtc0Lh6wsx+Ipqi4REg4bkvDpVNhMvHEXmTTpZHu4Wba4o6Sl0vsJORHQK7qVD2q0Qw9P7S3LUeg906g3y/9zxuAalW/b77NQUjid17Kr6otvh2YzxFl6uU26Q02wR+LXRkSepsDUw3YQ4XCDlMDnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3YjT9csW; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3YjT9csW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ta66Vn8mVOjenvpAsIEUWNbKg+7xIcsPsoup4eTnyvs=; b=3YjT9csW5QBrWjQm510VR4onN9
	rSWS6JfDOyikb1NgoH6fCaKy2mYf2tOBwikRpEp4ueDW+IlaSzoBa2BcTvS17gMsHv7u8s8qj8tao
	QproOv2EfHmqSRyXAp/E2Lir6A+YrIardmLMHF9a1TxgpCxhfxtnxs+TU0KS7PIcM9GlUoyjXIzWw
	ma8nY0hXXYTPFqdNpKdQXjT2hqO3NsNkFSdoljuPZ5fYhssHs9Spe7MK4NNOec5ychxL85ZycqGUE
	X9i1RQHlvqVTqBdGakROpI7D6F9i7ZAc84JT1PbHwIhMP3EHglCk3rvd2XXVfTXfJriUSZ9UTcVPO
	JTkuIFeihX/MxJ9bfEnSBqXCY571vi9gnWXEZ07fuEJCUqdcKXXD7Ep7HhtoUNYxlNmImJo98uo2v
	2n2DQWkw8P6lxSUcH3JDzIl94lyJ5UhLom3aCVz61tExDhoC0iZ956jtErXZPeR+ZIMob6i0KyJOI
	GsKTTyckVRXWrqsHrtK6ltCX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1umy9w-0032Ev-1m;
	Fri, 15 Aug 2025 17:24:08 +0000
Message-ID: <0bcae9fe-1dff-4530-875b-fe917af5b649@samba.org>
Date: Fri, 15 Aug 2025 19:24:07 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of
 ksmbd_rdma_destroy()
To: Steve French <smfrench@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>
References: <20250812164546.29238-1-metze@samba.org>
 <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
 <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org>
 <CAH2r5mvtxMnwdgz15RrSZj_Kut9WVLGK+WRGUGQD1Rs_MJEWbA@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5mvtxMnwdgz15RrSZj_Kut9WVLGK+WRGUGQD1Rs_MJEWbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 15.08.25 um 18:52 schrieb Steve French:
>> Steve can you remove 'return' so that the line is this:
>> static inline void ksmbd_rdma_stop_listening(void) {
> 
> Done, and have updated ksmbd-for-next
> 
> Updated patch also attached, let me know if any problems.

Maybe also remove the 'return;' from the inline ksmbd_rdma_destroy function?

> Also let me know if you have rebased versions of the other smbdirect
> patches for 6.18-rc so I can get them in linux-next

I guess I'll base on Monday on 6.17-rc2 and will post what I have then.

Thanks!
metze

