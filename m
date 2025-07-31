Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046E21DE4E7
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753983492; cv=none; b=RC8MH+7YOoox2L447wuVKpWp/cN08Z/i4G3j+Kczc2k0KI05gkvcj11rvJ/T3uWe009klG75w5Uz4/YueM+9uCtoIPLm1CU1n/EAGMDtLbiPy2myhStE8+/KqnG5bUMXe2TWLKFVDNfiYRXb2nH9Pcm1BQQP6XPtheojGdJC5mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753983492; c=relaxed/simple;
	bh=N2pDCmKAsQZ67tw9FCEMpIVuF48vp2aiUQ72wbHvlK0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ghPXLJlZaPjVthNshcH0fs/ivNlVI697Ee775tKyW7NFZnxi4tYmGqNpa5z2hv8jzvTjNtRIlOGGw3moS06ebyq7XlEksITTMQXN9/WSCVbgpxtgooLwqDoQFWBfDSt5/c25d1iPJS0HyqcPA8FxCtmULvzgDCm1NlLvIKEpmHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=07ZWfnp2; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="07ZWfnp2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sJzF3M5/1AiTlZYeNMJIb3QrO9lqocO/Ovnp4DqJzAQ=; b=07ZWfnp2GmbHUiPUoj2OikBPbg
	5jXirWIEJnDFdHb3u6o0aZyFq6Fu5w1Kte72tXpRCf1WtdxMiR2EC4SbmsbXX6D7zYQj7gv/VRCov
	piQ6oGYm30XqhuWPri68ptv9SJxWwxl+n06FEZ7O2zMKby3IJTwcx99haprK4gI6IfYATu26bXGeI
	B7BLpAZCbA9ShmYJrsKx7jJXkH1/RSkG8r1QEOls1esByKDc67hoY82hZfZ/CGBn2u2GnQkuGqoy4
	dmlDN19l6cJS0Fe3jo5itrO3iXE7ssZJEs7dM0L3VZJxv9Dey+yuk5A6bmAvXgokJkstZgYRUqLTN
	VRhccYJA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhXE9-000000009c1-3GEN;
	Thu, 31 Jul 2025 14:38:01 -0300
Message-ID: <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, Matthew Richardson <m.richardson@ed.ac.uk>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>, Steve French
 <smfrench@gmail.com>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
In-Reply-To: <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
Date: Thu, 31 Jul 2025 14:37:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> ...adding linux-cifs and Steve to the loop....
>
> Looks to be a client issue: the client is checking for existence of the 
> targets, the server returns ENOENT and then that's it. There no attempt 
> to create either a symlink nor the fifo as reparse points.
>
> @Steve: any idea of what could be going wrong? Iirc this is supposed to 
> be working in the client.

With Linux v6.16 and samba master (f1a828016921):

root@fed:~# mount.cifs //192.168.124.1/test /mnt/1 -o username=testuser,password=foo-123,unix
root@fed:~# mount -t cifs
//192.168.124.1/test on /mnt/1 type cifs (rw,relatime,vers=3.1.1,cache=strict,upcall_target=app,username=testuser,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.124.1,file_mode=0755,dir_mode=0755,soft,posix,posixpaths,serverino,reparse=nfs,nativesocket,symlink=unix,rsize=4194304,wsize=4194304,bsize=1048576,retrans=1,echo_interval=60,actimeo=1,closetimeo=1)
root@fed:~# (cd /mnt/1; rm -rf *; mknod chr c 2 1; mknod blk b 3 4; mknod fifo p; ln -s f0 l0; python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('sock')"; ls -lh)
ln: failed to create symbolic link 'l0': Operation not supported
total 0
brwxrwxrwx 1 root fsgqa 3, 4 Jul 31 14:31 blk
crwxrwxrwx 1 root fsgqa 2, 1 Jul 31 14:31 chr
prwxrwxrwx 1 root fsgqa    0 Jul 31 14:31 fifo
-rwxrwxrwx 1 root fsgqa    0 Jul 31 14:31 sock

I see a regression when attempting to create symlinks and sockets.  Note
the 'nativesocket' and 'symlink=unix' options, which are definitely
wrong for SMB3.1.1 POSIX mounts.  It should have 'symlink=native' and
'nonativesocket'.
