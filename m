Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6736B80628
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 09:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716369916; cv=none; b=A77UVe4oQ5e+h+v+BaXH6HhjIPbKpeEXBwSUyqwT01U4johLMo15OnYthB4y9UY1rIGQ1vZzHJU5168EDwTmfYlXh5xT7fbiZqDiOA2AGDZK38yS4uCkza9/fcDYBWxiH/SfarvEuskagfJDyNDULgnk3Xk7XrN5rVTel0UQb30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716369916; c=relaxed/simple;
	bh=dRVUAFq1qGQw5i59feTDFe73/S5wUhJrakl8Brx+A0c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ti0MUNbLsev7imk6ufTPHAW/PUmU8yTxVBHH84JuC9LevP6UwAXt0m+Flqs8xpir8SdWJEdzfh5G2bu4KQbfHP14ZqYIMLuIpQ7oTCfOMyj0FA6ni7bEy2ewu80jqpUoypSwFEy2RgDR1QyQW7QDAKUCLeVC2AYt8NErBQzLp8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=RF70OgsU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RF70OgsU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=xKVeC/krV9L90AQYj8hvzOrI0sUjjpS4t6WVFU97iGE=; b=RF70OgsUgew3UOkCOVcqeaHN0E
	aJlc100JSjjCfvKnKH1NYlhz2qfiU1q2+gcpOMvFIFq1874NMnrwRBOA7UPP9usw6/di50P2GxSMi
	LZvXm1mjxu1SQxYdsSXq7nBMEkSbz2FPti0DBtKdsqmPlEWa68QEcATcZIv+n8MCBcb+JHTEgKJG1
	P3/g+SL42BqEfMzBc5CSd4s3vIOU6LNsVoH397HtBJQlY0iyQYFetz5V4mzKxHiClaH2466MJ/liW
	84wj0o18JIjn6yC0lijzUsXlafHoy670VkRaevu4nHDe0wxsmOEbpZPWMw0Mp2k7zaaO11FnAaeex
	ae80BMM2Tv9TP0hcH8b70+nu6AfNmBw7q8z4udkAPeJJdrMj7JBOp6c2fdk6XQ/esZ2bHrfaLkCg3
	h0z79MW+bAzYdRX6dzsP5KPC/VJOP+7qp0Qx4r2nXyg+IE1YJpyrK32Fr8hVTkrGtD7kyC442lFUD
	GIyU9/DXL8B/VViQqxlXVrSF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s9hip-00CZZ9-2L;
	Wed, 22 May 2024 08:53:20 +0000
Date: Wed, 22 May 2024 18:53:05 +1000
From: David Disseldorp <ddiss@samba.org>
To: David Howells via samba-technical <samba-technical@lists.samba.org>
Cc: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>,
 Jeremy Allison <jra@samba.org>, linux-cifs@vger.kernel.org, Paulo Alcantara
 <pc@manguebit.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Message-ID: <20240522185305.69e04dab@echidna>
In-Reply-To: <349671.1716335639@warthog.procyon.org.uk>
References: <349671.1716335639@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 22 May 2024 00:53:59 +0100, David Howells via samba-technical wrote:

> I've been debugging a failure in xfstests generic/286 whereby llseek() re=
turn
> -EIO and am thinking that the bug is in Samba.  The test can be distilled=
 to:
>=20
> 	mount //my/share /mnt -ooptions
> 	truncate -s 100M /mnt/a
> 	for i in $(seq 0 5 100); do xfs_io -c "w ${i}M 1M" /mnt/a; done
> 	xfstests-dev/src/seek_copy_test /mnt/a /mnt/b

Thanks for providing the reproducer and detailed analysis...

> This creates a big sparse file, makes 21 1MiB extents at 5MiB intervals a=
nd
> then tries to copy them one at a time, using SEEK_DATA/SEEK_HOLE to enume=
rate
> each extent.
>=20
> I can see the error in the protocol being returned from the server:
>=20
>    16 2.353013398  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 206 Ioctl Requ=
est FSCTL_QUERY_ALLOCATED_RANGES File: a
>    17 2.353220936  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 143 Ioctl Resp=
onse, Error: STATUS_BUFFER_TOO_SMALL
>=20
> Stracing Samba shows:
>=20
>     lseek(30, 94371840, SEEK_HOLE)          =3D 95420416
>     lseek(30, 95420416, SEEK_DATA)          =3D 99614720
>     lseek(30, 99614720, SEEK_HOLE)          =3D 100663296
>     lseek(30, 100663296, SEEK_DATA)         =3D 104857600
>     lseek(30, 104857600, SEEK_HOLE)         =3D 105906176
>     sendmsg(35, {msg_name=3DNULL, msg_namelen=3D0, msg_iov=3D[{iov_base=
=3D"\0\0\0I", iov_len=3D4}, {iov_base=3DNULL, iov_len=3D0}, {iov_base=3D"\3=
76SMB@\0\1\0#\0\0\300\v\0\n\0\1\0\0\0\0\0\0\0\265\2\0\0\0\0\0\0"..., iov_le=
n=3D64}, {iov_base=3D"\t\0\0\0\0\0\0\0", iov_len=3D8}, {iov_base=3D"\0", io=
v_len=3D1}], msg_iovlen=3D5, msg_controllen=3D0, msg_flags=3D0}, MSG_DONTWA=
IT|MSG_NOSIGNAL) =3D 77
>=20
> You can see the error code in the sendmsg() as "...#\0\0\300...".
>=20
> Turning debugging on on Samba shows:
>=20
>     [2024/05/21 23:56:58.727547,  2] ../../source3/smbd/smb2_ioctl_filesy=
s.c:707(fsctl_qar)
>       QAR output len 336 exceeds max 16
>     [2024/05/21 23:56:58.727652,  3] ../../source3/smbd/smb2_server.c:403=
1(smbd_smb2_request_error_ex)
>       smbd_smb2_request_error_ex: smbd_smb2_request_error_ex: idx[1] stat=
us[NT_STATUS_BUFFER_TOO_SMALL] || at ../../source3/smbd/smb2_ioctl.c:353
>=20
> The "exceeds max 16" indicates the "Max Ioctl Out Size" setting passed in=
 the
> Ioctl Request frame (which can be seen as 16 in the full packet trace).  =
336
> is 21 * 16.
>=20
> This stems from the smb2_llseek() function in the cifs filesystem in the =
Linux
> kernel calling:
>=20
> 	rc =3D SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> 			cfile->fid.volatile_fid,
> 			FSCTL_QUERY_ALLOCATED_RANGES,
> 			(char *)&in_data, sizeof(in_data),
> 			sizeof(struct file_allocated_range_buffer),
> 			(char **)&out_data, &out_data_len);
>=20
> where the max_out_data_len parameter is sizeof() you can see, allowing for
> just a single element to be returned.  The file_allocated_range_buffer st=
ruct
> is just:
>=20
> 	struct file_allocated_range_buffer {
> 		__le64	file_offset;
> 		__le64	length;
> 	} __packed;
>=20
> which is 16 bytes - hence the maximum output data seen by Samba.
>=20
>=20
> Now, cifs only wants the next extent.  It fills in the input data with the
> base file position and the EOF:
>=20
> 	in_data.file_offset =3D cpu_to_le64(offset);
> 	in_data.length =3D cpu_to_le64(i_size_read(inode));
>=20
> and asks the server to retrieve the first allocated extent within this ra=
nge.
>=20
> In Samba, however, fsctl_qar() does not pass in_max_output to
> fsctl_qar_seek_fill() and therefore doesn't limit the amount returned.  T=
he
> fill loop seems only to be limited by the maximum file offset and not the=
 max
> buffer size.
>=20
> The:
>=20
> 	if (out_output->length > in_max_output) {
> 		DEBUG(2, ("QAR output len %lu exceeds max %lu\n",
> 			  (unsigned long)out_output->length,
> 			  (unsigned long)in_max_output));
> 		data_blob_free(out_output);
> 		return NT_STATUS_BUFFER_TOO_SMALL;
> 	}
>=20
> check at the end of fsctl_qar() generates the complaint.
>=20
> I think that fsctl_qar() should probably just discard the excess records.
>=20
> Looking at:
>=20
> 	https://learn.microsoft.com/en-us/windows/win32/api/winioctl/ni-winioctl=
-fsctl_query_allocated_ranges=20
>=20
> it's not obvious what should be done if the available records won't fit.

MS-FSCC from https://winprotocoldoc.blob.core.windows.net/productionwindows=
archives/MS-FSCC/%5bMS-FSCC%5d.pdf
is a more protocol-specific reference here, but it's still unclear
regarding partial / truncated responses.

We do have an existing test for the STATUS_BUFFER_TOO_SMALL response in
test_ioctl_sparse_qar_malformed(), which would have been run against a
Windows server to confirm matching protocol behaviour. But it doesn't
cover partial responses.

I think the best way to proceed here would be to capture traffic for the
same workload against a Windows SMB server. This could be don't by using
your cifs.ko workload or extending test_ioctl_sparse_qar_malformed().

Cheers, David
