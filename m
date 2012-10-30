From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 05/10] vfs: pass data to alloc_inode super operation
Date: Tue, 30 Oct 2012 21:17:01 +0000
Message-ID: <20121030211701.GC2616@ZenIV.linux.org.uk>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
 <1351628084-29358-8-git-send-email-jmoyer@redhat.com>
 <20121030205142.GB2616@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Chris Mason <chris.mason@fusionio.com>,
	Steve French <sfrench@samba.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	ocfs2-devel@oss.oracle.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121030205142.GB2616@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Oct 30, 2012 at 08:51:42PM +0000, Al Viro wrote:
> On Tue, Oct 30, 2012 at 04:14:39PM -0400, Jeff Moyer wrote:
> > This patch passes a data pointer along to the alloc_inode
> > super_operations function.  The value will initially be used by
> > bdev_alloc_inode to allocate the bdev_inode on the same numa
> > node as the device to which it is tied.
> 
> Yecchhh...
> 
> > -static struct inode *bdev_alloc_inode(struct super_block *sb)
> > +static struct inode *bdev_alloc_inode(struct super_block *sb, void *data)
> >  {
> > -	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
> > +	struct bdev_inode *ei;
> > +	int partno;
> > +	int node;
> > +
> > +	if (data) {
> > +		struct gendisk *disk;
> > +		dev_t dev = *(dev_t *)data;
> > +		disk = get_gendisk(dev, &partno);
> > +		node = disk->node_id;

BTW, speaking of other reasons this is FUBAR - mknod a block device node
for something that doesn't exist and try to open it.  struct block_device
lifetime is not limited to that of struct gendisk; it can be allocated
before gendisk is there.  Moreover, with static /dev and demand-loaded
modules this will be the normal scenario.

IOW, this is completely misguided.
