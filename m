Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7571862A
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716480535; cv=none; b=FR3ErYAxSCaz6I4WPoIvl9/VbbzdDTzCC2f6jbBWwjyWGeBKSYwOitr8jieE74CFtfARkU340aD3flejI+CCp1bfqvhBYpNfajftebBeKMpCF9psRPOyVPSB04bY+GqPxKxBXXz7N3InXdCgXTud0sAv5N5G9hIsQCuKi6k1XTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716480535; c=relaxed/simple;
	bh=oV7EGEZf3bhKXRU8xsqNL6l6Si3OXEf05CFxZldjCPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t/E0ZulJRg6P6qSTM9KRO6q5Xs6rXGV4W554YJQFjcMXyoa+JXzhKtQAksnBU07O0iRgM7IrrVsum86ZySyLvQIoi7zgMkJzpE037vv+5za3sDGY70sL93fN9ZUYP+xKojTar3urskG/6qUPIlCVvJzQfja0JxzEmkZ0A1CVRys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com; spf=pass smtp.mailfrom=enioka.com; dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b=KtYvvs08; arc=none smtp.client-ip=217.70.183.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=enioka.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enioka.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enioka.com header.i=@enioka.com header.b="KtYvvs08"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0A0FA20004;
	Thu, 23 May 2024 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=enioka.com; s=gm1;
	t=1716480525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iVgYgk4WCSpaCCjLNutIv8sGa0TGgwoX2GQdHAkqzxU=;
	b=KtYvvs08j+7K9KLI11Aj8dQw2tSPEfPQUSGx+gPU79X4oZnO0fhBbarhn+isU5zITuuBh+
	3Dn7NZedCRQZEvYmdRJMC3tXdfRoaphjVTZ+kZ4Dt0nun7sMGYQ/7bZlp28x/JUuTkObtA
	Kbg64gAYbeA2kIsQ2FCauFOG3KOl6l3eu4iHczEjV6U081qQByph5RTALqRrTY9R6Jx97+
	aY9t8dItcXUkd/1vtcQFZ4WMPS88lnKQaz6t7W85mx38xKOTIM2VJ7iSaP7NRBr6JPs5kP
	DEextD2ll22Aojbe5uQTH6dkB5rJCX/k0afwAi7j04xSw3fguFXjQNcI1tmF7A==
From: Kevin Ottens <kevin.ottens@enioka.com>
To: linux-cifs@vger.kernel.org
Cc: abartlet@samba.org
Subject: Different behavior of POSIX file locks depending on cache mode
Date: Thu, 23 May 2024 18:08:44 +0200
Message-ID: <5659539.ZASKD2KPVS@wintermute>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2094812.YKUYFuaPT4"
Content-Transfer-Encoding: 7Bit
X-GND-Sasl: kevin.ottens@enioka.com

This is a multi-part message in MIME format.

--nextPart2094812.YKUYFuaPT4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello,

I've been hunting down a bug exhibited by Libreoffice regarding POSIX file=
=20
locks in conjunction with CIFS mounts. In short: just before saving, it=20
reopens a file on which it already holds a file lock (via another file=20
descriptor in the same process) in order to read from it to create a backup=
=20
copy... but the read call fails.

I've been in discussion with Andrew Bartlett for a little while regarding t=
his=20
issue and, after exploring several venues, he advised me to send an email t=
o=20
this list in order to get more opinions about it.

The latest discovery we did was that the cache option on the mountpoint see=
ms=20
to impact the behavior of the POSIX file locks. I made a minimal test=20
application (attached to this email) which basically does the following:
 * open a file for read/write
 * set a POSIX write lock on the whole file
 * open the file a second time and try to read from it
 * open the file a third time and try to write to it

It assumes there is already some text in the file. Also, as it goes it outp=
uts=20
information about the calls.

The output I get is the following with cache=3Dstrict on the mount:
=2D--
Testing with /mnt/foo
Got new file descriptor 3
Lock set: 1
Second file descriptor 4
Read from second fd: x count: -1
Third file descriptor 5
Wrote to third fd: -1
=2D--
=20
If I'm using cache=3Dnone:
=2D--
Testing with /mnt/foo
Got new file descriptor 3
Lock set: 1
Second file descriptor 4
Read from second fd: b count: 1
Third file descriptor 5
Wrote to third fd: 1
=2D--

That's the surprising behavior which prompted the email on this list. Is it=
=20
somehow intended that the cache option would impact the semantic of the fil=
e=20
locks? At least it caught me by surprise and I wouldn't expect such a=20
difference in behavior.

Now, since the POSIX locks are process wide, I would have expected to have =
the=20
output I'm getting for the "cache=3Dnone" case to be also the one I'm getti=
ng=20
for the "cache=3Dstrict" case.

I'm looking forward to feedback on this one. I really wonder if we missed=20
something obvious or if there is some kind of bug in the cifs driver.

Regards.
=2D-=20
K=C3=A9vin Ottens
kevin.ottens@enioka.com
+33 7 57 08 95 13
--nextPart2094812.YKUYFuaPT4
Content-Disposition: attachment; filename="lock_test.cpp"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-c++src; charset="UTF-8"; name="lock_test.cpp"

#include <iostream>

#include <unistd.h>
#include <fcntl.h>

using namespace std;

int main(int argc, char **argv) {
    if (argc <= 1) {
        cout << "Please provide path to a file" << endl;
        return 1;
    }   

    const auto filepath = argv[1];
    cout << "Testing with " << filepath << endl;

    int fd = open(filepath, O_RDWR);
    cout << "Got new file descriptor " << fd << endl;


    struct flock lock;
    lock.l_type = F_WRLCK;
    lock.l_whence = SEEK_SET;
    lock.l_start = 0;
    lock.l_len = 0;
    int code = fcntl(fd, F_SETLK, &lock);
    cout << "Lock set: " << (code == 0) << endl;

    int fd2 = open(filepath, O_RDONLY);
    cout << "Second file descriptor " << fd2 << endl;

    char c = 'x';
    int count = read(fd2, &c, 1);
    cout << "Read from second fd: " << c << " count: " << count << endl;

    int fd3 = open(filepath, O_WRONLY|O_APPEND);
    cout << "Third file descriptor " << fd3 << endl;

    c = 'o';
    count = write(fd3, &c, 1);
    cout << "Wrote to third fd: " << count << endl;
}

--nextPart2094812.YKUYFuaPT4--



