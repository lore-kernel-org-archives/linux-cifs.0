From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Mon, 21 Aug 2017 14:15:03 -0500
Message-ID: <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Long Li'" <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: "'Long Li'" <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>,
        "'Steve French'" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "'Christoph Hellwig'" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        "'Tom Talpey'" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "'Matthew Wilcox'" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

> 
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> Starting with SMB2 dialect 3.0, Microsoft introduced SMBDirect transport
protocol
> for transferring upper layer (SMB2) payload over RDMA via Infiniband, RoCE or
> iWARP. The prococol is published in [MS-SMBD] (https://msdn.microsoft.com/en-
> us/library/hh536346.aspx).
> 
> The patch v2 added RDMA read/write via memory registration, and addressed
> feedbacks on v1.
> 

Hey Long,

What testing have you done with this on the various rdma transports?  Does it
work over IB, RoCE, and iWARP providers?

Thanks,

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
