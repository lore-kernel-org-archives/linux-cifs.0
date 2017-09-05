From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [Patch v2 00/19] CIFS: Implement SMBDirect
Date: Tue, 5 Sep 2017 11:30:50 -0500
Message-ID: <001b01d32664$5640f8c0$02c2ea40$@opengridcomputing.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com> <01ff01d31ab1$ca836a60$5f8a3f20$@opengridcomputing.com> <MWHPR21MB019081F64C50E08043286EE3CE870@MWHPR21MB0190.namprd21.prod.outlook.com> <027d01d31ab7$85adbed0$91093c70$@opengridcomputing.com> <MWHPR21MB0190AD423095EEA25CA6CD81CE870@MWHPR21MB0190.namprd21.prod.outlook.com> <MWHPR21MB0190050F3699CDF6F52B51A2CE9F0@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Venkatesh Pottem'" <venkatesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
To: "'Long Li'" <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "'Steve French'" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "'Christoph Hellwig'" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        "'Tom Talpey'" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "'Matthew Wilcox'" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MWHPR21MB0190050F3699CDF6F52B51A2CE9F0-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

> I have put the patch v3 in the following location:
> https://github.com/longlimsft/linux-next/tree/patch_v3
> 
> I will be sending it out soon. Please give it a try.
> 

Hey Long, how do I request a CIFS RDMA mount from the Linux client?  Is
there a mount.cifs option?  If so, where can I get the mount.cifs code that
enables this?  Or is there some other way? 

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
