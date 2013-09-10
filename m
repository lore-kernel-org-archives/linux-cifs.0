From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: determine if junction for cifs mount of windows on linux?
Date: Tue, 10 Sep 2013 11:59:51 -0500
Message-ID: <CAH2r5mv7WVopDzs4eWwvXReB12YEeZkFFCy=stTBjsgRSgV8hA@mail.gmail.com>
References: <20130910151535.GA16425@septictank.raw-sewage.fake>
	<CACyXjPzfGYVUpYFap1JOFRhUOG87SMaj=K2sPNWYVMAOO=ksGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Matt Garman <matthew.garman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPzfGYVUpYFap1JOFRhUOG87SMaj=K2sPNWYVMAOO=ksGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 10, 2013 at 11:40 AM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Sep 10, 2013 at 8:15 AM, Matt Garman <matthew.garman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On Linux, I'm doing a CIFS mount of an entire Windows 7 hard drive
>> (aka C$).  My intent is to take regular whole-disk snapshot backups
>> of the drive using rsync.
>>
>> For any "junction" on the Windows drive, I get permission denied on
>> the Linux CIFS mount side.  But using "ls", these junctions just
>> look like regular directories.  Is there any way to identify them as
>> junctions, so that I can exclude them from my rsync backup?  Or even
>> better, is there some way to have them not show up at all on the
>> CIFS mount?
>>
>> A good example of this is "C:\Documents and Settings".  This is a
>> junction that maps to "C:\Users" on Windows 7.  I get permission
>> denied if I try to ls Documends and Settings, but I can ls Users
>> without any issue.
>
> So, here's the deal. Changes are likely need to the cifsfs ...
>
> Windows implements junction points, sym links, DFS referrals, etc, as
> reparse points.
>
> There are three FIND FIRST/FIND NEXT/FIND info levels that can return
> info about them, and when they do, if you are dealing with a reparse
> point it returns a bit set in the attributes saying this is a reparse
> point and returns the reparse tag in the EA Length field. (I am told
> that this last bit is not documented, but I have not verified that
> claim myself.)
>
> Thus the CIFS FS can figure out it is dealing with a reparse point and
> from the tag what type, and can then open the reparse point if it is
> of the right type (there are flags that allow you to follow reparse
> points at the server (I believe) or retrieve them or something (over
> and above the GET DFS REFERRAL stuff, which does not apply here.)
>
> At the very least, the cifsfs could be configured to not show objects
> that are reparse points or something.

In cifs.ko now we do special case reparse points on readdir so that we force the
client to revalidate them.   This helps avoid the problem of a DFS junction
looking like a directory (rather than a submount to a different share) and thus
us not following the DFS referral.  Some of the other types of common
reparse points, such as junctions, are probably best considered as empty
directories, if a remote client can not follow them.

You might try a more recent kernel to see if any of your backup problems
are avoided by moving to 3.11 since it includes this fix

commit 2a2c41c07c710f2c1afe3748bdde40db9ea9d9e6
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Tue Jun 25 01:32:17 2013 -0500

    revalidate directories instiantiated via FIND_* in order to handle DFS refer



>> Here's my /etc/fstab entry:
>>
>> //192.168.185.24/C$ /mnt/windows/matt   cifs //noperm,ro,ignorecase,credentials=/root/smb_auth.txt 0 0
>>
>> Contents of /root/smb_auth.txt:
>> # cat /root/smb_auth.txt
>> username=WindowsUsername
>> password=WindowsPassword
>> domain=WindowsDomain
>>
>> Running the mount command:
>>
>> # mount -v matt
>> domain=WindowsDomain
>> mount.cifs kernel mount options:
>> ip=192.168.185.24,unc=\\192.168.185.24\C$,noperm,ignorecase,credentials=/root/smb_auth.txt,ver=1,user=WindowsUsername,domain=WindowsDomain,pass=********
>>
>> Contents of /proc/mounts after being mounted:
>>
>> # cat /proc/mounts | grep matt
>> //192.168.185.24/C$/ /mnt/windows/matt cifs ro,relatime,sec=ntlm,unc=\\192.168.185.24\C$,username=WindowsUser,domain=WindowsDomain,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.185.24,file_mode=0755,dir_mode=0755,nocase,serverino,noperm,rsize=16384,wsize=65536 0 0



-- 
Thanks,

Steve
