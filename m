Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479AB143889
	for <linux-cifs@vger.kernel.org>; Tue, 25 Jun 2024 06:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719296716; cv=none; b=TW129g6N91+PG3IqsiAKSvfdn+9kEbVJom+DQGswK23w9GDZsfxjoOuBmNvWugI6e54Ltmyf4/u99k9qpFlnMBelXBgJyMdGXkBEofOj+4OKbJmIDi+d49dSJEdwFBXz5TMSbvqeLSY7ysd+ECS5TojhrO12RO4iOwtzHJ1qhrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719296716; c=relaxed/simple;
	bh=1NkLJ7nFzGDTEfo8rM0tV39q4reAbgJ48b96O9Qv/W8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IHUgLcRy21drHBb2v1+rcEQHxYLwM5SEy45Cc9/8Gx/19CB6/foLpvaYs2kbeJV/GUcWQDTVvc8YJmJSdg1nYHQXKockiauWyU9KdTys4bk1pRX6uWr0hxFdjWvUgbLwxmbu3Bod8BmpvYHJKxSuviuiNPFnR4pQdB+De/0JQqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wFHqm2Ud; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wFHqm2Ud"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Date:Cc:To:From:Message-ID;
	bh=uoJ/ZB+8xfwEwllUFN/HGEu7lXkB2ozSuTMqouf5or0=; b=wFHqm2UdPMdhMITD1Y3g/kIwT1
	2gAxNKof2T1CdxhCaL/ZYaG9bSSqubuBatck/1oJYdI+P6Y8LDWhZuay8tu194ZL+t2Yr+/0n6eMU
	xrPW7Rqy+VixKGInyV/K9aD9EtSN2nGGKXaiqaI5dWhnUdBfGNvciGUWdqHHeb75sIgoDdTLdhfbI
	hVv3HdXlUzOHGMKnRcVd9wXVIP2A/mSSUDMycNkeJ2vAziYa1nkMm2ENsN9ag7i/YcGEIuZguq3Ep
	cboBEpF7MWFYWco6FSXVXleY9Jtjts9PryRQWQWvNnLtQYPlnLN6xTmNRSg48HW3U9ipchzk/6KKy
	jdmQUG9jPAJRg6Rciz1M+Ve91GMFEv39osKMWhdlopIVRf4jKRzS7OsqOcJsr9cAk+l0tIC5Z5F5+
	gDJfw0BfkOhun5/RNcm94g/8Q2LhijMzhnw8BIErPG9biTU9tatZFjoHBoaoHBUOHfl4Kt2UAwX/G
	qT5S9snS2eDfVis99NNU6XQU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sLzE2-000n3Z-37;
	Tue, 25 Jun 2024 06:00:19 +0000
Message-ID: <0ed85d03cfc698093e649394739c1379443ab0c8.camel@samba.org>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
From: Andrew Bartlett <abartlet@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org, 
	Pavel Shilovsky <piastryyy@gmail.com>, Jeff Layton <jlayton@kernel.org>
Date: Tue, 25 Jun 2024 18:00:11 +1200
In-Reply-To: <CAH2r5mvQi6ydn73zZb=psyE1MujC2ovtipT-tWzX2B4q4uc+1g@mail.gmail.com>
References: <5659539.ZASKD2KPVS@wintermute>
	 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
	 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
	 <CAH2r5mvQi6ydn73zZb=psyE1MujC2ovtipT-tWzX2B4q4uc+1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks so much Steve.  

Kevin can give more info, but no, my understanding is that this was
"always" problematic, the reason it came up now is LibreOffice changed
how it handled file saves, rather than a kernel change.

Even if the fix is to be in the direction that 'breaks' LibreOffice,
that is OK, I have given Kevin a suggestion on using locks ranges
towards the end of the file as a way to regain the desired 'advisory'
semantics, but we wanted to be working on solid ground with consistent,
reliable semantics that don't depend on cache modes. 

Thanks,

Andrew Bartlett

On Sun, 2024-06-23 at 23:54 -0500, Steve French wrote:
> This was interesting to dig through (and netfs caching changes made
> it
> a little harder to trace the original code) but it looks fixable. See
> cifs_find_fid_lock_conflict() in fs/smb/client/file.c.   It does not
> look new though - so let me know if you noticed that the behavior in
> earlier kernels was different for the default case (smb3.1.1 mounts
> with caching enabled).
> 
> The problem seems to be that locking is enforced only in some write
> paths, but these places where we do write vs. byte range locking
> checks (although at first glance may seem logical) obviously do not
> follow POSIX semantics which would allow a write to a locked range
> (even if POSIX behavior is counter-intuitive and different from
> Windows semantics).  Two obvious things to fix that I see so far:
> 
> 1) It was harder than expected to trace since looks like we don't
> have
> good dynamic (or static for that matter) tracepoints for the write
> and
> write error paths (although netfs fortunately has a few) - so
> obviously should add a few tracepoints to make it easier to narrow
> this kind of thing down in the future
> 2) We need to make changes to how we check lock conflicts.  See
> cifs_writev() and its call to cifs_find_lock_conflict(). It looks
> like
> this is the original commit that may have caused the problem:
> commit 85160e03a79e0d7f9082e61f6a784abc6f402701
> Author: Pavel Shilovsky <
> piastry@etersoft.ru
> >
> Date:   Sat Oct 22 15:33:29 2011 +0400
> 
>     CIFS: Implement caching mechanism for mandatory brlocks
> 
>     If we have an oplock and negotiate mandatory locking style we
> handle
>     all brlock requests on the client.
> 
> 
> On Sun, Jun 9, 2024 at 11:41 PM Andrew Bartlett <
> abartlet@samba.org
> > wrote:
> > (resend due spam rules on list)
> > 
> > Kia Ora Steve,
> > 
> > I'm working with Kevin on this, and I set up a clean environment
> > with
> > the latest software to make sure this is all still an issue on
> > current
> > software:
> > 
> > I was hoping to include the old SMB1 unix extensions in this test
> > also,
> > but these seem unsupported in current kernels.  When did they go
> > away?
> > 
> > Anyway, here is the data.  It certainly looks like an issue with
> > the
> > SMB3 client, as only the client changes with the cache=none
> > 
> > Server is Samba 4.20.1 from Debian Sid.  Kernel is
> > Linux debian-sid-cifs-client 6.7.9-amd64 #1 SMP PREEMPT_DYNAMIC
> > Debian
> > 6.7.9-2 (2024-03-13) x86_64 GNU/Linux
> > 
> > With SMB1 but not unix extensions (seems unsupported):
> > 
> > root@debian-sid-cifs-client:~# mount.cifs
> > //192.168.122.234/testuser
> > mnt -o user=testuser,pass=pass,vers=1.0
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: x count: 0
> > Third file descriptor 5
> > Wrote to third fd: 1
> > 
> > root@debian-sid-cifs-client:~# mount.cifs
> > //192.168.122.234/testuser
> > mnt -o user=testuser,pass=penguin12#,vers=3.1.1,posix
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: x count: -1
> > Third file descriptor 5
> > Wrote to third fd: -1
> > root@debian-sid-cifs-client:~# mount.cifs
> > //192.168.122.234/testuser
> > mnt -o user=testuser,pass=penguin12#,vers=3.1.1,unix
> > 
> > root@debian-sid-cifs-client:~# mount.cifs
> > //192.168.122.234/testuser
> > mnt -o user=testuser,pass=penguin12#,vers=3.1.1,unix,nobrl
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: o count: 1
> > Third file descriptor 5
> > Wrote to third fd: 1
> > 
> > And with cache=none
> > 
> > root@debian-sid-cifs-client:~# mount.cifs
> > //192.168.122.234/testuser
> > mnt -o user=testuser,pass=penguin12#,vers=3.1.1,posix,cache=none
> > root@debian-sid-cifs-client:~# cd mnt/
> > root@debian-sid-cifs-client:~/mnt# ../lock_test foo
> > Testing with foo
> > Got new file descriptor 3
> > Lock set: 1
> > Second file descriptor 4
> > Read from second fd: o count: 1
> > Third file descriptor 5
> > Wrote to third fd: 1
> > 
> > On Thu, 2024-05-23 at 11:12 -0500, Steve French wrote:
> > > What is the behavior with "nobrl" mount option? and what is the
> > > behavior when running with the POSIX extensions enabled (e.g. to
> > > current Samba or ksmbd adding "posix" to the mount options)
> > > 
> > > On Thu, May 23, 2024 at 11:08 AM Kevin Ottens <
> > > kevin.ottens@enioka.com
> > > 
> > > > wrote:
> > > > Hello,
> > > > 
> > > > I've been hunting down a bug exhibited by Libreoffice regarding
> > > > POSIX file
> > > > locks in conjunction with CIFS mounts. In short: just before
> > > > saving, it
> > > > reopens a file on which it already holds a file lock (via
> > > > another
> > > > file
> > > > descriptor in the same process) in order to read from it to
> > > > create
> > > > a backup
> > > > copy... but the read call fails.
> > > > 
> > > > I've been in discussion with Andrew Bartlett for a little while
> > > > regarding this
> > > > issue and, after exploring several venues, he advised me to
> > > > send an
> > > > email to
> > > > this list in order to get more opinions about it.
> > > > 
> > > > The latest discovery we did was that the cache option on the
> > > > mountpoint seems
> > > > to impact the behavior of the POSIX file locks. I made a
> > > > minimal
> > > > test
> > > > application (attached to this email) which basically does the
> > > > following:
> > > >  * open a file for read/write
> > > >  * set a POSIX write lock on the whole file
> > > >  * open the file a second time and try to read from it
> > > >  * open the file a third time and try to write to it
> > > > 
> > > > It assumes there is already some text in the file. Also, as it
> > > > goes
> > > > it outputs
> > > > information about the calls.
> > > > 
> > > > The output I get is the following with cache=strict on the
> > > > mount:
> > > > ---
> > > > Testing with /mnt/foo
> > > > Got new file descriptor 3
> > > > Lock set: 1
> > > > Second file descriptor 4
> > > > Read from second fd: x count: -1
> > > > Third file descriptor 5
> > > > Wrote to third fd: -1
> > > > ---
> > > > 
> > > > If I'm using cache=none:
> > > > ---
> > > > Testing with /mnt/foo
> > > > Got new file descriptor 3
> > > > Lock set: 1
> > > > Second file descriptor 4
> > > > Read from second fd: b count: 1
> > > > Third file descriptor 5
> > > > Wrote to third fd: 1
> > > > ---
> > > > 
> > > > That's the surprising behavior which prompted the email on this
> > > > list. Is it
> > > > somehow intended that the cache option would impact the
> > > > semantic of
> > > > the file
> > > > locks? At least it caught me by surprise and I wouldn't expect
> > > > such
> > > > a
> > > > difference in behavior.
> > > > 
> > > > Now, since the POSIX locks are process wide, I would have
> > > > expected
> > > > to have the
> > > > output I'm getting for the "cache=none" case to be also the one
> > > > I'm
> > > > getting
> > > > for the "cache=strict" case.
> > > > 
> > > > I'm looking forward to feedback on this one. I really wonder if
> > > > we
> > > > missed
> > > > something obvious or if there is some kind of bug in the cifs
> > > > driver.
> > > > 
> > > > Regards.
> > > > --
> > > > Kévin Ottens
> > > > kevin.ottens@enioka.com
> > > > 
> > > > 
> > > > +33 7 57 08 95 13
> > > 
> > > 
> > 
> > --
> > 
> > Andrew Bartlett (he/him)       
> > https://samba.org/~abartlet/
> > 
> > Samba Team Member (since 2001) 
> > https://samba.org
> > 
> > Samba Team Lead                
> > https://catalyst.net.nz/services/samba
> > 
> > Catalyst.Net Ltd
> > 
> > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > company
> > 
> > Samba Development and Support: 
> > https://catalyst.net.nz/services/samba
> > 
> > 
> > Catalyst IT - Expert Open Source Solutions
> > 
> > --
> > Andrew Bartlett (he/him)       
> > https://samba.org/~abartlet/
> > 
> > Samba Team Member (since 2001) 
> > https://samba.org
> > 
> > Samba Team Lead                
> > https://catalyst.net.nz/services/samba
> > 
> > Catalyst.Net Ltd
> > 
> > Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
> > company
> > 
> > Samba Development and Support: 
> > https://catalyst.net.nz/services/samba
> > 
> > 
> > Catalyst IT - Expert Open Source Solutions
> 
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

