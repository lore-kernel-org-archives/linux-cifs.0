From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 05/10] vfs: pass data to alloc_inode super operation
Date: Wed, 31 Oct 2012 09:22:51 -0400
Message-ID: <x49liemixn8.fsf@segfault.boston.devel.redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
	<1351628084-29358-8-git-send-email-jmoyer@redhat.com>
	<20121030205142.GB2616@ZenIV.linux.org.uk>
	<20121030211701.GC2616@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>,
	Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>,
	Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121030211701.GC2616-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> (Al Viro's message of
	"Tue, 30 Oct 2012 21:17:01 +0000")
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> writes:

> On Tue, Oct 30, 2012 at 08:51:42PM +0000, Al Viro wrote:
>> On Tue, Oct 30, 2012 at 04:14:39PM -0400, Jeff Moyer wrote:
>> > This patch passes a data pointer along to the alloc_inode
>> > super_operations function.  The value will initially be used by
>> > bdev_alloc_inode to allocate the bdev_inode on the same numa
>> > node as the device to which it is tied.
>> 
>> Yecchhh...
>> 
>> > -static struct inode *bdev_alloc_inode(struct super_block *sb)
>> > +static struct inode *bdev_alloc_inode(struct super_block *sb, void *data)
>> >  {
>> > -	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
>> > +	struct bdev_inode *ei;
>> > +	int partno;
>> > +	int node;
>> > +
>> > +	if (data) {
>> > +		struct gendisk *disk;
>> > +		dev_t dev = *(dev_t *)data;
>> > +		disk = get_gendisk(dev, &partno);
>> > +		node = disk->node_id;
>
> Oh, _lovely_.  Such a stunningly elegant idea.  And why not pass the
> sodding node_id directly, if I may ask?

struct block_device *bdget(dev_t dev)
{
...
        inode = iget5_locked(blockdev_superblock, hash(dev),
                        bdev_test, bdev_set, &dev);

The device is used by bdev_test and bdev_set.

> Take that crap out and don't bring it back.  And consider this kludge NAKed
> once and forever.  It's unspeakably ugly, even if it didn't break just about
> every fs out there (you do realize that almost all of them have ->alloc_inode(),
> pdon't you?  Use grep and see).

Oof.  I was using cscope and it didn't show all callers.

> BTW, speaking of other reasons this is FUBAR - mknod a block device node
> for something that doesn't exist and try to open it.  struct block_device
> lifetime is not limited to that of struct gendisk; it can be allocated
> before gendisk is there.  Moreover, with static /dev and demand-loaded
> modules this will be the normal scenario.
>
> IOW, this is completely misguided.

OK, thanks for the review, Al, it's greatly appreciated.  Do you have a
suggestion on how I might achieve this in a way that would be
acceptable?  I'm not too fond of the idea of reallocating the inode when
the device does appear.  I'll give it some more thought.

Again, thanks for taking a look.

Cheers,
Jeff
