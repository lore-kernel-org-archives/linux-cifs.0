From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [[PATCH v1] 12/37] [CIFS] SMBD: Handle send completion from CQ
Date: Sun, 13 Aug 2017 03:19:45 -0700
Message-ID: <20170813101945.GE17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-13-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>
To: Long Li <longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-13-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

You seem to be doing memory allocations and frees for every packet on
the write.  At least for other RDMA protocols that would have been
a major performance issue.  

Do you have any performance numbers and/or profiles of the code?
