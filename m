From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/25] fs: Provide infrastructure for dynamic BDIs in
 filesystems
Date: Wed, 12 Apr 2017 01:09:28 -0700
Message-ID: <20170412080928.GD9830@infradead.org>
References: <20170329105623.18241-1-jack@suse.cz>
 <20170329105623.18241-5-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org,
        Petr Vandrovec <petr@vandrovec.name>,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        osd-dev@open-osd.org, codalist@coda.cs.cmu.edu,
        linux-afs@lists.infradead.org, ecryptfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        lustre-devel@lists.lustre.org
To: Jan Kara <jack@suse.cz>
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170329105623.18241-5-jack@suse.cz>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> +	if (sb->s_iflags & SB_I_DYNBDI) {
> +		bdi_put(sb->s_bdi);
> +		sb->s_bdi = &noop_backing_dev_info;

At some point I'd really like to get rid of noop_backing_dev_info and
have a NULL here..

Otherwise this looks fine..

Reviewed-by: Christoph Hellwig <hch@lst.de>
