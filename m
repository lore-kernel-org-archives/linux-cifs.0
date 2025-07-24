Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F0F256D
	for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 00:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753317208; cv=none; b=haaV5tbjyWgkQAYZ40YTP9vfrSD3NExeQnnRBFCAbnRuEFkI6/F6AYXCCxIImkC1LSASV5QrqBLT5b3abBzyHg4bRE0/deKADQmcvURnFs4kJZ8srCjCluvWXh/E+TWn79+y01Uam+MbNmbYjl0s52r+4OuASKxdeitvHtee0o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753317208; c=relaxed/simple;
	bh=YTXR1/okUpnILmWGv+An6JiRsH5JdTLJSPGgm9JT4Rk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XcpfLvFgApSx3VVzR3X1kIdfVHs7vliT0EiP1VgcdpQh7cshNQw5oSTJqvQERneLWaasaTKglEA/Pv/WLDOkMJrekpEywg1VT0I1Jou1hZ6R7yq9/OBW5l4nKRvAiY9SlySBvEerCU2fQAg6mzQ+awC7Hl1SwEYsDRUWtHZn6SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDEjprxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDEjprxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1936EC4CEEF
	for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 00:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753317208;
	bh=YTXR1/okUpnILmWGv+An6JiRsH5JdTLJSPGgm9JT4Rk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NDEjprxu9GNB5myQm5sBKZNYbZvrkCuK2BR5qNP6x9fOC8/cg+mw+pfZj7Oq+BUna
	 DEu7zOqQqCFzk7Rdlrj1q99mGjJsAcyLTVgVcwa76TuCjFzFEU5nYZ7OVWUPOvk7YI
	 BackBn3IKXS60LRjmbOrDC/L1dw93aP7kNA40CImN26UggB4eog5l7tjSdaU8/oTE6
	 mPWvlhZ4ziQbr9qW5IrisDLmIcmoXdwPU7ez2Sn21bKhk/hN/f7+1+DQc47falR5op
	 erU+/kuLCbeS3n2SAVITeXV0DGctEe5hEFMTvHC+jr1KvUYCjzhVit6Ec0CVS/SOnC
	 HkhbmTDNT14hQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-60c4f796446so798193a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jul 2025 17:33:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWl/MrLPIWaMb7a8u3WR35r5Ope5eDXtPQBr7KwTzzTVsfsMOsN3OON3/6L7/tafWQoFhT/h8o+jsmX@vger.kernel.org
X-Gm-Message-State: AOJu0YxZr1/MhqNdbkoO//BH2oL9HKKTAe2l2MtlNOifiMzJNGJMfDp5
	OesPqFTWBEcrwOXLS6Dj53c+JjIAXdmi9mKLWS08b5/G0fFgSgfUNv5BX/qNESOToRImWC1iT9l
	/ao7USsydYyA9Wqs6GBfoBohXXgaYwfc=
X-Google-Smtp-Source: AGHT+IHMAj0L+5TXhtQj55fdhvrNbSD/Tj3g4T3z9jJ1uo7Qpk7YiAmldt7gMOB8My5sdKqPHOKW2QK6l1fzY7aW/hE=
X-Received: by 2002:a17:907:6e93:b0:ae0:4410:47e3 with SMTP id
 a640c23a62f3a-af2f8c52657mr460622766b.51.1753317206696; Wed, 23 Jul 2025
 17:33:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <317462.1753306110@warthog.procyon.org.uk>
In-Reply-To: <317462.1753306110@warthog.procyon.org.uk>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 24 Jul 2025 09:33:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_H-VgJ+0PuyjUQs8LbqQcMA__Sgu=FFvAwkoE-EBhpFw@mail.gmail.com>
X-Gm-Features: Ac12FXweNQlC2SRxTARDXtoNa1FFH5ZgmFfefrkl-qoJm23t4sM2S7szuVLqiKU
Message-ID: <CAKYAXd_H-VgJ+0PuyjUQs8LbqQcMA__Sgu=FFvAwkoE-EBhpFw@mail.gmail.com>
Subject: Re: Probable ksmbd bug causing Create Response to show bad timestamps
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 6:28=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
>
> Hi Namjae,
Hi David,
>
> I think I've found a bug in ksmbd.  Using the attached program to create =
a
> file, stat it, do a DIO write to it and stat it again:
Okay, I will take a look:)
Thanks for your report!
>
>         ~/write /xfstest.test/foo 0 4K
>         sleep 1
>         stat /xfstest.test/foo
>         ~/write -d /xfstest.test/foo 0 4K
>         stat /xfstest.test/foo
>
> and having mounted a ksmbd share with cache=3Dstrict and actimeo=3D1, I s=
ee mtime
> and ctime getting corrupted:
>
>   File: /xfstest.test/foo
>   Size: 4096            Blocks: 8          IO Block: 1048576 regular file
> Device: 0,65    Inode: 2033391     Links: 1
> Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Context: system_u:object_r:cifs_t:s0
> Access: 2025-07-23 22:15:30.136051900 +0100
> Modify: 2025-07-23 22:15:30.136051900 +0100
> Change: 2025-07-23 22:15:30.136051900 +0100
>  Birth: 2025-07-23 22:15:30.136051900 +0100
>   File: /xfstest.test/foo
>   Size: 4096            Blocks: 8          IO Block: 1048576 regular file
> Device: 0,65    Inode: 2033391     Links: 1
> Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Context: system_u:object_r:cifs_t:s0
> Access: 2025-07-23 22:15:30.136051900 +0100
> Modify: 1970-01-01 01:00:00.000000000 +0100
> Change: 1970-01-01 01:00:00.000000000 +0100
>  Birth: 2025-07-23 22:15:30.136051900 +0100
>
> I've also attached a PCAP file.  Frames 16 and 19 show Create Response
> messages with bad Last Write and Last Change timestamps and I think this =
is
> being reflected in the stat output, possibly due to deferred close.  Doin=
g
> another stat a bit later shows the correct timestamps:
>
> Access: 2025-07-23 22:15:32.279094100 +0100
> Modify: 2025-07-23 22:15:32.279094100 +0100
> Change: 2025-07-23 22:15:32.279094100 +0100
>  Birth: 2025-07-23 22:15:30.136051900 +0100
>
> I've also added a kernel trace as requested by Steve.
>
> David
>
