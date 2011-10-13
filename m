From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: async read patchset test results
Date: Thu, 13 Oct 2011 14:00:39 -0400
Message-ID: <20111013140039.3200de5d@barsoom.rdu.redhat.com>
References: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
	<20111013083151.55aa1cdf@barsoom.rdu.redhat.com>
	<CAKywueQg90k2FwRB+fJbmwq230p-DP-Zxtrc0+HP_gfieHxM6g@mail.gmail.com>
	<20111013133414.77f54658@barsoom.rdu.redhat.com>
	<CAKywueTjAwgmSpYeqX-iu6FhZbCiG5HTztDhNLWYFMkq3cmoBg@mail.gmail.com>
	<CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Oct 2011 12:48:54 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Any sign of reconnects in the failure case?  (/proc/fs/cifs/Stats for
> example)
> 
> Can you add (or flip a debug message from cFYI to cERROR) a debug message
> for any write errors
> in SMB write ...?
> 

Also, what mount options are you using?
 
> On Thu, Oct 13, 2011 at 12:36 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>wrote:
> 
> > 2011/10/13 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > > On Thu, 13 Oct 2011 16:46:51 +0400
> > > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >> 2011/10/13 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > >> > On Thu, 13 Oct 2011 11:28:29 +0400
> > >> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >> >
> > >> >> I tested your current cifs-3.2 branch and faced with strange results
> > >> >> (assuming Windows 7 share is mounted to /mnt/share):
> > >> >>
> > >> >
> > >> > I've not seen this, but I'll try to reproduce it in a little while.
> > >> >
> > >> >> piastry@adventure:~$ dd if=test1.iso of=/mnt/share/test.iso
> > bs=100000
> > >> >>
> > >> >
> > >> > Ok, so test1.iso is in your home directory and you're dd'ing it
> > >> > to /mnt/share/test.iso (which is a cifs mount)
> > >> >
> > >> >> piastry@adventure:~$ dd of=test.iso if=/mnt/share/test.iso bs=100000
> > >> >>
> > >> >
> > >> > Then you copy test.iso back from the share to your homedir
> > >> >
> > >> >> piastry@adventure:~$ md5sum test.iso
> > >> >> 5eee1675f46ac594dd7800c37e3ba944  test.iso
> > >> >>
> > >> >
> > >> > Checksum of test.iso in your homedir and end up with the above...
> > >> >
> > >> >> piastry@adventure:~$ md5sum /mnt/share/test.iso
> > >> >> 5eee1675f46ac594dd7800c37e3ba944  /mnt/HOME-share/test.iso
> > >> >>
> > >> >
> > >> > The checksum matches the (apparent) one on the share
> > >> >
> > >> >> piastry@adventure:~$ md5sum test1.iso
> > >> >> 10d672583cab035e2b55048fbfbbf7ca  test1.iso
> > >> >>
> > >> >
> > >> > But does not match the original.
> > >> >
> > >> >> Then, I umounted and mounted it again with 3.1-rc9 cifs module -
> > >> >> everything was fine. Then, I load previous "buggy" one and everything
> > >> >> was fine too.
> > >> >>
> > >> >> So, md5sums are not equal. Any ideas?
> > >> >>
> > >> >
> > >> > Not something I've seen in my testing. Some questions:
> > >> >
> > >> > 1) where is your home directory? is it on a local disk?
> > >>
> > >> It's on ext3 local hard drive.
> > >>
> > >> >
> > >> > 2) when you say "everything was fine" what checksum did you get?
> > >>
> > >> all checksums matched the original.
> > >>
> > >> >
> > >> > 3) if this test is repeatable, is there any discrepancy in the size of
> > >> > the file? IOW, when you do the md5sum, it would be good to also do a
> > >> > "stat" against the file the i_size is coming up correctly after each
> > >> > step.
> > >>
> > >> The size was the same - 415 MB. One time it happened I calculated the
> > >> number of different characters in these files - it was 127 (I don't
> > >> know how it can help, but anyway).
> > >>
> > >
> > > I tried this too, but haven't been able to reproduce it. Grabbed a
> > > random .iso file which is a bit bigger than yours -- 615M, and tried
> > > several of these tests and the checksum always came out the same...
> > >
> > > Do any of the dd commands return an error?
> > >
> >
> > No. It's hard to catch - I faced with it only twice while testing it
> > (for about 30 runs).
> >
> > --
> > Best regards,
> > Pavel Shilovsky.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> Thanks,
> 
> Steve


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
