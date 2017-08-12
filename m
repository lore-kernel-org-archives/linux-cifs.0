From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [[PATCH v1] 02/37] [CIFS] SMBD: Add structure for SMBD transport
Date: Sat, 12 Aug 2017 11:49:42 -0700
Message-ID: <20170812184942.GA26295@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-3-git-send-email-longli@exchange.microsoft.com>
 <9632c208-d6a5-2c47-b583-274d046d97bd@samba.org>
 <MWHPR21MB019089DF6B0B68C5C2F4FE56CE8E0@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <MWHPR21MB019089DF6B0B68C5C2F4FE56CE8E0-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Aug 12, 2017 at 08:32:48AM +0000, Long Li via samba-technical wrote:
> I think it is possible to separate the common code that implements the SMBDirect transport. There are some challenges to reuse the same code for both kernel and user spaces.
> 1. Kernel mode RDMA verbs are similar but different to user-mode ones.
> 2. Some RDMA features (e.g Fast Registration Work Request) are not available in user-mode.
> 3. Locking and synchronization mechanism is different
> 4. Memory management is different.
> 5. Process creation/scheduling and data sharing between processes are different, and there is no user-mode code running in interrupt/softirq.
> 
> Those needs to be abstracted through a layer, the rest of the code can be shared. I can work on this after patch set is reviewed.

NAK - code with those sort of obsfucation layer will be rejected
for kernel inclusion - don't add it.
