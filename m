Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CC0233D7C
	for <linux-cifs@vger.kernel.org>; Wed, 21 May 2025 11:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747825667; cv=none; b=f9OOpiXwx+9p0U09HiFvrPJiyTCr3MEBWgdgluavBJ2ZQ44saAAFfZzL75RSt/zPIZfKCYGTUHn3dlqeOVJfIW+RJ20vkEF6POI5hJNmqzxJ+n2PMfuMaZ/unzmjCjOuCFh3c4c1BEGhG3AsCoJRxSuudlspM0PbiHWkhmi2Sxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747825667; c=relaxed/simple;
	bh=qCE+A1fEaIQU0CHly0oL56Nsc2rvQr3ekMTqFj22fSI=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=mMOqD6J9NpqAshtEWY5NvRrONENmOeHxTBJiIs4jq2tsS1RKajeplypDOSrD2isF5VEKL1R3AgHMRKWVj/mHoQNIuvAQgnQ6LmSqYydQmOKV0jtZZ9J0HK3KOAkEaaGjH8/nVViBhalVVlEWHnurJsyK3ipwnrqzT9A4BKKCaDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EbIcgLal; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EbIcgLal"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=qCE+A1fEaIQU0CHly0oL56Nsc2rvQr3ekMTqFj22fSI=; t=1747825665; x=1749035265; 
	b=EbIcgLalk2piezRKzxIQOz4SAGev8O2lu21E544c5TKpoZMphZnqUcSvjWutWmRPXLHyHkn+aIH
	Q8ki+OPoIJYlFi2Wo7EhbmBCx+8apWGJbqgc4YPDn+1sgMAclE+ufizkBhqQJLKNU6gD/l6SukH6v
	f+4aU78XrPO8F/g12q9ivSqUYJ4xLA+07FUrqx9w34qUL1rTacTYkjfkAFCemFuQPD8PZTiSLog00
	0NyWNtSdLxARfG2iM9RwpSnPobgkdRHburpMonfjIx0FIk8JkqsVyMnPbLQOwMGY9M9aWKpah5VFl
	e23h9kMRLw3uJHnbjxjZptQDBnqhbYjFPOHw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uHhIV-0000000EM31-15CK
	for linux-cifs@vger.kernel.org;
	Wed, 21 May 2025 13:07:43 +0200
Message-ID: <50815dea489f26cf2c8d34162d8be5f0a7d3465e.camel@sipsolutions.net>
Subject: 6.14.6: copy from cifs mount never finishes
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-cifs@vger.kernel.org
Date: Wed, 21 May 2025 13:07:42 +0200
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

Hi,

So I'm on 6.14.6 on Fedora, trying to copy a few relatively small files.
I went to lunch and when I came back it still wasn't finished, and the
first file was just growing and growing in size ...

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
