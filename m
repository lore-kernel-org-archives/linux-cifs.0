Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B134D90D4;
	Thu,  3 Sep 2026 15:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449061; cv=none; b=nEQLNwuwfFrdj48VjaAHvVsS7+YsJJfQ8Gsb1ouJVWshXYB4eVZBnasJ/TgUbbHJ4jepkOoRA7xV4fPe+eiUVSTsxpgJ/vFNyZ7N/8inKmMJieisx5ebrVFSOQQ8WKKjYpebyKWQTIXxPiX7ZC4vsX9weAMYef2jLbALSBWlxtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449061; c=relaxed/simple;
	bh=3/LaprFL7fPD/EUitNi5bAcVZllnn68Uw9zQakVAN+k=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Tlnsk2+AZVpf7iBjNbTDwlxvH+R69c3fD/wq/lKbmf/UrBShCXl4iKDgwUstYTM7IsqY3fiizr4op81oSySTIgtaFR2+B4Oh5aIh6+ebDRUY0kiH/CIYpxb1bbjf0JKzPUpQItQSjxrElvWppfsmwGq3W7Z8X0bDDqMkVZwk8P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Ne1Iucou; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Ne1Iucou"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=YZCj2ROELgXCqd6M7StQliH6xymvS6urbbG0vCxfe8A=; b=Ne1IucoujV9nFxoMDe8KENOChk
	YZrUyfey7zAYy5iS8mIDn5gkUjb6Y2FcpiNRK2yb5YRnneSAknCe5488okUJGXcRxbLhpS6uoPMja
	Rb74Gx4h6LYEwgRZJR+a5jPj81d8VG76RsBo0Ou5/cxBYWgZ2pkBz0tddvwcBzh1R0sFBpQtkSd0H
	yuyoBPVrU/+5JRHYaudBncGFf94i1U5qK6HT64FPogCj7/HiDYbD9zNiP1FEW1h++1aMb0N35Si9o
	txnpbnPgKD8gGGnQo6qJTJwTIBhzlxPtX2K4ZfxMHajpOan3dFt2n8eCLdTrsrySZhBUMH8abaWnt
	evuRFlWQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x29IQ-00000000cD2-33TS;
	Thu, 03 Sep 2026 12:24:10 -0300
Message-ID: <86b3d1476eff0ad8286da11cfdad3070@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Diego Oliva <diego@bynar.io>
Cc: sorenson@redhat.com, Namjae Jeon <linkinjeon@kernel.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] smb: client: fix out-of-bounds reads in
 CIFSSMBRead()
In-Reply-To: <CAExJZk3gfbM4LkvN-zJGt6sQ3AKN+huZuhEatMswx2nYHyu7Og@mail.gmail.com>
References: <20260902104207.1820332-1-diego@bynar.io>
 <e5dec57a-0186-4087-9de4-5037f0a09879@redhat.com>
 <498fd2508ad66ac9d8fd19cbd4b4a02b@manguebit.org>
 <CAExJZk3gfbM4LkvN-zJGt6sQ3AKN+huZuhEatMswx2nYHyu7Og@mail.gmail.com>
Date: Thu, 03 Sep 2026 12:24:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Diego Oliva <diego@bynar.io> writes:

> On Wed, Sep 2, 2026 at 11:32=E2=80=AFPM Paulo Alcantara <pc@manguebit.org=
> wrote:
>>
>> Diego, do you want me to fold this in:
>>
>> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
>> index f3cba16f6e17..f9aff0712794 100644
>> --- a/fs/smb/client/cifssmb.c
>> +++ b/fs/smb/client/cifssmb.c
>> @@ -1742,7 +1742,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io=
_parms *io_parms,
>>                         rc =3D smb_EIO2(smb_eio_trace_read_overlarge,
>>                                       data_length, count);
>>                         *nbytes =3D 0;
>> -               } else if ((size_t)data_offset + data_length > rsp_iov.i=
ov_len) {
>> +               } else if (data_offset < sizeof(*pSMBr) ||
>> +                          (size_t)data_offset + data_length > rsp_iov.i=
ov_len) {
>>                         /* check that the data lies within the received =
response */
>>                         cifs_dbg(FYI, "%s: bad data offset %u length %u =
for response of %zu\n",
>>                                  __func__, data_offset, data_length, rsp=
_iov.iov_len);
>
> Looks good to me, thanks Paulo!

Done, thanks.  Updated #cifs-next with it.
