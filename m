From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/09] Implement direct user I/O interfaces for RDMA
Date: Thu, 17 May 2018 23:42:45 -0700
Message-ID: <20180518064245.GA9425@infradead.org>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <d5eaf67d-4b0d-9206-a016-67cb3b5a0df8@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
To: Tom Talpey <tom@talpey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d5eaf67d-4b0d-9206-a016-67cb3b5a0df8@talpey.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, May 17, 2018 at 07:10:04PM -0400, Tom Talpey wrote:
> What's the security risk? This type of direct i/o behavior is not
> uncommon, and can certainly be made safe, using the appropriate
> memory registration and protection domains. Any risk needs to be
> stated explicitly, and mitigation provided, or at least described.

And in fact it is the same behavior you'll see on NFS over RDMA, or
a block device or any local fs over SRP/iSER/NVMe over Fabrics..
