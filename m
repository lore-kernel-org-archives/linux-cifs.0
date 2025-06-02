Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7212C3250
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 22:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748901787; cv=none; b=OR+J6f9TUso3lrP5GoYALTYnm6p3AOCYOcJAJJZ85IDECMRafjoEejvpdbKpdjG8rH+PpEKxO5dk9vZFP1KrMmCF4SWf8OE4+5hws7MiUw6OH1AOkDhiIXclZGZNqi+sqlFEmFjx7NdYPXFa1mT71pTNFAN/mp3/dWAV381JDws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748901787; c=relaxed/simple;
	bh=yMBEs4Y9zy0PoZnL/M+j4XFPvI6wlPPb3Iu5XbNZbbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKdbCmrUA3jzqdI0WKTxxfOM1klULznqjxYJamZrus1E3b2+9u/to3HutCJT/XO0Sac4lF5vr6EyqgGwWN3YJpp3mWeupceJkLcISJ0XAFqsFEmbn0LTrKyBb1q21nt9Nto1I2UMKjD84FGUR813aVR2Z3/LS/ChW1PE/C3Jrhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0L6PPdZN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0L6PPdZN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=LAb7MImkVB18Eikyu1yoO0C8MExd+ptBqbHzTsah6zQ=; b=0L6PPdZNTrzn2i30wC8+hR2aDa
	joxXUXwEa0vWik8knnI1BBCpkZdiHmJisXFowrvSVIZLF5rF5XoxfQv/OKgTeaEZ6UtRxI9ribbrR
	bVQGavQvhEgunlVVPnJeDridtIcmjGykyb8fIxwpXCIIfs3oIPvAOmUvESBkAN2ClTixRxNjqhGdV
	9sAUVFjqyXwJttrU58QF5FL7xqqVwWNsxfVpzCSvIWDONve/YAXDBMjboK2Y163+UUikkbmtvG0ta
	+u39+jm68OFPLRS6WEJLkSx5ZUCYsyLCoRMk7qZwfqZA9Df4kmAz/nr2U4gnv9IGHvpFlPPnqaQia
	Ev6IiU0Cwp3Jp/ANAxqJF3Y5K52LqJg8aqMLlpBY38AlAc8u/gSfCauS0cpfUtpau6NN2d/cWbEY7
	M3Y5dWyvoMmFz8jwwIFOfyVt11snkDBnpv91OFOtl03LswPJJprGibpvD1eGhpLX/ycuw+NknnUgr
	G3k8UrSMn7g5X7oatlSxe9oe;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uMDFB-008Ztr-0V;
	Mon, 02 Jun 2025 22:02:57 +0000
Message-ID: <5d0f7f91-8726-4707-abd4-c1898c8ba65c@samba.org>
Date: Tue, 3 Jun 2025 00:02:56 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
References: <cover.1748446473.git.metze@samba.org>
 <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
 <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
 <096f20e9-3e59-4e80-8eeb-8a51f214c6f1@samba.org>
 <CAKYAXd86mLGAaAEUFcp1Vv+6p2O3MSJcwoor8MmjEypUo+Ofrg@mail.gmail.com>
 <CAH2r5mvQbL_R9wrFRHF9_3XwM3e-=2vK=i1uaSCk37-FZmJq9g@mail.gmail.com>
 <CAKYAXd9T81En40i3OigiTAmJabMr8yuCX9E1LT_JfaTmyefTag@mail.gmail.com>
 <CAH2r5mso54sXPcoJWDSU4E--XMH44wFY-cdww6_6yx5CxrFtdg@mail.gmail.com>
 <CAKYAXd_BVHPA8Jj6mtc_nsbby1HizZFEmCft20B_wcTM3pDUVg@mail.gmail.com>
 <CAH2r5mvygcy0-WwZNu6NvjXGrMtB5ZFLK7_w0rc6rVpaVDeBxA@mail.gmail.com>
 <CAKYAXd-4-WRw9bL-shqELhMO70fyznmeh0HByA=pyOcccu3sgg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd-4-WRw9bL-shqELhMO70fyznmeh0HByA=pyOcccu3sgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.06.25 um 04:19 schrieb Namjae Jeon:
> On Mon, Jun 2, 2025 at 10:57 AM Steve French <smfrench@gmail.com> wrote:
>>
>>> Can you explain why he has split it into smbdirect_socket.h?
>>
>> The three header names seem plausible, but would be useful to have
>> Metze's clarification/explanation:
>> - the "protocol" related header info for smbdirect goes in
>> smb/common/smbdirect/smbdirect_pdu.h   (we use similar name smb2pdu.h
>> for the smb2/smb3 protocol related wire definitions)
>> - smbdirect.h for internal smbdirect structure definitions
>> - smbdirect_socket.h for things related to exporting it as a socket
>> (since one of the goals is to make smbdirect useable by Samba
>> userspace tools)
> There is no need to do things in advance that are not yet concrete and
> may change later.

The current idea is to merge transport_tcp and transport_rdma into
transport_sock, see
https://git.samba.org/?p=metze/linux/wip.git;a=blob;f=fs/smb/server/transport_sock.c;hb=66714b6c0fc1eacbeb5b85d07524caa722fc19cf

Which uses this interface:
https://git.samba.org/?p=metze/linux/wip.git;a=blob;f=fs/smb/common/smbdirect/smbdirect.h;hb=66714b6c0fc1eacbeb5b85d07524caa722fc19cf

But note that is just the direction were it goes, that current code has a lot of resolved merge conflicts,
which may not work at all currently.

Instead of putting my current code I try to take the existing client and server
code and merge it, so that we don't have a flag day commit that switches to
completely new code. Instead I try to do tiny steps in that direction
and may end with an interface that is similar but might be a bit different in
some parts.

> He can just put these changes in his own queue and work on them.
> I am pointing out why he is trying to put unfinished things in the public queue.

Because I want to base the next steps on something that is already accepted.

I really don't want to work on it for weeks and then some review will void
that work completely and I can start again.

> If You want to apply it, Please do it only on cifs.ko. When it is
> properly implemented, I want to apply it to ksmbd.

I can keep the ksmbd patches rebased on top and send them again
each time to get more feedback.

Would that work for you?

The key for me is discuss patches first and have them reviewed early
so that the following work rely on. Any the tiny steps should
make it possible to do easy review and make it possible to test each
tiny step.

metze

