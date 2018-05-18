From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 09/09] Introduce cache=rdma moutning option
Date: Fri, 18 May 2018 00:26:31 -0700
Message-ID: <20180518072631.GA19250@infradead.org>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <20180518002214.5657-10-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
To: longli@microsoft.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180518002214.5657-10-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, May 17, 2018 at 05:22:14PM -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> When cache=rdma is enabled on mount options, CIFS do not allocate internal data
> buffer pages for I/O, data is read/writen directly to user memory via RDMA.

I don't think this should be an option.  For direct I/O without signing
or encryption CIFS should always use get_user_pages, with or without
RDMA.
