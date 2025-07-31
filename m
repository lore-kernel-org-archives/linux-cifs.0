Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F60DB644
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753984865; cv=none; b=Eshf18yBq1IoY8lvpJ/xcwIYpJC3edij37dqZi2wDHc/gwiI0UTkhxq9UqKuj358eVTcqmlkF21VXYe9GV5qTbSXx0xHsVs3e75gftasL8JaTyzlQ8EVWTaGL9n6hT0m+DCjlmAJHlhhPm6SXro7VhtM7fuofKH1qey9g9Rgw8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753984865; c=relaxed/simple;
	bh=tPhmeXmFL0SlbF35UNK/q/co5707fc0yqF4g+GsVPyM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Vw54j+FCvfExfSlz55kxdLCPUqGVJIgTmyfhKNrDhVA8KngerEy2qaHPo3MfJw+rZYt1+T0EOkcyeAm2uAf/dXBSv5gIMvBvZuPygxmUo5snLYDy28xzx12602GrJCzyklhFJAwIYU9+Yi8O8SEqJrugxn1Jktrl3ludzAiRq0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=alLHwkI4; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="alLHwkI4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m+5ga3J9SDpgw9V7QMSOYX0Ge7C6YGU/IEKbTaTvmeo=; b=alLHwkI464tR1evcUdN1s1ecZ0
	nIyXwRxJ0ucsuOSUZ8RcnY6tuoEnPiFJCfVHR+AqTcaNE5sNJK58Huu0rtmIHw6Ot607F/yKYjgR8
	vZcgGT5CxQ6ODBZizSLYmOY46uW7FdjrssxtVOeNF8X9pL423VH9U8qDnlVzss9/H8TZXeBal+D8Z
	A724rVbJep6vRGEFv+/RQqzUYKG18jpy4Pt5qyClAXKey5ovnrmAX1C5uXThkNt4U5zr7sKU36bAR
	WTE0hFlo7h2UbZaY7uztTezlkJGXvleiW4mCMIeL4X0J3KZF/Fk2E/Gl3UZlWVazs3cdBfoCWFfiA
	GyZ9BZzg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhXaL-000000009gx-188b;
	Thu, 31 Jul 2025 15:00:57 -0300
Message-ID: <11e6d17f181c57ee7113eb18f3f37419@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, Matthew Richardson <m.richardson@ed.ac.uk>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>, Steve French
 <smfrench@gmail.com>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
In-Reply-To: <notmuch-sha1-71ace0e0808cb1155c98f212b8406ee293b20f11>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
Date: Thu, 31 Jul 2025 15:00:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> Ralph Boehme <slow@samba.org> writes:
>
>> ...adding linux-cifs and Steve to the loop....
>>
>> Looks to be a client issue: the client is checking for existence of the 
>> targets, the server returns ENOENT and then that's it. There no attempt 
>> to create either a symlink nor the fifo as reparse points.
>>
>> @Steve: any idea of what could be going wrong? Iirc this is supposed to 
>> be working in the client.
>
> With Linux v6.16 and samba master (f1a828016921):
>
> root@fed:~# mount.cifs //192.168.124.1/test /mnt/1 -o username=testuser,password=foo-123,unix
> root@fed:~# mount -t cifs
> //192.168.124.1/test on /mnt/1 type cifs (rw,relatime,vers=3.1.1,cache=strict,upcall_target=app,username=testuser,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.124.1,file_mode=0755,dir_mode=0755,soft,posix,posixpaths,serverino,reparse=nfs,nativesocket,symlink=unix,rsize=4194304,wsize=4194304,bsize=1048576,retrans=1,echo_interval=60,actimeo=1,closetimeo=1)
> root@fed:~# (cd /mnt/1; rm -rf *; mknod chr c 2 1; mknod blk b 3 4; mknod fifo p; ln -s f0 l0; python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('sock')"; ls -lh)
> ln: failed to create symbolic link 'l0': Operation not supported
> total 0
> brwxrwxrwx 1 root fsgqa 3, 4 Jul 31 14:31 blk
> crwxrwxrwx 1 root fsgqa 2, 1 Jul 31 14:31 chr
> prwxrwxrwx 1 root fsgqa    0 Jul 31 14:31 fifo
> -rwxrwxrwx 1 root fsgqa    0 Jul 31 14:31 sock
>
> I see a regression when attempting to create symlinks and sockets.  Note
> the 'nativesocket' and 'symlink=unix' options, which are definitely
> wrong for SMB3.1.1 POSIX mounts.  It should have 'symlink=native' and
> 'nonativesocket'.

Looks like a regression caused by

        6c06be908ca1 ("cifs: Check if server supports reparse points before using them")

By mounting the share again with 'unix,symlink=native,nonativesocket'
and getting rid of this check in cifs_symlink()

	if (le32_to_cpu(pTcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS)

I was able to create symlink and socket:

root@fed:~# (cd /mnt/1; rm -rf *; mknod chr c 2 1; mknod blk b 3 4; mknod fifo p; ln -s f0 l0; python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('sock')"; ls -lh)
total 0
brwxrwxrwx 1 root fsgqa 3, 4 Jul 31 14:51 blk
crwxrwxrwx 1 root fsgqa 2, 1 Jul 31 14:51 chr
prwxrwxrwx 1 root fsgqa    0 Jul 31 14:51 fifo
lrwxrwxrwx 1 root fsgqa    2 Jul 31 14:51 l0 -> f0
srwxrwxrwx 1 root fsgqa    0 Jul 31 14:51 sock
