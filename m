From: <a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org>
Subject: Re: filenames with special chars and posix path caps enabled -
 regression?
Date: Mon, 15 Aug 2016 10:43:01 +0100
Message-ID: <20160815104301.7d3ac8c9@alice.paese.meraviglie>
References: <20160720164341.1c3a518b@alice.paese.meraviglie>
	<CAH2r5mtR5u+3XtGPcL8MrXgQanB6YjCHDA9PmOo2w+sJgvpdJg@mail.gmail.com>
	<20160720173448.6d079f3c@alice.paese.meraviglie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720173448.6d079f3c-73YhDmpz84Aw+Ft/lRvqTukuxxdDoHgO@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


On Wed, 20 Jul 2016 17:34:48 +0100, <a.biardi-IWqWACnzNjyonA0d6jMUrA@public.gmane.org> wrote:

> Thanks for the quick response; on 4.0.9 I get:
> 
> root@darkstar:~# grep cifs /proc/mounts
> //localhost/shared /mnt cifs
> rw,relatime,vers=1.0,cache=strict,username=user,domain=MYSERVER,uid=0,noforceuid,gid=0,noforcegid,addr=127.0.0.1,unix,posixpaths,serverino,acl,rsize=1048576,wsize=65536,actimeo=1
> 0 0
> 
> [...]

Resurrecting this thread from a few weeks ago.. I'm happy to start
working on a patch if somebody can confirm this is indeed a regression,
and perhaps points me in the right direction?

Andrea.
