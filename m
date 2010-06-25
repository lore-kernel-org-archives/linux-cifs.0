From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index
 objects and register them
Date: Fri, 25 Jun 2010 18:14:16 +0530
Message-ID: <4C24A4A0.90408@suse.de>
References: <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes> <9720.1277312290@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9720.1277312290-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/23/2010 10:28 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> Define superblock-level cache index objects (managed by cifsTconInfo
>> structs).  Each superblock object is created in a server-level index object
>> and in itself an index into which inode-level objects are inserted.
>>
>> Currently, the superblock objects are keyed by sharename.
> 
> Seems reasonable.  Is there any way you can check that the share you are
> looking at on a server is the same as the last time you looked?  Can you

Good point.

I thought of using TID (Tree identifier; a unique ID for a resource in
use by client) along with sharename. But, Server is free to reuse them
when the tree connection closes and does not guarantee the same Tid for
a particular resource across tree connections.

Also, considering the UNC name of the resource (//server/share) may not
be a good idea too as the cache will not be used when for e.g. IPaddress
is used to mount.

So, if a server does something like this:
   - export a share 'foo' (original server path: /export/vol1/foo)
   - client mounts and uses it
   - server unexports the share 'foo'
   - server exports 'foo' (original sever path: /export/vol2/foo)

we have a bit of problem..

> validate the root directory of the share in some way?
> 

I don't know if there is a way to do this.

Thanks,


-- 
Suresh Jayaraman
