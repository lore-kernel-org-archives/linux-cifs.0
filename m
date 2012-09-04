From: Trevor Cordes <gmane-CGgvEiIIHbIFyWsGDH9TEg@public.gmane.org>
Subject: Re: mount.cifs failed with Mac OS X 10.7 (LION, Preview 4)
Date: Tue, 4 Sep 2012 06:43:06 +0000 (UTC)
Message-ID: <loom.20120904T083623-886@post.gmane.org>
References: <loom.20110613T211710-599@post.gmane.org> <BANLkTi=CKD9F2Msdxf587QQN+Z5e8_r7BQ@mail.gmail.com> <loom.20110613T222739-674@post.gmane.org> <BANLkTinPTPYgeUJom4jjCistSX+ndrBR9A@mail.gmail.com> <loom.20110614T001442-338@post.gmane.org> <BANLkTim_zT-y9aczu3kC1MdQe55mv=W4Ww@mail.gmail.com> <BANLkTimdeNdRYpf3WwTG7p19V2QRq07DyQ@mail.gmail.com> <BANLkTimwbU_TQNw6MRwOzMLgPdRircL4-g@mail.gmail.com> <BANLkTikwsTH4B=WKtCxJrdVHqz1xTicBzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Kong Li <likong@...> writes:
> mounting with "nounix,noserverino,sec=ntlmssp" fixed the empty output from "ls
> see enclosed trace from wireshark (running on Mac).

Yes, that fixes the mount problems.  However, now there's a big problem because
of nounix: you can't read any files on the Mac that are symlinks.

On Mac:
# ls -l
lrwxr-xr-x  ...  iChat Icons -> /Library/Application Support/Apple/iChat Icons/

(It points to a directory actually.)

On Linux with that Mac share mounted:

# ls -l
-rw-r--r--  1 root root      0 Jun 13  2010 iChat Icons

# cat iChat\ Icons
cat: /mnt/netbak/iChat Icons: Object is remote

Which is causing an app of mine to blow up when it tries to figure out what to
do with these files.

I understand that nounix will break symlinks.  So how do we get a Mac share
mounted and still get symlinks to work?  Or is it hopeless because Apple screwed
us over?

Thanks
