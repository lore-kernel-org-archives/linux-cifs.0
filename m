Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EFA6FB6
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 04:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717994509; cv=none; b=UR5IMh3urg/KqHOa2l9LAcwf5cBQKJHsqROkyobscg8b+Gdv2niBV+89QELYSZZ6tZa1nImSQNQzCPddNJOmGyuj7ew9QDiDmzAKFjq546zYlGxVUO6K05CgG3gP+XAlsNsS3PYhjcq5YgConLeM+wgI/rRE+6c/wdgl4piztec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717994509; c=relaxed/simple;
	bh=9MlA/KfViLEXp2dpCQLJ11TYHb21I28737V7oeFc3kk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLdtTLeoKLD4LTDX39dDYw28b1OhPW93EFX7ttDfDyxFV6V2fKFreWU3JPVoGSh4n8gxn8a/BesQzZB0Xbjfwjc3574hNJCftAhtSna/IKv5Q0YH1lqz5L3KrNGGx01olyZYtyAQfjaixRFfvBnxUS1RfpjDZgeTdhhBk3Jd+LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CJKUYjAO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CJKUYjAO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Date:Cc:To:From:Message-ID;
	bh=5qwmPX+xWFIScKlykf6/s6/tkILxX18uNv2jn44W9ow=; b=CJKUYjAO4K8YepQxosqtESKYa/
	dt4A4O7kpr6CcMMsdJyYCBTGpjIf/CjnRE9gB3SQdYx474pHn9bdEUVj34Ex3GD2h6h5fzKIBm3qu
	DicpMHSj/ppypeW3q6/i75dfkYuVV0fZFcPlpPEfjfik1PTuwhJxa/nPqv7vGR0+Ecigg1CCUa6/B
	95sGoD/eCpeJB7aG6kYY1/d1Q9K8OSY8HLZKqm31gLk8AEY1k4OJQ2PUUBsu8zb1fFgGdchcQrEQ1
	APu0UQ3j80lOTpYZ/pJzlS1w1Zph3ycutfjcCRLrQomh+eAbMZxh/SwjyE2vK5OR6N6mnmdoRGc71
	E0ZhrHDTYfq9gTyrboM0M1IsS1rWa0L6sV6grGbeYHIGjZwpKOUIWB2aunmFV7MZuEGYxcvTWZbXY
	M8qns6qbUMIMNOZnQK/NyNN5GWRRFlAA8qFGKxXY/53/6v717TX8uKLklMWs/iPQY5eNuSlFSKi5l
	rH2u4kNqnFNt+9s3LPT8ZNvD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sGWql-00FrYN-1M;
	Mon, 10 Jun 2024 04:41:44 +0000
Message-ID: <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
From: Andrew Bartlett <abartlet@samba.org>
To: Steve French <smfrench@gmail.com>, Kevin Ottens <kevin.ottens@enioka.com>
Cc: linux-cifs@vger.kernel.org
Date: Mon, 10 Jun 2024 16:41:40 +1200
In-Reply-To: <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
References: <5659539.ZASKD2KPVS@wintermute>
	 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-7Rc/LTFi9hr2+fgRlKRW"
User-Agent: Evolution 3.36.5-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-7Rc/LTFi9hr2+fgRlKRW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

(resend due spam rules on list)

Kia Ora Steve,

I'm working with Kevin on this, and I set up a clean environment with
the latest software to make sure this is all still an issue on current
software:

I was hoping to include the old SMB1 unix extensions in this test also,
but these seem unsupported in current kernels.  When did they go away?

Anyway, here is the data.  It certainly looks like an issue with the
SMB3 client, as only the client changes with the cache=none

Server is Samba 4.20.1 from Debian Sid.  Kernel is 
Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC Debian
6.7.9-2 (2024-03-13) x86_64 GNU/Linux

With SMB1 but not unix extensions (seems unsupported):

root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
mnt -o user=testuser,pass=pass,vers=1.0
root@debian-sid-cifs-client:~# cd mnt/
root@debian-sid-cifs-client:~/mnt# ../lock_test foo 
Testing with foo
Got new file descriptor 3
Lock set: 1
Second file descriptor 4
Read from second fd: x count: 0
Third file descriptor 5
Wrote to third fd: 1

root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
mnt -o user=testuser,pass=penguin12#,vers=3.1.1,posix
root@debian-sid-cifs-client:~# cd mnt/
root@debian-sid-cifs-client:~/mnt# ../lock_test foo 
Testing with foo
Got new file descriptor 3
Lock set: 1
Second file descriptor 4
Read from second fd: x count: -1
Third file descriptor 5
Wrote to third fd: -1
root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
mnt -o user=testuser,pass=penguin12#,vers=3.1.1,unix

root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
mnt -o user=testuser,pass=penguin12#,vers=3.1.1,unix,nobrl
root@debian-sid-cifs-client:~# cd mnt/
root@debian-sid-cifs-client:~/mnt# ../lock_test foo 
Testing with foo
Got new file descriptor 3
Lock set: 1
Second file descriptor 4
Read from second fd: o count: 1
Third file descriptor 5
Wrote to third fd: 1

And with cache=none

root@debian-sid-cifs-client:~# mount.cifs //192.168.122.234/testuser
mnt -o user=testuser,pass=penguin12#,vers=3.1.1,posix,cache=none
root@debian-sid-cifs-client:~# cd mnt/
root@debian-sid-cifs-client:~/mnt# ../lock_test foo 
Testing with foo
Got new file descriptor 3
Lock set: 1
Second file descriptor 4
Read from second fd: o count: 1
Third file descriptor 5
Wrote to third fd: 1

On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> What is the behavior with "nobrl" mount option? and what is the
> behavior when running with the POSIX extensions enabled (e.g. to
> current Samba or ksmbd adding "posix" to the mount options)
> 
> On Thu, May 23, 2024 at 11:08 AM Kevin Ottens <
> kevin.ottens@enioka.com
> > wrote:
> > Hello,
> > 
> > I've been hunting down a bug exhibited by Libreoffice regarding
> > POSIX file
> > locks in conjunction with CIFS mounts. In short: just before
> > saving, it
> > reopens a file on which it already holds a file lock (via another
> > file
> > descriptor in the same process) in order to read from it to create
> > a backup
> > copy... but the read call fails.
> > 
> > I've been in discussion with Andrew Bartlett for a little while
> > regarding this
> > issue and, after exploring several venues, he advised me to send an
> > email to
> > this list in order to get more opinions about it.
> > 
> > The latest discovery we did was that the cache option on the
> > mountpoint seems
> > to impact the behavior of the POSIX file locks. I made a minimal
> > test
> > application (attached to this email) which basically does the
> > following:
> >  * open a file for read/write
> >  * set a POSIX write lock on the whole file
> >  * open the file a second time and try to read from it
> >  * open the file a third time and try to write to it
> > 
> > It assumes there is already some text in the file. Also, as it goes
> > it outputs
> > information about the calls.
> > 
> > The output I get is the following with cache=strict on the mount:
> > ---
> > Testing with /mnt/foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: x count: -1
> > Third file descriptor 5
> > Wrote to third fd: -1
> > ---
> > 
> > If I'm using cache=none:
> > ---
> > Testing with /mnt/foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: b count: 1
> > Third file descriptor 5
> > Wrote to third fd: 1
> > ---
> > 
> > That's the surprising behavior which prompted the email on this
> > list. Is it
> > somehow intended that the cache option would impact the semantic of
> > the file
> > locks? At least it caught me by surprise and I wouldn't expect such
> > a
> > difference in behavior.
> > 
> > Now, since the POSIX locks are process wide, I would have expected
> > to have the
> > output I'm getting for the "cache=none" case to be also the one I'm
> > getting
> > for the "cache=strict" case.
> > 
> > I'm looking forward to feedback on this one. I really wonder if we
> > missed
> > something obvious or if there is some kind of bug in the cifs
> > driver.
> > 
> > Regards.
> > --
> > Kévin Ottens
> > kevin.ottens@enioka.com
> > 
> > +33 7 57 08 95 13
> 
> 

-- 

Andrew Bartlett (he/him)       https://samba.org/~abartlet/
Samba Team Member (since 2001) https://samba.org
Samba Team Lead                https://catalyst.net.nz/services/samba
Catalyst.Net Ltd

Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
company

Samba Development and Support: https://catalyst.net.nz/services/samba

Catalyst IT - Expert Open Source Solutions

-- 
Andrew Bartlett (he/him)       https://samba.org/~abartlet/
Samba Team Member (since 2001) https://samba.org
Samba Team Lead                https://catalyst.net.nz/services/samba
Catalyst.Net Ltd

Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
company

Samba Development and Support: https://catalyst.net.nz/services/samba

Catalyst IT - Expert Open Source Solutions

--=-7Rc/LTFi9hr2+fgRlKRW
Content-Disposition: attachment; filename="lock_test.cpp"
Content-Type: text/x-c++src; name="lock_test.cpp"; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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

--=-7Rc/LTFi9hr2+fgRlKRW--

