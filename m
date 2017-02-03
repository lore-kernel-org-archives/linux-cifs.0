From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH 04/24] fs: Provide infrastructure for dynamic BDIs in
 filesystems
Date: Fri, 3 Feb 2017 10:31:56 -0800
Message-ID: <20170203183155.GA30842@localhost.localdomain>
References: <20170202173422.3240-1-jack@suse.cz>
 <20170202173422.3240-5-jack@suse.cz>
 <20170202192827.GF6550@localhost.localdomain>
 <20170203135042.GB5844@quack2.suse.cz>
Reply-To: bo.li.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codalist@TELEMANN.coda.cs.cmu.edu, linux-block@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, cluster-devel@redhat.com,
 linux-mtd@lists.infradead.org, osd-dev@open-osd.org,
 linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 ceph-devel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
 linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org,
 lustre-devel@lists.lustre.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170203135042.GB5844@quack2.suse.cz>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Feb 03, 2017 at 02:50:42PM +0100, Jan Kara wrote:
> On Thu 02-02-17 11:28:27, Liu Bo wrote:
> > Hi,
> > 
> > On Thu, Feb 02, 2017 at 06:34:02PM +0100, Jan Kara wrote:
> > > Provide helper functions for setting up dynamically allocated
> > > backing_dev_info structures for filesystems and cleaning them up on
> > > superblock destruction.
> > 
> > Just one concern, will this cause problems for multiple superblock cases
> > like nfs with nosharecache?
> 
> Can you ellaborate a bit? I've looked for a while what nfs with
> nosharecache does but I didn't see how it would influence anything with
> bdis...

Oh, I missed that bdi_seq was static, then it should be fine.

(I was worried about that nfs with nosharecache would have multiple
superblocks and if each superblock has a bdi using the same bdi name,
nfs-xx.)

Thanks for the reply.

Thanks,

-liubo

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
