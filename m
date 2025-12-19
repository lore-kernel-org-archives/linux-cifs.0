Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F272FE057
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 10:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766140981; cv=none; b=u5s/NE9mar4NTrGsGVy4qeSB+8otM608oNFdkkJCD0/MghD9i3ZgbOKuaYXaZBXNAu2fFZ8RuxZn76Df5LRCSt9lXoYxHKE5ogA/iGnMtdeNP3IDmfUMGHgDe3CvxWe2GueDGseoRgkQFV4ex6MxVigV5ZrQ4s9NIsxlmSBb86w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766140981; c=relaxed/simple;
	bh=cAU5++DbUQ+DVOWdI3V+oojdtXIBNdCuL9U9em2w7wQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=bwDd3H1BNFdkheAtCbMFKYzM7p+FoNBgKRbo6t9r4jPX3BTpxcs1Vs/08WLIQZohqEp94uvItVwl6LFWoXGpdzgiXcSFP7iJtZU7c256ExSmKYCJuKGM4B98cTfz4/h0AzkGa7IA4J18EBGniiw5bP3jvE8eKNqX1JJdjqhI+5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fUW8Zx8z; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fUW8Zx8z"
Date: Fri, 19 Dec 2025 18:42:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766140976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAbi4nAyOKZRpETXOXNcBSuA/plXjnyXrBFFrSVQKgY=;
	b=fUW8Zx8zXk2jl+hnWcnvpVUUEYDyMBx4CWG9qpDy3G4BAnviXDTGpwFNGMj1dqVDcaw9HU
	T6I2MF/NbkmhjLCdm1gLQforGR6tJE94frwE6lqn5M7FANZM4+PYnWXvhl7tvpfUL3f4JM
	rqNlRcE6qDPX93aTpAEaj7tmMn2yTcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>
CC: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
In-Reply-To: <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev> <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com> <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev> <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com> <805496.1766132276@warthog.procyon.org.uk> <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
Message-ID: <056E09CC-95A0-4775-82AB-3DB8756CA94F@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

OK, I will send v2 soon=2E
Thanks,
ChenXiaoSong=2E

On December 19, 2025 6:32:18 PM GMT+08:00, Namjae Jeon <linkinjeon@kernel=
=2Eorg> wrote:
>On Fri, Dec 19, 2025 at 5:18=E2=80=AFPM David Howells <dhowells@redhat=2E=
com> wrote:
>>
>> Namjae Jeon <linkinjeon@kernel=2Eorg> wrote:
>>
>> > > We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
>> > > `SMB2_MIN_SUPPORTED_PDU_SIZE`=2E
>> > >
>> > > But we "should not" add "+4" to them=2E
>> > Not adding the +4 will trigger a slab-out-of-bounds issue=2E
>> > You should check ksmbd_smb2_check_message() and
>> > ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop()=2E
>> > =2E=2E=2E
>> > >    pdu_size =3D get_rfc1002_len(hdr_buf);
>> > >    =2E=2E=2E
>> > >    if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
>> > >    =2E=2E=2E
>> > >    if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
>>
>> As previously mentioned, the problem I have with the +4 accounting for =
the
>> RFC1002 header is that the size value in pdu_size does not include the =
size of
>> the RFC1002 header, so the comparison seems to be allowing an overlong =
header=2E
>>
>> However, I think the +4 actually makes sense for SMB2/3 - assuming the =
+4
>> isn't actually for the RFC1002 size, but is rather for the StructureSiz=
e of
>> the operation header that follows immediately after the smb2_hdr=2E
>Right=2E
>>
>> If that's the case, I would guess that the SMB1 variant might want a +2=
 to
>> allow for the BCC field=2E=2E=2E  but according to the code in cifs sid=
e that I've
>> looked at, some servers may only provide half a BCC field - or maybe ev=
en
>> forget to put it in entirely=2E
>ksmbd only handles SMB1 negotiate requests in smb1 protocol, And the
>BCC (Byte Count) field of smb1 negotiate request must be greater than
>or equal to 2=2E This is why I originally treated any SMB1 request
>smaller than smb_hdr + 4 as an invalid packet=2E However, even if we add
>+2, it will be no problem because ksmbd_negotiate_smb_dialect() checks
>to verify if the BCC field is less than 2=2E
>
>ChenXiaoSong, If you agree with this, Can you make the v2 patch ?
>
>Thanks=2E
>>
>> David
>>
