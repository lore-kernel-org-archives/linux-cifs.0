Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCAD30C630
	for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756377535; cv=none; b=oqadNVsLcK0EcI3KK285oy/WnpmJUeG+PWsBDLVqqsBKsobpiiAu1craQ6OERP2sGXojIuSaXhgfVoOLU81/Z4CyZFvXfmaLzSQttVs48feMHPtH1hiV/8zZ8PkuX5dOB9864sXiePwQ8Woh1DrVr+nw1+gzkGcuizScbL4yftM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756377535; c=relaxed/simple;
	bh=42pZZoHJh1Fygwzm5WJNdngeVSBjEFWpBvooRcvyjsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WpK6VDsxuwSCVNzp57AKDyc1N3KgOiFZOtO6ajL3DY4i3qQYSku2P/t08s8hQ/DMlbSVDcMBF46GEbWhorDb5EvXNgayMdGnzfm77Y85U0f9vOLJuRrJIWv0MnQZtsPeYliBwyZkzDhgqkRpgjhBcZbH/mKksnfy2wctykPJLSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oAbOUD4k; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oAbOUD4k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xKNP/W7O4r1Zo2EvKARJG4j2NOBhTdz16H7JuwkLQPc=; b=oAbOUD4kJipFn5hJLqKe+fHWDb
	2Ox2Lzi05KC0oFsOJK6hWnIeKSKMY99+cbJrn5RkuIaUhkacjnxHuoXG2YKuzPkqdzY6LPhRDVk1K
	ltDnLFIhfOslutbUTKAuzuVB16nvPaIXv+bBMSxUEf3aVw8feZ3a5jszfWG8aPwd3+P+W/MHbKB02
	O3HCM6KorGMsUuHbrg1accdfVDwz9XlQv2ImHqc6IbcF/1KgDw4SaMFxMYr57HIPEvZg15OABbHuX
	Mgg6JM1hRjjlgdN94ru8scWk1t5mwZMkLMV6zZtDHFbQRiJV2glsihNwsQYvthJIdom49lnpOteEA
	N2MHixoiEZfwgS573DUwjVB6qBqEjmvuIWjsNqazieMp4gkHmc8HOxh9wuEDbWBtwmXe+XoKkIQdu
	5jNd+GtEYilLUJY2lq2MbBFm6rOeGkVIj9D2z94eTcRG8ickC1PbMuezYRlpzXDKmgwDWH4RJeDSj
	hrc1RAUlTeAlxDpCHbDKW8mh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ura1r-001FCp-0T;
	Thu, 28 Aug 2025 10:38:51 +0000
Message-ID: <0e3039e8-794b-47d8-809c-3ae327146b85@samba.org>
Date: Thu, 28 Aug 2025 12:38:50 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: smbdirect patches for 6.18
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
 <1f5a4297-8086-4914-af44-1cf76393c8c7@samba.org>
 <CAFTVevUWWrPgs=Kb6E3WtSiyTmWtoD8QYiONJ1hYkS37ri=NrA@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAFTVevUWWrPgs=Kb6E3WtSiyTmWtoD8QYiONJ1hYkS37ri=NrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Meetakshi,

> I ran some xfstests after building Steve's current for-next-next, with
> all 144 smbdirect client and server patches.

Thanks!

> All tests pass save generic/258 (negative timestamps test).

Can you past a list with all tests and time they take,
so that I can add some more fast tests to testing I typically do.

Currently I have these:

cifs/001 2s ...  3s
generic/001 71s ...  51s
generic/002 3s ...  2s
generic/005 9s ...  5s
generic/006 288s ...  50s
generic/007 325s ...  104s
generic/008 5s ...  3s
generic/011 275s ...  136s

The times on the left are against ksmbd in a VM the times
on the right against Windows 2025 on bare metal.

> generic/258 0s ... [failed, exit status 1]- output mismatch (see
> /home/met/xfstests/results//smb3/generic/258.out.bad)
>      --- tests/generic/258.out   2025-05-19 08:53:10.883041010 +0000
>      +++ /home/met/xfstests/results//smb3/generic/258.out.bad
> 2025-08-28 08:45:31.148495408 +0000
>      @@ -3,3 +3,6 @@
>       Testing for negative seconds since epoch
>       Remounting to flush cache
>       Testing for negative seconds since epoch
>      +Timestamp wrapped: 1756370731
>      +Timestamp wrapped
>      +(see /home/met/xfstests/results//smb3/generic/258.full for details)
>      ...
>      (Run 'diff -u /home/met/xfstests/tests/generic/258.out
> /home/met/xfstests/results//smb3/generic/258.out.bad'  to see the
> entire diff)
> 
> This test fails against ksmbd even without RDMA. It seems like a
> server problem because the same test passes against the Azure SMB
> Server.

I can't reproduce it here it just works fine with a patched
client using siw.ko against:

- Windows 2025 with a Chelsio T520-BT card
- ksmbd (without the patches) using siw.ko
- ksmbd (with the patches) using siw.ko

On ksmbd I'm using this trivial config:

# less /etc/ksmbd/ksmbd.conf
[globals]

[test]
         path = /data/test
         read only = no

[scratch]
         path = /data/scratch
         read only = no

/data/test and /data/scratch are on the following mount:
/dev/sda1 on / type ext4 (rw,relatime,errors=remount-ro)

metze
