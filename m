From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: async read patchset test results
Date: Fri, 14 Oct 2011 06:55:08 -0400
Message-ID: <20111014065508.2f4735d3@tlielax.poochiereds.net>
References: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
	<20111013083151.55aa1cdf@barsoom.rdu.redhat.com>
	<CAKywueQg90k2FwRB+fJbmwq230p-DP-Zxtrc0+HP_gfieHxM6g@mail.gmail.com>
	<20111013133414.77f54658@barsoom.rdu.redhat.com>
	<CAKywueTjAwgmSpYeqX-iu6FhZbCiG5HTztDhNLWYFMkq3cmoBg@mail.gmail.com>
	<CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ@mail.gmail.com>
	<20111013140039.3200de5d@barsoom.rdu.redhat.com>
	<CAKywueSfX7sn46uPTz2L3WWWZgpNmEfECJDv70Lr-jjFvTXi+g@mail.gmail.com>
	<CAKywueQ20Jh139J4E0XfJ+ZTPsO8gDpXPHL2jZ3YBh72ajKAWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ20Jh139J4E0XfJ+ZTPsO8gDpXPHL2jZ3YBh72ajKAWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Oct 2011 14:02:54 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Today, I caught it once again and didn't noticed any reconnects (no cERRORs).
> 
> It is surely not depends on Jeff's async read patchset, because I used
> my cifs-3.2-current branch.
> 
> My branch consists of Steve's master + lockpatchset + smb2 patches.
> From another hand, previously I caught it with Jeff's branch (without
> lockpatchset and smb2 patches). So, that's why the problem is in
> existing cifs code now.
> 
> FYI: I checked two files: "buggy" and original, and noticed that the
> difference between them is located in one place - positions from
> 2014442 to 2014569 - 126 differences with two equal holes.
> 
> So, 2014569 - 2014442 + 1 = 128 wrong bytes. Ideas?
> 

Good to know, thanks. I also tried reproducing this for a while last
night and was unable to...

I used this script:

-------------------------[snip]------------------------------
#!/bin/bash

origfile=$1
destfile=$2

origsum=`md5sum $origfile | cut -d' ' -f1`
i=0

while true; do
	echo $i
	rm -f $destfile $origfile.tmp

	dd if=$origfile of=$destfile bs=100000
	if [ $? -ne 0 ]; then
		echo "dd1 failed"
		exit 1
	fi

	dd if=$destfile of=$origfile.tmp bs=100000
	if [ $? -ne 0 ]; then
		echo "dd2 failed"
		exit 1
	fi

	destsum=`md5sum $destfile | cut -d' ' -f1`
	if [ "$origsum" != "$destsum" ]; then
		echo "md5sums don't match! orig=$origsum dest=$destsum"
		stat $origfile
		stat $destfile
		exit 1
	fi

	i=`expr $i + 1`
done

-------------------------[snip]------------------------------

I ran the above with the first arg set to a ~615M .iso file on local
disk and the second to a file on a cifs mount.

I ran it against my win2k8 host for several hours and it never failed.
I then tried running it against my Windows 7 home host (running on
bare-metal) and it would run for a little while and would eventually
fail due to the server returning "out of memory" errors. Some of those
would occur on the NEGOTIATE call, so I chalk that up to a Win7 bug.

I never saw this mismatch, but I think we can try to infer something
from the nature of the failures that Pavel saw...

Since the file was apparently being written properly, the write phase
seems like it worked correctly. The data all went into the cache, and
then got flushed properly to the server.

So, it seems likely that the problem is in the read phase of the test.
There are several possibilities:

1) we started out doing a cache read, but the cache was invalidated
partway through. "Something happened" and one of the reads got mangled.

2) the server sent us a corrupt read for some reason

3) lower level networking problem caused a corrupt read

4) generic memory corruption in the pagecache of some sort

...plus many others...

The fact that only 127 bytes was corrupt is very odd. It would be
easier to understand if an entire page were bad, or an entire rsize
chunk.

If you are able to reproduce this again, it might be helpful to see if
that's consistent. Try to nail down the nature of the corruption -- see
how much is different and where the different parts are. That may
help shed light on the problem...

In any case, this will probably take some digging -- we should probably
open a bug at bugzilla.samba.org and start working on this there.
Pavel, would you mind doing that when you have time?

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
