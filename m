Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CA612CD89
	for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 19:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727206413; cv=none; b=i/Kii2wWR0rzC+0sJ0muhpbItGDUEnBz5hu62FVp7t39LfTAL2SYDQ355ly2ntInxs803/RhbAon0OA9xstXZWaCU3S+pZt0WfjbsjFXGLBza7ntzaLJovF4pCTf4t5fa/2ITx43A8A3ELYYwfAJ/8JQTpqoYFREhSXE2Df61/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727206413; c=relaxed/simple;
	bh=xYIluz4MQgZnS0PvbaO7h7TVpf/Zheu9pqJDwzbG2lc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=G3iyqilZf4uxjGf5KJX+bd+jMga89dWEwI/xkpghtHPomqA66nENy+LtOpXBcqt/T5WkXucbIj8/QUJYzw7PqCbNYMBPuKDv/Hub+vXAPLTbn6++H5uwanLgO3B0UZe2F/pCDuUNAUkVPEofUltEoZQ+PKf1aVd2EwQ9c0eKB/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MZBGDP9p; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MZBGDP9p"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727206408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yLR6bhEI1FdlD20fqnApTL+T+S9SCIn4Pwas1mbHVQo=;
	b=MZBGDP9pEt+xC4TsJzKgcT4vLyrQJYv8odCUfWhib8pYAIJFMVQBP+mcbAebUAYEslzBu8
	5+xMOYydPsgzjil3RJQ9iG3+opMgUvtkmjS2C5sOe+81vYdc3okYo6V0JLWoVCf0lRehYv
	iVWSzuUo8PNbBg6Uo5isCGJCkjlcOIk=
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] ksmbd: Annotate struct copychunk_ioctl_req with
 __counted_by_le()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <d6341fc4-1d9d-46af-b809-f30430b30455@talpey.com>
Date: Tue, 24 Sep 2024 21:33:15 +0200
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C22D945F-4C40-4C0E-8074-07747C944C99@linux.dev>
References: <20240924102243.239811-2-thorsten.blum@linux.dev>
 <d6341fc4-1d9d-46af-b809-f30430b30455@talpey.com>
To: Tom Talpey <tom@talpey.com>
X-Migadu-Flow: FLOW_OUT

Hi Tom,

> On 24. Sep 2024, at 20:05, Tom Talpey <tom@talpey.com> wrote:
> On 9/24/2024 6:22 AM, Thorsten Blum wrote:
>> Add the __counted_by_le compiler attribute to the flexible array =
member
>> Chunks to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
>> CONFIG_FORTIFY_SOURCE.
>> Read Chunks[0] after checking that ChunkCount is not 0.
>> Compile-tested only.
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>>  fs/smb/server/smb2pdu.c | 2 +-
>>  fs/smb/server/smb2pdu.h | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>> index 461c4fc682ac..0670bdf3e167 100644
>> --- a/fs/smb/server/smb2pdu.c
>> +++ b/fs/smb/server/smb2pdu.c
>> @@ -7565,7 +7565,6 @@ static int fsctl_copychunk(struct ksmbd_work =
*work,
>>   ci_rsp->TotalBytesWritten =3D
>>   cpu_to_le32(ksmbd_server_side_copy_max_total_size());
>>  - chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
>>   chunk_count =3D le32_to_cpu(ci_req->ChunkCount);
>>   if (chunk_count =3D=3D 0)
>>   goto out;
>> @@ -7579,6 +7578,7 @@ static int fsctl_copychunk(struct ksmbd_work =
*work,
>>   return -EINVAL;
>>   }
>>  + chunks =3D (struct srv_copychunk *)&ci_req->Chunks[0];
>>   for (i =3D 0; i < chunk_count; i++) {
>>   if (le32_to_cpu(chunks[i].Length) =3D=3D 0 ||
>>      le32_to_cpu(chunks[i].Length) > =
ksmbd_server_side_copy_max_chunk_size())
>> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
>> index 73aff20e22d0..f01121dbf358 100644
>> --- a/fs/smb/server/smb2pdu.h
>> +++ b/fs/smb/server/smb2pdu.h
>> @@ -194,7 +194,7 @@ struct copychunk_ioctl_req {
>>   __le64 ResumeKey[3];
>>   __le32 ChunkCount;
>>   __le32 Reserved;
>> - __u8 Chunks[]; /* array of srv_copychunk */
>> + __u8 Chunks[] __counted_by_le(ChunkCount); /* array of =
srv_copychunk */
>>  } __packed;
>> =20
>=20
> This isn't correct. The u8 is just a raw buffer, copychunk structs are
> marshaled into it, and they're 24 bytes each.

Hm, I see.

How does this for-loop work then? It iterates over ci_req->ChunkCount
and expects a srv_copychunk at each ci_req->Chunks[i]?

for (i =3D 0; i < chunk_count; i++) {
	if (le32_to_cpu(chunks[i].Length) =3D=3D 0 ||
	    le32_to_cpu(chunks[i].Length) > =
ksmbd_server_side_copy_max_chunk_size())
		break;
	total_size_written +=3D le32_to_cpu(chunks[i].Length);
}

Thanks,
Thorsten=
