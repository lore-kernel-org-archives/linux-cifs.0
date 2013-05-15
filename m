From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 15:08:16 -0500
Message-ID: <CAH2r5mtA54fM-M1X7MS0FNeuXFh91UoarJ5QiKTk=vdSXHWFHg@mail.gmail.com>
References: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
	<20130515193600.GA318@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130515193600.GA318-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 15, 2013 at 2:36 PM, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, May 15, 2013 at 12:50:13PM -0500, Steve French wrote:
>> Doesn't the new syscall have to invalidate the page cache pages that
>> the server is about to overwrite as btrfs does with the following line
>> in fs/btrfs/ioctl.c
>>
>>       truncate_inode_pages_range(&inode->i_data, destoff,
>>                                  PAGE_CACHE_ALIGN(destoff + len) - 1);
>
> The file_operations ->copy_range implementation is responsible for this,
> yeah, similar to ->write being responsible for invalidating around
> O_DIRECT writes.
>
>> (and doesn't truncate_inode_pages_range handle page cache alignment
>> anyway
>
> No, it bugs if given an end offset that isn't page aligned:
>
>         BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
>
> Lukas is working on a patch series to fix this:
>
>   http://marc.info/?l=linux-fsdevel&m=136854986101843&w=2
>
>> - and also why did btrfs use truncate_inode_pages_range instead
>> of invalidate?)
>
> I'm not sure.  Maybe they can have racing dirty pages and want them
> thrown away rather than having invalidation fail?

Ideally cifs (and presumably) nfs would do a flush of the beginning of
the first page (before source offset) and/or the end of the last page
of the range (after target offset) if dirty (to send it to the server
before the copy) if they are not writing the complete page out, and
then toss the pages (including the first and last partial pages) from
the page cache.  Is there a good fs example for code for this?


>> Does nfs client ever have the case where two different superblocks map
>> to the same nfs export (and thus the check below is restricting the
>> ability to do server side copy)?
>>
>> +     if (inode_in->i_sb != inode_out->i_sb ||
>> +         file_in->f_path.mnt != file_out->f_path.mnt)
>> +             return -EXDEV;
>
> Ah, yes, thanks for bringing this up.  This check was brought over from
> the btrfs ioctl code into the core just to make our lives less
> complicated in the short term.
>
> We may well want to push this test down into the ->copy_range methods so
> that some can support these cross-sb/mnt copies.  I'm not sure how the
> nfs client manages all these relationships, but yes, what you suggest
> seems plausible.
>
> There's also the long term possibility of using the nfs copy op to
> offload copying between files on different servers.  The spec talks
> about this quite a bit (how the client informs both servers, whether to
> use nfs between the servers or some server-specific protocol), but this
> certainly isn't my priority.
>
> I figure we can worry about this once we have a ->copy_range method that
> can copy files like this safely and are stopped by the test.  It's easy
> enough to move the test around.
>
>> I am working on cifs client patches for the ioctl, and the new syscall
>> also looks pretty easy.   Some popular cifs servers (like Windows)
>> have supported smb/cifs copy offload for many, many years - and now
>> Samba with the support that David Disseldorp added for the clone range
>> ioctl has been supporting copychunk (server side copy from Windows to
>> Samba) so about time to finish the cifs client equivalent.
>
> Cool, let me know if anything strange pops up.
>
> - z



-- 
Thanks,

Steve
