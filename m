From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 15:21:12 -0500
Message-ID: <CAH2r5mvM4_FjfvNcjdxeU73oZ7uO4r0CYKJ6MXORjERMFr=26w@mail.gmail.com>
References: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
	<20130515193600.GA318@lenny.home.zabbo.net>
	<CAH2r5mtA54fM-M1X7MS0FNeuXFh91UoarJ5QiKTk=vdSXHWFHg@mail.gmail.com>
	<20130515201614.24668.83788@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
To: Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130515201614.24668.83788-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 15, 2013 at 3:16 PM, Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org> wrote:
> Quoting Steve French (2013-05-15 16:08:16)
>> On Wed, May 15, 2013 at 2:36 PM, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Wed, May 15, 2013 at 12:50:13PM -0500, Steve French wrote:
>> >> Doesn't the new syscall have to invalidate the page cache pages that
>> >> the server is about to overwrite as btrfs does with the following line
>> >> in fs/btrfs/ioctl.c
>> >>
>> >>       truncate_inode_pages_range(&inode->i_data, destoff,
>> >>                                  PAGE_CACHE_ALIGN(destoff + len) - 1);
>> >
>> > The file_operations ->copy_range implementation is responsible for this,
>> > yeah, similar to ->write being responsible for invalidating around
>> > O_DIRECT writes.
>> >
>> >> (and doesn't truncate_inode_pages_range handle page cache alignment
>> >> anyway
>> >
>> > No, it bugs if given an end offset that isn't page aligned:
>> >
>> >         BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
>> >
>> > Lukas is working on a patch series to fix this:
>> >
>> >   http://marc.info/?l=linux-fsdevel&m=136854986101843&w=2
>> >
>> >> - and also why did btrfs use truncate_inode_pages_range instead
>> >> of invalidate?)
>> >
>> > I'm not sure.  Maybe they can have racing dirty pages and want them
>> > thrown away rather than having invalidation fail?
>
> truncate_inode_pages_range ends with invalidate.  It just locks the page
> first and makes sure to wait for writeback if it was already in
> progress.

Does

     truncate_inode_pages_range(&inode->i_data, destoff,
                            PAGE_CACHE_ALIGN(destoff + len) - 1);


I also am worried about what does:

1) writing out data from start of previous page up to destoff (if
destoff not page aligned, and first page dirty)
2) writing out data from dest+len through end of page (if destoff not
page aligned, and last page dirty)

before tossing first through last page out


-- 
Thanks,

Steve
