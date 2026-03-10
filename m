Received: from mxchg04.rrz.uni-hamburg.de (mxchg04.rrz.uni-hamburg.de [134.100.38.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457A52DB780;
	Tue, 10 Mar 2026 23:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.100.38.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773183908; cv=none; b=TYLum68sc3meuc9gDUbPeeuSIjcMwTsENV9ySdexoQq6sIwmGCOOoNp2uoWO9yba5Axqeo+5op/2PONPwuB4P3bsE6L6dcsVRl/aw5XeUaxIqBzuMd9+IBdPpSJLhfdjiP9WtLvuB76idEHSKqbh+QdXETRl2PJffNWDNSLQl9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773183908; c=relaxed/simple;
	bh=y7Xqpc/wuYWtWe48tqJ7Y9F+CA4BF+ERGQuTslHT+I0=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type; b=RxfiQBmfg3yIncg7kGTBLIBNRKEiuzx9GIyPafYhG3u7xSaVgqRYhX3AtV/hNXN5Itwh3vE80uLQEQkMKNMYWbs+/OV5rM4AIuoGR7fJW5hX1YOpgh4eXQ8dW9/9gp+E+cTnCHT5pXIAjj76ZlRhcIkAh8G2tdtpUDT1vcmip8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de; spf=pass smtp.mailfrom=uni-hamburg.de; dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b=iFdqJ/3m; arc=none smtp.client-ip=134.100.38.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b="iFdqJ/3m"
Received: from mxchg04.rrz.uni-hamburg.de (mxchg04.rrz.uni-hamburg.de [134.100.38.114])
	by mxchg04.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fVq4q3KK1zLlZr;
	Tue, 10 Mar 2026 23:56:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1773183403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aKlgmgGXApqb89QvKp6ek8VSBUaqeTUHGbk9QK7a158=;
	b=iFdqJ/3mIpvtYgdVZMORPjtCJLEC0jgKZ5iyxtOwMG4blmWlfn2iMDBESx0ih+yLh8WXvB
	pZy1xvWod2Y3ZezDVxFliOl4AVCc/k/rCRkveACNQv59LiEmjHSeolSJwHaY7SrxuqftcB
	BN+f3UUITk3+zG07DCxda7KtDx2inMx1vbGvU2vnFJ2ine2JGykbL0EodgYYpiNqaHaNQA
	CyZlcqyW6TIpX9UOadEGjrQ1LNvtcApsdfx6pOcq87sajkxbMbTEm6TAz4TI8X/DgCh4in
	KZSmbMERwPg8FcR5ckXCdK9BW2K3etOGpiD8lieex73+vRYt2vMsd5jqfrCxyA==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg04.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fVq4q1dpPzLlZn;
	Tue, 10 Mar 2026 23:56:43 +0100 (CET)
Received: from plasteblaster (134.100.32.91) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 10 Mar
 2026 23:56:42 +0100
Date: Tue, 10 Mar 2026 23:56:42 +0100
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: Steve French <sfrench@samba.org>
CC: <linux-cifs@vger.kernel.org>, <regressions@lists.linux.dev>,
	<stable@vger.kernel.org>
Subject: [REGRESSION] failure to reconnect on SMB server restart with custom
 TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <20260310235642.6d9798f4@plasteblaster>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: EX-S-MR03.uni-hamburg.de (134.100.84.82) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: 45fadb
X-Rspamd-UID: 40e953

Dear Linux-CIFS maintainer(s),

I stumbled upon a regression in the Linux cifs/smb3 client when working
with a smbd using a non-standard port. I am not the first to note this, see

	https://bbs.archlinux.org/viewtopic.php?id=3D306712

which is a report from mid last year, indicating the problem sometime
after Linux 6.6.72. It is a very simple issue, where details of the
kernel builds or mount setup don't seem to matter much: Older kernels
reconnect to a SMB server that was restarted (old processes killed and
replaced), newer kernels do not and just have a defunct mount.

I reproduced this in our HPC cluster environment with such smb.conf on
the server side

[global]
security =3D user
map to guest =3D Bad Password
server role =3D standalone server
smb ports =3D 1445

[public]
path =3D /some/path
guest ok =3D yes
read only =3D yes

and such a mount command on the client:

mount -t smb3 -o port=3D1445,user=3Dguest,password=3Dfoo //server/public dir

When I kill and re-start smbd on the server, older client kernels
reconnect and continue to return listings and files from the share,
while newer kernels give this:

$ ls dir
ls: cannot access 'dir': Host is down

I also see that no smbd process is spawned for the client connection.
The client simply seems not to try to talk to the server anymore. This
apparently is only the case with the changed SMB port. With the default
445, the same setup works. I once tested that with root running smbd or
by forwarding port 445 to 1445 via socat on the server, things are back
to normal. The share continues working, server processes are spawned
and talked to by the client.

Also, it seems that this only covers cases with actual network
transfer. Mounting on the server from itself (localhost) seems to be
fine on either port.

I narrowed this down to these kernels working in the same system (which
is a HPC node booting a Debian 12 image with our custom kernel built
from vanilla kernel.org sources, barely changed):

6.6.53: good
6.6.78: good
6.6.86: good

Also, an Ubuntu client with 5.15.0-164-generic in a distinct setup,
talking to a differing server, was also fine. So I assume clients
reconnecting is baseline behaviour. I tested these kernel versions to
have the regression:

6.6.95: bad
6.6.97: bad
6.6.101: bad
6.12.47: bad
6.12.55: bad
6.18.16: bad
7.0.0-rc3: bad

The last one is torvalds/linux.git as of today, commit
1f318b96cc84d7c2ab792fcc0bfd42a7ca890681.

So it looks like something backported into 6.6 series between 6.6.86
and 6.6.95 broke the behaviour and this stayed with us up to the
current RC. This matches the report in the Arch Linux forums. I tested
by building kernels and booting real hardware =E2=80=A6 so this already
took some time and effort. I can test a specific patch/version
quite easily, but don't have a fully automatic bisecting setup.

The issue should be obvious in any environment, though. It seems to be
universal once you choose a custom port and have some real (or
emulated?) network between client and server.

Hopefully an easy fix for someone close to the code?


Alrighty then,

Thomas

PS: $ grep -e SMB -e CIFS  .config |grep -i -v -e SMBUS -e SMBIOS
CONFIG_RMI4_SMB=3Dm
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS2=3Dy
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=3Dy
CONFIG_CIFS_UPCALL=3Dy
CONFIG_CIFS_XATTR=3Dy
CONFIG_CIFS_POSIX=3Dy
CONFIG_CIFS_DEBUG=3Dy
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=3Dy
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_SMB_DIRECT is not set
CONFIG_CIFS_FSCACHE=3Dy
# CONFIG_CIFS_COMPRESSION is not set
CONFIG_SMB_SERVER=3Dm
# CONFIG_SMB_SERVER_SMBDIRECT is not set
CONFIG_SMB_SERVER_CHECK_CAP_NET_ADMIN=3Dy
# CONFIG_SMB_SERVER_KERBEROS5 is not set
CONFIG_SMBFS=3Dm

PPS: I am testing running Samba smbd as unprivileged user on a
non-standard port to find a cheap/simple least-privilege way to
re-export a custom FUSE fs to clients, read-only. Samba smbd doesn't
really like that, but can be coerced, esp. in a mount namespace where
the hardcoded paths it uses can be remapped. I could add more layers to
map the port back to 445 or do something else entirely, but maybe this
is a half-reasonable scenario why one would like to talk SMB on a
different port.

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg
