From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/09] Implement direct user I/O interfaces for RDMA
Date: Thu, 17 May 2018 23:44:00 -0700
Message-ID: <20180518064400.GB9425@infradead.org>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <d5eaf67d-4b0d-9206-a016-67cb3b5a0df8@talpey.com>
 <MWHPR2101MB0729BFF8F0A397805087C3A4CE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <MWHPR2101MB0729BFF8F0A397805087C3A4CE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, May 18, 2018 at 06:03:09AM +0000, Long Li wrote:
> I also want to point out that, I choose to implement .read_iter and .write_iter from file_operations to implement direct I/O (CIFS is already doing this for O_DIRECT, so following this code path will avoid a big mess up).  The ideal choice is to implement .direct_IO from address_space_operations that I think eventually we want to move to.

No, the direct_IO address space operation is the mess.  We're moving
away from it.
