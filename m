From: <Scott_Purcell-DYMqY+WieiM@public.gmane.org>
Subject: RE: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu
 12.04)
Date: Mon, 21 May 2012 09:59:44 -0500
Message-ID: <B284DF0EE72EBA488F6C7ED035128BF5105B607C12@AUSX7MCPS302.AMER.DELL.COM>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+HONu1ABEyjbgeLQjEBCzMjc01FTewJoHsT1bWn7tkTg@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777B@AUSX7MCPS302.AMER.DELL.COM>
	<201205180302.45016.linux@kukkukk.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B5B1C37@AUSX7MCPS302.AMER.DELL.COM>
	<20120519083749.513816b0@tlielax.poochiereds.net>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777F@AUSX7MCPS302.AMER.DELL.COM>,
	<CAH2r5msirj=AYseNMp7YFuCCYzv42ruLfDa-Ac0+DGg5yDt3WQ@mail.gmail.com>
 <B284DF0EE72EBA488F6C7ED035128BF5105B4F7780@AUSX7MCPS302.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <Scott_Purcell-DYMqY+WieiM@public.gmane.org>, <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B284DF0EE72EBA488F6C7ED035128BF5105B4F7780-aIqoxSDCDnzHZ6aSvHnYXgVY21JRvFwKV6yJEvX+wlw@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Early responses are not encouraging.  It sounds like this was not an accidently happening, but they *intend* to obscure the root level of the share.

Might it work to try to downgrade my Samba installation to a version prior to the introduction of this bug?  If so, do you know which version would be the latest to still work?


-----Original Message-----
From: samba-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org [mailto:samba-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org] On Behalf Of Purcell, Scott
Sent: Saturday, May 19, 2012 6:21 PM
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu 12.04)

I'll inquire.  But we're a very windows-centric shop -- I may be given the old "Working as designed... if it won't work on Linux you'll have to use Windows" routine...

Scott Purcell
Content Development: Linux, Virtualization, and Cloud Solutions
Dell | GSD Learning & Development
________________________________________
From: Steve French [smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Saturday, May 19, 2012 10:25 AM
To: Purcell, Scott
Cc: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org; linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org; samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu 12.04)

On Sat, May 19, 2012 at 9:52 AM,  <Scott_Purcell-8PEkshWhKlo@public.gmane.org> wrote:
> Is there any workaround?

Fixing the permissions on the parent directory so it can be traversed
is not possible?
> ________________________________________
> From: Jeff Layton [jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org] On Behalf Of Jeff Layton [jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org]
> Sent: Saturday, May 19, 2012 7:37 AM
> To: Purcell, Scott
> Cc: linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org; samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu 12.04)
>
> On Fri, 18 May 2012 16:32:29 -0500
> <Scott_Purcell-DYMqY+WieiM@public.gmane.org> wrote:
>
>> Yes, I think that has been the normal behavior since our data was moved to this device.  I assumed it was due to filesystem permissions -- that I don't have read access to the root level of the share, but do have r/w access to the /training/ directory below it.
>>
>> Using smbclient, get "NT_STATUS_ACCESS_DENIED" when I try:
>>
>>       ls
>>       ls training
>>       ls /training
>>       ls /training/
>>
>> but if I cd to training, I can list its contents.
>>
>> BTW,
>>
>> I've tried appending the path in my mount command as well and mount.cifs still doesn't handle it:
>>
>>
>
> Known problem since the superblock sharing patches went in. cifs.ko
> needs to establish a dentry and inode for the root of the share and
> then walks down to the "prefixpath" for the mount. Unfortunately if you
> don't have access to any point along that path, the mount will fail.
>
> There have been a couple of proposals to fix it, but they've had their
> own problems. What probably needs to happen is to do something like
> what NFS does in its superblock sharing model. Allow several trees of
> dentries within a superblock and only connect them later if we happen
> to stumble across the right entry. See commit 54ceac45159 for an
> explanation of the model NFS uses for this.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve
-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
