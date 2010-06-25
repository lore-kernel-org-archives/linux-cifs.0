From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
 register them
Date: Fri, 25 Jun 2010 18:20:14 +0530
Message-ID: <4C24A606.5040001@suse.de>
References: <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9822.1277312573-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/23/2010 10:32 PM, David Howells wrote:
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> Define inode-level data storage objects (managed by cifsInodeInfo structs).
>> Each inode-level object is created in a super-block level object and is
>> itself a data storage object in to which pages from the inode are stored.
>>
>> The inode object is keyed by UniqueId. The coherency data being used is
>> LastWriteTime and the file size.
> 
> Isn't there a file creation time too?

I think the creation time is currently being ignored as we won't be able
to accomodate in POSIX stat struct.

> I take it you don't support caching on files that are open for writing at this
> time?
> 

Yes.


-- 
Suresh Jayaraman
