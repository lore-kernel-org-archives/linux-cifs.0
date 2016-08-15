From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: filenames with special chars and posix path caps enabled - regression?
Date: Mon, 15 Aug 2016 10:48:56 -0500
Message-ID: <CAH2r5mtj0VBQkTrS5OQ5N5m5n7gjt_ottCShadtxR8tb-_JbqQ@mail.gmail.com>
References: <20160720164341.1c3a518b@alice.paese.meraviglie>
 <CAH2r5mtR5u+3XtGPcL8MrXgQanB6YjCHDA9PmOo2w+sJgvpdJg@mail.gmail.com>
 <20160720173448.6d079f3c@alice.paese.meraviglie> <20160815104301.7d3ac8c9@alice.paese.meraviglie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160815104301.7d3ac8c9-73YhDmpz84Aw+Ft/lRvqTukuxxdDoHgO@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The issue seems to be that the mount options are different between the
two.   Quick summary:

CIFS Unix/POSIX Extensions (which Samba and the Linux kernel support)
includes support for all valid posix characters in path names
(including those which Windows considers reserved ":"  and "\" and "?"
and "*" for example).

When mounting with newer dialects (vers=2.1 or vers=3 to get SMB2.1 or
SMB3 support for example), or when mounting with CIFS to servers like
Windows, the protocol dialect does not support these reserved
characters, so by default we mount with posixpath mapping enabled to
support mapping (posixpaths) of reserved characters to the SFM
reserved range (same as Windows Services for Mac and the Mac itself
does).  The result is that you can create and read the filenames
remotely and they look fine but on the Samba server itself the
reserved character will look strange since it is remapped.

You could turn off posixpaths on mount (noposixpaths) on your cifs
mount to see if this fixes it, but the key will be looking at the
mount options that were passed in to the kernel so we can see if you
are mounting with posixpath mapping (which would force posixpaths to
be mapped even though the server would have supported them without
mapping)

On Mon, Aug 15, 2016 at 4:43 AM,  <a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org> wrote:
>
> On Wed, 20 Jul 2016 17:34:48 +0100, <a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org> wrote:
>
>> Thanks for the quick response; on 4.0.9 I get:
>>
>> root@darkstar:~# grep cifs /proc/mounts
>> //localhost/shared /mnt cifs
>> rw,relatime,vers=1.0,cache=strict,username=user,domain=MYSERVER,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,unix,posixpaths,serverino,acl,rsize=1048576,wsize=65536,actimeo=1
>> 0 0
>>
>> [...]
>
> Resurrecting this thread from a few weeks ago.. I'm happy to start
> working on a patch if somebody can confirm this is indeed a regression,
> and perhaps points me in the right direction?
>
> Andrea.



-- 
Thanks,

Steve
