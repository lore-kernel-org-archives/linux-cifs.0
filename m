From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/25 v3] fs: Convert all embedded bdis into separate ones
Date: Thu, 20 Apr 2017 12:11:16 -0600
Message-ID: <20170420181115.GA22378@kernel.dk>
References: <20170412102449.16901-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        Petr Vandrovec <petr@vandrovec.name>,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        osd-dev@open-osd.org, codalist@coda.cs.cmu.edu,
        linux-afs@lists.infradead.org, ecryptfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        lustre-devel@lists.lustre.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170412102449.16901-1-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Apr 12 2017, Jan Kara wrote:
> Hello,
> 
> this is the third revision of the patch series which converts all embedded
> occurences of struct backing_dev_info to use standalone dynamically allocated
> structures. This makes bdi handling unified across all bdi users and generally
> removes some boilerplate code from filesystems setting up their own bdi. It
> also allows us to remove some code from generic bdi implementation.
> 
> The patches were only compile-tested for most filesystems (I've tested
> mounting only for NFS & btrfs) so fs maintainers please have a look whether
> the changes look sound to you.
> 
> This series is based on top of bdi fixes that were merged into linux-block
> git tree into for-next branch. I have pushed out the result as a branch to
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git bdi
> 
> Since all patches got reviewed by Christoph, can you please pick them up Jens?
> Thanks!

Yep, picked up for 4.12. Thanks Jan!

-- 
Jens Axboe
