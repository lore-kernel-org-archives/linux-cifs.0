Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E1225A2AF;
	Wed, 21 May 2025 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747827723; cv=none; b=hKfSzuLJM+4k/ML5fSQADm4HJIbqHoWZm2QXzhaIY6B3Qn9CfGOCHR8376u4EWgtzBFxZah+LJHVCu1xrX3pw2dKqVG1C6NbCwcw5ibyFvyE1QEoRm0jirk02gqOWZTyypqqhgQbwEEqJtPzi8DZ3m2xE0EG5thhlYUTENGfQo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747827723; c=relaxed/simple;
	bh=JWuKETJLvsVhKSXqsbMsjbWpsA6aRJuNrreKEkOgMSI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MH5K1fnieAQfb9xGhnIMpc/ZK2J9YFoYM0o0pv8Hbob7PNJKpmTxz+42PoI6SagIPTV4TIYtdPkSJ7U3LDyybvrLkyzKF6COx6xQxOgXZTBn4Gm9biHvoo81zD7AUlowObNcXcKf33j7GxBtYOmspLD11jXz9Ow+L4L3s8D18hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=D4bl3OgL; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="D4bl3OgL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JWuKETJLvsVhKSXqsbMsjbWpsA6aRJuNrreKEkOgMSI=;
	t=1747827721; x=1749037321; b=D4bl3OgLKZYZpCZyr1eJNb2sZmc2b2aItkOJUBH9uazP5VG
	cCa86H+muIX/NNyAuvld3KUl9TCeI2nh7nwDcYMIOer0jIcY2t7qLCDF6IWWDNYNCi0KVOIjlJXv3
	25svG8chrp2+Uu27Z5ZcrcGBVAXf5bOWvJSUtt41TMC8oWMArpayr1cbPjtiVlER4vrl968o70Iz5
	tj9ivqKUPPBKm1zvFZO994Ru/H6rW5Z4W5TQzUmBkg8e+hWGe9XKwIkmauH6vw8cQ3tKeN8lwZNTs
	3TxxFtyMXnFVqz9tlyBS9WYGo8J7+pR51lc7crCnVreCCQQmAYaET0zcY+aXq7ew==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uHhpe-0000000EPcj-3Epa;
	Wed, 21 May 2025 13:41:58 +0200
Message-ID: <e5d03b84a3631ace93bb36c5cd6ba5202c11e14f.camel@sipsolutions.net>
Subject: Re: 6.14.6: copy from cifs mount never finishes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-cifs@vger.kernel.org
Cc: netfs@lists.linux.dev, David Howells <dhowells@redhat.com>
Date: Wed, 21 May 2025 13:41:57 +0200
In-Reply-To: <50815dea489f26cf2c8d34162d8be5f0a7d3465e.camel@sipsolutions.net>
References: 
	<50815dea489f26cf2c8d34162d8be5f0a7d3465e.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

+netfs, and adding a bit more information



Hi,

So I'm on 6.14.6 on Fedora, trying to copy a few relatively small files.
I went to lunch and when I came back it still wasn't finished, and the
first file was just growing and growing in size ...

The filesystem was mounted with just

# mount.cifs -ouser=3D<user>,dom=3D<dom> '\\server\share\some\deep\path' /m=
nt

The server is some Windows server, I think, our IT runs it. Probably not
Azure since it's an internal IP address.

I also have a pcap now, but I'm not going to post it to the list.


Reproducing it, I see:

$ ls -l /mnt/dmesg_log.txt
-rwxr-xr-x. 1 root root 271261 May 13 13:00 /mnt/dmesg_log.txt
$ strace cp /mnt/dmesg_log.txt /tmp/
execve("/usr/bin/cp", ["cp", "/mnt/dmesg_log.txt", "/tmp/"], 0x7ffcae506680=
 /* 85 vars */) =3D 0
...
openat(AT_FDCWD, "/tmp/", O_RDONLY|O_PATH|O_DIRECTORY) =3D 3
newfstatat(AT_FDCWD, "/mnt/dmesg_log.txt", {st_mode=3DS_IFREG|0755, st_size=
=3D271261, ...}, 0) =3D 0
newfstatat(3, "dmesg_log.txt", 0x7ffdcacac290, 0) =3D -1 ENOENT (No such fi=
le or directory)
openat(AT_FDCWD, "/mnt/dmesg_log.txt", O_RDONLY) =3D 4
fstat(4, {st_mode=3DS_IFREG|0755, st_size=3D271261, ...}) =3D 0
openat(3, "dmesg_log.txt", O_WRONLY|O_CREAT|O_EXCL, 0755) =3D 5
ioctl(5, BTRFS_IOC_CLONE or FICLONE, 4) =3D -1 EXDEV (Invalid cross-device =
link)
fstat(5, {st_mode=3DS_IFREG|0755, st_size=3D0, ...}) =3D 0
fadvise64(4, 0, 0, POSIX_FADV_SEQUENTIAL) =3D 0
uname({sysname=3D"Linux", nodename=3D"jberg1-mobl2.ger.corp.intel.com", ...=
}) =3D 0
copy_file_range(4, NULL, 5, NULL, 9223372035781033984, 0) =3D -1 EXDEV (Inv=
alid cross-device link)
mmap(NULL, 1056768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)=
 =3D 0x7f1d2a6fe000
read(4, "[ 3410.434280] iwlwifi 0000:3d:0"..., 1048576) =3D 983040

now that's already wrong, the file is only 271261 bytes! That should
have returned 271261, not 983040.

Next that data is written out, nothing special, except when I look at
the data, after offset 271261 it's filled up with zeroes.

write(5, "[ 3410.434280] iwlwifi 0000:3d:0"..., 983040) =3D 983040


It gets worse from here though, because now even the next read doesn't
return 0 for EOF:

read(4, "[ 3410.434280] iwlwifi 0000:3d:0"..., 1048576) =3D 983040
write(5, "[ 3410.434280] iwlwifi 0000:3d:0"..., 983040) =3D 983040


And that just repeats forever.


johannes

