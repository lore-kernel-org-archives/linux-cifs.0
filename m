From: Chris Mason <chris.mason@fusionio.com>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 16:16:14 -0400
Message-ID: <20130515201614.24668.83788@localhost.localdomain>
References: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
 <20130515193600.GA318@lenny.home.zabbo.net>
 <CAH2r5mtA54fM-M1X7MS0FNeuXFh91UoarJ5QiKTk=vdSXHWFHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"J. Bruce Fields" <bfields@fieldses.org>
To: Steve French <smfrench@gmail.com>, Zach Brown <zab@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mtA54fM-M1X7MS0FNeuXFh91UoarJ5QiKTk=vdSXHWFHg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Quoting Steve French (2013-05-15 16:08:16)
> On Wed, May 15, 2013 at 2:36 PM, Zach Brown <zab@redhat.com> wrote:
> > On Wed, May 15, 2013 at 12:50:13PM -0500, Steve French wrote:
> >> Doesn't the new syscall have to invalidate the page cache pages that
> >> the server is about to overwrite as btrfs does with the following line
> >> in fs/btrfs/ioctl.c
> >>
> >>       truncate_inode_pages_range(&inode->i_data, destoff,
> >>                                  PAGE_CACHE_ALIGN(destoff + len) - 1);
> >
> > The file_operations ->copy_range implementation is responsible for this,
> > yeah, similar to ->write being responsible for invalidating around
> > O_DIRECT writes.
> >
> >> (and doesn't truncate_inode_pages_range handle page cache alignment
> >> anyway
> >
> > No, it bugs if given an end offset that isn't page aligned:
> >
> >         BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
> >
> > Lukas is working on a patch series to fix this:
> >
> >   http://marc.info/?l=linux-fsdevel&m=136854986101843&w=2
> >
> >> - and also why did btrfs use truncate_inode_pages_range instead
> >> of invalidate?)
> >
> > I'm not sure.  Maybe they can have racing dirty pages and want them
> > thrown away rather than having invalidation fail?

truncate_inode_pages_range ends with invalidate.  It just locks the page
first and makes sure to wait for writeback if it was already in
progress.

Looking at the btrfs side, I think we should add some locking on the
destination extents as well.

