From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [[PATCH v1] 15/37] [CIFS] SMBD: Post a SMBD data transfer
 message with data payload
Date: Wed, 30 Aug 2017 01:51:38 -0700
Message-ID: <20170830085138.GA4761@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-16-git-send-email-longli@exchange.microsoft.com>
 <20170813102345.GG17287@infradead.org>
 <MWHPR21MB0190E9E8303EADE6A6C84D90CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <MWHPR21MB0190E9E8303EADE6A6C84D90CE9C0@MWHPR21MB0190.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Aug 30, 2017 at 02:17:56AM +0000, Long Li wrote:
> I partially addressed this issue in the V3 patch. Most of the duplicate
> code on sending path is merged.
> 
> The difficulty with translating the buffer to pages is that: I don't
> know how many pages will be translated, and how many struct page I need
> to allocate in advance to hold them. I try to avoid memory allocation
> in the I/O path as much as possible. So I keep two functions of 
> sending data: one for buffer and one for pages.

You do: you'll always need speace for  (len + PAGE_SIZE - 1) >> PAGE_SIZE
pages.

That being said: what callers even send you buffers?  In general we
should aim to work with pages for all allocations that aren't tiny.
