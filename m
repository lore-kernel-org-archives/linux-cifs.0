From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cthon failure
Date: Mon, 25 Aug 2014 17:10:33 -0700
Message-ID: <20140826001033.GA7407@samba2>
References: <CAH2r5mtN1cHocFcVPsDC9kVq5c9DyxazmTBFQp_wUVCPNsvV7Q@mail.gmail.com>
 <20140821211338.GC17035@samba2>
 <CAH2r5ms5=vV2XD2oP2NoaLavsZCo=x4w=w7vvshzNQRNJ1RkFw@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5ms5=vV2XD2oP2NoaLavsZCo=x4w=w7vvshzNQRNJ1RkFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 25, 2014 at 07:05:53PM -0500, Steve French wrote:
> I just tried it on recent Samba (from about a week ago) with the same results
> 
> Version 4.2.0pre1-GIT-47e7440
> and also
> Version 4.1.6-Ubuntu
> 
> If "store dos attributes = yes" (on by default in Ubuntu) is in smb.conf
> 
> then the following fails
> mount -t cifs //someserver/someshare /mnt
> touch /mnt/newfile1
> chmod 0000 /mnt/newfile1
> stat /mnt/newfile1   (mode displays as expected)
> rm /mnt/newfile1  (fails with access denied)
> 
> if the identical scenario is tried with "store dos attributes = no" in
> smb.conf then it works
> mount -t cifs //someserver/someshare /mnt
> touch /mnt/newfile2
> chmod 0000 /mnt/newfile2
> stat /mnt/newfile2  (mode displays as expected)
> rm /mnt/newfile2   (delete works), and also removing the newfile1
> created above also works)
> rm /mnt/newfile1 (also works)
> 
> Details:
> posix unlink (set path info) fails with access denied/status cannot
> delete, as does subsequent smb delete.   Attempts to clear the
> readonly bit also fails with access denied
> 
> The chmod 0000 causes Samba server to set the read-only dos attribute
> in the failing case

As I said - can't reproduce here so obviously reporting
the same thing I already used to reproduce isn't going to help :-).

Can you get me YOUR ENTIRE smb.conf, debug level 10 log,
wireshark trace of the activity please.

Log a bug and attach them - easiest way to track.
