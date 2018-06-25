From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [Patch v2 02/15] CIFS: Add support for direct pages in rdata
Date: Mon, 25 Jun 2018 15:01:32 -0600
Message-ID: <20180625210132.GB5381@ziepe.ca>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-3-longli@linuxonhyperv.com>
 <67b8afe7-f5e0-b36a-fcc1-87f1ae08eaa4@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
To: Tom Talpey <tom@talpey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <67b8afe7-f5e0-b36a-fcc1-87f1ae08eaa4@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Jun 23, 2018 at 09:50:20PM -0400, Tom Talpey wrote:
> On 5/30/2018 3:47 PM, Long Li wrote:
> >From: Long Li <longli@microsoft.com>
> >
> >Add a function to allocate rdata without allocating pages for data
> >transfer. This gives the caller an option to pass a number of pages
> >that point to the data buffer.
> >
> >rdata is still reponsible for free those pages after it's done.
> 
> "Caller" is still responsible? Or is the rdata somehow freeing itself
> via another mechanism?
> 
> >
> >Signed-off-by: Long Li <longli@microsoft.com>
> >  fs/cifs/cifsglob.h |  2 +-
> >  fs/cifs/file.c     | 23 ++++++++++++++++++++---
> >  2 files changed, 21 insertions(+), 4 deletions(-)
> >
> >diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >index 8d16c3e..56864a87 100644
> >+++ b/fs/cifs/cifsglob.h
> >@@ -1179,7 +1179,7 @@ struct cifs_readdata {
> >  	unsigned int			tailsz;
> >  	unsigned int			credits;
> >  	unsigned int			nr_pages;
> >-	struct page			*pages[];
> >+	struct page			**pages;
> 
> Technically speaking, these are syntactically equivalent. It may not
> be worth changing this historic definition.

[] is a C99 'flex array', it has a different allocation behavior than
** and is not interchangeable..

Jason
